Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D534359BA4B
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 09:33:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbiHVHdd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 03:33:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229987AbiHVHd3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 03:33:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16E04641D;
        Mon, 22 Aug 2022 00:33:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6E2C160FD3;
        Mon, 22 Aug 2022 07:33:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D29AC433C1;
        Mon, 22 Aug 2022 07:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661153607;
        bh=XuzgcZ88oT76WikNe2fW2435sbH00Xg16r415ODnaU8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=e/zBKz5jtOpHSvUuXHmgbr/uYnwS9NrD6dXj7R2KUeNRVO/jrbE4ag+980CcPCMft
         95dBWAVNiuJzQEhgdc+xG7RzqTgKwqyDIv7l3vKLEAbqtA1c2r+5i8QL/jTzBy5l6K
         msId0qiEvCSnl0lRTrmxfFV8Ai728rwxHilCE9A0=
Date:   Mon, 22 Aug 2022 09:33:24 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     stable <stable@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-x86_64@vger.kernel.org
Subject: Re: LTS kernel Linux 4.14.290 unable to boot with edk2-ovmf (x86_64
 UEFI runtime)
Message-ID: <YwMxRAfrrsPE6sNI@kroah.com>
References: <2d6012e8-805d-4225-80ed-d317c28f1899@gmx.com>
 <YwMhXX6OhROLZ/LR@kroah.com>
 <1ed5a33a-b667-0e8e-e010-b4365f3713d6@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1ed5a33a-b667-0e8e-e010-b4365f3713d6@gmx.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 03:24:53PM +0800, Qu Wenruo wrote:
> 
> 
> On 2022/8/22 14:25, Greg KH wrote:
> > On Mon, Aug 22, 2022 at 09:15:59AM +0800, Qu Wenruo wrote:
> > > Hi,
> > > 
> > > When backporting some btrfs specific patches to all LTS kernels, I found
> > > v4.14.290 kernel unable to boot as a KVM guest with edk2-ovmf
> > > (edk2-ovmf: 202205, qemu 7.0.0, libvirt 1:8.6.0).
> > > 
> > > While all other LTS/stable branches (4.19.x, 5.4.x, 5.10.x, 5.15.x,
> > > 5.18.x, 5.19.x) can boot without a hipccup.
> > > 
> > > I tried the following configs, but none of them can even provide an
> > > early output:
> > > 
> > > - CONFIG_X86_VERBOSE_BOOTUP
> > > - CONFIG_EARLY_PRINTK
> > > - CONFIG_EARLY_PRINTK_EFI
> > > 
> > > Is this a known bug or something new?
> > 
> > Has this ever worked properly on this very old kernel tree?  If so, can
> > you use 'git bisect' to find the offending commit?
> 
> Unfortunately the initial v4.14 from upstream can not even be compiled.

Really?  Try using an older version of gcc and you should be fine.  It
did build properly back in 2017 when it was released :)

thanks,

greg k-h
