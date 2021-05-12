Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E56637CB76
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:57:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242725AbhELQfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:35:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:40578 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241282AbhELQ07 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:26:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C44A161DE4;
        Wed, 12 May 2021 15:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620834676;
        bh=wEWXxPD/eaguH+YPcPU1VXnedEtUccZeeR1WAwOcKdc=;
        h=From:To:Cc:Subject:Date:From;
        b=k8rMYzYg6b232w0PLMvb4PMjdGRUWlN8I3OznhZ5+uetDHVpqs+sE8O5fnbI6karE
         DX3SCev5WlWOug2G/SauMC0aOF7WHTapnTUKUPK2TtrsNOSM9EzIMs2s3muYce75bQ
         veSvYCHWiKPs8lLz/4gOIz01xgMJdjKj/eL7WqpQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: [PATCH 5.12 000/677] 5.12.4-rc1 review
Date:   Wed, 12 May 2021 16:40:46 +0200
Message-Id: <20210512144837.204217980@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.4-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.12.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.12.4-rc1
X-KernelTest-Deadline: 2021-05-14T14:48+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.12.4 release.
There are 677 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 14 May 2021 14:47:09 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.4-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.12.4-rc1

Xin Long <lucien.xin@gmail.com>
    sctp: delay auto_asconf init until binding the first addr

Xin Long <lucien.xin@gmail.com>
    Revert "net/sctp: fix race condition in sctp_destroy_sock"

Arnd Bergmann <arnd@arndb.de>
    smp: Fix smp_call_function_single_async prototype

Jonathon Reinhart <jonathon.reinhart@gmail.com>
    net: Only allow init netns to set default tcp cong to a restricted algo

Andrii Nakryiko <andrii@kernel.org>
    bpf: Prevent writable memory-mapping of read-only ringbuf pages

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    bpf, ringbuf: Deny reserve of buffers larger than ringbuf

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix alu32 const subreg bound tracking on bitwise operations

David Howells <dhowells@redhat.com>
    afs: Fix speculative status fetches

Jane Chu <jane.chu@oracle.com>
    mm/memory-failure: unnecessary amount of unmapping

Wang Wensheng <wangwensheng4@huawei.com>
    mm/sparse: add the missing sparse_buffer_fini() in error branch

Muchun Song <songmuchun@bytedance.com>
    mm: memcontrol: slab: fix obtain a reference to a freeing memcg

Vlastimil Babka <vbabka@suse.cz>
    mm, slub: enable slub_debug static key when creating cache with explicit debug flags

Dan Carpenter <dan.carpenter@oracle.com>
    kfifo: fix ternary sign extension bugs

Sergei Trofimovich <slyfox@gentoo.org>
    ia64: fix EFI_DEBUG build

Valentin Schneider <valentin.schneider@arm.com>
    ia64: ensure proper NUMA distance and possible map initialization

Leo Yan <leo.yan@linaro.org>
    perf session: Add swap operation for event TIME_CONV

Leo Yan <leo.yan@linaro.org>
    perf jit: Let convert_timestamp() to be backwards-compatible

Leo Yan <leo.yan@linaro.org>
    perf tools: Change fields type in perf_record_time_conv

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    net:nfc:digital: Fix a double free in digital_tg_recv_dep_req

Tobias Waldekranz <tobias@waldekranz.com>
    net: dsa: mv88e6xxx: Fix 6095/6097/6185 ports in non-SERDES CMODE

Linus Lüssing <linus.luessing@c0d3.blue>
    net: bridge: mcast: fix broken length + header check for MRDv6 Adv.

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    RDMA/bnxt_re: Fix a double free in bnxt_qplib_alloc_res

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    RDMA/siw: Fix a use after free in siw_alloc_mr

Daniel Borkmann <daniel@iogearbox.net>
    bpf: Fix propagation of 32 bit unsigned bounds from 64 bit bounds

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Fix core_reloc test runner

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Fix field existence CO-RE reloc tests

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Fix BPF_CORE_READ_BITFIELD() macro

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    net:emac/emac-mac: Fix a use after free in emac_mac_tx_buf_send

Davide Caratti <dcaratti@redhat.com>
    net/sched: act_ct: fix wild memory access when clearing fragments

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Disable SEV/SEV-ES if NPT is disabled

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Free sev_asid_bitmap during init if SEV setup fails

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Zero out the VMCB array used to track SEV ASID association

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Intercept FS/GS_BASE MSR accesses for 32-bit KVM

Michael Chan <michael.chan@broadcom.com>
    bnxt_en: Fix RX consumer index logic in the error path.

Mat Martineau <mathew.j.martineau@linux.intel.com>
    mptcp: Retransmit DATA_FIN

Danielle Ratson <danieller@nvidia.com>
    selftests: mlxsw: Remove a redundant if statement in tc_flower_scale test

Danielle Ratson <danieller@nvidia.com>
    selftests: mlxsw: Remove a redundant if statement in port_scale test

Petr Machata <petrm@nvidia.com>
    selftests: net: mirror_gre_vlan_bridge_1q: Make an FDB entry static

Phillip Potter <phil@philpotter.co.uk>
    net: geneve: modify IP header check in geneve6_xmit_skb and geneve_xmit_skb

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    arm64: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    ARM: dts: uniphier: Change phy-mode to RGMII-ID to enable delay pins for RTL8211E

Dan Carpenter <dan.carpenter@oracle.com>
    bnxt_en: fix ternary sign extension bug in bnxt_show_temp()

Martin Willi <martin@strongswan.org>
    net, xdp: Update pkt_type if generic XDP changes unicast MAC

Arnd Bergmann <arnd@arndb.de>
    net: enetc: fix link error again

Maxim Kochetkov <fido_max@inbox.ru>
    net: phy: marvell: fix m88e1111_set_downshift

Maxim Kochetkov <fido_max@inbox.ru>
    net: phy: marvell: fix m88e1011_set_downshift

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/52xx: Fix an invalid ASM expression ('addi' used instead of 'add')

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Fix the threshold event selection for memory events in power10

Colin Ian King <colin.king@canonical.com>
    wlcore: Fix buffer overrun by snprintf due to incorrect buffer size

Shuah Khan <skhan@linuxfoundation.org>
    ath10k: Fix ath10k_wmi_tlv_op_pull_peer_stats_info() unlock without lock

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    ath10k: Fix a use after free in ath10k_htc_send_bundle

Toke Høiland-Jørgensen <toke@redhat.com>
    ath9k: Fix error check in ath9k_hw_read_revisions() for PCI devices

Christophe Leroy <christophe.leroy@csgroup.eu>
    powerpc/64: Fix the definition of the fixmap area

Shay Drory <shayd@nvidia.com>
    RDMA/core: Add CM to restrack after successful attachment to a device

Bob Pearson <rpearsonhpe@gmail.com>
    RDMA/rxe: Fix a bug in rxe_fill_ip_info()

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: fix possible invalid register access

Colin Ian King <colin.king@canonical.com>
    mt76: mt7615: Fix a dereference of pointer sta before it is null checked

Martin Schiller <ms@dev.tdt.de>
    net: phy: intel-xway: enable integrated led functions

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    net: renesas: ravb: Fix a stuck issue when a lot of frames are received

Ong Boon Leong <boon.leong.ong@intel.com>
    net: stmmac: fix TSO and TBS feature enabling during driver open

Yinjun Zhang <yinjun.zhang@corigine.com>
    nfp: devlink: initialize the devlink port attribute "lanes"

Tobias Waldekranz <tobias@waldekranz.com>
    net: dsa: mv88e6xxx: Fix off-by-one in VTU devlink region size

Sean Christopherson <seanjc@google.com>
    crypto: ccp: Detect and reject "invalid" addresses destined for PSP

Leonardo Bras <leobras.c@gmail.com>
    powerpc/pseries/iommu: Fix window size for direct mapping with pmem

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: run mt7921_mcu_fw_log_2_host holding mt76 mutex

Ryder Lee <ryder.lee@mediatek.com>
    mt76: mt7915: fix memleak when mt7915_unregister_device()

Ryder Lee <ryder.lee@mediatek.com>
    mt76: mt7615: fix memleak when mt7615_unregister_device()

Po-Hao Huang <phhuang@realtek.com>
    rtw88: refine napi deinit flow

Colin Ian King <colin.king@canonical.com>
    net: davinci_emac: Fix incorrect masking of tx and rx error channel

Vadym Kochan <vkochan@marvell.com>
    net: marvell: prestera: fix port event handling on init

Stefano Garzarella <sgarzare@redhat.com>
    vsock/virtio: free queued packets when closing socket

Edward Cree <ecree.xilinx@gmail.com>
    sfc: ef10: fix TX queue lookup in TX event handling

Colin Ian King <colin.king@canonical.com>
    ALSA: usb: midi: don't return -ENOMEM when usb_urb_ep_type_check fails

Sindhu Devale <sindhu.devale@intel.com>
    RDMA/i40iw: Fix error unwinding when i40iw_hmc_sd_one fails

Potnuri Bharat Teja <bharat@chelsio.com>
    RDMA/cxgb4: add missing qpid increment

Alexander Lobakin <alobakin@pm.me>
    gro: fix napi_gro_frags() Fast GRO breakage due to IP alignment check

Linus Walleij <linus.walleij@linaro.org>
    net: ethernet: ixp4xx: Set the DMA masks explicitly

Florent Revest <revest@chromium.org>
    libbpf: Initialize the bpf_seq_printf parameters array field by field

Stefano Garzarella <sgarzare@redhat.com>
    vsock/vmci: log once the failed queue pair allocation

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nftables_offload: special ethertype handling for VLAN

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nftables_offload: VLAN id needs host byteorder in flow dissector

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nft_payload: fix C-VLAN offload support

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    mwl8k: Fix a double Free in mwl8k_probe_hw

Qii Wang <qii.wang@mediatek.com>
    i2c: mediatek: Fix wrong dma sync flag

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: sh7760: fix IRQ error path

Arnd Bergmann <arnd@arndb.de>
    wlcore: fix overlapping snprintf arguments in debugfs

Ping-Ke Shih <pkshih@realtek.com>
    rtlwifi: 8821ae: upgrade PHY and RF parameters

David Edmondson <david.edmondson@oracle.com>
    KVM: x86: dump_vmcs should not assume GUEST_IA32_EFER is valid

Srikar Dronamraju <srikar@linux.vnet.ibm.com>
    powerpc/smp: Reintroduce cpu_core_mask

Geliang Tang <geliangtang@gmail.com>
    mptcp: fix format specifiers for unsigned int

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    iommu/mediatek: Always enable the clk on resume

Tyrel Datwyler <tyreld@linux.ibm.com>
    powerpc/pseries: extract host bridge from pci_bus prior to bus removal

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
    MIPS: pci-legacy: stop using of_pci_range_to_resource

Dan Carpenter <dan.carpenter@oracle.com>
    drm/amd/pm: fix error code in smu_set_power_limit()

Dan Carpenter <dan.carpenter@oracle.com>
    drm/amdgpu: fix an error code in init_pmu_entry_by_type_and_add()

Vitaly Chikunov <vt@altlinux.org>
    perf beauty: Fix fsconfig generator

Paul Menzel <pmenzel@molgen.mpg.de>
    iommu/amd: Put newline after closing bracket in warning

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    iommu/vt-d: Fix an error handling path in 'intel_prepare_irq_remapping()'

Dan Carpenter <dan.carpenter@oracle.com>
    drm/i915/gvt: Fix error code in intel_gvt_init_device()

Eric Dumazet <edumazet@google.com>
    net/packet: remove data races in fanout operations

Colin Ian King <colin.king@canonical.com>
    net/mlx5: Fix bit-wise and with zero

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: ak5558: correct reset polarity

Nicholas Piggin <npiggin@gmail.com>
    powerpc/syscall: switch user_exit_irqoff and trace_hardirqs_off order

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Fix xmon command "dxi"

Cédric Le Goater <clg@kaod.org>
    powerpc/xive: Drop check on irq_data in xive_core_debug_show()

Mukesh Sisodiya <mukesh.sisodiya@intel.com>
    iwlwifi: dbg: disable ini debug in 9000 family and below

Mordechay Goodstein <mordechay.goodstein@intel.com>
    iwlwifi: rs-fw: don't support stbc for HE 160

Alessio Balsini <balsini@android.com>
    fuse: fix matching of FUSE_DEV_IOC_CLONE command

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: sh7760: add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: rcar: add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: mlxbf: add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: jz4780: add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: emev2: add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    i2c: cadence: add IRQ check

Qinglang Miao <miaoqinglang@huawei.com>
    i2c: xiic: fix reference leak when pm_runtime_get_sync fails

Qinglang Miao <miaoqinglang@huawei.com>
    i2c: stm32f7: fix reference leak when pm_runtime_get_sync fails

Qinglang Miao <miaoqinglang@huawei.com>
    i2c: sprd: fix reference leak when pm_runtime_get_sync fails

Qinglang Miao <miaoqinglang@huawei.com>
    i2c: omap: fix reference leak when pm_runtime_get_sync fails

Qinglang Miao <miaoqinglang@huawei.com>
    i2c: imx: fix reference leak when pm_runtime_get_sync fails

Qinglang Miao <miaoqinglang@huawei.com>
    i2c: imx-lpi2c: fix reference leak when pm_runtime_get_sync fails

Qinglang Miao <miaoqinglang@huawei.com>
    i2c: img-scb: fix reference leak when pm_runtime_get_sync fails

Qinglang Miao <miaoqinglang@huawei.com>
    i2c: cadence: fix reference leak when pm_runtime_get_sync fails

Tudor Ambarus <tudor.ambarus@microchip.com>
    pinctrl: at91-pio4: Fix slew rate disablement

Gioh Kim <gi-oh.kim@ionos.com>
    RDMA/rtrs-clt: destroy sysfs after removing session from active list

Wang Wensheng <wangwensheng4@huawei.com>
    RDMA/srpt: Fix error return code in srpt_cm_req_recv()

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: fix kernel crash when the firmware fails to download

Colin Ian King <colin.king@canonical.com>
    net: thunderx: Fix unintentional sign extension issue

Colin Ian King <colin.king@canonical.com>
    cxgb4: Fix unintentional sign extension issues

Wang Wensheng <wangwensheng4@huawei.com>
    RDMA/bnxt_re: Fix error return code in bnxt_qplib_cq_process_terminal()

Wang Wensheng <wangwensheng4@huawei.com>
    IB/hfi1: Fix error return code in parse_platform_config()

Wang Wensheng <wangwensheng4@huawei.com>
    RDMA/qedr: Fix error return code in qedr_iw_connect()

Amir Goldstein <amir73il@gmail.com>
    ovl: invalidate readdir cache on changes to dir with origin

Giuseppe Scrivano <gscrivan@redhat.com>
    ovl: show "userxattr" in the mount data

Nicholas Piggin <npiggin@gmail.com>
    KVM: PPC: Book3S HV P9: Restore host CTRL SPR after guest exit

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: fix the dwell time control

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: fix inappropriate WoW setup with the missing ARP informaiton

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: always wake the device in mt7921_remove_interface

Ryder Lee <ryder.lee@mediatek.com>
    mt76: mt7915: cleanup mcu tx queue in mt7915_dma_reset()

Ryder Lee <ryder.lee@mediatek.com>
    mt76: mt7615: cleanup mcu tx queue in mt7615_dma_reset()

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7663s: fix the possible device hang in high traffic

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7663s: make all of packets 4-bytes aligned in sdio tx aggregation

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7663: fix when beacon filter is being applied

Ryder Lee <ryder.lee@mediatek.com>
    mt76: mt7915: fix txrate reporting

Ryder Lee <ryder.lee@mediatek.com>
    mt76: mt7915: fix rxrate reporting

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: fix the base of the dynamic remap

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: fix the base of PCIe interrupt

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: check return value of mt76_txq_send_burst in mt76_txq_schedule_list

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: connac: fix kernel warning adding monitor interface

Ryder Lee <ryder.lee@mediatek.com>
    mt76: mt7915: fix mib stats counter reporting to mac80211

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: fix mib stats counter reporting to mac80211

Ryder Lee <ryder.lee@mediatek.com>
    mt76: mt7615: fix TSF configuration

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: fix stats register definitions

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7915: fix aggr len debugfs node

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7921: fix aggr length histogram

Lorenzo Bianconi <lorenzo@kernel.org>
    mt76: mt7615: fix memory leak in mt7615_coredump_work

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: fixup rx bitrate statistics

Sean Wang <sean.wang@mediatek.com>
    mt76: connac: fix up the setting for ht40 mode in mt76_connac_mcu_uni_add_bss

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: fix memory leak in mt7921_coredump_work

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: fix suspend/resume sequence

Felix Fietkau <nbd@nbd.name>
    mt76: mt7915: fix tx skb dma unmap

Felix Fietkau <nbd@nbd.name>
    mt76: mt7615: fix tx skb dma unmap

Colin Ian King <colin.king@canonical.com>
    mt7601u: fix always true expression

Dan Carpenter <dan.carpenter@oracle.com>
    rtw88: Fix an error code in rtw_debugfs_set_rsvd_page()

Colin Ian King <colin.king@canonical.com>
    xfs: fix return of uninitialized value in variable error

Weihang Li <liweihang@huawei.com>
    RDMA/hns: Fix missing assignment of max_inline_data

Smita Koralahalli <Smita.KoralahalliChannabasappa@amd.com>
    perf vendor events amd: Fix broken L2 Cache Hits from L2 HWPF metric

Johannes Berg <johannes.berg@intel.com>
    mac80211: bail out if cipher schemes are invalid

Randy Dunlap <rdunlap@infradead.org>
    powerpc: iommu: fix build when neither PCI or IBMVIO is set

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    powerpc/perf: Fix PMU constraint check for EBB events

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64s: Use htab_convert_pte_flags() in hash__mark_rodata_ro()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Add key to flags in pSeries_lpar_hpte_updateboltedpp()

Jordan Niethe <jniethe5@gmail.com>
    powerpc/64s: Fix pte update for kernel memory on radix

Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>
    IB/hfi1: Use kzalloc() for mmu_rb_handler allocation

Colin Ian King <colin.king@canonical.com>
    liquidio: Fix unintented sign extension of a left shift of a u16

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    ASoC: simple-card: fix possible uninitialized single_cpu local variable

Alexandru Elisei <alexandru.elisei@arm.com>
    KVM: arm64: Initialize VCPU mdcr_el2 before loading it

Hans de Goede <hdegoede@redhat.com>
    HID: lenovo: Map mic-mute button to KEY_F20 instead of KEY_MICMUTE

Hans de Goede <hdegoede@redhat.com>
    HID: lenovo: Check hid_get_drvdata() returns non NULL in lenovo_event()

Hans de Goede <hdegoede@redhat.com>
    HID: lenovo: Fix lenovo_led_set_tp10ubkbd() error handling

Hans de Goede <hdegoede@redhat.com>
    HID: lenovo: Use brightness_set_blocking callback for setting LEDs brightness

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Add error checks for usb_driver_claim_interface() calls

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Invalidate PASID cache when root/context entry changed

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Remove WO permissions on second-level paging entries

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Report the right page fault address

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Report right snoop capability when using FL for IOVA

Xiang Chen <chenxiang66@hisilicon.com>
    iommu: Fix a boundary issue to avoid performance drop

Lu Baolu <baolu.lu@linux.intel.com>
    iommu/vt-d: Don't set then clear private data in prq_event_thread()

Wang Wensheng <wangwensheng4@huawei.com>
    KVM: arm64: Fix error return code in init_hyp_mode()

Álvaro Fernández Rojas <noltari@gmail.com>
    mips: bmips: fix syscon-reboot nodes

Salil Mehta <salil.mehta@huawei.com>
    net: hns3: Limiting the scope of vector_ring_chain variable

Dan Carpenter <dan.carpenter@oracle.com>
    nfc: pn533: prevent potential memory corruption

Håkon Bugge <haakon.bugge@oracle.com>
    RDMA/core: Fix corrupted SL on passive side

Andrew Scull <ascull@google.com>
    bug: Remove redundant condition check in report_bug

Yang Yingliang <yangyingliang@huawei.com>
    net/tipc: fix missing destroy_workqueue() on error in tipc_crypto_start()

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/pseries: Only register vio drivers if vio bus exists

Paolo Abeni <pabeni@redhat.com>
    udp: never accept GSO_FRAGLIST packets

Paolo Abeni <pabeni@redhat.com>
    udp: skip L4 aggregation for UDP tunnel packets

Andre Edich <andre.edich@microchip.com>
    net: phy: lan87xx: fix access to wrong register of LAN87xx

Jia Zhou <zhou.jia2@zte.com.cn>
    ALSA: core: remove redundant spin_lock pair in snd_card_disconnect

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    ASoC: q6afe-clocks: fix reprobing of the driver

Yang Yingliang <yangyingliang@huawei.com>
    fs: dlm: fix missing unlock on error in accept_from_sock()

Álvaro Fernández Rojas <noltari@gmail.com>
    gpio: guard gpiochip_irqchip_add_domain() with GPIOLIB_IRQCHIP

Tiezhu Yang <yangtiezhu@loongson.cn>
    MIPS/bpf: Enable bpf_probe_read{, str}() on MIPS again

Chen Huang <chenhuang5@huawei.com>
    powerpc: Fix HAVE_HARDLOCKUP_DETECTOR_ARCH build configuration

Nicholas Piggin <npiggin@gmail.com>
    powerpc/64s: Fix hash fault to use TRAP accessor

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    IB/isert: Fix a use after free in isert_connect_request

Maor Gottlieb <maorg@nvidia.com>
    RDMA/mlx5: Fix drop packet rule in egress table

Zhen Lei <thunder.leizhen@huawei.com>
    iommu/arm-smmu-v3: add bit field SFM into GERROR_ERR_MASK

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: wm8960: Remove bitclk relax condition in wm8960_configure_sysclk

Huang Pei <huangpei@loongson.cn>
    MIPS: loongson64: fix bug when PAGE_SIZE > 16KB

Hanna Hawa <hhhawa@amazon.com>
    pinctrl: pinctrl-single: fix pcs_pin_dbg_show() when bits_per_mux is not zero

Hanna Hawa <hhhawa@amazon.com>
    pinctrl: pinctrl-single: remove unused parameter

Eric Dumazet <edumazet@google.com>
    inet: use bigger hash table for IP ID generation

Li Huafei <lihuafei1@huawei.com>
    ima: Fix the error code for restoring the PCR value

Huang Pei <huangpei@loongson.cn>
    MIPS: fix local_irq_{disable,enable} in asmmacro.h

Nathan Chancellor <nathan@kernel.org>
    powerpc/prom: Mark identical_pvr_fixup as __init

Nathan Chancellor <nathan@kernel.org>
    powerpc/fadump: Mark fadump_calculate_reserve_size as __init

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    powerpc/mm: Move the linear_mapping_mutex to the ifdef where it is used

KP Singh <kpsingh@kernel.org>
    libbpf: Add explicit padding to btf_dump_emit_type_decl_opts

Andrii Nakryiko <andrii@kernel.org>
    selftests/bpf: Re-generate vmlinux.h and BPF skeletons if bpftool changed

Rafał Miłecki <rafal@milecki.pl>
    net: dsa: bcm_sf2: fix BCM4908 RGMII reg(s)

Rafał Miłecki <rafal@milecki.pl>
    net: dsa: bcm_sf2: add function finding RGMII register

Dmitry Osipenko <digetx@gmail.com>
    ASoC: tegra30: i2s: Restore hardware state on runtime PM resume

Jacob Pan <jacob.jun.pan@linux.intel.com>
    iommu/vt-d: Reject unsupported page request modes

Robin Murphy <robin.murphy@arm.com>
    iommu/dma: Resurrect the "forcedac" option

Shameer Kolothum <shameerali.kolothum.thodi@huawei.com>
    iommu: Check dev->iommu in iommu_dev_xxx functions

Andrii Nakryiko <andrii@kernel.org>
    bpftool: Fix maybe-uninitialized warnings

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Add explicit padding to bpf_xdp_set_link_opts

Xie He <xie.he.0141@gmail.com>
    net: lapbether: Prevent racing when checking whether the netif is running

Jiri Kosina <jkosina@suse.cz>
    Bluetooth: avoid deadlock between hci_dev->lock and socket lock

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Retry page faults that hit an invalid memslot

Marcus Folkesson <marcus.folkesson@gmail.com>
    wilc1000: write value to WILC_INTR2_ENABLE register

Yevgeny Kliteynik <kliteyn@nvidia.com>
    net/mlx5: DR, Add missing vhca_id consume from STEv1

Mark Zhang <markzhang@nvidia.com>
    RDMA/mlx5: Fix mlx5 rates to IB rates map

Maor Gottlieb <maorg@nvidia.com>
    RDMA/mlx5: Fix query RoCE port

Jason Gunthorpe <jgg@ziepe.ca>
    RDMA/mlx5: Zero out ODP related items in the mlx5_ib_mr

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Skylake: Compile when any configuration is selected

Colin Ian King <colin.king@canonical.com>
    ASoC: Intel: boards: sof-wm8804: add check for PLL setting

Arnaldo Carvalho de Melo <acme@redhat.com>
    perf symbols: Fix dso__fprintf_symbols_by_name() to return the number of printed chars

Maxim Mikityanskiy <maxtram95@gmail.com>
    HID: plantronics: Workaround for double volume key presses

Alexander Lobakin <alobakin@pm.me>
    xsk: Respect device's headroom and tailroom on generic xmit path

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    drivers/block/null_blk/main: Fix a double free in null_init.

Dan Carpenter <dan.carpenter@oracle.com>
    ataflop: fix off by one in ataflop_probe()

Dan Carpenter <dan.carpenter@oracle.com>
    ataflop: potential out of bounds in do_format()

Peter Zijlstra <peterz@infradead.org>
    kthread: Fix PF_KTHREAD vs to_kthread() race

Waiman Long <longman@redhat.com>
    sched/debug: Fix cgroup_path[] serialization

Dima Stepanov <dmitrii.stepanov@cloud.ionos.com>
    block/rnbd-clt-sysfs: Remove copy buffer overlap in rnbd_clt_get_path_name

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix overflows checks in provide buffers

Nathan Chancellor <nathan@kernel.org>
    perf/amd/uncore: Fix sysfs type mismatch

Nathan Chancellor <nathan@kernel.org>
    x86/events/amd/iommu: Fix sysfs type mismatch

Dan Carpenter <dan.carpenter@oracle.com>
    HSI: core: fix resource leaks in hsi_add_client_from_dt()

Jernej Skrabec <jernej.skrabec@siol.net>
    media: cedrus: Fix H265 status definitions

Neil Armstrong <narmstrong@baylibre.com>
    media: meson-ge2d: fix rotation parameters

Niklas Cassel <niklas.cassel@wdc.com>
    nvme-pci: don't simple map sgl when sgls are disabled

Elad Grupi <elad.grupi@dell.com>
    nvmet-tcp: fix a segmentation fault during io parsing error

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    mfd: stm32-timers: Avoid clearing auto reload register

Orson Zhai <orson.zhai@unisoc.com>
    mailbox: sprd: Introduce refcnt when clients requests/free channels

Brian King <brking@linux.vnet.ibm.com>
    scsi: ibmvfc: Fix invalid state machine BUG_ON()

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    scsi: sni_53c710: Add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    scsi: sun3x_esp: Add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    scsi: jazz_esp: Add IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    scsi: hisi_sas: Fix IRQ checks

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    scsi: ufs: ufshcd-pltfrm: Fix deferred probing

Colin Ian King <colin.king@canonical.com>
    scsi: pm80xx: Fix potential infinite loop

Igor Pylypiv <ipylypiv@google.com>
    scsi: pm80xx: Increase timeout for pm80xx mpi_uninit_check()

Colin Ian King <colin.king@canonical.com>
    clk: uniphier: Fix potential infinite loop

Gustavo A. R. Silva <gustavoars@kernel.org>
    bcache: Use 64-bit arithmetic instead of 32-bit

Yingjie Wang <wangyingjie55@126.com>
    drm/radeon: Fix a missing check bug in radeon_dp_mst_detect()

Sefa Eyeoglu <contact@scrumplex.net>
    drm/amd/display: check fb of primary plane

Nirmoy Das <nirmoy.das@amd.com>
    drm/amd/display: use GFP_ATOMIC in dcn20_resource_construct

Chen Hui <clare.chenhui@huawei.com>
    clk: qcom: apss-ipq-pll: Add missing MODULE_DEVICE_TABLE

Chen Hui <clare.chenhui@huawei.com>
    clk: qcom: a53-pll: Add missing MODULE_DEVICE_TABLE

Chen Hui <clare.chenhui@huawei.com>
    clk: qcom: a7-pll: Add missing MODULE_DEVICE_TABLE

Jacopo Mondi <jacopo+renesas@jmondi.org>
    media: i2c: rdamc21: Fix warning on u8 cast

Dan Carpenter <dan.carpenter@oracle.com>
    drm: xlnx: zynqmp: fix a memset in zynqmp_dp_train()

Quanyang Wang <quanyang.wang@windriver.com>
    clk: zynqmp: pll: add set_pll_mode to check condition in zynqmp_pll_enable

Quanyang Wang <quanyang.wang@windriver.com>
    clk: zynqmp: move zynqmp_pll_set_mode out of round_rate callback

Jason Gunthorpe <jgg@ziepe.ca>
    vfio/mdev: Do not allow a mdev_type to have a NULL parent pointer

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dpu: enable DPU_SSPP_QOS_8LVL for SM8250

Rob Clark <robdclark@chromium.org>
    drm/msm: Fix debugfs deadlock

Jason Gunthorpe <jgg@ziepe.ca>
    vfio/pci: Re-order vfio_pci_probe()

Jason Gunthorpe <jgg@ziepe.ca>
    vfio/pci: Move VGA and VF initialization to functions

Jason Gunthorpe <jgg@ziepe.ca>
    vfio/fsl-mc: Re-order vfio_fsl_mc_probe()

Daniel Almeida <daniel.almeida@collabora.com>
    media: rkvdec: Do not require all controls to be present in every request

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: v4l2-ctrls.c: fix race condition in hdl->requests list

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    media: i2c: imx219: Balance runtime PM use-count

Lad Prabhakar <prabhakar.mahadev-lad.rj@bp.renesas.com>
    media: i2c: imx219: Move out locking/unlocking of vflip and hflip controls from imx219_set_stream

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ipu3-cio2: Fix pixel-rate derived link frequency

Sakari Ailus <sakari.ailus@linux.intel.com>
    media: ccs: Fix sub-device function

Hannes Reinecke <hare@suse.de>
    nvme: retrigger ANA log update if group descriptor isn't found

Ricardo Rivera-Matos <r-rivera-matos@ti.com>
    power: supply: bq25980: Move props from battery node

Adam Ford <aford173@gmail.com>
    clk: imx: Fix reparenting of UARTs not associated with stdout

Sagi Grimberg <sagi@grimberg.me>
    nvmet-tcp: fix incorrect locking in state_change sk callback

Sagi Grimberg <sagi@grimberg.me>
    nvme-tcp: block BH in sk state_change sk callback

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    drm/mediatek: Don't support hdmi connector creation

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    drm/mediatek: Switch the hdmi bridge ops to the atomic versions

Kenta.Tada@sony.com <Kenta.Tada@sony.com>
    seccomp: Fix CONFIG tests for Seccomp_filters

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    ata: libahci_platform: fix IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    sata_mv: add IRQ checks

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    pata_ipx4xx_cf: fix IRQ check

Sergey Shtylyov <s.shtylyov@omprussia.ru>
    pata_arasan_cf: fix IRQ check

Ilya Leoshkevich <iii@linux.ibm.com>
    selftests: fix prepending $(OUTPUT) to $(TEST_PROGS)

Yang Li <yang.lee@linux.alibaba.com>
    drm/omap: dsi: Add missing IRQF_ONESHOT

Masami Hiramatsu <mhiramat@kernel.org>
    x86/kprobes: Fix to check non boostable prefixes correctly

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Check kzalloc() return value

kernel test robot <lkp@intel.com>
    of: overlay: fix for_each_child.cocci warnings

Victor Lu <victorchengchi.lu@amd.com>
    drm/amd/display: Free local data after use

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdkfd: Fix recursive lock warnings

Felix Kuehling <Felix.Kuehling@amd.com>
    drm/amdkfd: fix build error with AMD_IOMMU_V2=m

Masami Hiramatsu <mhiramat@kernel.org>
    x86/kprobes: Retrieve correct opcode for group instruction

Dan Carpenter <dan.carpenter@oracle.com>
    media: atomisp: Fix use after free in atomisp_alloc_css_stat_bufs()

Colin Ian King <colin.king@canonical.com>
    media: m88rs6000t: avoid potential out-of-bounds reads on arrays

Souptick Joarder <jrdr.linux@gmail.com>
    media: atomisp: Fixed error handling path

Colin Ian King <colin.king@canonical.com>
    media: [next] staging: media: atomisp: fix memory leak of object flash

Liu Ying <victor.liu@nxp.com>
    media: docs: Fix data organization of MEDIA_BUS_FMT_RGB101010_1X30

Wei Yongjun <weiyongjun1@huawei.com>
    media: m88ds3103: fix return value check in m88ds3103_probe()

Jia-Ju Bai <baijiaju1990@gmail.com>
    media: platform: sunxi: sun6i-csi: fix error return code of sun6i_video_start_streaming()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: venus: core: Fix some resource leaks in the error path of 'venus_probe()'

Noralf Trønnes <noralf@tronnes.org>
    drm/probe-helper: Check epoch counter in output_poll_execute()

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    power: supply: bq27xxx: fix sign of current_now for newer ICs

Douglas Anderson <dianders@chromium.org>
    drm/panel-simple: Undo enable if HPD never asserts

Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>
    media: aspeed: fix clock handling logic

Dafna Hirschfeld <dafna.hirschfeld@collabora.com>
    media: rkisp1: rsz: crash fix when setting src format

Yang Yingliang <yangyingliang@huawei.com>
    media: omap4iss: return error code when omap4iss_get() failed

Tasos Sahanidis <tasos@tasossah.com>
    media: saa7146: use sg_dma_len when building pgtable

Tasos Sahanidis <tasos@tasossah.com>
    media: saa7134: use sg_dma_len when building pgtable

Colin Ian King <colin.king@canonical.com>
    media: vivid: fix assignment of dev->fbuf_out_flags

Arnd Bergmann <arnd@arndb.de>
    media: mtk: fix mtk-smi dependency

Zhouyi Zhou <zhouzhouyi@gmail.com>
    rcu: Remove spurious instrumentation_end() in rcu_nmi_enter()

David Howells <dhowells@redhat.com>
    afs: Fix updating of i_mode due to 3rd party change

John Ogness <john.ogness@linutronix.de>
    printk: limit second loop of syslog_print_all

Valentin Schneider <valentin.schneider@arm.com>
    sched/fair: Fix shift-out-of-bounds in load_balance()

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix null pointer dereference in lpfc_prep_els_iocb()

Linus Walleij <linus.walleij@linaro.org>
    drm/mcde/panel: Inverse misunderstood flag

Dan Carpenter <dan.carpenter@oracle.com>
    drm/amd/display: Fix off by one in hdmi_14_process_transaction()

Marek Vasut <marex@denx.de>
    drm/stm: Fix bus_flags handling

Quanyang Wang <quanyang.wang@windriver.com>
    drm/tilcdc: send vblank event when disabling crtc

Dan Carpenter <dan.carpenter@oracle.com>
    soc: aspeed: fix a ternary sign expansion bug

Paul Durrant <pdurrant@amazon.com>
    xen-blkback: fix compatibility bug with single page rings

Quanyang Wang <quanyang.wang@windriver.com>
    spi: tools: make a symbolic link to the header file spi.h

Dario Binacchi <dariobin@libero.it>
    serial: omap: fix rs485 half-duplex filtering

Dario Binacchi <dariobin@libero.it>
    serial: omap: don't disable rs485 if rts gpio is missing

Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>
    ttyprintk: Add TTY hangup callback.

Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
    usb: dwc2: Fix hibernation between host and device modes.

Artur Petrosyan <Arthur.Petrosyan@synopsys.com>
    usb: dwc2: Fix host mode hibernation exit with remote wakeup flow.

Chris von Recklinghausen <crecklin@redhat.com>
    PM: hibernate: x86: Use crc32 instead of md5 for hibernation e820 integrity check

Michael Kelley <mikelley@microsoft.com>
    Drivers: hv: vmbus: Increase wait time for VMbus unload

Dan Carpenter <dan.carpenter@oracle.com>
    platform/surface: aggregator: fix a bit test

Paul Fertser <fercerpav@gmail.com>
    hwmon: (pmbus/pxe1610) don't bail out when not all pages are active

Ingo Molnar <mingo@kernel.org>
    x86/platform/uv: Fix !KEXEC build failure

Arnd Bergmann <arnd@arndb.de>
    btrfs: zoned: bail out in btrfs_alloc_chunk for bad input

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: zoned: move log tree node allocation out of log_root_tree->log_mutex

Quanyang Wang <quanyang.wang@windriver.com>
    spi: spi-zynqmp-gqspi: return -ENOMEM if dma_map_single fails

Quanyang Wang <quanyang.wang@windriver.com>
    spi: spi-zynqmp-gqspi: fix use-after-free in zynqmp_qspi_exec_op

Quanyang Wang <quanyang.wang@windriver.com>
    spi: spi-zynqmp-gqspi: fix hang issue when suspend/resume

Quanyang Wang <quanyang.wang@windriver.com>
    spi: spi-zynqmp-gqspi: fix clk_enable/disable imbalance issue

Ard Biesheuvel <ardb@kernel.org>
    crypto: arm64/aes-ce - deal with oversight in new CTR carry code

Dan Carpenter <dan.carpenter@oracle.com>
    Drivers: hv: vmbus: Use after free in __vmbus_open()

Eddie James <eajames@linux.ibm.com>
    ARM: dts: aspeed: Rainier: Fix humidity sensor bus address

Dinghao Liu <dinghao.liu@zju.edu.cn>
    spi: spi-zynqmp-gqspi: Fix runtime PM imbalance in zynqmp_qspi_probe

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Honour pSnkStdby requirement during negotiation

Steffen Dirkwinkel <s.dirkwinkel@beckhoff.com>
    platform/x86: pmc_atom: Match all Beckhoff Automation baytrail boards with critclk_systems DMI table

Zhihao Cheng <chengzhihao1@huawei.com>
    char: tpm: fix error return code in tpm_cr50_i2c_tis_recv()

James Bottomley <James.Bottomley@HansenPartnership.com>
    security: keys: trusted: fix TPM2 authorizations

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    memory: samsung: exynos5422-dmc: handle clk_set_parent() failure

Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
    memory: renesas-rpc-if: fix possible NULL pointer dereference of resource

Wei Yongjun <weiyongjun1@huawei.com>
    spi: spi-zynqmp-gqspi: Fix missing unlock on error in zynqmp_qspi_exec_op()

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: Fixes issue with Configure Endpoint command

Liam Howlett <liam.howlett@oracle.com>
    m68k: Add missing mmap_read_lock() to sys_cacheflush()

Ye Bin <yebin10@huawei.com>
    usbip: vudc: fix missing unlock on error in usbip_sockfd_store()

Ayush Sawal <ayush.sawal@chelsio.com>
    crypto: chelsio - Read rxchannel-id from firmware

Dan Carpenter <dan.carpenter@oracle.com>
    node: fix device cleanups in error handling code

He Ying <heying24@huawei.com>
    firmware: qcom-scm: Fix QCOM_SCM configuration

Johan Hovold <johan@kernel.org>
    serial: core: return early on unsupported ioctls

Johan Hovold <johan@kernel.org>
    tty: fix return value for unsupported termiox ioctls

Johan Hovold <johan@kernel.org>
    tty: fix return value for unsupported ioctls

Johan Hovold <johan@kernel.org>
    tty: actually undefine superseded ASYNC flags

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix TIOCGSERIAL implementation

Johan Hovold <johan@kernel.org>
    USB: cdc-acm: fix unprivileged TIOCCSERIAL

Colin Ian King <colin.king@canonical.com>
    usb: gadget: r8a66597: Add missing null check on return from platform_get_resource

Wang Li <wangli74@huawei.com>
    spi: fsl-lpspi: Fix PM reference leak in lpspi_prepare_xfer_hardware()

Quanyang Wang <quanyang.wang@windriver.com>
    spi: spi-zynqmp-gqspi: fix incorrect operating mode in zynqmp_qspi_read_op

Quanyang Wang <quanyang.wang@windriver.com>
    spi: spi-zynqmp-gqspi: transmit dummy circles by using the controller's internal functionality

Quanyang Wang <quanyang.wang@windriver.com>
    spi: spi-zynqmp-gqspi: add mutex locking for exec_op

Quanyang Wang <quanyang.wang@windriver.com>
    spi: spi-zynqmp-gqspi: use wait_for_completion_timeout to make zynqmp_qspi_exec_op not interruptible

Pali Rohár <pali@kernel.org>
    cpufreq: armada-37xx: Fix determining base CPU frequency

Pali Rohár <pali@kernel.org>
    cpufreq: armada-37xx: Fix driver cleanup when registration failed

Pali Rohár <pali@kernel.org>
    clk: mvebu: armada-37xx-periph: Fix workaround for switching from L1 to L0

Pali Rohár <pali@kernel.org>
    clk: mvebu: armada-37xx-periph: Fix switching CPU freq from 250 Mhz to 1 GHz

Pali Rohár <pali@kernel.org>
    cpufreq: armada-37xx: Fix the AVS value for load L1

Marek Behún <kabel@kernel.org>
    clk: mvebu: armada-37xx-periph: remove .set_parent method for CPU PM clock

Marek Behún <kabel@kernel.org>
    cpufreq: armada-37xx: Fix setting TBG parent for load levels

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    crypto: qat - Fix a double free in adf_create_ring

Colin Ian King <colin.king@canonical.com>
    crypto: sa2ul - Fix memory leak of rxd

Colin Ian King <colin.king@canonical.com>
    crypto: sun8i-ss - Fix memory leak of pad

Corentin Labbe <clabbe.montjoie@gmail.com>
    crypto: allwinner - add missing CRYPTO_ prefix

Nathan Chancellor <nathan@kernel.org>
    ACPI: CPPC: Replace cppc_attr with kobj_attribute

He Ying <heying24@huawei.com>
    cpuidle: Fix ARM_QCOM_SPM_CPUIDLE configuration

YueHaibing <yuehaibing@huawei.com>
    PM: runtime: Replace inline function pm_runtime_callbacks_present()

Bjorn Andersson <bjorn.andersson@linaro.org>
    soc: qcom: mdt_loader: Detect truncated read of segments

Bjorn Andersson <bjorn.andersson@linaro.org>
    soc: qcom: mdt_loader: Validate that p_filesz < p_memsz

Yang Yingliang <yangyingliang@huawei.com>
    spi: fsl: add missing iounmap() on error in of_fsl_spi_probe()

William A. Kennington III <wak@google.com>
    spi: Fix use-after-free with devm_spi_alloc_*

Wei Yongjun <weiyongjun1@huawei.com>
    clocksource/drivers/ingenic_ost: Fix return value check in ingenic_ost_probe()

Tony Lindgren <tony@atomide.com>
    clocksource/drivers/timer-ti-dm: Add missing set_state_oneshot_stopped

Tony Lindgren <tony@atomide.com>
    clocksource/drivers/timer-ti-dm: Fix posted mode status check order

Dong Aisheng <aisheng.dong@nxp.com>
    PM / devfreq: Use more accurate returned new_freq as resume_freq

Qinglang Miao <miaoqinglang@huawei.com>
    soc: qcom: pdr: Fix error return code in pdr_register_listener

Hans de Goede <hdegoede@redhat.com>
    platform/x86: dell-wmi-sysman: Make init_bios_attributes() ACPI object parsing more robust

Johan Hovold <johan@kernel.org>
    staging: greybus: uart: fix unprivileged TIOCCSERIAL

Johan Hovold <johan@kernel.org>
    staging: fwserial: fix TIOCGSERIAL implementation

Johan Hovold <johan@kernel.org>
    staging: fwserial: fix TIOCSSERIAL implementation

Colin Ian King <colin.king@canonical.com>
    staging: rtl8192u: Fix potential infinite loop

Ian Abbott <abbotti@mev.co.uk>
    staging: comedi: tests: ni_routes_test: Fix compilation error

Arnd Bergmann <arnd@arndb.de>
    irqchip/gic-v3: Fix OF_BAD_ADDR error handling

Lv Yunlong <lyl2019@mail.ustc.edu.cn>
    mtd: rawnand: gpmi: Fix a double free in gpmi_nand_init

Alexandru Ardelean <aardelean@deviqon.com>
    iio: adc: Kconfig: make AD9467 depend on ADI_AXI_ADC symbol

Stephen Boyd <swboyd@chromium.org>
    firmware: qcom_scm: Workaround lack of "is available" call on SC7180

Stephen Boyd <swboyd@chromium.org>
    firmware: qcom_scm: Reduce locking section for __get_convention()

Stephen Boyd <swboyd@chromium.org>
    firmware: qcom_scm: Make __qcom_scm_is_call_available() return bool

Finn Thain <fthain@telegraphics.com.au>
    m68k: mvme147,mvme16x: Don't wipe PCC timer config bits

Rander Wang <rander.wang@intel.com>
    soundwire: stream: fix memory leak in stream config error path

gexueyuan <gexueyuan@gmail.com>
    memory: pl353: fix mask of ECC page_size config register

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: qcom: msm8974-samsung-klte: correct fuel gauge interrupt trigger level

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: qcom: msm8974-lge-nexus5: correct fuel gauge interrupt trigger level

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    driver core: platform: Declare early_platform_cleanup() prototype

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    nvmem: rmem: fix undefined reference to memremap

Ravi Kumar Bokka <rbokka@codeaurora.org>
    drivers: nvmem: Fix voltage settings for QTI qfprom-efuse

Yang Yingliang <yangyingliang@huawei.com>
    USB: gadget: udc: fix wrong pointer passed to IS_ERR() and PTR_ERR()

Tao Ren <rentao.bupt@gmail.com>
    usb: gadget: aspeed: fix dma map failure

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix error path in adf_isr_resource_alloc()

Arnd Bergmann <arnd@arndb.de>
    crypto: poly1305 - fix poly1305_core_setkey() declaration

Olga Kornievskaia <kolga@netapp.com>
    NFSv4.2: fix copy stateid copying for the async copy

Fabien Parent <fparent@baylibre.com>
    arm64: dts: mediatek: fix reset GPIO level on pumpkin

Wei Yongjun <weiyongjun1@huawei.com>
    phy: ingenic: Fix a typo in ingenic_usb_phy_probe()

Wei Yongjun <weiyongjun1@huawei.com>
    phy: ralink: phy-mt7621-pci: fix return value check in mt7621_pci_phy_probe()

Geert Uytterhoeven <geert+renesas@glider.be>
    phy: marvell: ARMADA375_USBCLUSTER_PHY should not default to y, unconditionally

Sergio Paracuellos <sergio.paracuellos@gmail.com>
    phy: ralink: phy-mt7621-pci: fix XTAL bitmask

Kishon Vijay Abraham I <kishon@ti.com>
    phy: ti: j721e-wiz: Delete "clk_div_sel" clk provider during cleanup

Enric Balletbo i Serra <enric.balletbo@collabora.com>
    soc: mediatek: pm-domains: Fix missing error code in scpsys_add_subdomain()

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soundwire: bus: Fix device found flag correctly

Jonathan Marek <jonathan@marek.ca>
    arm64: dts: qcom: sm8250: fix display nodes

Pan Bian <bianpan2016@163.com>
    bus: qcom: Put child node before return

Chunfeng Yun <chunfeng.yun@mediatek.com>
    arm64: dts: mt8173: fix wrong power-domain phandle of pmic

Hsin-Yi Wang <hsinyi@chromium.org>
    arm64: dts: mt8183: Add gce client reg for display subcomponents

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    arm64: dts: renesas: r8a779a0: Fix PMU interrupt

Michael Walle <michael@walle.cc>
    mtd: require write permissions for locking and badblock ioctls

dillon min <dillon.minfei@gmail.com>
    dt-bindings: serial: stm32: Use 'type: object' instead of false for 'additionalProperties'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: gadget: s3c: Fix the error handling path in 's3c2410_udc_probe()'

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    usb: gadget: s3c: Fix incorrect resources releasing

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Complete OUT requests on short packets

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Don't DMA more than the buffer can take

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Mask GRP2 interrupts we don't handle

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Remove a dubious condition leading to fotg210_done

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Fix EP0 IN requests bigger than two packets

Fabian Vogt <fabian@ritter-vogt.de>
    fotg210-udc: Fix DMA on EP0 for length > max packet size

Tong Zhang <ztong0001@gmail.com>
    crypto: qat - ADF_STATUS_PF_RUNNING should be set after adf_dev_init

Tong Zhang <ztong0001@gmail.com>
    crypto: qat - don't release uninitialized resources

Rijo Thomas <Rijo-john.Thomas@amd.com>
    crypto: ccp - fix command queuing to TEE ring buffer

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Provide a GPIO line used on Intel Minnowboard (v1)

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Initialize device pointer before use

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Check for DMA mapping error

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Check if driver is present before calling ->setup()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Replace cpu_to_le32() by lower_32_bits()

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    devtmpfs: fix placement of complete() call

Dmitry Osipenko <digetx@gmail.com>
    usb: host: ehci-tegra: Select USB_GADGET Kconfig option

Otavio Pontes <otavio.pontes@intel.com>
    x86/microcode: Check for offline CPUs before requesting new microcode

Dan Carpenter <dan.carpenter@oracle.com>
    staging: qlge: fix an error code in probe()

Andrea Parri (Microsoft) <parri.andrea@gmail.com>
    Drivers: hv: vmbus: Drop error message when 'No request id available'

Alain Volmat <alain.volmat@foss.st.com>
    spi: stm32: Fix use-after-free on unbind

Eric Biggers <ebiggers@google.com>
    crypto: arm/blake2s - fix for big endian

Andy Lutomirski <luto@kernel.org>
    selftests/x86: Add a missing .note.GNU-stack section to thunks_32.S

Vladimir Barinov <vladimir.barinov@cogentembedded.com>
    arm64: dts: renesas: r8a77980: Fix vin4-7 endpoint binding

Dan Carpenter <dan.carpenter@oracle.com>
    regulator: bd9576: Fix return from bd957x_probe()

Rafał Miłecki <rafal@milecki.pl>
    arm64: dts: broadcom: bcm4908: set Asus GT-AC5300 port 7 PHY mode

Antonio Borneo <antonio.borneo@foss.st.com>
    spi: stm32: drop devres version of spi_register_master

Colin Ian King <colin.king@canonical.com>
    crypto: sun8i-ss - Fix memory leak of object d when dma_iv fails to map

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    arm64: dts: qcom: db845c: fix correct powerdown pin for WSA881x

Shawn Guo <shawn.guo@linaro.org>
    arm64: dts: qcom: sm8350: fix number of pins in 'gpio-ranges'

Shawn Guo <shawn.guo@linaro.org>
    arm64: dts: qcom: sm8250: fix number of pins in 'gpio-ranges'

Shawn Guo <shawn.guo@linaro.org>
    arm64: dts: qcom: sm8150: fix number of pins in 'gpio-ranges'

Shawn Guo <shawn.guo@linaro.org>
    arm64: dts: qcom: sdm845: fix number of pins in 'gpio-ranges'

Douglas Anderson <dianders@chromium.org>
    arm64: dts: qcom: sc7180: Avoid glitching SPI CS at bootup on trogdor

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    arm64: dts: qcom: sm8250: Fix timer interrupt to specify EL2 physical timer

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    arm64: dts: qcom: sm8350: Fix level triggered PMU interrupt polarity

Sai Prakash Ranjan <saiprakash.ranjan@codeaurora.org>
    arm64: dts: qcom: sm8250: Fix level triggered PMU interrupt polarity

Matthias Kaehlcke <mka@chromium.org>
    arm64: dts: qcom: sc7180: trogdor: Fix trip point config of charger thermal zone

Nuno Sa <nuno.sa@analog.com>
    iio: adis16480: fix pps mode sampling frequency math

Aswath Govindraju <a-govindraju@ti.com>
    arm64: dts: ti: k3-j721e-main: Update the speed modes supported and their itap delay values for MMCSD subsystems

Valentin CARON - foss <valentin.caron@foss.st.com>
    ARM: dts: stm32: fix usart 2 & 3 pinconf to wake up with flow control

Jia-Ju Bai <baijiaju1990@gmail.com>
    mtd: maps: fix error return code of physmap_flash_remove()

Baruch Siach <baruch@tkos.co.il>
    mtd: parsers: qcom: incompatible with spi-nor 4k sectors

Miquel Raynal <miquel.raynal@bootlin.com>
    mtd: parsers: qcom: Fix error condition

David Bauer <mail@david-bauer.net>
    mtd: don't lock when recursively deleting partitions

Manivannan Sadhasivam <mani@kernel.org>
    mtd: rawnand: qcom: Return actual error code instead of -ENODEV

Manivannan Sadhasivam <mani@kernel.org>
    mtd: Handle possible -EPROBE_DEFER from parse_mtd_partitions()

Álvaro Fernández Rojas <noltari@gmail.com>
    mtd: rawnand: brcmnand: fix OOB R/W with Hamming ECC

Dan Carpenter <dan.carpenter@oracle.com>
    mtd: rawnand: fsmc: Fix error code in fsmc_nand_probe()

Rafał Miłecki <rafal@milecki.pl>
    arm64: dts: broadcom: bcm4908: fix switch parent node name

Arnd Bergmann <arnd@arndb.de>
    spi: rockchip: avoid objtool warning

Meng Li <Meng.Li@windriver.com>
    regmap: set debugfs_name to NULL after it is freed

David E. Box <david.e.box@linux.intel.com>
    mfd: intel_pmt: Fix nuisance messages and handling of disabled capabilities

Wei Yongjun <weiyongjun1@huawei.com>
    usb: typec: stusb160x: fix return value check in stusb160x_probe()

Wei Yongjun <weiyongjun1@huawei.com>
    usb: typec: tps6598x: Fix return value check in tps6598x_probe()

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpci: Check ROLE_CONTROL while interpreting CC_STATUS

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Wait for vbus discharge to VSAFE0V before toggling

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: fix tx_empty condition

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: add FIFO flush when port is closed

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: fix FIFO flush in startup and set_termios

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: call stm32_transmit_chars locked

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: fix tx dma completion, release channel

Wei Yongjun <weiyongjun1@huawei.com>
    serial: liteuart: fix return value check in liteuart_probe()

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: fix a deadlock in set_termios

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: fix wake-up flag handling

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: fix a deadlock condition with wakeup event

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: fix TX and RX FIFO thresholds

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: fix incorrect characters on console

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: fix startup by enabling usart for reception

Erwan Le Ray <erwan.leray@foss.st.com>
    serial: stm32: fix probe and remove order for dma

Mike Travis <mike.travis@hpe.com>
    x86/platform/uv: Set section block size for hubless architectures

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix initializing module_pa for modules without sysc register

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    arm64: dts: renesas: Add mmc aliases into board dts files

Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
    ARM: dts: renesas: Add mmc aliases into R-Car Gen2 board dts files

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: s5pv210: correct fuel gauge interrupt trigger level on Fascinate family

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Snow

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on SMDK5250

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on P4 Note family

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Odroid X/U3 family

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct PMIC interrupt trigger level on Midas family

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct MUIC interrupt trigger level on Midas family

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct fuel gauge interrupt trigger level on Midas family

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct fuel gauge interrupt trigger level on P4 Note family

Krzysztof Kozlowski <krzk@kernel.org>
    ARM: dts: exynos: correct fuel gauge interrupt trigger level on GT-I9100

Colin Ian King <colin.king@canonical.com>
    memory: gpmc: fix out of bounds read and dereference on gpmc_cs[]

Corentin Labbe <clabbe.montjoie@gmail.com>
    crypto: sun8i-ss - fix result memory leak on error path

Wei Yongjun <weiyongjun1@huawei.com>
    crypto: keembay-ocs-aes - Fix error return code in kmb_ocs_aes_probe()

Wei Yongjun <weiyongjun1@huawei.com>
    crypto: keembay-ocs-hcu - Fix error return code in kmb_ocs_hcu_probe()

Luca Ceresoli <luca@lucaceresoli.net>
    fpga: fpga-mgr: xilinx-spi: fix error messages on -EPROBE_DEFER

Jiri Slaby <jirislaby@kernel.org>
    x86/vdso: Use proper modifier for len's format specifier in extract()

Nobuhiro Iwamatsu <iwamatsu@nigauri.org>
    firmware: xilinx: Remove zynqmp_pm_get_eemi_ops() in IS_REACHABLE(CONFIG_ZYNQMP_FIRMWARE)

Tejas Patel <tejas.patel@xilinx.com>
    firmware: xilinx: Fix dereferencing freed memory

Len Brown <len.brown@intel.com>
    Revert "tools/power turbostat: adjust for temperature offset"

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    usb: gadget: pch_udc: Revert d3cb25a12138 completely

Gerd Hoffmann <kraxel@redhat.com>
    Revert "drm/qxl: do not run release if qxl failed to init"

Dan Carpenter <dan.carpenter@oracle.com>
    ovl: fix missing revert_creds() on error path

Rikard Falkeborn <rikard.falkeborn@gmail.com>
    mfd: stmpe: Revert "Constify static struct resource"

Jae Hyun Yoo <jae.hyun.yoo@linux.intel.com>
    Revert "i3c master: fix missing destroy_workqueue() on error in i3c_master_register"

Xie He <xie.he.0141@gmail.com>
    Revert "drivers/net/wan/hdlc_fr: Fix a double free in pvc_xmit"

Paolo Bonzini <pbonzini@redhat.com>
    KVM: selftests: Always run vCPU thread with blocked SIG_IPI

Peter Xu <peterx@redhat.com>
    KVM: selftests: Sync data verify of dirty logging with guest sync

Eric Auger <eric.auger@redhat.com>
    KVM: arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST_REGION read

Marc Zyngier <maz@kernel.org>
    KVM: arm64: Fully zero the vcpu state on reset

David Brazdil <dbrazdil@google.com>
    KVM: arm64: Support PREL/PLT relocs in EL2 code

Sean Christopherson <seanjc@google.com>
    KVM: Stop looking for coalesced MMIO zones if the bus is destroyed

Sean Christopherson <seanjc@google.com>
    KVM: Destroy I/O bus devices on unregister failure _after_ sync'ing SRCU

Eric Auger <eric.auger@redhat.com>
    KVM: arm/arm64: Fix KVM_VGIC_V3_ADDR_TYPE_REDIST read

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Truncate base/index GPR value on address calc in !64-bit

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Truncate bits 63:32 of VMCS field on nested check in !64-bit

Sean Christopherson <seanjc@google.com>
    KVM: VMX: Truncate GPR value for DR and CR reads in !64-bit mode

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Defer the MMU reload to the normal path on an EPTP switch

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Inject #GP on guest MSR_TSC_AUX accesses if RDTSCP unsupported

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Do not allow SEV/SEV-ES initialization after vCPUs are created

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Do not set sev->es_active until KVM_SEV_ES_INIT completes

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Use online_vcpus, not created_vcpus, to iterate over vCPUs

Sean Christopherson <seanjc@google.com>
    KVM: SVM: Don't strip the C-bit from CR2 on #PF interception

Sean Christopherson <seanjc@google.com>
    KVM: nSVM: Set the shadow root level to the TDP level for nested NPT

Sean Christopherson <seanjc@google.com>
    KVM: x86: Remove emulator's broken checks on CR0/CR3/CR4 loads

Sean Christopherson <seanjc@google.com>
    KVM: x86: Check CR3 GPA for validity regardless of vCPU mode

Vitaly Kuznetsov <vkuznets@redhat.com>
    KVM: x86: Properly handle APF vs disabled LAPIC situation

Wanpeng Li <wanpengli@tencent.com>
    KVM: X86: Fix failure to boost kernel lock holder candidate in SEV-ES guests

Sean Christopherson <seanjc@google.com>
    KVM: x86/xen: Drop RAX[63:32] when processing hypercall

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Alloc page for PDPTEs when shadowing 32-bit NPT with 64-bit

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: extend kvm_s390_shadow_fault to return entry pointer

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: split kvm_s390_real_to_abs

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: VSIE: fix MVPG handling for prefixing and MSO

David Hildenbrand <david@redhat.com>
    s390: fix detection of vector enhancements facility 1 vs. vector packed decimal facility

Heiko Carstens <hca@linux.ibm.com>
    KVM: s390: fix guarded storage control register handling

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: split kvm_s390_logical_to_effective

Claudio Imbrenda <imbrenda@linux.ibm.com>
    KVM: s390: VSIE: correctly handle MVPG when in VSIE

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix speaker amp on HP Envy AiO 32

Sami Loone <sami@loone.fi>
    ALSA: hda/realtek: ALC285 Thinkpad jack pin quirk is unreachable

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Remove redundant entry for ALC861 Haier/Uniwill devices

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC662 quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order remaining ALC269 quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC269 Lenovo quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC269 Sony quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC269 ASUS quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC269 Dell quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC269 Acer quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC269 HP quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC882 Clevo quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC882 Sony quirk table entries

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Re-order ALC882 Acer quirk table entries

Bas Nieuwenhuizen <bas@basnieuwenhuizen.nl>
    drm/amdgpu: Init GFX10_ADDR_CONFIG for VCN v3 in DPG mode.

Victor Zhao <Victor.Zhao@amd.com>
    drm/amdgpu: fix r initial values

Evan Quan <evan.quan@amd.com>
    drm/amdgpu: add new MC firmware for Polaris12 32bit ASIC

Christian König <christian.koenig@amd.com>
    drm/amdgpu: fix concurrent VM flushes on Vega/Navi v2

Harry Wentland <harry.wentland@amd.com>
    drm/amd/display: Reject non-zero src_y and src_x for video planes

Paul Cercueil <paul@crapouillou.net>
    drm: bridge/panel: Cleanup connector on bridge detach

Randy Dunlap <rdunlap@infradead.org>
    drm: bridge: fix ANX7625 use of mipi_dsi_() functions

Wayne Lin <Wayne.Lin@amd.com>
    drm/dp_mst: Set CLEAR_PAYLOAD_ID_TABLE as broadcast

Wayne Lin <Wayne.Lin@amd.com>
    drm/dp_mst: Revise broadcast msg lct & lcr

Colin Ian King <colin.king@canonical.com>
    drm/radeon: fix copy of uninitialized variable back to userspace

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Don't try to map pages that are already mapped

Boris Brezillon <boris.brezillon@collabora.com>
    drm/panfrost: Clear MMU irqs before handling the fault

Paul Cercueil <paul@crapouillou.net>
    drm/ingenic: Fix non-OSD mode

Gerd Hoffmann <kraxel@redhat.com>
    drm/qxl: use ttm bo priorities

Maciej W. Rozycki <macro@orcam.me.uk>
    FDDI: defxx: Make MMIO the configuration default except for EISA

Felix Fietkau <nbd@nbd.name>
    mt76: fix potential DMA mapping leak

Ping-Ke Shih <pkshih@realtek.com>
    rtw88: Fix array overrun in rtw_get_tx_power_params()

Johannes Berg <johannes.berg@intel.com>
    cfg80211: scan: drop entry from hidden_list on overflow

Randy Dunlap <rdunlap@infradead.org>
    net: xilinx: drivers need/depend on HAS_IOMEM

Dan Carpenter <dan.carpenter@oracle.com>
    ipw2x00: potential buffer overflow in libipw_wx_set_encodeext()

Ryder Lee <ryder.lee@mediatek.com>
    mt76: mt7615: use ieee80211_free_txskb() in mt7615_tx_token_put()

Nathan Chancellor <nathan@kernel.org>
    MIPS: generic: Update node names to avoid unit addresses

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: Reinstate platform `__div64_32' handler

Jan Glauber <jglauber@digitalocean.com>
    md: Fix missing unused status line of /proc/mdstat

Zhao Heming <heming.zhao@suse.com>
    md: md_open returns -EBUSY when entering racing area

Christoph Hellwig <hch@lst.de>
    md: factor out a mddev_find_locked helper from mddev_find

Christoph Hellwig <hch@lst.de>
    md: split mddev_find

Heming Zhao <heming.zhao@suse.com>
    md-cluster: fix use-after-free issue when removing rdev

Sudhakar Panneerselvam <sudhakar.panneerselvam@oracle.com>
    md/bitmap: wait for external bitmap writes to complete during tear down

Xiao Ni <xni@redhat.com>
    async_xor: increase src_offs when dropping destination page

Alison Schofield <alison.schofield@intel.com>
    x86, sched: Treat Intel SNC topology as default, COD as exception

Paul Moore <paul@paul-moore.com>
    selinux: add proper NULL termination to the secclass_map permissions

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    misc: vmw_vmci: explicitly initialize vmci_datagram payload

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    misc: vmw_vmci: explicitly initialize vmci_notify_bm_set_msg struct

Kishon Vijay Abraham I <kishon@ti.com>
    phy: ti: j721e-wiz: Invoke wiz_init() before of_platform_device_create()

Hans de Goede <hdegoede@redhat.com>
    misc: lis3lv02d: Fix false-positive WARN on various HP models

Kishon Vijay Abraham I <kishon@ti.com>
    phy: cadence: Sierra: Fix PHY power_on sequence

Annaliese McDermond <nh6z@nh6z.net>
    sc16is7xx: Defer probe if device read fails

Ye Xiang <xiang.ye@intel.com>
    iio: hid-sensor-rotation: Fix quaternion data not correct

Gwendal Grignou <gwendal@chromium.org>
    iio: sx9310: Fix access to variable DT array

Linus Walleij <linus.walleij@linaro.org>
    iio: magnetometer: yas530: Fix return value on error path

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:adc:ad7476: Fix remove handling

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:accel:adis16201: Fix wrong axis assignment that prevents loading

Gwendal Grignou <gwendal@chromium.org>
    iio: sx9310: Fix write_.._debounce()

Linus Walleij <linus.walleij@linaro.org>
    iio: magnetometer: yas530: Include right header

Lars-Peter Clausen <lars@metafoo.de>
    iio: inv_mpu6050: Fully validate gyro and accel scale writes

Dmitry Osipenko <digetx@gmail.com>
    soc/tegra: regulators: Fix locking up when voltage-spread is out of range

Lukasz Luba <lukasz.luba@arm.com>
    PM / devfreq: Unlock mutex and free devfreq struct in error path

Kishon Vijay Abraham I <kishon@ti.com>
    PCI: keystone: Let AM65 use the pci_ops defined in pcie-designware-host.c

Dejin Zheng <zhengdejin5@gmail.com>
    PCI: xgene: Fix cfg resource mapping

Sean Christopherson <seanjc@google.com>
    KVM: x86: Defer the MMU unload to the normal path on an global INVPCID

Arun Easi <aeasi@marvell.com>
    PCI: Allow VPD access for QLogic ISP2722

Maciej W. Rozycki <macro@orcam.me.uk>
    FDDI: defxx: Bail out gracefully with unassigned PCI resource for CSR

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
    MIPS: pci-rt2880: fix slot 0 configuration

Ilya Lipnitskiy <ilya.lipnitskiy@gmail.com>
    MIPS: pci-mt7620: fix PLL lock check

Annaliese McDermond <nh6z@nh6z.net>
    ASoC: tlv320aic32x4: Increase maximum register in regmap

Annaliese McDermond <nh6z@nh6z.net>
    ASoC: tlv320aic32x4: Register clocks before registering component

Lukasz Majczak <lma@semihalf.com>
    ASoC: Intel: kbl_da7219_max98927: Fix kabylake_ssp_fixup function

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: samsung: tm2_wm5110: check of of_parse return value

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: improve bandwidth scheduling with TT

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: remove or operator for setting schedule parameters

Johan Hovold <johan@kernel.org>
    USB: serial: xr: fix CSIZE handling

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: update power supply once partner accepts

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Address incorrect values of tcpm psy for pps supply

Badhri Jagan Sridharan <badhri@google.com>
    usb: typec: tcpm: Address incorrect values of tcpm psy for fixed supply

Randy Dunlap <rdunlap@infradead.org>
    drm: bridge: fix LONTIUM use of mipi_dsi_() functions

Johan Hovold <johan@kernel.org>
    tty: mxser: fix TIOCSSERIAL permission check

Johan Hovold <johan@kernel.org>
    staging: fwserial: fix TIOCSSERIAL permission check

Johan Hovold <johan@kernel.org>
    tty: mxser: fix TIOCSSERIAL jiffies conversions

Johan Hovold <johan@kernel.org>
    tty: moxa: fix TIOCSSERIAL permission check

Johan Hovold <johan@kernel.org>
    staging: fwserial: fix TIOCSSERIAL jiffies conversions

Johan Hovold <johan@kernel.org>
    USB: serial: ti_usb_3410_5052: fix TIOCSSERIAL permission check

Johan Hovold <johan@kernel.org>
    staging: greybus: uart: fix TIOCSSERIAL jiffies conversions

Johan Hovold <johan@kernel.org>
    USB: serial: usb_wwan: fix TIOCSSERIAL jiffies conversions

Johan Hovold <johan@kernel.org>
    tty: amiserial: fix TIOCSSERIAL permission check

Johan Hovold <johan@kernel.org>
    tty: moxa: fix TIOCSSERIAL jiffies conversions

Hans de Goede <hdegoede@redhat.com>
    usb: roles: Call try_module_get() from usb_role_switch_find_by_fwnode()

Johan Hovold <johan@kernel.org>
    Revert "USB: cdc-acm: fix rounding error in TIOCSSERIAL"

Heikki Krogerus <heikki.krogerus@linux.intel.com>
    software node: Allow node addition to already existing device

Mike Leach <mike.leach@linaro.org>
    coresight: etm-perf: Fix define build issue when built as module

Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
    io_uring: truncate lengths larger than MAX_RW_COUNT on provide buffers

Or Cohen <orcohen@paloaltonetworks.com>
    net/nfc: fix use-after-free llcp_sock_bind/connect

Lin Ma <linma@zju.edu.cn>
    bluetooth: eliminate the potential race condition when removing the HCI controller

Archie Pusaka <apusaka@chromium.org>
    Bluetooth: verify AMP hci_chan before amp_destroy


-------------

Diffstat:

 Documentation/admin-guide/kernel-parameters.txt    |  15 +-
 .../devicetree/bindings/serial/st,stm32-uart.yaml  |   3 +-
 Documentation/driver-api/xilinx/eemi.rst           |  31 +-
 .../userspace-api/media/v4l/subdev-formats.rst     |   4 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/aspeed-bmc-ibm-rainier.dts       |   4 +-
 arch/arm/boot/dts/exynos4210-i9100.dts             |   2 +-
 arch/arm/boot/dts/exynos4412-midas.dtsi            |   6 +-
 arch/arm/boot/dts/exynos4412-odroid-common.dtsi    |   2 +-
 arch/arm/boot/dts/exynos4412-p4note.dtsi           |   4 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   2 +-
 arch/arm/boot/dts/exynos5250-snow-common.dtsi      |   2 +-
 .../dts/qcom-msm8974-lge-nexus5-hammerhead.dts     |   2 +-
 arch/arm/boot/dts/qcom-msm8974-samsung-klte.dts    |   2 +-
 arch/arm/boot/dts/r8a7790-lager.dts                |   3 +
 arch/arm/boot/dts/r8a7791-koelsch.dts              |   3 +
 arch/arm/boot/dts/r8a7791-porter.dts               |   2 +
 arch/arm/boot/dts/r8a7793-gose.dts                 |   3 +
 arch/arm/boot/dts/r8a7794-alt.dts                  |   3 +
 arch/arm/boot/dts/r8a7794-silk.dts                 |   2 +
 arch/arm/boot/dts/s5pv210-fascinate4g.dts          |   2 +-
 arch/arm/boot/dts/stm32mp15-pinctrl.dtsi           |  21 +-
 arch/arm/boot/dts/uniphier-pxs2.dtsi               |   2 +-
 arch/arm/crypto/blake2s-core.S                     |  21 +
 arch/arm/crypto/poly1305-glue.c                    |   2 +-
 .../broadcom/bcm4908/bcm4908-asus-gt-ac5300.dts    |   1 +
 arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi  |   2 +-
 arch/arm64/boot/dts/mediatek/mt8173-evb.dts        |   2 +-
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |   7 +
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi   |   2 +-
 arch/arm64/boot/dts/qcom/sc7180-trogdor.dtsi       |  35 +-
 arch/arm64/boot/dts/qcom/sdm845-db845c.dts         |   4 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm8150.dtsi               |   2 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |  33 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   4 +-
 arch/arm64/boot/dts/renesas/hihope-common.dtsi     |   3 +
 .../boot/dts/renesas/r8a774a1-beacon-rzg2m-kit.dts |   3 +
 .../boot/dts/renesas/r8a774b1-beacon-rzg2n-kit.dts |   3 +
 arch/arm64/boot/dts/renesas/r8a774c0-cat874.dts    |   2 +
 .../boot/dts/renesas/r8a774e1-beacon-rzg2h-kit.dts |   3 +
 arch/arm64/boot/dts/renesas/r8a77980.dtsi          |  16 +-
 arch/arm64/boot/dts/renesas/r8a77990-ebisu.dts     |   3 +
 arch/arm64/boot/dts/renesas/r8a779a0.dtsi          |   5 +-
 arch/arm64/boot/dts/renesas/salvator-common.dtsi   |   3 +
 arch/arm64/boot/dts/renesas/ulcb-kf.dtsi           |   1 +
 arch/arm64/boot/dts/renesas/ulcb.dtsi              |   2 +
 arch/arm64/boot/dts/socionext/uniphier-ld20.dtsi   |   2 +-
 arch/arm64/boot/dts/socionext/uniphier-pxs3.dtsi   |   4 +-
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi          |  17 +-
 arch/arm64/crypto/aes-modes.S                      |   1 +
 arch/arm64/crypto/poly1305-glue.c                  |   2 +-
 arch/arm64/include/asm/kvm_host.h                  |   1 +
 arch/arm64/kvm/arm.c                               |   6 +-
 arch/arm64/kvm/debug.c                             |  88 ++--
 arch/arm64/kvm/hyp/nvhe/gen-hyprel.c               |  18 +
 arch/arm64/kvm/reset.c                             |   5 +
 arch/arm64/kvm/vgic/vgic-kvm-device.c              |   7 +-
 arch/ia64/kernel/acpi.c                            |   7 +-
 arch/ia64/kernel/efi.c                             |  11 +-
 arch/m68k/include/asm/mvme147hw.h                  |   3 +
 arch/m68k/kernel/sys_m68k.c                        |   2 +
 arch/m68k/mvme147/config.c                         |  14 +-
 arch/m68k/mvme16x/config.c                         |  14 +-
 arch/mips/Kconfig                                  |   1 +
 arch/mips/boot/dts/brcm/bcm3368.dtsi               |   2 +-
 arch/mips/boot/dts/brcm/bcm63268.dtsi              |   2 +-
 arch/mips/boot/dts/brcm/bcm6358.dtsi               |   2 +-
 arch/mips/boot/dts/brcm/bcm6362.dtsi               |   2 +-
 arch/mips/boot/dts/brcm/bcm6368.dtsi               |   2 +-
 arch/mips/crypto/poly1305-glue.c                   |   2 +-
 arch/mips/generic/board-boston.its.S               |  10 +-
 arch/mips/generic/board-jaguar2.its.S              |  16 +-
 arch/mips/generic/board-luton.its.S                |   8 +-
 arch/mips/generic/board-ni169445.its.S             |  10 +-
 arch/mips/generic/board-ocelot.its.S               |  20 +-
 arch/mips/generic/board-serval.its.S               |   8 +-
 arch/mips/generic/board-xilfpga.its.S              |  10 +-
 arch/mips/generic/vmlinux.its.S                    |  10 +-
 arch/mips/include/asm/asmmacro.h                   |   3 +-
 arch/mips/include/asm/div64.h                      |  57 ++-
 arch/mips/loongson64/init.c                        |   2 +-
 arch/mips/pci/pci-legacy.c                         |   9 +-
 arch/mips/pci/pci-mt7620.c                         |   5 +-
 arch/mips/pci/pci-rt2880.c                         |  37 +-
 arch/powerpc/Kconfig                               |   2 +-
 arch/powerpc/Kconfig.debug                         |   1 +
 arch/powerpc/include/asm/book3s/64/pgtable.h       |   4 +-
 arch/powerpc/include/asm/book3s/64/radix.h         |   6 +-
 arch/powerpc/include/asm/fixmap.h                  |   9 +
 arch/powerpc/include/asm/nohash/64/pgtable.h       |   5 +-
 arch/powerpc/include/asm/smp.h                     |   5 +
 arch/powerpc/kernel/fadump.c                       |   2 +-
 arch/powerpc/kernel/interrupt.c                    |   4 +-
 arch/powerpc/kernel/prom.c                         |   2 +-
 arch/powerpc/kernel/smp.c                          |  39 +-
 arch/powerpc/kvm/book3s_hv.c                       |   3 +
 arch/powerpc/mm/book3s64/hash_pgtable.c            |   6 +-
 arch/powerpc/mm/book3s64/hash_utils.c              |   4 +-
 arch/powerpc/mm/book3s64/radix_pgtable.c           |   4 +-
 arch/powerpc/mm/mem.c                              |   2 +-
 arch/powerpc/perf/isa207-common.c                  |   4 +-
 arch/powerpc/perf/power10-events-list.h            |   4 +-
 arch/powerpc/platforms/52xx/lite5200_sleep.S       |   2 +-
 arch/powerpc/platforms/pseries/iommu.c             |   2 +-
 arch/powerpc/platforms/pseries/lpar.c              |   4 +-
 arch/powerpc/platforms/pseries/pci_dlpar.c         |   4 +-
 arch/powerpc/platforms/pseries/vio.c               |   4 +
 arch/powerpc/sysdev/xive/common.c                  |  35 +-
 arch/s390/kernel/setup.c                           |   4 +-
 arch/s390/kvm/gaccess.c                            |  30 +-
 arch/s390/kvm/gaccess.h                            |  60 ++-
 arch/s390/kvm/kvm-s390.c                           |   4 +-
 arch/s390/kvm/vsie.c                               | 109 ++++-
 arch/x86/Kconfig                                   |   1 +
 arch/x86/crypto/poly1305_glue.c                    |   6 +-
 arch/x86/entry/vdso/vdso2c.h                       |   2 +-
 arch/x86/events/amd/iommu.c                        |   6 +-
 arch/x86/events/amd/uncore.c                       |   6 +-
 arch/x86/kernel/apic/x2apic_uv_x.c                 |   3 +
 arch/x86/kernel/cpu/microcode/core.c               |   8 +-
 arch/x86/kernel/e820.c                             |   4 +-
 arch/x86/kernel/kprobes/core.c                     |  23 +-
 arch/x86/kernel/smpboot.c                          |  90 ++--
 arch/x86/kvm/emulate.c                             |  80 +---
 arch/x86/kvm/lapic.c                               |   6 +
 arch/x86/kvm/mmu/mmu.c                             |  63 ++-
 arch/x86/kvm/svm/sev.c                             |  42 +-
 arch/x86/kvm/svm/svm.c                             |  44 +-
 arch/x86/kvm/vmx/nested.c                          |  17 +-
 arch/x86/kvm/vmx/vmx.c                             |  19 +-
 arch/x86/kvm/x86.c                                 |  18 +-
 arch/x86/kvm/xen.c                                 |   2 +-
 arch/x86/power/hibernate.c                         |  89 +---
 crypto/async_tx/async_xor.c                        |   1 +
 drivers/acpi/cppc_acpi.c                           |  14 +-
 drivers/ata/libahci_platform.c                     |   4 +-
 drivers/ata/pata_arasan_cf.c                       |  15 +-
 drivers/ata/pata_ixp4xx_cf.c                       |   6 +-
 drivers/ata/sata_mv.c                              |   4 +
 drivers/base/devtmpfs.c                            |   2 +-
 drivers/base/node.c                                |  26 +-
 drivers/base/regmap/regmap-debugfs.c               |   1 +
 drivers/base/swnode.c                              |   5 +-
 drivers/block/ataflop.c                            |  16 +-
 drivers/block/null_blk/zoned.c                     |   1 +
 drivers/block/rnbd/rnbd-clt-sysfs.c                |   6 +-
 drivers/block/xen-blkback/common.h                 |   1 +
 drivers/block/xen-blkback/xenbus.c                 |  38 +-
 drivers/bus/qcom-ebi2.c                            |   4 +-
 drivers/bus/ti-sysc.c                              |   6 +-
 drivers/char/tpm/tpm_tis_i2c_cr50.c                |   1 +
 drivers/char/ttyprintk.c                           |  11 +
 drivers/clk/clk-ast2600.c                          |   4 +-
 drivers/clk/imx/clk-imx25.c                        |  12 +-
 drivers/clk/imx/clk-imx27.c                        |  13 +-
 drivers/clk/imx/clk-imx35.c                        |  10 +-
 drivers/clk/imx/clk-imx5.c                         |  30 +-
 drivers/clk/imx/clk-imx6q.c                        |  16 +-
 drivers/clk/imx/clk-imx6sl.c                       |  16 +-
 drivers/clk/imx/clk-imx6sll.c                      |  24 +-
 drivers/clk/imx/clk-imx6sx.c                       |  16 +-
 drivers/clk/imx/clk-imx7d.c                        |  22 +-
 drivers/clk/imx/clk-imx7ulp.c                      |  31 +-
 drivers/clk/imx/clk-imx8mm.c                       |  18 +-
 drivers/clk/imx/clk-imx8mn.c                       |  18 +-
 drivers/clk/imx/clk-imx8mp.c                       |  17 +-
 drivers/clk/imx/clk-imx8mq.c                       |  18 +-
 drivers/clk/imx/clk.c                              |  41 +-
 drivers/clk/imx/clk.h                              |   4 +-
 drivers/clk/mvebu/armada-37xx-periph.c             |  83 ++--
 drivers/clk/qcom/a53-pll.c                         |   1 +
 drivers/clk/qcom/a7-pll.c                          |   1 +
 drivers/clk/qcom/apss-ipq-pll.c                    |   1 +
 drivers/clk/uniphier/clk-uniphier-mux.c            |   4 +-
 drivers/clk/zynqmp/pll.c                           |  24 +-
 drivers/clocksource/ingenic-ost.c                  |   4 +-
 drivers/clocksource/timer-ti-dm-systimer.c         |  13 +-
 drivers/cpufreq/armada-37xx-cpufreq.c              |  76 +++-
 drivers/cpuidle/Kconfig.arm                        |   2 +-
 drivers/crypto/allwinner/Kconfig                   |  14 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-hash.c  |   9 +-
 drivers/crypto/allwinner/sun8i-ss/sun8i-ss-prng.c  |   4 +-
 drivers/crypto/ccp/sev-dev.c                       |   3 +
 drivers/crypto/ccp/tee-dev.c                       |  49 +-
 drivers/crypto/ccp/tee-dev.h                       |  20 +-
 drivers/crypto/chelsio/chcr_algo.c                 |  19 +-
 drivers/crypto/keembay/keembay-ocs-aes-core.c      |   4 +-
 drivers/crypto/keembay/keembay-ocs-hcu-core.c      |   4 +-
 drivers/crypto/qat/qat_c3xxxvf/adf_drv.c           |   4 +-
 drivers/crypto/qat/qat_c62xvf/adf_drv.c            |   4 +-
 drivers/crypto/qat/qat_common/adf_isr.c            |  29 +-
 drivers/crypto/qat/qat_common/adf_transport.c      |   1 +
 drivers/crypto/qat/qat_common/adf_vf_isr.c         |  17 +-
 drivers/crypto/qat/qat_dh895xccvf/adf_drv.c        |   4 +-
 drivers/crypto/sa2ul.c                             |   8 +-
 drivers/devfreq/devfreq.c                          |   5 +-
 drivers/firmware/Kconfig                           |   1 +
 drivers/firmware/qcom_scm-smc.c                    |  12 +-
 drivers/firmware/qcom_scm.c                        |  88 ++--
 drivers/firmware/qcom_scm.h                        |   7 +-
 drivers/firmware/xilinx/zynqmp.c                   |   5 +-
 drivers/fpga/xilinx-spi.c                          |  24 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ids.c            |  19 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_pmu.c            |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.c             |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vm.h             |   1 +
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c              |  13 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |   4 +
 drivers/gpu/drm/amd/amdkfd/kfd_iommu.c             |   6 +
 drivers/gpu/drm/amd/amdkfd/kfd_iommu.h             |   9 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  20 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link.c      |   1 +
 drivers/gpu/drm/amd/display/dc/dce/dce_abm.c       |   2 +-
 drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c      |   6 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_dccg.c  |   2 +-
 .../gpu/drm/amd/display/dc/dcn20/dcn20_resource.c  |  26 +-
 drivers/gpu/drm/amd/display/dc/hdcp/hdcp_msg.c     |   9 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |   1 +
 drivers/gpu/drm/bridge/Kconfig                     |   3 +
 drivers/gpu/drm/bridge/analogix/Kconfig            |   1 +
 drivers/gpu/drm/bridge/panel.c                     |  12 +
 drivers/gpu/drm/drm_dp_mst_topology.c              |  17 +-
 drivers/gpu/drm/drm_probe_helper.c                 |   7 +-
 drivers/gpu/drm/i915/gvt/gvt.c                     |   8 +-
 drivers/gpu/drm/ingenic/ingenic-drm-drv.c          |  11 +-
 drivers/gpu/drm/mcde/mcde_dsi.c                    |   2 +-
 drivers/gpu/drm/mediatek/mtk_hdmi.c                | 174 +++----
 drivers/gpu/drm/msm/disp/dpu1/dpu_hw_catalog.c     |   2 +-
 drivers/gpu/drm/msm/msm_debugfs.c                  |  14 +-
 drivers/gpu/drm/msm/msm_drv.c                      |   3 +
 drivers/gpu/drm/msm/msm_drv.h                      |   9 +-
 drivers/gpu/drm/msm/msm_gem.c                      |  14 +-
 drivers/gpu/drm/msm/msm_gem.h                      |  12 +-
 drivers/gpu/drm/omapdrm/dss/dsi.c                  |   3 +-
 drivers/gpu/drm/panel/panel-novatek-nt35510.c      |   3 +-
 drivers/gpu/drm/panel/panel-samsung-s6d16d0.c      |   4 +-
 drivers/gpu/drm/panel/panel-samsung-s6e63m0-dsi.c  |   1 -
 drivers/gpu/drm/panel/panel-simple.c               |  11 +-
 drivers/gpu/drm/panel/panel-sony-acx424akp.c       |   3 +-
 drivers/gpu/drm/panfrost/panfrost_mmu.c            |  13 +-
 drivers/gpu/drm/qxl/qxl_cmd.c                      |   2 +-
 drivers/gpu/drm/qxl/qxl_display.c                  |   4 +-
 drivers/gpu/drm/qxl/qxl_drv.c                      |   2 -
 drivers/gpu/drm/qxl/qxl_gem.c                      |   2 +-
 drivers/gpu/drm/qxl/qxl_object.c                   |   5 +-
 drivers/gpu/drm/qxl/qxl_object.h                   |   1 +
 drivers/gpu/drm/qxl/qxl_release.c                  |  18 +-
 drivers/gpu/drm/radeon/radeon_dp_mst.c             |   3 +
 drivers/gpu/drm/radeon/radeon_kms.c                |   1 +
 drivers/gpu/drm/stm/ltdc.c                         |  33 +-
 drivers/gpu/drm/tilcdc/tilcdc_crtc.c               |   9 +
 drivers/gpu/drm/xlnx/zynqmp_dp.c                   |   2 +-
 drivers/hid/hid-ids.h                              |   1 +
 drivers/hid/hid-lenovo.c                           |  47 +-
 drivers/hid/hid-plantronics.c                      |  60 ++-
 drivers/hsi/hsi_core.c                             |   3 +-
 drivers/hv/channel.c                               |   2 +-
 drivers/hv/channel_mgmt.c                          |  30 +-
 drivers/hv/ring_buffer.c                           |   1 -
 drivers/hwmon/pmbus/pxe1610.c                      |   9 +
 drivers/hwtracing/coresight/coresight-etm-perf.c   |   2 +-
 drivers/i2c/busses/i2c-cadence.c                   |   9 +-
 drivers/i2c/busses/i2c-emev2.c                     |   5 +-
 drivers/i2c/busses/i2c-img-scb.c                   |   4 +-
 drivers/i2c/busses/i2c-imx-lpi2c.c                 |   2 +-
 drivers/i2c/busses/i2c-imx.c                       |   4 +-
 drivers/i2c/busses/i2c-jz4780.c                    |   5 +-
 drivers/i2c/busses/i2c-mlxbf.c                     |   2 +
 drivers/i2c/busses/i2c-mt65xx.c                    |   2 +-
 drivers/i2c/busses/i2c-omap.c                      |   8 +-
 drivers/i2c/busses/i2c-rcar.c                      |   5 +-
 drivers/i2c/busses/i2c-sh7760.c                    |   5 +-
 drivers/i2c/busses/i2c-sprd.c                      |   4 +-
 drivers/i2c/busses/i2c-stm32f7.c                   |  12 +-
 drivers/i2c/busses/i2c-xiic.c                      |   4 +-
 drivers/i3c/master.c                               |   5 +-
 drivers/iio/accel/adis16201.c                      |   2 +-
 drivers/iio/adc/Kconfig                            |   2 +-
 drivers/iio/adc/ad7476.c                           |  18 +-
 drivers/iio/imu/adis16480.c                        | 128 ++++--
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c         |  20 +-
 drivers/iio/magnetometer/yamaha-yas530.c           |   4 +-
 drivers/iio/orientation/hid-sensor-rotation.c      |  13 +-
 drivers/iio/proximity/sx9310.c                     |  52 ++-
 drivers/infiniband/core/cm.c                       |   3 +-
 drivers/infiniband/core/cma.c                      |  12 +-
 drivers/infiniband/hw/bnxt_re/qplib_fp.c           |   1 +
 drivers/infiniband/hw/bnxt_re/qplib_res.c          |   1 +
 drivers/infiniband/hw/cxgb4/resource.c             |   2 +-
 drivers/infiniband/hw/hfi1/firmware.c              |   1 +
 drivers/infiniband/hw/hfi1/mmu_rb.c                |   2 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   1 +
 drivers/infiniband/hw/i40iw/i40iw_pble.c           |   6 +-
 drivers/infiniband/hw/mlx5/fs.c                    |   9 +-
 drivers/infiniband/hw/mlx5/main.c                  |   6 +-
 drivers/infiniband/hw/mlx5/mlx5_ib.h               | 103 +++--
 drivers/infiniband/hw/mlx5/mr.c                    |  14 +-
 drivers/infiniband/hw/mlx5/odp.c                   |   1 -
 drivers/infiniband/hw/mlx5/qp.c                    |  15 +-
 drivers/infiniband/hw/qedr/qedr_iw_cm.c            |   4 +-
 drivers/infiniband/sw/rxe/rxe_av.c                 |   2 +-
 drivers/infiniband/sw/siw/siw_mem.c                |   4 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  16 +-
 drivers/infiniband/ulp/rtrs/rtrs-clt.c             |   2 +-
 drivers/infiniband/ulp/srpt/ib_srpt.c              |   1 +
 drivers/iommu/amd/init.c                           |   2 +-
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.h        |   2 +-
 drivers/iommu/dma-iommu.c                          |  13 +-
 drivers/iommu/intel/iommu.c                        |  38 +-
 drivers/iommu/intel/irq_remapping.c                |   2 +-
 drivers/iommu/intel/pasid.c                        |  16 +
 drivers/iommu/intel/pasid.h                        |   1 +
 drivers/iommu/intel/svm.c                          |  18 +-
 drivers/iommu/iommu.c                              |  24 +-
 drivers/iommu/mtk_iommu.c                          |  19 +-
 drivers/irqchip/irq-gic-v3-mbi.c                   |   2 +-
 drivers/mailbox/sprd-mailbox.c                     |  43 +-
 drivers/md/bcache/writeback.c                      |   6 +-
 drivers/md/md-bitmap.c                             |   2 +
 drivers/md/md.c                                    |  73 +--
 drivers/media/common/saa7146/saa7146_core.c        |   2 +-
 drivers/media/common/saa7146/saa7146_video.c       |   3 +-
 drivers/media/dvb-frontends/m88ds3103.c            |   4 +-
 drivers/media/i2c/ccs/ccs-core.c                   |   4 +-
 drivers/media/i2c/imx219.c                         |  49 +-
 drivers/media/i2c/rdacm21.c                        |   2 +-
 drivers/media/pci/intel/ipu3/ipu3-cio2-main.c      |   2 +-
 drivers/media/pci/saa7134/saa7134-core.c           |   2 +-
 drivers/media/platform/Kconfig                     |   3 +
 drivers/media/platform/aspeed-video.c              |   9 +-
 drivers/media/platform/meson/ge2d/ge2d.c           |   4 +-
 drivers/media/platform/qcom/venus/core.c           |   7 +-
 .../platform/rockchip/rkisp1/rkisp1-resizer.c      |   9 +-
 .../media/platform/sunxi/sun6i-csi/sun6i_video.c   |   4 +-
 drivers/media/test-drivers/vivid/vivid-vid-out.c   |   2 +-
 drivers/media/tuners/m88rs6000t.c                  |   6 +-
 drivers/media/v4l2-core/v4l2-ctrls.c               |  17 +-
 drivers/memory/omap-gpmc.c                         |   7 +-
 drivers/memory/pl353-smc.c                         |   2 +-
 drivers/memory/renesas-rpc-if.c                    |   2 +-
 drivers/memory/samsung/exynos5422-dmc.c            |   4 +-
 drivers/mfd/intel_pmt.c                            |  11 +-
 drivers/mfd/stm32-timers.c                         |   7 +-
 drivers/mfd/stmpe.c                                |  14 +-
 drivers/misc/lis3lv02d/lis3lv02d.c                 |  21 +-
 drivers/misc/vmw_vmci/vmci_doorbell.c              |   2 +-
 drivers/misc/vmw_vmci/vmci_guest.c                 |   2 +-
 drivers/mtd/maps/physmap-core.c                    |   4 +-
 drivers/mtd/mtdchar.c                              |   8 +-
 drivers/mtd/mtdcore.c                              |   3 +
 drivers/mtd/mtdpart.c                              |   2 +-
 drivers/mtd/nand/raw/brcmnand/brcmnand.c           |   6 +
 drivers/mtd/nand/raw/fsmc_nand.c                   |   2 +
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |   2 +-
 drivers/mtd/nand/raw/qcom_nandc.c                  |   7 +-
 drivers/mtd/parsers/qcomsmempart.c                 |   9 +-
 drivers/net/dsa/bcm_sf2.c                          |  58 ++-
 drivers/net/dsa/bcm_sf2_regs.h                     |   3 +-
 drivers/net/dsa/mv88e6xxx/devlink.c                |   2 +-
 drivers/net/dsa/mv88e6xxx/serdes.c                 |   6 +-
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  10 +-
 .../net/ethernet/cavium/liquidio/cn23xx_pf_regs.h  |   2 +-
 drivers/net/ethernet/cavium/thunder/nicvf_queues.c |   2 +-
 drivers/net/ethernet/chelsio/cxgb4/cxgb4_filter.c  |  22 +-
 drivers/net/ethernet/freescale/Makefile            |   4 +-
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    |   3 +-
 .../net/ethernet/marvell/prestera/prestera_main.c  |   3 +-
 .../net/ethernet/mellanox/mlx5/core/fpga/ipsec.c   |   2 +-
 .../mellanox/mlx5/core/steering/dr_ste_v1.c        |   1 +
 drivers/net/ethernet/netronome/nfp/nfp_devlink.c   |   1 +
 drivers/net/ethernet/qualcomm/emac/emac-mac.c      |   4 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  35 +-
 drivers/net/ethernet/sfc/ef10.c                    |   3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  12 +-
 drivers/net/ethernet/ti/davinci_emac.c             |   4 +-
 drivers/net/ethernet/xilinx/Kconfig                |   3 +
 drivers/net/ethernet/xscale/ixp4xx_eth.c           |   5 +-
 drivers/net/fddi/Kconfig                           |  15 +-
 drivers/net/fddi/defxx.c                           |  47 +-
 drivers/net/geneve.c                               |   4 +-
 drivers/net/phy/intel-xway.c                       |  21 +
 drivers/net/phy/marvell.c                          |  52 ++-
 drivers/net/phy/smsc.c                             |   7 +-
 drivers/net/wan/hdlc_fr.c                          |   5 +-
 drivers/net/wan/lapbether.c                        |  32 +-
 drivers/net/wireless/ath/ath10k/htc.c              |   2 +-
 drivers/net/wireless/ath/ath10k/wmi-tlv.c          |   3 +
 drivers/net/wireless/ath/ath9k/htc_drv_init.c      |   2 +-
 drivers/net/wireless/ath/ath9k/hw.c                |   2 +-
 drivers/net/wireless/intel/ipw2x00/libipw_wx.c     |   6 +-
 drivers/net/wireless/intel/iwlwifi/iwl-dbg-tlv.c   |   5 +-
 drivers/net/wireless/intel/iwlwifi/mvm/rs-fw.c     |  20 +-
 drivers/net/wireless/marvell/mwl8k.c               |   1 +
 drivers/net/wireless/mediatek/mt76/dma.c           |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mac.c    |  56 +--
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |  28 +-
 drivers/net/wireless/mediatek/mt76/mt7615/mt7615.h |  10 +-
 .../net/wireless/mediatek/mt76/mt7615/pci_init.c   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7615/regs.h   |   7 +-
 .../net/wireless/mediatek/mt76/mt7615/sdio_txrx.c  |  11 +-
 .../net/wireless/mediatek/mt76/mt7615/usb_sdio.c   |   7 +-
 .../net/wireless/mediatek/mt76/mt76_connac_mcu.c   |   6 +-
 .../net/wireless/mediatek/mt76/mt7915/debugfs.c    |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7915/init.c   |   3 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mac.c    |  52 +--
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |  11 +-
 drivers/net/wireless/mediatek/mt76/mt7915/mcu.c    |  85 ++--
 drivers/net/wireless/mediatek/mt76/mt7915/mt7915.h |  10 +-
 .../net/wireless/mediatek/mt76/mt7921/debugfs.c    |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    | 192 ++++----
 drivers/net/wireless/mediatek/mt76/mt7921/mac.h    |  10 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |  11 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  44 ++
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |  13 +-
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |  26 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |  27 +-
 drivers/net/wireless/mediatek/mt76/sdio.c          |   3 +
 drivers/net/wireless/mediatek/mt76/tx.c            |  15 +-
 drivers/net/wireless/mediatek/mt7601u/eeprom.c     |   2 +-
 drivers/net/wireless/microchip/wilc1000/sdio.c     |   2 +-
 .../net/wireless/realtek/rtlwifi/rtl8821ae/table.c | 500 +++++++++++++++------
 drivers/net/wireless/realtek/rtw88/debug.c         |   2 +-
 drivers/net/wireless/realtek/rtw88/pci.c           |  19 +-
 drivers/net/wireless/realtek/rtw88/pci.h           |   1 +
 drivers/net/wireless/realtek/rtw88/phy.c           |   5 +-
 drivers/net/wireless/ti/wlcore/boot.c              |  13 +-
 drivers/net/wireless/ti/wlcore/debugfs.h           |   7 +-
 drivers/nfc/pn533/pn533.c                          |   3 +
 drivers/nvme/host/multipath.c                      |   4 +
 drivers/nvme/host/pci.c                            |   2 +-
 drivers/nvme/host/tcp.c                            |   4 +-
 drivers/nvme/target/tcp.c                          |  43 +-
 drivers/nvmem/Kconfig                              |   1 +
 drivers/nvmem/qfprom.c                             |  21 +
 drivers/of/overlay.c                               |   1 +
 drivers/pci/controller/dwc/pci-keystone.c          |   3 +-
 drivers/pci/controller/pci-xgene.c                 |   3 +-
 drivers/pci/vpd.c                                  |   1 -
 drivers/phy/cadence/phy-cadence-sierra.c           |   7 +-
 drivers/phy/ingenic/phy-ingenic-usb.c              |   4 +-
 drivers/phy/marvell/Kconfig                        |   4 +-
 drivers/phy/ralink/phy-mt7621-pci.c                |   6 +-
 drivers/phy/ti/phy-j721e-wiz.c                     |  23 +-
 drivers/pinctrl/pinctrl-at91-pio4.c                |   8 +-
 drivers/pinctrl/pinctrl-single.c                   |  63 +--
 drivers/platform/surface/aggregator/controller.c   |   2 +-
 drivers/platform/x86/dell/dell-wmi-sysman/sysman.c |  32 +-
 drivers/platform/x86/pmc_atom.c                    |  28 +-
 drivers/power/supply/bq25980_charger.c             |  40 +-
 drivers/power/supply/bq27xxx_battery.c             |   2 +-
 drivers/regulator/bd9576-regulator.c               |  11 +-
 drivers/scsi/hisi_sas/hisi_sas_v1_hw.c             |   6 +-
 drivers/scsi/ibmvscsi/ibmvfc.c                     |  57 ++-
 drivers/scsi/jazz_esp.c                            |   4 +-
 drivers/scsi/lpfc/lpfc_els.c                       |  50 +--
 drivers/scsi/pm8001/pm8001_hwi.c                   |   2 +-
 drivers/scsi/pm8001/pm80xx_hwi.c                   |   4 +-
 drivers/scsi/qla2xxx/qla_bsg.c                     |   4 +
 drivers/scsi/sni_53c710.c                          |   5 +-
 drivers/scsi/sun3x_esp.c                           |   4 +-
 drivers/scsi/ufs/ufshcd-pltfrm.c                   |   2 +-
 drivers/soc/aspeed/aspeed-lpc-snoop.c              |   4 +-
 drivers/soc/mediatek/mtk-pm-domains.c              |   5 +-
 drivers/soc/qcom/mdt_loader.c                      |  17 +
 drivers/soc/qcom/pdr_interface.c                   |   2 +-
 drivers/soc/tegra/regulators-tegra30.c             |   2 +-
 drivers/soundwire/bus.c                            |   3 +-
 drivers/soundwire/stream.c                         |  10 +-
 drivers/spi/spi-fsl-lpspi.c                        |   2 +-
 drivers/spi/spi-fsl-spi.c                          |  23 +-
 drivers/spi/spi-rockchip.c                         |  13 +-
 drivers/spi/spi-stm32.c                            |  27 +-
 drivers/spi/spi-zynqmp-gqspi.c                     | 168 ++++---
 drivers/spi/spi.c                                  |   9 +-
 .../staging/comedi/drivers/tests/ni_routes_test.c  |   6 +-
 drivers/staging/fwserial/fwserial.c                |  19 +-
 drivers/staging/greybus/uart.c                     |  13 +-
 drivers/staging/media/atomisp/i2c/atomisp-lm3554.c |  19 +-
 drivers/staging/media/atomisp/pci/atomisp_ioctl.c  |   4 +-
 drivers/staging/media/atomisp/pci/hmm/hmm_bo.c     |  13 +-
 drivers/staging/media/omap4iss/iss.c               |   4 +-
 drivers/staging/media/rkvdec/rkvdec.c              |  48 +-
 drivers/staging/media/rkvdec/rkvdec.h              |   1 -
 drivers/staging/media/sunxi/cedrus/cedrus_regs.h   |  17 +-
 drivers/staging/qlge/qlge_main.c                   |   6 +-
 drivers/staging/rtl8192u/r8192U_core.c             |   2 +-
 drivers/tty/amiserial.c                            |   1 +
 drivers/tty/moxa.c                                 |  18 +-
 drivers/tty/mxser.c                                |  31 +-
 drivers/tty/serial/liteuart.c                      |   4 +-
 drivers/tty/serial/omap-serial.c                   |  51 ++-
 drivers/tty/serial/sc16is7xx.c                     |   2 +-
 drivers/tty/serial/serial_core.c                   |   6 +-
 drivers/tty/serial/stm32-usart.c                   | 184 +++++---
 drivers/tty/serial/stm32-usart.h                   |   3 -
 drivers/tty/tty_io.c                               |  10 +-
 drivers/tty/tty_ioctl.c                            |   4 +-
 drivers/usb/cdns3/cdnsp-gadget.c                   |  17 +-
 drivers/usb/cdns3/cdnsp-gadget.h                   |   1 +
 drivers/usb/class/cdc-acm.c                        |  16 +-
 drivers/usb/dwc2/core_intr.c                       | 154 ++++---
 drivers/usb/dwc2/hcd.c                             |  10 +-
 drivers/usb/gadget/udc/aspeed-vhub/core.c          |   3 +-
 drivers/usb/gadget/udc/aspeed-vhub/epn.c           |   2 +-
 drivers/usb/gadget/udc/fotg210-udc.c               |  26 +-
 drivers/usb/gadget/udc/pch_udc.c                   | 123 +++--
 drivers/usb/gadget/udc/r8a66597-udc.c              |   2 +
 drivers/usb/gadget/udc/s3c2410_udc.c               |  24 +-
 drivers/usb/gadget/udc/snps_udc_plat.c             |   4 +-
 drivers/usb/host/Kconfig                           |   1 +
 drivers/usb/host/xhci-mtk-sch.c                    |  80 +++-
 drivers/usb/host/xhci-mtk.h                        |   6 +-
 drivers/usb/roles/class.c                          |   2 +
 drivers/usb/serial/ti_usb_3410_5052.c              |   9 +-
 drivers/usb/serial/usb_wwan.c                      |   9 +-
 drivers/usb/serial/xr_serial.c                     |   5 +
 drivers/usb/typec/stusb160x.c                      |   4 +-
 drivers/usb/typec/tcpm/tcpci.c                     |  21 +-
 drivers/usb/typec/tcpm/tcpm.c                      | 197 +++++---
 drivers/usb/typec/tps6598x.c                       |   4 +-
 drivers/usb/usbip/vudc_sysfs.c                     |   2 +
 drivers/vfio/fsl-mc/vfio_fsl_mc.c                  |  74 +--
 drivers/vfio/mdev/mdev_sysfs.c                     |   2 +-
 drivers/vfio/pci/vfio_pci.c                        | 131 ++++--
 fs/afs/dir.c                                       |   7 +
 fs/afs/dir_silly.c                                 |   3 +
 fs/afs/fs_operation.c                              |   6 +
 fs/afs/inode.c                                     |  12 +-
 fs/afs/internal.h                                  |   2 +
 fs/afs/write.c                                     |   1 +
 fs/btrfs/tree-log.c                                |  12 +-
 fs/btrfs/volumes.c                                 |   2 +
 fs/dlm/lowcomms.c                                  |   1 +
 fs/fuse/dev.c                                      |   7 +-
 fs/io_uring.c                                      |  14 +-
 fs/nfsd/nfs4proc.c                                 |   4 +-
 fs/overlayfs/copy_up.c                             |   3 +-
 fs/overlayfs/overlayfs.h                           |  30 +-
 fs/overlayfs/readdir.c                             |  12 -
 fs/overlayfs/super.c                               |   2 +
 fs/overlayfs/util.c                                |  31 +-
 fs/proc/array.c                                    |   2 +
 fs/xfs/libxfs/xfs_attr.c                           |   1 +
 include/crypto/internal/poly1305.h                 |   3 +-
 include/crypto/poly1305.h                          |   6 +-
 include/keys/trusted-type.h                        |   1 +
 include/linux/dma-iommu.h                          |   2 +
 include/linux/firmware/xlnx-zynqmp.h               |   5 -
 include/linux/gpio/driver.h                        |   9 +
 include/linux/hid.h                                |   2 +
 include/linux/intel-iommu.h                        |   1 +
 include/linux/iommu.h                              |   2 +-
 include/linux/kvm_host.h                           |   4 +-
 include/linux/mlx5/driver.h                        |   2 +-
 include/linux/platform_device.h                    |   3 +
 include/linux/pm_runtime.h                         |   2 +-
 include/linux/smp.h                                |   2 +-
 include/linux/spi/spi.h                            |   3 +
 include/linux/tty_driver.h                         |   2 +-
 include/linux/udp.h                                |  16 +-
 include/linux/usb/pd.h                             |   2 +
 include/net/addrconf.h                             |   1 -
 include/net/bluetooth/hci_core.h                   |   1 +
 include/net/netfilter/nf_tables_offload.h          |  12 +-
 include/uapi/linux/tty_flags.h                     |   4 +-
 init/init_task.c                                   |   2 +-
 kernel/bpf/ringbuf.c                               |  24 +-
 kernel/bpf/verifier.c                              |  30 +-
 kernel/kthread.c                                   |  33 +-
 kernel/printk/printk.c                             |   9 +-
 kernel/rcu/tree.c                                  |   1 -
 kernel/sched/core.c                                |   2 +-
 kernel/sched/debug.c                               |  42 +-
 kernel/sched/fair.c                                |   5 +-
 kernel/sched/sched.h                               |   7 +
 kernel/smp.c                                       |  20 +-
 kernel/up.c                                        |   2 +-
 lib/bug.c                                          |  33 +-
 lib/crypto/poly1305-donna32.c                      |   3 +-
 lib/crypto/poly1305-donna64.c                      |   3 +-
 lib/crypto/poly1305.c                              |   3 +-
 mm/memcontrol.c                                    |  10 +-
 mm/memory-failure.c                                |   2 +-
 mm/slub.c                                          |   9 +
 mm/sparse.c                                        |   1 +
 net/bluetooth/hci_conn.c                           |   4 -
 net/bluetooth/hci_event.c                          |   3 +-
 net/bluetooth/hci_request.c                        |  12 +-
 net/bridge/br_multicast.c                          |  33 +-
 net/core/dev.c                                     |  14 +-
 net/ipv4/route.c                                   |  42 +-
 net/ipv4/tcp_cong.c                                |   4 +
 net/ipv4/udp.c                                     |   3 +
 net/ipv4/udp_offload.c                             |  19 +-
 net/ipv6/mcast_snoop.c                             |  12 +-
 net/mac80211/main.c                                |   7 +-
 net/mptcp/protocol.c                               |  29 +-
 net/netfilter/nf_tables_offload.c                  |  44 ++
 net/netfilter/nft_cmp.c                            |  41 +-
 net/netfilter/nft_payload.c                        |  13 +-
 net/nfc/digital_dep.c                              |   2 +
 net/nfc/llcp_sock.c                                |   4 +
 net/packet/af_packet.c                             |  15 +-
 net/packet/internal.h                              |   2 +-
 net/sched/act_ct.c                                 |   6 +-
 net/sctp/socket.c                                  |  38 +-
 net/tipc/crypto.c                                  |   2 +
 net/vmw_vsock/virtio_transport_common.c            |  28 +-
 net/vmw_vsock/vmci_transport.c                     |   3 +-
 net/wireless/scan.c                                |   2 +
 net/xdp/xsk.c                                      |   8 +-
 samples/kfifo/bytestream-example.c                 |   8 +-
 samples/kfifo/inttype-example.c                    |   8 +-
 samples/kfifo/record-example.c                     |   8 +-
 security/integrity/ima/ima_template.c              |   4 +-
 security/keys/trusted-keys/trusted_tpm1.c          |  32 +-
 security/keys/trusted-keys/trusted_tpm2.c          |  10 +-
 security/selinux/include/classmap.h                |   5 +-
 sound/core/init.c                                  |   2 -
 sound/pci/hda/patch_realtek.c                      | 162 ++++---
 sound/soc/codecs/ak5558.c                          |   4 +-
 sound/soc/codecs/tlv320aic32x4.c                   |  12 +-
 sound/soc/codecs/wm8960.c                          |  12 +-
 sound/soc/generic/audio-graph-card.c               |   2 +-
 sound/soc/generic/simple-card.c                    |   2 +-
 sound/soc/intel/Makefile                           |   2 +-
 sound/soc/intel/boards/kbl_da7219_max98927.c       |  38 +-
 sound/soc/intel/boards/sof_wm8804.c                |   6 +-
 sound/soc/intel/skylake/Makefile                   |   2 +-
 sound/soc/qcom/qdsp6/q6afe-clocks.c                | 209 ++++-----
 sound/soc/qcom/qdsp6/q6afe.c                       |   2 +-
 sound/soc/qcom/qdsp6/q6afe.h                       |   2 +-
 sound/soc/samsung/tm2_wm5110.c                     |   2 +-
 sound/soc/tegra/tegra30_i2s.c                      |  40 +-
 sound/usb/card.c                                   |  14 +-
 sound/usb/midi.c                                   |   2 +-
 sound/usb/quirks.c                                 |  16 +-
 sound/usb/usbaudio.h                               |   2 +
 tools/bpf/bpftool/btf.c                            |   3 +
 tools/bpf/bpftool/main.c                           |   3 +-
 tools/bpf/bpftool/map.c                            |   2 +-
 tools/lib/bpf/bpf_core_read.h                      |  16 +-
 tools/lib/bpf/bpf_tracing.h                        |  40 +-
 tools/lib/bpf/btf.h                                |   1 +
 tools/lib/bpf/libbpf.h                             |   1 +
 tools/lib/perf/include/perf/event.h                |   7 +-
 tools/perf/pmu-events/arch/x86/amdzen1/cache.json  |   2 +-
 .../pmu-events/arch/x86/amdzen1/recommended.json   |   6 +-
 tools/perf/pmu-events/arch/x86/amdzen2/cache.json  |   2 +-
 .../pmu-events/arch/x86/amdzen2/recommended.json   |   6 +-
 tools/perf/trace/beauty/fsconfig.sh                |   7 +-
 tools/perf/util/jitdump.c                          |  30 +-
 tools/perf/util/session.c                          |  15 +-
 tools/perf/util/symbol_fprintf.c                   |   2 +-
 tools/power/x86/turbostat/turbostat.c              |  62 +--
 tools/spi/Makefile                                 |   5 +-
 tools/testing/selftests/bpf/Makefile               |   5 +-
 .../testing/selftests/bpf/prog_tests/core_reloc.c  |  51 ++-
 ...tf__core_reloc_existence___err_wrong_arr_kind.c |   3 -
 ...re_reloc_existence___err_wrong_arr_value_type.c |   3 -
 ...tf__core_reloc_existence___err_wrong_int_kind.c |   3 -
 .../btf__core_reloc_existence___err_wrong_int_sz.c |   3 -
 ...tf__core_reloc_existence___err_wrong_int_type.c |   3 -
 ..._core_reloc_existence___err_wrong_struct_type.c |   3 -
 .../btf__core_reloc_existence___wrong_field_defs.c |   3 +
 .../testing/selftests/bpf/progs/core_reloc_types.h |  20 +-
 .../testing/selftests/bpf/verifier/array_access.c  |   2 +-
 .../selftests/drivers/net/mlxsw/port_scale.sh      |   6 +-
 .../selftests/drivers/net/mlxsw/tc_flower_scale.sh |   6 +-
 tools/testing/selftests/kvm/dirty_log_test.c       |  69 ++-
 tools/testing/selftests/lib.mk                     |   3 +-
 .../net/forwarding/mirror_gre_vlan_bridge_1q.sh    |   2 +-
 tools/testing/selftests/x86/thunks_32.S            |   2 +
 virt/kvm/coalesced_mmio.c                          |  19 +-
 virt/kvm/kvm_main.c                                |  20 +-
 677 files changed, 6153 insertions(+), 3838 deletions(-)


