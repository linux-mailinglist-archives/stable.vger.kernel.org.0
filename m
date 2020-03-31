Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6E4A199FB1
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 22:02:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728893AbgCaUCW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 16:02:22 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:44384 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727708AbgCaUCV (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 16:02:21 -0400
Received: by mail-qk1-f196.google.com with SMTP id j4so24446028qkc.11
        for <stable@vger.kernel.org>; Tue, 31 Mar 2020 13:02:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=massaru-org.20150623.gappssmtp.com; s=20150623;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=Q1beehtgWdVUjw4H/uaMAEYCwGvvcPji2ivitcnMva8=;
        b=qjEIqcXDFFQ1IVgRToaVEFyL+0yx+IHNvMfCjj1ZHcVpXyMqr/hcYS1hfnj2uVmjjv
         yF+qKqa9VvvPLCcwZ56GYq/5cMJwhVKSopJqHOxjo73zWwQET2IZ1Su5NLgv13G4oqcu
         Ho1jOsFYGPvNGoCteEmV1OxTymHbHz3pKZpamIUnpEWAE3tESP4ValkKap8szgNtnVE2
         L8euZT+pZ0CrVfRxjtsB1gSE9AT1NNvn0cxK9xffq358Uh1tM05ZO05zgGNOTqyTQeEP
         yTQPBU7ZfTLZBByEWwAdXwumthwfQIde9hm4L9IiAIGIfjzJOTbu6QVTDkyr+W4SoeDV
         gaDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=Q1beehtgWdVUjw4H/uaMAEYCwGvvcPji2ivitcnMva8=;
        b=j/rKCDzeGxHcGRvkiUOIjPupZCo13yfXlOGZnGniZNfwjK5RFFOFaR1wDmbTw6ogk4
         4KBy+rDHPm+88KIGBR2gXtpwE3qyjNpqEke2PvI+sO/vb4fcsFOD2BWN1VEEf1ges0q2
         +/YitsaxPka4j2DhD7+icoEDfWP9BMhuxXsPnw4NhAvaHkYocIhgaFpn90EEnvMCxMKJ
         DTq3yWfz3AuRsUbRt4cUBWjOySOJ98sAYBZ8O4JmYtf7kwi43xRE2Yuw6WsZAz8uMLC2
         Z+nK3NquSoolu2pdlNnlS9n3grY6GfbUrw/jhonOpW92pIukqlrxjNlVpsit+dqGxc4t
         8+jQ==
X-Gm-Message-State: ANhLgQ0BXAtOEoA3q/fQSmdDrFgu008j1AHk0KOz/nuP4axfsUpGiWMU
        TMS5PR6C4GdCPHuj0Kg0vqle2A==
X-Google-Smtp-Source: ADFU+vti1QMwOqAdl+gaxBXKBzLkewg0+Axr05e9r2mxkQ8EUGr/8S/DnP48kOLNivRmNJ7kFTFSGQ==
X-Received: by 2002:a37:61d0:: with SMTP id v199mr6669980qkb.292.1585684939953;
        Tue, 31 Mar 2020 13:02:19 -0700 (PDT)
Received: from bbking.lan ([2804:14c:4a5:36c::cd2])
        by smtp.gmail.com with ESMTPSA id t43sm14488528qtc.14.2020.03.31.13.02.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 31 Mar 2020 13:02:19 -0700 (PDT)
Message-ID: <953a450cf58e2a459f7a09267cbbbcd38e5cc6bc.camel@massaru.org>
Subject: Re: [PATCH 5.6 00/23] 5.6.1-rc1 review
From:   Vitor Massaru Iha <vitor@massaru.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org,
        "linux-kernel-mentees@lists.linuxfoundation.org" 
        <linux-kernel-mentees@lists.linuxfoundation.org>,
        skhan@linuxfoundation.org
Date:   Tue, 31 Mar 2020 17:02:14 -0300
In-Reply-To: <20200331085308.098696461@linuxfoundation.org>
References: <20200331085308.098696461@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.5 (3.32.5-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2020-03-31 at 10:59 +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.1 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied,
> please
> let me know.
> 
> Responses should be made by Thu, 02 Apr 2020 08:50:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	
> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-
> stable-rc.git linux-5.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.6.1-rc1
> 
> Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
>     media: v4l2-core: fix a use-after-free bug of sd->devnode
> 
> Johan Hovold <johan@kernel.org>
>     media: xirlink_cit: add missing descriptor sanity checks
> 
> Johan Hovold <johan@kernel.org>
>     media: stv06xx: add missing descriptor sanity checks
> 
> Johan Hovold <johan@kernel.org>
>     media: dib0700: fix rc endpoint lookup
> 
> Johan Hovold <johan@kernel.org>
>     media: ov519: add missing endpoint sanity checks
> 
> Eric Biggers <ebiggers@google.com>
>     libfs: fix infoleak in simple_attr_read()
> 
> Kai-Heng Feng <kai.heng.feng@canonical.com>
>     ahci: Add Intel Comet Lake H RAID PCI ID
> 
> Michał Mirosław <mirq-linux@rere.qmqm.pl>
>     staging: wfx: annotate nested gc_list vs tx queue locking
> 
> Michał Mirosław <mirq-linux@rere.qmqm.pl>
>     staging: wfx: fix init/remove vs IRQ race
> 
> Michał Mirosław <mirq-linux@rere.qmqm.pl>
>     staging: wfx: add proper "compatible" string
> 
> Qiujun Huang <hqjagain@gmail.com>
>     staging: wlan-ng: fix use-after-free Read in
> hfa384x_usbin_callback
> 
> Qiujun Huang <hqjagain@gmail.com>
>     staging: wlan-ng: fix ODEBUG bug in prism2sta_disconnect_usb
> 
> Larry Finger <Larry.Finger@lwfinger.net>
>     staging: rtl8188eu: Add ASUS USB-N10 Nano B1 to device table
> 
> Dan Carpenter <dan.carpenter@oracle.com>
>     staging: kpc2000: prevent underflow in cpld_reconfigure()
> 
> Johan Hovold <johan@kernel.org>
>     media: usbtv: fix control-message timeouts
> 
> Johan Hovold <johan@kernel.org>
>     media: flexcop-usb: fix endpoint sanity check
> 
> Mans Rullgard <mans@mansr.com>
>     usb: musb: fix crash with highmen PIO and usbmon
> 
> Qiujun Huang <hqjagain@gmail.com>
>     USB: serial: io_edgeport: fix slab-out-of-bounds read in
> edge_interrupt_callback
> 
> Matthias Reichl <hias@horus.com>
>     USB: cdc-acm: restore capability check order
> 
> Pawel Dembicki <paweldembicki@gmail.com>
>     USB: serial: option: add Wistron Neweb D19Q1
> 
> Pawel Dembicki <paweldembicki@gmail.com>
>     USB: serial: option: add BroadMobi BM806U
> 
> Pawel Dembicki <paweldembicki@gmail.com>
>     USB: serial: option: add support for ASKEY WWHC050
> 
> Daniel Borkmann <daniel@iogearbox.net>
>     bpf: Undo incorrect __reg_bound_offset32 handling
> 
> 
> -------------
> 
> Diffstat:
> 
>  Makefile                                           |  4 +--
>  drivers/ata/ahci.c                                 |  1 +
>  drivers/media/usb/b2c2/flexcop-usb.c               |  6 ++--
>  drivers/media/usb/dvb-usb/dib0700_core.c           |  4 +--
>  drivers/media/usb/gspca/ov519.c                    | 10 ++++++
>  drivers/media/usb/gspca/stv06xx/stv06xx.c          | 19 +++++++++-
>  drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c   |  4 +++
>  drivers/media/usb/gspca/xirlink_cit.c              | 18 +++++++++-
>  drivers/media/usb/usbtv/usbtv-core.c               |  2 +-
>  drivers/media/usb/usbtv/usbtv-video.c              |  5 +--
>  drivers/media/v4l2-core/v4l2-device.c              |  1 +
>  drivers/staging/kpc2000/kpc2000/core.c             |  4 +--
>  drivers/staging/rtl8188eu/os_dep/usb_intf.c        |  1 +
>  .../bindings/net/wireless/siliabs,wfx.txt          |  7 ++--
>  drivers/staging/wfx/bus_sdio.c                     | 15 ++++----
>  drivers/staging/wfx/bus_spi.c                      | 41
> +++++++++++++---------
>  drivers/staging/wfx/main.c                         | 21 ++++++-----
>  drivers/staging/wfx/main.h                         |  1 -
>  drivers/staging/wfx/queue.c                        | 16 ++++-----
>  drivers/staging/wlan-ng/hfa384x_usb.c              |  2 ++
>  drivers/staging/wlan-ng/prism2usb.c                |  1 +
>  drivers/usb/class/cdc-acm.c                        | 18 +++++-----
>  drivers/usb/musb/musb_host.c                       | 17 +++------
>  drivers/usb/serial/io_edgeport.c                   |  2 +-
>  drivers/usb/serial/option.c                        |  6 ++++
>  fs/libfs.c                                         |  8 +++--
>  kernel/bpf/verifier.c                              | 19 ----------
>  27 files changed, 149 insertions(+), 104 deletions(-)
> 
> 

Compiled, booted, and no regressions on my machine.

BR,
Vitor

