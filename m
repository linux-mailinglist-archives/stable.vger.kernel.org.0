Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4DB662CB4F
	for <lists+stable@lfdr.de>; Wed, 16 Nov 2022 21:45:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233358AbiKPUpB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Nov 2022 15:45:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbiKPUpA (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Nov 2022 15:45:00 -0500
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1300E40448;
        Wed, 16 Nov 2022 12:44:58 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 13E02320096B;
        Wed, 16 Nov 2022 15:44:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 16 Nov 2022 15:44:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
         h=cc:cc:content-transfer-encoding:content-type:date:date:from
        :from:in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm2; t=1668631495; x=
        1668717895; bh=YOfiesPEOAuUBSKKpRAQrX3e3W+dT8d3FBCanuP8ktQ=; b=N
        08txJlUzUDG1GQF4uRqGt7udIYP7fS7l3NRcYysByYbhCMbq9e4xqDHSxNBTV2Km
        iofRM+eUOJUo5KznvBAdG1FV9cnpjnSKGEBomqIK0CsXtW5COSjS5juZ/Z3h82Ox
        h2ZGcaZPeYmlCwxeWieupmAMQoHy6E0e14aerd6V9MUqBb29y3/QQaLmp4Iuh2ES
        evJczTWPL5xpf2mrDLvmBRdgulCX9Vv0VdLiSzjMF8oXJt6KIJ6kwEBAK6qUsld/
        EXvgkk4G4BZXUocLVYa4LYh+GyZMcZy9iooNv7EXPcmRQ29ssGGHaY45J07lb9cY
        2b/3xJcdaMFFDqkgEUIEQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:feedback-id:feedback-id:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1668631495; x=
        1668717895; bh=YOfiesPEOAuUBSKKpRAQrX3e3W+dT8d3FBCanuP8ktQ=; b=i
        rvJFQALqk2m9ETraqa9ybGitP5C4ZLZOREAwq/aM/bBoX3Olp2w6i4x8qommR4te
        8rFDrvzIMHx7lbqzFGiHVH705dNMhp2Z5zrmeQFBDQqDFgHBzKVD1vA+o1PyDQTU
        eCLPr++CCOYVUuVHCDF+k5g2e4s8pt48qUC49WUQjq7doSgZ544WPwpC5KpKOJnQ
        qd9Q+tOyUR3zaXfVIcaRZkGRswv697bU13T85ZDVK8PNceJ0obtpcZmG8fa+ZQ7s
        riqbnzN03UFJLupeOoPqEpvXOtI1LpmHkIeP2WXIO/NUdy3ZA3HZCvbMezN1fSYx
        bChB5SkSSvIvOnxikL+2A==
X-ME-Sender: <xms:xkt1Y69JOZNpI_wbdvb1KFo-TZjZwVAVzTyxlX6KBkXP5LxLjweC9Q>
    <xme:xkt1Y6u14R5FT9QgNTummNSxZNGEZHvzNs1Ykuq1JncpSxkwH2aernhZW7ZxVeCyj
    1i5BveRucWlDAoOiXE>
X-ME-Received: <xmr:xkt1YwBUVqqE0fzE3zmiS6L_SVchxo4nPKvKOnx-RiJ8qyuPwrCVys79au8ZDYFJGfSJUw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvgedrgeeigddufeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggugfgjsehtkedttddttddunecuhfhrohhmpedfkhhi
    rhhilhhlsehshhhuthgvmhhovhdrnhgrmhgvfdcuoehkihhrihhllhesshhhuhhtvghmoh
    hvrdhnrghmvgeqnecuggftrfgrthhtvghrnhepleehvefgieeukeekvddvudevieeikeeu
    gfeghfejjedvfeeivdfhtddtueetgfejnecuvehluhhsthgvrhfuihiivgeptdenucfrrg
    hrrghmpehmrghilhhfrhhomhepkhhirhhilhhlsehshhhuthgvmhhovhdrnhgrmhgv
X-ME-Proxy: <xmx:xkt1YycwHcuJnoD6aYa_kB3bvM122-QDPK1Ckm0uSUPnyTtD63aq5Q>
    <xmx:xkt1Y_NO6CaWKcg5UjVEBkXKC2wensON05H0-ATI4CKaZ8WMcOVMqA>
    <xmx:xkt1Y8mLwkr77TPCSWOnYyE_iJh08HpiI4Gu8SYD_f-I848HOZUyMg>
    <xmx:x0t1Y4g8QjR1NfGjP8caFLxuYxTZRZYaNKw7p11BwBV0AtjfEIQcjw>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Nov 2022 15:44:54 -0500 (EST)
Received: by box.shutemov.name (Postfix, from userid 1000)
        id 1BEF1109702; Wed, 16 Nov 2022 23:44:51 +0300 (+03)
Date:   Wed, 16 Nov 2022 23:44:51 +0300
From:   "kirill@shutemov.name" <kirill@shutemov.name>
To:     "Verma, Vishal L" <vishal.l.verma@intel.com>
Cc:     "Piper, Chris D" <chris.d.piper@intel.com>,
        "rafael@kernel.org" <rafael@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Williams, Dan J" <dan.j.williams@intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "nvdimm@lists.linux.dev" <nvdimm@lists.linux.dev>,
        "liushixin2@huawei.com" <liushixin2@huawei.com>
Subject: Re: [PATCH 2/2] ACPI: HMAT: Fix initiator registration for
 single-initiator systems
Message-ID: <20221116204451.rmh6lq7vilajg7ss@box.shutemov.name>
References: <20221116075736.1909690-1-vishal.l.verma@intel.com>
 <20221116075736.1909690-3-vishal.l.verma@intel.com>
 <20221116124634.nlvnsirdnlafdfeh@box.shutemov.name>
 <b29163f4e39d28c3656b468a52a63b34073cb933.camel@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <b29163f4e39d28c3656b468a52a63b34073cb933.camel@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 16, 2022 at 06:02:32PM +0000, Verma, Vishal L wrote:
> On Wed, 2022-11-16 at 15:46 +0300, Kirill A. Shutemov wrote:
> > On Wed, Nov 16, 2022 at 12:57:36AM -0700, Vishal Verma wrote:
> > > In a system with a single initiator node, and one or more memory-only
> > > 'target' nodes, the memory-only node(s) would fail to register their
> > > initiator node correctly. i.e. in sysfs:
> > > 
> > >   # ls /sys/devices/system/node/node0/access0/targets/
> > >   node0
> > > 
> > > Where as the correct behavior should be:
> > > 
> > >   # ls /sys/devices/system/node/node0/access0/targets/
> > >   node0 node1
> > > 
> > > This happened because hmat_register_target_initiators() uses list_sort()
> > > to sort the initiator list, but the sort comparision function
> > > (initiator_cmp()) is overloaded to also set the node mask's bits.
> > > 
> > > In a system with a single initiator, the list is singular, and list_sort
> > > elides the comparision helper call. Thus the node mask never gets set,
> > > and the subsequent search for the best initiator comes up empty.
> > > 
> > > Add a new helper to sort the initiator list, and handle the singular
> > > list corner case by setting the node mask for that explicitly.
> > > 
> > > Reported-by: Chris Piper <chris.d.piper@intel.com>
> > > Cc: <stable@vger.kernel.org>
> > > Cc: Rafael J. Wysocki <rafael@kernel.org>
> > > Cc: Liu Shixin <liushixin2@huawei.com>
> > > Cc: Dan Williams <dan.j.williams@intel.com>
> > > Signed-off-by: Vishal Verma <vishal.l.verma@intel.com>
> > > ---
> > >  drivers/acpi/numa/hmat.c | 32 ++++++++++++++++++++++++++++++--
> > >  1 file changed, 30 insertions(+), 2 deletions(-)
> > > 
> > > diff --git a/drivers/acpi/numa/hmat.c b/drivers/acpi/numa/hmat.c
> > > index 144a84f429ed..cd20b0e9cdfa 100644
> > > --- a/drivers/acpi/numa/hmat.c
> > > +++ b/drivers/acpi/numa/hmat.c
> > > @@ -573,6 +573,30 @@ static int initiator_cmp(void *priv, const struct list_head *a,
> > >         return ia->processor_pxm - ib->processor_pxm;
> > >  }
> > >  
> > > +static int initiators_to_nodemask(unsigned long *p_nodes)
> > > +{
> > > +       /*
> > > +        * list_sort doesn't call @cmp (initiator_cmp) for 0 or 1 sized lists.
> > > +        * For a single-initiator system with other memory-only nodes, this
> > > +        * means an empty p_nodes mask, since that is set by initiator_cmp().
> > > +        * Special case the singular list, and make sure the node mask gets set
> > > +        * appropriately.
> > > +        */
> > > +       if (list_empty(&initiators))
> > > +               return -ENXIO;
> > > +
> > > +       if (list_is_singular(&initiators)) {
> > > +               struct memory_initiator *initiator = list_first_entry(
> > > +                       &initiators, struct memory_initiator, node);
> > > +
> > > +               set_bit(initiator->processor_pxm, p_nodes);
> > > +               return 0;
> > > +       }
> > > +
> > > +       list_sort(p_nodes, &initiators, initiator_cmp);
> > > +       return 0;
> > > +}
> > > +
> > 
> > Hm. I think it indicates that these set_bit()s do not belong to
> > initiator_cmp().
> > 
> > Maybe remove both set_bit() from the compare helper and walk the list
> > separately to initialize the node mask? I think it will be easier to
> > follow.
> 
> 
> Yes - I thuoght about this, but went with the seemingly less intrusive
> change. I can send a v2 which separates out the set_bit()s. I agree
> that's cleaner and easier to follow than overloading initiator_cmp().

Yes, please make v2.

With current implementation set_bit() can be called multiple times on the
same initiator, depending on placement of the initiator in the list.
It is totally wrong place.

-- 
  Kiryl Shutsemau / Kirill A. Shutemov
