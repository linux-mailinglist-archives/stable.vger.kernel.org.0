Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F67D528E95
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 21:50:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240681AbiEPTrK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 15:47:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346212AbiEPTp7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 15:45:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7BE640A13;
        Mon, 16 May 2022 12:43:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B59AB81615;
        Mon, 16 May 2022 19:43:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DB7C34119;
        Mon, 16 May 2022 19:43:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730201;
        bh=vlUMwgSVN6d8hwNdUOFcqguNFvRLaiyt5AbBh+zlnRE=;
        h=From:To:Cc:Subject:Date:From;
        b=ia0bLPqHK2T/6Kke0jX6aA4Dt64byZQ2R4GI8lIJ6SQ16m+utFDABcfeQ3/qpkP5k
         MrfnfLKNM0UxangQuQy/roKtDKYUHoYWMtCwx1Si1WX2NLgVddl2iHKqTysymfxKbG
         G2frMFnq7Y4I9G527mQ5LtSXHofdGS8cG/hlVVaU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/43] 5.4.195-rc1 review
Date:   Mon, 16 May 2022 21:36:11 +0200
Message-Id: <20220516193614.714657361@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.195-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.195-rc1
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

This is the start of the stable review cycle for the 5.4.195 release.
There are 43 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.195-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.195-rc1

Yang Yingliang <yangyingliang@huawei.com>
    tty/serial: digicolor: fix possible null-ptr-deref in digicolor_uart_probe()

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ping: fix address binding wrt vrf

Mike Rapoport <rppt@linux.ibm.com>
    arm[64]/memremap: don't abuse pfn_valid() to ensure presence of linear map

Francesco Dolcini <francesco.dolcini@toradex.com>
    net: phy: Fix race condition on link status change

Sudip Mukherjee <sudipm.mukherjee@gmail.com>
    MIPS: fix build with gcc-12

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Initialize drm_mode_fb_cmd2

Waiman Long <longman@redhat.com>
    cgroup/cpuset: Remove cpus_allowed/mems_allowed setup in cpuset_init_smp()

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    i40e: i40e_main: fix a missing check on list iterator

Robin Murphy <robin.murphy@arm.com>
    drm/nouveau/tegra: Stop using iommu_present()

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

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    usb: typec: tcpci: Don't skip cleanup in .remove() on error

Sergey Ryazanov <ryazanov.s.a@gmail.com>
    usb: cdc-wdm: fix reading stuck on device close

Daniel Starke <daniel.starke@siemens.com>
    tty: n_gsm: fix mux activation issues in gsm_config()

Eric Dumazet <edumazet@google.com>
    tcp: resalt the secret every 10 seconds

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

Taehee Yoo <ap420073@gmail.com>
    net: sfc: ef10: fix memory leak in efx_ef10_mtd_probe()

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: non blocking recvmsg() return -EAGAIN when no data and signal_pending

Paolo Abeni <pabeni@redhat.com>
    net/sched: act_pedit: really ensure the skb is writable

Alexandra Winter <wintera@linux.ibm.com>
    s390/lcs: fix variable dereferenced before check

Alexandra Winter <wintera@linux.ibm.com>
    s390/ctcm: fix potential memory leak

Alexandra Winter <wintera@linux.ibm.com>
    s390/ctcm: fix variable dereferenced before check

Randy Dunlap <rdunlap@infradead.org>
    hwmon: (ltq-cputemp) restrict it to SOC_XWAY

Jesse Brandeburg <jesse.brandeburg@intel.com>
    dim: initialize all struct fields

Johannes Berg <johannes.berg@intel.com>
    mac80211_hwsim: call ieee80211_tx_prepare_skb under RCU protection

Eric Dumazet <edumazet@google.com>
    netlink: do not reset transport header in netlink_recvmsg()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    drm/nouveau: Fix a potential theorical leak in nouveau_get_backlight_name()

Lokesh Dhoundiyal <lokesh.dhoundiyal@alliedtelesis.co.nz>
    ipv4: drop dst in multicast routing path

Tariq Toukan <tariqt@nvidia.com>
    net: Fix features skip in for_each_netdev_feature()

Manikanta Pubbisetty <quic_mpubbise@quicinc.com>
    mac80211: Reset MBSSID parameters upon connection

Camel Guo <camel.guo@axis.com>
    hwmon: (tmp401) Add OF device ID table

Sven Eckelmann <sven@narfation.org>
    batman-adv: Don't skb_split skbuffs with frag_list


-------------

Diffstat:

 Makefile                                           |  4 +-
 arch/arm/include/asm/io.h                          |  3 ++
 arch/arm/mm/ioremap.c                              |  8 ++++
 arch/arm64/include/asm/io.h                        |  4 ++
 arch/arm64/mm/ioremap.c                            |  9 +++++
 arch/mips/jz4740/setup.c                           |  2 +-
 arch/s390/Makefile                                 | 10 +++++
 drivers/gpu/drm/nouveau/nouveau_backlight.c        |  9 +++--
 drivers/gpu/drm/nouveau/nvkm/engine/device/tegra.c |  2 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_fb.c                 |  2 +-
 drivers/hwmon/Kconfig                              |  2 +-
 drivers/hwmon/f71882fg.c                           |  5 ++-
 drivers/hwmon/tmp401.c                             | 11 ++++++
 drivers/net/ethernet/intel/i40e/i40e_main.c        | 27 ++++++-------
 drivers/net/ethernet/sfc/ef10.c                    |  5 +++
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      | 15 --------
 drivers/net/phy/phy.c                              | 45 +++++++++++++++++++---
 drivers/net/wireless/mac80211_hwsim.c              |  3 ++
 drivers/s390/net/ctcm_mpc.c                        |  6 +--
 drivers/s390/net/ctcm_sysfs.c                      |  5 ++-
 drivers/s390/net/lcs.c                             |  7 ++--
 drivers/slimbus/qcom-ctrl.c                        |  4 +-
 drivers/tty/n_gsm.c                                | 12 ++++--
 drivers/tty/serial/8250/8250_mtk.c                 | 22 ++++++-----
 drivers/tty/serial/digicolor-usart.c               |  2 +-
 drivers/usb/class/cdc-wdm.c                        |  1 +
 drivers/usb/serial/option.c                        |  4 ++
 drivers/usb/serial/pl2303.c                        |  1 +
 drivers/usb/serial/pl2303.h                        |  1 +
 drivers/usb/serial/qcserial.c                      |  2 +
 drivers/usb/typec/tcpm/tcpci.c                     |  2 +-
 fs/gfs2/bmap.c                                     | 11 +++---
 include/linux/netdev_features.h                    |  4 +-
 include/net/tc_act/tc_pedit.h                      |  1 +
 kernel/cgroup/cpuset.c                             |  7 +++-
 lib/dim/net_dim.c                                  | 44 ++++++++++-----------
 net/batman-adv/fragmentation.c                     | 11 ++++++
 net/core/secure_seq.c                              | 12 ++++--
 net/ipv4/ping.c                                    | 12 +++++-
 net/ipv4/route.c                                   |  1 +
 net/mac80211/mlme.c                                |  6 +++
 net/netlink/af_netlink.c                           |  1 -
 net/sched/act_pedit.c                              | 26 +++++++++++--
 net/smc/smc_rx.c                                   |  4 +-
 sound/soc/codecs/max98090.c                        |  5 ++-
 sound/soc/soc-ops.c                                | 18 ++++++++-
 46 files changed, 281 insertions(+), 117 deletions(-)


