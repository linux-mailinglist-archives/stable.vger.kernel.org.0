Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0B06E6577F9
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 15:44:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232871AbiL1Oo2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 09:44:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232879AbiL1OoQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 09:44:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CFD211808;
        Wed, 28 Dec 2022 06:44:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7673B81714;
        Wed, 28 Dec 2022 14:44:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1358C433EF;
        Wed, 28 Dec 2022 14:44:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672238649;
        bh=wwJqw7r0E5qSEulWrVzFv3tfpqQK0Zr73ES4oHkJiBM=;
        h=From:To:Cc:Subject:Date:From;
        b=uThH1B6vhE0Dua7TTktQJCV2Zi/KCFtxrM43KFEKwQUyo56IVpwuLrftj9hY3KAJn
         3EDCfeTQ0OPF73dZD4QlDM5IYI75NAlN0astRbUHUUv5TUDJQ05kUwEhPiJ/ao0DBE
         5367kxyrQVHA1D0PsRVQQvRQGJsJB/c1ejXsXOR4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 5.15 000/731] 5.15.86-rc1 review
Date:   Wed, 28 Dec 2022 15:31:47 +0100
Message-Id: <20221228144256.536395940@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.86-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.86-rc1
X-KernelTest-Deadline: 2022-12-30T14:43+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.86 release.
There are 731 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 30 Dec 2022 14:41:39 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.86-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.86-rc1

Yassine Oudjana <y.oudjana@protonmail.com>
    extcon: usbc-tusb320: Call the Type-C IRQ handler only if a port is registered

Lin Ma <linma@zju.edu.cn>
    media: dvbdev: fix refcnt bug

Lin Ma <linma@zju.edu.cn>
    media: dvbdev: fix build warning due to comments

Gaosheng Cui <cuigaosheng1@huawei.com>
    net: stmmac: fix errno when create_singlethread_workqueue() fails

Arun Easi <aeasi@marvell.com>
    scsi: qla2xxx: Fix crash when I/O abort times out

Filipe Manana <fdmanana@suse.com>
    btrfs: do not BUG_ON() on ENOMEM when dropping extent items for a range

Chen Zhongjin <chenzhongjin@huawei.com>
    ovl: fix use inode directly in rcu-walk mode

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    fbdev: fbcon: release buffer when fbcon_do_set_font() failed

Rickard x Andersson <rickaran@axis.com>
    gcov: add support for checksum field

Yuan Can <yuancan@huawei.com>
    floppy: Fix memory leak in do_floppy_init()

Johan Hovold <johan+linaro@kernel.org>
    regulator: core: fix deadlock on regulator enable

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    iio: adc128s052: add proper .data members in adc128_of_match table

Nuno Sá <nuno.sa@analog.com>
    iio: adc: ad_sigma_delta: do not use internal iio_dev lock

Zeng Heng <zengheng4@huawei.com>
    iio: fix memory leak in iio_device_register_eventset()

Roberto Sassu <roberto.sassu@huawei.com>
    reiserfs: Add missing calls to reiserfs_security_free()

Nathan Chancellor <nathan@kernel.org>
    security: Restrict CONFIG_ZERO_CALL_USED_REGS to gcc or clang > 15.0.6

Schspa Shi <schspa@gmail.com>
    9p: set req refcount to zero to avoid uninitialized usage

Isaac J. Manjarres <isaacmanjarres@google.com>
    loop: Fix the max_loop commandline argument treatment when it is set to 0

Enrik Berkhan <Enrik.Berkhan@inka.de>
    HID: mcp2221: don't connect hidraw

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Ensure bootloader PID is usable in hidraw mode

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: Prevent infinite loop in transaction errors recovery for streams

Ferry Toth <ftoth@exalondelft.nl>
    usb: dwc3: core: defer probe on ulpi_read_id timeout

Sven Peter <sven@svenpeter.dev>
    usb: dwc3: Fix race between dwc3_set_mode and __dwc3_set_mode

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sm8250: fix USB-DP PHY registers

Chunfeng Yun <chunfeng.yun@mediatek.com>
    usb: xhci-mtk: fix leakage of shared hcd when fail to set wakeup irq

Pawel Laszczak <pawell@cadence.com>
    usb: cdnsp: fix lack of ZLP for ep0

Jiao Zhou <jiaozhou@google.com>
    ALSA: hda/hdmi: Add HP Device 0x8711 to force connect list

Edward Pacman <edward@edward-p.xyz>
    ALSA: hda/realtek: Add quirk for Lenovo TianYi510Pro-14IOB

wangdicheng <wangdicheng@kylinos.cn>
    ALSA: usb-audio: add the quirk for KT0206 device

GUO Zihua <guozihua@huawei.com>
    ima: Simplify ima_lsm_copy_rule

John Stultz <jstultz@google.com>
    pstore: Make sure CONFIG_PSTORE_PMSG selects CONFIG_RT_MUTEXES

David Howells <dhowells@redhat.com>
    afs: Fix lost servers_outstanding count

Yang Jihong <yangjihong1@huawei.com>
    perf debug: Set debug_peo_args and redirect_to_stderr variable to correct values in perf_quiet_option()

John Stultz <jstultz@google.com>
    pstore: Switch pmsg_lock to an rt_mutex to avoid priority inversion

Kees Cook <keescook@chromium.org>
    LoadPin: Ignore the "contents" argument of the LSM hooks

Khaled Almahallawy <khaled.almahallawy@intel.com>
    drm/i915/display: Don't disable DDI/Transcoder when setting phy test pattern

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5670: Remove unbalanced pm_runtime_put()

Wang Jingjin <wangjingjin1@huawei.com>
    ASoC: rockchip: spdif: Add missing clk_disable_unprepare() in rk_spdif_runtime_resume()

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: wm8994: Fix potential deadlock

Wang Yufen <wangyufen@huawei.com>
    ASoC: mediatek: mt8183: fix refcount leak in mt8183_mt6358_ts3a227_max98357_dev_probe()

Wang Jingjin <wangjingjin1@huawei.com>
    ASoC: rockchip: pdm: Add missing clk_disable_unprepare() in rockchip_pdm_runtime_resume()

Wang Yufen <wangyufen@huawei.com>
    ASoC: audio-graph-card: fix refcount leak of cpu_ep in __graph_for_each_link()

Wang Yufen <wangyufen@huawei.com>
    ASoC: mediatek: mt8173-rt5650-rt5514: fix refcount leak in mt8173_rt5650_rt5514_dev_probe()

Cezary Rojewski <cezary.rojewski@intel.com>
    ASoC: Intel: Skylake: Fix driver hang during shutdown

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA: hda: add snd_hdac_stop_streams() helper

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ALSA/ASoC: hda: move/rename snd_hdac_ext_stop_streams to hdac_stream.c

Yang Yingliang <yangyingliang@huawei.com>
    hwmon: (jc42) Fix missing unlock on error in jc42_write()

Tyler Hicks <code@tyhicks.com>
    KVM: selftests: Fix build regression by using accessor function

Karolina Drobnik <karolinadrobnik@gmail.com>
    tools/include: Add _RET_IP_ and math definitions to kernel.h

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    orangefs: Fix kmemleak in orangefs_{kernel,client}_debug_init()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    orangefs: Fix kmemleak in orangefs_prepare_debugfs_help_string()

Nathan Chancellor <nathan@kernel.org>
    drm/sti: Fix return type of sti_{dvo,hda,hdmi}_connector_mode_valid()

Nathan Chancellor <nathan@kernel.org>
    drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()

Hawkins Jiawei <yin31149@gmail.com>
    hugetlbfs: fix null-ptr-deref in hugetlbfs_parse_param()

Nathan Chancellor <nathan@kernel.org>
    scsi: elx: libefc: Fix second parameter type in state callbacks

Bart Van Assche <bvanassche@acm.org>
    scsi: ufs: Reduce the START STOP UNIT timeout

Justin Tee <justin.tee@broadcom.com>
    scsi: lpfc: Fix hard lockup when reading the rx_monitor from debugfs

Zhiqi Song <songzhiqi1@huawei.com>
    crypto: hisilicon/hpre - fix resource leak in remove process

Xiu Jianfeng <xiujianfeng@huawei.com>
    clk: st: Fix memory leak in st_of_quadfs_setup()

Shigeru Yoshida <syoshida@redhat.com>
    media: si470x: Fix use-after-free in si470x_int_in_callback()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: renesas_sdhi: better reset from HS400 mode

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    mmc: f-sdh30: Add quirks for broken timeout clock capability

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: do not run mt76u_status_worker if the device is not running

Rui Zhang <zr.zhang@vivo.com>
    regulator: core: fix use_count leakage when handling boot-on

Andrii Nakryiko <andrii@kernel.org>
    libbpf: Avoid enum forward-declarations in public API in C++ mode

Wesley Chalmers <Wesley.Chalmers@amd.com>
    drm/amd/display: Use the largest vready_offset in pipe group

Ye Bin <yebin10@huawei.com>
    blk-mq: fix possible memleak when register 'hctx' failed

Mazin Al Haddad <mazinalhaddad05@gmail.com>
    media: dvb-usb: fix memory leak in dvb_usb_adapter_init()

Lin Ma <linma@zju.edu.cn>
    media: dvbdev: adopts refcnt to avoid UAF

Yan Lei <yan_lei@dahuatech.com>
    media: dvb-frontends: fix leak of memory fw

Maxim Korotkov <korotkov.maxim.s@gmail.com>
    ethtool: avoiding integer overflow in ethtool_phys_id()

Stanislav Fomichev <sdf@google.com>
    bpf: Prevent decl_tag from being referenced in func_proto arg

Stanislav Fomichev <sdf@google.com>
    ppp: associate skb with a device at tx

Schspa Shi <schspa@gmail.com>
    mrp: introduce active flags to prevent UAF when applicant uninit

Eric Dumazet <edumazet@google.com>
    ipv6/sit: use DEV_STATS_INC() to avoid data-races

Eric Dumazet <edumazet@google.com>
    net: add atomic_long_t to net_device_stats fields

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd/display: fix array index out of bound error in bios parser

Jiang Li <jiang.li@ugreen.com>
    md/raid1: stop mdx_raid1 thread when raid1 array run failed

Li Zhong <floridsleeves@gmail.com>
    drivers/md/md-bitmap: check the return value of md_bitmap_get_counter()

Nathan Chancellor <nathan@kernel.org>
    drm/mediatek: Fix return type of mtk_hdmi_bridge_mode_valid()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/sti: Use drm_mode_copy()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/rockchip: Use drm_mode_copy()

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/msm: Use drm_mode_copy()

Nathan Chancellor <nathan@kernel.org>
    s390/lcs: Fix return type of lcs_start_xmit()

Nathan Chancellor <nathan@kernel.org>
    s390/netiucv: Fix return type of netiucv_tx()

Nathan Chancellor <nathan@kernel.org>
    s390/ctcm: Fix return type of ctc{mp,}m_tx()

Nathan Chancellor <nathan@kernel.org>
    drm/amdgpu: Fix type of second parameter in odn_edit_dpm_table() callback

Nathan Chancellor <nathan@kernel.org>
    drm/amdgpu: Fix type of second parameter in trans_msg() callback

Kees Cook <keescook@chromium.org>
    igb: Do not free q_vector unless new one was allocated

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    wifi: brcmfmac: Fix potential shift-out-of-bounds in brcmf_fw_alloc_request()

Nathan Chancellor <nathan@kernel.org>
    hamradio: baycom_epp: Fix return type of baycom_send_packet()

Nathan Chancellor <nathan@kernel.org>
    net: ethernet: ti: Fix return type of netcp_ndo_start_xmit()

Stanislav Fomichev <sdf@google.com>
    bpf: make sure skb->len != 0 when redirecting to a tunneling device

Jiri Slaby (SUSE) <jirislaby@kernel.org>
    qed (gcc13): use u16 for fid to be big enough

Hamza Mahfooz <hamza.mahfooz@amd.com>
    Revert "drm/amd/display: Limit max DSC target bpp for specific monitors"

gehao <gehao@kylinos.cn>
    drm/amd/display: prevent memory leak

Zhang Yuchen <zhangyuchen.lcr@bytedance.com>
    ipmi: fix memleak when unload ipmi driver

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: codecs: rt298: Add quirk for KBL-R RVP platform

Shigeru Yoshida <syoshida@redhat.com>
    wifi: ar5523: Fix use-after-free on ar5523_cmd() timed out

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: ath9k: verify the expected usb_endpoints are present

Wright Feng <wright.feng@cypress.com>
    brcmfmac: return error when getting invalid max_flowrings from dongle

Ming Qian <ming.qian@nxp.com>
    media: imx-jpeg: Disable useless interrupt to avoid kernel panic

Doug Brown <doug@schmorgal.com>
    drm/etnaviv: add missing quirks for GC300

ZhangPeng <zhangpeng362@huawei.com>
    hfs: fix OOB Read in __hfs_brec_find

Zheng Yejian <zhengyejian1@huawei.com>
    acct: fix potential integer overflow in encode_comp_t()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix shift-out-of-bounds due to too large exponent of block size

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix shift-out-of-bounds/overflow in nilfs_sb2_bad_offset()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Fix error code path in acpi_ds_call_control_method()

Hoi Pok Wu <wuhoipok@gmail.com>
    fs: jfs: fix shift-out-of-bounds in dbDiscardAG

Dr. David Alan Gilbert <linux@treblig.org>
    jfs: Fix fortify moan in symlink

Shigeru Yoshida <syoshida@redhat.com>
    udf: Avoid double brelse() in udf_rename()

Dongliang Mu <mudongliangabcd@gmail.com>
    fs: jfs: fix shift-out-of-bounds in dbAllocAG

Liu Shixin <liushixin2@huawei.com>
    binfmt_misc: fix shift-out-of-bounds in check_special_flags

Gaurav Kohli <gauravkohli@linux.microsoft.com>
    x86/hyperv: Remove unregister syscore call from Hyper-V cleanup

Guilherme G. Piccoli <gpiccoli@igalia.com>
    video: hyperv_fb: Avoid taking busy spinlock on panic path

Mark Rutland <mark.rutland@arm.com>
    arm64: make is_ttbrX_addr() noinstr-safe

Zqiang <qiang1.zhang@intel.com>
    rcu: Fix __this_cpu_read() lockdep warning in rcu_force_quiescent_state()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    HID: amd_sfh: Add missing check for dma_alloc_coherent

Eric Dumazet <edumazet@google.com>
    net: stream: purge sk_error_queue in sk_stream_kill_queues()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    myri10ge: Fix an error handling path in myri10ge_probe()

David Howells <dhowells@redhat.com>
    rxrpc: Fix missing unlock in rxrpc_do_sendmsg()

Cong Wang <cong.wang@bytedance.com>
    net_sched: reject TCF_EM_SIMPLE case for complex ematch module

Yang Yingliang <yangyingliang@huawei.com>
    mailbox: zynq-ipi: fix error handling while device_register() fails

Yang Yingliang <yangyingliang@huawei.com>
    mailbox: arm_mhuv2: Fix return value check in mhuv2_probe()

Conor Dooley <conor.dooley@microchip.com>
    mailbox: mpfs: read the system controller's status

Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
    skbuff: Account for tail adjustment during pull operations

Chen-Yu Tsai <wenst@chromium.org>
    arm64: dts: mt8183: Fix Mali GPU clock

Chun-Jie Chen <chun-jie.chen@mediatek.com>
    soc: mediatek: pm-domains: Fix the power glitch issue

Eelco Chaudron <echaudro@redhat.com>
    openvswitch: Fix flow lookup to use unmasked key

Jakub Kicinski <kuba@kernel.org>
    selftests: devlink: fix the fd redirect in dummy_reporter_test

GUO Zihua <guozihua@huawei.com>
    rtc: mxc_v2: Add missing clk_disable_unprepare()

Tan Tee Min <tee.min.tan@linux.intel.com>
    igc: Set Qbv start_time and end_time to end_time if not being configured in GCL

Kurt Kanzenbach <kurt@linutronix.de>
    igc: Lift TAPRIO schedule restriction

Tan Tee Min <tee.min.tan@linux.intel.com>
    igc: recalculate Qbv end_time by considering cycle time

Tan Tee Min <tee.min.tan@linux.intel.com>
    igc: allow BaseTime 0 enrollment for Qbv

Muhammad Husaini Zulkifli <muhammad.husaini.zulkifli@intel.com>
    igc: Add checking for basetime less than zero

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    igc: Use strict cycles for Qbv scheduling

Vinicius Costa Gomes <vinicius.gomes@intel.com>
    igc: Enhance Qbv scheduling by using first flag bit

Christoph Hellwig <hch@lst.de>
    blk-iocost: simplify ioc_name

Li Zetao <lizetao1@huawei.com>
    r6040: Fix kmemleak in probe and remove

Kirill Tkhai <tkhai@ya.ru>
    unix: Fix race in SOCK_SEQPACKET's unix_dgram_sendmsg()

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    nfc: pn533: Clear nfc_target before being used

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: enetc: avoid buffer leaks on xdp_do_redirect() failure

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    selftests/bpf: Add test for unstable CT lookup API

Yu Kuai <yukuai3@huawei.com>
    block, bfq: fix possible uaf for 'bfqq->bic'

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: hfcmulti: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: hfcpci: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: hfcsusb: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()

Emeel Hakim <ehakim@nvidia.com>
    net: macsec: fix net device access prior to holding a lock

Dan Aloni <dan.aloni@vastdata.com>
    nfsd: under NFSv4.1, fix double svc_xprt_put on rpc_create failure

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: pcf85063: fix pcf85063_clkout_control

Gaosheng Cui <cuigaosheng1@huawei.com>
    rtc: pic32: Move devm_rtc_allocate_device earlier in pic32_rtc_probe()

Gaosheng Cui <cuigaosheng1@huawei.com>
    rtc: st-lpc: Add missing clk_disable_unprepare in st_rtc_probe()

Qingfang DENG <dqfext@gmail.com>
    netfilter: flowtable: really fix NAT IPv6 offload

Yang Yingliang <yangyingliang@huawei.com>
    mfd: pm8008: Fix return value check in pm8008_probe()

Lee Jones <lee.jones@linaro.org>
    mfd: pm8008: Remove driver data structure pm8008_data

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mfd: qcom_rpm: Fix an error handling path in qcom_rpm_probe()

Matti Vaittinen <matti.vaittinen@fi.rohmeurope.com>
    mfd: bd957x: Fix Kconfig dependency on REGMAP_IRQ

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/pseries/eeh: use correct API for error log size

Haowen Bai <baihaowen@meizu.com>
    powerpc/eeh: Drop redundant spinlock initialization

Shang XiaoJing <shangxiaojing@huawei.com>
    remoteproc: qcom: q6v5: Fix missing clk_disable_unprepare() in q6v5_wcss_qcs404_power_on()

Yuan Can <yuancan@huawei.com>
    remoteproc: qcom_q6v5_pas: Fix missing of_node_put() in adsp_alloc_memory_region()

Luca Weiss <luca.weiss@fairphone.com>
    remoteproc: qcom_q6v5_pas: detach power domains on remove

Luca Weiss <luca.weiss@fairphone.com>
    remoteproc: qcom_q6v5_pas: disable wakeup on probe fail or remove

Shang XiaoJing <shangxiaojing@huawei.com>
    remoteproc: qcom: q6v5: Fix potential null-ptr-deref in q6v5_wcss_init_mmio()

Gaosheng Cui <cuigaosheng1@huawei.com>
    remoteproc: sysmon: fix memory leak in qcom_add_sysmon_subdev()

Daniel Golle <daniel@makrotopia.org>
    pwm: mediatek: always use bus clock for PWM on MT7622

xinlei lee <xinlei.lee@mediatek.com>
    pwm: mtk-disp: Fix the parameters calculated by the enabled flag of disp_pwm

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    pwm: sifive: Call pwm_sifive_update_clock() while mutex is held

Jason Gunthorpe <jgg@ziepe.ca>
    iommu/sun50i: Remove IOMMU_DOMAIN_IDENTITY

Miaoqian Lin <linmq006@gmail.com>
    selftests/powerpc: Fix resource leaks

Kajol Jain <kjain@linux.ibm.com>
    powerpc/hv-gpci: Fix hv_gpci event list

Yang Yingliang <yangyingliang@huawei.com>
    powerpc/83xx/mpc832x_rdb: call platform_device_put() in error case in of_fsl_spi_probe()

Nicholas Piggin <npiggin@gmail.com>
    powerpc/perf: callchain validate kernel stack pointer bounds

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    phy: qcom-qmp: create copies of QMP PHY driver

Yang Yingliang <yangyingliang@huawei.com>
    powerpc/xive: add missing iounmap() in error path in xive_spapr_populate_irq_data()

Gustavo A. R. Silva <gustavoars@kernel.org>
    powerpc/xmon: Fix -Wswitch-unreachable warning in bpt_cmds

Miaoqian Lin <linmq006@gmail.com>
    cxl: Fix refcount leak in cxl_calc_capp_routing

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    powerpc/52xx: Fix a resource leak in an error handling path

Xie Shaowen <studentxswpy@163.com>
    macintosh/macio-adb: check the return value of ioremap()

Yang Yingliang <yangyingliang@huawei.com>
    macintosh: fix possible memory leak in macio_add_one_device()

Yuan Can <yuancan@huawei.com>
    iommu/fsl_pamu: Fix resource leak in fsl_pamu_probe()

Yang Yingliang <yangyingliang@huawei.com>
    iommu/amd: Fix pci device refcount leak in ppr_notifier()

Alexander Stein <alexander.stein@ew.tq-group.com>
    rtc: pcf85063: Fix reading alarm

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    rtc: snvs: Allow a time difference on clock register read

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Disable ACPI RTC event on removal

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Rename ACPI-related functions

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Eliminate forward declarations of some functions

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Call rtc_wake_setup() from cmos_do_probe()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Call cmos_wake_setup() from cmos_do_probe()

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: cmos: fix build on non-ACPI platforms

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Fix wake alarm breakage

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: cmos: Fix event handler registration ordering issue

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    rtc: rtc-cmos: Do not check ACPI_FADT_LOW_POWER_S0

Fenghua Yu <fenghua.yu@intel.com>
    dmaengine: idxd: Fix crc_val field for completion record

Abdun Nihaal <abdun.nihaal@gmail.com>
    fs/ntfs3: Fix slab-out-of-bounds read in ntfs_trim_fs

Jon Hunter <jonathanh@nvidia.com>
    pwm: tegra: Improve required rate calculation

Matt Redfearn <matt.redfearn@mips.com>
    include/uapi/linux/swab: Fix potentially missing __always_inline

Al Cooper <alcooperx@gmail.com>
    phy: usb: s2 WoL wakeup_count not incremented for USB->Eth devices

Michael Riesch <michael.riesch@wolfvision.net>
    iommu/rockchip: fix permission bits in page table entries v2

Jernej Skrabec <jernej.skrabec@gmail.com>
    iommu/sun50i: Fix flush size

Jernej Skrabec <jernej.skrabec@gmail.com>
    iommu/sun50i: Fix R/W permission check

Jernej Skrabec <jernej.skrabec@gmail.com>
    iommu/sun50i: Consider all fault sources for reset

Jernej Skrabec <jernej.skrabec@gmail.com>
    iommu/sun50i: Fix reset release

Dan Carpenter <dan.carpenter@oracle.com>
    fs/ntfs3: Harden against integer overflows

Kees Cook <keescook@chromium.org>
    overflow: Implement size_t saturating arithmetic helpers

Shigeru Yoshida <syoshida@redhat.com>
    fs/ntfs3: Avoid UBSAN error on true_sectors_per_clst()

Arnd Bergmann <arnd@arndb.de>
    RDMA/siw: Fix pointer cast warning

Namhyung Kim <namhyung@kernel.org>
    perf stat: Do not delay the workload with --delay

Adrián Herrera Arcila <adrian.herrera@arm.com>
    perf stat: Refactor __run_perf_stat() common code

ruanjinjie <ruanjinjie@huawei.com>
    power: supply: fix null pointer dereferencing in power_supply_get_battery_info

Yuan Can <yuancan@huawei.com>
    power: supply: ab8500: Fix error handling in ab8500_charger_init()

Yuan Can <yuancan@huawei.com>
    HSI: omap_ssi_core: Fix error handling in ssi_init()

Zhang Qilong <zhangqilong3@huawei.com>
    power: supply: z2_battery: Fix possible memleak in z2_batt_probe()

Ajay Kaher <akaher@vmware.com>
    perf symbol: correction while adjusting symbol

Leo Yan <leo.yan@linaro.org>
    perf trace: Handle failure when trace point folder is missed

Leo Yan <leo.yan@linaro.org>
    perf trace: Use macro RAW_SYSCALL_ARGS_NUM to replace number

Leo Yan <leo.yan@linaro.org>
    perf trace: Return error if a system call doesn't exist

Zeng Heng <zengheng4@huawei.com>
    power: supply: fix residue sysfs file in error handle route of __power_supply_register()

Yang Yingliang <yangyingliang@huawei.com>
    HSI: omap_ssi_core: fix possible memory leak in ssi_probe()

Yang Yingliang <yangyingliang@huawei.com>
    HSI: omap_ssi_core: fix unbalanced pm_runtime_disable()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    fbdev: uvesafb: Fixes an error handling path in uvesafb_probe()

Randy Dunlap <rdunlap@infradead.org>
    fbdev: uvesafb: don't build on UML

Randy Dunlap <rdunlap@infradead.org>
    fbdev: geode: don't build on UML

Gaosheng Cui <cuigaosheng1@huawei.com>
    fbdev: ep93xx-fb: Add missing clk_disable_unprepare in ep93xxfb_probe()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    fbdev: vermilion: decrease reference count in error path

Shang XiaoJing <shangxiaojing@huawei.com>
    fbdev: via: Fix error in via_core_init()

Yang Yingliang <yangyingliang@huawei.com>
    fbdev: pm2fb: fix missing pci_disable_device()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    fbdev: ssd1307fb: Drop optional dependency

Bjorn Andersson <bjorn.andersson@linaro.org>
    thermal/drivers/qcom/lmh: Fix irq handler return value

Luca Weiss <luca.weiss@fairphone.com>
    thermal/drivers/qcom/temp-alarm: Fix inaccurate warning for gen2

Marcus Folkesson <marcus.folkesson@gmail.com>
    thermal/drivers/imx8mm_thermal: Validate temperature range

Shang XiaoJing <shangxiaojing@huawei.com>
    samples: vfio-mdev: Fix missing pci_disable_device() in mdpy_fb_probe()

Xiu Jianfeng <xiujianfeng@huawei.com>
    ksmbd: Fix resource leak in ksmbd_session_rpc_open()

Zheng Yejian <zhengyejian1@huawei.com>
    tracing/hist: Fix issue of losting command info in error_log

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    usb: storage: Add check for kcalloc

Zheyu Ma <zheyuma97@gmail.com>
    i2c: ismt: Fix an out-of-bounds bug in ismt_access()

Yang Yingliang <yangyingliang@huawei.com>
    i2c: mux: reg: check return value after calling platform_get_resource()

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpiolib: protect the GPIO device against being dropped while in use by user-space

Bartosz Golaszewski <brgl@bgdev.pl>
    gpiolib: make struct comments into real kernel docs

Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
    gpiolib: cdev: fix NULL-pointer dereferences

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    gpiolib: Get rid of redundant 'else'

Chen Zhongjin <chenzhongjin@huawei.com>
    vme: Fix error not catched in fake_init()

YueHaibing <yuehaibing@huawei.com>
    staging: rtl8192e: Fix potential use-after-free in rtllib_rx_Monitor()

Dan Carpenter <error27@gmail.com>
    staging: rtl8192u: Fix use after free in ieee80211_rx()

Hui Tang <tanghui20@huawei.com>
    i2c: pxa-pci: fix missing pci_disable_device() on error in ce4100_i2c_probe

Yang Yingliang <yangyingliang@huawei.com>
    chardev: fix error handling in cdev_device_add()

Yang Yingliang <yangyingliang@huawei.com>
    mcb: mcb-parse: fix error handing in chameleon_parse_gdd()

Zhengchao Shao <shaozhengchao@huawei.com>
    drivers: mcb: fix resource leak in mcb_probe()

John Keeping <john@metanate.com>
    usb: gadget: f_hid: fix refcount leak on error path

John Keeping <john@metanate.com>
    usb: gadget: f_hid: fix f_hidg lifetime vs cdev

Yang Yingliang <yangyingliang@huawei.com>
    usb: roles: fix of node refcount leak in usb_role_switch_is_parent()

Yang Shen <shenyang39@huawei.com>
    coresight: trbe: remove cpuhp instance node before remove cpuhp state

Fabrice Gasnier <fabrice.gasnier@foss.st.com>
    counter: stm32-lptimer-cnt: fix the check on arr and cmp registers update

Ramona Bolboaca <ramona.bolboaca@analog.com>
    iio: adis: add '__adis_enable_irq()' implementation

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio:imu:adis: Move exports into IIO_ADISLIB namespace

Nuno Sá <nuno.sa@analog.com>
    iio: adis: stylistic changes

Nuno Sá <nuno.sa@analog.com>
    iio: adis: handle devices that cannot unmask the drdy pin

Cosmin Tanislav <cosmin.tanislav@analog.com>
    iio: temperature: ltc2983: make bulk write buffer DMA-safe

Yang Yingliang <yangyingliang@huawei.com>
    cxl: fix possible null-ptr-deref in cxl_pci_init_afu|adapter()

Yang Yingliang <yangyingliang@huawei.com>
    cxl: fix possible null-ptr-deref in cxl_guest_init_afu|adapter()

Yang Yingliang <yangyingliang@huawei.com>
    firmware: raspberrypi: fix possible memory leak in rpi_firmware_probe()

Zheng Wang <zyytlz.wz@163.com>
    misc: sgi-gru: fix use-after-free error in gru_set_context_option, gru_fault and gru_handle_user_call_os

ruanjinjie <ruanjinjie@huawei.com>
    misc: tifm: fix possible memory leak in tifm_7xx1_switch_media()

Yang Yingliang <yangyingliang@huawei.com>
    ocxl: fix pci device refcount leak when calling get_function_0()

Yang Yingliang <yangyingliang@huawei.com>
    misc: ocxl: fix possible name leak in ocxl_file_register_afu()

Zhengchao Shao <shaozhengchao@huawei.com>
    test_firmware: fix memory leak in test_firmware_init()

Yuan Can <yuancan@huawei.com>
    serial: sunsab: Fix error handling in sunsab_init()

Gabriel Somlo <gsomlo@gmail.com>
    serial: altera_uart: fix locking in polling mode

Jiri Slaby <jirislaby@kernel.org>
    tty: serial: altera_uart_{r,t}x_chars() need only uart_port

Jiri Slaby <jirislaby@kernel.org>
    tty: serial: clean up stop-tx part in altera_uart_tx_chars()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    serial: pch: Fix PCI device refcount leak in pch_request_dma()

Valentin Caron <valentin.caron@foss.st.com>
    serial: stm32: move dma_request_chan() before clk_prepare_enable()

delisun <delisun@pateo.com.cn>
    serial: pl011: Do not clear RX FIFO & RX interrupt in unthrottle.

Jiamei Xie <jiamei.xie@arm.com>
    serial: amba-pl011: avoid SBSA UART accessing DMACR register

Marek Vasut <marex@denx.de>
    extcon: usbc-tusb320: Update state on probe even if no IRQ pending

Marek Vasut <marex@denx.de>
    extcon: usbc-tusb320: Add USB TYPE-C support

Marek Vasut <marex@denx.de>
    extcon: usbc-tusb320: Factor out extcon into dedicated functions

Samuel Holland <samuel@sholland.org>
    usb: typec: Factor out non-PD fwnode properties

Yassine Oudjana <y.oudjana@protonmail.com>
    extcon: usbc-tusb320: Add support for TUSB320L

Yassine Oudjana <y.oudjana@protonmail.com>
    extcon: usbc-tusb320: Add support for mode setting and reset

Sven Peter <sven@svenpeter.dev>
    usb: typec: tipd: Fix spurious fwnode_handle_put in error path

Sven Peter <sven@svenpeter.dev>
    usb: typec: tipd: Cleanup resources if devm_tps6598_psy_register fails

Yang Yingliang <yangyingliang@huawei.com>
    usb: typec: tcpci: fix of node refcount leak in tcpci_register_port()

Sven Peter <sven@svenpeter.dev>
    usb: typec: Check for ops->exit instead of ops->enter in altmode_exit

Gaosheng Cui <cuigaosheng1@huawei.com>
    staging: vme_user: Fix possible UAF in tsi148_dma_list_add

Linus Walleij <linus.walleij@linaro.org>
    usb: fotg210-udc: Fix ages old endianness issues

Rafael Mendonca <rafaelmendsr@gmail.com>
    uio: uio_dmem_genirq: Fix deadlock between irq config and handling

Rafael Mendonca <rafaelmendsr@gmail.com>
    uio: uio_dmem_genirq: Fix missing unlock in irq configuration

Rafael Mendonca <rafaelmendsr@gmail.com>
    vfio: platform: Do not pass return buffer to ACPI _RST method

Yang Yingliang <yangyingliang@huawei.com>
    class: fix possible memory leak in __class_register()

Yuan Can <yuancan@huawei.com>
    serial: 8250_bcm7271: Fix error handling in brcmuart_init()

Kartik <kkartik@nvidia.com>
    serial: tegra: Read DMA status before terminating

Yang Yingliang <yangyingliang@huawei.com>
    drivers: dio: fix possible memory leak in dio_init()

Palmer Dabbelt <palmer@rivosinc.com>
    RISC-V: Align the shadow stack

Dragos Tatulea <dtatulea@nvidia.com>
    IB/IPoIB: Fix queue count inconsistency for PKEY child interfaces

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    hwrng: geode - Fix PCI device refcount leak

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    hwrng: amd - Fix PCI device refcount leak

Gaosheng Cui <cuigaosheng1@huawei.com>
    crypto: img-hash - Fix variable dereferenced before check 'hdev->req'

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix error code of CMD

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix page size cap from firmware

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix PBL page MTR find

Chengchang Tang <tangchengchang@huawei.com>
    RDMA/hns: Fix AH attr queried by query_qp

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    orangefs: Fix sysfs not cleanup when dev init failed

John Thomson <git@johnthomson.fastmail.com.au>
    PCI: mt7621: Add sentinel to quirks table

Bjorn Helgaas <bhelgaas@google.com>
    PCI: mt7621: Rename mt7621_pci_ to mt7621_pcie_

Wang Yufen <wangyufen@huawei.com>
    RDMA/srp: Fix error return code in srp_parse_options()

Wang Yufen <wangyufen@huawei.com>
    RDMA/hfi1: Fix error return code in parse_platform_config()

Tong Tiangen <tongtiangen@huawei.com>
    riscv/mm: add arch hook arch_clear_hugepage_flags

Shang XiaoJing <shangxiaojing@huawei.com>
    crypto: omap-sham - Use pm_runtime_resume_and_get() in omap_sham_probe()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    crypto: amlogic - Remove kcalloc without check

Mark Zhang <markzhang@nvidia.com>
    RDMA/nldev: Fix failure to send large messages

Yonggil Song <yonggil.song@samsung.com>
    f2fs: avoid victim selection from previous victim section

Yuan Can <yuancan@huawei.com>
    RDMA/nldev: Add checks for nla_nest_start() in fill_stat_counter_qps()

Gaosheng Cui <cuigaosheng1@huawei.com>
    scsi: snic: Fix possible UAF in snic_tgt_create()

Chen Zhongjin <chenzhongjin@huawei.com>
    scsi: fcoe: Fix transport not deattached when fcoe_if_init() fails

Shang XiaoJing <shangxiaojing@huawei.com>
    scsi: ipr: Fix WARNING in ipr_init()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: scsi_debug: Fix possible name leak in sdebug_add_host_helper()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: fcoe: Fix possible name leak when device_register() fails

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    scsi: scsi_debug: Fix a warning in resp_report_zones()

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    scsi: scsi_debug: Fix a warning in resp_verify()

Chen Zhongjin <chenzhongjin@huawei.com>
    scsi: efct: Fix possible memleak in efct_device_init()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: hpsa: Fix possible memory leak in hpsa_add_sas_device()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: hpsa: Fix error handling in hpsa_add_sas_host()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: mpt3sas: Fix possible resource leaks in mpt3sas_transport_port_add()

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: Fix list iterator in padata_do_serial()

Daniel Jordan <daniel.m.jordan@oracle.com>
    padata: Always leave BHs disabled when running ->parallel()

Zhang Yiqun <zhangyiqun@phytium.com.cn>
    crypto: tcrypt - Fix multibuffer skcipher speed test mem leak

Yuan Can <yuancan@huawei.com>
    scsi: hpsa: Fix possible memory leak in hpsa_init_one()

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    dt-bindings: visconti-pcie: Fix interrupts array max constraints

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    dt-bindings: imx6q-pcie: Fix clock names for imx6sx and imx8mq

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    RDMA/rxe: Fix NULL-ptr-deref in rxe_qp_do_cleanup() when socket create failed

Zhengchao Shao <shaozhengchao@huawei.com>
    RDMA/hns: fix memory leak in hns_roce_alloc_mr()

Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
    crypto: ccree - Make cc_debugfs_global_fini() available for module init function

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    RDMA/hfi: Decrease PCI device reference count in error path

Zeng Heng <zengheng4@huawei.com>
    PCI: Check for alloc failure in pci_request_irq()

Luoyouming <luoyouming@huawei.com>
    RDMA/hns: Fix ext_sge num error when post send

Luoyouming <luoyouming@huawei.com>
    RDMA/hns: Repacing 'dseg_len' by macros in fill_ext_sge_inl_data()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    crypto: hisilicon/qm - add missing pci_dev_put() in q_num_set()

Herbert Xu <herbert@gondor.apana.org.au>
    crypto: cryptd - Use request context instead of stack for sub-request

Gaosheng Cui <cuigaosheng1@huawei.com>
    crypto: ccree - Remove debugfs when platform_driver_register failed

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    scsi: scsi_debug: Fix a warning in resp_write_scat()

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Set defined status for work completion with undefined status

Mark Zhang <markzhang@nvidia.com>
    RDMA/nldev: Return "-EAGAIN" if the cm_id isn't from expected port

Mark Zhang <markzhang@nvidia.com>
    RDMA/core: Make sure "ib_port" is valid when access sysfs node

Mark Zhang <markzhang@nvidia.com>
    RDMA/restrack: Release MR restrack when delete

Nirmal Patel <nirmal.patel@linux.intel.com>
    PCI: vmd: Disable MSI remapping after suspend

Leonid Ravich <lravich@gmail.com>
    IB/mad: Don't call to function that might sleep while in atomic context

Bernard Metzler <bmt@zurich.ibm.com>
    RDMA/siw: Fix immediate work request flush to completion queue

Bart Van Assche <bvanassche@acm.org>
    scsi: qla2xxx: Fix set-but-not-used variable warnings

Shiraz Saleem <shiraz.saleem@intel.com>
    RDMA/irdma: Report the correct link speed

Chao Yu <chao@kernel.org>
    f2fs: fix to destroy sbi->post_read_wq in error path of f2fs_fill_super()

Dongdong Zhang <zhangdongdong1@oppo.com>
    f2fs: fix normal discard process

Chao Yu <chao@kernel.org>
    f2fs: fix to invalidate dcc->f2fs_issue_discard in error path

Xiu Jianfeng <xiujianfeng@huawei.com>
    apparmor: Fix memleak in alloc_ns()

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - rework by using crypto_engine

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - remove non-aligned handling

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - better handle cipher key

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - add fallback for ahash

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - add fallback for cipher

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - do not store mode globally

Corentin Labbe <clabbe@baylibre.com>
    crypto: rockchip - do not do custom power management

Zhang Qilong <zhangqilong3@huawei.com>
    f2fs: Fix the race condition of resize flag between resizefs

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    PCI: pci-epf-test: Register notifier if only core_init_notifier is enabled

Leon Romanovsky <leon@kernel.org>
    RDMA/core: Fix order of nldev_exit call

Vidya Sagar <vidyas@nvidia.com>
    PCI: dwc: Fix n_fts[] array overrun

Xiu Jianfeng <xiujianfeng@huawei.com>
    apparmor: Use pointer to struct aa_label for lbs_cred

Bart Van Assche <bvanassche@acm.org>
    scsi: core: Fix a race between scsi_done() and scsi_timeout()

Natalia Petrova <n.petrova@fintech.ru>
    crypto: nitrox - avoid double free on error path in nitrox_sriov_init()

Corentin Labbe <clabbe@baylibre.com>
    crypto: sun8i-ss - use dma_addr instead u32

Weili Qian <qianweili@huawei.com>
    crypto: hisilicon/qm - fix missing destroy qp_idr

John Johansen <john.johansen@canonical.com>
    apparmor: Fix abi check to include v8 abi

John Johansen <john.johansen@canonical.com>
    apparmor: fix lockdep warning when removing a namespace

Gaosheng Cui <cuigaosheng1@huawei.com>
    apparmor: fix a memleak in multi_transaction_new()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: tag_8021q: avoid leaking ctx on dsa_tag_8021q_register() error path

Bartosz Staszewski <bartoszx.staszewski@intel.com>
    i40e: Fix the inability to attach XDP program on downed interface

Piergiorgio Beruto <piergiorgio.beruto@gmail.com>
    stmmac: fix potential division by 0

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: RFCOMM: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: hci_core: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: hci_bcsp: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: hci_h5: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: hci_ll: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: hci_qca: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: btusb: don't call kfree_skb() under spin_lock_irqsave()

Wang ShaoBo <bobo.shaobowang@huawei.com>
    Bluetooth: btintel: Fix missing free skb in btintel_setup_combined()

Inga Stotland <inga.stotland@intel.com>
    Bluetooth: MGMT: Fix error report for ADD_EXT_ADV_PARAMS

Firo Yang <firo.yang@suse.com>
    sctp: sysctl: make extra pointers netns aware

Eric Pilmore <epilmore@gigaio.com>
    ntb_netdev: Use dev_kfree_skb_any() in interrupt context

Jerry Ray <jerry.ray@microchip.com>
    net: lan9303: Fix read error execution path

Markus Schneider-Pargmann <msp@baylibre.com>
    can: tcan4x5x: Fix use of register error status mask

Vivek Yadav <vivek.2311@samsung.com>
    can: m_can: Call the RAM init directly from m_can_chip_config

Markus Schneider-Pargmann <msp@baylibre.com>
    can: tcan4x5x: Remove invalid write in clear_interrupts

Tom Lendacky <thomas.lendacky@amd.com>
    net: amd-xgbe: Check only the minimum speed for active/passive cables

Tom Lendacky <thomas.lendacky@amd.com>
    net: amd-xgbe: Fix logic around active and passive cables

Yang Yingliang <yangyingliang@huawei.com>
    af_unix: call proto_unregister() in the error path in af_unix_init()

Yang Yingliang <yangyingliang@huawei.com>
    net: amd: lance: don't call dev_kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    hamradio: don't call dev_kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    net: ethernet: dnet: don't call dev_kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    net: emaclite: don't call dev_kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    net: apple: bmac: don't call dev_kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    net: apple: mace: don't call dev_kfree_skb() under spin_lock_irqsave()

Hangbin Liu <liuhangbin@gmail.com>
    net/tunnel: wait until all sk_user_data reader finish before releasing the sock

Li Zetao <lizetao1@huawei.com>
    net: farsync: Fix kmemleak when rmmods farsync

Yang Yingliang <yangyingliang@huawei.com>
    ethernet: s2io: don't call dev_kfree_skb() under spin_lock_irqsave()

ruanjinjie <ruanjinjie@huawei.com>
    of: overlay: fix null pointer dereferencing in find_dup_cset_node_entry() and find_dup_cset_prop()

Yuan Can <yuancan@huawei.com>
    drivers: net: qlcnic: Fix potential memory leak in qlcnic_sriov_init()

Gaosheng Cui <cuigaosheng1@huawei.com>
    net: stmmac: fix possible memory leak in stmmac_dvr_probe()

Zhang Changzhong <zhangchangzhong@huawei.com>
    net: stmmac: selftests: fix potential memleak in stmmac_test_arpoffload()

Yongqiang Liu <liuyongqiang13@huawei.com>
    net: defxx: Fix missing err handling in dfx_init()

Artem Chernyshev <artem.chernyshev@red-soft.ru>
    net: vmw_vsock: vmci: Check memcpy_from_msg()

Xiu Jianfeng <xiujianfeng@huawei.com>
    clk: socfpga: Fix memory leak in socfpga_gate_init()

Björn Töpel <bjorn@rivosinc.com>
    bpf: Do not zero-extend kfunc return values

Yang Jihong <yangjihong1@huawei.com>
    blktrace: Fix output non-blktrace event when blk_classic option enabled

Wang Yufen <wangyufen@huawei.com>
    wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix the channel width reporting

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Add __packed to struct rtl8723bu_c2h

Kris Bahnsen <kris@embeddedTS.com>
    spi: spi-gpio: Don't set MOSI as an input if not 3WIRE mode

Xiu Jianfeng <xiujianfeng@huawei.com>
    clk: samsung: Fix memory leak in _samsung_clk_register_pll()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: coda: Add check for kmalloc

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: coda: Add check for dcoda_iram_alloc

Liang He <windhl@126.com>
    media: c8sectpfe: Add of_node_put() when breaking out of loop

Yuan Can <yuancan@huawei.com>
    regulator: qcom-labibb: Fix missing of_node_put() in qcom_labibb_regulator_probe()

Zhen Lei <thunder.leizhen@huawei.com>
    mmc: core: Normalize the error handling branch in sd_read_ext_regs()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    memstick/ms_block: Add check for alloc_ordered_workqueue

Luis Chamberlain <mcgrof@kernel.org>
    memstick: ms_block: Add error handling support for add_disk()

Wolfram Sang <wsa+renesas@sang-engineering.com>
    mmc: renesas_sdhi: alway populate SCC pointer

Yang Yingliang <yangyingliang@huawei.com>
    mmc: mmci: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: wbsd: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: via-sdmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: meson-gx: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: omap_hsmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: atmel-mci: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: wmt-sdmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: vub300: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: toshsd: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: rtsx_usb_sdmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: rtsx_pci: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: pxamci: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: mxcmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: moxart: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: alcor: fix return value check of mmc_add_host()

Pu Lehui <pulehui@huawei.com>
    riscv, bpf: Emit fixed-length instructions for BPF_PSEUDO_FUNC

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.x: Fail client initialisation if state manager thread can't run

Wang ShaoBo <bobo.shaobowang@huawei.com>
    SUNRPC: Fix missing release socket in rpc_sockname()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    xprtrdma: Fix regbuf data not freed in rpcrdma_req_create()

Gaosheng Cui <cuigaosheng1@huawei.com>
    ALSA: mts64: fix possible null-ptr-defer in snd_mts64_interrupt

Liu Shixin <liushixin2@huawei.com>
    media: saa7164: fix missing pci_disable_device()

Takashi Iwai <tiwai@suse.de>
    ALSA: pcm: Set missing stop_operating flag at undoing trigger start

Eric Dumazet <edumazet@google.com>
    bpf, sockmap: fix race in sock_map_free()

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    hwmon: (jc42) Restore the min/max/critical temperatures on resume

Martin Blumenstingl <martin.blumenstingl@googlemail.com>
    hwmon: (jc42) Convert register access and caching to regmap/regcache

Yang Yingliang <yangyingliang@huawei.com>
    regulator: core: fix resource leak in regulator_register()

Chen Zhongjin <chenzhongjin@huawei.com>
    configfs: fix possible memory leak in configfs_create_dir()

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    hsr: Synchronize sequence number updates.

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    hsr: Synchronize sending frames to have always incremented outgoing seq nr.

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    hsr: Disable netpoll.

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    hsr: Avoid double remove of a node.

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    hsr: Add a rcu-read lock to hsr_forward_skb().

Christian Marangi <ansuelsmth@gmail.com>
    clk: qcom: clk-krait: fix wrong div2 functions

Douglas Anderson <dianders@chromium.org>
    clk: qcom: lpass-sc7180: Fix pm_runtime usage

Yang Yingliang <yangyingliang@huawei.com>
    regulator: core: fix module refcount leak in set_supply()

Deren Wu <deren.wu@mediatek.com>
    wifi: mt76: fix coverity overrun-call in mt76_get_txpower()

Lorenzo Bianconi <lorenzo@kernel.org>
    wifi: mt76: mt7921: fix reporting of TX AGGR histogram

Xing Song <xing.song@mediatek.com>
    mt76: stop the radar detector after leaving dfs channel

Chen Zhongjin <chenzhongjin@huawei.com>
    wifi: cfg80211: Fix not unregister reg_pdev when load_builtin_regdb_keys() fails

Zhengchao Shao <shaozhengchao@huawei.com>
    wifi: mac80211: fix memory leak in ieee80211_if_add()

Alexander Sverdlin <alexander.sverdlin@siemens.com>
    spi: spidev: mask SPI_CS_HIGH in SPI_IOC_RD_MODE

Dan Carpenter <error27@gmail.com>
    bonding: uninitialized variable in bond_miimon_inspect()

Pengcheng Yang <yangpc@wangsu.com>
    bpf, sockmap: Fix data loss caused by using apply_bytes on ingress redirect

Pengcheng Yang <yangpc@wangsu.com>
    bpf, sockmap: Fix missing BPF_F_INGRESS flag when using apply_bytes

Pengcheng Yang <yangpc@wangsu.com>
    bpf, sockmap: Fix repeated calls to sock_put() when msg has more_data

Randy Dunlap <rdunlap@infradead.org>
    Input: wistron_btns - disable on UML

Florian Westphal <fw@strlen.de>
    netfilter: conntrack: set icmpv6 redirects as RELATED

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: pcm512x: Fix PM disable depth imbalance in pcm512x_probe

Konstantin Meskhidze <konstantin.meskhidze@huawei.com>
    drm/amdkfd: Fix memory leakage

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    drm/amdgpu: Fix PCI device refcount leak in amdgpu_atrm_get_bios()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    drm/radeon: Fix PCI device refcount leak in radeon_atrm_get_bios()

Guchun Chen <guchun.chen@amd.com>
    drm/amd/pm/smu11: BACO is supported when it's in BACO state

Ricardo Ribalda <ribalda@chromium.org>
    ASoC: mediatek: mt8173: Enable IRQ when pdata is ready

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    ASoC: mediatek: mt8173: Fix debugfs registration for components

Ben Greear <greearb@candelatech.com>
    wifi: iwlwifi: mvm: fix double free on tx path.

Liu Shixin <liushixin2@huawei.com>
    ALSA: asihpi: fix missing pci_disable_device()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFS: Fix an Oops in nfs_d_automount()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix a deadlock between nfs4_open_recover_helper() and delegreturn

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix a credential leak in _nfs4_discover_trunking()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Fix initialisation of struct nfs4_label

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Fix a memory stomp in decode_attr_security_label

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Clear FATTR4_WORD2_SECURITY_LABEL when done decoding

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    ASoC: mediatek: mtk-btcvsd: Add checks for write and read of mtk_btcvsd_snd

Dmitry Torokhov <dmitry.torokhov@gmail.com>
    ASoC: dt-bindings: wcd9335: fix reset line polarity in example

Zhang Zekun <zhangzekun11@huawei.com>
    drm/tegra: Add missing clk_disable_unprepare() in tegra_dc_probe()

Aakarsh Jain <aakarsh.jain@samsung.com>
    media: s5p-mfc: Add variant data for MFC v7 hardware for Exynos 3250 SoC

Baisong Zhong <zhongbaisong@huawei.com>
    media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()

Chen Zhongjin <chenzhongjin@huawei.com>
    media: dvb-core: Fix ignored return value in dvb_register_frontend()

ZhangPeng <zhangpeng362@huawei.com>
    pinctrl: pinconf-generic: add missing of_node_put()

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    clk: imx8mn: fix imx8mn_enet_phy_sels clocks list

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    clk: imx8mn: fix imx8mn_sai2_sels clocks list

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    clk: imx: replace osc_hdmi with dummy

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    clk: imx8mn: rename vpu_pll to m7_alt_pll

Gautam Menghani <gautammenghani201@gmail.com>
    media: imon: fix a race condition in send_packet()

Chen Zhongjin <chenzhongjin@huawei.com>
    media: vimc: Fix wrong function called when vimc_init() fails

Yuan Can <yuancan@huawei.com>
    ASoC: qcom: Add checks for devm_kcalloc

Wang ShaoBo <bobo.shaobowang@huawei.com>
    drbd: destroy workqueue when drbd device was freed

Wang ShaoBo <bobo.shaobowang@huawei.com>
    drbd: remove call to memset before free device/resource/connection

Zheng Yongjun <zhengyongjun3@huawei.com>
    mtd: maps: pxa2xx-flash: fix memory leak in probe

Jonathan Toppins <jtoppins@redhat.com>
    bonding: fix link recovery in mode 2 when updelay is nonzero

Yang Yingliang <yangyingliang@huawei.com>
    drm/amdgpu: fix pci device refcount leak

Xiu Jianfeng <xiujianfeng@huawei.com>
    clk: rockchip: Fix memory leak in rockchip_clk_register_pll()

Wang ShaoBo <bobo.shaobowang@huawei.com>
    regulator: core: use kfree_const() to free space conditionally

Baisong Zhong <zhongbaisong@huawei.com>
    ALSA: seq: fix undefined behavior in bit shift for SNDRV_SEQ_FILTER_USE_EVENT

Baisong Zhong <zhongbaisong@huawei.com>
    ALSA: pcm: fix undefined behavior in bit shift for SNDRV_PCM_RATE_KNOT

ZhangPeng <zhangpeng362@huawei.com>
    pinctrl: k210: call of_node_put()

Marcus Folkesson <marcus.folkesson@gmail.com>
    HID: hid-sensor-custom: set fixed size for custom attributes

Stanislav Fomichev <sdf@google.com>
    bpf: Move skb->len == 0 checks into __bpf_redirect

Allen-KH Cheng <allen-kh.cheng@mediatek.com>
    mtd: spi-nor: Fix the number of bytes for the dummy cycles

Michael Walle <michael@walle.cc>
    mtd: spi-nor: hide jedec_id sysfs attribute if not present

Eric Dumazet <edumazet@google.com>
    inet: add READ_ONCE(sk->sk_bound_dev_if) in inet_csk_bind_conflict()

Christoph Hellwig <hch@lst.de>
    media: videobuf-dma-contig: use dma_mmap_coherent

Yuan Can <yuancan@huawei.com>
    media: platform: exynos4-is: Fix error handling in fimc_md_init()

Yang Yingliang <yangyingliang@huawei.com>
    media: solo6x10: fix possible memory leak in solo_sysfs_init()

Chen Zhongjin <chenzhongjin@huawei.com>
    media: vidtv: Fix use-after-free in vidtv_bridge_dvb_init()

Douglas Anderson <dianders@chromium.org>
    Input: elants_i2c - properly handle the reset GPIO when power is off

Hui Tang <tanghui20@huawei.com>
    mtd: lpddr2_nvm: Fix possible null-ptr-deref

Rob Clark <robdclark@chromium.org>
    drm/msm/a6xx: Fix speed-bin detection vs probe-defer

Xiu Jianfeng <xiujianfeng@huawei.com>
    wifi: ath10k: Fix return value in ath10k_pci_init()

Christoph Hellwig <hch@lst.de>
    block: clear ->slave_dir when dropping the main slave_dir reference

Xiu Jianfeng <xiujianfeng@huawei.com>
    ima: Fix misuse of dereference of pointer in template_desc_init_fields()

GUO Zihua <guozihua@huawei.com>
    integrity: Fix memory leakage in keyring allocation error path

Brian Starkey <brian.starkey@arm.com>
    drm/fourcc: Fix vsub/hsub for Q410 and Q401

Dave Stevenson <dave.stevenson@raspberrypi.com>
    drm/fourcc: Add packed 10bit YUV 4:2:0 format

Konrad Dybcio <konrad.dybcio@linaro.org>
    regulator: qcom-rpmh: Fix PMR735a S3 regulator spec

Joel Granados <j.granados@samsung.com>
    nvme: return err on nvme_init_non_mdts_limits fail

Dan Carpenter <error27@gmail.com>
    amdgpu/pm: prevent array underflow in vega20_odn_edit_dpm_table()

Yang Yingliang <yangyingliang@huawei.com>
    regulator: core: fix unbalanced of node refcount in regulator_dev_lookup()

Christoph Hellwig <hch@lst.de>
    nvmet: only allocate a single slab for bvecs

David Michael <fedora.dm0@gmail.com>
    libbpf: Fix uninitialized warning in btf_dump_dump_type_data

Zeng Heng <zengheng4@huawei.com>
    ASoC: pxa: fix null-pointer dereference in filter()

Xinlei Lee <xinlei.lee@mediatek.com>
    drm/mediatek: Modify dpi power on/off sequence.

Hanjun Guo <guohanjun@huawei.com>
    drm/radeon: Add the missed acpi_put_table() to fix memory leak

Khazhismel Kumykov <khazhy@chromium.org>
    bfq: fix waker_bfqq inconsistency crash

David Howells <dhowells@redhat.com>
    rxrpc: Fix ack.bufferSize to be 0 when generating an ack

David Howells <dhowells@redhat.com>
    net, proc: Provide PROC_FS=n fallback for proc_create_net_single_write()

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    media: camss: Clean up received buffers on failed start of streaming

Marek Vasut <marex@denx.de>
    wifi: rsi: Fix handling of 802.3 EAPOL frames sent via control port

Randy Dunlap <rdunlap@infradead.org>
    Input: joystick - fix Kconfig warning for JOYSTICK_ADC

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    mtd: Fix device name leak when register device failed in add_mtd_device()

Manivannan Sadhasivam <mani@kernel.org>
    clk: qcom: gcc-sm8250: Use retention mode for USB GDSCs

Andrii Nakryiko <andrii@kernel.org>
    bpf: propagate precision across all frames, not just the last one

Martin KaFai Lau <kafai@fb.com>
    bpf: Check the other end of slot_type for STACK_SPILL

Andrii Nakryiko <andrii@kernel.org>
    bpf: propagate precision in ALU/ALU64 operations

Yang Yingliang <yangyingliang@huawei.com>
    media: platform: exynos4-is: fix return value check in fimc_md_probe()

Liu Shixin <liushixin2@huawei.com>
    media: vivid: fix compose size exceed boundary

Kumar Kartikeya Dwivedi <memxor@gmail.com>
    bpf: Fix slot type check in check_stack_write_var_off

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/hdmi: use devres helper for runtime PM management

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    drm/msm/hdmi: drop unused GPIO support

GUO Zihua <guozihua@huawei.com>
    ima: Handle -ESTALE returned by ima_filter_rule_match()

Marek Vasut <marex@denx.de>
    drm/panel/panel-sitronix-st7701: Remove panel on DSI attach failure

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    spi: Update reference to struct spi_controller

Marek Vasut <marex@denx.de>
    clk: renesas: r9a06g032: Repair grave increment error

Zhang Qilong <zhangqilong3@huawei.com>
    drm/rockchip: lvds: fix PM usage counter unbalance in poweron

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: Compare requested bittiming parameters with actual parameters in do_set_{,data}_bittiming

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: Add struct kvaser_usb_busparams

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Fix bogus restart events

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Fix wrong CAN state after stopping

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Fix improved state not being reported

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: make use of units.h in assignment of frequency

Anssi Hannula <anssi.hannula@bitwise.fi>
    can: kvaser_usb_leaf: Set Warning state even without bus errors

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: kvaser_usb_leaf: Handle CMD_ERROR_EVENT

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: kvaser_usb_leaf: Rename {leaf,usbcan}_cmd_error_event to {leaf,usbcan}_cmd_can_error_event

Jimmy Assarsson <extja@kvaser.com>
    can: kvaser_usb: kvaser_usb_leaf: Get capabilities from device

Vincent Mailhol <mailhol.vincent@wanadoo.fr>
    can: kvaser_usb: do not increase tx statistics when sending error message frames

Alan Maguire <alan.maguire@oracle.com>
    libbpf: Btf dedup identical struct test needs check for nested structs/arrays

Marek Szyprowski <m.szyprowski@samsung.com>
    media: exynos4-is: don't rely on the v4l2_async_subdev internals

Kuniyuki Iwashima <kuniyu@amazon.com>
    soreuseport: Fix socket selection for SO_INCOMING_CPU.

Tang Bin <tangbin@cmss.chinamobile.com>
    venus: pm_helpers: Fix error check in vcodec_domains_get()

Ricardo Ribalda <ribalda@chromium.org>
    media: i2c: ad5820: Fix error path

Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
    media: adv748x: afe: Select input port when initializing AFE

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: coda: jpeg: Add check for kmalloc

Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
    media: v4l2-ctrls: Fix off-by-one error in integer menu control check

Sean Anderson <sean.anderson@seco.com>
    powerpc: dts: t208x: Mark MAC1 and MAC2 as 10G

Rafael Mendonca <rafaelmendsr@gmail.com>
    drm/amdgpu/powerplay/psm: Fix memory leak in power state init

Andrew Jeffery <andrew@aj.id.au>
    ipmi: kcs: Poll OBF briefly to reduce OBE latency

Niklas Cassel <niklas.cassel@wdc.com>
    ata: libata: fix NCQ autosense logic

Sergey Shtylyov <s.shtylyov@omp.ru>
    ata: add/use ata_taskfile::{error|status} fields

Hannes Reinecke <hare@suse.de>
    ata: libata: move ata_{port,link,dev}_dbg to standard pr_XXX() macros

Shung-Hsi Yu <shung-hsi.yu@suse.com>
    libbpf: Fix null-pointer dereference in find_prog_by_sec_insn()

Xu Kuohai <xukuohai@huawei.com>
    libbpf: Fix use-after-free in btf_dump_name_dups

Abhinav Kumar <quic_abhinavk@quicinc.com>
    drm/bridge: adv7533: remove dynamic lane switching from adv7533 bridge

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Fix reading the vendor of combo chips

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: ath9k: hif_usb: Fix use-after-free in ath9k_hif_usb_reg_in_cb()

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: ath9k: hif_usb: fix memory leak of urbs in ath9k_hif_usb_dealloc_tx_urbs()

James Hurley <jahurley@nvidia.com>
    platform/mellanox: mlxbf-pmc: Fix event typo

Cai Xinchen <caixinchen1@huawei.com>
    rapidio: devices: fix missing put_device in mport_cdev_open

ZhangPeng <zhangpeng362@huawei.com>
    hfs: Fix OOB Write in hfs_asc2mac

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    relay: fix type mismatch when allocating memory in relay_create_buf()

Zhang Qilong <zhangqilong3@huawei.com>
    eventfd: change int to __u64 in eventfd_signal() ifndef CONFIG_EVENTFD

Wang Weiyang <wangweiyang2@huawei.com>
    rapidio: fix possible UAF when kfifo_alloc() fails

Chen Zhongjin <chenzhongjin@huawei.com>
    fs: sysv: Fix sysv_nblocks() returns wrong value

Trond Myklebust <trond.myklebust@hammerspace.com>
    lockd: set other missing fields when unlocking files

Ladislav Michl <ladis@linux-mips.org>
    MIPS: OCTEON: warn only once if deprecated link status is being used

Anastasia Belova <abelova@astralinux.ru>
    MIPS: BCM63xx: Add check for NULL for clk in clk_enable

Yang Yingliang <yangyingliang@huawei.com>
    platform/x86: intel_scu_ipc: fix possible name leak in __intel_scu_ipc_register()

Yu Liao <liaoyu15@huawei.com>
    platform/x86: mxm-wmi: fix memleak in mxm_wmi_call_mx[ds|mx]()

Victor Ding <victording@chromium.org>
    platform/chrome: cros_ec_typec: zero out stale pointers

Prashant Malani <pmalani@chromium.org>
    platform/chrome: cros_ec_typec: Cleanup switch handle return paths

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    PM: runtime: Do not call __rpm_callback() from rpm_idle()

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    xen/privcmd: Fix a possible warning in privcmd_ioctl_mmap_resource()

Xiu Jianfeng <xiujianfeng@huawei.com>
    x86/xen: Fix memory leak in xen_init_lock_cpu()

Xiu Jianfeng <xiujianfeng@huawei.com>
    x86/xen: Fix memory leak in xen_smp_intr_init{_pv}()

Oleg Nesterov <oleg@redhat.com>
    uprobes/x86: Allow to probe a NOP instruction with 0x66 prefix

Li Zetao <lizetao1@huawei.com>
    ACPICA: Fix use-after-free in acpi_ut_copy_ipackage_to_ipackage()

Yang Yingliang <yangyingliang@huawei.com>
    clocksource/drivers/timer-ti-dm: Fix missing clk_disable_unprepare in dmtimer_systimer_init_clock()

Vincent Donnefort <vdonnefort@google.com>
    cpu/hotplug: Do not bail-out in DYING/STARTING sections

Phil Auld <pauld@redhat.com>
    cpu/hotplug: Make target_store() a nop when target == state

Alexey Izbyshev <izbyshev@ispras.ru>
    futex: Resend potentially swallowed owner death notification

Peter Zijlstra <peterz@infradead.org>
    futex: Move to kernel/futex/

John Thomson <git@johnthomson.fastmail.com.au>
    mips: ralink: mt7621: do not use kzalloc too early

John Thomson <git@johnthomson.fastmail.com.au>
    mips: ralink: mt7621: soc queries and tests as functions

John Thomson <git@johnthomson.fastmail.com.au>
    mips: ralink: mt7621: define MT7621_SYSC_BASE with __iomem

Wolfram Sang <wsa+renesas@sang-engineering.com>
    clocksource/drivers/sh_cmt: Access registers according to spec

Yang Yingliang <yangyingliang@huawei.com>
    rapidio: rio: fix possible name leak in rio_register_mport()

Yang Yingliang <yangyingliang@huawei.com>
    rapidio: fix possible name leaks when rio_add_device() fails

Akinobu Mita <akinobu.mita@gmail.com>
    debugfs: fix error when writing negative value to atomic_t debugfs file

Akinobu Mita <akinobu.mita@gmail.com>
    lib/notifier-error-inject: fix error when writing -errno to debugfs file

Akinobu Mita <akinobu.mita@gmail.com>
    libfs: add DEFINE_SIMPLE_ATTRIBUTE_SIGNED for signed value

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    cpufreq: amd_freq_sensitivity: Add missing pci_dev_put()

Yang Yingliang <yangyingliang@huawei.com>
    genirq/irqdesc: Don't try to remove non-existing sysfs files

Jeff Layton <jlayton@kernel.org>
    nfsd: don't call nfsd_file_put from client states seqfile display

Chuck Lever <chuck.lever@oracle.com>
    NFSD: Finish converting the NFSv2 GETACL result encoder

Haowen Bai <baihaowen@meizu.com>
    SUNRPC: Return true/false (not 1/0) from bool functions

Yang Yingliang <yangyingliang@huawei.com>
    EDAC/i10nm: fix refcount leak in pci_get_dev_wrapper()

Wei Yongjun <weiyongjun1@huawei.com>
    irqchip/wpcm450: Fix memory leak in wpcm450_aic_of_init()

Shang XiaoJing <shangxiaojing@huawei.com>
    irqchip: gic-pm: Use pm_runtime_resume_and_get() in gic_probe()

Yang Yingliang <yangyingliang@huawei.com>
    thermal: core: fix some possible name leaks in error paths

Yuan Can <yuancan@huawei.com>
    platform/chrome: cros_usbpd_notify: Fix error handling in cros_usbpd_notify_init()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    perf/x86/intel/uncore: Fix reference count leak in __uncore_imc_init_box()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    perf/x86/intel/uncore: Fix reference count leak in snr_uncore_mmio_map()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    perf/x86/intel/uncore: Fix reference count leak in hswep_has_limit_sbox()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    perf/x86/intel/uncore: Fix reference count leak in sad_cfg_iio_topology()

Yang Yingliang <yangyingliang@huawei.com>
    PNP: fix name memory leak in pnp_alloc_dev()

Zhao Gongyi <zhaogongyi@huawei.com>
    selftests/efivarfs: Add checking of the test return value

Yang Yingliang <yangyingliang@huawei.com>
    MIPS: vpe-cmp: fix possible memory leak while module exiting

Yang Yingliang <yangyingliang@huawei.com>
    MIPS: vpe-mt: fix possible memory leak while module exiting

Shang XiaoJing <shangxiaojing@huawei.com>
    ocfs2: fix memory leak in ocfs2_stack_glue_init()

Gaosheng Cui <cuigaosheng1@huawei.com>
    lib/fonts: fix undefined behavior in bit shift for get_default_font

Alexey Dobriyan <adobriyan@gmail.com>
    proc: fixup uptime selftest

Barnabás Pőcze <pobrn@protonmail.com>
    timerqueue: Use rb_entry_safe() in timerqueue_getnext()

Barnabás Pőcze <pobrn@protonmail.com>
    platform/x86: huawei-wmi: fix return value calculation

wuchi <wuchi.zero@gmail.com>
    lib/debugobjects: fix stat count and optimize debug_objects_mem_init

Chen Zhongjin <chenzhongjin@huawei.com>
    perf: Fix possible memleak in pmu_dev_alloc()

Yipeng Zou <zouyipeng@huawei.com>
    selftests/ftrace: event_triggers: wait longer for test_event_enable

Chen Hui <judy.chenhui@huawei.com>
    cpufreq: qcom-hw: Fix memory leak in qcom_cpufreq_hw_read_lut()

Ondrej Mosnacek <omosnace@redhat.com>
    fs: don't audit the capability check in simple_xattr_list()

xiongxin <xiongxin@kylinos.cn>
    PM: hibernate: Fix mistake in kerneldoc comment

Reinette Chatre <reinette.chatre@intel.com>
    x86/sgx: Reduce delay and interference of enclave release

Al Viro <viro@zeniv.linux.org.uk>
    alpha: fix syscall entry in !AUDUT_SYSCALL case

Al Viro <viro@zeniv.linux.org.uk>
    alpha: fix TIF_NOTIFY_SIGNAL handling

Ulf Hansson <ulf.hansson@linaro.org>
    cpuidle: dt: Return the correct numbers of parsed idle states

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Make asym_fits_capacity() use util_fits_cpu()

Dietmar Eggemann <dietmar.eggemann@arm.com>
    sched/core: Introduce sched_asym_cpucap_active()

Vincent Guittot <vincent.guittot@linaro.org>
    sched/fair: Removed useless update of p->recent_used_cpu

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Make select_idle_capacity() use util_fits_cpu()

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Make task_fits_capacity() use util_fits_cpu()

Qais Yousef <qais.yousef@arm.com>
    sched/uclamp: Fix relationship between uclamp and migration margin

Vincent Donnefort <vincent.donnefort@arm.com>
    sched/fair: Cleanup task_util and capacity type

Amir Goldstein <amir73il@gmail.com>
    ovl: remove privs in ovl_fallocate()

Amir Goldstein <amir73il@gmail.com>
    ovl: remove privs in ovl_copyfile()

Christian Brauner <brauner@kernel.org>
    ovl: use ovl_copy_{real,upper}attr() wrappers

Amir Goldstein <amir73il@gmail.com>
    ovl: store lower path in ovl_inode

Michael Kelley <mikelley@microsoft.com>
    tpm/tpm_crb: Fix error message in __crb_relinquish_locality()

Yuan Can <yuancan@huawei.com>
    tpm/tpm_ftpm_tee: Fix error handling in ftpm_mod_init()

Stephen Boyd <swboyd@chromium.org>
    pstore: Avoid kcore oops by vmap()ing with VM_IOREMAP

Doug Brown <doug@schmorgal.com>
    ARM: mmp: fix timer_read delay

Wang Yufen <wangyufen@huawei.com>
    pstore/ram: Fix error return code in ramoops_probe()

Kuniyuki Iwashima <kuniyu@amazon.com>
    seccomp: Move copy_seccomp() to no failure path.

Pali Rohár <pali@kernel.org>
    arm64: dts: armada-3720-turris-mox: Add missing interrupt for RTC

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-39x: Fix compatible string for gpios

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-38x: Fix compatible string for gpios

Pali Rohár <pali@kernel.org>
    ARM: dts: turris-omnia: Add switch port 6 node

Pali Rohár <pali@kernel.org>
    ARM: dts: turris-omnia: Add ethernet aliases

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-39x: Fix assigned-addresses for every PCIe Root Port

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-38x: Fix assigned-addresses for every PCIe Root Port

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-375: Fix assigned-addresses for every PCIe Root Port

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-xp: Fix assigned-addresses for every PCIe Root Port

Pali Rohár <pali@kernel.org>
    ARM: dts: armada-370: Fix assigned-addresses for every PCIe Root Port

Pali Rohár <pali@kernel.org>
    ARM: dts: dove: Fix assigned-addresses for every PCIe Root Port

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: mt6797: Fix 26M oscillator unit name

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mediatek: pumpkin-common: Fix devicetree warnings

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt2712-evb: Fix usb vbus regulators unit names

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt2712-evb: Fix vproc fixed regulators unit names

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt2712e: Fix unit address for pinctrl node

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt2712e: Fix unit_address_vs_reg warning for oscillators

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    arm64: dts: mt6779: Fix devicetree build warnings

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    ARM: dts: nuvoton: Remove bogus unit addresses from fixed-partition nodes

Jayesh Choudhary <j-choudhary@ti.com>
    arm64: dts: ti: k3-j721e-main: Drop dma-coherent in crypto node

Jayesh Choudhary <j-choudhary@ti.com>
    arm64: dts: ti: k3-am65-main: Drop dma-coherent in crypto node

Shang XiaoJing <shangxiaojing@huawei.com>
    perf/smmuv3: Fix hotplug callback leak in arm_smmu_pmu_init()

Shang XiaoJing <shangxiaojing@huawei.com>
    perf/arm_dmc620: Fix hotplug callback leak in dmc620_pmu_init()

Yuan Can <yuancan@huawei.com>
    perf: arm_dsu: Fix hotplug callback leak in dsu_pmu_init()

Mark Rutland <mark.rutland@arm.com>
    arm64: mm: kfence: only handle translation faults

Alexandru Elisei <alexandru.elisei@arm.com>
    arm64: Treat ESR_ELx as a 64-bit register

Zhang Qilong <zhangqilong3@huawei.com>
    soc: ti: smartreflex: Fix PM disable depth imbalance in omap_sr_probe

Zhang Qilong <zhangqilong3@huawei.com>
    soc: ti: knav_qmss_queue: Fix PM disable depth imbalance in knav_queue_probe

Minghao Chi <chi.minghao@zte.com.cn>
    soc: ti: knav_qmss_queue: Use pm_runtime_resume_and_get instead of pm_runtime_get_sync

Kory Maincent <kory.maincent@bootlin.com>
    arm: dts: spear600: Fix clcd interrupt

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm6125: fix SDHCI CQE reg names

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    soc: qcom: apr: Add check for idr_alloc and of_property_read_string_index

Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
    soc: qcom: apr: make code more reuseable

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sm8250: drop bogus DP PHY clock

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sm8350: fix UFS PHY registers

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sm8250: fix UFS PHY registers

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sm8150: fix UFS PHY registers

Shawn Guo <shawn.guo@linaro.org>
    arm64: dts: qcom: Correct QMP PHY child node name

Luca Weiss <luca.weiss@fairphone.com>
    soc: qcom: llcc: make irq truly optional

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8250: correct LPASS pin pull down

Marijn Suijten <marijn.suijten@somainline.org>
    arm64: dts: qcom: pm660: Use unique ADC5_VCOIN address in node name

Chen Jiahao <chenjiahao16@huawei.com>
    drivers: soc: ti: knav_qmss_queue: Mark knav_acc_firmwares as static

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Fix AV96 WLAN regulator gpio property

Marek Vasut <marex@denx.de>
    ARM: dts: stm32: Drop stm32mp15xc.dtsi from Avenger96

Marco Elver <elver@google.com>
    objtool, kcsan: Add volatile read/write instrumentation to whitelist

Stephan Gerhold <stephan.gerhold@kernkonzept.com>
    arm64: dts: qcom: msm8916: Drop MSS fallback compatible

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm845-cheza: fix AP suspend pin bias

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sdm630: fix UART1 pin bias

Luca Weiss <luca@z3ntu.xyz>
    ARM: dts: qcom: apq8064: fix coresight compatible

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8996: fix GPU OPP table

Dmitry Baryshkov <dmitry.baryshkov@linaro.org>
    arm64: dts: qcom: msm8996: fix supported-hw in cpufreq OPP tables

Yassine Oudjana <y.oudjana@protonmail.com>
    arm64: dts: qcom: msm8996: Add MSM8996 Pro support

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: sm8250-sony-xperia-edo: fix touchscreen bias-disable

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    arm64: dts: qcom: ipq6018-cp01-c1: use BLSPI1 pins

Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
    usb: musb: remove extra check in musb_gadget_vbus_draw

Martin Leung <Martin.Leung@amd.com>
    drm/amd/display: Manually adjust strobe for DCN303


-------------

Diffstat:

 .../ABI/testing/sysfs-bus-spi-devices-spi-nor      |    3 +
 .../devicetree/bindings/pci/fsl,imx6q-pcie.yaml    |   46 +-
 .../bindings/pci/toshiba,visconti-pcie.yaml        |    7 +-
 .../devicetree/bindings/sound/qcom,wcd9335.txt     |    2 +-
 Documentation/driver-api/spi.rst                   |    4 +-
 Documentation/fault-injection/fault-injection.rst  |   10 +-
 Documentation/process/deprecated.rst               |   20 +-
 MAINTAINERS                                        |    2 +-
 Makefile                                           |    4 +-
 arch/alpha/include/asm/thread_info.h               |    2 +-
 arch/alpha/kernel/entry.S                          |    4 +-
 arch/arm/boot/dts/armada-370.dtsi                  |    2 +-
 arch/arm/boot/dts/armada-375.dtsi                  |    2 +-
 arch/arm/boot/dts/armada-380.dtsi                  |    4 +-
 arch/arm/boot/dts/armada-385-turris-omnia.dts      |   18 +-
 arch/arm/boot/dts/armada-385.dtsi                  |    6 +-
 arch/arm/boot/dts/armada-38x.dtsi                  |    4 +-
 arch/arm/boot/dts/armada-39x.dtsi                  |   10 +-
 arch/arm/boot/dts/armada-xp-mv78230.dtsi           |    8 +-
 arch/arm/boot/dts/armada-xp-mv78260.dtsi           |   16 +-
 arch/arm/boot/dts/dove.dtsi                        |    2 +-
 arch/arm/boot/dts/nuvoton-npcm730-gbs.dts          |    2 +-
 arch/arm/boot/dts/nuvoton-npcm730-gsj.dts          |    2 +-
 arch/arm/boot/dts/nuvoton-npcm730-kudo.dts         |    6 +-
 arch/arm/boot/dts/nuvoton-npcm750-evb.dts          |    4 +-
 .../boot/dts/nuvoton-npcm750-runbmc-olympus.dts    |    6 +-
 arch/arm/boot/dts/qcom-apq8064.dtsi                |    2 +-
 arch/arm/boot/dts/spear600.dtsi                    |    2 +-
 arch/arm/boot/dts/stm32mp157a-dhcor-avenger96.dts  |    1 -
 arch/arm/boot/dts/stm32mp15xx-dhcor-avenger96.dtsi |    2 +-
 arch/arm/mach-mmp/time.c                           |   11 +-
 .../boot/dts/marvell/armada-3720-turris-mox.dts    |    3 +
 arch/arm64/boot/dts/mediatek/mt2712-evb.dts        |   12 +-
 arch/arm64/boot/dts/mediatek/mt2712e.dtsi          |   22 +-
 arch/arm64/boot/dts/mediatek/mt6779.dtsi           |    8 +-
 arch/arm64/boot/dts/mediatek/mt6797.dtsi           |    2 +-
 arch/arm64/boot/dts/mediatek/mt8183.dtsi           |    2 +-
 arch/arm64/boot/dts/mediatek/pumpkin-common.dtsi   |    6 +-
 arch/arm64/boot/dts/qcom/ipq6018-cp01-c1.dts       |    2 +
 arch/arm64/boot/dts/qcom/ipq6018.dtsi              |    2 +-
 arch/arm64/boot/dts/qcom/ipq8074.dtsi              |    4 +-
 arch/arm64/boot/dts/qcom/msm8916.dtsi              |    2 +-
 arch/arm64/boot/dts/qcom/msm8996.dtsi              |  122 +-
 arch/arm64/boot/dts/qcom/msm8996pro.dtsi           |  266 +
 arch/arm64/boot/dts/qcom/msm8998.dtsi              |    6 +-
 arch/arm64/boot/dts/qcom/pm660.dtsi                |    2 +-
 arch/arm64/boot/dts/qcom/sdm630.dtsi               |    2 +-
 arch/arm64/boot/dts/qcom/sdm845-cheza.dtsi         |    4 +-
 arch/arm64/boot/dts/qcom/sdm845.dtsi               |   10 +-
 arch/arm64/boot/dts/qcom/sm6125.dtsi               |    2 +-
 arch/arm64/boot/dts/qcom/sm8150.dtsi               |   16 +-
 .../boot/dts/qcom/sm8250-sony-xperia-edo.dtsi      |    2 +-
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   30 +-
 arch/arm64/boot/dts/qcom/sm8350.dtsi               |   12 +-
 arch/arm64/boot/dts/ti/k3-am65-main.dtsi           |    1 -
 arch/arm64/boot/dts/ti/k3-j721e-main.dtsi          |    1 -
 arch/arm64/include/asm/debug-monitors.h            |    4 +-
 arch/arm64/include/asm/esr.h                       |    6 +-
 arch/arm64/include/asm/exception.h                 |   28 +-
 arch/arm64/include/asm/processor.h                 |    4 +-
 arch/arm64/include/asm/system_misc.h               |    4 +-
 arch/arm64/include/asm/traps.h                     |   12 +-
 arch/arm64/kernel/debug-monitors.c                 |   12 +-
 arch/arm64/kernel/entry-common.c                   |    6 +-
 arch/arm64/kernel/fpsimd.c                         |    6 +-
 arch/arm64/kernel/hw_breakpoint.c                  |    4 +-
 arch/arm64/kernel/kgdb.c                           |    6 +-
 arch/arm64/kernel/probes/kprobes.c                 |    4 +-
 arch/arm64/kernel/probes/uprobes.c                 |    4 +-
 arch/arm64/kernel/traps.c                          |   66 +-
 arch/arm64/mm/fault.c                              |   78 +-
 arch/mips/bcm63xx/clk.c                            |    2 +
 .../cavium-octeon/executive/cvmx-helper-board.c    |    2 +-
 arch/mips/cavium-octeon/executive/cvmx-helper.c    |    2 +-
 arch/mips/include/asm/mach-ralink/mt7621.h         |    4 +-
 arch/mips/kernel/vpe-cmp.c                         |    4 +-
 arch/mips/kernel/vpe-mt.c                          |    4 +-
 arch/mips/ralink/mt7621.c                          |   97 +-
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-2.dtsi |   44 +
 arch/powerpc/boot/dts/fsl/qoriq-fman3-0-10g-3.dtsi |   44 +
 arch/powerpc/boot/dts/fsl/t2081si-post.dtsi        |    4 +-
 arch/powerpc/perf/callchain.c                      |    1 +
 arch/powerpc/perf/hv-gpci-requests.h               |    4 +
 arch/powerpc/perf/hv-gpci.c                        |   33 +-
 arch/powerpc/perf/hv-gpci.h                        |    1 +
 arch/powerpc/perf/req-gen/perf.h                   |   20 +
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |    1 +
 arch/powerpc/platforms/83xx/mpc832x_rdb.c          |    2 +-
 arch/powerpc/platforms/pseries/eeh_pseries.c       |   14 +-
 arch/powerpc/sysdev/xive/spapr.c                   |    1 +
 arch/powerpc/xmon/xmon.c                           |    7 +-
 arch/riscv/include/asm/hugetlb.h                   |    6 +
 arch/riscv/kernel/traps.c                          |    2 +-
 arch/riscv/net/bpf_jit_comp64.c                    |   29 +-
 arch/x86/events/intel/uncore_snb.c                 |    3 +
 arch/x86/events/intel/uncore_snbep.c               |    5 +
 arch/x86/hyperv/hv_init.c                          |    2 -
 arch/x86/kernel/cpu/sgx/encl.c                     |   23 +-
 arch/x86/kernel/uprobes.c                          |    4 +-
 arch/x86/xen/smp.c                                 |   24 +-
 arch/x86/xen/smp_pv.c                              |   12 +-
 arch/x86/xen/spinlock.c                            |    6 +-
 block/bfq-iosched.c                                |   16 +-
 block/blk-iocost.c                                 |   14 +-
 block/blk-mq-sysfs.c                               |   11 +-
 block/genhd.c                                      |    2 +
 crypto/cryptd.c                                    |   36 +-
 crypto/tcrypt.c                                    |    9 -
 drivers/acpi/acpica/dsmethod.c                     |   10 +-
 drivers/acpi/acpica/utcopy.c                       |    7 -
 drivers/ata/acard-ahci.c                           |    2 +-
 drivers/ata/ahci.c                                 |    4 +-
 drivers/ata/ahci_qoriq.c                           |    2 +-
 drivers/ata/ahci_xgene.c                           |    2 +-
 drivers/ata/libahci.c                              |    4 +-
 drivers/ata/libata-acpi.c                          |   52 +-
 drivers/ata/libata-core.c                          |   73 +-
 drivers/ata/libata-eh.c                            |   42 +-
 drivers/ata/libata-sata.c                          |   19 +-
 drivers/ata/libata-scsi.c                          |   22 +-
 drivers/ata/libata-sff.c                           |    6 +-
 drivers/ata/pata_ep93xx.c                          |    4 +-
 drivers/ata/pata_ixp4xx_cf.c                       |    6 +-
 drivers/ata/pata_ns87415.c                         |    4 +-
 drivers/ata/pata_octeon_cf.c                       |    4 +-
 drivers/ata/pata_samsung_cf.c                      |    2 +-
 drivers/ata/sata_highbank.c                        |    2 +-
 drivers/ata/sata_inic162x.c                        |   10 +-
 drivers/ata/sata_rcar.c                            |    4 +-
 drivers/ata/sata_svw.c                             |   10 +-
 drivers/ata/sata_vsc.c                             |   10 +-
 drivers/base/class.c                               |    5 +
 drivers/base/power/runtime.c                       |   12 +-
 drivers/block/drbd/drbd_main.c                     |    9 +-
 drivers/block/floppy.c                             |    4 +-
 drivers/block/loop.c                               |   28 +-
 drivers/bluetooth/btintel.c                        |    5 +-
 drivers/bluetooth/btusb.c                          |    6 +-
 drivers/bluetooth/hci_bcsp.c                       |    2 +-
 drivers/bluetooth/hci_h5.c                         |    2 +-
 drivers/bluetooth/hci_ll.c                         |    2 +-
 drivers/bluetooth/hci_qca.c                        |    2 +-
 drivers/char/hw_random/amd-rng.c                   |   18 +-
 drivers/char/hw_random/geode-rng.c                 |   36 +-
 drivers/char/ipmi/ipmi_msghandler.c                |    8 +-
 drivers/char/ipmi/kcs_bmc_aspeed.c                 |   24 +-
 drivers/char/tpm/tpm_crb.c                         |    2 +-
 drivers/char/tpm/tpm_ftpm_tee.c                    |    8 +-
 drivers/clk/imx/clk-imx8mn.c                       |   34 +-
 drivers/clk/qcom/clk-krait.c                       |    2 +
 drivers/clk/qcom/gcc-sm8250.c                      |    4 +-
 drivers/clk/qcom/lpasscorecc-sc7180.c              |   24 +-
 drivers/clk/renesas/r9a06g032-clocks.c             |    3 +-
 drivers/clk/rockchip/clk-pll.c                     |    1 +
 drivers/clk/samsung/clk-pll.c                      |    1 +
 drivers/clk/socfpga/clk-gate.c                     |    5 +-
 drivers/clk/st/clkgen-fsyn.c                       |    5 +-
 drivers/clocksource/sh_cmt.c                       |   88 +-
 drivers/clocksource/timer-ti-dm-systimer.c         |    4 +-
 drivers/counter/stm32-lptimer-cnt.c                |    2 +-
 drivers/cpufreq/amd_freq_sensitivity.c             |    2 +
 drivers/cpufreq/qcom-cpufreq-hw.c                  |    1 +
 drivers/cpuidle/dt_idle_states.c                   |    2 +-
 drivers/crypto/Kconfig                             |    5 +
 .../crypto/allwinner/sun8i-ss/sun8i-ss-cipher.c    |    2 +-
 drivers/crypto/amlogic/amlogic-gxl-core.c          |    1 -
 drivers/crypto/amlogic/amlogic-gxl.h               |    2 +-
 drivers/crypto/cavium/nitrox/nitrox_mbx.c          |    1 +
 drivers/crypto/ccree/cc_debugfs.c                  |    2 +-
 drivers/crypto/ccree/cc_driver.c                   |   10 +-
 drivers/crypto/hisilicon/hpre/hpre_main.c          |   10 +-
 drivers/crypto/hisilicon/qm.c                      |    7 +-
 drivers/crypto/hisilicon/qm.h                      |    6 +-
 drivers/crypto/img-hash.c                          |    8 +-
 drivers/crypto/omap-sham.c                         |    2 +-
 drivers/crypto/rockchip/rk3288_crypto.c            |  193 +-
 drivers/crypto/rockchip/rk3288_crypto.h            |   53 +-
 drivers/crypto/rockchip/rk3288_crypto_ahash.c      |  197 +-
 drivers/crypto/rockchip/rk3288_crypto_skcipher.c   |  413 +-
 drivers/dio/dio.c                                  |    8 +
 drivers/edac/i10nm_base.c                          |    3 +-
 drivers/extcon/Kconfig                             |    2 +-
 drivers/extcon/extcon-usbc-tusb320.c               |  402 +-
 drivers/firmware/raspberrypi.c                     |    1 +
 drivers/gpio/gpiolib-cdev.c                        |  268 +-
 drivers/gpio/gpiolib.c                             |   16 +-
 drivers/gpio/gpiolib.h                             |   39 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_amdkfd_gpuvm.c   |    2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |    1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |    4 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.h           |    5 +-
 .../drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c  |   35 -
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |   16 +-
 .../gpu/drm/amd/display/dc/dce60/dce60_resource.c  |    3 +
 .../gpu/drm/amd/display/dc/dce80/dce80_resource.c  |    2 +
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |   30 +-
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |   29 +-
 .../drm/amd/display/dc/dcn303/dcn303_resource.c    |   14 +
 drivers/gpu/drm/amd/include/kgd_pp_interface.h     |    3 +-
 drivers/gpu/drm/amd/pm/powerplay/amd_powerplay.c   |    3 +-
 drivers/gpu/drm/amd/pm/powerplay/hwmgr/pp_psm.c    |    2 +
 .../gpu/drm/amd/pm/powerplay/hwmgr/vega20_hwmgr.c  |    3 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |    4 +
 drivers/gpu/drm/bridge/adv7511/adv7511.h           |    3 +-
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c       |   18 +-
 drivers/gpu/drm/bridge/adv7511/adv7533.c           |   25 +-
 drivers/gpu/drm/drm_fourcc.c                       |   11 +-
 drivers/gpu/drm/etnaviv/etnaviv_gpu.c              |   11 +-
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c          |    5 +-
 drivers/gpu/drm/i915/display/intel_dp.c            |   59 -
 drivers/gpu/drm/mediatek/mtk_dpi.c                 |   12 +-
 drivers/gpu/drm/mediatek/mtk_hdmi.c                |    7 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   12 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |    2 +-
 drivers/gpu/drm/msm/hdmi/hdmi.c                    |   68 +-
 drivers/gpu/drm/msm/hdmi/hdmi.h                    |   13 +-
 drivers/gpu/drm/msm/hdmi/hdmi_hpd.c                |   62 +-
 drivers/gpu/drm/panel/panel-sitronix-st7701.c      |   10 +-
 drivers/gpu/drm/radeon/radeon_bios.c               |   19 +-
 drivers/gpu/drm/rockchip/cdn-dp-core.c             |    2 +-
 drivers/gpu/drm/rockchip/inno_hdmi.c               |    2 +-
 drivers/gpu/drm/rockchip/rk3066_hdmi.c             |    2 +-
 drivers/gpu/drm/rockchip/rockchip_lvds.c           |   10 +-
 drivers/gpu/drm/sti/sti_dvo.c                      |    7 +-
 drivers/gpu/drm/sti/sti_hda.c                      |    7 +-
 drivers/gpu/drm/sti/sti_hdmi.c                     |    7 +-
 drivers/gpu/drm/tegra/dc.c                         |    4 +-
 drivers/hid/amd-sfh-hid/amd_sfh_client.c           |    4 +
 drivers/hid/hid-mcp2221.c                          |   12 +-
 drivers/hid/hid-sensor-custom.c                    |    2 +-
 drivers/hid/wacom_sys.c                            |    8 +
 drivers/hid/wacom_wac.c                            |    4 +
 drivers/hid/wacom_wac.h                            |    1 +
 drivers/hsi/controllers/omap_ssi_core.c            |   14 +-
 drivers/hv/ring_buffer.c                           |   13 +
 drivers/hwmon/Kconfig                              |    1 +
 drivers/hwmon/jc42.c                               |  243 +-
 drivers/hwtracing/coresight/coresight-trbe.c       |    1 +
 drivers/i2c/busses/i2c-ismt.c                      |    3 +
 drivers/i2c/busses/i2c-pxa-pci.c                   |   10 +-
 drivers/i2c/muxes/i2c-mux-reg.c                    |    5 +-
 drivers/iio/accel/adis16201.c                      |    1 +
 drivers/iio/accel/adis16209.c                      |    1 +
 drivers/iio/adc/ad_sigma_delta.c                   |    8 +-
 drivers/iio/adc/ti-adc128s052.c                    |   14 +-
 drivers/iio/gyro/adis16136.c                       |    1 +
 drivers/iio/gyro/adis16260.c                       |    1 +
 drivers/iio/imu/adis.c                             |   98 +-
 drivers/iio/imu/adis16400.c                        |    1 +
 drivers/iio/imu/adis16460.c                        |    1 +
 drivers/iio/imu/adis16475.c                        |    1 +
 drivers/iio/imu/adis16480.c                        |    1 +
 drivers/iio/imu/adis_buffer.c                      |   10 +-
 drivers/iio/imu/adis_trigger.c                     |    9 +-
 drivers/iio/industrialio-event.c                   |    4 +-
 drivers/iio/temperature/ltc2983.c                  |   10 +-
 drivers/infiniband/core/device.c                   |    2 +-
 drivers/infiniband/core/mad.c                      |    5 -
 drivers/infiniband/core/nldev.c                    |    6 +-
 drivers/infiniband/core/restrack.c                 |    2 -
 drivers/infiniband/core/sysfs.c                    |   17 +-
 drivers/infiniband/hw/hfi1/affinity.c              |    2 +
 drivers/infiniband/hw/hfi1/firmware.c              |    6 +
 drivers/infiniband/hw/hns/hns_roce_hw_v2.c         |   52 +-
 drivers/infiniband/hw/hns/hns_roce_hw_v2.h         |    5 +
 drivers/infiniband/hw/hns/hns_roce_mr.c            |    4 +-
 drivers/infiniband/hw/irdma/verbs.c                |   35 +-
 drivers/infiniband/sw/rxe/rxe_qp.c                 |    6 +-
 drivers/infiniband/sw/siw/siw_cq.c                 |   24 +-
 drivers/infiniband/sw/siw/siw_qp_tx.c              |    2 +-
 drivers/infiniband/sw/siw/siw_verbs.c              |   40 +-
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c       |    7 +
 drivers/infiniband/ulp/srp/ib_srp.c                |   96 +-
 drivers/input/joystick/Kconfig                     |    1 +
 drivers/input/misc/Kconfig                         |    2 +-
 drivers/input/touchscreen/elants_i2c.c             |    9 +-
 drivers/iommu/amd/iommu_v2.c                       |    1 +
 drivers/iommu/fsl_pamu.c                           |    2 +-
 drivers/iommu/rockchip-iommu.c                     |   10 +-
 drivers/iommu/sun50i-iommu.c                       |   16 +-
 drivers/irqchip/irq-gic-pm.c                       |    2 +-
 drivers/irqchip/irq-wpcm450-aic.c                  |    1 +
 drivers/isdn/hardware/mISDN/hfcmulti.c             |   19 +-
 drivers/isdn/hardware/mISDN/hfcpci.c               |   13 +-
 drivers/isdn/hardware/mISDN/hfcsusb.c              |   12 +-
 drivers/macintosh/macio-adb.c                      |    4 +
 drivers/macintosh/macio_asic.c                     |    2 +-
 drivers/mailbox/arm_mhuv2.c                        |    4 +-
 drivers/mailbox/mailbox-mpfs.c                     |   31 +-
 drivers/mailbox/zynqmp-ipi-mailbox.c               |    4 +-
 drivers/mcb/mcb-core.c                             |    4 +-
 drivers/mcb/mcb-parse.c                            |    2 +-
 drivers/md/md-bitmap.c                             |   27 +-
 drivers/md/raid1.c                                 |    1 +
 drivers/media/dvb-core/dvb_ca_en50221.c            |    2 +-
 drivers/media/dvb-core/dvb_frontend.c              |   10 +-
 drivers/media/dvb-core/dvbdev.c                    |   32 +-
 drivers/media/dvb-frontends/bcm3510.c              |    1 +
 drivers/media/i2c/ad5820.c                         |   10 +-
 drivers/media/i2c/adv748x/adv748x-afe.c            |    4 +
 drivers/media/pci/saa7164/saa7164-core.c           |    4 +-
 drivers/media/pci/solo6x10/solo6x10-core.c         |    1 +
 drivers/media/platform/coda/coda-bit.c             |   14 +-
 drivers/media/platform/coda/coda-jpeg.c            |   10 +-
 drivers/media/platform/exynos4-is/fimc-core.c      |    2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |   12 +-
 drivers/media/platform/imx-jpeg/mxc-jpeg-hw.c      |    4 +-
 drivers/media/platform/qcom/camss/camss-video.c    |    3 +-
 drivers/media/platform/qcom/venus/pm_helpers.c     |    4 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           |   17 +-
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  |    1 +
 drivers/media/radio/si470x/radio-si470x-usb.c      |    4 +-
 drivers/media/rc/imon.c                            |    6 +-
 drivers/media/test-drivers/vidtv/vidtv_bridge.c    |   22 +-
 drivers/media/test-drivers/vimc/vimc-core.c        |    2 +-
 drivers/media/test-drivers/vivid/vivid-vid-cap.c   |    1 +
 drivers/media/usb/dvb-usb/az6027.c                 |    4 +
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |    4 +-
 drivers/media/v4l2-core/v4l2-ctrls-core.c          |    2 +-
 drivers/media/v4l2-core/videobuf-dma-contig.c      |   22 +-
 drivers/memstick/core/ms_block.c                   |   13 +-
 drivers/mfd/Kconfig                                |    1 +
 drivers/mfd/qcom-pm8008.c                          |   55 +-
 drivers/mfd/qcom_rpm.c                             |    4 +-
 drivers/misc/cxl/guest.c                           |   24 +-
 drivers/misc/cxl/pci.c                             |   21 +-
 drivers/misc/ocxl/config.c                         |   20 +-
 drivers/misc/ocxl/file.c                           |    7 +-
 drivers/misc/sgi-gru/grufault.c                    |   13 +-
 drivers/misc/sgi-gru/grumain.c                     |   22 +-
 drivers/misc/sgi-gru/grutables.h                   |    2 +-
 drivers/misc/tifm_7xx1.c                           |    2 +-
 drivers/mmc/core/sd.c                              |   11 +-
 drivers/mmc/host/alcor.c                           |    5 +-
 drivers/mmc/host/atmel-mci.c                       |    9 +-
 drivers/mmc/host/meson-gx-mmc.c                    |    4 +-
 drivers/mmc/host/mmci.c                            |    4 +-
 drivers/mmc/host/moxart-mmc.c                      |    4 +-
 drivers/mmc/host/mxcmmc.c                          |    4 +-
 drivers/mmc/host/omap_hsmmc.c                      |    4 +-
 drivers/mmc/host/pxamci.c                          |    7 +-
 drivers/mmc/host/renesas_sdhi_core.c               |   14 +-
 drivers/mmc/host/rtsx_pci_sdmmc.c                  |    9 +-
 drivers/mmc/host/rtsx_usb_sdmmc.c                  |   11 +-
 drivers/mmc/host/sdhci_f_sdh30.c                   |    3 +
 drivers/mmc/host/toshsd.c                          |    6 +-
 drivers/mmc/host/via-sdmmc.c                       |    4 +-
 drivers/mmc/host/vub300.c                          |   11 +-
 drivers/mmc/host/wbsd.c                            |   12 +-
 drivers/mmc/host/wmt-sdmmc.c                       |    6 +-
 drivers/mtd/lpddr/lpddr2_nvm.c                     |    2 +
 drivers/mtd/maps/pxa2xx-flash.c                    |    2 +
 drivers/mtd/mtdcore.c                              |    4 +-
 drivers/mtd/spi-nor/core.c                         |    3 +-
 drivers/mtd/spi-nor/sysfs.c                        |   14 +
 drivers/net/bonding/bond_main.c                    |   13 +-
 drivers/net/can/m_can/m_can.c                      |   32 +-
 drivers/net/can/m_can/m_can_platform.c             |    4 -
 drivers/net/can/m_can/tcan4x5x-core.c              |   18 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb.h        |   30 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_core.c   |  115 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_hydra.c  |  174 +-
 drivers/net/can/usb/kvaser_usb/kvaser_usb_leaf.c   |  446 +-
 drivers/net/dsa/lan9303-core.c                     |    4 +-
 drivers/net/ethernet/amd/atarilance.c              |    2 +-
 drivers/net/ethernet/amd/lance.c                   |    2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        |   23 +-
 drivers/net/ethernet/apple/bmac.c                  |    2 +-
 drivers/net/ethernet/apple/mace.c                  |    2 +-
 drivers/net/ethernet/dnet.c                        |    4 +-
 drivers/net/ethernet/freescale/enetc/enetc.c       |   35 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |   36 +-
 drivers/net/ethernet/intel/igb/igb_main.c          |    8 +-
 drivers/net/ethernet/intel/igc/igc.h               |    3 +
 drivers/net/ethernet/intel/igc/igc_defines.h       |    2 +
 drivers/net/ethernet/intel/igc/igc_main.c          |  233 +-
 drivers/net/ethernet/intel/igc/igc_tsn.c           |   13 +-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |    1 +
 drivers/net/ethernet/neterion/s2io.c               |    2 +-
 drivers/net/ethernet/qlogic/qed/qed_debug.c        |    3 +-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |    2 +
 drivers/net/ethernet/rdc/r6040.c                   |    5 +-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |    3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |    4 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h   |    2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_selftests.c |    8 +-
 drivers/net/ethernet/ti/netcp_core.c               |    2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |    2 +-
 drivers/net/fddi/defxx.c                           |   22 +-
 drivers/net/hamradio/baycom_epp.c                  |    2 +-
 drivers/net/hamradio/scc.c                         |    6 +-
 drivers/net/macsec.c                               |   34 +-
 drivers/net/ntb_netdev.c                           |    4 +-
 drivers/net/ppp/ppp_generic.c                      |    2 +
 drivers/net/wan/farsync.c                          |    2 +
 drivers/net/wireless/ath/ar5523/ar5523.c           |    6 +
 drivers/net/wireless/ath/ath10k/pci.c              |   20 +-
 drivers/net/wireless/ath/ath9k/hif_usb.c           |   46 +-
 .../broadcom/brcm80211/brcmfmac/firmware.c         |    5 +
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |    6 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |    1 +
 drivers/net/wireless/intel/iwlwifi/mvm/tx.c        |   12 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |    3 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mac.c    |    2 +-
 drivers/net/wireless/mediatek/mt76/usb.c           |   11 +-
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |    2 +-
 .../net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c  |   26 +-
 drivers/net/wireless/rsi/rsi_91x_core.c            |    4 +-
 drivers/net/wireless/rsi/rsi_91x_hal.c             |    6 +-
 drivers/nfc/pn533/pn533.c                          |    4 +
 drivers/nvme/host/core.c                           |    2 +-
 drivers/nvme/target/core.c                         |   22 +-
 drivers/nvme/target/io-cmd-file.c                  |   16 +-
 drivers/nvme/target/nvmet.h                        |    3 +-
 drivers/of/overlay.c                               |    4 +-
 drivers/pci/controller/dwc/pcie-designware.c       |    2 +-
 drivers/pci/controller/vmd.c                       |    5 +
 drivers/pci/endpoint/functions/pci-epf-test.c      |    2 +-
 drivers/pci/irq.c                                  |    2 +
 drivers/perf/arm_dmc620_pmu.c                      |    8 +-
 drivers/perf/arm_dsu_pmu.c                         |    6 +-
 drivers/perf/arm_smmuv3_pmu.c                      |    8 +-
 drivers/phy/broadcom/phy-brcm-usb.c                |    6 +-
 drivers/phy/qualcomm/phy-qcom-qmp-combo.c          | 6350 ++++++++++++++++++++
 drivers/phy/qualcomm/phy-qcom-qmp-pcie-msm8996.c   | 6350 ++++++++++++++++++++
 drivers/phy/qualcomm/phy-qcom-qmp-pcie.c           | 6350 ++++++++++++++++++++
 drivers/phy/qualcomm/phy-qcom-qmp-ufs.c            | 6350 ++++++++++++++++++++
 drivers/phy/qualcomm/phy-qcom-qmp-usb.c            | 6350 ++++++++++++++++++++
 drivers/pinctrl/pinconf-generic.c                  |    4 +-
 drivers/pinctrl/pinctrl-k210.c                     |    4 +-
 drivers/platform/chrome/cros_ec_typec.c            |    8 +-
 drivers/platform/chrome/cros_usbpd_notify.c        |    6 +-
 drivers/platform/mellanox/mlxbf-pmc.c              |    2 +-
 drivers/platform/x86/huawei-wmi.c                  |   20 +-
 drivers/platform/x86/intel_scu_ipc.c               |    2 +-
 drivers/platform/x86/mxm-wmi.c                     |    8 +-
 drivers/pnp/core.c                                 |    4 +-
 drivers/power/supply/ab8500_charger.c              |    9 +-
 drivers/power/supply/power_supply_core.c           |    7 +-
 drivers/power/supply/z2_battery.c                  |    6 +-
 drivers/pwm/pwm-mediatek.c                         |    2 +-
 drivers/pwm/pwm-mtk-disp.c                         |    5 +-
 drivers/pwm/pwm-sifive.c                           |    5 +-
 drivers/pwm/pwm-tegra.c                            |    4 +-
 drivers/rapidio/devices/rio_mport_cdev.c           |   15 +-
 drivers/rapidio/rio-scan.c                         |    8 +-
 drivers/rapidio/rio.c                              |    9 +-
 drivers/regulator/core.c                           |   15 +-
 drivers/regulator/qcom-labibb-regulator.c          |    1 +
 drivers/regulator/qcom-rpmh-regulator.c            |    2 +-
 drivers/remoteproc/qcom_q6v5_pas.c                 |    4 +
 drivers/remoteproc/qcom_q6v5_wcss.c                |    6 +-
 drivers/remoteproc/qcom_sysmon.c                   |    5 +-
 drivers/rtc/rtc-cmos.c                             |  366 +-
 drivers/rtc/rtc-mxc_v2.c                           |    4 +-
 drivers/rtc/rtc-pcf85063.c                         |   10 +-
 drivers/rtc/rtc-pic32.c                            |    8 +-
 drivers/rtc/rtc-snvs.c                             |   16 +-
 drivers/rtc/rtc-st-lpc.c                           |    1 +
 drivers/s390/net/ctcm_main.c                       |   11 +-
 drivers/s390/net/lcs.c                             |    8 +-
 drivers/s390/net/netiucv.c                         |    9 +-
 drivers/scsi/elx/efct/efct_driver.c                |    1 +
 drivers/scsi/elx/libefc/efclib.h                   |    6 +-
 drivers/scsi/fcoe/fcoe.c                           |    1 +
 drivers/scsi/fcoe/fcoe_sysfs.c                     |   19 +-
 drivers/scsi/hpsa.c                                |    9 +-
 drivers/scsi/ipr.c                                 |   10 +-
 drivers/scsi/lpfc/lpfc_sli.c                       |    6 +-
 drivers/scsi/mpt3sas/mpt3sas_transport.c           |    2 +
 drivers/scsi/qla2xxx/qla_def.h                     |   22 +-
 drivers/scsi/qla2xxx/qla_init.c                    |   20 +-
 drivers/scsi/qla2xxx/qla_inline.h                  |    4 +-
 drivers/scsi/qla2xxx/qla_os.c                      |    4 +-
 drivers/scsi/scsi_debug.c                          |   11 +-
 drivers/scsi/scsi_error.c                          |   14 +-
 drivers/scsi/snic/snic_disc.c                      |    3 +
 drivers/scsi/ufs/ufshcd.c                          |    9 +-
 drivers/soc/mediatek/mtk-pm-domains.c              |    2 +-
 drivers/soc/qcom/apr.c                             |  142 +-
 drivers/soc/qcom/llcc-qcom.c                       |    2 +-
 drivers/soc/ti/knav_qmss_queue.c                   |    6 +-
 drivers/soc/ti/smartreflex.c                       |    1 +
 drivers/spi/spi-gpio.c                             |   16 +-
 drivers/spi/spidev.c                               |   21 +-
 drivers/staging/iio/accel/adis16203.c              |    1 +
 drivers/staging/iio/accel/adis16240.c              |    1 +
 drivers/staging/mt7621-pci/pci-mt7621.c            |   39 +-
 drivers/staging/rtl8192e/rtllib_rx.c               |    2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |    4 +-
 drivers/thermal/imx8mm_thermal.c                   |    8 +-
 drivers/thermal/qcom/lmh.c                         |    2 +-
 drivers/thermal/qcom/qcom-spmi-temp-alarm.c        |    3 +-
 drivers/thermal/thermal_core.c                     |   18 +-
 drivers/tty/serial/8250/8250_bcm7271.c             |   10 +-
 drivers/tty/serial/altera_uart.c                   |   21 +-
 drivers/tty/serial/amba-pl011.c                    |   14 +-
 drivers/tty/serial/pch_uart.c                      |    4 +
 drivers/tty/serial/serial-tegra.c                  |    6 +-
 drivers/tty/serial/stm32-usart.c                   |   47 +-
 drivers/tty/serial/sunsab.c                        |    8 +-
 drivers/uio/uio_dmem_genirq.c                      |   13 +-
 drivers/usb/cdns3/cdnsp-ring.c                     |   42 +-
 drivers/usb/dwc3/core.c                            |   23 +-
 drivers/usb/gadget/function/f_hid.c                |   53 +-
 drivers/usb/gadget/udc/fotg210-udc.c               |   12 +-
 drivers/usb/host/xhci-mtk.c                        |    1 -
 drivers/usb/host/xhci-ring.c                       |   14 +-
 drivers/usb/host/xhci.h                            |    2 +-
 drivers/usb/musb/musb_gadget.c                     |    2 -
 drivers/usb/roles/class.c                          |    5 +-
 drivers/usb/storage/alauda.c                       |    2 +
 drivers/usb/typec/bus.c                            |    2 +-
 drivers/usb/typec/class.c                          |   43 +
 drivers/usb/typec/tcpm/tcpci.c                     |    5 +-
 drivers/usb/typec/tcpm/tcpm.c                      |   24 +-
 drivers/usb/typec/tipd/core.c                      |    4 +-
 drivers/vfio/platform/vfio_platform_common.c       |    3 +-
 drivers/video/fbdev/Kconfig                        |    2 +-
 drivers/video/fbdev/core/fbcon.c                   |    3 +-
 drivers/video/fbdev/ep93xx-fb.c                    |    4 +-
 drivers/video/fbdev/geode/Kconfig                  |    1 +
 drivers/video/fbdev/hyperv_fb.c                    |    8 +-
 drivers/video/fbdev/pm2fb.c                        |    9 +-
 drivers/video/fbdev/uvesafb.c                      |    1 +
 drivers/video/fbdev/vermilion/vermilion.c          |    4 +-
 drivers/video/fbdev/via/via-core.c                 |    9 +-
 drivers/vme/bridges/vme_fake.c                     |    2 +
 drivers/vme/bridges/vme_tsi148.c                   |    1 +
 drivers/xen/privcmd.c                              |    2 +-
 fs/afs/fs_probe.c                                  |    5 +-
 fs/binfmt_misc.c                                   |    8 +-
 fs/btrfs/file.c                                    |   10 +-
 fs/char_dev.c                                      |    2 +-
 fs/configfs/dir.c                                  |    2 +
 fs/debugfs/file.c                                  |   28 +-
 fs/f2fs/gc.c                                       |   10 +-
 fs/f2fs/segment.c                                  |    6 +-
 fs/f2fs/super.c                                    |    2 +-
 fs/hfs/inode.c                                     |    2 +
 fs/hfs/trans.c                                     |    2 +-
 fs/hugetlbfs/inode.c                               |    6 +-
 fs/jfs/jfs_dmap.c                                  |   27 +-
 fs/jfs/namei.c                                     |    2 +-
 fs/ksmbd/mgmt/user_session.c                       |    8 +-
 fs/libfs.c                                         |   22 +-
 fs/lockd/svcsubs.c                                 |   17 +-
 fs/nfs/namespace.c                                 |    2 +-
 fs/nfs/nfs4proc.c                                  |   38 +-
 fs/nfs/nfs4state.c                                 |    2 +
 fs/nfs/nfs4xdr.c                                   |   12 +-
 fs/nfsd/nfs2acl.c                                  |   32 +-
 fs/nfsd/nfs4callback.c                             |    4 +-
 fs/nfsd/nfs4state.c                                |   51 +-
 fs/nilfs2/the_nilfs.c                              |   73 +-
 fs/ntfs3/bitmap.c                                  |    2 +-
 fs/ntfs3/super.c                                   |    2 +-
 fs/ntfs3/xattr.c                                   |    2 +-
 fs/ocfs2/stackglue.c                               |    8 +-
 fs/orangefs/orangefs-debugfs.c                     |   29 +-
 fs/orangefs/orangefs-mod.c                         |    8 +-
 fs/overlayfs/dir.c                                 |   10 +-
 fs/overlayfs/file.c                                |   43 +-
 fs/overlayfs/inode.c                               |   19 +-
 fs/overlayfs/overlayfs.h                           |   13 +-
 fs/overlayfs/ovl_entry.h                           |    2 +-
 fs/overlayfs/super.c                               |   12 +-
 fs/overlayfs/util.c                                |   47 +-
 fs/pstore/Kconfig                                  |    1 +
 fs/pstore/pmsg.c                                   |    7 +-
 fs/pstore/ram.c                                    |    2 +
 fs/pstore/ram_core.c                               |    6 +-
 fs/reiserfs/namei.c                                |    4 +
 fs/reiserfs/xattr_security.c                       |    2 +-
 fs/sysv/itree.c                                    |    2 +-
 fs/udf/namei.c                                     |    8 +-
 fs/xattr.c                                         |    2 +-
 include/dt-bindings/clock/imx8mn-clock.h           |   12 +-
 include/linux/debugfs.h                            |   19 +-
 include/linux/eventfd.h                            |    2 +-
 include/linux/fs.h                                 |   12 +-
 include/linux/gpio/consumer.h                      |   35 +-
 include/linux/hyperv.h                             |    2 +
 include/linux/iio/imu/adis.h                       |   63 +-
 include/linux/libata.h                             |   79 +-
 include/linux/netdevice.h                          |   58 +-
 include/linux/overflow.h                           |  110 +-
 include/linux/proc_fs.h                            |    2 +
 include/linux/skmsg.h                              |    1 +
 include/linux/soc/qcom/apr.h                       |   12 +-
 include/linux/timerqueue.h                         |    2 +-
 include/linux/usb/typec.h                          |    3 +
 include/media/dvbdev.h                             |   32 +-
 include/net/dst.h                                  |    5 +-
 include/net/mrp.h                                  |    1 +
 include/net/sock_reuseport.h                       |    2 +
 include/net/tcp.h                                  |    4 +-
 include/sound/hdaudio.h                            |    2 +
 include/sound/hdaudio_ext.h                        |    1 -
 include/sound/pcm.h                                |   36 +-
 include/trace/events/ib_mad.h                      |   13 +-
 include/uapi/drm/drm_fourcc.h                      |   11 +
 include/uapi/linux/idxd.h                          |    2 +-
 include/uapi/linux/swab.h                          |    2 +-
 include/uapi/sound/asequencer.h                    |    8 +-
 kernel/Makefile                                    |    2 +-
 kernel/acct.c                                      |    2 +
 kernel/bpf/btf.c                                   |    5 +
 kernel/bpf/verifier.c                              |  127 +-
 kernel/cpu.c                                       |   60 +-
 kernel/events/core.c                               |    8 +-
 kernel/fork.c                                      |   17 +-
 kernel/futex/Makefile                              |    3 +
 kernel/{futex.c => futex/core.c}                   |   28 +-
 kernel/gcov/gcc_4_7.c                              |    5 +
 kernel/irq/internals.h                             |    2 +
 kernel/irq/irqdesc.c                               |   15 +-
 kernel/padata.c                                    |   15 +-
 kernel/power/snapshot.c                            |    4 +-
 kernel/rcu/tree.c                                  |    2 +-
 kernel/relay.c                                     |    4 +-
 kernel/sched/cpudeadline.c                         |    2 +-
 kernel/sched/deadline.c                            |    4 +-
 kernel/sched/fair.c                                |  190 +-
 kernel/sched/rt.c                                  |    4 +-
 kernel/sched/sched.h                               |   14 +
 kernel/trace/blktrace.c                            |    3 +-
 kernel/trace/trace_events_hist.c                   |    2 +-
 lib/debugobjects.c                                 |   10 +
 lib/fonts/fonts.c                                  |    4 +-
 lib/notifier-error-inject.c                        |    2 +-
 lib/test_firmware.c                                |    1 +
 lib/test_overflow.c                                |   98 +
 net/802/mrp.c                                      |   18 +-
 net/9p/client.c                                    |    5 +
 net/bluetooth/hci_core.c                           |    2 +-
 net/bluetooth/mgmt.c                               |    2 +-
 net/bluetooth/rfcomm/core.c                        |    2 +-
 net/bpf/test_run.c                                 |    3 -
 net/core/dev.c                                     |   14 +-
 net/core/filter.c                                  |   11 +-
 net/core/skbuff.c                                  |    3 +
 net/core/skmsg.c                                   |    9 +-
 net/core/sock.c                                    |    2 +-
 net/core/sock_map.c                                |    2 +
 net/core/sock_reuseport.c                          |   94 +-
 net/core/stream.c                                  |    6 +
 net/dsa/tag_8021q.c                                |   11 +-
 net/ethtool/ioctl.c                                |    3 +-
 net/hsr/hsr_device.c                               |   22 +-
 net/hsr/hsr_forward.c                              |    7 +-
 net/hsr/hsr_framereg.c                             |   25 +-
 net/hsr/hsr_framereg.h                             |    3 +
 net/ipv4/inet_connection_sock.c                    |   12 +-
 net/ipv4/tcp_bpf.c                                 |   19 +-
 net/ipv4/udp_tunnel_core.c                         |    1 +
 net/ipv6/sit.c                                     |   22 +-
 net/mac80211/iface.c                               |    1 +
 net/netfilter/nf_conntrack_proto_icmpv6.c          |   53 +
 net/netfilter/nf_flow_table_offload.c              |    6 +-
 net/openvswitch/datapath.c                         |   25 +-
 net/rxrpc/output.c                                 |    2 +-
 net/rxrpc/sendmsg.c                                |    2 +-
 net/sched/ematch.c                                 |    2 +
 net/sctp/sysctl.c                                  |   73 +-
 net/sunrpc/clnt.c                                  |    2 +-
 net/sunrpc/xprtrdma/verbs.c                        |    2 +-
 net/tls/tls_sw.c                                   |    6 +-
 net/unix/af_unix.c                                 |   12 +-
 net/vmw_vsock/vmci_transport.c                     |    6 +-
 net/wireless/reg.c                                 |    4 +-
 samples/vfio-mdev/mdpy-fb.c                        |    8 +-
 security/Kconfig.hardening                         |    3 +
 security/apparmor/apparmorfs.c                     |    4 +-
 security/apparmor/lsm.c                            |    4 +-
 security/apparmor/policy.c                         |    2 +-
 security/apparmor/policy_ns.c                      |    2 +-
 security/apparmor/policy_unpack.c                  |    2 +-
 security/integrity/digsig.c                        |    6 +-
 security/integrity/ima/ima_policy.c                |   51 +-
 security/integrity/ima/ima_template.c              |    4 +-
 security/loadpin/loadpin.c                         |   30 +-
 sound/core/pcm_native.c                            |    4 +-
 sound/drivers/mts64.c                              |    3 +
 sound/hda/ext/hdac_ext_stream.c                    |   17 -
 sound/hda/hdac_stream.c                            |   27 +
 sound/pci/asihpi/hpioctl.c                         |    2 +-
 sound/pci/hda/hda_controller.c                     |    4 +-
 sound/pci/hda/patch_hdmi.c                         |    1 +
 sound/pci/hda/patch_realtek.c                      |   27 +
 sound/soc/codecs/pcm512x.c                         |    8 +-
 sound/soc/codecs/rt298.c                           |    7 +
 sound/soc/codecs/rt5670.c                          |    2 -
 sound/soc/codecs/wm8994.c                          |    5 +
 sound/soc/generic/audio-graph-card.c               |    4 +-
 sound/soc/intel/skylake/skl.c                      |    7 +-
 sound/soc/mediatek/common/mtk-btcvsd.c             |    6 +-
 sound/soc/mediatek/mt8173/mt8173-afe-pcm.c         |   71 +-
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c   |    7 +-
 .../mt8183/mt8183-mt6358-ts3a227-max98357.c        |   14 +-
 sound/soc/pxa/mmp-pcm.c                            |    2 +-
 sound/soc/qcom/lpass-sc7180.c                      |    3 +
 sound/soc/rockchip/rockchip_pdm.c                  |    1 +
 sound/soc/rockchip/rockchip_spdif.c                |    1 +
 sound/usb/quirks-table.h                           |    2 +
 tools/include/linux/kernel.h                       |    6 +
 tools/lib/bpf/bpf.h                                |    7 +
 tools/lib/bpf/btf.c                                |    8 +-
 tools/lib/bpf/btf_dump.c                           |   31 +-
 tools/lib/bpf/libbpf.c                             |    3 +
 tools/objtool/check.c                              |   10 +
 tools/perf/builtin-stat.c                          |   46 +-
 tools/perf/builtin-trace.c                         |   32 +-
 tools/perf/util/debug.c                            |    4 +
 tools/perf/util/symbol-elf.c                       |    2 +-
 tools/testing/selftests/bpf/config                 |    4 +
 tools/testing/selftests/bpf/prog_tests/bpf_nf.c    |   48 +
 tools/testing/selftests/bpf/progs/test_bpf_nf.c    |  109 +
 .../selftests/drivers/net/netdevsim/devlink.sh     |    4 +-
 tools/testing/selftests/efivarfs/efivarfs.sh       |    5 +
 .../ftrace/test.d/ftrace/func_event_triggers.tc    |   15 +-
 .../kvm/memslot_modification_stress_test.c         |    2 +-
 .../selftests/netfilter/conntrack_icmp_related.sh  |   36 +-
 .../selftests/powerpc/dscr/dscr_sysfs_test.c       |    5 +-
 tools/testing/selftests/proc/proc-uptime-002.c     |    3 +-
 727 files changed, 39668 insertions(+), 3853 deletions(-)


