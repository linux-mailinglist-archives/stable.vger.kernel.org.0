Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 887A22EC720
	for <lists+stable@lfdr.de>; Thu,  7 Jan 2021 00:58:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727840AbhAFX4u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jan 2021 18:56:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727837AbhAFX4t (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jan 2021 18:56:49 -0500
Received: from mail-pl1-x62d.google.com (mail-pl1-x62d.google.com [IPv6:2607:f8b0:4864:20::62d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99202C06136B
        for <stable@vger.kernel.org>; Wed,  6 Jan 2021 15:56:09 -0800 (PST)
Received: by mail-pl1-x62d.google.com with SMTP id r4so2358927pls.11
        for <stable@vger.kernel.org>; Wed, 06 Jan 2021 15:56:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ENlTdyGwVxSb4me32guopKBMcEMFFJ6gIQIeemIR0MQ=;
        b=LKOAb8shKr4lACnLHxXBrVO3HHFl3OTQyeBJ+mvlvBMpLFnEmjqROiDZMw1izyT7i3
         oVleMZBdZAHC5M3Oso4bwIAvgMGQtw6pXoeIjKaLBHUmU5cHRXTiLzpD/cv6xdp3rz9I
         KDsdjlXvtg58+mwAIpSPB0Wh3Jp9nT9Mb8XVLWBlUd65e20AqjOKwxA6hOWJMKlvwPAH
         i78Dn7cOBVghRCFKYC+zy3FQp0WOLj/th7tD9HMsnSBhsX8Cuihg0ZbWXQfQQjmm7UFT
         xylOiX6cBRyz6zvOX2czj46e3fBD0Hb3iVBnwercYAqtYuqOyRLchbfW69qSHGoNMLRQ
         pjKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ENlTdyGwVxSb4me32guopKBMcEMFFJ6gIQIeemIR0MQ=;
        b=U6IFzhCV2ihLwAYJGyU0n8oYzWLtv9telpbwYgwwhEpuuTT8S/FbNWFV/E4ROccp0B
         Gmhye1T16ntQtSaDGzP2IDhYRy2pWCfJr9q/C09sMXjndSL21NcDGxWVekTLj/z2B9DN
         6j0rKIDuQwvaNn3+hv1NyInji0NHODf5zemwxVggrQArg2FNa2B6Tqnr2ok2Cc4BRKeS
         d5p3S+AD4fR+P9BtzA20fWfOitv5c9cCCp4Heq8DFhX2dGw3I5wh+gV2PsL2PcbhA8LB
         NwvetiW8tLOE+9nEWKDQsVLUKpJVeCg99l7F4HM//8bpmwFGXhLu7qShNvoHzfJTPdwX
         UZdg==
X-Gm-Message-State: AOAM5305dCXmPNyLgOeNHz390QivI5NSRxqj3SMgZwmFSw3OX3HmO4RR
        l1VK74cxVGzJUHtD1s3B+sNtI2BV0qksGg==
X-Google-Smtp-Source: ABdhPJzDEFaCDRhEU4/rbzYAv6tE8cdZ8AYmewWdHkhrVwvhPlc9e81pEz5wkTvLa5c6cCs8s0W/Lg==
X-Received: by 2002:a17:90a:ec0e:: with SMTP id l14mr6656503pjy.123.1609977369073;
        Wed, 06 Jan 2021 15:56:09 -0800 (PST)
Received: from [192.168.0.4] ([122.164.82.190])
        by smtp.gmail.com with ESMTPSA id l2sm3343359pjz.27.2021.01.06.15.56.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Jan 2021 15:56:08 -0800 (PST)
Message-ID: <269f0c8fef67713814b16737098bbac2f942bda7.camel@rajagiritech.edu.in>
Subject: Re: [PATCH 5.10 00/40] 5.10.3-rc1 review
From:   Jeffrin Jose T <jeffrin@rajagiritech.edu.in>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, Pavel Machek <pavel@denx.de>,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Date:   Thu, 07 Jan 2021 05:26:03 +0530
In-Reply-To: <X/YUPr5fmVDKcSAK@kroah.com>
References: <1b12b1311e5f0ff7e96d444bf258facc6b0c6ae4.camel@rajagiritech.edu.in>
         <X+dRkTq+T+A6nWPz@kroah.com>
         <58d01e9ee69b4fe51d75bcecdf12db219d261ff1.camel@rajagiritech.edu.in>
         <X+iwvG2d0QfPl+mc@kroah.com>
         <c7688d9a00a510975f115305a9e8d245a4403773.camel@rajagiritech.edu.in>
         <20201228095040.GA11960@amd>
         <356ddc03-038e-71b6-8134-5b41f090d448@roeck-us.net>
         <aa62485a757305b46df190e6f90dfbd6bc31a144.camel@rajagiritech.edu.in>
         <X/Kz4KHxoU/YYEvu@kroah.com>
         <4474633bf649e93f3292d8d248b352066c063a20.camel@rajagiritech.edu.in>
         <X/YUPr5fmVDKcSAK@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2021-01-06 at 20:49 +0100, Greg Kroah-Hartman wrote:
> On Thu, Jan 07, 2021 at 01:08:01AM +0530, Jeffrin Jose T wrote:
> > On Mon, 2021-01-04 at 07:21 +0100, Greg Kroah-Hartman wrote:
> > > On Sun, Jan 03, 2021 at 06:37:51PM +0530, Jeffrin Jose T wrote:
> > > > On Mon, 2020-12-28 at 12:41 -0800, Guenter Roeck wrote:
> > > > > On 12/28/20 1:50 AM, Pavel Machek wrote:
> > > > > > Hi!
> > > > > > 
> > > > > > > > > > > > https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.3-rc1.gz
> > > > > > > > > > > > or in the git tree and branch at:
> > > > > > > > > > > >         git://git.kernel.org/pub/scm/linux/kern
> > > > > > > > > > > > el/g
> > > > > > > > > > > > it/s
> > > > > > > > > > > > table/
> > > > > > > > > > > > linu
> > > > > > > > > > > > x-
> > > > > > > > > > > > stable-rc.git linux-5.10.y
> > > > > > > > > > > > and the diffstat can be found below.
> > > > > > > > > > > > 
> > > > > > > > > > > > thanks,
> > > > > > > > > > > > 
> > > > > > > > > > > > greg k-h
> > > > > > > > > > > 
> > > > > > > > > > > hello ,
> > > > > > > > > > > Compiled and booted 5.10.3-rc1+.
> > > > > > > > > > > 
> > > > > > > > > > > dmesg -l err gives...
> > > > > > > > > > > --------------x-------------x------------------->
> > > > > > > > > > >    43.190922] Bluetooth: hci0: don't support
> > > > > > > > > > > firmware
> > > > > > > > > > > rome
> > > > > > > > > > > 0x31010100
> > > > > > > > > > > --------------x---------------x----------------->
> > > > > > > > > > > 
> > > > > > > > > > > My Bluetooth is Off.
> > > > > > > > > > 
> > > > > > > > > > Is this a new warning?  Does it show up on 5.10.2?
> > > > > > > > > > 
> > > > > > > > > > > Tested-by: Jeffrin Jose T <
> > > > > > > > > > > jeffrin@rajagiritech.edu.in>
> > > > > > > > > > 
> > > > > > > > > > thanks for testing?
> > > > > > > > > > 
> > > > > > > > > > greg k-h
> > > > > > > > > 
> > > > > > > > > this does not show up in 5.10.2-rc1+
> > > > > > > > 
> > > > > > > > Odd.  Can you run 'git bisect' to find the offending
> > > > > > > > commit?
> > > > > > > > 
> > > > > > > > Does this same error message show up in Linus's git
> > > > > > > > tree?
> > > > > > 
> > > > > > > i will try to do "git bisect" .  i saw this error in
> > > > > > > linus's 
> > > > > > > tree.
> > > > > > 
> > > > > > The bug is in -stable, too, so it is probably easiest to do
> > > > > > bisect
> > > > > > on
> > > > > > -stable tree. IIRC there's less then few hundred commits,
> > > > > > so it
> > > > > > should
> > > > > > be feasible to do bisection by hand if you are not familiar
> > > > > > with
> > > > > > git
> > > > > > bisect.
> > > > > > 
> > > > > 
> > > > > My wild guess would be commit b260e4a68853 ("Bluetooth: Fix
> > > > > slab-
> > > > > out-
> > > > > of-bounds
> > > > > read in hci_le_direct_adv_report_evt()"), but I don't see
> > > > > what
> > > > > might
> > > > > be wrong
> > > > > with it unless some BT device sends a bad report which used
> > > > > to be
> > > > > accepted
> > > > > but is now silently ignored.
> > > > > 
> > > > > Guenter
> > > > > 
> > > > hello,
> > > > 
> > > > Did  "git bisect" in  a typically ok fashion and found that
> > > > 5.9.0
> > > > is
> > > > working for bluetooth related. But 5.10.0-rc1  related is not
> > > > working.
> > > > 
> > > > some related information in bisect.txt  attached.
> > > > 
> > > > -- 
> > > > software engineer
> > > > rajagiri school of engineering and technology - autonomous
> > > > 
> > > 
> > > > $sudo git bisect bad
> > > > Bisecting: 0 revisions left to test after this (roughly 1 step)
> > > > [194810f78402128fe07676646cf9027fd3ed431c] dt-bindings: leds:
> > > > Update devicetree documents for ID_RGB
> > > > 
> > > > $sudo git bisect bad
> > > > Bisecting: 0 revisions left to test after this (roughly 0
> > > > steps)
> > > > [3650b228f83adda7e5ee532e2b90429c03f7b9ec] Linux 5.10-rc1
> > > 
> > > That's really odd, as that commit only has a Makefile change.
> > 
> > i will try to work on it again
> > 
> > > Also, why run this as root?
> > > 
> > there may be some problem in my sudo configurtion or the way in run
> > sudo.\
> > when i run "make modules_install" and "make install" using sudo
> > typical
> > files 
> > ownership changes to root.
> 
> That's fine when installing the kernel, but not when building or
> running
> git, please don't do that.

ok related .

