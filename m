Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EF5528F43
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:53:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235100AbiEPTx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:53:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346793AbiEPTvY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:51:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1415444A13;
        Mon, 16 May 2022 12:45:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A18061557;
        Mon, 16 May 2022 19:45:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECAFCC385AA;
        Mon, 16 May 2022 19:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730350;
        bh=/cUxW2AyLLCnodarmYRnHhF8tCi8PfnjXu2z2k1jhYI=;
        h=From:To:Cc:Subject:Date:From;
        b=znAdRHhCjPMf3AhoNDy9av6CRXz0B2MDEjWZmHTsPG+G+3S4Guc6wvunl1SPvtyDM
         ff0oWjZOeVYS4iAfhMe+9T6jV9nmGqe84Ji9z5B9beHrhTEi1gHUdInQX2Lnfoo/pv
         XyWAtVVFVnwKMCqOBp77BrARg8naxrij4gGaE8Xg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 00/66] 5.10.117-rc1 review
Date:   Mon, 16 May 2022 21:36:00 +0200
Message-Id: <20220516193619.400083785@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.117-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.117-rc1
X-KernelTest-Deadline: 2022-05-18T19:36+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.117 release.
There are 66 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.117-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.117-rc1

Dan Vacura <w36195@motorola.com>
    usb: gadget: uvc: allow for application to cleanly shutdown

Michael Tretter <m.tretter@pengutronix.de>
    usb: gadget: uvc: rename function to be more consistent

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ping: fix address binding wrt vrf

Mike Rapoport <rppt@kernel.org>
    arm[64]/memremap: don't abuse pfn_valid() to ensure presence of linear map

Francesco Dolcini <francesco.dolcini@toradex.com>
    net: phy: Fix race condition on link status change

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Ensure we flush any closed sockets before xs_xprt_free()

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Don't call connect() more than once on a TCP socket

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Prevent immediate close+reconnect

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: Clean up scheduling of autoclose

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Initialize drm_mode_fb_cmd2

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Remove cpus_allowed/mems_allowed setup in cpuset_init_smp()

Manuel Ullmann <labre@posteo.de>
    net: atlantic: always deep reset on pm op, fixing up my null deref regression

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    i40e: i40e_main: fix a missing check on list iterator

Robin Murphy <robin.murphy@arm.com>
    drm/nouveau/tegra: Stop using iommu_present()

Jeff Layton <jlayton@kernel.org>
    ceph: fix setting of xattrs on async created inodes

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    serial: 8250_mtk: Fix register address for XON/XOFF character

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    serial: 8250_mtk: Fix UART_EFR register address

Miaoqian Lin <linmq006@gmail.com>
    slimbus: qcom: Fix IRQ check in qcom_slim_probe

Sven Schwermer <sven.schwermer@disruptive-technologies.com>
    USB: serial: option: add Fibocom MA510 modem

Sven Schwermer <sven.schwermer@disruptive-technologies.com>
    USB: serial: option: add Fibocom L610 modem

Ethan Yang <etyang@sierrawireless.com>
    USB: serial: qcserial: add support for Sierra Wireless EM7590

Scott Chen <scott@labau.com.tw>
    USB: serial: pl2303: add device id for HP LM930 Display

ChiYuan Huang <cy_huang@richtek.com>
    usb: typec: tcpci_mt6360: Update for BMC PHY setting

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    usb: typec: tcpci: Don't skip cleanup in .remove() on error

Sergey Ryazanov <ryazanov.s.a@gmail.com>
    usb: cdc-wdm: fix reading stuck on device close

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix mux activation issues in gsm_config()

Yang Yingliang <yangyingliang@huawei.com>
    tty/serial: digicolor: fix possible null-ptr-deref in digicolor_uart_probe()

Thiébaud Weksteen <tweek@google.com>
    firmware_loader: use kernel credentials when reading firmware

Eric Dumazet <edumazet@google.com>
    tcp: resalt the secret every 10 seconds

Matthew Hagan <mnhagan88@gmail.com>
    net: sfp: Add tx-fault workaround for Huawei MA5671A SFP ONT

Shravya Kumbham <shravya.kumbham@xilinx.com>
    net: emaclite: Don't advertise 1000BASE-T and do auto negotiation

Sven Schnelle <svens@linux.ibm.com>
    s390: disable -Warray-bounds

Mark Brown <broonie@kernel.org>
    ASoC: ops: Validate input values in snd_soc_put_volsw_range()

Mark Brown <broonie@kernel.org>
    ASoC: max98090: Generate notifications on changes for custom control

Mark Brown <broonie@kernel.org>
    ASoC: max98090: Reject invalid values in custom control put()

Ji-Ze Hong (Peter Hong) <hpeter@gmail.com>
    hwmon: (f71882fg) Fix negative temperature

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Fix filesystem block deallocation for short writes

Maxim Mikityanskiy <maximmi@nvidia.com>
    tls: Fix context leak on tls_device_down

Taehee Yoo <ap420073@gmail.com>
    net: sfc: ef10: fix memory leak in efx_ef10_mtd_probe()

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: non blocking recvmsg() return -EAGAIN when no data and signal_pending

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Fix Wake-on-LAN with mac_link_down()

Florian Fainelli <f.fainelli@gmail.com>
    net: bcmgenet: Check for Wake-on-LAN interrupt probe deferral

Paolo Abeni <pabeni@redhat.com>
    net/sched: act_pedit: really ensure the skb is writable

Alexandra Winter <wintera@linux.ibm.com>
    s390/lcs: fix variable dereferenced before check

Alexandra Winter <wintera@linux.ibm.com>
    s390/ctcm: fix potential memory leak

Alexandra Winter <wintera@linux.ibm.com>
    s390/ctcm: fix variable dereferenced before check

Joel Savitz <jsavitz@redhat.com>
    selftests: vm: Makefile: rename TARGETS to VMTARGETS

Randy Dunlap <rdunlap@infradead.org>
    hwmon: (ltq-cputemp) restrict it to SOC_XWAY

Jesse Brandeburg <jesse.brandeburg@intel.com>
    dim: initialize all struct fields

Yang Yingliang <yangyingliang@huawei.com>
    ionic: fix missing pci_release_regions() on error in ionic_probe()

Dan Aloni <dan.aloni@vastdata.com>
    nfs: fix broken handling of the softreval mount option

Johannes Berg <johannes.berg@intel.com>
    mac80211_hwsim: call ieee80211_tx_prepare_skb under RCU protection

Taehee Yoo <ap420073@gmail.com>
    net: sfc: fix memory leak due to ptp channel

Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
    sfc: Use swap() instead of open coding it

Eric Dumazet <edumazet@google.com>
    netlink: do not reset transport header in netlink_recvmsg()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/nouveau: Fix a potential theorical leak in nouveau_get_backlight_name()

Lokesh Dhoundiyal <lokesh.dhoundiyal@alliedtelesis.co.nz>
    ipv4: drop dst in multicast routing path

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: avoid corrupting hardware counters when moving VCAP filters

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: restrict tc-trap actions to VCAP IS2 lookup 0

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix VCAP IS2 filters matching on both lookups

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mscc: ocelot: fix last VCAP IS1/IS2 filter persisting in hardware when deleted

Tariq Toukan <tariqt@nvidia.com>
    net: Fix features skip in for_each_netdev_feature()

Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
    mac80211: Reset MBSSID parameters upon connection

Camel Guo <camel.guo@axis.com>
    hwmon: (tmp401) Add OF device ID table

Guenter Roeck <linux@roeck-us.net>
    iwlwifi: iwl-dbg: Use del_timer_sync() before freeing

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't skb_split skbuffs with frag_list


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/include/asm/io.h                          |  3 ++
 arch/arm/mm/ioremap.c                              |  8 ++++
 arch/arm64/include/asm/io.h                        |  4 ++
 arch/arm64/mm/ioremap.c                            |  9 +++++
 arch/s390/Makefile                                 | 10 +++++
 drivers/base/firmware_loader/main.c                | 17 ++++++++
 drivers/gpu/drm/nouveau/nouveau_backlight.c        |  9 +++--
 drivers/gpu/drm/nouveau/nvkm/engine/device/tegra.c |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                 |  2 +-
 drivers/hwmon/Kconfig                              |  2 +-
 drivers/hwmon/f71882fg.c                           |  5 ++-
 drivers/hwmon/tmp401.c                             | 11 ++++++
 drivers/net/dsa/bcm_sf2.c                          |  3 ++
 .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |  4 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |  4 ++
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 27 ++++++-------
 drivers/net/ethernet/mscc/ocelot_flower.c          |  5 ++-
 drivers/net/ethernet/mscc/ocelot_vcap.c            |  9 ++++-
 .../net/ethernet/pensando/ionic/ionic_bus_pci.c    |  3 +-
 drivers/net/ethernet/sfc/ef10.c                    |  5 +++
 drivers/net/ethernet/sfc/efx_channels.c            | 21 +++++-----
 drivers/net/ethernet/sfc/ptp.c                     | 14 ++++++-
 drivers/net/ethernet/sfc/ptp.h                     |  1 +
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      | 15 --------
 drivers/net/phy/phy.c                              | 45 +++++++++++++++++++---
 drivers/net/phy/sfp.c                              | 12 +++++-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |  2 +-
 drivers/net/wireless/mac80211_hwsim.c              |  3 ++
 drivers/s390/net/ctcm_mpc.c                        |  6 +--
 drivers/s390/net/ctcm_sysfs.c                      |  5 ++-
 drivers/s390/net/lcs.c                             |  7 ++--
 drivers/slimbus/qcom-ctrl.c                        |  4 +-
 drivers/tty/n_gsm.c                                | 12 ++++--
 drivers/tty/serial/8250/8250_mtk.c                 | 22 ++++++-----
 drivers/tty/serial/digicolor-usart.c               |  5 +--
 drivers/usb/class/cdc-wdm.c                        |  1 +
 drivers/usb/gadget/function/f_uvc.c                | 32 +++++++++++++--
 drivers/usb/gadget/function/uvc.h                  |  2 +
 drivers/usb/gadget/function/uvc_v4l2.c             |  3 +-
 drivers/usb/serial/option.c                        |  4 ++
 drivers/usb/serial/pl2303.c                        |  1 +
 drivers/usb/serial/pl2303.h                        |  1 +
 drivers/usb/serial/qcserial.c                      |  2 +
 drivers/usb/typec/tcpm/tcpci.c                     |  2 +-
 drivers/usb/typec/tcpm/tcpci_mt6360.c              | 26 +++++++++++++
 fs/ceph/file.c                                     | 16 ++++++--
 fs/file_table.c                                    |  1 +
 fs/gfs2/bmap.c                                     | 11 +++---
 fs/nfs/fs_context.c                                |  2 +-
 include/linux/netdev_features.h                    |  4 +-
 include/linux/sunrpc/xprtsock.h                    |  1 +
 include/net/tc_act/tc_pedit.h                      |  1 +
 include/trace/events/sunrpc.h                      |  1 -
 kernel/cgroup/cpuset.c                             |  7 +++-
 lib/dim/net_dim.c                                  | 44 ++++++++++-----------
 net/batman-adv/fragmentation.c                     | 11 ++++++
 net/core/secure_seq.c                              | 12 ++++--
 net/ipv4/ping.c                                    | 15 +++++++-
 net/ipv4/route.c                                   |  1 +
 net/mac80211/mlme.c                                |  6 +++
 net/netlink/af_netlink.c                           |  1 -
 net/sched/act_pedit.c                              | 26 +++++++++++--
 net/smc/smc_rx.c                                   |  4 +-
 net/sunrpc/xprt.c                                  | 36 ++++++++---------
 net/sunrpc/xprtsock.c                              | 35 +++++++++++------
 net/tls/tls_device.c                               |  3 ++
 sound/soc/codecs/max98090.c                        |  5 ++-
 sound/soc/soc-ops.c                                | 18 ++++++++-
 tools/testing/selftests/vm/Makefile                | 10 ++---
 70 files changed, 482 insertions(+), 183 deletions(-)


