Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B33B4CF526
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:24:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236643AbiCGJYi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:24:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236625AbiCGJWj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:22:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4E1752B04;
        Mon,  7 Mar 2022 01:20:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5743260FF6;
        Mon,  7 Mar 2022 09:20:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E8EDC340E9;
        Mon,  7 Mar 2022 09:20:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646644849;
        bh=xsBz0RqUi2urBvcdghvSVVgEdjdNzS2up+wEosCosYQ=;
        h=From:To:Cc:Subject:Date:From;
        b=ldvqrEBeVLhsEKoH92iaTPk85D+5pjW0x+tX1yfFs3hbjwosJOf0aYlENa0Ijqv0w
         BJ6UpWkZ97PQdrYHRFxUNuXv+a4ateiwz0zyUeCebew+elhM6cTa142xFX1KJjuWWZ
         L82LvEZ8k0v9N7SrrFsCInAaTXjD+RZQjGm/pa2c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 00/32] 4.9.305-rc1 review
Date:   Mon,  7 Mar 2022 10:18:26 +0100
Message-Id: <20220307091634.434478485@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.305-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.305-rc1
X-KernelTest-Deadline: 2022-03-09T09:16+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.9.305 release.
There are 32 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.305-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.305-rc1

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dcb: disable softirqs in dcbnl_flush_dev()

Hugh Dickins <hughd@google.com>
    memfd: fix F_SEAL_WRITE after shmem huge page allocated

William Mahon <wmahon@chromium.org>
    HID: add mapping for KEY_ALL_APPLICATIONS

Hans de Goede <hdegoede@redhat.com>
    Input: elan_i2c - fix regulator enable count imbalance after suspend/resume

Hans de Goede <hdegoede@redhat.com>
    Input: elan_i2c - move regulator_[en|dis]able() out of elan_[en|dis]able_power()

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: chelsio: cxgb3: check the return value of pci_find_capability()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    soc: fsl: qe: Check of ioremap return value

Randy Dunlap <rdunlap@infradead.org>
    ARM: 9182/1: mmu: fix returns from early_param() and __setup() functions

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: gs_usb: change active_channels's type from atomic_t to u8

Jann Horn <jannh@google.com>
    efivars: Respect "block" flag in efivar_entry_set_safe()

Zheyu Ma <zheyuma97@gmail.com>
    net: arcnet: com20020: Fix null-ptr-deref in com20020pci_probe()

Randy Dunlap <rdunlap@infradead.org>
    net: sxgbe: fix return value of __setup handler

Randy Dunlap <rdunlap@infradead.org>
    net: stmmac: fix return value of __setup handler

Nicolas Escande <nico.escande@gmail.com>
    mac80211: fix forwarded mesh frames AC & queue selection

Johan Hovold <johan@kernel.org>
    firmware: qemu_fw_cfg: fix kobject leak in probe error path

Qiushi Wu <wu000273@umn.edu>
    firmware: Fix a reference count leak.

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dcb: flush lingering app table entries for unregistered devices

Florian Westphal <fw@strlen.de>
    netfilter: nf_queue: fix possible use-after-free

Florian Westphal <fw@strlen.de>
    netfilter: nf_queue: don't assume sk is full socket

Jiri Bohac <jbohac@suse.cz>
    xfrm: fix MTU regression

Marek Vasut <marex@denx.de>
    ASoC: ops: Shift tested values in snd_soc_put_volsw() by +min

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: pata_hpt37x: fix PCI clock detection

Hangyu Hua <hbh25y@gmail.com>
    usb: gadget: clear related members when goto fail

Hangyu Hua <hbh25y@gmail.com>
    usb: gadget: don't release an existing dev->buf

Daniele Palmas <dnlplm@gmail.com>
    net: usb: cdc_mbim: avoid altsetting toggling for Telit FN990

Wolfram Sang <wsa@kernel.org>
    i2c: qup: allow COMPILE_TEST

Yongzhi Liu <lyz_cs@pku.edu.cn>
    dmaengine: shdma: Fix runtime PM imbalance on error

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix double free race when mount fails in cifs_get_root()

José Expósito <jose.exposito89@gmail.com>
    Input: clear BTN_RIGHT/MIDDLE on buttonpads

Eric Anholt <eric@anholt.net>
    i2c: bcm2835: Avoid clock stretching timeouts

JaeMan Park <jaeman@google.com>
    mac80211_hwsim: initialize ieee80211_tx_info at hw_scan_work

Benjamin Beichler <benjamin.beichler@uni-rostock.de>
    mac80211_hwsim: report NOACK frames in tx_status


-------------

Diffstat:

 Makefile                                          |  4 +-
 arch/arm/mm/mmu.c                                 |  2 +
 drivers/ata/pata_hpt37x.c                         |  4 +-
 drivers/dma/sh/shdma-base.c                       |  4 +-
 drivers/firmware/efi/vars.c                       |  5 +-
 drivers/firmware/qemu_fw_cfg.c                    | 10 ++--
 drivers/hid/hid-debug.c                           |  4 +-
 drivers/hid/hid-input.c                           |  2 +
 drivers/i2c/busses/Kconfig                        |  2 +-
 drivers/i2c/busses/i2c-bcm2835.c                  | 11 ++++
 drivers/input/input.c                             |  6 +++
 drivers/input/mouse/elan_i2c_core.c               | 64 ++++++++---------------
 drivers/net/arcnet/com20020-pci.c                 |  3 ++
 drivers/net/can/usb/gs_usb.c                      | 10 ++--
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c        |  2 +
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c   |  6 +--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  6 +--
 drivers/net/usb/cdc_mbim.c                        |  5 ++
 drivers/net/wireless/mac80211_hwsim.c             | 13 +++++
 drivers/soc/fsl/qe/qe_io.c                        |  2 +
 drivers/usb/gadget/legacy/inode.c                 | 10 ++--
 fs/cifs/cifsfs.c                                  |  1 +
 include/net/netfilter/nf_queue.h                  |  2 +-
 include/uapi/linux/input-event-codes.h            |  3 +-
 mm/shmem.c                                        |  7 +--
 net/dcb/dcbnl.c                                   | 44 ++++++++++++++++
 net/ipv6/ip6_output.c                             | 11 ++--
 net/mac80211/rx.c                                 |  4 +-
 net/netfilter/nf_queue.c                          | 23 ++++++--
 net/netfilter/nfnetlink_queue.c                   | 12 +++--
 sound/soc/soc-ops.c                               |  4 +-
 31 files changed, 199 insertions(+), 87 deletions(-)


