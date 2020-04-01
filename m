Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C77119A3C5
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 05:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731680AbgDADGU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 23:06:20 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42474 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731554AbgDADGT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Mar 2020 23:06:19 -0400
Received: by mail-qt1-f195.google.com with SMTP id t9so20449278qto.9;
        Tue, 31 Mar 2020 20:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding;
        bh=CTCfa1W35Oc7sDfr9TwTYrOwaj81GSfGfT3RVFEhg1o=;
        b=R0lPMT/tq1g9OgNl9wLoCJrGyJWRuHsdF6cnIDlh1yvebdw0XGUDyodU4V8KP9Sq4I
         YKv3FiUl6cNY4UCkp8mR2Wt8wfU+WqNSmuUEF+EDqBboc9w/RMpBL5WrcbJnuTcAOlND
         +5Vq+se2dtDALPb5pFMCplNmclKDld4TmMszl8qpI3RVb72Ugo1PmLBWmL79nuqPAMa4
         I0V0Q7tDnwlqT4eZERzjR6Ur68pL2SMfBuj/GC0iH13WYR220z0qKYhkEjpCpC9pRgoE
         O43ZCk+fSbPsziHhyOeAr76yKfC8KLzjmHKCPb5VvsL9tTC+luZAtLHfgcA621vMMYJC
         JgcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding;
        bh=CTCfa1W35Oc7sDfr9TwTYrOwaj81GSfGfT3RVFEhg1o=;
        b=Ld8BULMisyt0Z+zC4Vv3EnrvxKwJZ+YSBdn/GujXN3z8JnOdHAzDLlv0Ii5EgwmfYq
         FtnuwcU3dH4WPcOLc1hdnBmGZBUlswEFYZUN+pq/omCRca1CtmLVCCZ9qnK4OO2NSQg3
         HLcK4a9OwwqOQkOHZGbOJejyxYJeCMOxxb38gtDuj928l/UMKpl26WdORrulIGZO+2/a
         QUQFawCeYvEoUnXZmnhT6rMZZiFmKE3gbA69U30t2hR3mAkLJs3SYqZjV1BojclW10En
         bL2uEugS787xgaoN5wN/H4T7ejSKgGhisNq2SWmlJ84g9L2ReorxRnU1UzpRsQWXUJhy
         NVUw==
X-Gm-Message-State: ANhLgQ0gNSBXcYY7Ft3qM4WGXZ1Uk63CMkzlW6wclZ2MjI7DrXWsjQFD
        hsDnTkArVuYD3UHKNcAOhDSP1+OFzDZ8
X-Google-Smtp-Source: ADFU+vt5CF4RVP7oYpSoYFpxD2EQ24jNbHllQ71wiLqdMNUhmmSTaApmj0pYh87G1dxgRCvevv07bw==
X-Received: by 2002:ac8:376d:: with SMTP id p42mr8510918qtb.378.1585710378432;
        Tue, 31 Mar 2020 20:06:18 -0700 (PDT)
Received: from [120.7.1.38] ([184.175.21.212])
        by smtp.gmail.com with ESMTPSA id p191sm622848qke.6.2020.03.31.20.06.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 31 Mar 2020 20:06:17 -0700 (PDT)
Subject: Re: [PATCH 5.6 00/23] 5.6.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
References: <20200331085308.098696461@linuxfoundation.org>
From:   Woody Suwalski <terraluna977@gmail.com>
Message-ID: <6cdfe0e5-408f-2d88-cb08-c7675d78637c@gmail.com>
Date:   Tue, 31 Mar 2020 23:06:16 -0400
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:60.0) Gecko/20100101 Firefox/60.0
 SeaMonkey/2.53.1
MIME-Version: 1.0
In-Reply-To: <20200331085308.098696461@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.6.1 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Apr 2020 08:50:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
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
>      Linux 5.6.1-rc1
>
> Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
>      media: v4l2-core: fix a use-after-free bug of sd->devnode
>
> Johan Hovold <johan@kernel.org>
>      media: xirlink_cit: add missing descriptor sanity checks
>
> Johan Hovold <johan@kernel.org>
>      media: stv06xx: add missing descriptor sanity checks
>
> Johan Hovold <johan@kernel.org>
>      media: dib0700: fix rc endpoint lookup
>
> Johan Hovold <johan@kernel.org>
>      media: ov519: add missing endpoint sanity checks
>
> Eric Biggers <ebiggers@google.com>
>      libfs: fix infoleak in simple_attr_read()
>
> Kai-Heng Feng <kai.heng.feng@canonical.com>
>      ahci: Add Intel Comet Lake H RAID PCI ID
>
> Michał Mirosław <mirq-linux@rere.qmqm.pl>
>      staging: wfx: annotate nested gc_list vs tx queue locking
>
> Michał Mirosław <mirq-linux@rere.qmqm.pl>
>      staging: wfx: fix init/remove vs IRQ race
>
> Michał Mirosław <mirq-linux@rere.qmqm.pl>
>      staging: wfx: add proper "compatible" string
>
> Qiujun Huang <hqjagain@gmail.com>
>      staging: wlan-ng: fix use-after-free Read in hfa384x_usbin_callback
>
> Qiujun Huang <hqjagain@gmail.com>
>      staging: wlan-ng: fix ODEBUG bug in prism2sta_disconnect_usb
>
> Larry Finger <Larry.Finger@lwfinger.net>
>      staging: rtl8188eu: Add ASUS USB-N10 Nano B1 to device table
>
> Dan Carpenter <dan.carpenter@oracle.com>
>      staging: kpc2000: prevent underflow in cpld_reconfigure()
>
> Johan Hovold <johan@kernel.org>
>      media: usbtv: fix control-message timeouts
>
> Johan Hovold <johan@kernel.org>
>      media: flexcop-usb: fix endpoint sanity check
>
> Mans Rullgard <mans@mansr.com>
>      usb: musb: fix crash with highmen PIO and usbmon
>
> Qiujun Huang <hqjagain@gmail.com>
>      USB: serial: io_edgeport: fix slab-out-of-bounds read in edge_interrupt_callback
>
> Matthias Reichl <hias@horus.com>
>      USB: cdc-acm: restore capability check order
>
> Pawel Dembicki <paweldembicki@gmail.com>
>      USB: serial: option: add Wistron Neweb D19Q1
>
> Pawel Dembicki <paweldembicki@gmail.com>
>      USB: serial: option: add BroadMobi BM806U
>
> Pawel Dembicki <paweldembicki@gmail.com>
>      USB: serial: option: add support for ASKEY WWHC050
>
> Daniel Borkmann <daniel@iogearbox.net>
>      bpf: Undo incorrect __reg_bound_offset32 handling
>
>
> -------------
>
> Diffstat:
>
>   Makefile                                           |  4 +--
>   drivers/ata/ahci.c                                 |  1 +
>   drivers/media/usb/b2c2/flexcop-usb.c               |  6 ++--
>   drivers/media/usb/dvb-usb/dib0700_core.c           |  4 +--
>   drivers/media/usb/gspca/ov519.c                    | 10 ++++++
>   drivers/media/usb/gspca/stv06xx/stv06xx.c          | 19 +++++++++-
>   drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c   |  4 +++
>   drivers/media/usb/gspca/xirlink_cit.c              | 18 +++++++++-
>   drivers/media/usb/usbtv/usbtv-core.c               |  2 +-
>   drivers/media/usb/usbtv/usbtv-video.c              |  5 +--
>   drivers/media/v4l2-core/v4l2-device.c              |  1 +
>   drivers/staging/kpc2000/kpc2000/core.c             |  4 +--
>   drivers/staging/rtl8188eu/os_dep/usb_intf.c        |  1 +
>   .../bindings/net/wireless/siliabs,wfx.txt          |  7 ++--
>   drivers/staging/wfx/bus_sdio.c                     | 15 ++++----
>   drivers/staging/wfx/bus_spi.c                      | 41 +++++++++++++---------
>   drivers/staging/wfx/main.c                         | 21 ++++++-----
>   drivers/staging/wfx/main.h                         |  1 -
>   drivers/staging/wfx/queue.c                        | 16 ++++-----
>   drivers/staging/wlan-ng/hfa384x_usb.c              |  2 ++
>   drivers/staging/wlan-ng/prism2usb.c                |  1 +
>   drivers/usb/class/cdc-acm.c                        | 18 +++++-----
>   drivers/usb/musb/musb_host.c                       | 17 +++------
>   drivers/usb/serial/io_edgeport.c                   |  2 +-
>   drivers/usb/serial/option.c                        |  6 ++++
>   fs/libfs.c                                         |  8 +++--
>   kernel/bpf/verifier.c                              | 19 ----------
>   27 files changed, 149 insertions(+), 104 deletions(-)
>
>
I think you have missed the
https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=be8c827f50a0bcd56361b31ada11dc0a3c2fd240

Without it 5.6 is completely broken on iwlwifi.

Thanks, Woody

