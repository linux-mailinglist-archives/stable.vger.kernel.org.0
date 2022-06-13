Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0892754843E
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 12:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241630AbiFMKOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 06:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241518AbiFMKOc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 06:14:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1270B1D8;
        Mon, 13 Jun 2022 03:14:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64300B80E2D;
        Mon, 13 Jun 2022 10:14:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77DA4C34114;
        Mon, 13 Jun 2022 10:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655115264;
        bh=GOqYbzeCWuME85WrdtOtMbtaT+DXd8zBa+XLYJfeCHM=;
        h=From:To:Cc:Subject:Date:From;
        b=C+fcpgSmj5xnxr+0qrls8m8+YheIZdapFcCF48+vCLVjwC+bSPnzuQwDp/OJMUQZH
         DkGkeZZP/UmX9DTXNu1R+7DMKirCtRmC4B9QIHAm/rvLcXRjAXgHfH2uDhe4OQAPt3
         Bbs0yEAT5DHxwHRn5zaiv9mvT0bhFum+LjzoW1DY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 4.9 000/167] 4.9.318-rc1 review
Date:   Mon, 13 Jun 2022 12:07:54 +0200
Message-Id: <20220613094840.720778945@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.318-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.9.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.9.318-rc1
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

This is the start of the stable review cycle for the 4.9.318 release.
There are 167 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 15 Jun 2022 09:47:08 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.9.318-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.9.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.9.318-rc1

Johan Hovold <johan+linaro@kernel.org>
    PCI: qcom: Fix unbalanced PHY init on probe errors

Tokunori Ikegami <ikegami.t@gmail.com>
    mtd: cfi_cmdset_0002: Use chip_ready() for write on S29GL064N

Tokunori Ikegami <ikegami.t@gmail.com>
    mtd: cfi_cmdset_0002: Move and rename chip_check/chip_ready/chip_good_for_write

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/32: Fix overread/overwrite of thread_struct via ptrace

Mathias Nyman <mathias.nyman@linux.intel.com>
    Input: bcm5974 - set missing URB_NO_TRANSFER_DMA_MAP urb flag

Martin Faltesek <mfaltesek@google.com>
    nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling

Martin Faltesek <mfaltesek@google.com>
    nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: libata-transport: fix {dma|pio|xfer}_mode sysfs files

Shyam Prasad N <sprasad@microsoft.com>
    cifs: return errors during session setup during reconnects

huangwenhui <huangwenhuia@uniontech.com>
    ALSA: hda/conexant - Fix loopback issue with CX20632

Xie Yongji <xieyongji@bytedance.com>
    vringh: Fix loop descriptors check in the indirect cases

Kees Cook <keescook@chromium.org>
    nodemask: Fix return values to be unsigned

Masahiro Yamada <masahiroy@kernel.org>
    modpost: fix undefined behavior of is_arm_mapping_symbol()

Gong Yuanjun <ruc_gongyuanjun@163.com>
    drm/radeon: fix a possible null pointer dereference

Michal Kubecek <mkubecek@suse.cz>
    Revert "net: af_key: add check for pfkey_broadcast in function pfkey_process"

Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
    md: protect md_unregister_thread from reentrancy

John Ogness <john.ogness@linutronix.de>
    serial: msm_serial: disable interrupts in __msm_console_write()

Wang Cheng <wanngchenng@gmail.com>
    staging: rtl8712: fix uninit-value in r871xu_drv_init()

Andre Przywara <andre.przywara@arm.com>
    clocksource/drivers/sp804: Avoid error on multiple instances

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

Huang Guobin <huangguobin4@huawei.com>
    tty: Fix a possible resource leak in icom_probe

Zheyu Ma <zheyuma97@gmail.com>
    tty: synclink_gt: Fix null-pointer-dereference in slgt_clean()

Kees Cook <keescook@chromium.org>
    lkdtm/usercopy: Expand size of "out of frame" object

Xiaoke Wang <xkernel.wang@foxmail.com>
    iio: dummy: iio_simple_dummy: check the return value of kstrdup()

Miaoqian Lin <linmq006@gmail.com>
    net: altera: Fix refcount leak in altera_tse_mdio_create

Masahiro Yamada <masahiroy@kernel.org>
    net: xfrm: unexport __init-annotated xfrm4_protocol_init()

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix the calculation of xdr->end in xdr_get_next_encode_buffer()

Gal Pressman <gal@nvidia.com>
    net/mlx4_en: Fix wrong return value on ioctl EEPROM query failure

Miaoqian Lin <linmq006@gmail.com>
    ata: pata_octeon_cf: Fix refcount leak in octeon_cf_probe

Maciej Żenczykowski <maze@google.com>
    net: fix nla_strcmp to handle more then one trailing null character

Yang Yingliang <yangyingliang@huawei.com>
    video: fbdev: pxa3xx-gcu: release the resources correctly in pxa3xx_gcu_probe/remove()

Greg Ungerer <gerg@linux-m68k.org>
    m68knommu: fix undefined reference to `_init_sp'

Greg Ungerer <gerg@linux-m68k.org>
    m68knommu: set ZERO_PAGE() to the allocated zeroed page

Lucas Tanure <tanureal@opensource.cirrus.com>
    i2c: cadence: Increase timeout per message if necessary

Mark-PK Tsai <mark-pk.tsai@mediatek.com>
    tracing: Avoid adding tracer option before update_tracer_options

Eric Dumazet <edumazet@google.com>
    tcp: tcp_rtx_synack() can be called from process context

Baokun Li <libaokun1@huawei.com>
    jffs2: fix memory leak in jffs2_do_fill_super

Alexander Lobakin <alexandr.lobakin@intel.com>
    modpost: fix removing numeric suffixes

Dan Carpenter <dan.carpenter@oracle.com>
    net: ethernet: mtk_eth_soc: out of bounds read in mtk_hwlro_get_fdir_entry()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    clocksource/drivers/oxnas-rps: Fix irq_of_parse_and_map() return value

Miaoqian Lin <linmq006@gmail.com>
    firmware: dmi-sysfs: Fix memory leak in dmi_sysfs_register_handle

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: st-asc: Sanitize CSIZE and correct PARENB for CS7

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: sh-sci: Don't allow CS5-6

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: txx9: Don't allow CS5-6

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: digicolor-usart: Don't allow CS5-6

John Ogness <john.ogness@linutronix.de>
    serial: meson: acquire port->lock in startup()

Yang Yingliang <yangyingliang@huawei.com>
    rtc: mt6397: check return value after calling platform_get_resource()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    rpmsg: qcom_smd: Fix irq_of_parse_and_map() return value

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: lp3943: Fix duty calculation in case period was clamped

Lin Ma <linma@zju.edu.cn>
    USB: storage: karma: fix rio_karma_init return

Niels Dossche <dossche.niels@gmail.com>
    usb: usbip: add missing device lock on tweak configuration cmd

Hangyu Hua <hbh25y@gmail.com>
    usb: usbip: fix a refcount leak in stub_probe()

Jakob Koschel <jakobkoschel@gmail.com>
    staging: greybus: codecs: fix type confusion of list iterator variable

Randy Dunlap <rdunlap@infradead.org>
    pcmcia: db1xxx_ss: restrict to MIPS_DB1XXX boards

Pablo Neira Ayuso <pablo@netfilter.org>
    netfilter: nf_tables: disallow non-stateful expression in sets earlier

Maciej W. Rozycki <macro@orcam.me.uk>
    MIPS: IP27: Remove incorrect `cpu_has_fpu' override

Xiao Yang <yangx.jy@fujitsu.com>
    RDMA/rxe: Generate a completion for unsupported/invalid opcode

Dinh Nguyen <dinguyen@kernel.org>
    dt-bindings: gpio: altera: correct interrupt-cells

Akira Yokosawa <akiyks@gmail.com>
    docs/conf.py: Cope with removal of language=None in Sphinx 5.0.0

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    gma500: fix an incorrect NULL check on list iterator

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

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    md: fix an incorrect NULL check in md_reload_sb

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    md: fix an incorrect NULL check in does_sb_need_changing

Brian Norris <briannorris@chromium.org>
    drm/bridge: analogix_dp: Grab runtime PM reference for DP-AUX

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

Jan Kara <jack@suse.cz>
    ext4: verify dir block before splitting it

Ye Bin <yebin10@huawei.com>
    ext4: fix bug_on in ext4_writepages

Ye Bin <yebin10@huawei.com>
    ext4: fix use-after-free in ext4_rename_dir_prepare

Zhihao Cheng <chengzhihao1@huawei.com>
    fs-writeback: writeback_sb_inodes：Recalculate 'wrote' according skipped pages

Emmanuel Grumbach <emmanuel.grumbach@intel.com>
    iwlwifi: mvm: fix assert 1F04 upon reconfig

Johannes Berg <johannes.berg@intel.com>
    wifi: mac80211: fix use-after-free in chanctx code

Joerg Roedel <jroedel@suse.de>
    iommu/amd: Increase timeout waiting for GA log enablement

Miaoqian Lin <linmq006@gmail.com>
    video: fbdev: clcdfb: Fix refcount leak in clcdfb_of_vram_setup

Miaoqian Lin <linmq006@gmail.com>
    Input: sparcspkr - fix refcount leak in bbc_beep_probe

Qi Zheng <zhengqi.arch@bytedance.com>
    tty: fix deadlock caused by calling printk() under tty_port->lock

Randy Dunlap <rdunlap@infradead.org>
    powerpc/4xx/cpm: Fix return value of __setup() handler

Randy Dunlap <rdunlap@infradead.org>
    powerpc/idle: Fix return value of __setup() handler

Randy Dunlap <rdunlap@infradead.org>
    powerpc/8xx: export 'cpm_setbrg' for modules

Miaohe Lin <linmiaohe@huawei.com>
    drivers/base/node.c: fix compaction sysfs file leak

Gustavo A. R. Silva <gustavoars@kernel.org>
    scsi: fcoe: Fix Wstringop-overflow warnings in fcoe_wwn_from_mac()

Lv Ruyi <lv.ruyi@zte.com.cn>
    mfd: ipaq-micro: Fix error check return value of platform_get_irq()

Miaoqian Lin <linmq006@gmail.com>
    soc: qcom: smsm: Fix missing of_node_put() in smsm_parse_ipc

Miaoqian Lin <linmq006@gmail.com>
    soc: qcom: smp2p: Fix missing of_node_put() in smp2p_parse_ipc

David Howells <dhowells@redhat.com>
    rxrpc: Don't try to resend the request if we're receiving the reply

David Howells <dhowells@redhat.com>
    rxrpc: Fix listen() setting the bar too high for the prealloc rings

Yang Yingliang <yangyingliang@huawei.com>
    ASoC: wm2000: fix missing clk_disable_unprepare() on error in wm2000_anc_transition()

Eric Dumazet <edumazet@google.com>
    sctp: read sk->sk_bound_dev_if once in sctp_rcv()

Geert Uytterhoeven <geert@linux-m68k.org>
    m68k: math-emu: Fix dependencies of math emulation support

Ying Hsu <yinghsu@chromium.org>
    Bluetooth: fix dangling sco_conn and use-after-free in sco_sock_timeout

Pavel Skripkin <paskripkin@gmail.com>
    media: pvrusb2: fix array-index-out-of-bounds in pvr2_i2c_core_init

Miaoqian Lin <linmq006@gmail.com>
    media: exynos4-is: Change clk_disable to clk_disable_unprepare

Miaoqian Lin <linmq006@gmail.com>
    regulator: pfuze100: Fix refcount leak in pfuze_parse_regulators_dt

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mxs-saif: Fix refcount leak in mxs_saif_probe

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    media: uvcvideo: Fix missing check to determine if element is found in list

Dan Carpenter <dan.carpenter@oracle.com>
    drm/msm: return an error pointer in msm_gem_prime_get_sg_table()

Randy Dunlap <rdunlap@infradead.org>
    x86/mm: Cleanup the control_va_addr_alignment() __setup handler

Yang Yingliang <yangyingliang@huawei.com>
    drm/rockchip: vop: fix possible null-ptr-deref in vop_bind()

Yang Yingliang <yangyingliang@huawei.com>
    drm/msm/hdmi: check return value after calling platform_get_resource_byname()

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/dsi: fix error checks and return values for DSI xmit functions

Matthieu Baerts <matthieu.baerts@tessares.net>
    x86/pm: Fix false positive kmemleak report in msr_build_context()

Amir Goldstein <amir73il@gmail.com>
    inotify: show inotify mask flags in proc fdinfo

Dan Carpenter <dan.carpenter@oracle.com>
    ath9k_htc: fix potential out of bounds access with invalid rxstatus->rs_keyix

Zheng Yongjun <zhengyongjun3@huawei.com>
    spi: img-spfi: Fix pm_runtime_get_sync() error checking

Jonathan Teh <jonathan.teh@outlook.com>
    HID: hid-led: fix maximum brightness for Dream Cheeky

Lin Ma <linma@zju.edu.cn>
    NFC: NULL out the dev->rfkill to prevent UAF

Miaoqian Lin <linmq006@gmail.com>
    spi: spi-ti-qspi: Fix return value handling of wait_for_completion_timeout

Miles Chen <miles.chen@mediatek.com>
    drm/mediatek: Fix mtk_cec_mask()

Ammar Faizi <ammarfaizi2@gnuweeb.org>
    x86/delay: Fix the wrong asm constraint in delay_loop()

Miaoqian Lin <linmq006@gmail.com>
    ASoC: mediatek: Fix error handling in mt8173_max98090_dev_probe

Linus Torvalds <torvalds@linux-foundation.org>
    drm: fix EDID struct for old ARM OABI format

Finn Thain <fthain@linux-m68k.org>
    macintosh/via-pmu: Fix build failure when CONFIG_INPUT is disabled

Lv Ruyi <lv.ruyi@zte.com.cn>
    powerpc/xics: fix refcount leak in icp_opal_init()

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

Janusz Krzysztofik <jmkrzyszt@gmail.com>
    ARM: OMAP1: clock: Fix UART rate reporting algorithm

Zixuan Fu <r33s3n6@gmail.com>
    fs: jfs: fix possible NULL pointer dereference in dbFree()

Jakub Kicinski <kuba@kernel.org>
    eth: tg3: silence the GCC 12 array-bounds warning

David Howells <dhowells@redhat.com>
    rxrpc: Return an error to sendmsg if call failed

Kwanghoon Son <k.son@samsung.com>
    media: exynos4-is: Fix compile warning

Lin Ma <linma@zju.edu.cn>
    ASoC: rt5645: Fix errorenous cleanup order

Smith, Kyle Miller (Nimble Kernel) <kyles@hpe.com>
    nvme-pci: fix a NULL pointer dereference in nvme_alloc_admin_tags

Jason A. Donenfeld <Jason@zx2c4.com>
    openrisc: start CPU timer early in boot

Corey Minyard <cminyard@mvista.com>
    ipmi:ssif: Check for NULL msg when handling events and messages

Mikulas Patocka <mpatocka@redhat.com>
    dma-debug: change allocation mode from GFP_NOWAIT to GFP_ATIOMIC

Mark Brown <broonie@kernel.org>
    ASoC: dapm: Don't fold register value changes into notifications

jianghaoran <jianghaoran@kylinos.cn>
    ipv6: Don't send rs packets to the interface of ARPHRD_TUNNEL

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: fix the compile warning

Lv Ruyi <lv.ruyi@zte.com.cn>
    scsi: megaraid: Fix error check return value of register_chrdev()

Zheyu Ma <zheyuma97@gmail.com>
    media: cx25821: Fix the warning when removing the module

Thibaut VARÈNE <hacks+kernel@slashdirt.org>
    ath9k: fix QCA9561 PA bias level

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    drm/amd/pm: fix double free in si_parse_power_table()

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ALSA: jack: Access input_dev under mutex

Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
    ACPICA: Avoid cache flush inside virtual machines

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
    btrfs: add "0x" prefix for unsupported optional features

Eric W. Biederman <ebiederm@xmission.com>
    ptrace: Reimplement PTRACE_KILL by always sending SIGKILL

Eric W. Biederman <ebiederm@xmission.com>
    ptrace/xtensa: Replace PT_SINGLESTEP with TIF_SINGLESTEP

Monish Kumar R <monish.kumar.r@intel.com>
    USB: new quirk for Dell Gen 2 devices


-------------

Diffstat:

 Documentation/ABI/testing/sysfs-ata                |  5 +-
 Documentation/conf.py                              |  2 +-
 .../devicetree/bindings/gpio/gpio-altera.txt       |  5 +-
 Makefile                                           |  4 +-
 arch/arm/boot/dts/exynos5250-smdk5250.dts          |  4 +-
 arch/arm/mach-hisi/platsmp.c                       |  4 +
 arch/arm/mach-omap1/clock.c                        |  2 +-
 arch/arm/mach-vexpress/dcscb.c                     |  1 +
 arch/m68k/Kconfig.cpu                              |  2 +-
 arch/m68k/Kconfig.machine                          |  1 +
 arch/m68k/include/asm/pgtable_no.h                 |  3 +-
 .../include/asm/mach-ip27/cpu-feature-overrides.h  |  1 -
 arch/openrisc/include/asm/timex.h                  |  1 +
 arch/openrisc/kernel/head.S                        |  9 +++
 arch/powerpc/kernel/idle.c                         |  2 +-
 arch/powerpc/kernel/ptrace.c                       | 18 ++++-
 arch/powerpc/sysdev/cpm1.c                         |  1 +
 arch/powerpc/sysdev/ppc4xx_cpm.c                   |  2 +-
 arch/powerpc/sysdev/xics/icp-opal.c                |  1 +
 arch/um/drivers/chan_user.c                        |  9 ++-
 arch/x86/include/asm/acenv.h                       | 14 +++-
 arch/x86/include/asm/suspend_32.h                  |  2 +-
 arch/x86/include/asm/suspend_64.h                  | 12 ++-
 arch/x86/kernel/step.c                             |  3 +-
 arch/x86/kernel/sys_x86_64.c                       |  7 +-
 arch/x86/lib/delay.c                               |  4 +-
 arch/x86/um/ldt.c                                  |  6 +-
 arch/xtensa/kernel/ptrace.c                        |  4 +-
 arch/xtensa/kernel/signal.c                        |  4 +-
 drivers/ata/libata-transport.c                     |  2 +-
 drivers/ata/pata_octeon_cf.c                       |  3 +
 drivers/base/node.c                                |  1 +
 drivers/char/ipmi/ipmi_ssif.c                      | 23 ++++++
 drivers/clocksource/timer-oxnas-rps.c              |  2 +-
 drivers/clocksource/timer-sp804.c                  | 10 +--
 drivers/firmware/dmi-sysfs.c                       |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_cs.c             |  2 +-
 drivers/gpu/drm/amd/amdgpu/kv_dpm.c                | 14 +---
 drivers/gpu/drm/amd/amdgpu/si_dpm.c                |  8 +-
 drivers/gpu/drm/bridge/analogix/analogix_dp_core.c | 13 ++-
 drivers/gpu/drm/gma500/psb_intel_display.c         |  7 +-
 drivers/gpu/drm/mediatek/mtk_cec.c                 |  2 +-
 drivers/gpu/drm/msm/dsi/dsi_host.c                 | 21 +++--
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |  4 +
 drivers/gpu/drm/msm/msm_gem_prime.c                |  2 +-
 drivers/gpu/drm/radeon/radeon_connectors.c         |  4 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop.c        |  2 +-
 drivers/gpu/drm/virtio/virtgpu_display.c           |  2 +
 drivers/hid/hid-led.c                              |  2 +-
 drivers/i2c/busses/i2c-cadence.c                   | 12 ++-
 drivers/iio/dummy/iio_simple_dummy.c               | 20 +++--
 drivers/infiniband/hw/hfi1/init.c                  |  2 +-
 drivers/infiniband/sw/rxe/rxe_req.c                |  2 +-
 drivers/input/misc/sparcspkr.c                     |  1 +
 drivers/input/mouse/bcm5974.c                      |  7 +-
 drivers/iommu/amd_iommu_init.c                     |  2 +-
 drivers/iommu/msm_iommu.c                          | 11 ++-
 drivers/irqchip/irq-armada-370-xp.c                | 11 ++-
 drivers/irqchip/irq-xtensa-mx.c                    | 18 ++++-
 drivers/macintosh/Kconfig                          |  4 +
 drivers/macintosh/Makefile                         |  3 +-
 drivers/macintosh/via-pmu.c                        |  2 +-
 drivers/md/md.c                                    | 33 +++++---
 drivers/media/pci/cx25821/cx25821-core.c           |  2 +-
 drivers/media/platform/exynos4-is/fimc-is.c        |  2 +-
 drivers/media/platform/exynos4-is/fimc-isp-video.h |  2 +-
 drivers/media/usb/pvrusb2/pvrusb2-hdw.c            |  7 +-
 drivers/media/usb/uvc/uvc_v4l2.c                   | 20 ++---
 drivers/mfd/ipaq-micro.c                           |  2 +-
 drivers/mfd/rtsx_usb.c                             |  1 +
 drivers/misc/lkdtm_usercopy.c                      | 17 +++-
 drivers/mtd/chips/cfi_cmdset_0002.c                | 93 ++++++++++++----------
 drivers/net/ethernet/altera/altera_tse_main.c      |  6 +-
 drivers/net/ethernet/broadcom/Makefile             |  5 ++
 drivers/net/ethernet/mediatek/mtk_eth_soc.c        |  3 +
 drivers/net/ethernet/mellanox/mlx4/en_ethtool.c    |  2 +-
 drivers/net/wireless/ath/ath9k/ar9003_phy.h        |  2 +-
 drivers/net/wireless/ath/ath9k/htc_drv_txrx.c      |  8 ++
 drivers/net/wireless/ath/carl9170/tx.c             |  3 +
 drivers/net/wireless/broadcom/b43/phy_n.c          |  2 +-
 drivers/net/wireless/broadcom/b43legacy/phy.c      |  2 +-
 drivers/net/wireless/intel/ipw2x00/libipw_tx.c     |  2 +-
 drivers/net/wireless/intel/iwlwifi/mvm/power.c     |  3 +
 drivers/net/wireless/marvell/mwifiex/11h.c         |  2 +
 drivers/net/wireless/realtek/rtl818x/rtl8180/dev.c |  8 +-
 drivers/nfc/st21nfca/se.c                          | 15 +++-
 drivers/nvme/host/pci.c                            |  1 +
 drivers/pci/host/pcie-qcom.c                       |  7 +-
 drivers/pci/pci.c                                  | 10 +--
 drivers/pcmcia/Kconfig                             |  2 +-
 drivers/pwm/pwm-lp3943.c                           |  1 +
 drivers/regulator/pfuze100-regulator.c             |  2 +
 drivers/rpmsg/qcom_smd.c                           |  2 +-
 drivers/rtc/rtc-mt6397.c                           |  2 +
 drivers/scsi/dc395x.c                              | 15 +++-
 drivers/scsi/fcoe/fcoe_ctlr.c                      |  2 +-
 drivers/scsi/megaraid.c                            |  2 +-
 drivers/scsi/ufs/ufs-qcom.c                        |  7 +-
 drivers/soc/qcom/smp2p.c                           |  1 +
 drivers/soc/qcom/smsm.c                            |  1 +
 drivers/spi/spi-img-spfi.c                         |  2 +-
 drivers/spi/spi-ti-qspi.c                          |  5 +-
 drivers/staging/greybus/audio_codec.c              |  4 +-
 drivers/staging/rtl8192e/rtllib_softmac.c          |  2 +-
 drivers/staging/rtl8712/usb_intf.c                 |  6 +-
 drivers/tty/serial/digicolor-usart.c               |  2 +
 drivers/tty/serial/icom.c                          |  2 +-
 drivers/tty/serial/meson_uart.c                    | 13 +++
 drivers/tty/serial/msm_serial.c                    |  5 ++
 drivers/tty/serial/sa1100.c                        |  4 +-
 drivers/tty/serial/serial_txx9.c                   |  2 +
 drivers/tty/serial/sh-sci.c                        |  6 +-
 drivers/tty/serial/st-asc.c                        |  4 +
 drivers/tty/synclink_gt.c                          |  2 +
 drivers/tty/tty_buffer.c                           |  3 +-
 drivers/usb/core/hcd-pci.c                         |  4 +-
 drivers/usb/core/quirks.c                          |  3 +
 drivers/usb/dwc2/gadget.c                          |  1 -
 drivers/usb/host/isp116x-hcd.c                     |  6 +-
 drivers/usb/host/oxu210hp-hcd.c                    |  2 +
 drivers/usb/storage/karma.c                        | 15 ++--
 drivers/usb/usbip/stub_dev.c                       |  2 +-
 drivers/usb/usbip/stub_rx.c                        |  2 +
 drivers/vhost/vringh.c                             | 10 ++-
 drivers/video/fbdev/amba-clcd.c                    |  5 +-
 drivers/video/fbdev/pxa3xx-gcu.c                   | 12 +--
 fs/btrfs/disk-io.c                                 |  4 +-
 fs/cifs/smb2pdu.c                                  |  3 +
 fs/dlm/lock.c                                      | 11 ++-
 fs/dlm/plock.c                                     | 12 ++-
 fs/ext4/inline.c                                   | 12 +++
 fs/ext4/namei.c                                    | 62 +++++++++++----
 fs/fat/fatent.c                                    |  7 +-
 fs/fs-writeback.c                                  | 13 +--
 fs/jffs2/fs.c                                      |  1 +
 fs/jfs/jfs_dmap.c                                  |  3 +-
 fs/notify/fdinfo.c                                 | 11 +--
 fs/notify/inotify/inotify.h                        | 12 +++
 fs/notify/inotify/inotify_user.c                   |  2 +-
 fs/ocfs2/dlmfs/userdlm.c                           | 16 +++-
 include/drm/drm_edid.h                             |  6 +-
 include/linux/mtd/cfi.h                            |  1 +
 include/linux/nodemask.h                           | 51 ++++++------
 include/linux/ptrace.h                             |  6 --
 include/scsi/libfcoe.h                             |  3 +-
 include/sound/jack.h                               |  1 +
 kernel/ptrace.c                                    |  5 +-
 kernel/trace/trace.c                               |  7 ++
 lib/dma-debug.c                                    |  2 +-
 lib/nlattr.c                                       |  2 +-
 lib/nodemask.c                                     |  4 +-
 mm/hugetlb.c                                       |  9 ++-
 net/bluetooth/sco.c                                | 21 +++--
 net/ipv4/tcp_output.c                              |  4 +-
 net/ipv4/xfrm4_protocol.c                          |  1 -
 net/ipv6/addrconf.c                                |  3 +-
 net/key/af_key.c                                   | 10 ++-
 net/mac80211/chan.c                                |  7 +-
 net/mac80211/ieee80211_i.h                         |  5 ++
 net/mac80211/scan.c                                | 20 +++++
 net/netfilter/nf_tables_api.c                      | 16 ++--
 net/netfilter/nft_dynset.c                         |  3 -
 net/nfc/core.c                                     |  1 +
 net/rxrpc/call_event.c                             |  3 +-
 net/rxrpc/sendmsg.c                                |  6 ++
 net/rxrpc/sysctl.c                                 |  4 +-
 net/sctp/input.c                                   |  4 +-
 net/sunrpc/xdr.c                                   |  6 +-
 scripts/mod/modpost.c                              |  5 +-
 sound/core/jack.c                                  | 34 ++++++--
 sound/pci/hda/patch_conexant.c                     |  7 ++
 sound/soc/codecs/rt5514.c                          |  2 +-
 sound/soc/codecs/rt5645.c                          |  6 ++
 sound/soc/codecs/wm2000.c                          |  6 +-
 sound/soc/mediatek/mt8173/mt8173-max98090.c        |  5 +-
 sound/soc/mxs/mxs-saif.c                           |  1 +
 sound/soc/soc-dapm.c                               |  2 -
 177 files changed, 840 insertions(+), 383 deletions(-)


