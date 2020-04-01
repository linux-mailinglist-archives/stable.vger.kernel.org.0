Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3F1819AEF0
	for <lists+stable@lfdr.de>; Wed,  1 Apr 2020 17:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732877AbgDAPkv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Apr 2020 11:40:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:59504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732861AbgDAPkv (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Apr 2020 11:40:51 -0400
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net [24.9.64.241])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D353212CC;
        Wed,  1 Apr 2020 15:40:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585755650;
        bh=55DIQUMPnN3dUhv747Rs4JVQiYpVrBL9TjR0jiURsaI=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=ugbwDSle2bptSQOpzxRPCOJl3PA7exzHP6Pm6ABjBZ4TJaBS5OP9LONr23TCltZos
         gQCzmHyvKDJVb00PlkM/XdNK9lBGas3sd24/yXTiDO8YxwfTugQuPjRlAoIlxGiCgb
         Zzts3AxAUccM4LeOQ6k9v+TEPAQyiraFDEaK1DR8=
Subject: Re: [PATCH 5.6 00/23] 5.6.1-rc1 review
To:     Woody Suwalski <terraluna977@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, shuah <shuah@kernel.org>
References: <20200331085308.098696461@linuxfoundation.org>
 <6cdfe0e5-408f-2d88-cb08-c7675d78637c@gmail.com>
From:   shuah <shuah@kernel.org>
Message-ID: <9762570c-c83f-10d4-ecec-0d0427c2d2a3@kernel.org>
Date:   Wed, 1 Apr 2020 09:40:31 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <6cdfe0e5-408f-2d88-cb08-c7675d78637c@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 3/31/20 9:06 PM, Woody Suwalski wrote:
> Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.6.1 release.
>> There are 23 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Thu, 02 Apr 2020 08:50:37 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.1-rc1.gz 
>>
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>> linux-5.6.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
>> -------------
>> Pseudo-Shortlog of commits:
>>
>> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>      Linux 5.6.1-rc1
>>
>> Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
>>      media: v4l2-core: fix a use-after-free bug of sd->devnode
>>
>> Johan Hovold <johan@kernel.org>
>>      media: xirlink_cit: add missing descriptor sanity checks
>>
>> Johan Hovold <johan@kernel.org>
>>      media: stv06xx: add missing descriptor sanity checks
>>
>> Johan Hovold <johan@kernel.org>
>>      media: dib0700: fix rc endpoint lookup
>>
>> Johan Hovold <johan@kernel.org>
>>      media: ov519: add missing endpoint sanity checks
>>
>> Eric Biggers <ebiggers@google.com>
>>      libfs: fix infoleak in simple_attr_read()
>>
>> Kai-Heng Feng <kai.heng.feng@canonical.com>
>>      ahci: Add Intel Comet Lake H RAID PCI ID
>>
>> Michał Mirosław <mirq-linux@rere.qmqm.pl>
>>      staging: wfx: annotate nested gc_list vs tx queue locking
>>
>> Michał Mirosław <mirq-linux@rere.qmqm.pl>
>>      staging: wfx: fix init/remove vs IRQ race
>>
>> Michał Mirosław <mirq-linux@rere.qmqm.pl>
>>      staging: wfx: add proper "compatible" string
>>
>> Qiujun Huang <hqjagain@gmail.com>
>>      staging: wlan-ng: fix use-after-free Read in hfa384x_usbin_callback
>>
>> Qiujun Huang <hqjagain@gmail.com>
>>      staging: wlan-ng: fix ODEBUG bug in prism2sta_disconnect_usb
>>
>> Larry Finger <Larry.Finger@lwfinger.net>
>>      staging: rtl8188eu: Add ASUS USB-N10 Nano B1 to device table
>>
>> Dan Carpenter <dan.carpenter@oracle.com>
>>      staging: kpc2000: prevent underflow in cpld_reconfigure()
>>
>> Johan Hovold <johan@kernel.org>
>>      media: usbtv: fix control-message timeouts
>>
>> Johan Hovold <johan@kernel.org>
>>      media: flexcop-usb: fix endpoint sanity check
>>
>> Mans Rullgard <mans@mansr.com>
>>      usb: musb: fix crash with highmen PIO and usbmon
>>
>> Qiujun Huang <hqjagain@gmail.com>
>>      USB: serial: io_edgeport: fix slab-out-of-bounds read in 
>> edge_interrupt_callback
>>
>> Matthias Reichl <hias@horus.com>
>>      USB: cdc-acm: restore capability check order
>>
>> Pawel Dembicki <paweldembicki@gmail.com>
>>      USB: serial: option: add Wistron Neweb D19Q1
>>
>> Pawel Dembicki <paweldembicki@gmail.com>
>>      USB: serial: option: add BroadMobi BM806U
>>
>> Pawel Dembicki <paweldembicki@gmail.com>
>>      USB: serial: option: add support for ASKEY WWHC050
>>
>> Daniel Borkmann <daniel@iogearbox.net>
>>      bpf: Undo incorrect __reg_bound_offset32 handling
>>
>>
>> -------------
>>
>> Diffstat:
>>
>>   Makefile                                           |  4 +--
>>   drivers/ata/ahci.c                                 |  1 +
>>   drivers/media/usb/b2c2/flexcop-usb.c               |  6 ++--
>>   drivers/media/usb/dvb-usb/dib0700_core.c           |  4 +--
>>   drivers/media/usb/gspca/ov519.c                    | 10 ++++++
>>   drivers/media/usb/gspca/stv06xx/stv06xx.c          | 19 +++++++++-
>>   drivers/media/usb/gspca/stv06xx/stv06xx_pb0100.c   |  4 +++
>>   drivers/media/usb/gspca/xirlink_cit.c              | 18 +++++++++-
>>   drivers/media/usb/usbtv/usbtv-core.c               |  2 +-
>>   drivers/media/usb/usbtv/usbtv-video.c              |  5 +--
>>   drivers/media/v4l2-core/v4l2-device.c              |  1 +
>>   drivers/staging/kpc2000/kpc2000/core.c             |  4 +--
>>   drivers/staging/rtl8188eu/os_dep/usb_intf.c        |  1 +
>>   .../bindings/net/wireless/siliabs,wfx.txt          |  7 ++--
>>   drivers/staging/wfx/bus_sdio.c                     | 15 ++++----
>>   drivers/staging/wfx/bus_spi.c                      | 41 
>> +++++++++++++---------
>>   drivers/staging/wfx/main.c                         | 21 ++++++-----
>>   drivers/staging/wfx/main.h                         |  1 -
>>   drivers/staging/wfx/queue.c                        | 16 ++++-----
>>   drivers/staging/wlan-ng/hfa384x_usb.c              |  2 ++
>>   drivers/staging/wlan-ng/prism2usb.c                |  1 +
>>   drivers/usb/class/cdc-acm.c                        | 18 +++++-----
>>   drivers/usb/musb/musb_host.c                       | 17 +++------
>>   drivers/usb/serial/io_edgeport.c                   |  2 +-
>>   drivers/usb/serial/option.c                        |  6 ++++
>>   fs/libfs.c                                         |  8 +++--
>>   kernel/bpf/verifier.c                              | 19 ----------
>>   27 files changed, 149 insertions(+), 104 deletions(-)
>>
>>
> I think you have missed the
> https://git.kernel.org/pub/scm/linux/kernel/git/netdev/net.git/commit/?id=be8c827f50a0bcd56361b31ada11dc0a3c2fd240 
> 
> 
> Without it 5.6 is completely broken on iwlwifi.
> 

I am seeing this on my primary laptop with Linux 5.6. I switched
back to Linux 5.6-rc7 for now. Is this issue introduced in 5.6
when Dave's networking pull? 5.6-rc7 is just fine.

wifi authentication keeps on failing and can't connect at all.

Just about to report this for 5.6 and saw this thread.

thanks,
-- Shuah


