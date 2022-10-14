Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 817405FEDF1
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 14:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbiJNMXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 08:23:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229581AbiJNMXH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 08:23:07 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8B131CC75D;
        Fri, 14 Oct 2022 05:23:06 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id o17-20020a17090aac1100b0020d98b0c0f4so6390589pjq.4;
        Fri, 14 Oct 2022 05:23:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=V6AkhIKtWrcZ5eSbP2tIo5/S0hKQmPOZyaUq/gsVss4=;
        b=Zeskzt3usWzckFQ8nQKHkjEufJK80Bb2tBdNjmRZFd0SJX05APqMjSoBRM271jS4YG
         H9zDwVZ8lRghoCuyTZbke4vAkWZemiYa8UyI7zgSSV0oU9KmQKrpm9n4cmHH6oMgd85M
         m0Z1daVD4ZYVBWYZc6KnAwNJGrrctdk5rCPyvVf1v9FxzvCA/HwJZbZwtGHsaNGINJqi
         E1HqbYTBBGRsZ1+zyKffn10sdHnaKJIC5DZliph4lntSuhkcy6jQQkLS7GoRHQnd4qA9
         nrx1IZXANeRra4PIXu7lsaXZqiNJbZjblJP0VZBGjptuJlNfvLGXcIzpiY9tLQIFOkf2
         XmPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:references:in-reply-to
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=V6AkhIKtWrcZ5eSbP2tIo5/S0hKQmPOZyaUq/gsVss4=;
        b=h6vDohqFDpouDck2wlDBf8bwA/pozQqZJDbqfmKkRws5RKuCGG6QnvvKAO+LTRJ1Cf
         I4C8BgrcImrqX2W052InPGfUOnVIwy81CnTeGwyGn+heKme6J4F5DMLV/5ms0Q8XdneH
         tgSiWmS7TYdIMcXwviJLbbGTF3f0psSRC7auRxggZYQZKS8LoGpv1Z+pPYZ374udCTS/
         zTbrShU1skD7F1Lnyk1d9yXLkbRatKvhW2xneaNb5k+eEvEvtsJ/1lbl/DCO1t97PjzF
         pbykeIuk/3OaTwGBujK3WBeE0sg2UUTda2HTlyse/rgIWFgsr1EqvmG5YeIXIkB3MbjZ
         mWuw==
X-Gm-Message-State: ACrzQf0DH+Psd1lDRXhunx4wjEF4o253hbqdxoEZ9cTj24ACs7hwYQhp
        Rx4jfEZTSgLwO8w7iN1NJ+7E4CFTiWxoMAYnpjA=
X-Google-Smtp-Source: AMsMyM5QAysmvbv74GkbZQ40SjKXJSxAIW3nzS25w7jRYkcZVEdPN8nNNZK+pbmXtPRbinbc8qxj4sudbmVlRYvKKWI=
X-Received: by 2002:a17:902:d50f:b0:178:6505:fae3 with SMTP id
 b15-20020a170902d50f00b001786505fae3mr5041222plg.54.1665750186130; Fri, 14
 Oct 2022 05:23:06 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:7022:249f:b0:45:6892:6b88 with HTTP; Fri, 14 Oct 2022
 05:23:05 -0700 (PDT)
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
References: <20221013175146.507746257@linuxfoundation.org>
From:   Luna Jernberg <droidbittin@gmail.com>
Date:   Fri, 14 Oct 2022 14:23:05 +0200
Message-ID: <CADo9pHhS3gDjkBA=hEJv_pD1zpJ05Mm2e8oNsxBAFzArQ4KnKg@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/34] 6.0.2-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        droidbittin@gmail.com
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Works fine on my Arch Linux Server with Intel(R) Core(TM) i5-6400 CPU @ 2.70GHz

Tested-by: Luna Jernberg <droidbittin@gmail.com>

On 10/13/22, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 6.0.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> linux-6.0.y
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
>     Linux 6.0.2-rc1
>
> Shunsuke Mie <mie@igel.co.jp>
>     misc: pci_endpoint_test: Fix pci_endpoint_test_{copy,write,read}()
> panic
>
> Shunsuke Mie <mie@igel.co.jp>
>     misc: pci_endpoint_test: Aggregate params checking for xfer
>
> Cameron Gutman <aicommander@gmail.com>
>     Input: xpad - fix wireless 360 controller breaking after suspend
>
> Pavel Rojtberg <rojtberg@gmail.com>
>     Input: xpad - add supported devices as contributed on github
>
> Jeremy Kerr <jk@codeconstruct.com.au>
>     mctp: prevent double key removal and unref
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: cfg80211: update hidden BSSes to avoid WARN_ON
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: fix crash in beacon protection for P2P-device
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211_hwsim: avoid mac80211 warning on bad rate
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: cfg80211: avoid nontransmitted BSS list corruption
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: cfg80211: fix BSS refcounting bugs
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: cfg80211: ensure length byte is present before access
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: mac80211: fix MBSSID parsing use-after-free
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: cfg80211/mac80211: reject bad MBSSID elements
>
> Johannes Berg <johannes.berg@intel.com>
>     wifi: cfg80211: fix u8 overflow in cfg80211_update_notlisted_nontrans()
>
> Jason A. Donenfeld <Jason@zx2c4.com>
>     random: use expired timer rather than wq for mixing fast pool
>
> Jason A. Donenfeld <Jason@zx2c4.com>
>     random: avoid reading two cache lines on irq randomness
>
> Giovanni Cabiddu <giovanni.cabiddu@intel.com>
>     Revert "crypto: qat - reduce size of mapped region"
>
> Nathan Lynch <nathanl@linux.ibm.com>
>     Revert "powerpc/rtas: Implement reentrant rtas call"
>
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     Revert "usb: dwc3: Don't switch OTG -> peripheral if extcon is present"
>
> Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>     Revert "USB: fixup for merge issue with "usb: dwc3: Don't switch OTG ->
> peripheral if extcon is present""
>
> Frank Wunderlich <frank-w@public-files.de>
>     USB: serial: qcserial: add new usb-id for Dell branded EM7455
>
> Linus Torvalds <torvalds@linux-foundation.org>
>     scsi: stex: Properly zero out the passthrough command structure
>
> Arun Easi <aeasi@marvell.com>
>     scsi: qla2xxx: Fix response queue handler reading stale packets
>
> Arun Easi <aeasi@marvell.com>
>     scsi: qla2xxx: Revert "scsi: qla2xxx: Fix response queue handler reading
> stale packets"
>
> Orlando Chamberlain <redecorating@protonmail.com>
>     efi: Correct Macmini DMI match in uefi cert quirk
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda/realtek: Add quirk for HP Zbook Firefly 14 G9 model
>
> Takashi Iwai <tiwai@suse.de>
>     ALSA: hda: Fix position reporting on Poulsbo
>
> Jason A. Donenfeld <Jason@zx2c4.com>
>     random: clamp credited irq bits to maximum mixed
>
> Jason A. Donenfeld <Jason@zx2c4.com>
>     random: restore O_NONBLOCK support
>
> Rishabh Bhatnagar <risbhat@amazon.com>
>     nvme-pci: set min_align_mask before calculating max_hw_sectors
>
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>     nilfs2: replace WARN_ONs by nilfs_error for checkpoint acquisition
> failure
>
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>     nilfs2: fix leak of nilfs_root in case of writer thread creation
> failure
>
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>     nilfs2: fix use-after-free bug of struct nilfs_root
>
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>     nilfs2: fix NULL pointer dereference at nilfs_bmap_lookup_at_level()
>
>
> -------------
>
> Diffstat:
>
>  Makefile                                      |  4 +-
>  arch/powerpc/include/asm/paca.h               |  1 -
>  arch/powerpc/include/asm/rtas.h               |  1 -
>  arch/powerpc/kernel/paca.c                    | 32 -----------
>  arch/powerpc/kernel/rtas.c                    | 54 -------------------
>  arch/powerpc/sysdev/xics/ics-rtas.c           | 22 ++++----
>  drivers/char/mem.c                            |  4 +-
>  drivers/char/random.c                         | 25 ++++++---
>  drivers/crypto/qat/qat_common/qat_asym_algs.c | 12 ++---
>  drivers/input/joystick/xpad.c                 | 20 ++++++-
>  drivers/misc/pci_endpoint_test.c              | 34 +++++++++---
>  drivers/net/wireless/mac80211_hwsim.c         |  2 +
>  drivers/nvme/host/pci.c                       |  3 +-
>  drivers/scsi/qla2xxx/qla_gbl.h                |  2 -
>  drivers/scsi/qla2xxx/qla_isr.c                | 22 +++-----
>  drivers/scsi/qla2xxx/qla_os.c                 | 10 ----
>  drivers/scsi/stex.c                           | 17 +++---
>  drivers/usb/dwc3/core.c                       | 50 +----------------
>  drivers/usb/dwc3/drd.c                        | 50 +++++++++++++++++
>  drivers/usb/serial/qcserial.c                 |  1 +
>  fs/nilfs2/inode.c                             | 19 ++++++-
>  fs/nilfs2/segment.c                           | 21 +++++---
>  include/scsi/scsi_cmnd.h                      |  2 +-
>  net/mac80211/ieee80211_i.h                    |  8 +++
>  net/mac80211/rx.c                             | 12 +++--
>  net/mac80211/util.c                           | 32 +++++------
>  net/mctp/af_mctp.c                            | 23 +++++---
>  net/mctp/route.c                              | 10 ++--
>  net/wireless/scan.c                           | 77
> +++++++++++++++++----------
>  security/integrity/platform_certs/load_uefi.c |  2 +-
>  sound/pci/hda/hda_intel.c                     |  3 +-
>  sound/pci/hda/patch_realtek.c                 | 18 +++++++
>  32 files changed, 313 insertions(+), 280 deletions(-)
>
>
>
