Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F8966CBECC
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 14:14:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230095AbjC1MOm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 08:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229728AbjC1MOl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 08:14:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D11471AC;
        Tue, 28 Mar 2023 05:14:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 680BB60DE6;
        Tue, 28 Mar 2023 12:14:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7245BC433D2;
        Tue, 28 Mar 2023 12:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680005679;
        bh=xbFRyZyzqgBp4VY8lMbcNo1SclMc/sKJFwaJaJqJz1Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GQh60RuKjQE+ypYjIPjSg5WaCab4xlth7fo/NlmTwPibO3sOYEWrnh/D7vDwY2QSW
         tWTIEnDr59z5yZhhtb9XH6ZF1RX3C1eybQ6FnEQns5ZMru22gEcrpMVC/DOno1zA3n
         U5qPz0SieK2GlIUBZOLgMamzdMdn9mTN02rhBMec=
Date:   Tue, 28 Mar 2023 14:14:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mathias Krause <minipli@grsecurity.net>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        lwn@lwn.net, jslaby@suse.cz
Subject: Re: Linux 5.15.103
Message-ID: <ZCLaLWJiIsDV5yGr@kroah.com>
References: <1679040264214179@kroah.com>
 <c359c777-c3af-b4a6-791d-d51916160bf5@grsecurity.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c359c777-c3af-b4a6-791d-d51916160bf5@grsecurity.net>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 28, 2023 at 02:02:03PM +0200, Mathias Krause wrote:
> On 17.03.23 09:04, Greg Kroah-Hartman wrote:
> > I'm announcing the release of the 5.15.103 kernel.
> > 
> > [...]
> > 
> > Vitaly Kuznetsov (4):
> >       KVM: Optimize kvm_make_vcpus_request_mask() a bit
> >       KVM: Pre-allocate cpumasks for kvm_make_all_cpus_request_except()
> >       KVM: nVMX: Don't use Enlightened MSR Bitmap for L3
> >       KVM: VMX: Introduce vmx_msr_bitmap_l01_changed() helper
> > 
> 
> That list is missing commit 6470accc7ba9 ("KVM: x86: hyper-v: Avoid
> calling kvm_make_vcpus_request_mask() with vcpu_mask==NULL") to fulfill
> the prerequisite of "KVM: Optimize kvm_make_vcpus_request_mask() a bit".
> 
> Right now the kvm selftests trigger a kernel NULL deref for the hyperv
> test, making the system hang.
> 
> Please consider applying commit 6470accc7ba9 for the next v5.15.x release.

It wasn't tagged for the stable kernels, so we didn't pick it up :(

Have now done so, thanks.

greg k-h
