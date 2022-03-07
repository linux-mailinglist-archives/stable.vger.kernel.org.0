Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E43E54CF580
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:29:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236891AbiCGJ37 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:29:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237210AbiCGJ1w (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:27:52 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C65E766CBE;
        Mon,  7 Mar 2022 01:24:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DBFCCB810C3;
        Mon,  7 Mar 2022 09:24:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE4B5C340F3;
        Mon,  7 Mar 2022 09:24:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645086;
        bh=oMim++ni5oOA3MTAgyxuWZ1ohy1hqlImQ013Z6OtWYc=;
        h=From:To:Cc:Subject:Date:From;
        b=CVcRIB/i2xGkMVbR7/DoRhWyzIaoSjWpPPJ6IoRvRL0OGzmHBCZ5GMVSB7ooxADiG
         AtRTkgL/V3nirI68EylASl5ghWxe09v4br+gNoZTI60Wa1oyUnXOQ2tDVpgJ1oIm65
         jjfYUCZ+UVsHUwU2TqvknWt9HI9W9Ph0qbraXou0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.19 00/51] 4.19.233-rc1 review
Date:   Mon,  7 Mar 2022 10:18:35 +0100
Message-Id: <20220307091636.988950823@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.233-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.233-rc1
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

This is the start of the stable review cycle for the 4.19.233 release.
There are 51 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.233-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.233-rc1

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dcb: disable softirqs in dcbnl_flush_dev()

Filipe Manana <fdmanana@suse.com>
    btrfs: add missing run of delayed items after unlink during log replay

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/histogram: Fix sorting on old "cpu" value

Hugh Dickins <hughd@google.com>
    memfd: fix F_SEAL_WRITE after shmem huge page allocated

William Mahon <wmahon@chromium.org>
    HID: add mapping for KEY_ALL_APPLICATIONS

Hans de Goede <hdegoede@redhat.com>
    Input: elan_i2c - fix regulator enable count imbalance after suspend/resume

Hans de Goede <hdegoede@redhat.com>
    Input: elan_i2c - move regulator_[en|dis]able() out of elan_[en|dis]able_power()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    nl80211: Handle nla_memdup failures in handle_nan_filter

Jia-Ju Bai <baijiaju1990@gmail.com>
    net: chelsio: cxgb3: check the return value of pci_find_capability()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    soc: fsl: qe: Check of ioremap return value

Sukadev Bhattiprolu <sukadev@linux.ibm.com>
    ibmvnic: free reset-work-item when flushing

Randy Dunlap <rdunlap@infradead.org>
    ARM: 9182/1: mmu: fix returns from early_param() and __setup() functions

Brian Norris <briannorris@chromium.org>
    arm64: dts: rockchip: Switch RK3399-Gru DP to SPDIF output

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: gs_usb: change active_channels's type from atomic_t to u8

Alyssa Ross <hi@alyssa.is>
    firmware: arm_scmi: Remove space in MODULE_ALIAS name

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

Marek Marczykowski-Górecki <marmarek@invisiblethingslab.com>
    xen/netfront: destroy queues before real_num_tx_queues is zeroed

Lukas Wunner <lukas@wunner.de>
    PCI: pciehp: Fix infinite loop in IRQ handler upon power fault

Ye Bin <yebin10@huawei.com>
    block: Fix fsync always failed if once failed

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error cause by server

D. Wythe <alibuda@linux.alibaba.com>
    net/smc: fix unexpected SMC_CLC_DECL_ERR_REGRMB error generated by client

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dcb: flush lingering app table entries for unregistered devices

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't expect inter-netns unique iflink indices

Sven Eckelmann <sven@narfation.org>
    batman-adv: Request iflink once in batadv_get_real_netdevice

Sven Eckelmann <sven@narfation.org>
    batman-adv: Request iflink once in batadv-on-batadv check

Florian Westphal <fw@strlen.de>
    netfilter: nf_queue: fix possible use-after-free

Florian Westphal <fw@strlen.de>
    netfilter: nf_queue: don't assume sk is full socket

Leon Romanovsky <leonro@nvidia.com>
    xfrm: enforce validity of offload input flags

Antony Antony <antony.antony@secunet.com>
    xfrm: fix the if_id check in changelink

Eric Dumazet <edumazet@google.com>
    netfilter: fix use-after-free in __nf_register_net_hook()

Jiri Bohac <jbohac@suse.cz>
    xfrm: fix MTU regression

Marek Vasut <marex@denx.de>
    ASoC: ops: Shift tested values in snd_soc_put_volsw() by +min

Zhen Ni <nizhen@uniontech.com>
    ALSA: intel_hdmi: Fix reference to PCM buffer address

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

Wolfram Sang <wsa@kernel.org>
    i2c: cadence: allow COMPILE_TEST

Yongzhi Liu <lyz_cs@pku.edu.cn>
    dmaengine: shdma: Fix runtime PM imbalance on error

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix double free race when mount fails in cifs_get_root()

José Expósito <jose.exposito89@gmail.com>
    Input: clear BTN_RIGHT/MIDDLE on buttonpads

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: rt5682: do not block workqueue if card is unbound

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: rt5668: do not block workqueue if card is unbound

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
 arch/arm64/boot/dts/rockchip/rk3399-gru.dtsi      | 17 ++++--
 block/blk-flush.c                                 |  4 +-
 drivers/ata/pata_hpt37x.c                         |  4 +-
 drivers/dma/sh/shdma-base.c                       |  4 +-
 drivers/firmware/arm_scmi/driver.c                |  2 +-
 drivers/firmware/efi/vars.c                       |  5 +-
 drivers/hid/hid-debug.c                           |  4 +-
 drivers/hid/hid-input.c                           |  2 +
 drivers/i2c/busses/Kconfig                        |  4 +-
 drivers/i2c/busses/i2c-bcm2835.c                  | 11 ++++
 drivers/input/input.c                             |  6 +++
 drivers/input/mouse/elan_i2c_core.c               | 64 ++++++++---------------
 drivers/net/arcnet/com20020-pci.c                 |  3 ++
 drivers/net/can/usb/gs_usb.c                      | 10 ++--
 drivers/net/ethernet/chelsio/cxgb3/t3_hw.c        |  2 +
 drivers/net/ethernet/ibm/ibmvnic.c                |  4 +-
 drivers/net/ethernet/samsung/sxgbe/sxgbe_main.c   |  6 +--
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c |  6 +--
 drivers/net/usb/cdc_mbim.c                        |  5 ++
 drivers/net/wireless/mac80211_hwsim.c             | 13 +++++
 drivers/net/xen-netfront.c                        | 39 ++++++++------
 drivers/pci/hotplug/pciehp_hpc.c                  |  7 +--
 drivers/soc/fsl/qe/qe_io.c                        |  2 +
 drivers/usb/gadget/legacy/inode.c                 | 10 ++--
 fs/btrfs/tree-log.c                               | 18 +++++++
 fs/cifs/cifsfs.c                                  |  1 +
 include/net/netfilter/nf_queue.h                  |  2 +-
 include/uapi/linux/input-event-codes.h            |  3 +-
 include/uapi/linux/xfrm.h                         |  6 +++
 kernel/trace/trace_events_hist.c                  |  6 +--
 mm/memfd.c                                        | 30 ++++++++---
 net/batman-adv/hard-interface.c                   | 29 ++++++----
 net/dcb/dcbnl.c                                   | 44 ++++++++++++++++
 net/ipv6/ip6_output.c                             | 11 ++--
 net/mac80211/rx.c                                 |  4 +-
 net/netfilter/core.c                              |  5 +-
 net/netfilter/nf_queue.c                          | 22 ++++++--
 net/netfilter/nfnetlink_queue.c                   | 12 +++--
 net/smc/smc_core.c                                |  5 +-
 net/wireless/nl80211.c                            | 12 +++++
 net/xfrm/xfrm_device.c                            |  6 ++-
 net/xfrm/xfrm_interface.c                         |  2 +-
 sound/soc/codecs/rt5668.c                         | 12 +++--
 sound/soc/codecs/rt5682.c                         | 12 +++--
 sound/soc/soc-ops.c                               |  4 +-
 sound/x86/intel_hdmi_audio.c                      |  2 +-
 48 files changed, 344 insertions(+), 144 deletions(-)


