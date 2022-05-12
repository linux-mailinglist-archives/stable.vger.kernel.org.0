Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96BA5524E54
	for <lists+stable@lfdr.de>; Thu, 12 May 2022 15:32:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354300AbiELNcj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 May 2022 09:32:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354338AbiELNcg (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 May 2022 09:32:36 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B425D131F2B;
        Thu, 12 May 2022 06:32:35 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 4334C32002D8;
        Thu, 12 May 2022 09:32:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 12 May 2022 09:32:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-transfer-encoding:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to; s=fm1; t=1652362353; x=
        1652448753; bh=TWjr3IjUSG7EQPHiuRD8Jyjrf2Ne+S+SPNmY1waQIN0=; b=g
        WCF5iKNFVrgApTtZJY+3QbOm+Lcd16NBu0LvBJeeNJw+0UwJA+pP38XAz1WTizpR
        ZLQTSUZaS0II+Lzxp0p10528VcfoVe3Yyp/tMaXsGfaK3X0dxZxA4G6m5WfIu3Nh
        NPvp49S5RSpBU2Femfmm9/s9I+bfBSAOy4kLd/JVzOmK/xX7ypzjvlI7CXaUNuDj
        5IqTC0Xop0XK0tvRUCNODf/whGXSFNTqXI4S3CoYxvqWhDZueOrWrndUvwBk2nBp
        w8LA3xBjlCuLB+8sgPOUN4ryU0L3zQhmZc9fzbo3XCalyKG8PTFElqrcgMEKE/lW
        ePn5FAGsrkhXhc4OcStzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm1; t=1652362353; x=1652448753; bh=TWjr3IjUSG7EQ
        PHiuRD8Jyjrf2Ne+S+SPNmY1waQIN0=; b=mB+XOu4pKQmg+mB/NHcdAmC1hpU1b
        yJtrkWxUrPgFD9fF4bAUOhyRbmzElnkJN2ptWS0gjSlWClZkK+AgoL0h1UOFBwLx
        1p0ViiAldJVcVFF3BMi8Bq6LiS23vB2v+EYQz6FcfWS6bveCsjsKgifC4K3SPviH
        G3J5U4L+1kccnpyjiqMIOfOs9VFidEGdGaf8F31ijHguGFsRvnyEXAOgOzsxDV7V
        A0WTBEp7rODnLgHlqYulIKr3QCTF58UuItlSKyqyLcVuT8idczwGqsVSc3Pc+kxZ
        bog+c2H5+otRpv1pOj6hkrh3e2uISAcvltA2EMYBQdu6mr9lmf3DinKjg==
X-ME-Sender: <xms:cQx9Yp-EmaRILQSXdtEgAYE-sCb8Zs84lfL-yLYpYo6IxFi_agQzew>
    <xme:cQx9YtttDm-Hqia2B-I_Wt61mmjvwzPyjOrdzPYKDhHrdPBNyQofYqcnGJdMTf-LW
    31bsxDCvSu_7Q>
X-ME-Received: <xmr:cQx9YnDgG2eR6FOWShVdrhPTCL_7ll8ppO_qGdh681UKOBYE2Nn-OxjVgn7ev8KpcSzGYiaAWy1ifkBIucVA7RTJU9uoPljs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgeejgdeifecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhepfffhvfevuffkfhggtggugfgjsehtke
    ertddttddunecuhfhrohhmpefirhgvghcumffjuceoghhrvghgsehkrhhorghhrdgtohhm
    qeenucggtffrrghtthgvrhhnpeelheehudduueeggeejgfehueduffehveeukefgkeeufe
    eltdejteeiuedtkeekleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgr
    ihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:cQx9Ytebpj45E86a7Jirvfwn1Dyhgyt2uHtzqT4TiScC8G8yhJ_nng>
    <xmx:cQx9YuNIa7XKLMxHEZEqv7hOSamvesoQEA2Bj4GVIXxaNjwOzli1aQ>
    <xmx:cQx9YvmWVC4htSzi2aGsD6GJzir4tkvbtdicm1BvCH7IELvxsKV5MA>
    <xmx:cQx9YqBPfWGTahld9a71qXHYaaCClIaeT0DqkM-RddL6UgTNErm41A>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 12 May 2022 09:32:32 -0400 (EDT)
Date:   Thu, 12 May 2022 15:32:30 +0200
From:   Greg KH <greg@kroah.com>
To:     =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>
Cc:     stable@vger.kernel.org, bugzilla-daemon@kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [Bug 215967] New: Kernel build fails if CONFIG_REGULATOR is unset
Message-ID: <Yn0MbpKBi++ooGI9@kroah.com>
References: <bug-215967-208809@https.bugzilla.kernel.org/>
 <YnuqQAb2CIRyfZPX@kroah.com>
 <87wnesccjl.fsf@miraculix.mork.no>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87wnesccjl.fsf@miraculix.mork.no>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, May 11, 2022 at 05:30:06PM +0200, Bjørn Mork wrote:
> Greg KH <greg@kroah.com> writes:
> > On Wed, May 11, 2022 at 07:44:39AM +0000, bugzilla-daemon@kernel.org wrote:
> >
> >> Compilation of "drivers/usb/phy/phy-generic.c" fails reproducible if
> >> CONFIG_REGULATOR is unset, because function "devm_regulator_get_exclusive" is
> >> undeclared but nevertheless used.
> >> The offending patch propably is commit 03e607cbb2931374db1825f371e9c7f28526d3f4
> >> upstream
> >
> > Can you please send this information to the stable@vger.kernel.org
> > mailing list and we will work on it there?
> 
> Please backport commit 51dfb6ca3728 ("regulator: consumer: Add missing
> stubs to regulator/consumer.h") to v5.10 stable and older stable
> releases where 03e607cbb2931374db1825f371e9c7f28526d3f4 is backported

Now queued up, thanks.

greg k-h
