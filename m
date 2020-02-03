Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BFD48150BE5
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:32:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729981AbgBCQb0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:31:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:44578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730210AbgBCQb0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:31:26 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BA6982087E;
        Mon,  3 Feb 2020 16:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747485;
        bh=ZsrMJTX3BuIbcDs4ilQcSyCXXWBvxS2/InN10YvLGIA=;
        h=From:To:Cc:Subject:Date:From;
        b=d0oSLtgeGxbniBaFidmJ+ujCSTFtLqDFoD6kNdBBaIQ3fTiWYDJDGQQ5DpvulOZNT
         u8ed8xhMCDSaJBa1oaU5L32phHNOmEwGkiQRCzXrovnA+8oIyCs07JYtWcq240neGI
         4sH+aUxumQJR7xOhX43YnAcn+aX2rz2alOnYafgE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 4.19 00/70] 4.19.102-stable review
Date:   Mon,  3 Feb 2020 16:19:12 +0000
Message-Id: <20200203161912.158976871@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.102-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.102-rc1
X-KernelTest-Deadline: 2020-02-05T16:19+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 4.19.102 release.
There are 70 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.102-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.19.102-rc1

Praveen Chaudhary <praveen5582@gmail.com>
    net: Fix skb->csum update in inet_proto_csum_replace16().

Vasily Averin <vvs@virtuozzo.com>
    l2t_seq_next should increase position index

Vasily Averin <vvs@virtuozzo.com>
    seq_tab_next() should increase position index

Madalin Bucur <madalin.bucur@oss.nxp.com>
    net: fsl/fman: rename IF_MODE_XGMII to IF_MODE_10G

Madalin Bucur <madalin.bucur@oss.nxp.com>
    net/fsl: treat fsl,erratum-a011043

Madalin Bucur <madalin.bucur@oss.nxp.com>
    powerpc/fsl/dts: add fsl,erratum-a011043

Manish Chopra <manishc@marvell.com>
    qlcnic: Fix CPU soft lockup while collecting firmware dump

Raag Jadav <raagjadav@gmail.com>
    ARM: dts: am43x-epos-evm: set data pin directions for spi0 and spi1

Hayes Wang <hayeswang@realtek.com>
    r8152: get default setting of WOL before initializing

Michael Ellerman <mpe@ellerman.id.au>
    airo: Add missing CAP_NET_ADMIN check in AIROOLDIOCTL/SIOCDEVPRIVATE

Michael Ellerman <mpe@ellerman.id.au>
    airo: Fix possible info leak in AIROOLDIOCTL/SIOCDEVPRIVATE

Vincenzo Frascino <vincenzo.frascino@arm.com>
    tee: optee: Fix compilation issue with nommu

Vladimir Murzin <vladimir.murzin@arm.com>
    ARM: 8955/1: virt: Relax arch timer version check during early boot

Hannes Reinecke <hare@suse.de>
    scsi: fnic: do not queue commands during fwreset

Xu Wang <vulab@iscas.ac.cn>
    xfrm: interface: do not confirm neighbor when do pmtu update

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    xfrm interface: fix packet tx through bpf_redirect()

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    vti[6]: fix packet tx through bpf_redirect()

Matwey V. Kornilov <matwey@sai.msu.ru>
    ARM: dts: am335x-boneblack-common: fix memory size

Johan Hovold <johan@kernel.org>
    Input: aiptek - use descriptors of current altsetting

Haim Dreyfuss <haim.dreyfuss@intel.com>
    iwlwifi: Don't ignore the cap field upon mcc update

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: fix NVM check for 3168 devices

Ilie Halip <ilie.halip@gmail.com>
    riscv: delete temporary files

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix ipv6 RFS filter matching logic.

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Configure IMP port for 2Gb/sec

Florian Westphal <fw@strlen.de>
    netfilter: nft_tunnel: ERSPAN_VERSION must not be null

Arnd Bergmann <arnd@arndb.de>
    wireless: wext: avoid gcc -O3 warning

Jouni Malinen <j@w1.fi>
    mac80211: Fix TKIP replay protection immediately after key setup

Orr Mazor <orr.mazor@tandemg.com>
    cfg80211: Fix radar event during another phy CAC

Ganapathi Bhat <ganapathi.bhat@nxp.com>
    wireless: fix enabling channel 12 for custom regulatory domain

Krzysztof Kozlowski <krzk@kernel.org>
    parisc: Use proper printk format for resource_size_t

Kristian Evensen <kristian.evensen@gmail.com>
    qmi_wwan: Add support for Quectel RM500Q

Arnaud Pouliquen <arnaud.pouliquen@st.com>
    ASoC: sti: fix possible sleep-in-atomic

Hans de Goede <hdegoede@redhat.com>
    platform/x86: GPD pocket fan: Allow somewhat lower/higher temperature limits

Manfred Rudigier <manfred.rudigier@omicronenergy.com>
    igb: Fix SGMII SFP module discovery for 100FX/LX.

Cambda Zhu <cambda@linux.alibaba.com>
    ixgbe: Fix calculation of queue with VFs and flow director on interface flap

Radoslaw Tyl <radoslawx.tyl@intel.com>
    ixgbevf: Remove limit of 10 entries for unicast filter list

Dmitry Osipenko <digetx@gmail.com>
    ASoC: rt5640: Fix NULL dereference on module unload

Lubomir Rintel <lkundrak@v3.sk>
    clk: mmp2: Fix the order of timer mux parents

Markus Theil <markus.theil@tu-ilmenau.de>
    mac80211: mesh: restrict airtime metric to peered established plinks

Samuel Holland <samuel@sholland.org>
    clk: sunxi-ng: h6-r: Fix AR100/R_APB2 parent order

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    rseq: Unregister rseq for clone CLONE_VM

Hewenliang <hewenliang4@huawei.com>
    tools lib traceevent: Fix memory leakage in filter_event

Dave Gerlach <d-gerlach@ti.com>
    soc: ti: wkup_m3_ipc: Fix race condition with rproc_boot

Kishon Vijay Abraham I <kishon@ti.com>
    ARM: dts: beagle-x15-common: Model 5V0 regulator

Kishon Vijay Abraham I <kishon@ti.com>
    ARM: dts: am57xx-beagle-x15/am57xx-idk: Remove "gpios" for endpoint dt nodes

Marek Szyprowski <m.szyprowski@samsung.com>
    ARM: dts: sun8i: a83t: Correct USB3503 GPIOs polarity

Lee Jones <lee.jones@linaro.org>
    media: si470x-i2c: Move free() past last use of 'radio'

Michal Koutný <mkoutny@suse.com>
    cgroup: Prevent double killing of css when enabling threaded cgroup

Dan Carpenter <dan.carpenter@oracle.com>
    Bluetooth: Fix race condition in hci_release_sock()

Zhenzhong Duan <zhenzhong.duan@gmail.com>
    ttyprintk: fix a potential deadlock in interrupt context issue

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    tomoyo: Use atomic_t for statistics counter

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: dvb-usb/dvb-usb-urb.c: initialize actlen to 0

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: gspca: zero usb_buf

Sean Young <sean@mess.org>
    media: vp7045: do not read uninitialized values if usb transfer fails

Sean Young <sean@mess.org>
    media: af9005: uninitialized variable printked

Sean Young <sean@mess.org>
    media: digitv: don't continue if remote control state can't be read

Jan Kara <jack@suse.cz>
    reiserfs: Fix memory leak of journal device string

Dan Carpenter <dan.carpenter@oracle.com>
    mm/mempolicy.c: fix out of bounds write in mpol_parse_str()

Theodore Ts'o <tytso@mit.edu>
    ext4: validate the debug_want_extra_isize mount option at parse time

Dirk Behme <dirk.behme@de.bosch.com>
    arm64: kbuild: remove compressed images on 'make ARCH=arm64 (dist)clean'

Vitaly Chikunov <vt@altlinux.org>
    tools lib: Fix builds when glibc contains strlcpy()

Chanwoo Choi <cw00.choi@samsung.com>
    PM / devfreq: Add new name attribute for sysfs

Andres Freund <andres@anarazel.de>
    perf c2c: Fix return type for histogram sorting comparision functions

Johan Hovold <johan@kernel.org>
    rsi: fix use-after-free on failed probe and unbind

Siva Rebbagondla <siva.rebbagondla@redpinesignals.com>
    rsi: add hci detach for hibernation and poweroff

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: pcrypt - Fix user-after-free on module unload

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Fix a deadlock due to inaccurate reference

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Fix use-after-free due to inaccurate refcount of rdtgroup

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Fix use-after-free when deleting resource groups

Al Viro <viro@zeniv.linux.org.uk>
    vfs: fix do_last() regression


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-class-devfreq      |   7 ++
 Makefile                                           |   4 +-
 arch/arm/boot/dts/am335x-boneblack-common.dtsi     |   5 +
 arch/arm/boot/dts/am43x-epos-evm.dts               |   2 +
 arch/arm/boot/dts/am571x-idk.dts                   |   4 -
 arch/arm/boot/dts/am572x-idk-common.dtsi           |   4 -
 arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi    |  25 +++-
 arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts   |   2 +-
 arch/arm/kernel/hyp-stub.S                         |   7 +-
 arch/arm64/boot/Makefile                           |   2 +-
 arch/parisc/kernel/drivers.c                       |   4 +-
 .../dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi   |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi |   1 +
 .../dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi   |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi  |   1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi  |   1 +
 arch/riscv/kernel/vdso/Makefile                    |   3 +-
 arch/x86/kernel/cpu/intel_rdt_rdtgroup.c           |  32 ++++--
 crypto/pcrypt.c                                    |   3 +-
 drivers/char/ttyprintk.c                           |  15 ++-
 drivers/clk/mmp/clk-of-mmp2.c                      |   2 +-
 drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c             |   4 +-
 drivers/devfreq/devfreq.c                          |   9 ++
 drivers/input/tablet/aiptek.c                      |   2 +-
 drivers/media/radio/si470x/radio-si470x-i2c.c      |   2 +-
 drivers/media/usb/dvb-usb/af9005.c                 |   2 +-
 drivers/media/usb/dvb-usb/digitv.c                 |  10 +-
 drivers/media/usb/dvb-usb/dvb-usb-urb.c            |   2 +-
 drivers/media/usb/dvb-usb/vp7045.c                 |  21 ++--
 drivers/media/usb/gspca/gspca.c                    |   2 +-
 drivers/net/dsa/bcm_sf2.c                          |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  22 +++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |   3 +-
 drivers/net/ethernet/chelsio/cxgb4/l2t.c           |   3 +-
 drivers/net/ethernet/freescale/fman/fman_memac.c   |   4 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c        |   7 +-
 drivers/net/ethernet/intel/igb/e1000_82575.c       |   8 +-
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |   2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |  37 ++++--
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |   5 -
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |   1 +
 .../net/ethernet/qlogic/qlcnic/qlcnic_minidump.c   |   2 +
 drivers/net/usb/qmi_wwan.c                         |   1 +
 drivers/net/usb/r8152.c                            |   9 +-
 drivers/net/wireless/cisco/airo.c                  |  20 ++--
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c |  48 +++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |   6 +-
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |   3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |   2 +-
 drivers/net/wireless/rsi/rsi_91x_sdio.c            |  18 +++
 drivers/net/wireless/rsi/rsi_91x_usb.c             |  25 +++-
 drivers/platform/x86/gpd-pocket-fan.c              |   2 +-
 drivers/scsi/fnic/fnic_scsi.c                      |   3 +
 drivers/soc/ti/wkup_m3_ipc.c                       |   4 +-
 drivers/tee/optee/Kconfig                          |   1 +
 fs/ext4/super.c                                    | 127 +++++++++++----------
 fs/namei.c                                         |   4 +-
 fs/reiserfs/super.c                                |   2 +
 include/linux/sched.h                              |   4 +-
 include/net/cfg80211.h                             |   5 +
 kernel/cgroup/cgroup.c                             |  11 +-
 mm/mempolicy.c                                     |   6 +-
 net/bluetooth/hci_sock.c                           |   3 +
 net/core/utils.c                                   |  20 +++-
 net/ipv4/ip_vti.c                                  |  13 ++-
 net/ipv6/ip6_vti.c                                 |  13 ++-
 net/mac80211/cfg.c                                 |  23 ++++
 net/mac80211/mesh_hwmp.c                           |   3 +
 net/mac80211/tkip.c                                |  18 ++-
 net/netfilter/nft_tunnel.c                         |   3 +
 net/wireless/rdev-ops.h                            |  10 ++
 net/wireless/reg.c                                 |  36 +++++-
 net/wireless/trace.h                               |   5 +
 net/wireless/wext-core.c                           |   3 +-
 net/xfrm/xfrm_interface.c                          |  34 ++++--
 security/tomoyo/common.c                           |  11 +-
 sound/soc/codecs/rt5640.c                          |   7 ++
 sound/soc/sti/uniperif_player.c                    |   7 +-
 tools/include/linux/string.h                       |   8 ++
 tools/lib/string.c                                 |   7 ++
 tools/lib/traceevent/parse-filter.c                |   4 +-
 tools/perf/builtin-c2c.c                           |  10 +-
 95 files changed, 596 insertions(+), 232 deletions(-)


