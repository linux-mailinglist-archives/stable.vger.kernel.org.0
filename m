Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB7426CF8F4
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 03:57:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbjC3B5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Mar 2023 21:57:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229816AbjC3B5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Mar 2023 21:57:09 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30DF8EC;
        Wed, 29 Mar 2023 18:56:58 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id jl13so13067842qvb.10;
        Wed, 29 Mar 2023 18:56:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680141417;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lbjGY3m7S6qGoSTvDHDrb9vkclrch2yCM0obwlF52w4=;
        b=DSCHGQJdaLDhs7zXQEUapeLSItyi3tVs1lzGb9+aEkuVP7Rc9xtfnr9g6yG46fQluW
         ST2Fk3UMFbl5jftxtzqQpe0na4WsF/gi0Ymd5g852oo2kP40ei/0I1k5U+C/+hzow/bg
         pQFO35yJyGAWYUHX7LoBrrLNCqwe8/cIj2c3rzA06eEaQ5pL6Vg/CUSSy13TbGRtHRSo
         ljybmXNGACh7YXnPOanplrp7vr27pvvwTNjJy1d9dRQRw4arAZgrVRG752739+Z/OJUI
         YKAqbUzNMPwf8975lYniMCBFfgdZn9+FPhlL+38j+uL7xC0CEFu53b98yiX/0V9NvgxK
         2omw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680141417;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:feedback-id:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lbjGY3m7S6qGoSTvDHDrb9vkclrch2yCM0obwlF52w4=;
        b=IBs02DfJQASHYPqxDeFA6NYz5iqhzHRLqwzkqYDWIWkjrek+noKS5kCruMUEIRiJ23
         mIVdbZqzP0NR5bgvhlJLAlHb23xQFT7pLm6wsHW6w+iCnuUnlll/G190wEVIX/CyqmLw
         4xVoIuKhfq8Q1oviplAjpIalzdkqJj8WEKzBolJDGU443SKZuZ3PKN6Ubs0OE0era84R
         ftHaSp+I+G1uhO4wTfU7GyoN5rxgJYV/SXH4kDEY3UAkEZG2RbqJePFvSq3MGclWXL84
         ATxxOHShZkHMR/gQQmAlCqkGeghnrdEGIgG45Daxz/Z9BqaMFtEkTaDztoQUPmw88pDE
         F7OQ==
X-Gm-Message-State: AAQBX9fELKgWndqQV7lF73t4VBTn/SvX/97oBWKHKw2MSA91rgMMtwBq
        YD4Nua5XTleYLeo+TIWxXLU=
X-Google-Smtp-Source: AKy350aHck463IEJMWltZlh+uS/YcpesvUKpvDyj25rUJxeqxULfKF0rgKdrO9IiNc4QW83/J7LZrw==
X-Received: by 2002:a05:6214:4017:b0:56e:961a:b454 with SMTP id kd23-20020a056214401700b0056e961ab454mr6034669qvb.21.1680141417261;
        Wed, 29 Mar 2023 18:56:57 -0700 (PDT)
Received: from auth2-smtp.messagingengine.com (auth2-smtp.messagingengine.com. [66.111.4.228])
        by smtp.gmail.com with ESMTPSA id y3-20020a37f603000000b0074382b756c2sm18995913qkj.14.2023.03.29.18.56.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Mar 2023 18:56:56 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailauth.nyi.internal (Postfix) with ESMTP id B15CA27C005A;
        Wed, 29 Mar 2023 21:56:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 29 Mar 2023 21:56:55 -0400
X-ME-Sender: <xms:Z-wkZKW409Far7TP2uNe1tETzfuqHMrgTVF0W5s1Mzc4392rY5P3yg>
    <xme:Z-wkZGn4GyVKaNsd_192iYyOsfBZKZNHJAUHpvmiDiybAUbTtP2xfybWREu9ZHpew
    VFZXfp-NXkcS3-6iw>
X-ME-Received: <xmr:Z-wkZOZyQ_QUNFB_QPJf3JMOgsLjxLiuKICUKRYa41nPzJ2oMi8ZlkTTYDGx2g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdehjedghedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehoqhhu
    nhcuhfgvnhhguceosghoqhhunhdrfhgvnhhgsehgmhgrihhlrdgtohhmqeenucggtffrrg
    htthgvrhhnpeeigeethfejvdfhudegtdevtefhleelffegteevtdelgfeugefhhffhteeg
    iefhheenucffohhmrghinheplhifnhdrnhgvthenucevlhhushhtvghrufhiiigvpedtne
    curfgrrhgrmhepmhgrihhlfhhrohhmpegsohhquhhnodhmvghsmhhtphgruhhthhhpvghr
    shhonhgrlhhithihqdeiledvgeehtdeigedqudejjeekheehhedvqdgsohhquhhnrdhfvg
    hngheppehgmhgrihhlrdgtohhmsehfihigmhgvrdhnrghmvg
X-ME-Proxy: <xmx:Z-wkZBX83T7cKAIJ82p-p_3OIBbpANJ5Z2ajIMN3e3Iu7wmWzTWrEA>
    <xmx:Z-wkZEn3ngqareM2EE1_tOvTRhAPZrDDD3XeyJWtuR8p8fQIm1gIfQ>
    <xmx:Z-wkZGd8DR5zr3TJ-81DB4K3xkprGVpk3Yyj7sqjWd9uMYqPAOTOFw>
    <xmx:Z-wkZCqeK-mPgmw4vQJ1tCVkGPo9cGkV-S5afvNNHrrwb25kAz5W4g>
Feedback-ID: iad51458e:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 29 Mar 2023 21:56:54 -0400 (EDT)
Date:   Wed, 29 Mar 2023 18:56:12 -0700
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
Message-ID: <ZCTsPFb7dBj2IZmo@boqun-archlinux>
References: <20221027205256.17678-1-decui@microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221027205256.17678-1-decui@microsoft.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[Cc stable]

On Thu, Oct 27, 2022 at 01:52:56PM -0700, Dexuan Cui wrote:
> The local variable 'vector' must be u32 rather than u8: see the
> struct hv_msi_desc3.
> 
> 'vector_count' should be u16 rather than u8: see struct hv_msi_desc,
> hv_msi_desc2 and hv_msi_desc3.
> 

Dexuan, I think this patch should only be in 5.15, because...

> Fixes: a2bad844a67b ("PCI: hv: Fix interrupt mapping for multi-MSI")

^^^ this commit is already in 5.15.y (commit id 92dcb50f7f09).

Upstream id e70af8d040d2b7904dca93d942ba23fb722e21b1
Cc: <stable@vger.kernel.org> # 5.15.x

Regards,
Boqun

> Signed-off-by: Dexuan Cui <decui@microsoft.com>
> Cc: Jeffrey Hugo <quic_jhugo@quicinc.com>
> Cc: Carl Vanderlip <quic_carlv@quicinc.com>
> ---
> 
> v1 was posted here (sorry, I forgot to follow this up...):
> https://lwn.net/ml/linux-kernel/20220815185505.7626-1-decui@microsoft.com/
> 
> Changes in v2:
>   Added the explicit "(u8)" cast in hv_compose_msi_msg().
>   Added and improved the comments.
>   Fixed a typo in the subject in v1: s/definiton/definition
> 
>  drivers/pci/controller/pci-hyperv.c | 22 ++++++++++++++++------
>  1 file changed, 16 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/pci/controller/pci-hyperv.c b/drivers/pci/controller/pci-hyperv.c
> index e7c6f6629e7c..ba64284eaf9f 100644
> --- a/drivers/pci/controller/pci-hyperv.c
> +++ b/drivers/pci/controller/pci-hyperv.c
> @@ -1614,7 +1614,7 @@ static void hv_pci_compose_compl(void *context, struct pci_response *resp,
>  
>  static u32 hv_compose_msi_req_v1(
>  	struct pci_create_interrupt *int_pkt, const struct cpumask *affinity,
> -	u32 slot, u8 vector, u8 vector_count)
> +	u32 slot, u8 vector, u16 vector_count)
>  {
>  	int_pkt->message_type.type = PCI_CREATE_INTERRUPT_MESSAGE;
>  	int_pkt->wslot.slot = slot;
> @@ -1642,7 +1642,7 @@ static int hv_compose_msi_req_get_cpu(const struct cpumask *affinity)
>  
>  static u32 hv_compose_msi_req_v2(
>  	struct pci_create_interrupt2 *int_pkt, const struct cpumask *affinity,
> -	u32 slot, u8 vector, u8 vector_count)
> +	u32 slot, u8 vector, u16 vector_count)
>  {
>  	int cpu;
>  
> @@ -1661,7 +1661,7 @@ static u32 hv_compose_msi_req_v2(
>  
>  static u32 hv_compose_msi_req_v3(
>  	struct pci_create_interrupt3 *int_pkt, const struct cpumask *affinity,
> -	u32 slot, u32 vector, u8 vector_count)
> +	u32 slot, u32 vector, u16 vector_count)
>  {
>  	int cpu;
>  
> @@ -1701,7 +1701,12 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
>  	struct compose_comp_ctxt comp;
>  	struct tran_int_desc *int_desc;
>  	struct msi_desc *msi_desc;
> -	u8 vector, vector_count;
> +	/*
> +	 * vector_count should be u16: see hv_msi_desc, hv_msi_desc2
> +	 * and hv_msi_desc3. vector must be u32: see hv_msi_desc3.
> +	 */
> +	u16 vector_count;
> +	u32 vector;
>  	struct {
>  		struct pci_packet pci_pkt;
>  		union {
> @@ -1767,6 +1772,11 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
>  		vector_count = 1;
>  	}
>  
> +	/*
> +	 * hv_compose_msi_req_v1 and v2 are for x86 only, meaning 'vector'
> +	 * can't exceed u8. Cast 'vector' down to u8 for v1/v2 explicitly
> +	 * for better readability.
> +	 */
>  	memset(&ctxt, 0, sizeof(ctxt));
>  	init_completion(&comp.comp_pkt.host_event);
>  	ctxt.pci_pkt.completion_func = hv_pci_compose_compl;
> @@ -1777,7 +1787,7 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
>  		size = hv_compose_msi_req_v1(&ctxt.int_pkts.v1,
>  					dest,
>  					hpdev->desc.win_slot.slot,
> -					vector,
> +					(u8)vector,
>  					vector_count);
>  		break;
>  
> @@ -1786,7 +1796,7 @@ static void hv_compose_msi_msg(struct irq_data *data, struct msi_msg *msg)
>  		size = hv_compose_msi_req_v2(&ctxt.int_pkts.v2,
>  					dest,
>  					hpdev->desc.win_slot.slot,
> -					vector,
> +					(u8)vector,
>  					vector_count);
>  		break;
>  
> -- 
> 2.25.1
> 
