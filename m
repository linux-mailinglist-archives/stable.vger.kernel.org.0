Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0AF9549013
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:25:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244097AbiFMKts (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:49:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348571AbiFMKt2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:49:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D71E02E099;
        Mon, 13 Jun 2022 03:27:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 385BDB80EA5;
        Mon, 13 Jun 2022 10:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0674AC34114;
        Mon, 13 Jun 2022 10:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655116017;
        bh=GmMaRreet5gVLXml0CXpmhFC7BR2xLYbOdzRlmsF1Cs=;
        h=From:To:Cc:Subject:Date:From;
        b=MdudMTN5G8qyGbXOhk4d2A3O3MRnlQhdRY+zIGEovOp2cjevMBSxUiBx2P+Tk8+KS
         HNw7xCxxCGStalLIBkYLNVZshSr0EmcjSFTZ+vPn3XCYvaQPdQLNvrSspUqBOsOx0b
         KX595LBvr3OIyUK6K4o4JdJxutxwiKo06EnPpX5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.4 000/411] 5.4.198-rc1 review
Date:   Mon, 13 Jun 2022 12:04:33 +0200
Message-Id: <20220613094928.482772422@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.198-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.4.198-rc1
X-KernelTest-Deadline: 2022-06-15T09:49+00:00
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

This is the start of the stable review cycle for the 5.4.198 release.
There are 411 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.198-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.4.198-rc1

Tokunori Ikegami <ikegami.t@gmail.com>
    mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N

Pascal Hambourg <pascal@plouf.fr.eu.org>
    md/raid0: Ignore RAID0 layout if the second zone has only one device

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/32: Fix overread/overwrite of thread_struct via ptrace

Mathias Nyman <mathias.nyman@linux.intel.com>
    Input: bcm5974 - set missing URB_NO_TRANSFER_DMA_MAP urb flag

Olivier Matz <olivier.matz@6wind.com>
    ixgbe: fix unexpected VLAN Rx in promisc mode on VF

Olivier Matz <olivier.matz@6wind.com>
    ixgbe: fix bcast packets Rx on VF after promisc removal

Martin Faltesek <mfaltesek@google.com>
    nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling

Martin Faltesek <mfaltesek@google.com>
    nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION

Adrian Hunter <adrian.hunter@intel.com>
    mmc: block: Fix CQE recovery reset success

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: libata-transport: fix {dma|pio|xfer}_mode sysfs files

Shyam Prasad N <sprasad@microsoft.com>
    cifs: return errors during session setup during reconnects

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
    netfilter: nf_tables: memleak flow rule from commit path

Miaoqian Lin <linmq006@gmail.com>
    ata: pata_octeon_cf: Fix refcount leak in octeon_cf_probe

Florian Westphal <fw@strlen.de>
    netfilter: nat: really support inet nat without l3 address

Kinglong Mee <kinglongmee@gmail.com>
    xprtrdma: treat all calls not a bcall when bc_serv is NULL

Yang Yingliang <yangyingliang@huawei.com>
    video: fbdev: pxa3xx-gcu: release the resources correctly in pxa3xx_gcu_probe/remove()

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

Mark-PK Tsai <mark-pk.tsai@mediatek.com>
    tracing: Avoid adding tracer option before update_tracer_options

Jun Miao <jun.miao@intel.com>
    tracing: Fix sleeping function called from invalid context on RT kernel

Gong Yuanjun <ruc_gongyuanjun@163.com>
    mips: cpc: Fix refcount leak in mips_cpc_default_phys_base

Leo Yan <leo.yan@linaro.org>
    perf c2c: Fix sorting in percent_rmt_hitm_cmp()

Hoang Le <hoang.h.le@dektech.com.au>
    tipc: check attribute length for bearer name

David Howells <dhowells@redhat.com>
    afs: Fix infinite loop found by xfstest generic/676

Eric Dumazet <edumazet@google.com>
    tcp: tcp_rtx_synack() can be called from process context

Guoju Fang <gjfang@linux.alibaba.com>
    net: sched: add barrier to fix packet stuck problem for lockless qdisc

Maxim Mikityanskiy <maximmi@nvidia.com>
    net/mlx5e: Update netdev features after changing XDP state

Leon Romanovsky <leonro@nvidia.com>
    net/mlx5: Don't use already freed action pointer

Yu Xiao <yu.xiao@corigine.com>
    nfp: only report pause frame configuration for physical device

Zhihao Cheng <chengzhihao1@huawei.com>
    ubi: ubi_create_volume: Fix use-after-free when volume creation failed

Baokun Li <libaokun1@huawei.com>
    jffs2: fix memory leak in jffs2_do_fill_super

Alexander Lobakin <alexandr.lobakin@intel.com>
    modpost: fix removing numeric suffixes

Miaoqian Lin <linmq006@gmail.com>
    net: dsa: mv88e6xxx: Fix refcount leak in mv88e6xxx_mdios_register

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
    iio: adc: stmpe-adc: Fix wait_for_completion_timeout return value check

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    firmware: stratix10-svc: fix a missing check on list iterator

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

Miaoqian Lin <linmq006@gmail.com>
    tty: serial: owl: Fix missing clk_disable_unprepare() in owl_uart_probe

Wang Weiyang <wangweiyang2@huawei.com>
    tty: goldfish: Use tty_port_destroy() to destroy port

Alexandru Tachici <alexandru.tachici@analog.com>
    iio: adc: ad7124: Remove shift from scan_type

Jakob Koschel <jakobkoschel@gmail.com>
    staging: greybus: codecs: fix type confusion of list iterator variable

Randy Dunlap <rdunlap@infradead.org>
    pcmcia: db1xxx_ss: restrict to MIPS_DB1XXX boards

Jia-Ju Bai <baijiaju1990@gmail.com>
    md: bcache: check the return value of kzalloc() in detached_dev_do_request()

Jan Kara <jack@suse.cz>
    block: fix bio_clone_blkg_association() to associate with proper blkcg_gq

Jan Kara <jack@suse.cz>
    bfq: Make sure bfqg for which we are queueing requests is online

Jan Kara <jack@suse.cz>
    bfq: Get rid of __bio_blkcg() usage

Jan Kara <jack@suse.cz>
    bfq: Remove pointless bfq_init_rq() calls

Jan Kara <jack@suse.cz>
    bfq: Drop pointless unlock-lock pair

Jan Kara <jack@suse.cz>
    bfq: Avoid merging queues with different parents

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: IP27: Remove incorrect `cpu_has_fpu' override

Xiao Yang <yangx.jy@fujitsu.com>
    RDMA/rxe: Generate a completion for unsupported/invalid opcode

Nick Desaulniers <ndesaulniers@google.com>
    Kconfig: add config option for asm goto w/ outputs

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp: fix reset-controller leak on probe errors

Tejun Heo <tj@kernel.org>
    blk-iolatency: Fix inflight count imbalances and IO hangs on offline

Dinh Nguyen <dinguyen@kernel.org>
    dt-bindings: gpio: altera: correct interrupt-cells

Akira Yokosawa <akiyks@gmail.com>
    docs/conf.py: Cope with removal of language=None in Sphinx 5.0.0

Arnd Bergmann <arnd@arndb.de>
    ARM: pxa: maybe fix gpio lookup tables

Johan Hovold <johan+linaro@kernel.org>
    phy: qcom-qmp: fix struct clk leak on probe errors

Kathiravan T <quic_kathirav@quicinc.com>
    arm64: dts: qcom: ipq8074: fix the sleep clock frequency

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    gma500: fix an incorrect NULL check on list iterator

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    tilcdc: tilcdc_external: fix an incorrect NULL check on list iterator

Jiri Slaby <jslaby@suse.cz>
    serial: pch: don't overwrite xmit->buf[0] by x_char

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    carl9170: tx: fix an incorrect use of list iterator

Mark Brown <broonie@kernel.org>
    ASoC: rt5514: Fix event generation for "DSP Voice Wake Up" control

Alexander Wetzel <alexander@wetzel-home.de>
    rtl818x: Prevent using not initialized queues

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: fix huge_pmd_unshare address update

Christophe de Dinechin <dinechin@redhat.com>
    nodemask.h: fix compilation error with GCC12

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    iommu/msm: Fix an incorrect NULL check on list iterator

Vincent Whitchurch <vincent.whitchurch@axis.com>
    um: Fix out-of-bounds read in LDT setup

Johannes Berg <johannes.berg@intel.com>
    um: chan_user: Fix winch_tramp() return value

Felix Fietkau <nbd@nbd.name>
    mac80211: upgrade passive scan to active scan on DFS channels after beacon rx

Max Filippov <jcmvbkbc@gmail.com>
    irqchip: irq-xtensa-mx: fix initial IRQ affinity

Pali Rohár <pali@kernel.org>
    irqchip/armada-370-xp: Do not touch Performance Counter Overflow on A375, A38x, A39x

Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>
    RDMA/hfi1: Fix potential integer multiplication overflow errors

Sean Christopherson <seanjc@google.com>
    Kconfig: Add option for asm goto w/ tied outputs to workaround clang-13 bug

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: coda: Add more H264 levels for CODA960

Nicolas Dufresne <nicolas.dufresne@collabora.com>
    media: coda: Fix reported H264 profile

Tokunori Ikegami <ikegami.t@gmail.com>
    mtd: cfi_cmdset_0002: Move and rename chip_check/chip_ready/chip_good_for_write

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    md: fix an incorrect NULL check in md_reload_sb

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    md: fix an incorrect NULL check in does_sb_need_changing

Brian Norris <briannorris@chromium.org>
    drm/bridge: analogix_dp: Grab runtime PM reference for DP-AUX

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    drm/nouveau/clk: Fix an incorrect NULL check on list iterator

Lucas Stach <l.stach@pengutronix.de>
    drm/etnaviv: check for reaped mapping in etnaviv_iommu_unmap_gem

Dave Airlie <airlied@redhat.com>
    drm/amdgpu/cs: make commands with 0 chunks illegal behaviour.

Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
    scsi: ufs: qcom: Add a readl() to make sure ref_clk gets enabled

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    scsi: dc395x: Fix a missing check on list iterator

Junxiao Bi via Ocfs2-devel <ocfs2-devel@oss.oracle.com>
    ocfs2: dlmfs: fix error handling of user_dlm_destroy_lock

Alexander Aring <aahringo@redhat.com>
    dlm: fix missing lkb refcount handling

Alexander Aring <aahringo@redhat.com>
    dlm: fix plock invalid read

Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>
    mm, compaction: fast_find_migrateblock() should return pfn in the target zone

Johan Hovold <johan+linaro@kernel.org>
    PCI: qcom: Fix unbalanced PHY init on probe errors

Johan Hovold <johan+linaro@kernel.org>
    PCI: qcom: Fix runtime PM imbalance on probe errors

Bjorn Helgaas <bhelgaas@google.com>
    PCI/PM: Fix bridge_d3_blacklist[] Elo i2 overwrite of Gigabyte X299

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    tracing: Fix potential double free in create_var_ref()

Sakari Ailus <sakari.ailus@linux.intel.com>
    ACPI: property: Release subnode properties with data nodes

Jan Kara <jack@suse.cz>
    ext4: avoid cycles in directory h-tree

Jan Kara <jack@suse.cz>
    ext4: verify dir block before splitting it

Ye Bin <yebin10@huawei.com>
    ext4: fix bug_on in ext4_writepages

Ye Bin <yebin10@huawei.com>
    ext4: fix warning in ext4_handle_inode_extension

Ye Bin <yebin10@huawei.com>
    ext4: fix use-after-free in ext4_rename_dir_prepare

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: disallow non-stateful expression in sets earlier

Jan Kara <jack@suse.cz>
    bfq: Track whether bfq_group is still online

Jan Kara <jack@suse.cz>
    bfq: Update cgroup information before merging bio

Jan Kara <jack@suse.cz>
    bfq: Split shared queues on move between cgroups

Aditya Garg <gargaditya08@live.com>
    efi: Do not import certificates from UEFI Secure Boot for T2 Macs

Zhihao Cheng <chengzhihao1@huawei.com>
    fs-writeback: writeback_sb_inodes：Recalculate 'wrote' according skipped pages

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: fix assert 1F04 upon reconfig

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix use-after-free in chanctx code

Chao Yu <chao@kernel.org>
    f2fs: fix fallocate to use file_modified to update permissions consistently

Jaegeuk Kim <jaegeuk@kernel.org>
    f2fs: don't need inode lock for system hidden quota

Chao Yu <chao@kernel.org>
    f2fs: fix deadloop in foreground GC

Chao Yu <chao@kernel.org>
    f2fs: fix to clear dirty inode in f2fs_evict_inode()

Chao Yu <chao@kernel.org>
    f2fs: fix to do sanity check on block address in f2fs_do_zero_range()

Chao Yu <chao@kernel.org>
    f2fs: fix to avoid f2fs_bug_on() in dec_valid_node_count()

Zhengjun Xing <zhengjun.xing@linux.intel.com>
    perf jevents: Fix event syntax error caused by ExtSel

Leo Yan <leo.yan@linaro.org>
    perf c2c: Use stdio interface if slang is not supported

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Increase timeout waiting for GA log enablement

Amelie Delaunay <amelie.delaunay@foss.st.com>
    dmaengine: stm32-mdma: remove GISR1 register

Miaoqian Lin <linmq006@gmail.com>
    video: fbdev: clcdfb: Fix refcount leak in clcdfb_of_vram_setup

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4/pNFS: Do not fail I/O when we fail to allocate the pNFS layout

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Don't report errors from nfs_pageio_complete() more than once

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Do not report flush errors in nfs_write_end()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Do not report EINTR/ERESTARTSYS as mapping errors

Nathan Chancellor <nathan@kernel.org>
    i2c: at91: Initialize dma_buf in at91_twi_xfer()

Michael Walle <michael@walle.cc>
    i2c: at91: use dma safe buffers

Yong Wu <yong.wu@mediatek.com>
    iommu/mediatek: Add list_del in mtk_iommu_remove

Jakob Koschel <jakobkoschel@gmail.com>
    f2fs: fix dereference of stale list iterator after loop body

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    Input: stmfts - do not leave device disabled in stmfts_input_open

Douglas Miller <doug.miller@cornelisnetworks.com>
    RDMA/hfi1: Prevent use of lock before it is initialized

Björn Ardö <bjorn.ardo@axis.com>
    mailbox: forward the hrtimer if not queued and under a lock

Yang Yingliang <yangyingliang@huawei.com>
    mfd: davinci_voicecodec: Fix possible null-ptr-deref davinci_vc_probe()

Miaoqian Lin <linmq006@gmail.com>
    powerpc/fsl_rio: Fix refcount leak in fsl_rio_setup

Randy Dunlap <rdunlap@infradead.org>
    macintosh: via-pmu and via-cuda need RTC_LIB

Kajol Jain <kjain@linux.ibm.com>
    powerpc/perf: Fix the threshold compare group constraint for power9

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64: Only WARN if __pa()/__va() called with bad addresses

Miaoqian Lin <linmq006@gmail.com>
    Input: sparcspkr - fix refcount leak in bbc_beep_probe

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    crypto: cryptd - Protect per-CPU resource by disabling BH.

Qi Zheng <zhengqi.arch@bytedance.com>
    tty: fix deadlock caused by calling printk() under tty_port->lock

Francesco Dolcini <francesco.dolcini@toradex.com>
    PCI: imx6: Fix PERST# start-up sequence

Waiman Long <longman@redhat.com>
    ipc/mqueue: use get_tree_nodev() in mqueue_get_tree()

Alexey Dobriyan <adobriyan@gmail.com>
    proc: fix dentry/inode overinstantiating under /proc/${pid}/net

Randy Dunlap <rdunlap@infradead.org>
    powerpc/4xx/cpm: Fix return value of __setup() handler

Randy Dunlap <rdunlap@infradead.org>
    powerpc/idle: Fix return value of __setup() handler

Randy Dunlap <rdunlap@infradead.org>
    powerpc/8xx: export 'cpm_setbrg' for modules

Muchun Song <songmuchun@bytedance.com>
    dax: fix cache flush on PMD-mapped pages

Miaohe Lin <linmiaohe@huawei.com>
    drivers/base/node.c: fix compaction sysfs file leak

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    pinctrl: mvebu: Fix irq_of_parse_and_map() return value

Dan Williams <dan.j.williams@intel.com>
    nvdimm: Allow overwrite in the presence of disabled dimms

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix list protocols enumeration in the base protocol

Gustavo A. R. Silva <gustavoars@kernel.org>
    scsi: fcoe: Fix Wstringop-overflow warnings in fcoe_wwn_from_mac()

Lv Ruyi <lv.ruyi@zte.com.cn>
    mfd: ipaq-micro: Fix error check return value of platform_get_irq()

Hari Bathini <hbathini@linux.ibm.com>
    powerpc/fadump: fix PT_LOAD segment for boot memory area

Chuanhong Guo <gch981213@gmail.com>
    arm: mediatek: select arch timer for mt7629

Corentin Labbe <clabbe@baylibre.com>
    crypto: marvell/cesa - ECB does not IV

Hangyu Hua <hbh25y@gmail.com>
    misc: ocxl: fix possible double free in ocxl_file_register_afu

Stefan Wahren <stefan.wahren@i2se.com>
    ARM: dts: bcm2835-rpi-b: Fix GPIO line names

Phil Elwell <phil@raspberrypi.com>
    ARM: dts: bcm2837-rpi-3-b-plus: Fix GPIO line name of power LED

Phil Elwell <phil@raspberrypi.com>
    ARM: dts: bcm2837-rpi-cm3-io3: Fix GPIO line names for SMPS I2C

Phil Elwell <phil@raspberrypi.com>
    ARM: dts: bcm2835-rpi-zero-w: Fix GPIO line name for Wifi/BT

Marc Kleine-Budde <mkl@pengutronix.de>
    can: xilinx_can: mark bit timing constants as const

Sean Christopherson <seanjc@google.com>
    KVM: nVMX: Leave most VM-Exit info fields unmodified on failed VM-Entry

Dan Carpenter <dan.carpenter@oracle.com>
    PCI: rockchip: Fix find_first_zero_bit() limit

Dan Carpenter <dan.carpenter@oracle.com>
    PCI: cadence: Fix find_first_zero_bit() limit

Miaoqian Lin <linmq006@gmail.com>
    soc: qcom: smsm: Fix missing of_node_put() in smsm_parse_ipc

Miaoqian Lin <linmq006@gmail.com>
    soc: qcom: smp2p: Fix missing of_node_put() in smp2p_parse_ipc

Andre Przywara <andre.przywara@arm.com>
    ARM: dts: suniv: F1C100: fix watchdog compatible

Shawn Lin <shawn.lin@rock-chips.com>
    arm64: dts: rockchip: Move drive-impedance-ohm to emmc phy on rk3399

liuyacan <liuyacan@corp.netease.com>
    net/smc: postpone sk_refcnt increment in connect()

David Howells <dhowells@redhat.com>
    rxrpc: Fix decision on when to generate an IDLE ACK

David Howells <dhowells@redhat.com>
    rxrpc: Don't let ack.previousPacket regress

David Howells <dhowells@redhat.com>
    rxrpc: Fix overlapping ACK accounting

David Howells <dhowells@redhat.com>
    rxrpc: Don't try to resend the request if we're receiving the reply

David Howells <dhowells@redhat.com>
    rxrpc: Fix listen() setting the bar too high for the prealloc rings

Duoming Zhou <duoming@zju.edu.cn>
    NFC: hci: fix sleep in atomic context bugs in nfc_hci_hcp_message_tx

Yang Yingliang <yangyingliang@huawei.com>
    ASoC: wm2000: fix missing clk_disable_unprepare() on error in wm2000_anc_transition()

Zheng Yongjun <zhengyongjun3@huawei.com>
    thermal/drivers/broadcom: Fix potential NULL dereference in sr_thermal_probe

Hangyu Hua <hbh25y@gmail.com>
    drm: msm: fix possible memory leak in mdp5_crtc_cursor_set()

Miaoqian Lin <linmq006@gmail.com>
    drm/msm/a6xx: Fix refcount leak in a6xx_gpu_init

Eric Biggers <ebiggers@google.com>
    ext4: reject the 'commit' option on ext2 filesystems

Dongliang Mu <mudongliangabcd@gmail.com>
    media: ov7670: remove ov7670_power_off from ov7670_remove

Eric Dumazet <edumazet@google.com>
    sctp: read sk->sk_bound_dev_if once in sctp_rcv()

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: math-emu: Fix dependencies of math emulation support

Ying Hsu <yinghsu@chromium.org>
    Bluetooth: fix dangling sco_conn and use-after-free in sco_sock_timeout

Michael Rodin <mrodin@de.adit-jv.com>
    media: vsp1: Fix offset calculation for plane cropping

Pavel Skripkin <paskripkin@gmail.com>
    media: pvrusb2: fix array-index-out-of-bounds in pvr2_i2c_core_init

Miaoqian Lin <linmq006@gmail.com>
    media: exynos4-is: Change clk_disable to clk_disable_unprepare

Miaoqian Lin <linmq006@gmail.com>
    media: st-delta: Fix PM disable depth imbalance in delta_probe

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    media: aspeed: Fix an error handling path in aspeed_video_probe()

Josh Poimboeuf <jpoimboe@kernel.org>
    scripts/faddr2line: Fix overlapping text section failures

Miaoqian Lin <linmq006@gmail.com>
    regulator: pfuze100: Fix refcount leak in pfuze_parse_regulators_dt

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mxs-saif: Fix refcount leak in mxs_saif_probe

Miaoqian Lin <linmq006@gmail.com>
    ASoC: fsl: Fix refcount leak in imx_sgtl5000_probe

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/amd/ibs: Use interrupt regs ip for stack unwinding

Viresh Kumar <viresh.kumar@linaro.org>
    Revert "cpufreq: Fix possible race in cpufreq online error path"

Andreas Gruenbacher <agruenba@redhat.com>
    iomap: iomap_write_failed fix

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    media: uvcvideo: Fix missing check to determine if element is found in list

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm: return an error pointer in msm_gem_prime_get_sg_table()

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm/msm/mdp5: Return error code in mdp5_mixer_release when deadlock is detected

Jessica Zhang <quic_jesszhan@quicinc.com>
    drm/msm/mdp5: Return error code in mdp5_pipe_release when deadlock is detected

Zev Weiss <zev@bewilderbeest.net>
    regulator: core: Fix enable_count imbalance with EXCLUSIVE_GET

Randy Dunlap <rdunlap@infradead.org>
    x86/mm: Cleanup the control_va_addr_alignment() __setup handler

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    irqchip/aspeed-i2c-ic: Fix irq_of_parse_and_map() return value

Daniel Thompson <daniel.thompson@linaro.org>
    irqchip/exiu: Fix acknowledgment of edge triggered interrupts

Randy Dunlap <rdunlap@infradead.org>
    x86: Fix return value of __setup handlers

Christoph Hellwig <hch@lst.de>
    virtio_blk: fix the discard_granularity and discard_alignment queue limits

Yang Yingliang <yangyingliang@huawei.com>
    drm/rockchip: vop: fix possible null-ptr-deref in vop_bind()

Lv Ruyi <lv.ruyi@zte.com.cn>
    drm/msm/hdmi: fix error check return value of irq_of_parse_and_map()

Yang Yingliang <yangyingliang@huawei.com>
    drm/msm/hdmi: check return value after calling platform_get_resource_byname()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dsi: fix error checks and return values for DSI xmit functions

Vinod Polimera <quic_vpolimer@quicinc.com>
    drm/msm/disp/dpu1: set vbif hw config to NULL to avoid use after memory free during pm runtime resume

Yang Jihong <yangjihong1@huawei.com>
    perf tools: Add missing headers needed by util/data.h

Nicolas Frattaroli <frattaroli.nicolas@gmail.com>
    ASoC: rk3328: fix disabling mclk on pclk probe failure

Josh Poimboeuf <jpoimboe@redhat.com>
    x86/speculation: Add missing prototype for unpriv_ebpf_notify()

Matthieu Baerts <matthieu.baerts@tessares.net>
    x86/pm: Fix false positive kmemleak report in msr_build_context()

Kiwoong Kim <kwmad.kim@samsung.com>
    scsi: ufs: core: Exclude UECxx from SFR dump list

Nuno Sá <nuno.sa@analog.com>
    of: overlay: do not break notify on NOTIFY_{OK|STOP}

Amir Goldstein <amir73il@gmail.com>
    fsnotify: fix wrong lockdep annotations

Amir Goldstein <amir73il@gmail.com>
    inotify: show inotify mask flags in proc fdinfo

Dan Carpenter <dan.carpenter@oracle.com>
    ath9k_htc: fix potential out of bounds access with invalid rxstatus->rs_keyix

Schspa Shi <schspa@gmail.com>
    cpufreq: Fix possible race in cpufreq online error path

Zheng Yongjun <zhengyongjun3@huawei.com>
    spi: img-spfi: Fix pm_runtime_get_sync() error checking

Chengming Zhou <zhouchengming@bytedance.com>
    sched/fair: Fix cfs_rq_clock_pelt() for throttled cfs_rq

Miaoqian Lin <linmq006@gmail.com>
    drm/bridge: Fix error handling in analogix_dp_probe

Miaoqian Lin <linmq006@gmail.com>
    HID: elan: Fix potential double free in elan_input_configured

Jonathan Teh <jonathan.teh@outlook.com>
    HID: hid-led: fix maximum brightness for Dream Cheeky

Arnd Bergmann <arnd@arndb.de>
    drbd: fix duplicate array initializer

Jan Kiszka <jan.kiszka@siemens.com>
    efi: Add missing prototype for efi_capsule_setup_info

Lin Ma <linma@zju.edu.cn>
    NFC: NULL out the dev->rfkill to prevent UAF

Miaoqian Lin <linmq006@gmail.com>
    spi: spi-ti-qspi: Fix return value handling of wait_for_completion_timeout

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    drm: mali-dp: potential dereference of null pointer

Zhou Qingyang <zhou1615@umn.edu>
    drm/komeda: Fix an undefined behavior bug in komeda_plane_add()

Johannes Berg <johannes.berg@intel.com>
    nl80211: show SSID for P2P_GO interfaces

Yuntao Wang <ytcoode@gmail.com>
    bpf: Fix excessive memory allocation in stack_map_alloc()

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: txp: Force alpha to be 0xff if it's disabled

Maxime Ripard <maxime@cerno.tech>
    drm/vc4: txp: Don't set TXP_VSTART_AT_EOF

Miles Chen <miles.chen@mediatek.com>
    drm/mediatek: Fix mtk_cec_mask()

Ammar Faizi <ammarfaizi2@gnuweeb.org>
    x86/delay: Fix the wrong asm constraint in delay_loop()

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mediatek: Fix missing of_node_put in mt2701_wm8960_machine_probe

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mediatek: Fix error handling in mt8173_max98090_dev_probe

Lucas Stach <l.stach@pengutronix.de>
    drm/bridge: adv7511: clean up CEC adapter when probe fails

Jani Nikula <jani.nikula@intel.com>
    drm/edid: fix invalid EDID extension block filtering

Wenli Looi <wlooi@ucalgary.ca>
    ath9k: fix ar9003_get_eepmisc

Linus Torvalds <torvalds@linux-foundation.org>
    drm: fix EDID struct for old ARM OABI format

Douglas Miller <doug.miller@cornelisnetworks.com>
    RDMA/hfi1: Prevent panic when SDMA is disabled

Peng Wu <wupeng58@huawei.com>
    powerpc/iommu: Add missing of_node_put in iommu_init_early_dart

Finn Thain <fthain@linux-m68k.org>
    macintosh/via-pmu: Fix build failure when CONFIG_INPUT is disabled

Lv Ruyi <lv.ruyi@zte.com.cn>
    powerpc/powernv: fix missing of_node_put in uv_init()

Lv Ruyi <lv.ruyi@zte.com.cn>
    powerpc/xics: fix refcount leak in icp_opal_init()

Vasily Averin <vvs@openvz.org>
    tracing: incorrect isolate_mote_t cast in mm_vmscan_lru_isolate

Yicong Yang <yangyicong@hisilicon.com>
    PCI: Avoid pci_dev_lock() AB/BA deadlock with sriov_numvfs_store()

Peng Wu <wupeng58@huawei.com>
    ARM: hisi: Add missing of_node_put after of_find_compatible_node

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: exynos: add atmel,24c128 fallback to Samsung EEPROM

Peng Wu <wupeng58@huawei.com>
    ARM: versatile: Add missing of_node_put in dcscb_init

OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
    fat: add ratelimit to fat*_ent_bread()

Hari Bathini <hbathini@linux.ibm.com>
    powerpc/fadump: Fix fadump to work with a different endian capture kernel

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    ARM: OMAP1: clock: Fix UART rate reporting algorithm

Zixuan Fu <r33s3n6@gmail.com>
    fs: jfs: fix possible NULL pointer dereference in dbFree()

Brian Norris <briannorris@chromium.org>
    PM / devfreq: rk3399_dmc: Disable edev on remove()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    ARM: dts: ox820: align interrupt controller node name with dtschema

Niels Dossche <dossche.niels@gmail.com>
    IB/rdmavt: add missing locks in rvt_ruc_loopback

Yonghong Song <yhs@fb.com>
    selftests/bpf: fix btf_dump/btf_dump due to recent clang change

Jakub Kicinski <kuba@kernel.org>
    eth: tg3: silence the GCC 12 array-bounds warning

David Howells <dhowells@redhat.com>
    rxrpc: Return an error to sendmsg if call failed

Guenter Roeck <linux@roeck-us.net>
    hwmon: Make chip parameter for with_info API mandatory

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: max98357a: remove dependency on GPIOLIB

Kwanghoon Son <k.son@samsung.com>
    media: exynos4-is: Fix compile warning

Fabio Estevam <festevam@denx.de>
    net: phy: micrel: Allow probing without .driver_data

Xie Yongji <xieyongji@bytedance.com>
    nbd: Fix hung on disconnect request if socket is closed before

Lin Ma <linma@zju.edu.cn>
    ASoC: rt5645: Fix errorenous cleanup order

Smith, Kyle Miller (Nimble Kernel) <kyles@hpe.com>
    nvme-pci: fix a NULL pointer dereference in nvme_alloc_admin_tags

Jason A. Donenfeld <Jason@zx2c4.com>
    openrisc: start CPU timer early in boot

Hans Verkuil <hverkuil-cisco@xs4all.nl>
    media: cec-adap.c: fix is_configuring state

Philipp Zabel <p.zabel@pengutronix.de>
    media: coda: limit frame interval enumeration to supported encoder frame sizes

Dongliang Mu <mudongliangabcd@gmail.com>
    rtlwifi: Use pr_warn instead of WARN_ONCE

Corey Minyard <cminyard@mvista.com>
    ipmi: Fix pr_fmt to avoid compilation issues

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: Check for NULL msg when handling events and messages

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: PM: Block ASUS B1400CEAE from suspend to idle by default

Mikulas Patocka <mpatocka@redhat.com>
    dma-debug: change allocation mode from GFP_NOWAIT to GFP_ATIOMIC

Patrice Chotard <patrice.chotard@foss.st.com>
    spi: stm32-qspi: Fix wait_cmd timeout in APM mode

Heiko Carstens <hca@linux.ibm.com>
    s390/preempt: disable __preempt_count_add() optimization for PROFILE_ALL_BRANCHES

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: tscs454: Add endianness flag in snd_soc_component_driver

Dongliang Mu <mudongliangabcd@gmail.com>
    HID: bigben: fix slab-out-of-bounds Write in bigben_probe

Alice Wong <shiwei.wong@amd.com>
    drm/amdgpu/ucode: Remove firmware load type check in amdgpu_ucode_free_bo

Petr Machata <petrm@nvidia.com>
    mlxsw: spectrum_dcb: Do not warn about priority changes

Mark Brown <broonie@kernel.org>
    ASoC: dapm: Don't fold register value changes into notifications

Mark Bloch <mbloch@nvidia.com>
    net/mlx5: fs, delete the FTE when there are no rules attached to it

jianghaoran <jianghaoran@kylinos.cn>
    ipv6: Don't send rs packets to the interface of ARPHRD_TUNNEL

Lv Ruyi <lv.ruyi@zte.com.cn>
    drm: msm: fix error check return value of irq_of_parse_and_map()

Alexandru Elisei <alexandru.elisei@arm.com>
    arm64: compat: Do not treat syscall number as ESR_ELx for a bad syscall

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: fix the compile warning

Steven Price <steven.price@arm.com>
    drm/plane: Move range check for format_count earlier

Lv Ruyi <lv.ruyi@zte.com.cn>
    scsi: megaraid: Fix error check return value of register_chrdev()

Aidan MacDonald <aidanmacdonald.0x0@gmail.com>
    mmc: jz4740: Apply DMA engine limits to maximum segment size

Heming Zhao <heming.zhao@suse.com>
    md/bitmap: don't set sb values if can't pass sanity check

Zheyu Ma <zheyuma97@gmail.com>
    media: cx25821: Fix the warning when removing the module

Zheyu Ma <zheyuma97@gmail.com>
    media: pci: cx23885: Fix the error handling in cx23885_initdev()

Luca Weiss <luca.weiss@fairphone.com>
    media: venus: hfi: avoid null dereference in deinit

Thibaut VARÈNE <hacks+kernel@slashdirt.org>
    ath9k: fix QCA9561 PA bias level

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    drm/amd/pm: fix double free in si_parse_power_table()

Len Brown <len.brown@intel.com>
    tools/power turbostat: fix ICX DRAM power numbers

Biju Das <biju.das.jz@bp.renesas.com>
    spi: spi-rspi: Remove setting {src,dst}_{addr,addr_width} based on DMA direction

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ALSA: jack: Access input_dev under mutex

Liviu Dudau <liviu.dudau@arm.com>
    drm/komeda: return early if drm_universal_plane_init() fails.

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    ACPICA: Avoid cache flush inside virtual machines

Daniel Vetter <daniel.vetter@ffwll.ch>
    fbcon: Consistently protect deferred_takeover with console_lock()

Niels Dossche <dossche.niels@gmail.com>
    ipv6: fix locking issues with loops over idev->addr_list

Haowen Bai <baihaowen@meizu.com>
    ipw2x00: Fix potential NULL dereference in libipw_xmit()

Haowen Bai <baihaowen@meizu.com>
    b43: Fix assigning negative value to unsigned variable

Haowen Bai <baihaowen@meizu.com>
    b43legacy: Fix assigning negative value to unsigned variable

Niels Dossche <dossche.niels@gmail.com>
    mwifiex: add mutex lock for call in mwifiex_dfs_chan_sw_work_queue

Liu Zixian <liuzixian4@huawei.com>
    drm/virtio: fix NULL pointer dereference in virtio_gpu_conn_get_modes

Qu Wenruo <wqu@suse.com>
    btrfs: repair super block num_devices automatically

Qu Wenruo <wqu@suse.com>
    btrfs: add "0x" prefix for unsupported optional features

Eric W. Biederman <ebiederm@xmission.com>
    ptrace: Reimplement PTRACE_KILL by always sending SIGKILL

Eric W. Biederman <ebiederm@xmission.com>
    ptrace/xtensa: Replace PT_SINGLESTEP with TIF_SINGLESTEP

Eric W. Biederman <ebiederm@xmission.com>
    ptrace/um: Replace PT_DTRACE with TIF_SINGLESTEP

Kan Liang <kan.liang@linux.intel.com>
    perf/x86/intel: Fix event constraints for ICL

Kishon Vijay Abraham I <kishon@ti.com>
    usb: core: hcd: Add support for deferring roothub registration

Monish Kumar R <monish.kumar.r@intel.com>
    USB: new quirk for Dell Gen 2 devices

Carl Yin(殷张成) <carl.yin@quectel.com>
    USB: serial: option: add Quectel BG95 modem

Marios Levogiannis <marios.levogiannis@gmail.com>
    ALSA: hda/realtek - Fix microphone noise on ASUS TUF B550M-PLUS

Niklas Cassel <niklas.cassel@wdc.com>
    binfmt_flat: do not stop relocating GOT entries prematurely on riscv


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-ata                |  11 +-
 Documentation/conf.py                              |   2 +-
 .../devicetree/bindings/gpio/gpio-altera.txt       |   5 +-
 Documentation/hwmon/hwmon-kernel-api.rst           |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/bcm2835-rpi-b.dts                |  13 +-
 arch/arm/boot/dts/bcm2835-rpi-zero-w.dts           |  22 +--
 arch/arm/boot/dts/bcm2837-rpi-3-b-plus.dts         |   2 +-
 arch/arm/boot/dts/bcm2837-rpi-cm3-io3.dts          |   4 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |   4 +-
 arch/arm/boot/dts/ox820.dtsi                       |   2 +-
 arch/arm/boot/dts/suniv-f1c100s.dtsi               |   4 +-
 arch/arm/mach-hisi/platsmp.c                       |   4 +
 arch/arm/mach-mediatek/Kconfig                     |   1 +
 arch/arm/mach-omap1/clock.c                        |   2 +-
 arch/arm/mach-pxa/cm-x300.c                        |   8 +-
 arch/arm/mach-pxa/magician.c                       |   2 +-
 arch/arm/mach-pxa/tosa.c                           |   4 +-
 arch/arm/mach-vexpress/dcscb.c                     |   1 +
 arch/arm64/Kconfig.platforms                       |   1 +
 arch/arm64/boot/dts/qcom/ipq8074.dtsi              |   2 +-
 arch/arm64/boot/dts/rockchip/rk3399.dtsi           |   2 +-
 arch/arm64/kernel/sys_compat.c                     |   2 +-
 arch/arm64/net/bpf_jit_comp.c                      |   1 +
 arch/m68k/Kconfig.cpu                              |   2 +-
 arch/m68k/Kconfig.machine                          |   1 +
 arch/m68k/include/asm/pgtable_no.h                 |   3 +-
 .../include/asm/mach-ip27/cpu-feature-overrides.h  |   1 -
 arch/mips/kernel/mips-cpc.c                        |   1 +
 arch/openrisc/include/asm/timex.h                  |   1 +
 arch/openrisc/kernel/head.S                        |   9 ++
 arch/powerpc/include/asm/page.h                    |   7 +-
 arch/powerpc/kernel/fadump.c                       |   8 +-
 arch/powerpc/kernel/idle.c                         |   2 +-
 arch/powerpc/kernel/ptrace.c                       |  21 ++-
 arch/powerpc/perf/isa207-common.c                  |   3 +-
 arch/powerpc/platforms/4xx/cpm.c                   |   2 +-
 arch/powerpc/platforms/8xx/cpm1.c                  |   1 +
 arch/powerpc/platforms/powernv/opal-fadump.c       |  94 +++++++------
 arch/powerpc/platforms/powernv/opal-fadump.h       |  10 +-
 arch/powerpc/platforms/powernv/ultravisor.c        |   1 +
 arch/powerpc/sysdev/dart_iommu.c                   |   6 +-
 arch/powerpc/sysdev/fsl_rio.c                      |   2 +
 arch/powerpc/sysdev/xics/icp-opal.c                |   1 +
 arch/s390/crypto/aes_s390.c                        |   4 +-
 arch/s390/include/asm/preempt.h                    |  15 ++-
 arch/s390/mm/gmap.c                                |  14 ++
 arch/um/drivers/chan_user.c                        |   9 +-
 arch/um/include/asm/thread_info.h                  |   2 +
 arch/um/kernel/exec.c                              |   2 +-
 arch/um/kernel/process.c                           |   2 +-
 arch/um/kernel/ptrace.c                            |   8 +-
 arch/um/kernel/signal.c                            |   4 +-
 arch/x86/entry/vdso/vma.c                          |   2 +-
 arch/x86/events/amd/ibs.c                          |  18 +++
 arch/x86/events/intel/core.c                       |   2 +-
 arch/x86/include/asm/acenv.h                       |  14 +-
 arch/x86/include/asm/cpufeature.h                  |   2 +-
 arch/x86/include/asm/suspend_32.h                  |   2 +-
 arch/x86/include/asm/suspend_64.h                  |  12 +-
 arch/x86/kernel/apic/apic.c                        |   2 +-
 arch/x86/kernel/cpu/intel.c                        |   2 +-
 arch/x86/kernel/step.c                             |   3 +-
 arch/x86/kernel/sys_x86_64.c                       |   7 +-
 arch/x86/kvm/vmx/nested.c                          |  15 ++-
 arch/x86/lib/delay.c                               |   4 +-
 arch/x86/mm/pat.c                                  |   2 +-
 arch/x86/um/ldt.c                                  |   6 +-
 arch/xtensa/kernel/ptrace.c                        |   4 +-
 arch/xtensa/kernel/signal.c                        |   4 +-
 block/bfq-cgroup.c                                 | 111 +++++++++------
 block/bfq-iosched.c                                |  46 ++++---
 block/bfq-iosched.h                                |   6 +-
 block/bio.c                                        |   2 +-
 block/blk-iolatency.c                              | 122 +++++++++--------
 crypto/cryptd.c                                    |  23 ++--
 drivers/acpi/property.c                            |  18 ++-
 drivers/acpi/sleep.c                               |  12 ++
 drivers/ata/libata-transport.c                     |   2 +-
 drivers/ata/pata_octeon_cf.c                       |   3 +
 drivers/base/bus.c                                 |   4 +-
 drivers/base/dd.c                                  |   5 +-
 drivers/base/node.c                                |   1 +
 drivers/block/drbd/drbd_main.c                     |  11 +-
 drivers/block/nbd.c                                |  50 ++++---
 drivers/block/virtio_blk.c                         |   7 +-
 drivers/bus/ti-sysc.c                              |   4 +-
 drivers/char/ipmi/ipmi_msghandler.c                |   4 +-
 drivers/char/ipmi/ipmi_ssif.c                      |  23 ++++
 drivers/clocksource/timer-oxnas-rps.c              |   2 +-
 drivers/clocksource/timer-riscv.c                  |   2 +-
 drivers/clocksource/timer-sp804.c                  |  10 +-
 drivers/crypto/marvell/cipher.c                    |   1 -
 drivers/devfreq/rk3399_dmc.c                       |   2 +
 drivers/dma/stm32-mdma.c                           |  21 +--
 drivers/dma/xilinx/zynqmp_dma.c                    |   5 +-
 drivers/extcon/extcon.c                            |  29 ++--
 drivers/firmware/arm_scmi/base.c                   |   2 +-
 drivers/firmware/dmi-sysfs.c                       |   2 +-
 drivers/firmware/stratix10-svc.c                   |  12 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_ucode.c          |   3 +-
 drivers/gpu/drm/amd/amdgpu/kv_dpm.c                |  14 +-
 drivers/gpu/drm/amd/amdgpu/si_dpm.c                |   8 +-
 drivers/gpu/drm/arm/display/komeda/komeda_plane.c  |  10 +-
 drivers/gpu/drm/arm/malidp_crtc.c                  |   5 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |   1 +
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c |  31 ++++-
 drivers/gpu/drm/drm_edid.c                         |   6 +-
 drivers/gpu/drm/drm_plane.c                        |  14 +-
 drivers/gpu/drm/etnaviv/etnaviv_mmu.c              |   6 +
 drivers/gpu/drm/gma500/psb_intel_display.c         |   7 +-
 drivers/gpu/drm/imx/ipuv3-crtc.c                   |   2 +-
 drivers/gpu/drm/mediatek/mtk_cec.c                 |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   1 +
 drivers/gpu/drm/msm/disp/dpu1/dpu_kms.c            |   4 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_crtc.c          |  14 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_kms.c           |   6 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.c         |  15 ++-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_mixer.h         |   4 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.c          |  15 ++-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_pipe.h          |   2 +-
 drivers/gpu/drm/msm/disp/mdp5/mdp5_plane.c         |  20 ++-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 |  21 ++-
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |  10 +-
 drivers/gpu/drm/msm/msm_gem_prime.c                |   2 +-
 drivers/gpu/drm/nouveau/nvkm/subdev/clk/base.c     |   6 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |   4 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |   2 +-
 drivers/gpu/drm/tilcdc/tilcdc_external.c           |   8 +-
 drivers/gpu/drm/vc4/vc4_txp.c                      |   8 +-
 drivers/gpu/drm/virtio/virtgpu_display.c           |   2 +
 drivers/hid/hid-bigbenff.c                         |   6 +
 drivers/hid/hid-elan.c                             |   2 -
 drivers/hid/hid-led.c                              |   2 +-
 drivers/hwmon/hwmon.c                              |  16 +--
 drivers/hwtracing/coresight/coresight-cpu-debug.c  |   7 +-
 drivers/i2c/busses/i2c-at91-master.c               |  11 ++
 drivers/i2c/busses/i2c-cadence.c                   |  12 +-
 drivers/iio/adc/ad7124.c                           |   1 -
 drivers/iio/adc/sc27xx_adc.c                       |  20 +--
 drivers/iio/adc/stmpe-adc.c                        |   8 +-
 drivers/iio/common/st_sensors/st_sensors_core.c    |  24 +++-
 drivers/iio/dummy/iio_simple_dummy.c               |  20 +--
 drivers/infiniband/hw/hfi1/file_ops.c              |   2 +
 drivers/infiniband/hw/hfi1/init.c                  |   2 +-
 drivers/infiniband/hw/hfi1/sdma.c                  |  12 +-
 drivers/infiniband/sw/rdmavt/qp.c                  |   6 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |   2 +-
 drivers/input/misc/sparcspkr.c                     |   1 +
 drivers/input/mouse/bcm5974.c                      |   7 +-
 drivers/input/touchscreen/stmfts.c                 |  16 +--
 drivers/iommu/amd_iommu_init.c                     |   2 +-
 drivers/iommu/msm_iommu.c                          |  11 +-
 drivers/iommu/mtk_iommu.c                          |   3 +-
 drivers/irqchip/irq-armada-370-xp.c                |  11 +-
 drivers/irqchip/irq-aspeed-i2c-ic.c                |   4 +-
 drivers/irqchip/irq-sni-exiu.c                     |  25 +++-
 drivers/irqchip/irq-xtensa-mx.c                    |  18 ++-
 drivers/macintosh/Kconfig                          |   6 +
 drivers/macintosh/Makefile                         |   3 +-
 drivers/macintosh/via-pmu.c                        |   2 +-
 drivers/mailbox/mailbox.c                          |  19 ++-
 drivers/md/bcache/request.c                        |   6 +
 drivers/md/md-bitmap.c                             |  44 +++---
 drivers/md/md.c                                    |  33 +++--
 drivers/md/raid0.c                                 |  31 ++---
 drivers/media/cec/cec-adap.c                       |   6 +-
 drivers/media/i2c/ov7670.c                         |   1 -
 drivers/media/pci/cx23885/cx23885-core.c           |   6 +-
 drivers/media/pci/cx25821/cx25821-core.c           |   2 +-
 drivers/media/platform/aspeed-video.c              |   4 +-
 drivers/media/platform/coda/coda-common.c          |  35 +++--
 drivers/media/platform/exynos4-is/fimc-is.c        |   2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.h |   2 +-
 drivers/media/platform/qcom/venus/hfi.c            |   3 +
 drivers/media/platform/sti/delta/delta-v4l2.c      |   6 +-
 drivers/media/platform/vsp1/vsp1_rpf.c             |   6 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |   7 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   |  20 +--
 drivers/mfd/davinci_voicecodec.c                   |   6 +-
 drivers/mfd/ipaq-micro.c                           |   2 +-
 drivers/misc/cardreader/rtsx_usb.c                 |   1 +
 drivers/misc/lkdtm/usercopy.c                      |  17 ++-
 drivers/misc/ocxl/file.c                           |   2 +
 drivers/mmc/core/block.c                           |   3 +-
 drivers/mmc/host/jz4740_mmc.c                      |  20 +++
 drivers/mtd/chips/cfi_cmdset_0002.c                | 103 +++++++-------
 drivers/mtd/ubi/vmt.c                              |   1 -
 drivers/net/can/xilinx_can.c                       |   4 +-
 drivers/net/dsa/lantiq_gswip.c                     |   4 +-
 drivers/net/dsa/mv88e6xxx/chip.c                   |   1 +
 drivers/net/ethernet/altera/altera_tse_main.c      |   6 +-
 drivers/net/ethernet/broadcom/Makefile             |   5 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |   8 +-
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |   3 +
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |   2 +-
 .../ethernet/mellanox/mlx5/core/diag/fw_tracer.c   |   7 +-
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c  |   5 +
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c  |  45 +++++--
 .../ethernet/mellanox/mlx5/core/steering/fs_dr.c   |   9 +-
 drivers/net/ethernet/mellanox/mlxsw/spectrum_dcb.c |  13 --
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   4 +-
 drivers/net/phy/mdio_bus.c                         |   1 -
 drivers/net/phy/micrel.c                           |  11 +-
 drivers/net/wireless/ath/ath9k/ar9003_eeprom.c     |   2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |   2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |   8 ++
 drivers/net/wireless/ath/carl9170/tx.c             |   3 +
 drivers/net/wireless/broadcom/b43/phy_n.c          |   2 +-
 drivers/net/wireless/broadcom/b43legacy/phy.c      |   2 +-
 drivers/net/wireless/intel/ipw2x00/libipw_tx.c     |   2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |   3 +
 drivers/net/wireless/marvell/mwifiex/11h.c         |   2 +
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |   8 +-
 drivers/net/wireless/realtek/rtlwifi/usb.c         |   2 +-
 drivers/nfc/st21nfca/se.c                          |  32 ++++-
 drivers/nfc/st21nfca/st21nfca.h                    |   1 +
 drivers/nvdimm/security.c                          |   5 -
 drivers/nvme/host/pci.c                            |   1 +
 drivers/of/overlay.c                               |   4 +-
 drivers/pci/controller/dwc/pci-imx6.c              |  23 ++--
 drivers/pci/controller/dwc/pcie-qcom.c             |   9 +-
 drivers/pci/controller/pcie-cadence-ep.c           |   3 +-
 drivers/pci/controller/pcie-rockchip-ep.c          |   3 +-
 drivers/pci/pci.c                                  |  12 +-
 drivers/pcmcia/Kconfig                             |   2 +-
 drivers/phy/qualcomm/phy-qcom-qmp.c                |  13 +-
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |   2 +-
 drivers/pwm/pwm-lp3943.c                           |   1 +
 drivers/regulator/core.c                           |   7 +-
 drivers/regulator/pfuze100-regulator.c             |   2 +
 drivers/rpmsg/qcom_smd.c                           |   4 +-
 drivers/rtc/rtc-mt6397.c                           |   2 +
 drivers/scsi/dc395x.c                              |  15 ++-
 drivers/scsi/fcoe/fcoe_ctlr.c                      |   2 +-
 drivers/scsi/megaraid.c                            |   2 +-
 drivers/scsi/myrb.c                                |  11 +-
 drivers/scsi/ufs/ufs-qcom.c                        |   7 +-
 drivers/scsi/ufs/ufshcd.c                          |   7 +-
 drivers/soc/qcom/smp2p.c                           |   1 +
 drivers/soc/qcom/smsm.c                            |   1 +
 drivers/soc/rockchip/grf.c                         |   2 +
 drivers/spi/spi-img-spfi.c                         |   2 +-
 drivers/spi/spi-rspi.c                             |  15 +--
 drivers/spi/spi-stm32-qspi.c                       |   3 +-
 drivers/spi/spi-ti-qspi.c                          |   5 +-
 drivers/staging/fieldbus/anybuss/host.c            |   2 +-
 drivers/staging/greybus/audio_codec.c              |   4 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |   2 +-
 .../staging/rtl8192u/ieee80211/ieee80211_softmac.c |   2 +-
 drivers/staging/rtl8712/usb_intf.c                 |   6 +-
 drivers/staging/rtl8712/usb_ops.c                  |  27 ++--
 drivers/thermal/broadcom/sr-thermal.c              |   3 +
 drivers/tty/goldfish.c                             |   2 +
 drivers/tty/serial/8250/8250_fintek.c              |   8 +-
 drivers/tty/serial/digicolor-usart.c               |   2 +
 drivers/tty/serial/fsl_lpuart.c                    |  24 +---
 drivers/tty/serial/icom.c                          |   2 +-
 drivers/tty/serial/meson_uart.c                    |  13 ++
 drivers/tty/serial/msm_serial.c                    |   5 +
 drivers/tty/serial/owl-uart.c                      |   1 +
 drivers/tty/serial/pch_uart.c                      |  27 +---
 drivers/tty/serial/rda-uart.c                      |   2 +
 drivers/tty/serial/sa1100.c                        |   4 +-
 drivers/tty/serial/serial_txx9.c                   |   2 +
 drivers/tty/serial/sh-sci.c                        |   6 +-
 drivers/tty/serial/sifive.c                        |   8 +-
 drivers/tty/serial/st-asc.c                        |   4 +
 drivers/tty/serial/stm32-usart.c                   |  15 ++-
 drivers/tty/synclink_gt.c                          |   2 +
 drivers/tty/tty_buffer.c                           |   3 +-
 drivers/usb/core/hcd-pci.c                         |   4 +-
 drivers/usb/core/hcd.c                             |  29 +++-
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc2/gadget.c                          |   1 -
 drivers/usb/dwc3/dwc3-pci.c                        |   2 +-
 drivers/usb/host/isp116x-hcd.c                     |   6 +-
 drivers/usb/host/oxu210hp-hcd.c                    |   2 +
 drivers/usb/musb/omap2430.c                        |   1 +
 drivers/usb/serial/option.c                        |   2 +
 drivers/usb/storage/karma.c                        |  15 ++-
 drivers/usb/usbip/stub_dev.c                       |   2 +-
 drivers/usb/usbip/stub_rx.c                        |   2 +
 drivers/vhost/vringh.c                             |  10 +-
 drivers/video/fbdev/amba-clcd.c                    |   5 +-
 drivers/video/fbdev/core/fbcon.c                   |   5 +-
 drivers/video/fbdev/pxa3xx-gcu.c                   |  12 +-
 drivers/watchdog/ts4800_wdt.c                      |   5 +-
 drivers/watchdog/wdat_wdt.c                        |   1 +
 drivers/xen/xlate_mmu.c                            |   1 -
 fs/afs/dir.c                                       |   5 +-
 fs/binfmt_flat.c                                   |  27 +++-
 fs/btrfs/disk-io.c                                 |   4 +-
 fs/btrfs/volumes.c                                 |   8 +-
 fs/ceph/xattr.c                                    |  10 +-
 fs/cifs/cifsglob.h                                 |   4 +-
 fs/cifs/smb2ops.c                                  |   7 +-
 fs/cifs/smb2pdu.c                                  |   3 +
 fs/dax.c                                           |   3 +-
 fs/dlm/lock.c                                      |  11 +-
 fs/dlm/plock.c                                     |  12 +-
 fs/ext4/inline.c                                   |  12 ++
 fs/ext4/inode.c                                    |   4 +
 fs/ext4/namei.c                                    |  84 +++++++++---
 fs/ext4/super.c                                    |   1 +
 fs/f2fs/checkpoint.c                               |   4 +-
 fs/f2fs/f2fs.h                                     |  14 +-
 fs/f2fs/file.c                                     |  20 ++-
 fs/f2fs/inode.c                                    |  16 ++-
 fs/f2fs/segment.c                                  |   9 +-
 fs/f2fs/segment.h                                  |  32 +++--
 fs/f2fs/super.c                                    |   6 +-
 fs/fat/fatent.c                                    |   7 +-
 fs/fs-writeback.c                                  |  13 +-
 fs/iomap/buffered-io.c                             |   3 +-
 fs/jffs2/fs.c                                      |   1 +
 fs/jfs/jfs_dmap.c                                  |   3 +-
 fs/kernfs/dir.c                                    |  31 +++--
 fs/nfs/file.c                                      |   7 +-
 fs/nfs/nfs4proc.c                                  |   4 +
 fs/nfs/pnfs.c                                      |   2 +
 fs/nfs/write.c                                     |  11 +-
 fs/notify/fdinfo.c                                 |  11 +-
 fs/notify/inotify/inotify.h                        |  12 ++
 fs/notify/inotify/inotify_user.c                   |   2 +-
 fs/notify/mark.c                                   |   6 +-
 fs/ocfs2/dlmfs/userdlm.c                           |  16 ++-
 fs/proc/generic.c                                  |   3 +
 fs/proc/proc_net.c                                 |   3 +
 include/drm/drm_edid.h                             |   6 +-
 include/linux/bpf.h                                |   2 +
 include/linux/efi.h                                |   2 +
 include/linux/iio/common/st_sensors.h              |   3 +
 include/linux/mailbox_controller.h                 |   1 +
 include/linux/mtd/cfi.h                            |   1 +
 include/linux/nodemask.h                           |  51 ++++---
 include/linux/ptrace.h                             |   7 -
 include/linux/usb/hcd.h                            |   2 +
 include/net/if_inet6.h                             |   8 ++
 include/net/sch_generic.h                          |  42 ++----
 include/scsi/libfcoe.h                             |   3 +-
 include/sound/jack.h                               |   1 +
 include/trace/events/rxrpc.h                       |   2 +-
 include/trace/events/vmscan.h                      |   4 +-
 init/Kconfig                                       |   9 ++
 ipc/mqueue.c                                       |  14 ++
 kernel/bpf/stackmap.c                              |   1 -
 kernel/dma/debug.c                                 |   2 +-
 kernel/ptrace.c                                    |   5 +-
 kernel/sched/fair.c                                |   8 +-
 kernel/sched/pelt.h                                |   4 +-
 kernel/sched/sched.h                               |   4 +-
 kernel/trace/trace.c                               |  13 +-
 kernel/trace/trace_events_hist.c                   |   3 +
 lib/nodemask.c                                     |   4 +-
 mm/compaction.c                                    |   2 +
 mm/hugetlb.c                                       |   9 +-
 net/bluetooth/sco.c                                |  21 +--
 net/ipv4/ip_gre.c                                  |  11 +-
 net/ipv4/tcp_output.c                              |   4 +-
 net/ipv4/xfrm4_protocol.c                          |   1 -
 net/ipv6/addrconf.c                                |  33 ++++-
 net/ipv6/seg6_hmac.c                               |   1 -
 net/key/af_key.c                                   |  10 +-
 net/mac80211/chan.c                                |   7 +-
 net/mac80211/ieee80211_i.h                         |   5 +
 net/mac80211/scan.c                                |  20 +++
 net/netfilter/nf_tables_api.c                      |  22 ++-
 net/netfilter/nft_dynset.c                         |   3 -
 net/netfilter/nft_nat.c                            |   3 +-
 net/nfc/core.c                                     |   1 +
 net/rxrpc/ar-internal.h                            |  13 +-
 net/rxrpc/call_event.c                             |   3 +-
 net/rxrpc/input.c                                  |  31 +++--
 net/rxrpc/output.c                                 |  20 +--
 net/rxrpc/recvmsg.c                                |   8 +-
 net/rxrpc/sendmsg.c                                |   6 +
 net/rxrpc/sysctl.c                                 |   4 +-
 net/sctp/input.c                                   |   4 +-
 net/smc/af_smc.c                                   |   2 +-
 net/sunrpc/xdr.c                                   |   6 +-
 net/sunrpc/xprtrdma/rpc_rdma.c                     |   5 +
 net/tipc/bearer.c                                  |   3 +-
 net/unix/af_unix.c                                 |   2 +-
 net/wireless/nl80211.c                             |   1 +
 scripts/faddr2line                                 | 150 +++++++++++++--------
 scripts/gdb/linux/config.py                        |   6 +-
 scripts/mod/modpost.c                              |   5 +-
 .../integrity/platform_certs/keyring_handler.h     |   8 ++
 security/integrity/platform_certs/load_uefi.c      |  33 +++++
 sound/core/jack.c                                  |  34 ++++-
 sound/pci/hda/patch_conexant.c                     |   7 +
 sound/pci/hda/patch_realtek.c                      |  10 ++
 sound/soc/codecs/Kconfig                           |   1 -
 sound/soc/codecs/rk3328_codec.c                    |   2 +-
 sound/soc/codecs/rt5514.c                          |   2 +-
 sound/soc/codecs/rt5645.c                          |   7 +-
 sound/soc/codecs/tscs454.c                         |  12 +-
 sound/soc/codecs/wm2000.c                          |   6 +-
 sound/soc/fsl/fsl_sai.h                            |   4 +-
 sound/soc/fsl/imx-sgtl5000.c                       |  14 +-
 sound/soc/mediatek/mt2701/mt2701-wm8960.c          |   9 +-
 sound/soc/mediatek/mt8173/mt8173-max98090.c        |   5 +-
 sound/soc/mxs/mxs-saif.c                           |   1 +
 sound/soc/soc-dapm.c                               |   2 -
 tools/perf/builtin-c2c.c                           |  10 +-
 tools/perf/pmu-events/jevents.c                    |   2 +-
 tools/perf/util/data.h                             |   1 +
 tools/power/x86/turbostat/turbostat.c              |   1 +
 .../bpf/progs/btf_dump_test_case_syntax.c          |   2 +-
 tools/testing/selftests/netfilter/nft_nat.sh       |  43 ++++++
 412 files changed, 2494 insertions(+), 1313 deletions(-)


