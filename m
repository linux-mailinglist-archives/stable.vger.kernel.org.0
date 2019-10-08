Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1C9CF21A
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 07:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbfJHFPD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 01:15:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:45084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726193AbfJHFPD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 01:15:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F47B2084D;
        Tue,  8 Oct 2019 05:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570511700;
        bh=YCW5X3BjS2i51EyVNfbxFVuo9U5hDS8jaqwxFAFPNMg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IIExwIqOhzf1dLwTzR/1Qfh58BDozdE32CPzSQuOvaIazGf5nqGzPTaZSiz5i5Kap
         6K4Y1oU2K0IHvQRJvNrxMuZScsLjLtsE3SeY8aPCGTXuT2ZKpb5r5/LuIw3FGAYzAn
         mEaRP1e5LIA24/QgaI9lsD9bUgx7fblruPZ6xJlE=
Date:   Tue, 8 Oct 2019 07:14:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/36] 4.4.196-stable review
Message-ID: <20191008051457.GA2058179@kroah.com>
References: <20191006171038.266461022@linuxfoundation.org>
 <d3e1e6ae-8ca4-a43b-d30d-9a9a9a7e5752@roeck-us.net>
 <20191007144951.GB966828@kroah.com>
 <fbce4eb8-ebc8-5246-ea03-3af2ebb97a16@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <fbce4eb8-ebc8-5246-ea03-3af2ebb97a16@roeck-us.net>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 07, 2019 at 03:36:46PM -0700, Guenter Roeck wrote:
> On 10/7/19 7:49 AM, Greg Kroah-Hartman wrote:
> > On Mon, Oct 07, 2019 at 05:53:55AM -0700, Guenter Roeck wrote:
> > > On 10/6/19 10:18 AM, Greg Kroah-Hartman wrote:
> > > > This is the start of the stable review cycle for the 4.4.196 release.
> > > > There are 36 patches in this series, all will be posted as a response
> > > > to this one.  If anyone has any issues with these being applied, please
> > > > let me know.
> > > > 
> > > > Responses should be made by Tue 08 Oct 2019 05:07:10 PM UTC.
> > > > Anything received after that time might be too late.
> > > > 
> > > 
> > > powerpc:defconfig fails to build.
> > > 
> > > arch/powerpc/kernel/eeh_driver.c: In function ‘eeh_handle_normal_event’:
> > > arch/powerpc/kernel/eeh_driver.c:678:2: error: implicit declaration of function ‘eeh_for_each_pe’; did you mean ‘bus_for_each_dev’?
> > > 
> > > It has a point:
> > > 
> > > ... HEAD is now at 13cac61d31df Linux 4.4.196-rc1
> > > $ git grep eeh_for_each_pe
> > > arch/powerpc/kernel/eeh_driver.c:       eeh_for_each_pe(pe, tmp_pe)
> > > arch/powerpc/kernel/eeh_driver.c:                               eeh_for_each_pe(pe, tmp_pe)
> > > 
> > > Caused by commit 3fb431be8de3a ("powerpc/eeh: Clear stale EEH_DEV_NO_HANDLER flag").
> > > Full report will follow later.
> > 
> > Thanks for letting me know, I've dropped this from the queue now and
> > pushed out a -rc2 with that removed.
> > 
> 
> For v4.4.195-36-g898f6e5cf82f:
> 
> Build results:
> 	total: 170 pass: 170 fail: 0
> Qemu test results:
> 	total: 324 pass: 324 fail: 0

Wonderful, thanks for letting me know!

greg k-h
