Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD678395FC0
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232459AbhEaOQE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:16:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:42958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233065AbhEaOMz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:12:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17DCA61467;
        Mon, 31 May 2021 13:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468507;
        bh=Cjadt9KvEtwSC/hz7aDTBUbGVXBf9TNOYi7tR5O7ob8=;
        h=From:To:Cc:Subject:Date:From;
        b=pXbmx6dx/87v7F9JA2oZ+tZDdQMVNmOxMLPNMntMG17RLe/O/AC2mzTx0oJR+ih6F
         HDBvSh4MrHp6Ziql4vpsdg5ZuvJAWnibHs+KAt72xMvm1UAugz/OgvGfg3W1pP9Sb1
         QrSwVfvw1U9tV62tP/MTiZokW7RH66XklyDkS3Rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.4 000/177] 5.4.124-rc1 review
Date:   Mon, 31 May 2021 15:12:37 +0200
Message-Id: <20210531130647.887605866@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.124-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.124-rc1
X-KernelTest-Deadline: 2021-06-02T13:06+00:00
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.124 release.
There are 177 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.124-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.124-rc1

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: core: reduce power-on-good delay time of root hub

Chinmay Agarwal <chinagar@codeaurora.org>
    neighbour: Prevent Race condition in neighbour subsytem

Johan Hovold <johan@kernel.org>
    net: hso: bail out on interrupt URB allocation failure

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Revert "ALSA: usx2y: Fix potential NULL pointer dereference""

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: check the return of skb_checksum_help()

Jesse Brandeburg <jesse.brandeburg@intel.com>
    drivers/net/ethernet: clean up unused assignments

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    i915: fix build warning in intel_dp_get_link_status()

Linus Torvalds <torvalds@linux-foundation.org>
    drm/i915/display: fix compiler warning about array overrun

Randy Dunlap <rdunlap@infradead.org>
    MIPS: ralink: export rt_sysc_membase for rt2880_wdt.c

Randy Dunlap <rdunlap@infradead.org>
    MIPS: alchemy: xxs1500: add gpio-au1000.h header file

Taehee Yoo <ap420073@gmail.com>
    sch_dsmark: fix a NULL deref in qdisc_reset()

Stefan Roese <sr@denx.de>
    net: ethernet: mtk_eth_soc: Fix packet statistics support for MT7628/88

kernel test robot <lkp@intel.com>
    ALSA: usb-audio: scarlett2: snd_scarlett_gen2_controls_create() can be static

Francesco Ruggeri <fruggeri@arista.com>
    ipv6: record frag_max_size in atomic fragments in input path

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: lantiq: fix memory corruption in RX ring

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: libsas: Use _safe() loop in sas_resume_port()

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ixgbe: fix large MTU request from VF

Jussi Maki <joamaki@gmail.com>
    bpf: Set mac_len in bpf_skb_change_head

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: cs35l33: fix an error code in probe()

Dan Carpenter <dan.carpenter@oracle.com>
    staging: emxx_udc: fix loop in _nbu2ss_nuke()

Raju Rangoju <rajur@chelsio.com>
    cxgb4: avoid accessing registers when clearing filters

David Awogbemila <awogbemila@google.com>
    gve: Correct SKB queue index validation.

Catherine Sullivan <csully@google.com>
    gve: Upgrade memory barrier in poll routine

David Awogbemila <awogbemila@google.com>
    gve: Add NULL pointer checks when freeing irqs.

David Awogbemila <awogbemila@google.com>
    gve: Update mgmt_msix_idx if num_ntfy changes

Catherine Sullivan <csully@google.com>
    gve: Check TX QPL was actually assigned

Taehee Yoo <ap420073@gmail.com>
    mld: fix panic in mld_newpack()

Andy Gospodarek <gospo@broadcom.com>
    bnxt_en: Include new P5 HV definition in VF check.

Zhen Lei <thunder.leizhen@huawei.com>
    net: bnx2: Fix error return code in bnx2_init_board()

Dan Carpenter <dan.carpenter@oracle.com>
    net: hso: check for allocation failure in hso_create_bulk_serial_device()

Yunsheng Lin <linyunsheng@huawei.com>
    net: sched: fix tx action reschedule issue with stopped queue

Yunsheng Lin <linyunsheng@huawei.com>
    net: sched: fix tx action rescheduling issue during deactivation

Yunsheng Lin <linyunsheng@huawei.com>
    net: sched: fix packet stuck problem for lockless qdisc

Jim Ma <majinjing3@gmail.com>
    tls splice: check SPLICE_F_NONBLOCK instead of MSG_DONTWAIT

Tao Liu <thomas.liu@ucloud.cn>
    openvswitch: meter: fix race when getting now_ms.

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: mdio: octeon: Fix some double free issues

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: mdio: thunder: Fix a double free issue in the .remove function

Fugang Duan <fugang.duan@nxp.com>
    net: fec: fix the potential memory leak in fec_enet_init()

Paolo Abeni <pabeni@redhat.com>
    net: really orphan skbs tied to closing sk

Eric Farman <farman@linux.ibm.com>
    vfio-ccw: Check initialized flag in cp_init()

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Regmap must use_single_read/write

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: fix error code getting shifted with 4 in dsa_slave_get_sset_count

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: netcp: Fix an error message

Lang Yu <Lang.Yu@amd.com>
    drm/amd/amdgpu: fix a potential deadlock in gpu reset

xinhui pan <xinhui.pan@amd.com>
    drm/amdgpu: Fix a use-after-free

Jingwen Chen <Jingwen.Chen2@amd.com>
    drm/amd/amdgpu: fix refcount leak

Chris Park <Chris.Park@amd.com>
    drm/amd/display: Disconnect non-DP with no EDID

Steve French <stfrench@microsoft.com>
    SMB3: incorrect file id in requests compounded with open

Teava Radu <rateava@gmail.com>
    platform/x86: touchscreen_dmi: Add info for the Mediacom Winpad 7.0 W700 tablet

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    platform/x86: intel_punit_ipc: Append MODULE_DEVICE_TABLE for ACPI

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86: hp-wireless: add AMD's hardware id to the supported list

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not BUG_ON in link_to_fixup_dir

Peter Zijlstra <peterz@infradead.org>
    openrisc: Define memory barrier mb

Matt Wang <wwentao@vmware.com>
    scsi: BusLogic: Fix 64-bit system enumeration error for Buslogic

Boris Burkov <boris@bur.io>
    btrfs: return whole extents in fiemap

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    brcmfmac: properly check for bus register errors

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "brcmfmac: add a check for the status of usb_register"

Tom Seewald <tseewald@gmail.com>
    net: liquidio: Add missing null pointer checks

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "net: liquidio: fix a NULL pointer dereference"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    media: gspca: properly check for errors in po1030_probe()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "media: gspca: Check the return value of write_bridge for timeout"

Alaa Emad <alaaemadhossney.ae@gmail.com>
    media: gspca: mt9m111: Check write_bridge for timeout

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "media: gspca: mt9m111: Check write_bridge for timeout"

Alaa Emad <alaaemadhossney.ae@gmail.com>
    media: dvb: Add check on sp8870_readreg return

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "media: dvb: Add check on sp8870_readreg"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    ASoC: cs43130: handle errors in cs43130_probe() properly

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ASoC: cs43130: fix a NULL pointer dereference"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    libertas: register sysfs groups properly

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "libertas: add checks for the return value of sysfs_create_group"

Phillip Potter <phil@philpotter.co.uk>
    dmaengine: qcom_hidma: comment platform_driver_register call

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "dmaengine: qcom_hidma: Check for driver register failure"

Phillip Potter <phil@philpotter.co.uk>
    isdn: mISDN: correctly handle ph_info allocation failure in hfcsusb_ph_info

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "isdn: mISDN: Fix potential NULL pointer dereference of kzalloc"

Anirudh Rayabharam <mail@anirudhrb.com>
    ath6kl: return error code in ath6kl_wmi_set_roam_lrssi_cmd()

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ath6kl: return error code in ath6kl_wmi_set_roam_lrssi_cmd()"

Phillip Potter <phil@philpotter.co.uk>
    isdn: mISDNinfineon: check/cleanup ioremap failure correctly in setup_io

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "isdn: mISDNinfineon: fix potential NULL pointer dereference"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ALSA: usx2y: Fix potential NULL pointer dereference"

Atul Gopinathan <atulgopinathan@gmail.com>
    ALSA: sb8: Add a comment note regarding an unused pointer

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ALSA: gus: add a check of the status of snd_ctl_add"

Tom Seewald <tseewald@gmail.com>
    char: hpet: add checks after calling ioremap

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "char: hpet: fix a missing check of ioremap"

Du Cheng <ducheng2@gmail.com>
    net: caif: remove BUG_ON(dev == NULL) in caif_xmit

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "net/smc: fix a NULL pointer dereference"

Anirudh Rayabharam <mail@anirudhrb.com>
    net: fujitsu: fix potential null-ptr-deref

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "net: fujitsu: fix a potential NULL pointer dereference"

Atul Gopinathan <atulgopinathan@gmail.com>
    serial: max310x: unregister uart driver in case of failure and abort

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "serial: max310x: pass return value of spi_register_driver"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "ALSA: sb: fix a missing check of snd_ctl_add"

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "media: usb: gspca: add a missed check for goto_low_power"

Zou Wei <zou_wei@huawei.com>
    gpio: cadence: Add missing MODULE_DEVICE_TABLE

Kai-Heng Feng <kai.heng.feng@canonical.com>
    platform/x86: hp_accel: Avoid invoking _INI to speed up resume

Felix Fietkau <nbd@nbd.name>
    perf jevents: Fix getting maximum number of fds

Geert Uytterhoeven <geert+renesas@glider.be>
    i2c: sh_mobile: Use new clock calculation formulas for RZ/G2E

Jean Delvare <jdelvare@suse.de>
    i2c: i801: Don't generate an interrupt on bus reset

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    i2c: s3c2410: fix possible NULL pointer deref on read message after write

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: error out on unsupported PHY mode

Dan Carpenter <dan.carpenter@oracle.com>
    net: dsa: fix a crash if ->get_sset_count() fails

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mt7530: fix VLAN traffic leaks

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    spi: spi-fsl-dspi: Fix a resource leak in an error handling path

Xin Long <lucien.xin@gmail.com>
    tipc: skb_linearize the head skb when reassembling msgs

Xin Long <lucien.xin@gmail.com>
    tipc: wait and exit until all work queues are done

Hoang Le <hoang.h.le@dektech.com.au>
    Revert "net:tipc: Fix a double free in tipc_sk_mcast_rcv"

Vladyslav Tarasiuk <vladyslavt@nvidia.com>
    net/mlx4: Fix EEPROM dump support

Dima Chumak <dchumak@nvidia.com>
    net/mlx5e: Fix nullptr in add_vlan_push_action()

Dima Chumak <dchumak@nvidia.com>
    net/mlx5e: Fix multipath lag activation

Neil Armstrong <narmstrong@baylibre.com>
    drm/meson: fix shutdown crash when component not probed

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    NFSv4: Fix v4.0/v4.1 SEEK_DATA return -ENOTSUPP when set NFS_V4_2 config

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't corrupt the value of pg_bytes_written in nfs_do_recoalesce()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix an Oopsable condition in __nfs_pageio_add_request()

Dan Carpenter <dan.carpenter@oracle.com>
    NFS: fix an incorrect limit in filelayout_decode_layout()

zhouchuangao <zhouchuangao@vivo.com>
    fs/nfs: Use fatal_signal_pending instead of signal_pending

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    Bluetooth: cmtp: fix file refcount when cmtp_attach_device fails

Lukas Wunner <lukas@wunner.de>
    spi: spi-geni-qcom: Fix use-after-free on unbind

Pavel Skripkin <paskripkin@gmail.com>
    net: usb: fix memory leak in smsc75xx_bind

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    usb: gadget: udc: renesas_usb3: Fix a race in usb3_start_pipen()

Thinh Nguyen <Thinh.Nguyen@synopsys.com>
    usb: dwc3: gadget: Properly track pending and queued SG

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    thermal/drivers/intel: Initialize RW trip to THERMAL_TEMP_INVALID

Zolton Jheng <s6668c2t@gmail.com>
    USB: serial: pl2303: add device id for ADLINK ND-6530 GC

Dominik Andreas Schorpp <dominik.a.schorpp@ids.de>
    USB: serial: ftdi_sio: add IDs for IDS GmbH Products

Daniele Palmas <dnlplm@gmail.com>
    USB: serial: option: add Telit LE910-S1 compositions 0x7010, 0x7011

Sean MacLennan <seanm@seanm.ca>
    USB: serial: ti_usb_3410_5052: add startech.com device id

Zheyu Ma <zheyuma97@gmail.com>
    serial: rp2: use 'request_firmware' instead of 'request_firmware_nowait'

Geert Uytterhoeven <geert+renesas@glider.be>
    serial: sh-sci: Fix off-by-one error in FIFO threshold register setting

Colin Ian King <colin.king@canonical.com>
    serial: tegra: Fix a mask operation that is always true

Alan Stern <stern@rowland.harvard.edu>
    USB: usbfs: Don't WARN about excessively large memory allocations

Johan Hovold <johan@kernel.org>
    USB: trancevibrator: fix control-request direction

Christian Gmeiner <christian.gmeiner@gmail.com>
    serial: 8250_pci: handle FL_NOIRQ board flag

Randy Wright <rwright@hpe.com>
    serial: 8250_pci: Add support for new HPE serial device

YueHaibing <yuehaibing@huawei.com>
    iio: adc: ad7793: Add missing error code in ad7793_setup()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7124: Fix potential overflow due to non sequential channel numbers

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7124: Fix missbalanced regulator enable / disable on error.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7768-1: Fix too small buffer passed to iio_push_to_buffers_with_timestamp()

Rui Miguel Silva <rui.silva@linaro.org>
    iio: gyro: fxas21002c: balance runtime power in error path

Lucas Stankus <lucas.p.stankus@gmail.com>
    staging: iio: cdc: ad7746: avoid overwrite of num_channels

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: request autosuspend after sending rx flow control

Mathias Nyman <mathias.nyman@linux.intel.com>
    thunderbolt: dma_port: Fix NVM read buffer bounds and offset issue

Dongliang Mu <mudongliangabcd@gmail.com>
    misc/uss720: fix memory leak in uss720_probe

Ondrej Mosnacek <omosnace@redhat.com>
    serial: core: fix suspicious security_locked_down() call

Sargun Dhillon <sargun@sargun.me>
    Documentation: seccomp: Fix user notification documentation

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kgdb: fix gcc-11 warnings harder

Michael Ellerman <mpe@ellerman.id.au>
    selftests/gpio: Fix build when source tree is read only

Michael Ellerman <mpe@ellerman.id.au>
    selftests/gpio: Move include of lib.mk up

Michael Ellerman <mpe@ellerman.id.au>
    selftests/gpio: Use TEST_GEN_PROGS_EXTENDED

James Zhu <James.Zhu@amd.com>
    drm/amdgpu/vcn2.5: add cancel_delayed_work_sync before power gate

James Zhu <James.Zhu@amd.com>
    drm/amdgpu/vcn2.0: add cancel_delayed_work_sync before power gate

James Zhu <James.Zhu@amd.com>
    drm/amdgpu/vcn1: add cancel_delayed_work_sync before power gate

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: properly fix a crash when an origin has no snapshots

Sriram R <srirrama@codeaurora.org>
    ath10k: Validate first subframe of A-MSDU before processing the list

Wen Gong <wgong@codeaurora.org>
    ath10k: Fix TKIP Michael MIC verification for PCIe

Wen Gong <wgong@codeaurora.org>
    ath10k: drop MPDU which has discard flag set by firmware for SDIO

Wen Gong <wgong@codeaurora.org>
    ath10k: drop fragments with multicast DA for SDIO

Wen Gong <wgong@codeaurora.org>
    ath10k: drop fragments with multicast DA for PCIe

Wen Gong <wgong@codeaurora.org>
    ath10k: add CCMP PN replay protection for fragmented frames for PCIe

Wen Gong <wgong@codeaurora.org>
    mac80211: extend protection against mixed key and fragment cache attacks

Johannes Berg <johannes.berg@intel.com>
    mac80211: do not accept/forward invalid EAPOL frames

Johannes Berg <johannes.berg@intel.com>
    mac80211: prevent attacks on TKIP/WEP as well

Johannes Berg <johannes.berg@intel.com>
    mac80211: check defrag PN against current frame

Johannes Berg <johannes.berg@intel.com>
    mac80211: add fragment cache to sta_info

Johannes Berg <johannes.berg@intel.com>
    mac80211: drop A-MSDUs on old ciphers

Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
    cfg80211: mitigate A-MSDU aggregation attacks

Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
    mac80211: properly handle A-MSDUs that start with an RFC 1042 header

Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
    mac80211: prevent mixed key and fragment cache attacks

Mathy Vanhoef <Mathy.Vanhoef@kuleuven.be>
    mac80211: assure all fragments are encrypted

Johan Hovold <johan@kernel.org>
    net: hso: fix control-request directions

Kees Cook <keescook@chromium.org>
    proc: Check /proc/$pid/attr/ writes against file opener

Adrian Hunter <adrian.hunter@intel.com>
    perf scripts python: exported-sql-viewer.py: Fix warning display

Adrian Hunter <adrian.hunter@intel.com>
    perf scripts python: exported-sql-viewer.py: Fix Array TypeError

Adrian Hunter <adrian.hunter@intel.com>
    perf scripts python: exported-sql-viewer.py: Fix copy to clipboard from Top Calls by elapsed Time report

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix transaction abort handling

Adrian Hunter <adrian.hunter@intel.com>
    perf intel-pt: Fix sample instruction bytes

Rolf Eike Beer <eb@emlix.com>
    iommu/vt-d: Fix sysfs leak in alloc_iommu()

Anna Schumaker <Anna.Schumaker@Netapp.com>
    NFSv4: Fix a NULL pointer dereference in pnfs_mark_matching_lsegs_return()

Aurelien Aptel <aaptel@suse.com>
    cifs: set server->cipher_type to AES-128-CCM for SMB3.0

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: scarlett2: Improve driver startup messages

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: scarlett2: Fix device hang with ehci-pci

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek: Headphone volume is controlled by Front mixer


-------------

Diffstat:

 Documentation/userspace-api/seccomp_filter.rst     |  16 +-
 Makefile                                           |   4 +-
 arch/mips/alchemy/board-xxs1500.c                  |   1 +
 arch/mips/ralink/of.c                              |   2 +
 arch/openrisc/include/asm/barrier.h                |   9 +
 drivers/char/hpet.c                                |   2 +
 drivers/dma/qcom/hidma_mgmt.c                      |  17 +-
 drivers/gpio/gpio-cadence.c                        |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c             |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c              |   6 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c              |   2 +
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |   2 +
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |  18 ++
 drivers/gpu/drm/i915/display/intel_dp.c            |  15 +-
 drivers/gpu/drm/meson/meson_drv.c                  |   9 +-
 drivers/i2c/busses/i2c-i801.c                      |   6 +-
 drivers/i2c/busses/i2c-s3c2410.c                   |   3 +
 drivers/i2c/busses/i2c-sh_mobile.c                 |   2 +-
 drivers/iio/adc/ad7124.c                           |  36 ++--
 drivers/iio/adc/ad7768-1.c                         |   8 +-
 drivers/iio/adc/ad7793.c                           |   1 +
 drivers/iio/gyro/fxas21002c_core.c                 |   2 +
 drivers/iommu/dmar.c                               |   4 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |  17 +-
 drivers/isdn/hardware/mISDN/mISDNinfineon.c        |  21 ++-
 drivers/md/dm-snap.c                               |   2 +-
 drivers/media/dvb-frontends/sp8870.c               |   2 +-
 drivers/media/usb/gspca/cpia1.c                    |   6 +-
 drivers/media/usb/gspca/m5602/m5602_mt9m111.c      |  16 +-
 drivers/media/usb/gspca/m5602/m5602_po1030.c       |  14 +-
 drivers/misc/kgdbts.c                              |   3 +-
 drivers/misc/lis3lv02d/lis3lv02d.h                 |   1 +
 drivers/misc/mei/interrupt.c                       |   3 +
 drivers/net/caif/caif_serial.c                     |   1 -
 drivers/net/dsa/mt7530.c                           |   8 -
 drivers/net/dsa/sja1105/sja1105_main.c             |   1 +
 drivers/net/ethernet/broadcom/bnx2.c               |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   3 +-
 drivers/net/ethernet/brocade/bna/bnad.c            |   7 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |  27 ++-
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c |  27 ++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |   2 +-
 drivers/net/ethernet/dec/tulip/de4x5.c             |   4 +-
 drivers/net/ethernet/dec/tulip/media.c             |   5 -
 drivers/net/ethernet/freescale/fec_main.c          |  11 +-
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c          |   4 +-
 drivers/net/ethernet/google/gve/gve_main.c         |  21 ++-
 drivers/net/ethernet/google/gve/gve_tx.c           |   8 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |  10 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |  16 +-
 drivers/net/ethernet/lantiq_xrx200.c               |  14 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  67 ++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |  24 ++-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |   2 +-
 drivers/net/ethernet/mellanox/mlx4/port.c          | 107 ++++++++++-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |   8 +-
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |   6 +
 drivers/net/ethernet/micrel/ksz884x.c              |   3 +-
 drivers/net/ethernet/microchip/lan743x_main.c      |   6 +-
 drivers/net/ethernet/neterion/vxge/vxge-traffic.c  |  32 ++--
 drivers/net/ethernet/sfc/falcon/farch.c            |  29 ++-
 drivers/net/ethernet/sis/sis900.c                  |   5 +-
 drivers/net/ethernet/synopsys/dwc-xlgmac-common.c  |   2 +-
 drivers/net/ethernet/ti/davinci_emac.c             |   5 +-
 drivers/net/ethernet/ti/netcp_core.c               |   4 +-
 drivers/net/ethernet/ti/tlan.c                     |   4 +-
 drivers/net/ethernet/via/via-velocity.c            |  13 --
 drivers/net/phy/mdio-octeon.c                      |   2 -
 drivers/net/phy/mdio-thunder.c                     |   1 -
 drivers/net/usb/hso.c                              |  45 +++--
 drivers/net/usb/smsc75xx.c                         |   8 +-
 drivers/net/wireless/ath/ath10k/htt.h              |   1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c           | 201 ++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/rx_desc.h          |  14 +-
 drivers/net/wireless/ath/ath6kl/debug.c            |   5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |   8 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  19 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  42 ++---
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   9 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.h    |   5 -
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   8 +-
 drivers/net/wireless/marvell/libertas/mesh.c       |  33 +---
 drivers/platform/x86/hp-wireless.c                 |   2 +
 drivers/platform/x86/hp_accel.c                    |  22 ++-
 drivers/platform/x86/intel_punit_ipc.c             |   1 +
 drivers/platform/x86/touchscreen_dmi.c             |   8 +
 drivers/s390/cio/vfio_ccw_cp.c                     |   4 +
 drivers/scsi/BusLogic.c                            |   6 +-
 drivers/scsi/BusLogic.h                            |   2 +-
 drivers/scsi/libsas/sas_port.c                     |   4 +-
 drivers/spi/spi-fsl-dspi.c                         |   4 +-
 drivers/spi/spi-geni-qcom.c                        |   3 +-
 drivers/staging/emxx_udc/emxx_udc.c                |   4 +-
 drivers/staging/iio/cdc/ad7746.c                   |   1 -
 .../intel/int340x_thermal/int340x_thermal_zone.c   |   4 +
 drivers/thermal/intel/x86_pkg_temp_thermal.c       |   2 +-
 drivers/thunderbolt/dma_port.c                     |  11 +-
 drivers/tty/serial/8250/8250_pci.c                 |  47 +++--
 drivers/tty/serial/max310x.c                       |   2 +
 drivers/tty/serial/rp2.c                           |  52 ++----
 drivers/tty/serial/serial-tegra.c                  |   2 +-
 drivers/tty/serial/serial_core.c                   |   8 +-
 drivers/tty/serial/sh-sci.c                        |   4 +-
 drivers/usb/core/devio.c                           |  11 +-
 drivers/usb/core/hub.h                             |   6 +-
 drivers/usb/dwc3/gadget.c                          |  13 +-
 drivers/usb/gadget/udc/renesas_usb3.c              |   5 +-
 drivers/usb/misc/trancevibrator.c                  |   4 +-
 drivers/usb/misc/uss720.c                          |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   7 +
 drivers/usb/serial/option.c                        |   4 +
 drivers/usb/serial/pl2303.c                        |   1 +
 drivers/usb/serial/pl2303.h                        |   1 +
 drivers/usb/serial/ti_usb_3410_5052.c              |   3 +
 fs/btrfs/extent_io.c                               |   7 +-
 fs/btrfs/tree-log.c                                |   2 -
 fs/cifs/smb2pdu.c                                  |  13 +-
 fs/nfs/filelayout/filelayout.c                     |   2 +-
 fs/nfs/nfs4file.c                                  |   2 +-
 fs/nfs/nfs4proc.c                                  |   4 +-
 fs/nfs/pagelist.c                                  |  21 +--
 fs/nfs/pnfs.c                                      |  15 +-
 fs/proc/base.c                                     |   4 +
 include/net/cfg80211.h                             |   4 +-
 include/net/pkt_sched.h                            |   7 +-
 include/net/sch_generic.h                          |  35 +++-
 include/net/sock.h                                 |   4 +-
 net/bluetooth/cmtp/core.c                          |   5 +
 net/core/dev.c                                     |  29 ++-
 net/core/filter.c                                  |   1 +
 net/core/neighbour.c                               |   4 +
 net/core/sock.c                                    |   8 +-
 net/dsa/master.c                                   |   5 +-
 net/dsa/slave.c                                    |  12 +-
 net/ipv6/mcast.c                                   |   3 -
 net/ipv6/reassembly.c                              |   4 +-
 net/mac80211/ieee80211_i.h                         |  36 ++--
 net/mac80211/iface.c                               |  11 +-
 net/mac80211/key.c                                 |   7 +
 net/mac80211/key.h                                 |   2 +
 net/mac80211/rx.c                                  | 150 +++++++++++----
 net/mac80211/sta_info.c                            |   6 +-
 net/mac80211/sta_info.h                            |  32 ++++
 net/mac80211/wpa.c                                 |  13 +-
 net/openvswitch/meter.c                            |   8 +
 net/sched/sch_dsmark.c                             |   3 +-
 net/sched/sch_generic.c                            |  50 ++++-
 net/smc/smc_ism.c                                  |   5 -
 net/tipc/core.c                                    |   3 +
 net/tipc/core.h                                    |   2 +
 net/tipc/msg.c                                     |   9 +-
 net/tipc/socket.c                                  |   5 +-
 net/tipc/udp_media.c                               |   2 +
 net/tls/tls_sw.c                                   |  11 +-
 net/wireless/util.c                                |   7 +-
 sound/isa/gus/gus_main.c                           |  13 +-
 sound/isa/sb/sb16_main.c                           |  10 +-
 sound/isa/sb/sb8.c                                 |   6 +-
 sound/pci/hda/patch_realtek.c                      |  23 +++
 sound/soc/codecs/cs35l33.c                         |   1 +
 sound/soc/codecs/cs42l42.c                         |   3 +
 sound/soc/codecs/cs43130.c                         |  28 ++-
 sound/usb/mixer_quirks.c                           |   2 +-
 sound/usb/mixer_scarlett_gen2.c                    |  81 ++++++---
 sound/usb/mixer_scarlett_gen2.h                    |   2 +-
 tools/perf/pmu-events/jevents.c                    |   2 +-
 tools/perf/scripts/python/exported-sql-viewer.py   |  12 +-
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |   6 +-
 tools/perf/util/intel-pt.c                         |   5 +-
 tools/testing/selftests/gpio/Makefile              |  24 +--
 174 files changed, 1467 insertions(+), 705 deletions(-)


