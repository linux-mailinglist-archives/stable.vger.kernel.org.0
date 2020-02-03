Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9D725150D1E
	for <lists+stable@lfdr.de>; Mon,  3 Feb 2020 17:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728552AbgBCQee (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Feb 2020 11:34:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:48936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730800AbgBCQed (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Feb 2020 11:34:33 -0500
Received: from localhost (unknown [104.132.45.99])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F314A2087E;
        Mon,  3 Feb 2020 16:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580747672;
        bh=zkJVeSbqeWrr74Mr3qj1hilc8Ws/VCOxCoc+gA3yIiY=;
        h=From:To:Cc:Subject:Date:From;
        b=1NbtRd20KqHiUmrbm+KUlGRoxXnv0dRdCsgUw2dFpbHFZ3LY+R6F5qUKjEFYlYXN4
         rfmjMBK+ypdEdlYC2R54lHOQ3amRZtr1Ma1eY80SWTOBQNvy4hfsX4oJLH3PryGLFw
         JjbqIVMhIMCBgW+Ba+k5Nxq3sXESNe2cvXoKaW8A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: [PATCH 5.4 00/90] 5.4.18-stable review
Date:   Mon,  3 Feb 2020 16:19:03 +0000
Message-Id: <20200203161917.612554987@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.4.18-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.18-rc1
X-KernelTest-Deadline: 2020-02-05T16:19+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.18 release.
There are 90 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 05 Feb 2020 16:17:59 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.18-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.18-rc1

Praveen Chaudhary <praveen5582@gmail.com>
    net: Fix skb->csum update in inet_proto_csum_replace16().

wenxu <wenxu@ucloud.cn>
    netfilter: nf_tables_offload: fix check the chain offload flag

Jiri Wiesner <jwiesner@suse.com>
    netfilter: conntrack: sctp: use distinct states for new SCTP connections

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
    r8152: disable DelayPhyPwrChg

Hayes Wang <hayeswang@realtek.com>
    r8152: avoid the MCU to clear the lanwake

Hayes Wang <hayeswang@realtek.com>
    r8152: disable test IO for RTL8153B

Hayes Wang <hayeswang@realtek.com>
    r8152: Disable PLA MCU clock speed down

Hayes Wang <hayeswang@realtek.com>
    r8152: disable U2P3 for RTL8153B

Hayes Wang <hayeswang@realtek.com>
    r8152: get default setting of WOL before initializing

Vincenzo Frascino <vincenzo.frascino@arm.com>
    tee: optee: Fix compilation issue with nommu

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    led: max77650: add of_match table

Vladimir Murzin <vladimir.murzin@arm.com>
    ARM: 8955/1: virt: Relax arch timer version check during early boot

Hannes Reinecke <hare@suse.de>
    scsi: fnic: do not queue commands during fwreset

Bartosz Golaszewski <bgolaszewski@baylibre.com>
    Input: max77650-onkey - add of_match table

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

Miles Chen <miles.chen@mediatek.com>
    Input: evdev - convert kzalloc()/vzalloc() to kvzalloc()

Shahar S Matityahu <shahar.s.matityahu@intel.com>
    iwlwifi: dbg: force stop the debug monitor HW

Haim Dreyfuss <haim.dreyfuss@intel.com>
    iwlwifi: Don't ignore the cap field upon mcc update

Luca Coelho <luciano.coelho@intel.com>
    iwlwifi: mvm: fix NVM check for 3168 devices

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: pcie: allocate smaller dev_cmd for TX headers

Matthew Wilcox (Oracle) <willy@infradead.org>
    XArray: Fix xas_pause at ULONG_MAX

Olof Johansson <olof@lixom.net>
    riscv: Less inefficient gcc tishift helpers (and export their symbols)

Ilie Halip <ilie.halip@gmail.com>
    riscv: delete temporary files

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Remove PCIe3 unit for SNR

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel/uncore: Add PCI ID of IMC for Xeon E3 V5 Family

Arnd Bergmann <arnd@arndb.de>
    wireless: wext: avoid gcc -O3 warning

Jouni Malinen <j@w1.fi>
    mac80211: Fix TKIP replay protection immediately after key setup

Orr Mazor <orr.mazor@tandemg.com>
    cfg80211: Fix radar event during another phy CAC

Ganapathi Bhat <ganapathi.bhat@nxp.com>
    wireless: fix enabling channel 12 for custom regulatory domain

Brendan Higgins <brendanhiggins@google.com>
    lkdtm/bugs: fix build error in lkdtm_UNSET_SMEP

Krzysztof Kozlowski <krzk@kernel.org>
    parisc: Use proper printk format for resource_size_t

Kristian Evensen <kristian.evensen@gmail.com>
    qmi_wwan: Add support for Quectel RM500Q

Arnaud Pouliquen <arnaud.pouliquen@st.com>
    ASoC: sti: fix possible sleep-in-atomic

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: hdac_hda: Fix error in driver removal after failed probe

Kai Vehmanen <kai.vehmanen@linux.intel.com>
    ASoC: SOF: Intel: fix HDA codec driver probe with multiple controllers

Harry Pan <harry.pan@intel.com>
    platform/x86: intel_pmc_core: update Comet Lake platform driver

Hans de Goede <hdegoede@redhat.com>
    platform/x86: GPD pocket fan: Allow somewhat lower/higher temperature limits

Stefan Assmann <sassmann@kpanic.de>
    iavf: remove current MAC address filter on VF reset

Manfred Rudigier <manfred.rudigier@omicronenergy.com>
    igb: Fix SGMII SFP module discovery for 100FX/LX.

Cambda Zhu <cambda@linux.alibaba.com>
    ixgbe: Fix calculation of queue with VFs and flow director on interface flap

Radoslaw Tyl <radoslawx.tyl@intel.com>
    ixgbevf: Remove limit of 10 entries for unicast filter list

Brett Creeley <brett.creeley@intel.com>
    i40e: Fix virtchnl_queue_select bitmap validation

Harald Freudenberger <freude@linux.ibm.com>
    s390/zcrypt: move ap device reset from bus to driver code

Dmitry Osipenko <digetx@gmail.com>
    ASoC: rt5640: Fix NULL dereference on module unload

Lubomir Rintel <lkundrak@v3.sk>
    clk: mmp2: Fix the order of timer mux parents

Markus Theil <markus.theil@tu-ilmenau.de>
    mac80211: mesh: restrict airtime metric to peered established plinks

Samuel Holland <samuel@sholland.org>
    clk: sunxi-ng: h6-r: Fix AR100/R_APB2 parent order

Samuel Holland <samuel@sholland.org>
    clk: sunxi-ng: sun8i-r: Fix divider on APB0 clock

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

Guillaume La Roque <glaroque@baylibre.com>
    arm64: dts: meson-sm1-sei610: add gpio bluetooth interrupt

Yunhao Tian <18373444@buaa.edu.cn>
    clk: sunxi-ng: v3s: Fix incorrect number of hw_clks.

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

Dirk Behme <dirk.behme@de.bosch.com>
    arm64: kbuild: remove compressed images on 'make ARCH=arm64 (dist)clean'

Vitaly Chikunov <vt@altlinux.org>
    tools lib: Fix builds when glibc contains strlcpy()

Chanwoo Choi <cw00.choi@samsung.com>
    PM / devfreq: Add new name attribute for sysfs

Andres Freund <andres@anarazel.de>
    perf c2c: Fix return type for histogram sorting comparision functions

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Another gfs2_find_jhead fix

Jeff Kirsher <jeffrey.t.kirsher@intel.com>
    e1000e: Revert "e1000e: Make watchdog use delayed work"

Alexander Duyck <alexander.h.duyck@linux.intel.com>
    e1000e: Drop unnecessary __E1000_DOWN bit twiddling

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Fix use-after-free due to inaccurate refcount of rdtgroup

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Fix use-after-free when deleting resource groups

Xiaochen Shen <xiaochen.shen@intel.com>
    x86/resctrl: Fix a deadlock due to inaccurate reference

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: fix soft mounts hanging in the reconnect code

Al Viro <viro@zeniv.linux.org.uk>
    vfs: fix do_last() regression


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-class-devfreq      |  7 ++
 Makefile                                           |  4 +-
 arch/arm/boot/dts/am335x-boneblack-common.dtsi     |  5 ++
 arch/arm/boot/dts/am43x-epos-evm.dts               |  2 +
 arch/arm/boot/dts/am571x-idk.dts                   |  4 --
 arch/arm/boot/dts/am572x-idk-common.dtsi           |  4 --
 arch/arm/boot/dts/am57xx-beagle-x15-common.dtsi    | 25 +++++--
 arch/arm/boot/dts/sun8i-a83t-cubietruck-plus.dts   |  2 +-
 arch/arm/kernel/hyp-stub.S                         |  7 +-
 arch/arm64/boot/Makefile                           |  2 +-
 arch/arm64/boot/dts/amlogic/meson-sm1-sei610.dts   |  2 +
 arch/parisc/kernel/drivers.c                       |  4 +-
 .../dts/fsl/qoriq-fman3-0-10g-0-best-effort.dtsi   |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-0.dtsi |  1 +
 .../dts/fsl/qoriq-fman3-0-10g-1-best-effort.dtsi   |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-1.dtsi |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-0.dtsi  |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-1.dtsi  |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-2.dtsi  |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-3.dtsi  |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-4.dtsi  |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-1g-5.dtsi  |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-0.dtsi |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-10g-1.dtsi |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-0.dtsi  |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-1.dtsi  |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-2.dtsi  |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-3.dtsi  |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-4.dtsi  |  1 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-1-1g-5.dtsi  |  1 +
 arch/riscv/include/asm/asm-prototypes.h            |  4 ++
 arch/riscv/kernel/vdso/Makefile                    |  3 +-
 arch/riscv/lib/tishift.S                           | 75 +++++++++++++++-----
 arch/x86/events/intel/uncore_snb.c                 |  6 ++
 arch/x86/events/intel/uncore_snbep.c               | 24 -------
 arch/x86/kernel/cpu/resctrl/rdtgroup.c             | 32 +++++----
 drivers/char/ttyprintk.c                           | 15 ++--
 drivers/clk/mmp/clk-of-mmp2.c                      |  2 +-
 drivers/clk/sunxi-ng/ccu-sun50i-h6-r.c             |  4 +-
 drivers/clk/sunxi-ng/ccu-sun8i-r.c                 | 21 +-----
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.c               |  4 +-
 drivers/clk/sunxi-ng/ccu-sun8i-v3s.h               |  2 -
 drivers/devfreq/devfreq.c                          |  9 +++
 drivers/input/evdev.c                              |  5 +-
 drivers/input/misc/max77650-onkey.c                |  7 ++
 drivers/input/tablet/aiptek.c                      |  2 +-
 drivers/leds/leds-max77650.c                       |  7 ++
 drivers/media/usb/dvb-usb/af9005.c                 |  2 +-
 drivers/media/usb/dvb-usb/digitv.c                 | 10 ++-
 drivers/media/usb/dvb-usb/dvb-usb-urb.c            |  2 +-
 drivers/media/usb/dvb-usb/vp7045.c                 | 21 ++++--
 drivers/media/usb/gspca/gspca.c                    |  2 +-
 drivers/misc/lkdtm/bugs.c                          |  2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_debugfs.c |  3 +-
 drivers/net/ethernet/chelsio/cxgb4/l2t.c           |  3 +-
 drivers/net/ethernet/freescale/fman/fman_memac.c   |  4 +-
 drivers/net/ethernet/freescale/xgmac_mdio.c        |  7 +-
 drivers/net/ethernet/intel/e1000e/e1000.h          |  5 +-
 drivers/net/ethernet/intel/e1000e/netdev.c         | 61 +++++++---------
 drivers/net/ethernet/intel/i40e/i40e_virtchnl_pf.c | 22 ++++--
 drivers/net/ethernet/intel/iavf/iavf.h             |  2 +
 drivers/net/ethernet/intel/iavf/iavf_main.c        | 17 +++--
 drivers/net/ethernet/intel/iavf/iavf_virtchnl.c    |  3 +
 drivers/net/ethernet/intel/igb/e1000_82575.c       |  8 +--
 drivers/net/ethernet/intel/igb/igb_ethtool.c       |  2 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      | 37 +++++++---
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  |  5 --
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |  1 +
 .../net/ethernet/qlogic/qlcnic/qlcnic_minidump.c   |  2 +
 drivers/net/usb/qmi_wwan.c                         |  1 +
 drivers/net/usb/r8152.c                            | 82 +++++++++++++++++++---
 drivers/net/wireless/intel/iwlwifi/dvm/tx.c        |  3 +-
 drivers/net/wireless/intel/iwlwifi/fw/dbg.c        |  7 +-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.c | 48 ++++++++++++-
 drivers/net/wireless/intel/iwlwifi/iwl-nvm-parse.h |  6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-trans.c     | 10 +--
 drivers/net/wireless/intel/iwlwifi/iwl-trans.h     | 26 +++++--
 drivers/net/wireless/intel/iwlwifi/mvm/mac80211.c  |  3 +-
 drivers/net/wireless/intel/iwlwifi/mvm/nvm.c       |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        | 15 ++--
 drivers/net/wireless/intel/iwlwifi/pcie/internal.h |  6 +-
 drivers/net/wireless/intel/iwlwifi/pcie/trans.c    | 32 ++++++---
 drivers/net/wireless/intel/iwlwifi/pcie/tx-gen2.c  | 21 ++++--
 drivers/net/wireless/intel/iwlwifi/pcie/tx.c       | 20 +++---
 drivers/platform/x86/gpd-pocket-fan.c              |  2 +-
 drivers/platform/x86/intel_pmc_core_pltdrv.c       |  2 +
 drivers/s390/crypto/ap_bus.c                       |  2 -
 drivers/s390/crypto/ap_bus.h                       |  2 +-
 drivers/s390/crypto/ap_queue.c                     |  5 +-
 drivers/s390/crypto/zcrypt_cex2a.c                 |  1 +
 drivers/s390/crypto/zcrypt_cex2c.c                 |  2 +
 drivers/s390/crypto/zcrypt_cex4.c                  |  1 +
 drivers/scsi/fnic/fnic_scsi.c                      |  3 +
 drivers/soc/ti/wkup_m3_ipc.c                       |  4 +-
 drivers/tee/optee/Kconfig                          |  1 +
 fs/cifs/smb2pdu.c                                  |  2 +-
 fs/gfs2/lops.c                                     | 68 +++++++++++-------
 fs/namei.c                                         |  4 +-
 fs/reiserfs/super.c                                |  2 +
 include/linux/sched.h                              |  4 +-
 include/net/cfg80211.h                             |  5 ++
 kernel/cgroup/cgroup.c                             | 11 +--
 lib/test_xarray.c                                  | 22 ++++++
 lib/xarray.c                                       |  8 ++-
 mm/mempolicy.c                                     |  6 +-
 net/bluetooth/hci_sock.c                           |  3 +
 net/core/utils.c                                   | 20 +++++-
 net/ipv4/ip_vti.c                                  | 13 +++-
 net/ipv6/ip6_vti.c                                 | 13 +++-
 net/mac80211/cfg.c                                 | 23 ++++++
 net/mac80211/mesh_hwmp.c                           |  3 +
 net/mac80211/tkip.c                                | 18 ++++-
 net/netfilter/nf_conntrack_proto_sctp.c            |  6 +-
 net/netfilter/nf_tables_offload.c                  |  2 +-
 net/wireless/rdev-ops.h                            | 10 +++
 net/wireless/reg.c                                 | 36 ++++++++--
 net/wireless/trace.h                               |  5 ++
 net/wireless/wext-core.c                           |  3 +-
 net/xfrm/xfrm_interface.c                          | 34 ++++++---
 security/tomoyo/common.c                           | 11 ++-
 sound/soc/codecs/hdac_hda.c                        |  4 +-
 sound/soc/codecs/rt5640.c                          |  7 ++
 sound/soc/sof/intel/hda-codec.c                    | 19 +++--
 sound/soc/sti/uniperif_player.c                    |  7 +-
 tools/include/linux/string.h                       |  8 +++
 tools/lib/string.c                                 |  7 ++
 tools/lib/traceevent/parse-filter.c                |  4 +-
 tools/perf/builtin-c2c.c                           | 10 +--
 128 files changed, 864 insertions(+), 370 deletions(-)


