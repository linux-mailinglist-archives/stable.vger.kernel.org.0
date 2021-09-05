Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3189B401145
	for <lists+stable@lfdr.de>; Sun,  5 Sep 2021 21:06:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229880AbhIETH3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Sep 2021 15:07:29 -0400
Received: from x127130.tudelft.net ([131.180.127.130]:34236 "EHLO
        djo.tudelft.nl" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S229865AbhIETH3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Sep 2021 15:07:29 -0400
X-Greylist: delayed 409 seconds by postgrey-1.27 at vger.kernel.org; Sun, 05 Sep 2021 15:07:28 EDT
Received: by djo.tudelft.nl (Postfix, from userid 2001)
        id AD58A1C42C4; Sun,  5 Sep 2021 21:00:45 +0200 (CEST)
Date:   Sun, 5 Sep 2021 21:00:45 +0200
From:   wim <wim@djo.tudelft.nl>
To:     gregkh@linuxfoundation.org
Cc:     wim <wim@djo.tudelft.nl>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: kernel-4.9.270 crash
Message-ID: <20210905190045.GA10991@djo.tudelft.nl>
Reply-To: wim@djo.tudelft.nl
References: <20210904235231.GA31607@djo.tudelft.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210904235231.GA31607@djo.tudelft.nl>
User-Agent: Mutt/1.11.2 (2019-01-07)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 05, 2021 at 01:52:31AM +0200, wim wrote:
> 
> Hello Greg,
> 
> from kernel-4.9.270 up until now (4.9.282) I experience kernel crashes upon
> loading a GPU module.
> It happens on two out of at least six different machines.
> I can't believe that I'm the only one where that happens, but since the bug
> is still there twelve versions later, I need to report this.
> 
> I run Gentoo with vanilla kernels.
> Upon loading i915.ko (automatically or manually) my laptop freezes until
> power-down. (Note that other machines using i915.ko have no problems here.)
> It's an Asus laptop with Intel chipset with a peculiarity:
> 
>  00:02.0 VGA compatible controller: Intel Corporation HD Graphics 620 (rev 02)
>  01:00.0 3D controller: NVIDIA Corporation GM108M [GeForce 940MX] (rev a2)
> 
> (It uses Intel natively and nobody knows how to make use of that Nvidia chip)
> 
> 
> On an AMD desktop I get the same crash upon loading of nouveau.ko .
> 
> Something ugly must have been introduced in kernel-4.9.270 .
> Strace modprobe .. only prints two lines on the screen.
> Strace modprobe .. 2>&1 > file produces only an empty file.
> 
> Any ideas?
 
Regards,
Wim Osterholt.

