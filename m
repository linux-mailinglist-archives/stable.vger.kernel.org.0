Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF5AE6CF958
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 04:56:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229750AbjC3C42 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 22:56:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229755AbjC3C41 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 22:56:27 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE07D3C26;
        Wed, 29 Mar 2023 19:56:17 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id m16so13100645qvi.12;
        Wed, 29 Mar 2023 19:56:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680144977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8X2YSVby3eARSC5IBWjikSWO8skTq18zdSjFOS2gB6I=;
        b=RPWn/wB+SOLnUxOcLQLIKnFvdFrJ/Q7oRalBf/lJRKKJ8998AG/120Zt20hEkFjXMK
         wGLEd/pLUhdwnGBTficsp3sknQRQE18AK+bFlxbHkD9teAzku7+dTDwVW9l2/pOmO0O+
         JGyZbVwUWM7JxNm1/nb8HKZZnCQ5Su9urxE8Byl8Aruc/fK/VX5Qrdq4kze/+tH1qfLG
         S312kdeukWHPRJgAzcQlnQTKpFsyk75hSF5w2qh3ngQbhWzliFccrTyqr9Kg1SKqoKbo
         lxSZzgCX4BygCt9N6GN6+78SHoBVlUHP4/9OfZYhowFx4HSlTLZPj6dYlbW2dSpcZp/W
         xxUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680144977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8X2YSVby3eARSC5IBWjikSWO8skTq18zdSjFOS2gB6I=;
        b=BJZpZz1cZjEmJy0LoFPcoacccrhsY5lBHGd9Sjvxs1KOx7JeKd+JjO0BHbiI1HoV0s
         yyVTK9inqBKuHpxNLc18AwxhrFRnaq+90J3hvxvpFADfov/8zFiFXqnNIUCCu1rWBGOF
         NifGtcPIRtCRAoptLWfcrvMctVWZBDb402ldTuI2syUpJ2ks0r4ZBmZdkD9jk/hHVoad
         6qV/0+WEpGfVeNKGID32qltuqh5eek34BnTrGhRGmr4z1p/Hjj+GMliaUEQp7XGSTuj6
         nc9OmV2LOkg4DM6KzKHjnDVxcvXoBHrb0nE6qJJ91PnfpSihJ3nJCMFADW4qfx7pXFaY
         zmPA==
X-Gm-Message-State: AAQBX9ejaiIwMgGiRvthaoQJMDs1T3VpgCcMYaufoYuw6m71UMuxYBam
        9x/IKMkbn6Tp3v0HYvCy5Ag=
X-Google-Smtp-Source: AKy350ZDgR1/Z52yr2nflFcnv6/3LiGTO5DKz4Z0hYd9YkaWAchuq+IKfoBX+R9is/hQuJ+zi+01kA==
X-Received: by 2002:ad4:5c61:0:b0:5c9:422e:c7b9 with SMTP id i1-20020ad45c61000000b005c9422ec7b9mr39171311qvh.19.1680144977029;
        Wed, 29 Mar 2023 19:56:17 -0700 (PDT)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id a8-20020a0ce908000000b005dd8b9345a3sm5108719qvo.59.2023.03.29.19.56.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 19:56:16 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailauth.nyi.internal (Postfix) with ESMTP id B4DE627C0054;
        Wed, 29 Mar 2023 22:56:15 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 29 Mar 2023 22:56:15 -0400
X-ME-Sender: <xms:T_okZA6_fAKqbW5wicByn_U55I3RvSYD1HinI_0iYhHvzMrS2FQhSw>
    <xme:T_okZB4Joq_O45HF3y4d-uw7XokUpTj2WbRsMgRw8d7oWp_uy4coowSyjW-58dwe3
    3_2iAT4Q7vrjwnc6A>
X-ME-Received: <xmr:T_okZPctN7-nixS5SQZ9r8fEGULqZQsEqSAEaYLCcwRdx6uMtWVHSvnFLpG9TA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdehjedgieegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeeigeethfejvdfhudegtdevtefhleelffegteevtdelgfeugefhhffhteeg
    iefhheenucffohhmrghinheplhifnhdrnhgvthenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquhhnrdhfvg
    hngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:T_okZFLoYdTpwssuGuYv_32DhfWPm3BshK_nx6MJ1YKbYZ4wxqZKIw>
    <xmx:T_okZEJbRehIGY11Qy2ZGixI6pf6jq1OSgu-SJW3nB_ObqOCBgX4dQ>
    <xmx:T_okZGzDQxP8uaaoX2dtTRGClVrf1ltQFtkI5CQL2DUk2XLd-M3qew>
    <xmx:T_okZA_UWYqtzpmlbqF6s2t48Z9MHWHKRVPmdbhZi22CsnGF1jSnOA>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Mar 2023 22:56:15 -0400 (EDT)
Date:   Wed, 29 Mar 2023 19:55:32 -0700
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Dexuan Cui <decui@microsoft.com>
Cc:     quic_jhugo@quicinc.com, quic_carlv@quicinc.com, wei.liu@kernel.org,
        kys@microsoft.com, haiyangz@microsoft.com, sthemmin@microsoft.com,
        lpieralisi@kernel.org, bhelgaas@google.com,
        linux-hyperv@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, mikelley@microsoft.com,
        robh@kernel.org, kw@linux.com, helgaas@kernel.org,
        alex.williamson@redhat.com, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH v2] PCI: hv: Fix the definition of vector in
 hv_compose_msi_msg()
Message-ID: <ZCT6JEK/yGpKHVLn@boqun-archlinux>
References: <20221027205256.17678-1-decui@microsoft.com>
 <ZCTsPFb7dBj2IZmo@boqun-archlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCTsPFb7dBj2IZmo@boqun-archlinux>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 29, 2023 at 06:56:12PM -0700, Boqun Feng wrote:
> [Cc stable]
> 
> On Thu, Oct 27, 2022 at 01:52:56PM -0700, Dexuan Cui wrote:
> > The local variable 'vector' must be u32 rather than u8: see the
> > struct hv_msi_desc3.
> > 
> > 'vector_count' should be u16 rather than u8: see struct hv_msi_desc,
> > hv_msi_desc2 and hv_msi_desc3.
> > 
> 
> Dexuan, I think this patch should only be in 5.15, because...
> 

Sorry, I meant:

"this patch should also be backported in 5.15"

Regards,
Boqun

> > Fixes: a2bad844a67b ("PCI: hv: Fix interrupt mapping for multi-MSI")
> 
> ^^^ this commit is already in 5.15.y (commit id 92dcb50f7f09).
> 
> Upstream id e70af8d040d2b7904dca93d942ba23fb722e21b1
> Cc: <stable@vger.kernel.org> # 5.15.x
> 
> Regards,
> Boqun
> 
> > Signed-off-by: Dexuan Cui <decui@microsoft.com>
> > Cc: Jeffrey Hugo <quic_jhugo@quicinc.com>
> > Cc: Carl Vanderlip <quic_carlv@quicinc.com>
> > ---
> > 
> > v1 was posted here (sorry, I forgot to follow this up...):
> > https://lwn.net/ml/linux-kernel/20220815185505.7626-1-decui@microsoft.com/
> > 
> > Changes in v2:
> >   Added the explicit "(u8)" cast in hv_compose_msi_msg().
> >   Added and improved the comments.
> >   Fixed a typo in the subject in v1: s/definiton/definition
> > 
> >  drivers/pci/controller/pci-hyperv.c | 22 ++++++++++++++++------
> >  1 file changed, 16 insertions(+), 6 deletions(-)
> > 
> > diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
> > index e7c6f6629e7c..ba64284eaf9f 100644
> > --- a/drivers/pci/controller/pci-hyperv.c
> > +++ b/drivers/pci/controller/pci-hyperv.c
> > @@ -1614,7 +1614,7 @@ static void hv_pci_compose_compl(void *context, struct pci_response *resp,
> >  
> >  static u32 hv_compose_msi_req_v1(
> >  	struct pci_create_interrupt *int_pkt, const struct cpumask *affinity,
> > -	u32 slot, u8 vector, u8 vector_count)
> > +	u32 slot, u8 vector, u16 vector_count)
> >  {
> >  	int_pkt->message_type.type = PCI_CREATE_INTERRUPT_MESSAGE;
> >  	int_pkt->wslot.slot = slot;
> > @@ -1642,7 +1642,7 @@ static int hv_compose_msi_req_get_cpu(const struct cpumask *affinity)
> >  
> >  static u32 hv_compose_msi_req_v2(
> >  	struct pci_create_interrupt2 *int_pkt, const struct cpumask *affinity,
> > -	u32 slot, u8 vector, u8 vector_count)
> > +	u32 slot, u8 vector, u16 vector_count)
> >  {
> >  	int cpu;
> >  
> > @@ -1661,7 +1661,7 @@ static u32 hv_compose_msi_req_v2(
> >  
> >  static u32 hv_compose_msi_req_v3(
> >  	struct pci_create_interrupt3 *int_pkt, const struct cpumask *affinity,
> > -	u32 slot, u32 vector, u8 vector_count)
> > +	u32 slot, u32 vector, u16 vector_count)
> >  {
> >  	int cpu;
> >  
> > @@ -1701,7 +1701,12 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
> >  	struct compose_comp_ctxt comp;
> >  	struct tran_int_desc *int_desc;
> >  	struct msi_desc *msi_desc;
> > -	u8 vector, vector_count;
> > +	/*
> > +	 * vector_count should be u16: see hv_msi_desc, hv_msi_desc2
> > +	 * and hv_msi_desc3. vector must be u32: see hv_msi_desc3.
> > +	 */
> > +	u16 vector_count;
> > +	u32 vector;
> >  	struct {
> >  		struct pci_packet pci_pkt;
> >  		union {
> > @@ -1767,6 +1772,11 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
> >  		vector_count = 1;
> >  	}
> >  
> > +	/*
> > +	 * hv_compose_msi_req_v1 and v2 are for x86 only, meaning 'vector'
> > +	 * can't exceed u8. Cast 'vector' down to u8 for v1/v2 explicitly
> > +	 * for better readability.
> > +	 */
> >  	memset(&ctxt, 0, sizeof(ctxt));
> >  	init_completion(&comp.comp_pkt.host_event);
> >  	ctxt.pci_pkt.completion_func = hv_pci_compose_compl;
> > @@ -1777,7 +1787,7 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
> >  		size = hv_compose_msi_req_v1(&ctxt.int_pkts.v1,
> >  					dest,
> >  					hpdev->desc.win_slot.slot,
> > -					vector,
> > +					(u8)vector,
> >  					vector_count);
> >  		break;
> >  
> > @@ -1786,7 +1796,7 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
> >  		size = hv_compose_msi_req_v2(&ctxt.int_pkts.v2,
> >  					dest,
> >  					hpdev->desc.win_slot.slot,
> > -					vector,
> > +					(u8)vector,
> >  					vector_count);
> >  		break;
> >  
> > -- 
> > 2.25.1
> > 
