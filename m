Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DBEA39610B
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:33:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233238AbhEaOfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234032AbhEaOdE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:33:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1C64D6162A;
        Mon, 31 May 2021 13:49:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468984;
        bh=Ty2Bd/uGyHZrxPpCk5+ScacDhglSwogUYcKDHx/Qux8=;
        h=From:To:Cc:Subject:Date:From;
        b=bXuV2x9OciTaj3FV1Qx6Zp7etDSk2/Po/nYSvpq1AHezcYdSaOkyvBrhvMcmDNnH7
         yIGabAmK7PvufE9bidIBIHad1R6uMcGFPucv6frzWmUxd20LNOO2P1hKNDR67/wK/5
         NTbjnfl15KcKNQiW5g+TAB6hPWECUHzPA5XOAm+k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.12 000/296] 5.12.9-rc1 review
Date:   Mon, 31 May 2021 15:10:55 +0200
Message-Id: <20210531130703.762129381@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.9-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.9-rc1
X-KernelTest-Deadline: 2021-06-02T13:07+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.12.9 release.
There are 296 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.9-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.12.9-rc1

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: core: reduce power-on-good delay time of root hub

Chinmay Agarwal <chinagar@codeaurora.org>
    neighbour: Prevent Race condition in neighbour subsytem

Jisheng Zhang <Jisheng.Zhang@synaptics.com>
    arm64: mm: don't use CON and BLK mapping if KFENCE is enabled

Johan Hovold <johan@kernel.org>
    net: hso: bail out on interrupt URB allocation failure

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "Revert "ALSA: usx2y: Fix potential NULL pointer dereference""

Liu Jian <liujian56@huawei.com>
    bpftool: Add sock_release help info for cgroup attach/prog load command

Yunsheng Lin <linyunsheng@huawei.com>
    net: hns3: check the return of skb_checksum_help()

Magnus Karlsson <magnus.karlsson@intel.com>
    samples/bpf: Consider frame size in tx_only of xdpsock sample

Chuck Lever <chuck.lever@oracle.com>
    xprtrdma: Revert 586a0787ce35

Wanpeng Li <wanpengli@tencent.com>
    KVM: X86: hyper-v: Task srcu lock when accessing kvm_memslots()

Yang Yingliang <yangyingliang@huawei.com>
    thermal/drivers/qcom: Fix error code in adc_tm5_get_dt_channel_data()

Trond Myklebust <trond.myklebust@hammerspace.com>
    SUNRPC: More fixes for backlog congestion

Stefan Chulski <stefanc@marvell.com>
    net: mvpp2: add buffer header handling in RX

Vlad Buslov <vladbu@nvidia.com>
    net: zero-initialize tc skb extension on allocation

Randy Dunlap <rdunlap@infradead.org>
    MIPS: ralink: export rt_sysc_membase for rt2880_wdt.c

Randy Dunlap <rdunlap@infradead.org>
    MIPS: alchemy: xxs1500: add gpio-au1000.h header file

George McCollister <george.mccollister@gmail.com>
    net: hsr: fix mac_len checks

Taehee Yoo <ap420073@gmail.com>
    sch_dsmark: fix a NULL deref in qdisc_reset()

Stefan Roese <sr@denx.de>
    net: ethernet: mtk_eth_soc: Fix packet statistics support for MT7628/88

kernel test robot <lkp@intel.com>
    ALSA: usb-audio: scarlett2: snd_scarlett_gen2_controls_create() can be static

Tom Rix <trix@redhat.com>
    scsi: aic7xxx: Restore several defines for aic7xxx firmware build

Francesco Ruggeri <fruggeri@arista.com>
    ipv6: record frag_max_size in atomic fragments in input path

Aleksander Jan Bajkowski <olek2@wp.pl>
    net: lantiq: fix memory corruption in RX ring

Dan Carpenter <dan.carpenter@oracle.com>
    scsi: libsas: Use _safe() loop in sas_resume_port()

Stephen Boyd <swboyd@chromium.org>
    ASoC: qcom: lpass-cpu: Use optional clk APIs

Jesse Brandeburg <jesse.brandeburg@intel.com>
    ixgbe: fix large MTU request from VF

Jussi Maki <joamaki@gmail.com>
    bpf: Set mac_len in bpf_skb_change_head

Yinjun Zhang <yinjun.zhang@corigine.com>
    bpf, offload: Reorder offload callback 'prepare' in verifier

Dan Carpenter <dan.carpenter@oracle.com>
    ASoC: cs35l33: fix an error code in probe()

Dan Carpenter <dan.carpenter@oracle.com>
    staging: emxx_udc: fix loop in _nbu2ss_nuke()

Raju Rangoju <rajur@chelsio.com>
    cxgb4: avoid accessing registers when clearing filters

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Use user privilege for RID2PASID translation

Dan Carpenter <dan.carpenter@oracle.com>
    iommu/vt-d: Check for allocation failure in aux_detach_device()

Vlad Buslov <vladbu@nvidia.com>
    net/mlx5e: Reject mirroring on source port change encap rules

Roi Dayan <roid@nvidia.com>
    net/mlx5e: Make sure fib dev exists in fib event

Parav Pandit <parav@nvidia.com>
    net/mlx5: SF, Fix show state inactive when its inactivated

Huazhong Tan <tanhuazhong@huawei.com>
    net: hns3: fix user's coalesce configuration lost issue

Jian Shen <shenjian15@huawei.com>
    net: hns3: put off calling register_netdev() until client initialize complete

Jiaran Zhang <zhangjiaran@huawei.com>
    net: hns3: fix incorrect resp_msg issue

Bixuan Cui <cuibixuan@huawei.com>
    iommu/virtio: Add missing MODULE_DEVICE_TABLE

Jean-Philippe Brucker <jean-philippe@linaro.org>
    iommu/amd: Clear DMA ops when switching domain

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

Julian Wiedmann <jwi@linux.ibm.com>
    net/smc: remove device from smcd_dev_list after failed device_add()

Taehee Yoo <ap420073@gmail.com>
    mld: fix panic in mld_newpack()

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix context memory setup for 64K page size.

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

Ayush Sawal <ayush.sawal@chelsio.com>
    cxgb4/ch_ktls: Clear resources when pf4 device is removed

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: mdio: octeon: Fix some double free issues

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: mdio: thunder: Fix a double free issue in the .remove function

Dan Carpenter <dan.carpenter@oracle.com>
    chelsio/chtls: unlock on error in chtls_pt_recvmsg()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    ptp: ocp: Fix a resource leak in an error handling path

Dan Carpenter <dan.carpenter@oracle.com>
    octeontx2-pf: fix a buffer overflow in otx2_set_rxfh_context()

Fugang Duan <fugang.duan@nxp.com>
    net: fec: fix the potential memory leak in fec_enet_init()

Richard Sanger <rsanger@wand.net.nz>
    net: packetmmap: fix only tx timestamp on request

Paolo Abeni <pabeni@redhat.com>
    net: really orphan skbs tied to closing sk

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    spi: Assume GPIO CS active high in ACPI case

Eric Farman <farman@linux.ibm.com>
    vfio-ccw: Check initialized flag in cp_init()

Alex Elder <elder@linaro.org>
    net: ipa: memory region array is variable size

Joakim Zhang <qiangqing.zhang@nxp.com>
    net: stmmac: Fix MAC WoL not working if PHY does not support WoL

Richard Fitzgerald <rf@opensource.cirrus.com>
    ASoC: cs42l42: Regmap must use_single_read/write

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fix lack of removing request from pending list.

Zou Wei <zou_wei@huawei.com>
    interconnect: qcom: Add missing MODULE_DEVICE_TABLE

Subbaraman Narayanamurthy <subbaram@codeaurora.org>
    interconnect: qcom: bcm-voter: add a missing of_node_put()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: fix error code getting shifted with 4 in dsa_slave_get_sset_count

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    net: netcp: Fix an error message

Leilk Liu <leilk.liu@mediatek.com>
    spi: take the SPI IO-mutex in the spi_set_cs_timing method

Rikard Falkeborn <rikard.falkeborn@gmail.com>
    linux/bits.h: fix compilation error with GENMASK

Gulam Mohamed <gulam.mohamed@oracle.com>
    block: fix a race between del_gendisk and BLKRRPART

Hans de Goede <hdegoede@redhat.com>
    platform/x86: touchscreen_dmi: Add info for the Chuwi Hi10 Pro (CWI529) tablet

Christian König <christian.koenig@amd.com>
    drm/amdgpu: stop touching sched.ready in the backend

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

Takashi Sakamoto <o-takashi@sakamocchi.jp>
    ALSA: dice: disable double_pcm_frames mode for M-Audio Profire 610, 2626 and Avid M-Box 3 Pro

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not BUG_ON in link_to_fixup_dir

Filipe Manana <fdmanana@suse.com>
    btrfs: release path before starting transaction when cloning inline extent

Ajish Koshy <ajish.koshy@microchip.com>
    scsi: pm80xx: Fix drives missing during rmmod/insmod loop

Peter Zijlstra <peterz@infradead.org>
    openrisc: Define memory barrier mb

Matt Wang <wwentao@vmware.com>
    scsi: BusLogic: Fix 64-bit system enumeration error for Buslogic

Peter Wang <peter.wang@mediatek.com>
    scsi: ufs: ufs-mediatek: Fix power down spec violation

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
    Revert "net: caif: replace BUG_ON with recovery code"

Anirudh Rayabharam <mail@anirudhrb.com>
    net/smc: properly handle workqueue allocation failure

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

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Revert "crypto: cavium/nitrox - add an error message to explain the failure of pci_request_mem_regions"

Zou Wei <zou_wei@huawei.com>
    gpio: cadence: Add missing MODULE_DEVICE_TABLE

Kai-Heng Feng <kai.heng.feng@canonical.com>
    platform/x86: hp_accel: Avoid invoking _INI to speed up resume

Paolo Abeni <pabeni@redhat.com>
    mptcp: drop unconditional pr_warn on bad opt

Paolo Abeni <pabeni@redhat.com>
    mptcp: fix data stream corruption

Paolo Abeni <pabeni@redhat.com>
    mptcp: avoid error message on infinite mapping

Hou Pu <houpu.main@gmail.com>
    nvmet-tcp: fix inline data size comparison in nvmet_tcp_queue_response

Felix Fietkau <nbd@nbd.name>
    perf jevents: Fix getting maximum number of fds

Ian Rogers <irogers@google.com>
    perf debug: Move debug initialization earlier

David Howells <dhowells@redhat.com>
    afs: Fix the nlink handling of dir-over-dir rename

Geert Uytterhoeven <geert+renesas@glider.be>
    i2c: sh_mobile: Use new clock calculation formulas for RZ/G2E

Jean Delvare <jdelvare@suse.de>
    i2c: i801: Don't generate an interrupt on bus reset

Qii Wang <qii.wang@mediatek.com>
    i2c: mediatek: Disable i2c start_en and clear intr_stat brfore reset

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    i2c: s3c2410: fix possible NULL pointer deref on read message after write

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: fix VL lookup command packing for P/Q/R/S

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: call dsa_unregister_switch when allocating memory fails

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: add error handling in sja1105_setup()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: error out on unsupported PHY mode

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: use 4095 as the private VLAN for untagged traffic

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: sja1105: update existing VLANs from the bridge VLAN list

Dan Carpenter <dan.carpenter@oracle.com>
    net: dsa: fix a crash if ->get_sset_count() fails

Florian Fainelli <f.fainelli@gmail.com>
    net: dsa: bcm_sf2: Fix bcm_sf2_reg_rgmii_cntrl() call for non-RGMII port

DENG Qingfang <dqfext@gmail.com>
    net: dsa: mt7530: fix VLAN traffic leaks

Roi Dayan <roid@nvidia.com>
    netfilter: flowtable: Remove redundant hw refresh bit

Xin Long <lucien.xin@gmail.com>
    sctp: add the missing setting for asoc encap_port

Xin Long <lucien.xin@gmail.com>
    sctp: fix the proc_handler for sysctl encap_port

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    spi: spi-fsl-dspi: Fix a resource leak in an error handling path

Xin Long <lucien.xin@gmail.com>
    tipc: skb_linearize the head skb when reassembling msgs

Xin Long <lucien.xin@gmail.com>
    tipc: wait and exit until all work queues are done

Hoang Le <hoang.h.le@dektech.com.au>
    Revert "net:tipc: Fix a double free in tipc_sk_mcast_rcv"

NeilBrown <neilb@suse.de>
    SUNRPC in case of backlog, hand free slots directly to waiting task

David Matlack <dmatlack@google.com>
    KVM: selftests: Fix 32-bit truncation of vm_get_max_gfn()

Joe Richey <joerichey@google.com>
    KVM: X86: Use _BITUL() macro in UAPI headers

Wanpeng Li <wanpengli@tencent.com>
    KVM: X86: Fix warning caused by stale emulation context

Ariel Levkovich <lariel@nvidia.com>
    net/mlx5: Set term table as an unmanaged flow table

Maor Gottlieb <maorg@nvidia.com>
    {net, RDMA}/mlx5: Fix override of log_max_qp by other device

Vladyslav Tarasiuk <vladyslavt@nvidia.com>
    net/mlx4: Fix EEPROM dump support

Roi Dayan <roid@nvidia.com>
    net/mlx5e: Fix null deref accessing lag dev

Jianbo Liu <jianbol@nvidia.com>
    net/mlx5: Set reformat action when needed for termination rules

Dima Chumak <dchumak@nvidia.com>
    net/mlx5e: Fix nullptr in add_vlan_push_action()

Dima Chumak <dchumak@nvidia.com>
    net/mlx5e: Fix nullptr in mlx5e_tc_add_fdb_flow()

Eli Cohen <elic@nvidia.com>
    {net,vdpa}/mlx5: Configure interface MAC into mpfs L2 table

Aya Levin <ayal@nvidia.com>
    net/mlx5e: Fix error path of updating netdev queues

Dima Chumak <dchumak@nvidia.com>
    net/mlx5e: Fix multipath lag activation

Saeed Mahameed <saeedm@nvidia.com>
    net/mlx5e: reset XPS on error flow if netdev isn't registered yet

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

Pavel Skripkin <paskripkin@gmail.com>
    net: usb: fix memory leak in smsc75xx_bind

Kyle Tso <kyletso@google.com>
    usb: typec: tcpm: Respond Not_Supported if no snk_vdo

Kyle Tso <kyletso@google.com>
    usb: typec: tcpm: Properly interrupt VDM AMS

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: typec: tcpm: Use LE to CPU conversion when accessing msg->header

Bjorn Andersson <bjorn.andersson@linaro.org>
    usb: typec: ucsi: Clear pending after acking connector change

Bjorn Andersson <bjorn.andersson@linaro.org>
    usb: typec: mux: Fix matching with typec_altmode_desc

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

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    drivers: base: Fix device link removal

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Fix 5.12 regression of missing xHC cache clearing command after a Stall

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: fix giving back URB with incorrect status regression in 5.12

Alan Stern <stern@rowland.harvard.edu>
    USB: usbfs: Don't WARN about excessively large memory allocations

Zhu Lingshan <lingshan.zhu@intel.com>
    Revert "irqbypass: do not start cons/prod when failed connect"

Johan Hovold <johan@kernel.org>
    USB: trancevibrator: fix control-request direction

Christian Gmeiner <christian.gmeiner@gmail.com>
    serial: 8250_pci: handle FL_NOIRQ board flag

Randy Wright <rwright@hpe.com>
    serial: 8250_pci: Add support for new HPE serial device

Maximilian Luz <luzmaximilian@gmail.com>
    serial: 8250_dw: Add device HID for new AMD UART controller

Andrew Jeffery <andrew@aj.id.au>
    serial: 8250: Add UART_BUG_TXRACE workaround for Aspeed VUART

Alexandru Ardelean <aardelean@deviqon.com>
    iio: adc: ad7192: handle regulator voltage error first

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7192: Avoid disabling a clock that was never enabled.

YueHaibing <yuehaibing@huawei.com>
    iio: adc: ad7793: Add missing error code in ad7793_setup()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7923: Fix undersized rx buffer.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7124: Fix potential overflow due to non sequential channel numbers

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7124: Fix missbalanced regulator enable / disable on error.

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: adc: ad7768-1: Fix too small buffer passed to iio_push_to_buffers_with_timestamp()

Andy Shevchenko <andy.shevchenko@gmail.com>
    iio: dac: ad5770r: Put fwnode in error case during ->probe()

Rui Miguel Silva <rui.silva@linaro.org>
    iio: gyro: fxas21002c: balance runtime power in error path

Lucas Stankus <lucas.p.stankus@gmail.com>
    staging: iio: cdc: ad7746: avoid overwrite of num_channels

Alexander Usyskin <alexander.usyskin@intel.com>
    mei: request autosuspend after sending rx flow control

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Prevent mixed-width VM creation

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fix debug register indexing

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Move __adjust_pc out of line

Wanpeng Li <wanpengli@tencent.com>
    KVM: X86: Fix vCPU preempted state from guest's point of view

Mathias Nyman <mathias.nyman@linux.intel.com>
    thunderbolt: dma_port: Fix NVM read buffer bounds and offset issue

Mathias Nyman <mathias.nyman@linux.intel.com>
    thunderbolt: usb4: Fix NVM read buffer bounds and offset issue

Dongliang Mu <mudongliangabcd@gmail.com>
    misc/uss720: fix memory leak in uss720_probe

Ondrej Mosnacek <omosnace@redhat.com>
    serial: core: fix suspicious security_locked_down() call

Ondrej Mosnacek <omosnace@redhat.com>
    debugfs: fix security_locked_down() call for SELinux

Sargun Dhillon <sargun@sargun.me>
    seccomp: Refactor notification handler to prepare for new semantics

Chen Huang <chenhuang5@huawei.com>
    riscv: stacktrace: fix the riscv stacktrace when CONFIG_FRAME_POINTER enabled

Sargun Dhillon <sargun@sargun.me>
    Documentation: seccomp: Fix user notification documentation

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    kgdb: fix gcc-11 warnings harder

James Zhu <James.Zhu@amd.com>
    drm/amdgpu/jpeg2.0: add cancel_delayed_work_sync before power gate

James Zhu <James.Zhu@amd.com>
    drm/amdgpu/vcn2.5: add cancel_delayed_work_sync before power gate

James Zhu <James.Zhu@amd.com>
    drm/amdgpu/vcn2.0: add cancel_delayed_work_sync before power gate

Kevin Wang <kevin1.wang@amd.com>
    drm/amdkfd: correct sienna_cichlid SDMA RLC register offset error

James Zhu <James.Zhu@amd.com>
    drm/amdgpu/vcn1: add cancel_delayed_work_sync before power gate

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: correct MGpuFanBoost setting

Imre Deak <imre.deak@intel.com>
    drm/i915: Reenable LTTPR non-transparent LT mode for DPCD_REV<1.4

Christoph Hellwig <hch@lst.de>
    md/raid5: remove an incorrect assert in in_chunk_boundary

Mikulas Patocka <mpatocka@redhat.com>
    dm snapshot: properly fix a crash when an origin has no snapshots

Sriram R <srirrama@codeaurora.org>
    ath11k: Clear the fragment cache during key install

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

Stefano Brivio <sbrivio@redhat.com>
    netfilter: nft_set_pipapo_avx2: Add irq_fpu_usable() check, fallback to non-AVX2 version

Davide Caratti <dcaratti@redhat.com>
    net/sched: fq_pie: fix OOB access in the traffic path

Davide Caratti <dcaratti@redhat.com>
    net/sched: fq_pie: re-factor fix for fq_pie endless loop

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

Stefan Haberland <sth@linux.ibm.com>
    s390/dasd: add missing discipline function

Rolf Eike Beer <eb@emlix.com>
    iommu/vt-d: Fix sysfs leak in alloc_iommu()

Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
    scsi: target: core: Avoid smp_processor_id() in preemptible code

Anna Schumaker <Anna.Schumaker@Netapp.com>
    NFSv4: Fix a NULL pointer dereference in pnfs_mark_matching_lsegs_return()

Norbert Slusarek <nslusarek@gmx.net>
    can: isotp: prevent race between isotp_bind() and isotp_setsockopt()

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: fsmc: Fix external use of SW Hamming ECC helper

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: tmio: Fix external use of SW Hamming ECC helper

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: ndfc: Fix external use of SW Hamming ECC helper

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: lpc32xx_slc: Fix external use of SW Hamming ECC helper

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: sharpsl: Fix external use of SW Hamming ECC helper

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: txx9ndfmc: Fix external use of SW Hamming ECC helper

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: rawnand: cs553x: Fix external use of SW Hamming ECC helper

Aurelien Aptel <aaptel@suse.com>
    cifs: set server->cipher_type to AES-128-CCM for SMB3.0

Shyam Prasad N <sprasad@microsoft.com>
    cifs: fix string declarations and assignments in tracepoints

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: scarlett2: Improve driver startup messages

Geoffrey D. Bennett <g@b4.vu>
    ALSA: usb-audio: scarlett2: Fix device hang with ehci-pci

Johan Hovold <johan@kernel.org>
    ALSA: usb-audio: fix control-request direction

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs and speaker for HP Zbook Fury 17 G8

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs and speaker for HP Zbook Fury 15 G8

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs and speaker for HP Zbook G8

Jeremy Szu <jeremy.szu@canonical.com>
    ALSA: hda/realtek: fix mute/micmute LEDs for HP 855 G8

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ALSA: hda/realtek: Chain in pop reduction fixup for ThinkStation P340

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek: Headphone volume is controlled by Front mixer

Hui Wang <hui.wang@canonical.com>
    ALSA: hda/realtek: the bass speaker can't output sound on Yoga 9i


-------------

Diffstat:

 Documentation/userspace-api/seccomp_filter.rst     |  16 +-
 Makefile                                           |   4 +-
 arch/arm64/include/asm/kvm_asm.h                   |   2 +
 arch/arm64/include/asm/kvm_emulate.h               |   5 +
 arch/arm64/kvm/hyp/exception.c                     |  18 +-
 arch/arm64/kvm/hyp/include/hyp/adjust_pc.h         |  18 --
 arch/arm64/kvm/hyp/nvhe/switch.c                   |   3 +-
 arch/arm64/kvm/hyp/vhe/switch.c                    |   3 +-
 arch/arm64/kvm/reset.c                             |  28 ++-
 arch/arm64/kvm/sys_regs.c                          |  42 ++---
 arch/arm64/mm/mmu.c                                |   3 +-
 arch/mips/alchemy/board-xxs1500.c                  |   1 +
 arch/mips/ralink/of.c                              |   2 +
 arch/openrisc/include/asm/barrier.h                |   9 +
 arch/riscv/kernel/stacktrace.c                     |  14 +-
 arch/x86/kvm/hyperv.c                              |   8 +
 arch/x86/kvm/x86.c                                 |  12 +-
 drivers/acpi/acpi_apd.c                            |   1 +
 drivers/base/core.c                                |  37 ++--
 drivers/char/hpet.c                                |   2 +
 drivers/crypto/cavium/nitrox/nitrox_main.c         |   1 -
 drivers/dma/qcom/hidma_mgmt.c                      |  17 +-
 drivers/gpio/gpio-cadence.c                        |   1 +
 .../gpu/drm/amd/amdgpu/amdgpu_amdkfd_gfx_v10_3.c   |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   1 -
 drivers/gpu/drm/amd/amdgpu/amdgpu_fb.c             |   3 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_ttm.c            |   1 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_0.c             |   2 +
 drivers/gpu/drm/amd/amdgpu/jpeg_v2_5.c             |   2 -
 drivers/gpu/drm/amd/amdgpu/jpeg_v3_0.c             |   2 -
 drivers/gpu/drm/amd/amdgpu/sdma_v5_2.c             |   5 -
 drivers/gpu/drm/amd/amdgpu/vcn_v1_0.c              |   6 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v2_0.c              |   2 +
 drivers/gpu/drm/amd/amdgpu/vcn_v2_5.c              |   2 +
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |   8 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |  18 ++
 drivers/gpu/drm/amd/pm/swsmu/smu11/navi10_ppt.c    |   9 +
 .../drm/amd/pm/swsmu/smu11/sienna_cichlid_ppt.c    |  10 +
 .../gpu/drm/i915/display/intel_dp_link_training.c  |  71 ++++----
 drivers/gpu/drm/meson/meson_drv.c                  |   9 +-
 drivers/i2c/busses/i2c-i801.c                      |   6 +-
 drivers/i2c/busses/i2c-mt65xx.c                    |   5 +
 drivers/i2c/busses/i2c-s3c2410.c                   |   3 +
 drivers/i2c/busses/i2c-sh_mobile.c                 |   2 +-
 drivers/iio/adc/ad7124.c                           |  36 ++--
 drivers/iio/adc/ad7192.c                           |  19 +-
 drivers/iio/adc/ad7768-1.c                         |   8 +-
 drivers/iio/adc/ad7793.c                           |   1 +
 drivers/iio/adc/ad7923.c                           |   4 +-
 drivers/iio/dac/ad5770r.c                          |  16 +-
 drivers/iio/gyro/fxas21002c_core.c                 |   2 +
 drivers/infiniband/hw/mlx5/mr.c                    |   4 +-
 drivers/interconnect/qcom/bcm-voter.c              |   4 +-
 drivers/iommu/amd/iommu.c                          |   2 +
 drivers/iommu/intel/dmar.c                         |   4 +-
 drivers/iommu/intel/iommu.c                        |   9 +-
 drivers/iommu/intel/pasid.c                        |   3 +-
 drivers/iommu/virtio-iommu.c                       |   1 +
 drivers/isdn/hardware/mISDN/hfcsusb.c              |  17 +-
 drivers/isdn/hardware/mISDN/mISDNinfineon.c        |  21 ++-
 drivers/md/dm-snap.c                               |   2 +-
 drivers/md/raid5.c                                 |   2 -
 drivers/media/dvb-frontends/sp8870.c               |   2 +-
 drivers/media/usb/gspca/cpia1.c                    |   6 +-
 drivers/media/usb/gspca/m5602/m5602_mt9m111.c      |  16 +-
 drivers/media/usb/gspca/m5602/m5602_po1030.c       |  14 +-
 drivers/misc/kgdbts.c                              |   3 +-
 drivers/misc/lis3lv02d/lis3lv02d.h                 |   1 +
 drivers/misc/mei/interrupt.c                       |   3 +
 drivers/mtd/nand/raw/cs553x_nand.c                 |  12 +-
 drivers/mtd/nand/raw/fsmc_nand.c                   |  12 +-
 drivers/mtd/nand/raw/lpc32xx_slc.c                 |  15 +-
 drivers/mtd/nand/raw/ndfc.c                        |  12 +-
 drivers/mtd/nand/raw/sharpsl.c                     |  12 +-
 drivers/mtd/nand/raw/tmio_nand.c                   |   8 +-
 drivers/mtd/nand/raw/txx9ndfmc.c                   |   5 +-
 drivers/net/caif/caif_serial.c                     |   3 -
 drivers/net/dsa/bcm_sf2.c                          |   5 +-
 drivers/net/dsa/mt7530.c                           |   8 -
 drivers/net/dsa/sja1105/sja1105_dynamic_config.c   |  23 ++-
 drivers/net/dsa/sja1105/sja1105_main.c             |  74 +++++---
 drivers/net/ethernet/broadcom/bnx2.c               |   2 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  12 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |  10 +
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |  27 ++-
 drivers/net/ethernet/cavium/liquidio/lio_vf_main.c |  27 ++-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_main.c    |   2 +-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.c      |  80 +++++++-
 .../chelsio/inline_crypto/ch_ktls/chcr_ktls.h      |   2 +
 .../chelsio/inline_crypto/chtls/chtls_io.c         |   6 +-
 drivers/net/ethernet/freescale/fec_main.c          |  11 +-
 drivers/net/ethernet/fujitsu/fmvj18x_cs.c          |   4 +-
 drivers/net/ethernet/google/gve/gve_main.c         |  21 ++-
 drivers/net/ethernet/google/gve/gve_tx.c           |  10 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 110 ++++++-----
 drivers/net/ethernet/hisilicon/hns3/hns3_ethtool.c |  64 +++----
 .../net/ethernet/hisilicon/hns3/hns3pf/hclge_mbx.c |   4 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |  16 +-
 drivers/net/ethernet/lantiq_xrx200.c               |  14 +-
 drivers/net/ethernet/marvell/mvpp2/mvpp2.h         |  22 +++
 drivers/net/ethernet/marvell/mvpp2/mvpp2_main.c    |  54 +++++-
 .../ethernet/marvell/octeontx2/nic/otx2_ethtool.c  |   4 +
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  67 ++++---
 drivers/net/ethernet/mediatek/mtk_eth_soc.h        |  24 ++-
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   4 +-
 drivers/net/ethernet/mellanox/mlx4/port.c          | 107 ++++++++++-
 .../net/ethernet/mellanox/mlx5/core/en/rep/bond.c  |   2 +
 .../net/ethernet/mellanox/mlx5/core/en/rep/tc.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/en/tc_tun_encap.c  |   2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_fs.c    |   1 +
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   9 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c    |  28 ++-
 drivers/net/ethernet/mellanox/mlx5/core/eswitch.c  |   1 +
 .../mellanox/mlx5/core/eswitch_offloads_termtbl.c  |  38 ++--
 drivers/net/ethernet/mellanox/mlx5/core/lag_mp.c   |   6 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.c |   3 +
 drivers/net/ethernet/mellanox/mlx5/core/lib/mpfs.h |   5 +-
 drivers/net/ethernet/mellanox/mlx5/core/main.c     |  11 +-
 .../net/ethernet/mellanox/mlx5/core/sf/devlink.c   |  18 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   9 +-
 drivers/net/ethernet/ti/netcp_core.c               |   4 +-
 drivers/net/ipa/ipa.h                              |   2 +
 drivers/net/ipa/ipa_mem.c                          |   3 +-
 drivers/net/mdio/mdio-octeon.c                     |   2 -
 drivers/net/mdio/mdio-thunder.c                    |   1 -
 drivers/net/usb/hso.c                              |  45 +++--
 drivers/net/usb/smsc75xx.c                         |   8 +-
 drivers/net/wireless/ath/ath10k/htt.h              |   1 +
 drivers/net/wireless/ath/ath10k/htt_rx.c           | 201 ++++++++++++++++++++-
 drivers/net/wireless/ath/ath10k/rx_desc.h          |  14 +-
 drivers/net/wireless/ath/ath11k/dp_rx.c            |  18 ++
 drivers/net/wireless/ath/ath11k/dp_rx.h            |   1 +
 drivers/net/wireless/ath/ath11k/mac.c              |   6 +
 drivers/net/wireless/ath/ath6kl/debug.c            |   5 +-
 .../wireless/broadcom/brcm80211/brcmfmac/bcmsdh.c  |   8 +-
 .../net/wireless/broadcom/brcm80211/brcmfmac/bus.h |  19 +-
 .../wireless/broadcom/brcm80211/brcmfmac/core.c    |  42 ++---
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |   9 +-
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.h    |   5 -
 .../net/wireless/broadcom/brcm80211/brcmfmac/usb.c |   8 +-
 drivers/net/wireless/marvell/libertas/mesh.c       |  33 +---
 drivers/nvme/target/tcp.c                          |   2 +-
 drivers/platform/x86/hp-wireless.c                 |   2 +
 drivers/platform/x86/hp_accel.c                    |  22 ++-
 drivers/platform/x86/intel_punit_ipc.c             |   1 +
 drivers/platform/x86/touchscreen_dmi.c             |  43 +++++
 drivers/ptp/ptp_ocp.c                              |   4 +-
 drivers/s390/block/dasd_diag.c                     |   8 +-
 drivers/s390/block/dasd_fba.c                      |   8 +-
 drivers/s390/block/dasd_int.h                      |   1 -
 drivers/s390/cio/vfio_ccw_cp.c                     |   4 +
 drivers/scsi/BusLogic.c                            |   6 +-
 drivers/scsi/BusLogic.h                            |   2 +-
 drivers/scsi/aic7xxx/scsi_message.h                |  11 ++
 drivers/scsi/libsas/sas_port.c                     |   4 +-
 drivers/scsi/pm8001/pm8001_hwi.c                   |  10 +-
 drivers/scsi/pm8001/pm8001_init.c                  |   2 +-
 drivers/scsi/pm8001/pm8001_sas.c                   |   7 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  12 +-
 drivers/scsi/ufs/ufs-mediatek.c                    |   4 +
 drivers/spi/spi-fsl-dspi.c                         |   4 +-
 drivers/spi/spi.c                                  |  32 +++-
 drivers/staging/emxx_udc/emxx_udc.c                |   4 +-
 drivers/staging/iio/cdc/ad7746.c                   |   1 -
 drivers/target/target_core_transport.c             |   2 +-
 .../intel/int340x_thermal/int340x_thermal_zone.c   |   4 +
 drivers/thermal/intel/x86_pkg_temp_thermal.c       |   2 +-
 drivers/thermal/qcom/qcom-spmi-adc-tm5.c           |   2 +-
 drivers/thunderbolt/dma_port.c                     |  11 +-
 drivers/thunderbolt/usb4.c                         |   9 +-
 drivers/tty/serial/8250/8250.h                     |   1 +
 drivers/tty/serial/8250/8250_aspeed_vuart.c        |   1 +
 drivers/tty/serial/8250/8250_dw.c                  |   1 +
 drivers/tty/serial/8250/8250_pci.c                 |  47 +++--
 drivers/tty/serial/8250/8250_port.c                |  12 ++
 drivers/tty/serial/max310x.c                       |   2 +
 drivers/tty/serial/rp2.c                           |  52 ++----
 drivers/tty/serial/serial-tegra.c                  |   2 +-
 drivers/tty/serial/serial_core.c                   |   8 +-
 drivers/tty/serial/sh-sci.c                        |   4 +-
 drivers/usb/cdns3/cdnsp-gadget.c                   |  14 +-
 drivers/usb/core/devio.c                           |  11 +-
 drivers/usb/core/hub.h                             |   6 +-
 drivers/usb/dwc3/gadget.c                          |  13 +-
 drivers/usb/gadget/udc/renesas_usb3.c              |   5 +-
 drivers/usb/host/xhci-ring.c                       |  14 +-
 drivers/usb/misc/trancevibrator.c                  |   4 +-
 drivers/usb/misc/uss720.c                          |   1 +
 drivers/usb/serial/ftdi_sio.c                      |   3 +
 drivers/usb/serial/ftdi_sio_ids.h                  |   7 +
 drivers/usb/serial/option.c                        |   4 +
 drivers/usb/serial/pl2303.c                        |   1 +
 drivers/usb/serial/pl2303.h                        |   1 +
 drivers/usb/serial/ti_usb_3410_5052.c              |   3 +
 drivers/usb/typec/mux.c                            |   7 +-
 drivers/usb/typec/tcpm/tcpm.c                      |  39 +++-
 drivers/usb/typec/ucsi/ucsi.c                      |   2 +-
 drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  19 +-
 fs/afs/dir.c                                       |   4 +-
 fs/block_dev.c                                     |   3 +
 fs/btrfs/extent_io.c                               |   7 +-
 fs/btrfs/reflink.c                                 |   5 +
 fs/btrfs/tree-log.c                                |   2 -
 fs/cifs/smb2pdu.c                                  |  13 +-
 fs/cifs/trace.h                                    |  29 +--
 fs/debugfs/inode.c                                 |   9 +-
 fs/nfs/filelayout/filelayout.c                     |   2 +-
 fs/nfs/nfs4file.c                                  |   2 +-
 fs/nfs/nfs4proc.c                                  |   4 +-
 fs/nfs/pagelist.c                                  |  21 +--
 fs/nfs/pnfs.c                                      |  15 +-
 fs/proc/base.c                                     |   4 +
 include/linux/bits.h                               |   2 +-
 include/linux/const.h                              |   8 +
 include/linux/device.h                             |   6 +-
 include/linux/minmax.h                             |  10 +-
 include/linux/mlx5/driver.h                        |  44 ++---
 include/linux/mlx5/mpfs.h                          |  18 ++
 include/linux/sunrpc/xprt.h                        |   2 +
 include/net/cfg80211.h                             |   4 +-
 include/net/netfilter/nf_flow_table.h              |   1 -
 include/net/pkt_cls.h                              |  11 ++
 include/net/pkt_sched.h                            |   7 +-
 include/net/sch_generic.h                          |  35 +++-
 include/net/sock.h                                 |   4 +-
 include/uapi/linux/kvm.h                           |   5 +-
 kernel/bpf/verifier.c                              |  12 +-
 kernel/seccomp.c                                   |  30 +--
 net/bluetooth/cmtp/core.c                          |   5 +
 net/can/isotp.c                                    |  49 +++--
 net/core/dev.c                                     |  29 ++-
 net/core/filter.c                                  |   1 +
 net/core/neighbour.c                               |   4 +
 net/core/sock.c                                    |   8 +-
 net/dsa/master.c                                   |   5 +-
 net/dsa/slave.c                                    |  12 +-
 net/hsr/hsr_device.c                               |   2 +
 net/hsr/hsr_forward.c                              |  30 ++-
 net/hsr/hsr_forward.h                              |   8 +-
 net/hsr/hsr_main.h                                 |   4 +-
 net/hsr/hsr_slave.c                                |  11 +-
 net/ipv6/mcast.c                                   |   3 -
 net/ipv6/reassembly.c                              |   4 +-
 net/mac80211/ieee80211_i.h                         |  36 ++--
 net/mac80211/iface.c                               |  11 +-
 net/mac80211/key.c                                 |   7 +
 net/mac80211/key.h                                 |   2 +
 net/mac80211/rx.c                                  | 150 +++++++++++----
 net/mac80211/sta_info.c                            |   6 +-
 net/mac80211/sta_info.h                            |  33 +++-
 net/mac80211/wpa.c                                 |  13 +-
 net/mptcp/options.c                                |   1 -
 net/mptcp/protocol.c                               |   6 +
 net/mptcp/subflow.c                                |   1 -
 net/netfilter/nf_flow_table_core.c                 |   3 +-
 net/netfilter/nf_flow_table_offload.c              |   7 +-
 net/netfilter/nft_set_pipapo.c                     |   4 +-
 net/netfilter/nft_set_pipapo.h                     |   2 +
 net/netfilter/nft_set_pipapo_avx2.c                |   3 +
 net/openvswitch/meter.c                            |   8 +
 net/packet/af_packet.c                             |  10 +-
 net/sched/cls_api.c                                |   2 +-
 net/sched/sch_dsmark.c                             |   3 +-
 net/sched/sch_fq_pie.c                             |  19 +-
 net/sched/sch_generic.c                            |  50 ++++-
 net/sctp/socket.c                                  |   1 +
 net/sctp/sysctl.c                                  |   2 +-
 net/smc/smc_ism.c                                  |  26 ++-
 net/sunrpc/clnt.c                                  |   7 -
 net/sunrpc/xprt.c                                  |  40 +++-
 net/sunrpc/xprtrdma/rpc_rdma.c                     |  27 ++-
 net/sunrpc/xprtrdma/transport.c                    |  12 +-
 net/sunrpc/xprtrdma/verbs.c                        |  18 +-
 net/sunrpc/xprtrdma/xprt_rdma.h                    |   1 +
 net/tipc/core.c                                    |   2 +
 net/tipc/core.h                                    |   2 +
 net/tipc/msg.c                                     |   9 +-
 net/tipc/socket.c                                  |   5 +-
 net/tipc/udp_media.c                               |   2 +
 net/tls/tls_sw.c                                   |  11 +-
 net/wireless/util.c                                |   7 +-
 samples/bpf/xdpsock_user.c                         |   2 +-
 sound/firewire/dice/dice-pcm.c                     |   4 +-
 sound/firewire/dice/dice-stream.c                  |   2 +-
 sound/firewire/dice/dice.c                         |  24 +++
 sound/firewire/dice/dice.h                         |   3 +-
 sound/isa/gus/gus_main.c                           |  13 +-
 sound/isa/sb/sb16_main.c                           |  10 +-
 sound/isa/sb/sb8.c                                 |   6 +-
 sound/pci/hda/patch_realtek.c                      |  46 ++++-
 sound/soc/codecs/cs35l33.c                         |   1 +
 sound/soc/codecs/cs42l42.c                         |   3 +
 sound/soc/codecs/cs43130.c                         |  28 ++-
 sound/soc/qcom/lpass-cpu.c                         |  12 +-
 sound/usb/format.c                                 |   2 +-
 sound/usb/mixer_quirks.c                           |   2 +-
 sound/usb/mixer_scarlett_gen2.c                    |  81 ++++++---
 sound/usb/mixer_scarlett_gen2.h                    |   2 +-
 tools/bpf/bpftool/Documentation/bpftool-cgroup.rst |   4 +-
 tools/bpf/bpftool/Documentation/bpftool-prog.rst   |   2 +-
 tools/bpf/bpftool/bash-completion/bpftool          |   6 +-
 tools/bpf/bpftool/cgroup.c                         |   3 +-
 tools/bpf/bpftool/prog.c                           |   2 +-
 tools/include/linux/bits.h                         |   2 +-
 tools/include/linux/const.h                        |   8 +
 tools/include/uapi/linux/kvm.h                     |   5 +-
 tools/perf/perf.c                                  |   4 +-
 tools/perf/pmu-events/jevents.c                    |   2 +-
 tools/perf/scripts/python/exported-sql-viewer.py   |  12 +-
 .../perf/util/intel-pt-decoder/intel-pt-decoder.c  |   6 +-
 tools/perf/util/intel-pt.c                         |   5 +-
 tools/testing/selftests/kvm/include/kvm_util.h     |   2 +-
 tools/testing/selftests/kvm/lib/kvm_util.c         |   2 +-
 tools/testing/selftests/kvm/lib/perf_test_util.c   |   4 +-
 .../kvm/memslot_modification_stress_test.c         |  18 +-
 .../tc-testing/tc-tests/qdiscs/fq_pie.json         |   8 +-
 virt/lib/irqbypass.c                               |  16 +-
 318 files changed, 2744 insertions(+), 1250 deletions(-)


