Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A45736FBB1
	for <lists+stable@lfdr.de>; Fri, 30 Apr 2021 15:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbhD3NrQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Apr 2021 09:47:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:45188 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229688AbhD3NrQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 30 Apr 2021 09:47:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8497461476;
        Fri, 30 Apr 2021 13:46:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1619790388;
        bh=SMsgf9OmZXlQb5w8BVoAcEI5H2Xnfd08BV9vqKDtdrw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YPKPS+iNQ+k0YGnANi34LNrFBvmGWn46ftVwzsT4OZHlHzy5u/q+zSpnCgC4bDXnx
         6jY7cBn+WGdH/TgCaUME/6uOcTzt6GpXXX/69UWgJ3pA8dYSXC4aN3fliDicz8GV9Z
         h23fvfY7sz9/vPfI0it3r9JXt2Zab1pGbaAZk8Ys=
Date:   Fri, 30 Apr 2021 15:46:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Seewald <tseewald@gmail.com>
Cc:     stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>,
        syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com,
        Valentina Manea <valentina.manea.m@gmail.com>,
        Shuah Khan <shuah@kernel.org>
Subject: Re: [PATCH] usbip: vudc synchronize sysfs code paths
Message-ID: <YIwKMYwHBYmNL3R4@kroah.com>
References: <20210426172831.24030-1-tseewald@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210426172831.24030-1-tseewald@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 26, 2021 at 12:28:31PM -0500, Tom Seewald wrote:
> From: Shuah Khan <skhan@linuxfoundation.org>
> 
> commit bd8b82042269a95db48074b8bb400678dbac1815 upstream.
> 
> Fuzzing uncovered race condition between sysfs code paths in usbip
> drivers. Device connect/disconnect code paths initiated through
> sysfs interface are prone to races if disconnect happens during
> connect and vice versa.
> 
> Use sysfs_lock to protect sysfs paths in vudc.
> 
> Cc: stable@vger.kernel.org # 4.14.x
> Reported-and-tested-by: syzbot+a93fba6d384346a761e3@syzkaller.appspotmail.com
> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
> Link: https://lore.kernel.org/r/caabcf3fc87bdae970509b5ff32d05bb7ce2fb15.1616807117.git.skhan@linuxfoundation.org
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Tom Seewald <tseewald@gmail.com>
> ---
>  drivers/usb/usbip/vudc_dev.c   | 1 +
>  drivers/usb/usbip/vudc_sysfs.c | 5 +++++
>  2 files changed, 6 insertions(+)

Now queued up, thanks.

greg k-h
