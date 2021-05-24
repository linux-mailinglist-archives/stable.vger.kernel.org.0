Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA57938E746
	for <lists+stable@lfdr.de>; Mon, 24 May 2021 15:19:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232842AbhEXNUx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 May 2021 09:20:53 -0400
Received: from mail-io1-f71.google.com ([209.85.166.71]:33770 "EHLO
        mail-io1-f71.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232426AbhEXNUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 May 2021 09:20:51 -0400
Received: by mail-io1-f71.google.com with SMTP id d14-20020a056602328eb029043afd25c9efso25801871ioz.0
        for <stable@vger.kernel.org>; Mon, 24 May 2021 06:19:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:date:in-reply-to:message-id:subject
         :from:to;
        bh=xlJyul8EX30BPfx0IrWN2X0dWiT6NoPE1yBME7Ku8yY=;
        b=dj9RYD2kPzK4LeIgEfv5yqZOZyVn960hphdoFTb6H3+znyddRiHNmQmOGVy1YW+/yW
         Xv5YgoM/83QXY4TCtHh5+y+efl7DyiaSU/PHIbwKB8Wivn0cnef0REDGjpJRr7ZiFONu
         RJWy/XGmRTodNj1f9m7OVESRxOPspIw0oivPM9frkf2JsSoSwL36Gim1771/YcNA/YA8
         XnDSXfvOVN8SGh9g6l4A1fNAM/xgIs8l9QpZhnIhNtgePyiRVjZ0c5NdOo92JdkgsdXV
         BVV3UETrtbIu28wDrwK9wVh5cv7D0q0AmIRv9AA/s9JIOdBlUAfmCv/U7FNhs41GEmRt
         O0oA==
X-Gm-Message-State: AOAM532HXcUTgf1OBNlNiYx6awVvKZTUcOs9uNYK0+kln67vexEMR55C
        ypKMu0j2BRE/KFoBpeBkJxw8242pUN10Kb0Zj/19gRil+J2/
X-Google-Smtp-Source: ABdhPJzWg5EheSUX48l72MPSH9pGe+SyqFLJi+CvgWH+f8EzYpTz/N9nLnSDP/N6AY7rcG4uM2y87svB8dHUB9euCm+kwxK4BWSE
MIME-Version: 1.0
X-Received: by 2002:a6b:cd08:: with SMTP id d8mr16023343iog.86.1621862363043;
 Mon, 24 May 2021 06:19:23 -0700 (PDT)
Date:   Mon, 24 May 2021 06:19:23 -0700
In-Reply-To: <000000000000f96caf05c30fd10f@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000061f5105c3134231@google.com>
Subject: Re: [syzbot] WARNING in rtl28xxu_ctrl_msg/usb_submit_urb
From:   syzbot <syzbot+faf11bbadc5a372564da@syzkaller.appspotmail.com>
To:     crope@iki.fi, gregkh@linuxfoundation.org, hverkuil@xs4all.nl,
        johan@kernel.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-usb@vger.kernel.org,
        mathias.nyman@linux.intel.com, mchehab@kernel.org,
        stable@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

syzbot has found a reproducer for the following issue on:

HEAD commit:    5cc59c41 USB: core: WARN if pipe direction != setup packet..
git tree:       https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git usb-testing
console output: https://syzkaller.appspot.com/x/log.txt?x=17aa9217d00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=1206ee92dd3d988d
dashboard link: https://syzkaller.appspot.com/bug?extid=faf11bbadc5a372564da
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17e839d1d00000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=1242ce8dd00000

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+faf11bbadc5a372564da@syzkaller.appspotmail.com

usb 1-1: New USB device found, idVendor=0413, idProduct=6a03, bcdDevice=39.7e
usb 1-1: New USB device strings: Mfr=1, Product=2, SerialNumber=3
usb 1-1: Product: syz
usb 1-1: Manufacturer: syz
usb 1-1: SerialNumber: syz
------------[ cut here ]------------
usb 1-1: BOGUS control dir, pipe 80000280 doesn't match bRequestType c0
WARNING: CPU: 1 PID: 32 at drivers/usb/core/urb.c:410 usb_submit_urb+0x14aa/0x1830 drivers/usb/core/urb.c:410
Modules linked in:
CPU: 1 PID: 32 Comm: kworker/1:1 Not tainted 5.13.0-rc2-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
Workqueue: usb_hub_wq hub_event
RIP: 0010:usb_submit_urb+0x14aa/0x1830 drivers/usb/core/urb.c:410
Code: 84 4c 01 00 00 e8 a6 14 b3 fd 4c 89 f7 e8 4e a7 1b ff 45 89 e8 44 89 e1 48 89 ea 48 89 c6 48 c7 c7 c0 09 63 86 e8 18 f1 fb 01 <0f> 0b 49 8d 4f 5c 48 b8 00 00 00 00 00 fc ff df 48 89 ca 48 89 4c
RSP: 0018:ffffc900001a6d50 EFLAGS: 00010286
RAX: 0000000000000000 RBX: ffff88811ab8a058 RCX: 0000000000000000
RDX: ffff888107fc0000 RSI: ffffffff812a6013 RDI: fffff52000034d9c
RBP: ffff88810e79f7a8 R08: 0000000000000001 R09: 0000000000000000
R10: ffffffff814b996b R11: 0000000000000000 R12: 0000000080000280
R13: 00000000000000c0 R14: ffff88811ab8a0a8 R15: ffff8881097a2500
FS:  0000000000000000(0000) GS:ffff8881f6900000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055d9ffcec928 CR3: 00000001103c2000 CR4: 00000000001506e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 usb_start_wait_urb+0x101/0x4c0 drivers/usb/core/message.c:58
 usb_internal_control_msg drivers/usb/core/message.c:102 [inline]
 usb_control_msg+0x31c/0x4a0 drivers/usb/core/message.c:153
 rtl28xxu_ctrl_msg+0x4b7/0x700 drivers/media/usb/dvb-usb-v2/rtl28xxu.c:43
 rtl28xxu_identify_state+0xb6/0x320 drivers/media/usb/dvb-usb-v2/rtl28xxu.c:624
 dvb_usbv2_probe+0x55b/0x7d0 drivers/media/usb/dvb-usb-v2/dvb_usb_core.c:947
 usb_probe_interface+0x315/0x7f0 drivers/usb/core/driver.c:396
 really_probe+0x291/0xf60 drivers/base/dd.c:576
 driver_probe_device+0x298/0x410 drivers/base/dd.c:763
 __device_attach_driver+0x203/0x2c0 drivers/base/dd.c:870
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4b0 drivers/base/dd.c:938
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbe0/0x2100 drivers/base/core.c:3320
 usb_set_configuration+0x113f/0x1910 drivers/usb/core/message.c:2164
 usb_generic_driver_probe+0xba/0x100 drivers/usb/core/generic.c:238
 usb_probe_device+0xd9/0x2c0 drivers/usb/core/driver.c:293
 really_probe+0x291/0xf60 drivers/base/dd.c:576
 driver_probe_device+0x298/0x410 drivers/base/dd.c:763
 __device_attach_driver+0x203/0x2c0 drivers/base/dd.c:870
 bus_for_each_drv+0x15f/0x1e0 drivers/base/bus.c:431
 __device_attach+0x228/0x4b0 drivers/base/dd.c:938
 bus_probe_device+0x1e4/0x290 drivers/base/bus.c:491
 device_add+0xbe0/0x2100 drivers/base/core.c:3320
 usb_new_device.cold+0x721/0x1058 drivers/usb/core/hub.c:2556
 hub_port_connect drivers/usb/core/hub.c:5297 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5437 [inline]
 port_event drivers/usb/core/hub.c:5583 [inline]
 hub_event+0x2357/0x4330 drivers/usb/core/hub.c:5665
 process_one_work+0x98d/0x1580 kernel/workqueue.c:2275
 worker_thread+0x64c/0x1120 kernel/workqueue.c:2421
 kthread+0x38c/0x460 kernel/kthread.c:313
 ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:294

