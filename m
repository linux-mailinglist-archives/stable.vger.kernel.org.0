Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5AF0B1A0B7D
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 12:27:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728554AbgDGK1E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 06:27:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:39330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729270AbgDGK1D (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 Apr 2020 06:27:03 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E28B52074B;
        Tue,  7 Apr 2020 10:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586255222;
        bh=YVQM+iczOo1Fh288Dyr3xQF9gGdlPeApTwv+EbhBE20=;
        h=From:To:Cc:Subject:Date:From;
        b=eBrYudOMN/1m14Cqjf5kl9HSMciRCtvVbZWp8jlOREOc1BB41s0MCujOfRRRFmGqX
         962C0TZDj4KJ/Mu+pt3Xy/fPVXUD76GjNR/z/9foDXkUzKyWTBiobSVjccf7DWJzHS
         8kUOFAT090aa/6EK+3kgrfrUXMnG9WqK3Tb7mswY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.6 00/29] 5.6.3-rc1 review
Date:   Tue,  7 Apr 2020 12:21:57 +0200
Message-Id: <20200407101452.046058399@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.6.3-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.6.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.6.3-rc1
X-KernelTest-Deadline: 2020-04-09T10:14+00:00
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.6.3 release.
There are 29 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 09 Apr 2020 10:13:38 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.3-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.6.3-rc1

Bibby Hsieh <bibby.hsieh@mediatek.com>
    soc: mediatek: knows_txdone needs to be set in Mediatek CMDQ helper

Geoffrey Allott <geoffrey@allott.email>
    ALSA: hda/ca0132 - Add Recon3Di quirk to handle integrated sound on EVGA X99 Classified motherboard

Mike Snitzer <snitzer@redhat.com>
    Revert "dm: always call blk_queue_split() in dm_process_bio()"

Takashi Iwai <tiwai@suse.de>
    Revert "ALSA: uapi: Drop asound.h inclusion from asoc.h"

Hans de Goede <hdegoede@redhat.com>
    power: supply: axp288_charger: Add special handling for HP Pavilion x2 10

Hans de Goede <hdegoede@redhat.com>
    extcon: axp288: Add wakeup support

Freeman Liu <freeman.liu@unisoc.com>
    nvmem: sprd: Fix the block lock operation

Nicholas Johnson <nicholas.johnson-opensource@outlook.com.au>
    nvmem: check for NULL reg_read and reg_write before dereferencing

Khouloud Touil <ktouil@baylibre.com>
    nvmem: release the write-protect pin

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

Uma Shankar <uma.shankar@intel.com>
    drm/i915/display: Fix mode private_flags comparison at atomic_check

Torsten Duwe <duwe@lst.de>
    drm/bridge: analogix-anx6345: Avoid duplicate -supply suffix

Matthew Wilcox (Oracle) <willy@infradead.org>
    XArray: Fix xa_find_next for large multi-index entries

Jann Horn <jannh@google.com>
    bpf: Fix tnum constraints for 32-bit comparisons

Guenter Roeck <linux@roeck-us.net>
    brcmfmac: abort and release host after error

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: fix uninitialized return value in padata_replace()

Xin Long <lucien.xin@gmail.com>
    udp: initialize is_flist with 0 in udp_gro_receive

Florian Westphal <fw@strlen.de>
    net: fix fraglist segmentation reference count leak

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
 drivers/gpu/drm/bridge/analogix/analogix-anx6345.c |   4 +-
 drivers/gpu/drm/i915/display/intel_display.c       |   4 +-
 drivers/md/dm.c                                    |   5 +-
 drivers/misc/cardreader/rts5227.c                  |   1 +
 drivers/misc/mei/hw-me-regs.h                      |   2 +
 drivers/misc/mei/pci-me.c                          |   2 +
 drivers/misc/pci_endpoint_test.c                   |  14 ++-
 drivers/net/dsa/microchip/Kconfig                  |   1 +
 drivers/net/ethernet/cadence/macb_main.c           |   3 +
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |   2 +
 drivers/nvmem/core.c                               |   1 +
 drivers/nvmem/nvmem-sysfs.c                        |   6 ++
 drivers/nvmem/sprd-efuse.c                         |   2 +-
 drivers/pci/pci-sysfs.c                            |   6 +-
 drivers/power/supply/axp288_charger.c              |  57 ++++++++++-
 drivers/soc/mediatek/mtk-cmdq-helper.c             |   1 +
 include/uapi/linux/coresight-stm.h                 |   6 +-
 include/uapi/sound/asoc.h                          |   1 +
 kernel/bpf/verifier.c                              | 108 ++++++++++++++-------
 kernel/padata.c                                    |   2 +-
 lib/test_xarray.c                                  |  18 ++++
 lib/xarray.c                                       |   3 +-
 net/core/skbuff.c                                  |   1 +
 net/ipv4/fib_trie.c                                |   3 +
 net/ipv4/ip_tunnel.c                               |   6 +-
 net/ipv4/udp_offload.c                             |   1 +
 net/sctp/ipv6.c                                    |  20 ++--
 net/sctp/protocol.c                                |  28 ++++--
 net/sctp/socket.c                                  |  31 ++++--
 sound/pci/hda/patch_ca0132.c                       |   1 +
 32 files changed, 292 insertions(+), 84 deletions(-)


