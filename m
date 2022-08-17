Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 543BE596E72
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 14:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiHQM3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 08:29:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235468AbiHQM3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 08:29:11 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AAF674DDF
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 05:29:10 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id A513220265;
        Wed, 17 Aug 2022 12:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1660739348; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i8xhYIvCY2cx7mdhxBssSvv2oFodjc7YGSxo//Lv5aU=;
        b=TvunlgNJY/uD4Tm43qwFbhFDX4PDdO5b5wdN5Ww2uaBotMFJWLNcvuJlsTD0YbrCLOpA6A
        T4Go8YbZP33/nLR7pIooXM6Q34Txye9uHyLbUQuCXmLBi5N9ha1H1+8KEvrgmX9ur6Ewa5
        Kkyo2IgeAsZoVVc2OmhddMPSTKmo/fg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1660739348;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i8xhYIvCY2cx7mdhxBssSvv2oFodjc7YGSxo//Lv5aU=;
        b=uSlf+xEllhXEvhfmONdtbjr8hclOj6HdaYXNz4EwRfS1MEGm7SjQl4y2aHd0a0NdUi+bwe
        LoxAble1RTL5znBg==
Received: from kitsune.suse.cz (kitsune.suse.cz [10.100.12.127])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 7F0F02C197;
        Wed, 17 Aug 2022 12:29:08 +0000 (UTC)
Date:   Wed, 17 Aug 2022 14:29:07 +0200
From:   Michal =?iso-8859-1?Q?Such=E1nek?= <msuchanek@suse.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Coiby Xu <coxu@redhat.com>, bhe@redhat.com, will@kernel.org,
        zohar@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] arm64: kexec_file: use more system
 keyrings to verify kernel" failed to apply to 5.19-stable tree
Message-ID: <20220817122907.GB28810@kitsune.suse.cz>
References: <166057758347124@kroah.com>
 <20220816063256.qzc6jh744i2zc6ou@Rk>
 <YvtOfWDg2SXdcqgL@kroah.com>
 <20220816104559.xwovh5y4bcx6n37a@Rk>
 <YvzZILTQYXBanipB@kroah.com>
 <20220817121115.GA28810@kitsune.suse.cz>
 <YvzcKd2BMSpM9IZV@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <YvzcKd2BMSpM9IZV@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 17, 2022 at 02:16:41PM +0200, Greg KH wrote:
> On Wed, Aug 17, 2022 at 02:11:15PM +0200, Michal Suchánek wrote:
> > On Wed, Aug 17, 2022 at 02:03:44PM +0200, Greg KH wrote:
> > > On Tue, Aug 16, 2022 at 06:45:59PM +0800, Coiby Xu wrote:
> > > > On Tue, Aug 16, 2022 at 09:59:57AM +0200, Greg KH wrote:
> > > > > On Tue, Aug 16, 2022 at 02:32:56PM +0800, Coiby Xu wrote:
> > > > > > Hi Greg,
> > > > > > 
> > > > > > Good to see you here:)
> > > > > > 
> > > > > > On Mon, Aug 15, 2022 at 05:33:03PM +0200, gregkh@linuxfoundation.org wrote:
> > > > > > >
> > > > > > > The patch below does not apply to the 5.19-stable tree.
> > > > > > > If someone wants it applied there, or to any other stable or longterm
> > > > > > > tree, then please email the backport, including the original git commit
> > > > > > > id to <stable@vger.kernel.org>.
> > > > > > >
> > > > > > > thanks,
> > > > > > >
> > > > > > > greg k-h
> > > > > > >
> > > > > > > ------------------ original commit in Linus's tree ------------------
> > > > > > >
> > > > > > > > From 0d519cadf75184a24313568e7f489a7fc9b1be3b Mon Sep 17 00:00:00 2001
> > > > > > > From: Coiby Xu <coxu@redhat.com>
> > > > > > > Date: Thu, 14 Jul 2022 21:40:26 +0800
> > > > > > > Subject: [PATCH] arm64: kexec_file: use more system keyrings to verify kernel
> > > > > > > image signature
> > > > > > >
> > > > > > > Currently, when loading a kernel image via the kexec_file_load() system
> > > > > > > call, arm64 can only use the .builtin_trusted_keys keyring to verify
> > > > > > > a signature whereas x86 can use three more keyrings i.e.
> > > > > > > .secondary_trusted_keys, .machine and .platform keyrings. For example,
> > > > > > > one resulting problem is kexec'ing a kernel image  would be rejected
> > > > > > > with the error "Lockdown: kexec: kexec of unsigned images is restricted;
> > > > > > > see man kernel_lockdown.7".
> > > > > > >
> > > > > > > This patch set enables arm64 to make use of the same keyrings as x86 to
> > > > > > > verify the signature kexec'ed kernel image.
> > > > > > >
> > > > > > > Fixes: 732b7b93d849 ("arm64: kexec_file: add kernel signature verification support")
> > > > > > > Cc: stable@vger.kernel.org # 105e10e2cf1c: kexec_file: drop weak attribute from functions
> > > > > 
> > > > > This is not a valid commit id in Linus's tree.
> > > > > 
> > > > > > > Cc: stable@vger.kernel.org # 34d5960af253: kexec: clean up arch_kexec_kernel_verify_sig
> > > > > 
> > > > > This is not a valid commit id in Linus's tree
> > > > > 
> > > > > > > Cc: stable@vger.kernel.org # 83b7bb2d49ae: kexec, KEYS: make the code in bzImage64_verify_sig generic
> > > > > 
> > > > > And this too is not a valid commit in Linus's tree.
> > > > 
> > > > Sorry for the confusion. The correct commit ids are as follows,
> > > > 
> > > > 0738eceb6201 ("kexec: drop weak attribute from functions")
> > > > 689a71493bd2 ("kexec: clean up arch_kexec_kernel_verify_sig")
> > > > c903dae8941d ("kexec, KEYS: make the code in bzImage64_verify_sig generic")
> > > 
> > > What order do they need to be applied in?
> > 
> > This is the whole series as seen in Linus tree from oldest to newest:
> > 
> > 65d9a9a60fd71be964effb2e94747a6acb6e7015 kexec_file: drop weak attribute from functions
> > 0738eceb6201691534df07e0928d0a6168a35787 kexec: drop weak attribute from functions
> > 689a71493bd2f31c024f8c0395f85a1fd4b2138e kexec: clean up arch_kexec_kernel_verify_sig
> > c903dae8941deb55043ee46ded29e84e97cd84bb kexec, KEYS: make the code in bzImage64_verify_sig generic
> > 0d519cadf75184a24313568e7f489a7fc9b1be3b arm64: kexec_file: use more system keyrings to verify kernel image signature
> 
> Great!
> 
> > (with the exception of the s390 patch which stands on its own)
> 
> What s390 patch?

0828c4a39be57768b8788e8cbd0d84683ea757e5 kexec, KEYS, s390: Make use of built-in and secondary keyring for signature verification

> Now you confused me again...
> 
> greg k-h
