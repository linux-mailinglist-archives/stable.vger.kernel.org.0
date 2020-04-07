Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75E951A0B4A
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728899AbgDGKZO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:25:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:35692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728896AbgDGKZN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:25:13 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 01B0D20644;
        Tue,  7 Apr 2020 10:25:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255112;
        bh=I832NDZIhyiH/5E1uvn2KBluHKu1cNjlRaRP8Xg6sgY=;
        h=From:To:Cc:Subject:Date:From;
        b=GrOtQe9316D9hXegwEuXLB8U3cCeYejko2DeesxGwc2+jsz6FxXKNeBhwJPiUmmnb
         dp84Sme79rIg7hYAZ8oMdigf5wpD+mbz8p98Vr6lmwI3wZseOL5vloWpRD9WRandPX
         r/V6c4D++Bj1EroeGvUq3v+9qdlHT96W4NoDxBtA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.5 00/46] 5.5.16-rc1 review
Date:   Tue,  7 Apr 2020 12:21:31 +0200
Message-Id: <20200407101459.502593074@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.5.16-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.5.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.5.16-rc1
X-KernelTest-Deadline: 2020-04-09T10:15+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.5.16 release.
There are 46 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 09 Apr 2020 10:13:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.5.16-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.5.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.5.16-rc1

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: always acquire cpu_hotplug_lock before pinst->lock

Ursula Braun <ubraun@linux.ibm.com>
    net/smc: fix cleanup for linkgroup setup failures

Amritha Nambiar <amritha.nambiar@intel.com>
    net: Fix Tx hash bound checking

Paolo Abeni <pabeni@redhat.com>
    net: genetlink: return the error code when attribute parsing fails.

Mika Westerberg <mika.westerberg@linux.intel.com>
    i2c: i801: Do not add ICH_RES_IO_SMI for the iTCO_wdt device

Neal Cardwell <ncardwell@google.com>
    tcp: fix TFO SYNACK undo to avoid double-timestamp-undo

Jiri Pirko <jiri@mellanox.com>
    sched: act: count in the size of action flags bitfield

Mike Marciniszyn <mike.marciniszyn@intel.com>
    IB/hfi1: Ensure pq is not left on waitlist

David Howells <dhowells@redhat.com>
    rxrpc: Fix sendmsg(MSG_WAITALL) handling

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: dbg: don't abort if sending DBGC_SUSPEND_RESUME fails

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: yoyo: don't add TLV offset when reading FIFOs

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: consider HE capability when setting LDPC

Tariq Toukan <tariqt@mellanox.com>
    net/mlx5e: kTLS, Fix wrong value in record tracker enum

Bibby Hsieh <bibby.hsieh@mediatek.com>
    soc: mediatek: knows_txdone needs to be set in Mediatek CMDQ helper

Geoffrey Allott <geoffrey@allott.email>
    ALSA: hda/ca0132 - Add Recon3Di quirk to handle integrated sound on EVGA X99 Classified motherboard

Mike Snitzer <snitzer@redhat.com>
    Revert "dm: always call blk_queue_split() in dm_process_bio()"

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_charger: Add special handling for HP Pavilion x2 10

Hans de Goede <hdegoede@redhat.com>
    extcon: axp288: Add wakeup support

Freeman Liu <freeman.liu@unisoc.com>
    nvmem: sprd: Fix the block lock operation

Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
    nvmem: check for NULL reg_read and reg_write before dereferencing

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: me: add cedar fork device ids

Eugene Syromiatnikov <esyr@redhat.com>
    coresight: do not use the BIT() macro in the UAPI header

Kelsey Skunberg <kelsey.skunberg@gmail.com>
    PCI: sysfs: Revert "rescan" file renames

Kishon Vijay Abraham I <kishon@ti.com>
    misc: pci_endpoint_test: Avoid using module parameter to determine irqtype

Kishon Vijay Abraham I <kishon@ti.com>
    misc: pci_endpoint_test: Fix to support > 10 pci-endpoint-test devices

YueHaibing <yuehaibing@huawei.com>
    misc: rtsx: set correct pcr_ops for rts522A

Matthew Wilcox (Oracle) <willy@infradead.org>
    XArray: Fix xa_find_next for large multi-index entries

Jann Horn <jannh@google.com>
    bpf: Fix tnum constraints for 32-bit comparisons

Guenter Roeck <linux@roeck-us.net>
    brcmfmac: abort and release host after error

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: fix uninitialized return value in padata_replace()

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix 32-bit capabilities warning

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix missing SYS_LPI counter on some Chromebooks

Len Brown <len.brown@intel.com>
    tools/power turbostat: Fix gcc build warnings

James Zhu <James.Zhu@amd.com>
    drm/amdgpu: fix typo for vcn1 idle check

Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>
    initramfs: restore default compression behavior

Gerd Hoffmann <kraxel@redhat.com>
    drm/bochs: downgrade pci_request_region failure from error to warning

Mario Kleiner <mario.kleiner.de@gmail.com>
    drm/amd/display: Add link_rate quirk for Apple 15" MBP 2017

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: add fbdev suspend/resume on gpu reset

Jérôme Pouiller <jerome.pouiller@silabs.com>
    staging: wfx: fix warning about freeing in-use mutex during device unregister

Prabhath Sajeepa <psajeepa@purestorage.com>
    nvme-rdma: Avoid double freeing of async event data

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    net: macb: Fix handling of fixed-link node

Qiujun Huang <hqjagain@gmail.com>
    sctp: fix refcount bug in sctp_wfree

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    sctp: fix possibly using a bad saddr with a given dst

William Dauchy <w.dauchy@criteo.com>
    net, ip_tunnel: fix interface lookup with no key

Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
    net: dsa: ksz: Select KSZ protocol tag

Qian Cai <cai@lca.pw>
    ipv4: fix a RCU-list lock in fib_triestat_seq_show


-------------

Diffstat:

 Makefile                                           |   4 +-
 drivers/extcon/extcon-axp288.c                     |  32 ++++++
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   4 +
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c              |   2 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |  11 +++
 drivers/gpu/drm/bochs/bochs_hw.c                   |   6 +-
 drivers/i2c/busses/i2c-i801.c                      |  45 +++------
 drivers/infiniband/hw/hfi1/user_sdma.c             |  25 ++++-
 drivers/md/dm.c                                    |   5 +-
 drivers/misc/cardreader/rts5227.c                  |   1 +
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/misc/pci_endpoint_test.c                   |  14 ++-
 drivers/net/dsa/microchip/Kconfig                  |   1 +
 drivers/net/ethernet/cadence/macb_main.c           |   3 +
 .../ethernet/mellanox/mlx5/core/en_accel/ktls.h    |   4 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   2 +
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  25 ++---
 drivers/net/wireless/intel/iwlwifi/fw/dbg.h        |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |   6 +-
 drivers/nvme/host/rdma.c                           |   8 +-
 drivers/nvmem/nvmem-sysfs.c                        |   6 ++
 drivers/nvmem/sprd-efuse.c                         |   2 +-
 drivers/pci/pci-sysfs.c                            |   6 +-
 drivers/power/supply/axp288_charger.c              |  57 ++++++++++-
 drivers/soc/mediatek/mtk-cmdq-helper.c             |   1 +
 drivers/staging/wfx/hif_tx.c                       |   1 +
 include/uapi/linux/coresight-stm.h                 |   6 +-
 kernel/bpf/verifier.c                              | 108 ++++++++++++++-------
 kernel/padata.c                                    |   6 +-
 lib/test_xarray.c                                  |  18 ++++
 lib/xarray.c                                       |   3 +-
 net/core/dev.c                                     |   2 +
 net/ipv4/fib_trie.c                                |   3 +
 net/ipv4/ip_tunnel.c                               |   6 +-
 net/ipv4/tcp_input.c                               |   6 +-
 net/netlink/genetlink.c                            |   5 +-
 net/rxrpc/sendmsg.c                                |   4 +-
 net/sched/act_api.c                                |   1 +
 net/sctp/ipv6.c                                    |  20 ++--
 net/sctp/protocol.c                                |  28 ++++--
 net/sctp/socket.c                                  |  31 ++++--
 net/smc/af_smc.c                                   |  25 +++--
 net/smc/smc_core.c                                 |  12 +++
 net/smc/smc_core.h                                 |   2 +-
 sound/pci/hda/patch_ca0132.c                       |   1 +
 tools/power/x86/turbostat/Makefile                 |   2 +-
 tools/power/x86/turbostat/turbostat.c              |  73 ++++++++------
 usr/Kconfig                                        |  22 ++---
 49 files changed, 461 insertions(+), 204 deletions(-)


