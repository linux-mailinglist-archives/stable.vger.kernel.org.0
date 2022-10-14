Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588E55FEA7E
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 10:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbiJNIZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 04:25:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiJNIZu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 04:25:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB5E1C19ED;
        Fri, 14 Oct 2022 01:25:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7A16761A41;
        Fri, 14 Oct 2022 08:25:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501D8C433D6;
        Fri, 14 Oct 2022 08:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665735947;
        bh=3tECuhA0ozpVGqihRCRiN9MiLJneF8ElEi85kAbgxAE=;
        h=From:To:Cc:Subject:Date:From;
        b=BXC83EdfJrbbEt9Ps8FPo8QoCBcosRGswj9po1rnmKHzAK0jxSkVfBZjIExGoIoFq
         PtALSR9x9hpKAqg6wWjpE/RHmjBAEzQHqC7h3nR+hzwdXoQBnq2nQ2ywNuUGvb1Tcn
         5R9A811XVW+4X8AdrQIo1f1em+COzwpjIj0ixYUk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
Subject: [PATCH 5.15 00/33] 5.15.74-rc2 review
Date:   Fri, 14 Oct 2022 10:26:31 +0200
Message-Id: <20221014082515.704103805@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.74-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.74-rc2
X-KernelTest-Deadline: 2022-10-16T08:25+00:00
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.74 release.
There are 33 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sun, 16 Oct 2022 08:25:00 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.74-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.74-rc2

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix MBSSID parsing use-after-free

Johannes Berg <johannes.berg@intel.com>
    mac80211: fix memory leaks with element parsing

Johannes Berg <johannes.berg@intel.com>
    mac80211: always allocate struct ieee802_11_elems

Johannes Berg <johannes.berg@intel.com>
    mac80211: mlme: find auth challenge directly

Johannes Berg <johannes.berg@intel.com>
    mac80211: move CRC into struct ieee802_11_elems

Johannes Berg <johannes.berg@intel.com>
    mac80211: mesh: clean up rx_bcn_presp API

Shunsuke Mie <mie@igel.co.jp>
    misc: pci_endpoint_test: Fix pci_endpoint_test_{copy,write,read}() panic

Shunsuke Mie <mie@igel.co.jp>
    misc: pci_endpoint_test: Aggregate params checking for xfer

Cameron Gutman <aicommander@gmail.com>
    Input: xpad - fix wireless 360 controller breaking after suspend

Pavel Rojtberg <rojtberg@gmail.com>
    Input: xpad - add supported devices as contributed on github

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

Frank Wunderlich <frank-w@public-files.de>
    USB: serial: qcserial: add new usb-id for Dell branded EM7455

Linus Torvalds <torvalds@linux-foundation.org>
    scsi: stex: Properly zero out the passthrough command structure

Orlando Chamberlain <redecorating@protonmail.com>
    efi: Correct Macmini DMI match in uefi cert quirk

Takashi Iwai <tiwai@suse.de>
    ALSA: hda: Fix position reporting on Poulsbo

Jason A. Donenfeld <Jason@zx2c4.com>
    random: clamp credited irq bits to maximum mixed

Jason A. Donenfeld <Jason@zx2c4.com>
    random: restore O_NONBLOCK support

Hu Weiwen <sehuww@mail.scut.edu.cn>
    ceph: don't truncate file in atomic_open

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

 Makefile                                      |   4 +-
 arch/powerpc/include/asm/paca.h               |   1 -
 arch/powerpc/include/asm/rtas.h               |   1 -
 arch/powerpc/kernel/paca.c                    |  32 ----
 arch/powerpc/kernel/rtas.c                    |  54 -------
 arch/powerpc/sysdev/xics/ics-rtas.c           |  22 +--
 drivers/char/mem.c                            |   4 +-
 drivers/char/random.c                         |  25 ++-
 drivers/crypto/qat/qat_common/qat_asym_algs.c |  12 +-
 drivers/input/joystick/xpad.c                 |  20 ++-
 drivers/misc/pci_endpoint_test.c              |  34 +++-
 drivers/net/wireless/mac80211_hwsim.c         |   2 +
 drivers/scsi/stex.c                           |  17 +-
 drivers/usb/serial/qcserial.c                 |   1 +
 fs/ceph/file.c                                |  10 +-
 fs/nilfs2/inode.c                             |  19 ++-
 fs/nilfs2/segment.c                           |  21 ++-
 include/scsi/scsi_cmnd.h                      |   2 +-
 net/mac80211/agg-rx.c                         |  14 +-
 net/mac80211/ibss.c                           |  33 ++--
 net/mac80211/ieee80211_i.h                    |  40 +++--
 net/mac80211/mesh.c                           |  87 +++++-----
 net/mac80211/mesh_hwmp.c                      |  44 +++---
 net/mac80211/mesh_plink.c                     |  11 +-
 net/mac80211/mesh_sync.c                      |  26 ++-
 net/mac80211/mlme.c                           | 218 ++++++++++++++------------
 net/mac80211/rx.c                             |  12 +-
 net/mac80211/scan.c                           |  16 +-
 net/mac80211/tdls.c                           |  63 +++++---
 net/mac80211/util.c                           |  53 ++++---
 net/wireless/scan.c                           |  77 +++++----
 security/integrity/platform_certs/load_uefi.c |   2 +-
 sound/pci/hda/hda_intel.c                     |   3 +-
 33 files changed, 536 insertions(+), 444 deletions(-)


