Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BBFC6406F7
	for <lists+stable@lfdr.de>; Fri,  2 Dec 2022 13:39:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233062AbiLBMjg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Dec 2022 07:39:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232873AbiLBMje (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Dec 2022 07:39:34 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D98BB8EE70;
        Fri,  2 Dec 2022 04:39:32 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2F486CE1E79;
        Fri,  2 Dec 2022 12:39:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D54F8C433C1;
        Fri,  2 Dec 2022 12:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669984769;
        bh=KtngymIfyeQ0A30J7Xlx/WGy9n4uZFsRswH4rUF7oro=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1q1mZ+R6LUf75CDSex3BDNdhBG8+vmdP34vZs3K5d5+2jcc/TVfeZ1uaXcWVl0rgC
         0C4uXk7Ynhp9w/zpF4U0Jyi2zdKwQIbZIwzpC/NmgGG+D4R7zjU/qVrMlCLPKcIIbf
         0qmoYtnqXn2YTs/MLxhKIz9uIfcvIbrJlAV6uNDA=
Date:   Fri, 2 Dec 2022 13:39:24 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     mlevitsk@redhat.com, samuel.thibault@ens-lyon.org,
        pawell@cadence.com, stable@vger.kernel.org,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/162] 5.10.157-rc1 review
Message-ID: <Y4nx/HMggCOhdIMy@kroah.com>
References: <20221130180528.466039523@linuxfoundation.org>
 <Y4nmNb46aqbm7JuS@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <Y4nmNb46aqbm7JuS@duo.ucw.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 02, 2022 at 12:49:09PM +0100, Pavel Machek wrote:
> Hi!
> 
> [If I cc-ed you, you are author of one of patches below. Please take a
> look.]
> 
> > Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> > Anything received after that time might be too late.
> 
> I hope to make it :-). I
> 
> > Pawel Laszczak <pawell@cadence.com>
> >     usb: cdnsp: Device side header file for CDNSP driver
> > 
> > Pawel Laszczak <pawell@cadence.com>
> >     usb: cdns3: Add support for DRD CDNSP
> 
> These two together are 1500+ lines, and are marked as Stable-dep-of:
> 9d5333c93134 ("usb: cdns3: host: fix endless superspeed hub port
> reset") . But we don't have that one in 5.10 tree. Likely we should
> not have these either.

I already dropped these yesterday.

> > Maxim Levitsky <mlevitsk@redhat.com>
> >     KVM: x86: emulator: update the emulation mode after rsm
> 
> No. The patch does not do anything. Mainline commit this referenced
> changed the return value, this changes just a comment. Wrong backport?

I will look at this.

> > Samuel Thibault <samuel.thibault@ens-lyon.org>
> >     speakup: Generate speakupmap.h automatically
> 
> Ok, so this one rewrites some header generation and is buggy. 500+ lines.

Already dropped yesterday.

> > Đoàn Trần Công Danh <congdanhqx@gmail.com>
> >     speakup: replace utils' u_char with unsigned char
> 
> With this patch fixing it. The rewrite is marked as stable depedncency
> of the fix, but fix would not be needed if we did not apply the
> rewrite. We should not have these two in stable.

Again, already dropped.

thanks for the review.

greg k-h
