Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E1685FE10E
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 20:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbiJMSYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 14:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231664AbiJMSXP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 14:23:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0AF018981F;
        Thu, 13 Oct 2022 11:18:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8D6BC619F6;
        Thu, 13 Oct 2022 18:02:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DBF6C433C1;
        Thu, 13 Oct 2022 18:02:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665684137;
        bh=E6tcvzlk1MkFf2n9tPgpDzOMWqmE4SkDvRihwIWDNCs=;
        h=From:To:Cc:Subject:Date:From;
        b=Q4EltmPbXqXtu+8+kOxIJUL+x/DaqpvsSwOqPZTQscMstK3EkbT0TKTx2+SnJ4gfz
         TPm4m704a15TuyFm4Vc9gmuFE4tdexGD7SQbvnwyUKqPkC/QKLi6xpI3L9XoWq4ohb
         6d1BoGyBVWceWe0ZFtEF2qvLw2VDsGrHyu4iwaIg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 6.0 00/34] 6.0.2-rc1 review
Date:   Thu, 13 Oct 2022 19:52:38 +0200
Message-Id: <20221013175146.507746257@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.2-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.0.2-rc1
X-KernelTest-Deadline: 2022-10-15T17:51+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 6.0.2 release.
There are 34 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.2-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.0.2-rc1

Shunsuke Mie <mie@igel.co.jp>
    misc: pci_endpoint_test: Fix pci_endpoint_test_{copy,write,read}() panic

Shunsuke Mie <mie@igel.co.jp>
    misc: pci_endpoint_test: Aggregate params checking for xfer

Cameron Gutman <aicommander@gmail.com>
    Input: xpad - fix wireless 360 controller breaking after suspend

Pavel Rojtberg <rojtberg@gmail.com>
    Input: xpad - add supported devices as contributed on github

Jeremy Kerr <jk@codeconstruct.com.au>
    mctp: prevent double key removal and unref

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: update hidden BSSes to avoid WARN_ON

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix crash in beacon protection for P2P-device

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211_hwsim: avoid mac80211 warning on bad rate

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: avoid nontransmitted BSS list corruption

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: fix BSS refcounting bugs

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: ensure length byte is present before access

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix MBSSID parsing use-after-free

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211/mac80211: reject bad MBSSID elements

Johannes Berg <johannes.berg@intel.com>
    wifi: cfg80211: fix u8 overflow in cfg80211_update_notlisted_nontrans()

Jason A. Donenfeld <Jason@zx2c4.com>
    random: use expired timer rather than wq for mixing fast pool

Jason A. Donenfeld <Jason@zx2c4.com>
    random: avoid reading two cache lines on irq randomness

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    Revert "crypto: qat - reduce size of mapped region"

Nathan Lynch <nathanl@linux.ibm.com>
    Revert "powerpc/rtas: Implement reentrant rtas call"

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    Revert "usb: dwc3: Don't switch OTG -> peripheral if extcon is present"

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    Revert "USB: fixup for merge issue with "usb: dwc3: Don't switch OTG -> peripheral if extcon is present""

Frank Wunderlich <frank-w@public-files.de>
    USB: serial: qcserial: add new usb-id for Dell branded EM7455

Linus Torvalds <torvalds@linux-foundation.org>
    scsi: stex: Properly zero out the passthrough command structure

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix response queue handler reading stale packets

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Revert "scsi: qla2xxx: Fix response queue handler reading stale packets"

Orlando Chamberlain <redecorating@protonmail.com>
    efi: Correct Macmini DMI match in uefi cert quirk

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Add quirk for HP Zbook Firefly 14 G9 model

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix position reporting on Poulsbo

Jason A. Donenfeld <Jason@zx2c4.com>
    random: clamp credited irq bits to maximum mixed

Jason A. Donenfeld <Jason@zx2c4.com>
    random: restore O_NONBLOCK support

Rishabh Bhatnagar <risbhat@amazon.com>
    nvme-pci: set min_align_mask before calculating max_hw_sectors

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: replace WARN_ONs by nilfs_error for checkpoint acquisition failure

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix leak of nilfs_root in case of writer thread creation failure

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix use-after-free bug of struct nilfs_root

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix NULL pointer dereference at nilfs_bmap_lookup_at_level()


-------------

Diffstat:

 Makefile                                      |  4 +-
 arch/powerpc/include/asm/paca.h               |  1 -
 arch/powerpc/include/asm/rtas.h               |  1 -
 arch/powerpc/kernel/paca.c                    | 32 -----------
 arch/powerpc/kernel/rtas.c                    | 54 -------------------
 arch/powerpc/sysdev/xics/ics-rtas.c           | 22 ++++----
 drivers/char/mem.c                            |  4 +-
 drivers/char/random.c                         | 25 ++++++---
 drivers/crypto/qat/qat_common/qat_asym_algs.c | 12 ++---
 drivers/input/joystick/xpad.c                 | 20 ++++++-
 drivers/misc/pci_endpoint_test.c              | 34 +++++++++---
 drivers/net/wireless/mac80211_hwsim.c         |  2 +
 drivers/nvme/host/pci.c                       |  3 +-
 drivers/scsi/qla2xxx/qla_gbl.h                |  2 -
 drivers/scsi/qla2xxx/qla_isr.c                | 22 +++-----
 drivers/scsi/qla2xxx/qla_os.c                 | 10 ----
 drivers/scsi/stex.c                           | 17 +++---
 drivers/usb/dwc3/core.c                       | 50 +----------------
 drivers/usb/dwc3/drd.c                        | 50 +++++++++++++++++
 drivers/usb/serial/qcserial.c                 |  1 +
 fs/nilfs2/inode.c                             | 19 ++++++-
 fs/nilfs2/segment.c                           | 21 +++++---
 include/scsi/scsi_cmnd.h                      |  2 +-
 net/mac80211/ieee80211_i.h                    |  8 +++
 net/mac80211/rx.c                             | 12 +++--
 net/mac80211/util.c                           | 32 +++++------
 net/mctp/af_mctp.c                            | 23 +++++---
 net/mctp/route.c                              | 10 ++--
 net/wireless/scan.c                           | 77 +++++++++++++++++----------
 security/integrity/platform_certs/load_uefi.c |  2 +-
 sound/pci/hda/hda_intel.c                     |  3 +-
 sound/pci/hda/patch_realtek.c                 | 18 +++++++
 32 files changed, 313 insertions(+), 280 deletions(-)


