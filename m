Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ADA24B473D
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 10:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244473AbiBNJlw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 04:41:52 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:34468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244941AbiBNJlB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 04:41:01 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693573F334;
        Mon, 14 Feb 2022 01:36:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EC2B660FA2;
        Mon, 14 Feb 2022 09:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FDD3C340E9;
        Mon, 14 Feb 2022 09:36:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644831380;
        bh=ZvzWO3q5LJsF0HrYycAFdA1SCQjw16LLBPm/P507UmI=;
        h=From:To:Cc:Subject:Date:From;
        b=uoV+46XAd3JXjPhsvaq2+sAbKXMYhE5virR9txSqXsvvqAhQz/VLBxuN/vU1bQebn
         LpCscwD61t+h5OQx4N1eCDhYohLfvi19CFVh/Kg9gf94exv7/GDoKxhd90QmNfMlxS
         wLcXm7aKj82/Ptuw5AxvMARzAO01KLPQ4GuGD8KE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 00/71] 5.4.180-rc1 review
Date:   Mon, 14 Feb 2022 10:25:28 +0100
Message-Id: <20220214092452.020713240@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.180-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.180-rc1
X-KernelTest-Deadline: 2022-02-16T09:24+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.4.180 release.
There are 71 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 16 Feb 2022 09:24:36 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.180-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.180-rc1

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPI: PM: s2idle: Cancel wakeup before dispatching EC GPE

Song Liu <song@kernel.org>
    perf: Fix list corruption in perf_cgroup_switch()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Remove NVMe support if kernel has NVME_FC disabled

Armin Wolf <W_Armin@gmx.de>
    hwmon: (dell-smm) Speed up setting of fan speed

Kees Cook <keescook@chromium.org>
    seccomp: Invalidate seccomp mode to catch death failures

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: add CPI Bulk Coin Recycler id

Johan Hovold <johan@kernel.org>
    USB: serial: cp210x: add NCR Retail IO box id

Stephan Brunner <s.brunner@stephan-brunner.net>
    USB: serial: ch341: add support for GW Instek USB2.0-Serial devices

Pawel Dembicki <paweldembicki@gmail.com>
    USB: serial: option: add ZTE MF286D modem

Cameron Williams <cang1@live.co.uk>
    USB: serial: ftdi_sio: add support for Brainboxes US-159/235/320

Pavel Hofman <pavel.hofman@ivitera.com>
    usb: gadget: f_uac2: Define specific wTerminalType

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    usb: gadget: rndis: check size of RNDIS_MSG_SET command

Szymon Heidrich <szymon.heidrich@gmail.com>
    USB: gadget: validate interface OS descriptor requests

Adam Ford <aford173@gmail.com>
    usb: gadget: udc: renesas_usb3: Fix host to USB_ROLE_NONE transition

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: dwc3: gadget: Prevent core from processing stale TRBs

Sean Anderson <sean.anderson@seco.com>
    usb: ulpi: Call of_node_put correctly

Sean Anderson <sean.anderson@seco.com>
    usb: ulpi: Move of_node_put to ulpi_dev_release

Jann Horn <jannh@google.com>
    net: usb: ax88179_178a: Fix out-of-bounds accesses in RX fixup

Jonas Malaco <jonas@protocubo.io>
    eeprom: ee1004: limit i2c reads to I2C_SMBUS_BLOCK_MAX

TATSUKAWA KOSUKE (立川 江介) <tatsu-ab1@nec.com>
    n_tty: wake up poll(POLLRDNORM) on receiving data

Jakob Koschel <jakobkoschel@gmail.com>
    vt_ioctl: add array_index_nospec to VT_ACTIVATE

Jakob Koschel <jakobkoschel@gmail.com>
    vt_ioctl: fix array_index_nospec in vt_setactivate

Raju Rangoju <Raju.Rangoju@amd.com>
    net: amd-xgbe: disable interrupts during pci removal

Jon Maloy <jmaloy@redhat.com>
    tipc: rate limit warning for received illegal binding update

Joel Stanley <joel@jms.id.au>
    net: mdio: aspeed: Add missing MODULE_DEVICE_TABLE

Eric Dumazet <edumazet@google.com>
    veth: fix races around rq->rx_notify_masked

Antoine Tenart <atenart@kernel.org>
    net: fix a memleak when uncloning an skb dst and its metadata

Antoine Tenart <atenart@kernel.org>
    net: do not keep the dst cache when uncloning an skb dst and its metadata

Louis Peens <louis.peens@corigine.com>
    nfp: flower: fix ida_idx not being released

Eric Dumazet <edumazet@google.com>
    ipmr,ip6mr: acquire RTNL before calling ip[6]mr_free_table() on failure path

Mahesh Bandewar <maheshb@google.com>
    bonding: pair enable_port with slave_arr_updates

Samuel Mendoza-Jonas <samjonas@amazon.com>
    ixgbevf: Require large buffers for build_skb on 82599VF

Mathias Krause <minipli@grsecurity.net>
    misc: fastrpc: avoid double fput() on failed usercopy

Udipto Goswami <quic_ugoswami@quicinc.com>
    usb: f_fs: Fix use-after-free for epfile

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx6qdl-udoo: Properly describe the SD card detect

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    staging: fbtft: Fix error path in fbtft_driver_module_init()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    ARM: dts: meson: Fix the UART compatible strings

Zechuan Chen <chenzechuan1@huawei.com>
    perf probe: Fix ppc64 'perf probe add events failed' case

Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
    net: bridge: fix stale eth hdr pointer in br_dev_xmit

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: s2idle: ACPI: Fix wakeup interrupts handling

Robin Murphy <robin.murphy@arm.com>
    ACPI/IORT: Check node revision for PMCG resources

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: fix bogus request completion when failing to send AER

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ARM: socfpga: fix missing RESET_CONTROLLER

Fabio Estevam <festevam@gmail.com>
    ARM: dts: imx23-evk: Remove MX23_PAD_SSP1_DETECT from hog group

Aurelien Jarno <aurelien@aurel32.net>
    riscv: fix build with binutils 2.38

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Add kconfig knob for disabling unpriv bpf by default

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: nVMX: eVMCS: Filter out VM_EXIT_SAVE_VMX_PREEMPTION_TIMER

Jisheng Zhang <jszhang@kernel.org>
    net: stmmac: dwmac-sun8i: use return val of readl_poll_timeout()

Amelie Delaunay <amelie.delaunay@foss.st.com>
    usb: dwc2: gadget: don't try to disable ep0 in dwc2_hsotg_suspend

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    PM: hibernate: Remove register_nosave_region_late()

Tong Zhang <ztong0001@gmail.com>
    scsi: myrs: Fix crash in error case

Saurav Kashyap <skashyap@marvell.com>
    scsi: qedf: Fix refcount issue when LOGO is received during TMF

ZouMingzhe <mingzhe.zou@easystack.cn>
    scsi: target: iscsi: Make sure the np under each tpg is unique

Victor Nogueira <victor@mojatatu.com>
    net: sched: Clarify error message when qdisc kind is unknown

Raymond Jay Golo <rjgolo@gmail.com>
    drm: panel-orientation-quirks: Add quirk for the 1Netbook OneXPlayer

Olga Kornievskaia <kolga@netapp.com>
    NFSv4 expose nfs_parse_server_name function

Olga Kornievskaia <kolga@netapp.com>
    NFSv4 remove zero number of fs_locations entries error check

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.1: Fix uninitialised variable in devicenotify

Xiaoke Wang <xkernel.wang@foxmail.com>
    nfs: nfs4clinet: check the return value of kstrdup()

Olga Kornievskaia <kolga@netapp.com>
    NFSv4 only print the label when its queried

Prabhath Sajeepa <psajeepa@purestorage.com>
    nvme: Fix parsing of ANA log page

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Fix offset type in I/O trace points

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Clamp WRITE offsets

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix initialisation of nfs_client cl_flags field

Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
    net: phy: marvell: Fix MDI-x polarity setting in 88e1118-compatible PHYs

Pavel Parkhomenko <Pavel.Parkhomenko@baikalelectronics.ru>
    net: phy: marvell: Fix RGMII Tx/Rx delays setting in 88e1121-compatible PHYs

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    mmc: sdhci-of-esdhc: Check for error num after setting mask

Stefan Berger <stefanb@linux.ibm.com>
    ima: Do not print policy rule with inactive LSM labels

Roberto Sassu <roberto.sassu@huawei.com>
    ima: Allow template selection with ima_template[_fmt]= after ima_hash=

Stefan Berger <stefanb@linux.ibm.com>
    ima: Remove ima_policy file before directory

Xiaoke Wang <xkernel.wang@foxmail.com>
    integrity: check the return value of audit_log_start()


-------------

Diffstat:

 Documentation/admin-guide/sysctl/kernel.rst        | 21 +++++++
 Makefile                                           |  4 +-
 arch/arm/boot/dts/imx23-evk.dts                    |  1 -
 arch/arm/boot/dts/imx6qdl-udoo.dtsi                |  5 +-
 arch/arm/boot/dts/meson.dtsi                       |  8 +--
 arch/arm/mach-socfpga/Kconfig                      |  2 +
 arch/riscv/Makefile                                |  6 ++
 arch/x86/kvm/vmx/evmcs.h                           |  4 +-
 drivers/acpi/arm64/iort.c                          | 14 ++++-
 drivers/acpi/ec.c                                  | 10 ++++
 drivers/acpi/sleep.c                               | 15 ++---
 drivers/base/power/wakeup.c                        | 41 ++++++++++---
 drivers/gpu/drm/drm_panel_orientation_quirks.c     | 12 ++++
 drivers/hwmon/dell-smm-hwmon.c                     | 12 ++--
 drivers/misc/eeprom/ee1004.c                       |  3 +
 drivers/misc/fastrpc.c                             |  9 ++-
 drivers/mmc/host/sdhci-of-esdhc.c                  |  8 ++-
 drivers/net/bonding/bond_3ad.c                     |  3 +-
 drivers/net/ethernet/amd/xgbe/xgbe-pci.c           |  3 +
 drivers/net/ethernet/intel/ixgbevf/ixgbevf_main.c  | 13 +++--
 .../ethernet/netronome/nfp/flower/tunnel_conf.c    | 12 ++--
 drivers/net/ethernet/stmicro/stmmac/dwmac-sun8i.c  |  2 +-
 drivers/net/phy/marvell.c                          | 17 +++---
 drivers/net/phy/mdio-aspeed.c                      |  1 +
 drivers/net/usb/ax88179_178a.c                     | 68 +++++++++++++---------
 drivers/net/veth.c                                 | 13 +++--
 drivers/nvme/host/multipath.c                      | 12 ++--
 drivers/nvme/host/tcp.c                            | 10 +++-
 drivers/scsi/lpfc/lpfc.h                           | 13 ++++-
 drivers/scsi/lpfc/lpfc_attr.c                      |  4 +-
 drivers/scsi/myrs.c                                |  3 +-
 drivers/scsi/qedf/qedf_io.c                        |  1 +
 drivers/staging/fbtft/fbtft.h                      |  5 +-
 drivers/target/iscsi/iscsi_target_tpg.c            |  3 +
 drivers/tty/n_tty.c                                |  4 +-
 drivers/tty/vt/vt_ioctl.c                          |  5 +-
 drivers/usb/common/ulpi.c                          | 10 +++-
 drivers/usb/dwc2/gadget.c                          |  2 +-
 drivers/usb/dwc3/gadget.c                          | 13 +++++
 drivers/usb/gadget/composite.c                     |  3 +
 drivers/usb/gadget/function/f_fs.c                 | 56 +++++++++++++-----
 drivers/usb/gadget/function/f_uac2.c               |  4 +-
 drivers/usb/gadget/function/rndis.c                |  9 ++-
 drivers/usb/gadget/udc/renesas_usb3.c              |  2 +
 drivers/usb/serial/ch341.c                         |  1 +
 drivers/usb/serial/cp210x.c                        |  2 +
 drivers/usb/serial/ftdi_sio.c                      |  3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |  3 +
 drivers/usb/serial/option.c                        |  2 +
 fs/nfs/callback.h                                  |  2 +-
 fs/nfs/callback_proc.c                             |  2 +-
 fs/nfs/callback_xdr.c                              | 18 +++---
 fs/nfs/client.c                                    |  2 +-
 fs/nfs/nfs4_fs.h                                   |  3 +-
 fs/nfs/nfs4client.c                                |  5 +-
 fs/nfs/nfs4namespace.c                             |  4 +-
 fs/nfs/nfs4state.c                                 |  3 +
 fs/nfs/nfs4xdr.c                                   |  9 ++-
 fs/nfsd/nfs3proc.c                                 |  5 ++
 fs/nfsd/nfs4proc.c                                 |  5 +-
 fs/nfsd/trace.h                                    | 14 ++---
 include/linux/suspend.h                            | 15 +----
 include/net/dst_metadata.h                         | 14 ++++-
 init/Kconfig                                       | 10 ++++
 kernel/bpf/syscall.c                               |  3 +-
 kernel/events/core.c                               |  4 +-
 kernel/power/main.c                                |  5 +-
 kernel/power/process.c                             |  2 +-
 kernel/power/snapshot.c                            | 21 +++----
 kernel/power/suspend.c                             |  2 -
 kernel/seccomp.c                                   | 10 ++++
 kernel/sysctl.c                                    | 29 +++++++--
 net/bridge/br_device.c                             |  6 +-
 net/ipv4/ipmr.c                                    |  2 +
 net/ipv6/ip6mr.c                                   |  2 +
 net/sched/sch_api.c                                |  2 +-
 net/tipc/name_distr.c                              |  2 +-
 security/integrity/ima/ima_fs.c                    |  2 +-
 security/integrity/ima/ima_policy.c                |  8 +++
 security/integrity/ima/ima_template.c              | 10 +++-
 security/integrity/integrity_audit.c               |  2 +
 tools/perf/util/probe-event.c                      |  3 +
 82 files changed, 496 insertions(+), 207 deletions(-)


