Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E59B9549E0B
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 21:49:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346242AbiFMTtx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 15:49:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244360AbiFMTtV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 15:49:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACA053FD92;
        Mon, 13 Jun 2022 11:20:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 384FC61244;
        Mon, 13 Jun 2022 18:20:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E36F2C34114;
        Mon, 13 Jun 2022 18:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655144399;
        bh=rD19ajwYdLsgxFAcNug0UsL5eDmTFIYQHOvkeqJX4C4=;
        h=From:To:Cc:Subject:Date:From;
        b=zomBFX2Kocd5mOENYzNig9HCYl4KZi8hDcynN0NrY2YrKcQ7mSOUfLePNe2T+ZSaA
         /ScJ2Bz6SnlIx/LbOnqNj3DSSEgWSTwahYdx2KzTd0cqG+0XqnvBeCWFKiqIhkTByP
         N7TlhyurQfEKCZD9wCREwvi8UFsGna8BwBchMksQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.10 000/173] 5.10.122-rc2 review
Date:   Mon, 13 Jun 2022 20:19:56 +0200
Message-Id: <20220613181850.655683495@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.122-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.10.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.10.122-rc2
X-KernelTest-Deadline: 2022-06-15T18:18+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.10.122 release.
There are 173 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Jun 2022 18:18:23 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.122-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.10.122-rc2

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: add missing callback function to support DMA_INTERRUPT

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    zonefs: fix handling of explicit_open option on mount

Johan Hovold <johan+linaro@kernel.org>
    PCI: qcom: Fix pipe clock imbalance

Pascal Hambourg <pascal@plouf.fr.eu.org>
    md/raid0: Ignore RAID0 layout if the second zone has only one device

Stephen Boyd <swboyd@chromium.org>
    interconnect: Restore sync state by ignoring ipa-virt in provider count

Stephen Boyd <swboyd@chromium.org>
    interconnect: qcom: sc7180: Drop IP0 interconnects

Alexey Kardashevskiy <aik@ozlabs.ru>
    powerpc/mm: Switch obsolete dssall to .long

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/32: Fix overread/overwrite of thread_struct via ptrace

Brian Norris <briannorris@chromium.org>
    drm/atomic: Force bridge self-refresh-exit on CRTC switch

Brian Norris <briannorris@chromium.org>
    drm/bridge: analogix_dp: Support PSR-exit to disable transition

Mathias Nyman <mathias.nyman@linux.intel.com>
    Input: bcm5974 - set missing URB_NO_TRANSFER_DMA_MAP urb flag

Olivier Matz <olivier.matz@6wind.com>
    ixgbe: fix unexpected VLAN Rx in promisc mode on VF

Olivier Matz <olivier.matz@6wind.com>
    ixgbe: fix bcast packets Rx on VF after promisc removal

Martin Faltesek <mfaltesek@google.com>
    nfc: st21nfca: fix incorrect sizing calculations in EVT_TRANSACTION

Martin Faltesek <mfaltesek@google.com>
    nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling

Martin Faltesek <mfaltesek@google.com>
    nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION

Tan Tee Min <tee.min.tan@linux.intel.com>
    net: phy: dp83867: retrigger SGMII AN when link change

Adrian Hunter <adrian.hunter@intel.com>
    mmc: block: Fix CQE recovery reset success

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: libata-transport: fix {dma|pio|xfer}_mode sysfs files

Paulo Alcantara <pc@cjr.nz>
    cifs: fix reconnect on smb3 mount types

Shyam Prasad N <sprasad@microsoft.com>
    cifs: return errors during session setup during reconnects

Cameron Berkenpas <cam@neo-zeon.de>
    ALSA: hda/realtek: Fix for quirk to enable speaker output on the Lenovo Yoga DuetITL 2021

huangwenhui <huangwenhuia@uniontech.com>
    ALSA: hda/conexant - Fix loopback issue with CX20632

Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
    scripts/gdb: change kernel config dumping method

Xie Yongji <xieyongji@bytedance.com>
    vringh: Fix loop descriptors check in the indirect cases

Kees Cook <keescook@chromium.org>
    nodemask: Fix return values to be unsigned

Steve French <stfrench@microsoft.com>
    cifs: version operations for smb20 unneeded when legacy support disabled

Christian Borntraeger <borntraeger@linux.ibm.com>
    s390/gmap: voluntarily schedule during key setting

Yu Kuai <yukuai3@huawei.com>
    nbd: fix io hung while disconnecting device

Yu Kuai <yukuai3@huawei.com>
    nbd: fix race between nbd_alloc_config() and module removal

Yu Kuai <yukuai3@huawei.com>
    nbd: call genl_unregister_family() first in nbd_cleanup()

Peter Zijlstra <peterz@infradead.org>
    jump_label,noinstr: Avoid instrumentation for JUMP_LABEL=n builds

Peter Zijlstra <peterz@infradead.org>
    x86/cpu: Elide KCSAN for cpu_has() and friends

Masahiro Yamada <masahiroy@kernel.org>
    modpost: fix undefined behavior of is_arm_mapping_symbol()

Gong Yuanjun <ruc_gongyuanjun@163.com>
    drm/radeon: fix a possible null pointer dereference

Venky Shankar <vshankar@redhat.com>
    ceph: allow ceph.dir.rctime xattr to be updatable

Michal Kubecek <mkubecek@suse.cz>
    Revert "net: af_key: add check for pfkey_broadcast in function pfkey_process"

Hannes Reinecke <hare@suse.de>
    scsi: myrb: Fix up null pointer access on myrb_cleanup()

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    md: protect md_unregister_thread from reentrancy

Liu Xinpeng <liuxp11@chinatelecom.cn>
    watchdog: wdat_wdt: Stop watchdog when rebooting the system

Hao Luo <haoluo@google.com>
    kernfs: Separate kernfs_pr_cont_buf and rename_lock.

John Ogness <john.ogness@linutronix.de>
    serial: msm_serial: disable interrupts in __msm_console_write()

Wang Cheng <wanngchenng@gmail.com>
    staging: rtl8712: fix uninit-value in r871xu_drv_init()

Wang Cheng <wanngchenng@gmail.com>
    staging: rtl8712: fix uninit-value in usb_read8() and friends

Andre Przywara <andre.przywara@arm.com>
    clocksource/drivers/sp804: Avoid error on multiple instances

bumwoo lee <bw365.lee@samsung.com>
    extcon: Modify extcon device to be created after driver data is set

Shuah Khan <skhan@linuxfoundation.org>
    misc: rtsx: set NULL intfdata when probe fails

Marek Szyprowski <m.szyprowski@samsung.com>
    usb: dwc2: gadget: don't reset gadget's driver->bus

Changbin Du <changbin.du@intel.com>
    sysrq: do not omit current cpu when showing backtrace of all active CPUs

Evan Green <evgreen@chromium.org>
    USB: hcd-pci: Fully suspend across freeze/thaw cycle

Duoming Zhou <duoming@zju.edu.cn>
    drivers: usb: host: Fix deadlock in oxu_bus_suspend()

Duoming Zhou <duoming@zju.edu.cn>
    drivers: tty: serial: Fix deadlock in sa1100_set_termios()

Zhen Ni <nizhen@uniontech.com>
    USB: host: isp116x: check return value after calling platform_get_resource()

Duoming Zhou <duoming@zju.edu.cn>
    drivers: staging: rtl8192e: Fix deadlock in rtllib_beacons_stop()

Duoming Zhou <duoming@zju.edu.cn>
    drivers: staging: rtl8192u: Fix deadlock in ieee80211_beacons_stop()

Huang Guobin <huangguobin4@huawei.com>
    tty: Fix a possible resource leak in icom_probe

Zheyu Ma <zheyuma97@gmail.com>
    tty: synclink_gt: Fix null-pointer-dereference in slgt_clean()

Kees Cook <keescook@chromium.org>
    lkdtm/usercopy: Expand size of "out of frame" object

Miquel Raynal <miquel.raynal@bootlin.com>
    iio: st_sensors: Add a local lock for protecting odr

Xiaoke Wang <xkernel.wang@foxmail.com>
    staging: rtl8712: fix a potential memory leak in r871xu_drv_init()

Xiaoke Wang <xkernel.wang@foxmail.com>
    iio: dummy: iio_simple_dummy: check the return value of kstrdup()

Linus Torvalds <torvalds@linux-foundation.org>
    drm: imx: fix compiler warning with gcc-12

Miaoqian Lin <linmq006@gmail.com>
    net: altera: Fix refcount leak in altera_tse_mdio_create

Willem de Bruijn <willemb@google.com>
    ip_gre: test csum_start instead of transport header

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: fs, fail conflicting actions

Feras Daoud <ferasda@nvidia.com>
    net/mlx5: Rearm the FW tracer after each tracer event

Masahiro Yamada <masahiroy@kernel.org>
    net: ipv6: unexport __init-annotated seg6_hmac_init()

Masahiro Yamada <masahiroy@kernel.org>
    net: xfrm: unexport __init-annotated xfrm4_protocol_init()

Masahiro Yamada <masahiroy@kernel.org>
    net: mdio: unexport __init-annotated mdio_bus_init()

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix the calculation of xdr->end in xdr_get_next_encode_buffer()

Gal Pressman <gal@nvidia.com>
    net/mlx4_en: Fix wrong return value on ioctl EEPROM query failure

Miaoqian Lin <linmq006@gmail.com>
    net: dsa: lantiq_gswip: Fix refcount leak in gswip_gphy_fw_list

Eric Dumazet <edumazet@google.com>
    bpf, arm64: Clear prog->jited_len along prog->jited

Kuniyuki Iwashima <kuniyu@amazon.com>
    af_unix: Fix a data-race in unix_dgram_peer_wake_me().

Masahiro Yamada <masahiroy@kernel.org>
    xen: unexport __init-annotated xen_xlate_map_ballooned_pages()

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: bail out early if hardware offload is not supported

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: memleak flow rule from commit path

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: release new hooks on unsupported flowtable flags

Miaoqian Lin <linmq006@gmail.com>
    ata: pata_octeon_cf: Fix refcount leak in octeon_cf_probe

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: always initialize flowtable hook list in transaction

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/kasan: Force thread size increase with KASAN

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: delete flowtable hooks via transaction list

Florian Westphal <fw@strlen.de>
    netfilter: nat: really support inet nat without l3 address

Kinglong Mee <kinglongmee@gmail.com>
    xprtrdma: treat all calls not a bcall when bc_serv is NULL

Yang Yingliang <yangyingliang@huawei.com>
    video: fbdev: pxa3xx-gcu: release the resources correctly in pxa3xx_gcu_probe/remove()

Saurabh Sengar <ssengar@linux.microsoft.com>
    video: fbdev: hyperv_fb: Allow resolutions with size > 64 MB for Gen1

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Don't hold the layoutget locks across multiple RPC calls

Radhey Shyam Pandey <radhey.shyam.pandey@xilinx.com>
    dmaengine: zynqmp_dma: In struct zynqmp_dma_chan fix desc_size data type

Greg Ungerer <gerg@linux-m68k.org>
    m68knommu: fix undefined reference to `_init_sp'

Greg Ungerer <gerg@linux-m68k.org>
    m68knommu: set ZERO_PAGE() to the allocated zeroed page

Lucas Tanure <tanureal@opensource.cirrus.com>
    i2c: cadence: Increase timeout per message if necessary

Dongliang Mu <mudongliangabcd@gmail.com>
    f2fs: remove WARN_ON in f2fs_is_valid_blkaddr

Yang Yingliang <yangyingliang@huawei.com>
    iommu/arm-smmu-v3: check return value after calling platform_get_resource()

Yang Yingliang <yangyingliang@huawei.com>
    iommu/arm-smmu: fix possible null-ptr-deref in arm_smmu_device_probe()

Mark-PK Tsai <mark-pk.tsai@mediatek.com>
    tracing: Avoid adding tracer option before update_tracer_options

Jun Miao <jun.miao@intel.com>
    tracing: Fix sleeping function called from invalid context on RT kernel

Masami Hiramatsu <mhiramat@kernel.org>
    bootconfig: Make the bootconfig.o as a normal object file

Gong Yuanjun <ruc_gongyuanjun@163.com>
    mips: cpc: Fix refcount leak in mips_cpc_default_phys_base

Dave Jiang <dave.jiang@intel.com>
    dmaengine: idxd: set DMA_INTERRUPT cap bit

Leo Yan <leo.yan@linaro.org>
    perf c2c: Fix sorting in percent_rmt_hitm_cmp()

Saravana Kannan <saravanak@google.com>
    driver core: Fix wait_for_device_probe() & deferred_probe_timeout interaction

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: check attribute length for bearer name

Damien Le Moal <damien.lemoal@opensource.wdc.com>
    scsi: sd: Fix potential NULL pointer dereference

David Howells <dhowells@redhat.com>
    afs: Fix infinite loop found by xfstest generic/676

Haibo Chen <haibo.chen@nxp.com>
    gpio: pca953x: use the correct register address to do regcache sync

Eric Dumazet <edumazet@google.com>
    tcp: tcp_rtx_synack() can be called from process context

Guoju Fang <gjfang@linux.alibaba.com>
    net: sched: add barrier to fix packet stuck problem for lockless qdisc

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Update netdev features after changing XDP state

Changcheng Liu <jerrliu@nvidia.com>
    net/mlx5: correct ECE offset in query qp output

Leon Romanovsky <leon@kernel.org>
    net/mlx5: Don't use already freed action pointer

Íñigo Huguet <ihuguet@redhat.com>
    sfc: fix wrong tx channel offset with efx_separate_tx_channels

Martin Habets <habetsm.xilinx@gmail.com>
    sfc: fix considering that all channels have TX queues

Yu Xiao <yu.xiao@corigine.com>
    nfp: only report pause frame configuration for physical device

Guangguan Wang <guangguan.wang@linux.alibaba.com>
    net/smc: fixes for converting from "struct smc_cdc_tx_pend **" to "struct smc_wr_tx_pend_priv *"

Heinrich Schuchardt <heinrich.schuchardt@canonical.com>
    riscv: read-only pages should not be writable

Menglong Dong <imagedong@tencent.com>
    bpf: Fix probe read error in ___bpf_prog_run()

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: ubi_create_volume: Fix use-after-free when volume creation failed

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: fastmap: Fix high cpu usage of ubi_bgt by making sure wl_pool not empty

Baokun Li <libaokun1@huawei.com>
    jffs2: fix memory leak in jffs2_do_fill_super

Alexander Lobakin <alexandr.lobakin@intel.com>
    modpost: fix removing numeric suffixes

Miaoqian Lin <linmq006@gmail.com>
    net: dsa: mv88e6xxx: Fix refcount leak in mv88e6xxx_mdios_register

Miaoqian Lin <linmq006@gmail.com>
    net: ethernet: ti: am65-cpsw-nuss: Fix some refcount leaks

Dan Carpenter <dan.carpenter@oracle.com>
    net: ethernet: mtk_eth_soc: out of bounds read in mtk_hwlro_get_fdir_entry()

Vincent Ray <vray@kalrayinc.com>
    net: sched: fixed barrier to prevent skbuff sticking in qdisc backlog

Jann Horn <jannh@google.com>
    s390/crypto: fix scatterwalk_unmap() callers in AES-GCM

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    clocksource/drivers/oxnas-rps: Fix irq_of_parse_and_map() return value

Shengjiu Wang <shengjiu.wang@nxp.com>
    ASoC: fsl_sai: Fix FSL_SAI_xDR/xFR definition

Miaoqian Lin <linmq006@gmail.com>
    watchdog: ts4800_wdt: Fix refcount leak in ts4800_wdt_probe

Miaoqian Lin <linmq006@gmail.com>
    watchdog: rti-wdt: Fix pm_runtime_get_sync() error checking

Zhang Wensheng <zhangwensheng5@huawei.com>
    driver core: fix deadlock in __device_attach

Schspa Shi <schspa@gmail.com>
    driver: base: fix UAF when driver_attach failed

Tony Lindgren <tony@atomide.com>
    bus: ti-sysc: Fix warnings for unbind for serial

Miaoqian Lin <linmq006@gmail.com>
    firmware: dmi-sysfs: Fix memory leak in dmi_sysfs_register_handle

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: stm32-usart: Correct CSIZE, bits, and parity

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: st-asc: Sanitize CSIZE and correct PARENB for CS7

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: sifive: Sanitize CSIZE and c_iflag

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: sh-sci: Don't allow CS5-6

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: txx9: Don't allow CS5-6

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: rda-uart: Don't allow CS5-6

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: digicolor-usart: Don't allow CS5-6

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_fintek: Check SER_RS485_RTS_* only with RS485

John Ogness <john.ogness@linutronix.de>
    serial: meson: acquire port->lock in startup()

Yang Yingliang <yangyingliang@huawei.com>
    rtc: mt6397: check return value after calling platform_get_resource()

Samuel Holland <samuel@sholland.org>
    clocksource/drivers/riscv: Events are stopped during CPU suspend

Miaoqian Lin <linmq006@gmail.com>
    soc: rockchip: Fix refcount leak in rockchip_grf_init

Li Jun <jun.li@nxp.com>
    extcon: ptn5150: Add queue work sync before driver release

Guilherme G. Piccoli <gpiccoli@igalia.com>
    coresight: cpu-debug: Replace mutex with mutex_trylock on panic notifier

Maciej W. Rozycki <macro@orcam.me.uk>
    serial: sifive: Report actual baud base rather than fixed 115200

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp: fix pipe-clock imbalance on power-on failure

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    rpmsg: qcom_smd: Fix returning 0 if irq_of_parse_and_map() fails

Cixi Geng <cixi.geng1@unisoc.com>
    iio: adc: sc27xx: Fine tune the scale calibration values

Cixi Geng <cixi.geng1@unisoc.com>
    iio: adc: sc27xx: fix read big scale voltage not right

Miaoqian Lin <linmq006@gmail.com>
    iio: proximity: vl53l0x: Fix return value check of wait_for_completion_timeout

Miaoqian Lin <linmq006@gmail.com>
    iio: adc: stmpe-adc: Fix wait_for_completion_timeout return value check

Bjorn Andersson <bjorn.andersson@linaro.org>
    usb: typec: mux: Check dev_set_name() return value

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    firmware: stratix10-svc: fix a missing check on list iterator

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    misc: fastrpc: fix an incorrect NULL check on list iterator

Zheng Yongjun <zhengyongjun3@huawei.com>
    usb: dwc3: pci: Fix pm_runtime_get_sync() error checking

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    rpmsg: qcom_smd: Fix irq_of_parse_and_map() return value

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: lp3943: Fix duty calculation in case period was clamped

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    staging: fieldbus: Fix the error handling path in anybuss_host_common_probe()

Miaoqian Lin <linmq006@gmail.com>
    usb: musb: Fix missing of_node_put() in omap2430_probe

Lin Ma <linma@zju.edu.cn>
    USB: storage: karma: fix rio_karma_init return

Niels Dossche <dossche.niels@gmail.com>
    usb: usbip: add missing device lock on tweak configuration cmd

Hangyu Hua <hbh25y@gmail.com>
    usb: usbip: fix a refcount leak in stub_probe()

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: fix potential bug when using both of_alias_get_id and ida_simple_get

Daniel Gibson <daniel@gibson.sh>
    tty: n_tty: Restore EOF push handling behavior

Miaoqian Lin <linmq006@gmail.com>
    tty: serial: owl: Fix missing clk_disable_unprepare() in owl_uart_probe

Wang Weiyang <wangweiyang2@huawei.com>
    tty: goldfish: Use tty_port_destroy() to destroy port

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    lkdtm/bugs: Check for the NULL pointer after calling kmalloc

Alexandru Tachici <alexandru.tachici@analog.com>
    iio: adc: ad7124: Remove shift from scan_type

Jakob Koschel <jakobkoschel@gmail.com>
    staging: greybus: codecs: fix type confusion of list iterator variable

Randy Dunlap <rdunlap@infradead.org>
    pcmcia: db1xxx_ss: restrict to MIPS_DB1XXX boards


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-ata                | 11 ++--
 Makefile                                           |  4 +-
 arch/arm64/net/bpf_jit_comp.c                      |  1 +
 arch/m68k/Kconfig.machine                          |  1 +
 arch/m68k/include/asm/pgtable_no.h                 |  3 +-
 arch/mips/kernel/mips-cpc.c                        |  1 +
 arch/powerpc/Kconfig                               |  1 -
 arch/powerpc/include/asm/ppc-opcode.h              |  2 +
 arch/powerpc/include/asm/thread_info.h             | 10 +++-
 arch/powerpc/kernel/idle.c                         |  2 +-
 arch/powerpc/kernel/idle_6xx.S                     |  2 +-
 arch/powerpc/kernel/l2cr_6xx.S                     |  6 +-
 arch/powerpc/kernel/ptrace/ptrace.c                | 21 +++++--
 arch/powerpc/kernel/swsusp_32.S                    |  2 +-
 arch/powerpc/kernel/swsusp_asm64.S                 |  2 +-
 arch/powerpc/mm/mmu_context.c                      |  2 +-
 arch/powerpc/platforms/powermac/cache.S            |  4 +-
 arch/riscv/kernel/efi.c                            |  2 +-
 arch/s390/crypto/aes_s390.c                        |  4 +-
 arch/s390/mm/gmap.c                                | 14 +++++
 arch/x86/include/asm/cpufeature.h                  |  2 +-
 drivers/ata/libata-transport.c                     |  2 +-
 drivers/ata/pata_octeon_cf.c                       |  3 +
 drivers/base/bus.c                                 |  4 +-
 drivers/base/dd.c                                  | 10 ++--
 drivers/block/nbd.c                                | 37 ++++++++----
 drivers/bus/ti-sysc.c                              |  4 +-
 drivers/clocksource/timer-oxnas-rps.c              |  2 +-
 drivers/clocksource/timer-riscv.c                  |  2 +-
 drivers/clocksource/timer-sp804.c                  | 10 ++--
 drivers/dma/idxd/dma.c                             | 23 ++++++++
 drivers/dma/xilinx/zynqmp_dma.c                    |  5 +-
 drivers/extcon/extcon-ptn5150.c                    | 11 ++++
 drivers/extcon/extcon.c                            | 29 +++++----
 drivers/firmware/dmi-sysfs.c                       |  2 +-
 drivers/firmware/stratix10-svc.c                   | 12 ++--
 drivers/gpio/gpio-pca953x.c                        | 19 +++---
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 42 +++++++++++--
 drivers/gpu/drm/drm_atomic_helper.c                | 16 ++++-
 drivers/gpu/drm/imx/ipuv3-crtc.c                   |  2 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |  4 ++
 drivers/hwtracing/coresight/coresight-cpu-debug.c  |  7 ++-
 drivers/i2c/busses/i2c-cadence.c                   | 12 +++-
 drivers/iio/adc/ad7124.c                           |  1 -
 drivers/iio/adc/sc27xx_adc.c                       | 20 +++----
 drivers/iio/adc/stmpe-adc.c                        |  8 +--
 drivers/iio/common/st_sensors/st_sensors_core.c    | 24 ++++++--
 drivers/iio/dummy/iio_simple_dummy.c               | 20 ++++---
 drivers/iio/proximity/vl53l0x-i2c.c                |  7 +--
 drivers/input/mouse/bcm5974.c                      |  7 ++-
 drivers/interconnect/core.c                        |  7 ++-
 drivers/interconnect/qcom/sc7180.c                 | 21 -------
 drivers/iommu/arm/arm-smmu-v3/arm-smmu-v3.c        |  2 +
 drivers/iommu/arm/arm-smmu/arm-smmu.c              |  5 +-
 drivers/md/md.c                                    | 15 +++--
 drivers/md/raid0.c                                 | 31 +++++-----
 drivers/misc/cardreader/rtsx_usb.c                 |  1 +
 drivers/misc/fastrpc.c                             |  9 +--
 drivers/misc/lkdtm/bugs.c                          |  5 ++
 drivers/misc/lkdtm/usercopy.c                      | 17 +++++-
 drivers/mmc/core/block.c                           |  3 +-
 drivers/mtd/ubi/fastmap-wl.c                       | 69 ++++++++++++++--------
 drivers/mtd/ubi/fastmap.c                          | 11 ----
 drivers/mtd/ubi/ubi.h                              |  4 +-
 drivers/mtd/ubi/vmt.c                              |  1 -
 drivers/mtd/ubi/wl.c                               | 19 +++---
 drivers/net/dsa/lantiq_gswip.c                     |  4 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |  1 +
 drivers/net/ethernet/altera/altera_tse_main.c      |  6 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |  8 +--
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  3 +
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |  2 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |  7 ++-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |  5 ++
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  | 35 ++++++++++-
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |  9 ++-
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |  4 +-
 drivers/net/ethernet/sfc/efx_channels.c            |  6 +-
 drivers/net/ethernet/sfc/net_driver.h              |  2 +-
 drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  3 +-
 drivers/net/phy/dp83867.c                          | 29 +++++++++
 drivers/net/phy/mdio_bus.c                         |  1 -
 drivers/nfc/st21nfca/se.c                          | 53 +++++++++--------
 drivers/pci/controller/dwc/pcie-qcom.c             |  6 --
 drivers/pcmcia/Kconfig                             |  2 +-
 drivers/phy/qualcomm/phy-qcom-qmp.c                |  2 +-
 drivers/pwm/pwm-lp3943.c                           |  1 +
 drivers/rpmsg/qcom_smd.c                           |  4 +-
 drivers/rtc/rtc-mt6397.c                           |  2 +
 drivers/scsi/myrb.c                                | 11 +++-
 drivers/scsi/sd.c                                  |  1 -
 drivers/soc/rockchip/grf.c                         |  2 +
 drivers/staging/fieldbus/anybuss/host.c            |  2 +-
 drivers/staging/greybus/audio_codec.c              |  4 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |  2 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |  2 +-
 drivers/staging/rtl8712/os_intfs.c                 |  1 -
 drivers/staging/rtl8712/usb_intf.c                 | 12 ++--
 drivers/staging/rtl8712/usb_ops.c                  | 27 ++++++---
 drivers/tty/goldfish.c                             |  2 +
 drivers/tty/n_tty.c                                | 38 +++++++++++-
 drivers/tty/serial/8250/8250_fintek.c              |  8 +--
 drivers/tty/serial/digicolor-usart.c               |  2 +
 drivers/tty/serial/fsl_lpuart.c                    | 24 ++------
 drivers/tty/serial/icom.c                          |  2 +-
 drivers/tty/serial/meson_uart.c                    | 13 ++++
 drivers/tty/serial/msm_serial.c                    |  5 ++
 drivers/tty/serial/owl-uart.c                      |  1 +
 drivers/tty/serial/rda-uart.c                      |  2 +
 drivers/tty/serial/sa1100.c                        |  4 +-
 drivers/tty/serial/serial_txx9.c                   |  2 +
 drivers/tty/serial/sh-sci.c                        |  6 +-
 drivers/tty/serial/sifive.c                        |  8 ++-
 drivers/tty/serial/st-asc.c                        |  4 ++
 drivers/tty/serial/stm32-usart.c                   | 15 ++++-
 drivers/tty/synclink_gt.c                          |  2 +
 drivers/tty/sysrq.c                                | 13 ++--
 drivers/usb/core/hcd-pci.c                         |  4 +-
 drivers/usb/dwc2/gadget.c                          |  1 -
 drivers/usb/dwc3/dwc3-pci.c                        |  2 +-
 drivers/usb/host/isp116x-hcd.c                     |  6 +-
 drivers/usb/host/oxu210hp-hcd.c                    |  2 +
 drivers/usb/musb/omap2430.c                        |  1 +
 drivers/usb/storage/karma.c                        | 15 ++---
 drivers/usb/typec/mux.c                            | 14 +++--
 drivers/usb/usbip/stub_dev.c                       |  2 +-
 drivers/usb/usbip/stub_rx.c                        |  2 +
 drivers/vhost/vringh.c                             | 10 +++-
 drivers/video/fbdev/hyperv_fb.c                    | 19 +-----
 drivers/video/fbdev/pxa3xx-gcu.c                   | 12 ++--
 drivers/watchdog/rti_wdt.c                         |  2 +-
 drivers/watchdog/ts4800_wdt.c                      |  5 +-
 drivers/watchdog/wdat_wdt.c                        |  1 +
 drivers/xen/xlate_mmu.c                            |  1 -
 fs/afs/dir.c                                       |  5 +-
 fs/ceph/xattr.c                                    | 10 +++-
 fs/cifs/cifsfs.c                                   |  2 +-
 fs/cifs/cifsfs.h                                   |  2 +-
 fs/cifs/cifsglob.h                                 |  4 +-
 fs/cifs/misc.c                                     | 27 +++++----
 fs/cifs/smb2ops.c                                  |  7 ++-
 fs/cifs/smb2pdu.c                                  |  3 +
 fs/f2fs/checkpoint.c                               |  4 +-
 fs/jffs2/fs.c                                      |  1 +
 fs/kernfs/dir.c                                    | 31 ++++++----
 fs/nfs/nfs4proc.c                                  |  4 ++
 fs/zonefs/super.c                                  | 11 ++--
 include/linux/iio/common/st_sensors.h              |  3 +
 include/linux/jump_label.h                         |  4 +-
 include/linux/mlx5/mlx5_ifc.h                      |  5 +-
 include/linux/nodemask.h                           | 38 ++++++------
 include/net/flow_offload.h                         |  1 +
 include/net/netfilter/nf_tables.h                  |  1 -
 include/net/netfilter/nf_tables_offload.h          |  2 +-
 include/net/sch_generic.h                          | 42 +++++--------
 kernel/bpf/core.c                                  | 14 ++---
 kernel/trace/trace.c                               | 13 +++-
 lib/Makefile                                       |  2 +-
 lib/nodemask.c                                     |  4 +-
 net/core/flow_offload.c                            |  6 ++
 net/ipv4/ip_gre.c                                  | 11 ++--
 net/ipv4/tcp_output.c                              |  4 +-
 net/ipv4/xfrm4_protocol.c                          |  1 -
 net/ipv6/seg6_hmac.c                               |  1 -
 net/key/af_key.c                                   | 10 ++--
 net/netfilter/nf_tables_api.c                      | 52 +++++++---------
 net/netfilter/nf_tables_offload.c                  | 23 +++++++-
 net/netfilter/nft_nat.c                            |  3 +-
 net/smc/smc_cdc.c                                  |  2 +-
 net/sunrpc/xdr.c                                   |  6 +-
 net/sunrpc/xprtrdma/rpc_rdma.c                     |  5 ++
 net/tipc/bearer.c                                  |  3 +-
 net/unix/af_unix.c                                 |  2 +-
 scripts/gdb/linux/config.py                        |  6 +-
 scripts/mod/modpost.c                              |  5 +-
 sound/pci/hda/patch_conexant.c                     |  7 +++
 sound/pci/hda/patch_realtek.c                      |  1 +
 sound/soc/fsl/fsl_sai.h                            |  4 +-
 tools/perf/builtin-c2c.c                           |  4 +-
 tools/testing/selftests/netfilter/nft_nat.sh       | 43 ++++++++++++++
 180 files changed, 1044 insertions(+), 566 deletions(-)


