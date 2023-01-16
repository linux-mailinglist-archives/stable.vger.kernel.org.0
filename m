Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4295E66CC4A
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 18:24:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234411AbjAPRYl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 12:24:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234585AbjAPRYH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 12:24:07 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BBD659E5D;
        Mon, 16 Jan 2023 09:01:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 89B1FB8108E;
        Mon, 16 Jan 2023 17:01:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E40FC433D2;
        Mon, 16 Jan 2023 17:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673888475;
        bh=nXYsYXTdJ2/5MNubvlKOFieWAeWb/FKHBfd6Yr8+2X4=;
        h=From:To:Cc:Subject:Date:From;
        b=JP0rMg9pj/MAN0DDVRLeob/ii5yksh/ChB6eWmrpvEY4/klLnPL/DbIkvlGfDJCkS
         q+Xr4FOC+pAdKOKXT5Ugpgtp6gocbHUrz9LcAicAim1i2Wfjp46FSJD3zJ88KZsg3p
         oGm/23TJciAh0o8vZsWbWi0AFB3E3MyE3lSNFtXU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 4.14 000/338] 4.14.303-rc1 review
Date:   Mon, 16 Jan 2023 16:47:53 +0100
Message-Id: <20230116154820.689115727@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.303-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.14.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.14.303-rc1
X-KernelTest-Deadline: 2023-01-18T15:48+00:00
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

This is the start of the stable review cycle for the 4.14.303 release.
There are 338 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.303-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 4.14.303-rc1

Ferry Toth <ftoth@exalondelft.nl>
    Revert "usb: ulpi: defer ulpi_register on ulpi_read_id timeout"

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    nfc: pn533: Wait for out_urb's completion in pn533_usb_send_frame()

Roger Pau Monne <roger.pau@citrix.com>
    hvc/xen: lock console list traversal

Ricardo Ribalda <ribalda@chromium.org>
    regulator: da9211: Use irq handler when ready

Eliav Farber <farbere@amazon.com>
    EDAC/device: Fix period calculation in edac_device_reset_delay_period()

Peter Zijlstra <peterz@infradead.org>
    x86/boot: Avoid using Intel mnemonics in AT&T syntax asm

Gavrilov Ilia <Ilia.Gavrilov@infotecs.ru>
    netfilter: ipset: Fix overflow before widen in the bitmap_ip_create() function.

Herbert Xu <herbert@gondor.apana.org.au>
    ipv6: raw: Deduct extension header length in rawv6_push_pending_frames

Hans de Goede <hdegoede@redhat.com>
    platform/x86: sony-laptop: Don't turn off 0x153 keyboard backlight during probe

Clement Lecigne <clecigne@google.com>
    ALSA: pcm: Move rwsem lock inside snd_ctl_elem_read to prevent UAF

Paolo Abeni <pabeni@redhat.com>
    net/ulp: prevent ULP without clone op from entering the LISTEN status

Heiko Carstens <hca@linux.ibm.com>
    s390/percpu: add READ_ONCE() to arch_this_cpu_to_op_simple()

Adrian Hunter <adrian.hunter@intel.com>
    perf auxtrace: Fix address filter duplicate symbol selection

Jonathan Corbet <corbet@lwn.net>
    docs: Fix the docs build with Sphinx 6.0

Frederick Lawler <fred@cloudflare.com>
    net: sched: disallow noqueue for qdisc classes

Biju Das <biju.das.jz@bp.renesas.com>
    ravb: Fix "failed to switch device to config mode" message during unbind

Isaac J. Manjarres <isaacmanjarres@google.com>
    driver core: Fix bus_type.match() error handling in __driver_attach()

Helge Deller <deller@gmx.de>
    parisc: Align parisc MADV_XXX constants with all other architectures

Linus Torvalds <torvalds@linux-foundation.org>
    hfs/hfsplus: avoid WARN_ON() for sanity check, use proper error handling

Arnd Bergmann <arnd@arndb.de>
    hfs/hfsplus: use WARN_ON for sanity check

Jeff Layton <jlayton@kernel.org>
    nfsd: fix handling of readdir in v4root vs. mount upcall timeout

Rodrigo Branco <bsdaemon@google.com>
    x86/bugs: Flush IBP in ib_prctl_set()

Jan Kara <jack@suse.cz>
    udf: Fix extension of the last extent in the file

Zhengchao Shao <shaozhengchao@huawei.com>
    caif: fix memory leak in cfctrl_linkup_request()

Szymon Heidrich <szymon.heidrich@gmail.com>
    usb: rndis_host: Secure rndis_query check against int overflow

Jamal Hadi Salim <jhs@mojatatu.com>
    net: sched: atm: dont intepret cls results when asked to drop

Miaoqian Lin <linmq006@gmail.com>
    net: phy: xgmiitorgmii: Fix refcount leak in xgmiitorgmii_probe

Jiguang Xiao <jiguang.xiao@windriver.com>
    net: amd-xgbe: add missed tasklet_kill

Miaoqian Lin <linmq006@gmail.com>
    nfc: Fix potential resource leaks

Daniil Tatianin <d-tatianin@yandex-team.ru>
    qlcnic: prevent ->dcb use-after-free on qlcnic_dcb_enable() failure

Jakub Kicinski <kuba@kernel.org>
    bpf: pull before calling skb_postpull_rcsum()

minoura makoto <minoura@valinux.co.jp>
    SUNRPC: ensure the matching upcall is in-flight upon downcall

Ye Bin <yebin10@huawei.com>
    ext4: allocate extended attribute value in vmalloc area

Jan Kara <jack@suse.cz>
    ext4: avoid unaccounted block allocation when expanding inode

Jan Kara <jack@suse.cz>
    ext4: initialize quota before expanding inode in setproject ioctl

Ye Bin <yebin10@huawei.com>
    ext4: fix inode leak in ext4_xattr_inode_create() on an error path

Jan Kara <jack@suse.cz>
    ext4: avoid BUG_ON when creating xattrs

Luís Henriques <lhenriques@suse.de>
    ext4: fix error code return to user-space in ext4_get_branch()

Ye Bin <yebin10@huawei.com>
    ext4: init quota for 'old.inode' in 'ext4_rename'

Baokun Li <libaokun1@huawei.com>
    ext4: fix bug_on in __es_tree_search caused by bad boot loader inode

Gaosheng Cui <cuigaosheng1@huawei.com>
    ext4: fix undefined behavior in bit shift for ext4_check_flag_values

Baokun Li <libaokun1@huawei.com>
    ext4: add inode table check in __ext4_get_inode_loc to aovid possible infinite loop

Zack Rusin <zackr@vmware.com>
    drm/vmwgfx: Validate the box size for the snooped cursor

Simon Ser <contact@emersion.fr>
    drm/connector: send hotplug uevent on connector cleanup

Wang Weiyang <wangweiyang2@huawei.com>
    device_cgroup: Roll back to original exceptions after copy failure

Shang XiaoJing <shangxiaojing@huawei.com>
    parisc: led: Fix potential null-ptr-deref in start_task()

Kim Phillips <kim.phillips@amd.com>
    iommu/amd: Fix ivrs_acpihid cmdline parsing code

Corentin Labbe <clabbe@baylibre.com>
    crypto: n2 - add missing hash statesize

Sascha Hauer <s.hauer@pengutronix.de>
    PCI/sysfs: Fix double free in error path

Michael S. Tsirkin <mst@redhat.com>
    PCI: Fix pci_device_is_present() for VFs by checking PF

Huaxin Lu <luhuaxin1@huawei.com>
    ima: Fix a potential NULL pointer access in ima_restore_measurement_list

Paulo Alcantara <pc@cjr.nz>
    cifs: fix confusing debug message

Takashi Iwai <tiwai@suse.de>
    media: dvb-core: Fix UAF due to refcount races at releasing

Keita Suzuki <keitasuzuki.park@sslab.ics.keio.ac.jp>
    media: dvb-core: Fix double free in dvb_register_device()

Nick Desaulniers <ndesaulniers@google.com>
    ARM: 9256/1: NWFPE: avoid compiler-generated __aeabi_uldivmod

Yang Jihong <yangjihong1@huawei.com>
    tracing: Fix infinite loop in tracing_read_pipe on overflowed print_trace_line

Ashok Raj <ashok.raj@intel.com>
    x86/microcode/intel: Do not retry microcode reloading on the APs

Mike Snitzer <snitzer@kernel.org>
    dm cache: set needs_check flag after aborting metadata

Luo Meng <luomeng12@huawei.com>
    dm cache: Fix UAF in destroy()

Luo Meng <luomeng12@huawei.com>
    dm thin: Fix UAF in run_timer_softirq()

Zhihao Cheng <chengzhihao1@huawei.com>
    dm thin: Use last transaction's pmd->root when commit failed

Mike Snitzer <snitzer@kernel.org>
    dm cache: Fix ABBA deadlock between shrink_slab and dm_cache_metadata_abort

Mickaël Salaün <mic@digikod.net>
    selftests: Use optional USERCFLAGS and USERLDFLAGS

Jason A. Donenfeld <Jason@zx2c4.com>
    ARM: ux500: do not directly dereference __iomem

Steven Rostedt <rostedt@goodmis.org>
    ktest.pl minconfig: Unset configs instead of just removing them

Jason A. Donenfeld <Jason@zx2c4.com>
    media: stv0288: use explicitly signed char

Hanjun Guo <guohanjun@huawei.com>
    tpm: tpm_tis: Add the missed acpi_put_table() to fix memory leak

Hanjun Guo <guohanjun@huawei.com>
    tpm: tpm_crb: Add the missed acpi_put_table() to fix memory leak

Deren Wu <deren.wu@mediatek.com>
    mmc: vub300: fix warning - do not call blocking ops when !TASK_RUNNING

Mikulas Patocka <mpatocka@redhat.com>
    md: fix a crash in mempool_free

Christian Brauner <brauner@kernel.org>
    pnode: terminate at peers of source

Artem Egorkine <arteme@gmail.com>
    ALSA: line6: fix stack overflow in line6_midi_transmit

Artem Egorkine <arteme@gmail.com>
    ALSA: line6: correct midi status byte when receiving data from podxt

Aditya Garg <gargaditya08@live.com>
    hfsplus: fix bug causing custom uid and gid being unable to be assigned with mount

Terry Junge <linuxhid@cosmicgizmosystems.com>
    HID: plantronics: Additional PIDs for double volume key presses quirk

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: avoid scheduling in rtas_os_term()

Nathan Lynch <nathanl@linux.ibm.com>
    powerpc/rtas: avoid device tree lookups in rtas_os_term()

Lin Ma <linma@zju.edu.cn>
    media: dvbdev: fix refcnt bug

Rickard x Andersson <rickaran@axis.com>
    gcov: add support for checksum field

Nuno Sá <nuno.sa@analog.com>
    iio: adc: ad_sigma_delta: do not use internal iio_dev lock

Roberto Sassu <roberto.sassu@huawei.com>
    reiserfs: Add missing calls to reiserfs_security_free()

Jason Gerecke <killertofu@gmail.com>
    HID: wacom: Ensure bootloader PID is usable in hidraw mode

Ferry Toth <ftoth@exalondelft.nl>
    usb: dwc3: core: defer probe on ulpi_read_id timeout

John Stultz <jstultz@google.com>
    pstore: Make sure CONFIG_PSTORE_PMSG selects CONFIG_RT_MUTEXES

John Stultz <jstultz@google.com>
    pstore: Switch pmsg_lock to an rt_mutex to avoid priority inversion

Hans de Goede <hdegoede@redhat.com>
    ASoC: rt5670: Remove unbalanced pm_runtime_put()

Wang Jingjin <wangjingjin1@huawei.com>
    ASoC: rockchip: spdif: Add missing clk_disable_unprepare() in rk_spdif_runtime_resume()

Marek Szyprowski <m.szyprowski@samsung.com>
    ASoC: wm8994: Fix potential deadlock

Wang Jingjin <wangjingjin1@huawei.com>
    ASoC: rockchip: pdm: Add missing clk_disable_unprepare() in rockchip_pdm_runtime_resume()

Wang Yufen <wangyufen@huawei.com>
    ASoC: mediatek: mt8173-rt5650-rt5514: fix refcount leak in mt8173_rt5650_rt5514_dev_probe()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    orangefs: Fix kmemleak in orangefs_prepare_debugfs_help_string()

Nathan Chancellor <nathan@kernel.org>
    drm/sti: Fix return type of sti_{dvo,hda,hdmi}_connector_mode_valid()

Nathan Chancellor <nathan@kernel.org>
    drm/fsl-dcu: Fix return type of fsl_dcu_drm_connector_mode_valid()

Xiu Jianfeng <xiujianfeng@huawei.com>
    clk: st: Fix memory leak in st_of_quadfs_setup()

Shigeru Yoshida <syoshida@redhat.com>
    media: si470x: Fix use-after-free in si470x_int_in_callback()

Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
    mmc: f-sdh30: Add quirks for broken timeout clock capability

Ye Bin <yebin10@huawei.com>
    blk-mq: fix possible memleak when register 'hctx' failed

Mazin Al Haddad <mazinalhaddad05@gmail.com>
    media: dvb-usb: fix memory leak in dvb_usb_adapter_init()

Lin Ma <linma@zju.edu.cn>
    media: dvbdev: adopts refcnt to avoid UAF

Yan Lei <yan_lei@dahuatech.com>
    media: dvb-frontends: fix leak of memory fw

Stanislav Fomichev <sdf@google.com>
    ppp: associate skb with a device at tx

Schspa Shi <schspa@gmail.com>
    mrp: introduce active flags to prevent UAF when applicant uninit

Jiang Li <jiang.li@ugreen.com>
    md/raid1: stop mdx_raid1 thread when raid1 array run failed

Ville Syrjälä <ville.syrjala@linux.intel.com>
    drm/sti: Use drm_mode_copy()

Nathan Chancellor <nathan@kernel.org>
    s390/lcs: Fix return type of lcs_start_xmit()

Nathan Chancellor <nathan@kernel.org>
    s390/netiucv: Fix return type of netiucv_tx()

Nathan Chancellor <nathan@kernel.org>
    s390/ctcm: Fix return type of ctc{mp,}m_tx()

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

Zhang Yuchen <zhangyuchen.lcr@bytedance.com>
    ipmi: fix memleak when unload ipmi driver

Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
    ASoC: codecs: rt298: Add quirk for KBL-R RVP platform

Shigeru Yoshida <syoshida@redhat.com>
    wifi: ar5523: Fix use-after-free on ar5523_cmd() timed out

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: ath9k: verify the expected usb_endpoints are present

ZhangPeng <zhangpeng362@huawei.com>
    hfs: fix OOB Read in __hfs_brec_find

Zheng Yejian <zhengyejian1@huawei.com>
    acct: fix potential integer overflow in encode_comp_t()

Ryusuke Konishi <konishi.ryusuke@gmail.com>
    nilfs2: fix shift-out-of-bounds/overflow in nilfs_sb2_bad_offset()

Rafael J. Wysocki <rafael.j.wysocki@intel.com>
    ACPICA: Fix error code path in acpi_ds_call_control_method()

Hoi Pok Wu <wuhoipok@gmail.com>
    fs: jfs: fix shift-out-of-bounds in dbDiscardAG

Shigeru Yoshida <syoshida@redhat.com>
    udf: Avoid double brelse() in udf_rename()

Dongliang Mu <mudongliangabcd@gmail.com>
    fs: jfs: fix shift-out-of-bounds in dbAllocAG

Liu Shixin <liushixin2@huawei.com>
    binfmt_misc: fix shift-out-of-bounds in check_special_flags

Eric Dumazet <edumazet@google.com>
    net: stream: purge sk_error_queue in sk_stream_kill_queues()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    myri10ge: Fix an error handling path in myri10ge_probe()

Cong Wang <cong.wang@bytedance.com>
    net_sched: reject TCF_EM_SIMPLE case for complex ematch module

Subash Abhinov Kasiviswanathan <quic_subashab@quicinc.com>
    skbuff: Account for tail adjustment during pull operations

Eelco Chaudron <echaudro@redhat.com>
    openvswitch: Fix flow lookup to use unmasked key

Li Zetao <lizetao1@huawei.com>
    r6040: Fix kmemleak in probe and remove

Minsuk Kang <linuxlovemin@yonsei.ac.kr>
    nfc: pn533: Clear nfc_target before being used

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: hfcmulti: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: hfcpci: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: hfcsusb: don't call dev_kfree_skb/kfree_skb() under spin_lock_irqsave()

Dan Aloni <dan.aloni@vastdata.com>
    nfsd: under NFSv4.1, fix double svc_xprt_put on rpc_create failure

Gaosheng Cui <cuigaosheng1@huawei.com>
    rtc: st-lpc: Add missing clk_disable_unprepare in st_rtc_probe()

Miaoqian Lin <linmq006@gmail.com>
    selftests/powerpc: Fix resource leaks

Kajol Jain <kjain@linux.ibm.com>
    powerpc/hv-gpci: Fix hv_gpci event list

Yang Yingliang <yangyingliang@huawei.com>
    powerpc/83xx/mpc832x_rdb: call platform_device_put() in error case in of_fsl_spi_probe()

Nicholas Piggin <npiggin@gmail.com>
    powerpc/perf: callchain validate kernel stack pointer bounds

Yang Yingliang <yangyingliang@huawei.com>
    powerpc/xive: add missing iounmap() in error path in xive_spapr_populate_irq_data()

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

Stefan Eichenberger <stefan.eichenberger@toradex.com>
    rtc: snvs: Allow a time difference on clock register read

Matt Redfearn <matt.redfearn@mips.com>
    include/uapi/linux/swab: Fix potentially missing __always_inline

Yuan Can <yuancan@huawei.com>
    HSI: omap_ssi_core: Fix error handling in ssi_init()

Zeng Heng <zengheng4@huawei.com>
    power: supply: fix residue sysfs file in error handle route of __power_supply_register()

Yang Yingliang <yangyingliang@huawei.com>
    HSI: omap_ssi_core: fix possible memory leak in ssi_probe()

Yang Yingliang <yangyingliang@huawei.com>
    HSI: omap_ssi_core: fix unbalanced pm_runtime_disable()

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    fbdev: uvesafb: Fixes an error handling path in uvesafb_probe()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    fbdev: vermilion: decrease reference count in error path

Shang XiaoJing <shangxiaojing@huawei.com>
    fbdev: via: Fix error in via_core_init()

Yang Yingliang <yangyingliang@huawei.com>
    fbdev: pm2fb: fix missing pci_disable_device()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    fbdev: ssd1307fb: Drop optional dependency

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    usb: storage: Add check for kcalloc

Zheyu Ma <zheyuma97@gmail.com>
    i2c: ismt: Fix an out-of-bounds bug in ismt_access()

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

Yang Yingliang <yangyingliang@huawei.com>
    cxl: fix possible null-ptr-deref in cxl_pci_init_afu|adapter()

Yang Yingliang <yangyingliang@huawei.com>
    cxl: fix possible null-ptr-deref in cxl_guest_init_afu|adapter()

Zheng Wang <zyytlz.wz@163.com>
    misc: sgi-gru: fix use-after-free error in gru_set_context_option, gru_fault and gru_handle_user_call_os

ruanjinjie <ruanjinjie@huawei.com>
    misc: tifm: fix possible memory leak in tifm_7xx1_switch_media()

Zhengchao Shao <shaozhengchao@huawei.com>
    test_firmware: fix memory leak in test_firmware_init()

Yuan Can <yuancan@huawei.com>
    serial: sunsab: Fix error handling in sunsab_init()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    serial: pch: Fix PCI device refcount leak in pch_request_dma()

Jiamei Xie <jiamei.xie@arm.com>
    serial: amba-pl011: avoid SBSA UART accessing DMACR register

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

Yang Yingliang <yangyingliang@huawei.com>
    drivers: dio: fix possible memory leak in dio_init()

Dragos Tatulea <dtatulea@nvidia.com>
    IB/IPoIB: Fix queue count inconsistency for PKEY child interfaces

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    hwrng: geode - Fix PCI device refcount leak

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    hwrng: amd - Fix PCI device refcount leak

Gaosheng Cui <cuigaosheng1@huawei.com>
    crypto: img-hash - Fix variable dereferenced before check 'hdev->req'

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    orangefs: Fix sysfs not cleanup when dev init failed

Wang Yufen <wangyufen@huawei.com>
    RDMA/hfi1: Fix error return code in parse_platform_config()

Gaosheng Cui <cuigaosheng1@huawei.com>
    scsi: snic: Fix possible UAF in snic_tgt_create()

Chen Zhongjin <chenzhongjin@huawei.com>
    scsi: fcoe: Fix transport not deattached when fcoe_if_init() fails

Shang XiaoJing <shangxiaojing@huawei.com>
    scsi: ipr: Fix WARNING in ipr_init()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: fcoe: Fix possible name leak when device_register() fails

Yang Yingliang <yangyingliang@huawei.com>
    scsi: hpsa: Fix possible memory leak in hpsa_add_sas_device()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: hpsa: Fix error handling in hpsa_add_sas_host()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    RDMA/rxe: Fix NULL-ptr-deref in rxe_qp_do_cleanup() when socket create failed

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    RDMA/hfi: Decrease PCI device reference count in error path

Zeng Heng <zengheng4@huawei.com>
    PCI: Check for alloc failure in pci_request_irq()

Gaosheng Cui <cuigaosheng1@huawei.com>
    apparmor: fix a memleak in multi_transaction_new()

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
    Bluetooth: hci_qca: don't call kfree_skb() under spin_lock_irqsave()

Yang Yingliang <yangyingliang@huawei.com>
    Bluetooth: btusb: don't call kfree_skb() under spin_lock_irqsave()

Eric Pilmore <epilmore@gigaio.com>
    ntb_netdev: Use dev_kfree_skb_any() in interrupt context

Jerry Ray <jerry.ray@microchip.com>
    net: lan9303: Fix read error execution path

Tom Lendacky <thomas.lendacky@amd.com>
    net: amd-xgbe: Check only the minimum speed for active/passive cables

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

Yuan Can <yuancan@huawei.com>
    drivers: net: qlcnic: Fix potential memory leak in qlcnic_sriov_init()

Yongqiang Liu <liuyongqiang13@huawei.com>
    net: defxx: Fix missing err handling in dfx_init()

Artem Chernyshev <artem.chernyshev@red-soft.ru>
    net: vmw_vsock: vmci: Check memcpy_from_msg()

Yang Jihong <yangjihong1@huawei.com>
    blktrace: Fix output non-blktrace event when blk_classic option enabled

Wang Yufen <wangyufen@huawei.com>
    wifi: brcmfmac: Fix error return code in brcmf_sdio_download_firmware()

Bitterblue Smith <rtl8821cerfe2@gmail.com>
    wifi: rtl8xxxu: Add __packed to struct rtl8723bu_c2h

Xiu Jianfeng <xiujianfeng@huawei.com>
    clk: samsung: Fix memory leak in _samsung_clk_register_pll()

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: coda: Add check for kmalloc

Jiasheng Jiang <jiasheng@iscas.ac.cn>
    media: coda: Add check for dcoda_iram_alloc

Liang He <windhl@126.com>
    media: c8sectpfe: Add of_node_put() when breaking out of loop

Yang Yingliang <yangyingliang@huawei.com>
    mmc: mmci: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: wbsd: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: via-sdmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: wmt-sdmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: vub300: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: toshsd: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: rtsx_usb_sdmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: mxcmmc: fix return value check of mmc_add_host()

Yang Yingliang <yangyingliang@huawei.com>
    mmc: moxart: fix return value check of mmc_add_host()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.x: Fail client initialisation if state manager thread can't run

Wang ShaoBo <bobo.shaobowang@huawei.com>
    SUNRPC: Fix missing release socket in rpc_sockname()

Gaosheng Cui <cuigaosheng1@huawei.com>
    ALSA: mts64: fix possible null-ptr-defer in snd_mts64_interrupt

Liu Shixin <liushixin2@huawei.com>
    media: saa7164: fix missing pci_disable_device()

Yang Yingliang <yangyingliang@huawei.com>
    regulator: core: fix module refcount leak in set_supply()

Zhengchao Shao <shaozhengchao@huawei.com>
    wifi: mac80211: fix memory leak in ieee80211_if_add()

Dan Carpenter <error27@gmail.com>
    bonding: uninitialized variable in bond_miimon_inspect()

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: pcm512x: Fix PM disable depth imbalance in pcm512x_probe

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    drm/amdgpu: Fix PCI device refcount leak in amdgpu_atrm_get_bios()

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    drm/radeon: Fix PCI device refcount leak in radeon_atrm_get_bios()

Liu Shixin <liushixin2@huawei.com>
    ALSA: asihpi: fix missing pci_disable_device()

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4: Fix a deadlock between nfs4_open_recover_helper() and delegreturn

Trond Myklebust <trond.myklebust@hammerspace.com>
    NFSv4.2: Fix a memory stomp in decode_attr_security_label

Aakarsh Jain <aakarsh.jain@samsung.com>
    media: s5p-mfc: Add variant data for MFC v7 hardware for Exynos 3250 SoC

Baisong Zhong <zhongbaisong@huawei.com>
    media: dvb-usb: az6027: fix null-ptr-deref in az6027_i2c_xfer()

ZhangPeng <zhangpeng362@huawei.com>
    pinctrl: pinconf-generic: add missing of_node_put()

Gautam Menghani <gautammenghani201@gmail.com>
    media: imon: fix a race condition in send_packet()

Zheng Yongjun <zhengyongjun3@huawei.com>
    mtd: maps: pxa2xx-flash: fix memory leak in probe

Xiu Jianfeng <xiujianfeng@huawei.com>
    clk: rockchip: Fix memory leak in rockchip_clk_register_pll()

Baisong Zhong <zhongbaisong@huawei.com>
    ALSA: seq: fix undefined behavior in bit shift for SNDRV_SEQ_FILTER_USE_EVENT

Marcus Folkesson <marcus.folkesson@gmail.com>
    HID: hid-sensor-custom: set fixed size for custom attributes

Yuan Can <yuancan@huawei.com>
    media: platform: exynos4-is: Fix error handling in fimc_md_init()

Yang Yingliang <yangyingliang@huawei.com>
    media: solo6x10: fix possible memory leak in solo_sysfs_init()

Douglas Anderson <dianders@chromium.org>
    Input: elants_i2c - properly handle the reset GPIO when power is off

Hui Tang <tanghui20@huawei.com>
    mtd: lpddr2_nvm: Fix possible null-ptr-deref

Xiu Jianfeng <xiujianfeng@huawei.com>
    wifi: ath10k: Fix return value in ath10k_pci_init()

Xiu Jianfeng <xiujianfeng@huawei.com>
    ima: Fix misuse of dereference of pointer in template_desc_init_fields()

Yang Yingliang <yangyingliang@huawei.com>
    regulator: core: fix unbalanced of node refcount in regulator_dev_lookup()

Zeng Heng <zengheng4@huawei.com>
    ASoC: pxa: fix null-pointer dereference in filter()

Hanjun Guo <guohanjun@huawei.com>
    drm/radeon: Add the missed acpi_put_table() to fix memory leak

Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
    media: camss: Clean up received buffers on failed start of streaming

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    mtd: Fix device name leak when register device failed in add_mtd_device()

Liu Shixin <liushixin2@huawei.com>
    media: vivid: fix compose size exceed boundary

Jonathan Neuschäfer <j.neuschaefer@gmx.net>
    spi: Update reference to struct spi_controller

Ricardo Ribalda <ribalda@chromium.org>
    media: i2c: ad5820: Fix error path

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: ath9k: hif_usb: Fix use-after-free in ath9k_hif_usb_reg_in_cb()

Fedor Pchelkin <pchelkin@ispras.ru>
    wifi: ath9k: hif_usb: fix memory leak of urbs in ath9k_hif_usb_dealloc_tx_urbs()

Cai Xinchen <caixinchen1@huawei.com>
    rapidio: devices: fix missing put_device in mport_cdev_open

ZhangPeng <zhangpeng362@huawei.com>
    hfs: Fix OOB Write in hfs_asc2mac

Zhang Qilong <zhangqilong3@huawei.com>
    eventfd: change int to __u64 in eventfd_signal() ifndef CONFIG_EVENTFD

Wang Weiyang <wangweiyang2@huawei.com>
    rapidio: fix possible UAF when kfifo_alloc() fails

Chen Zhongjin <chenzhongjin@huawei.com>
    fs: sysv: Fix sysv_nblocks() returns wrong value

Anastasia Belova <abelova@astralinux.ru>
    MIPS: BCM63xx: Add check for NULL for clk in clk_enable

Yu Liao <liaoyu15@huawei.com>
    platform/x86: mxm-wmi: fix memleak in mxm_wmi_call_mx[ds|mx]()

Xiu Jianfeng <xiujianfeng@huawei.com>
    x86/xen: Fix memory leak in xen_init_lock_cpu()

Oleg Nesterov <oleg@redhat.com>
    uprobes/x86: Allow to probe a NOP instruction with 0x66 prefix

Li Zetao <lizetao1@huawei.com>
    ACPICA: Fix use-after-free in acpi_ut_copy_ipackage_to_ipackage()

Yang Yingliang <yangyingliang@huawei.com>
    rapidio: rio: fix possible name leak in rio_register_mport()

Yang Yingliang <yangyingliang@huawei.com>
    rapidio: fix possible name leaks when rio_add_device() fails

Akinobu Mita <akinobu.mita@gmail.com>
    lib/notifier-error-inject: fix error when writing -errno to debugfs file

Akinobu Mita <akinobu.mita@gmail.com>
    libfs: add DEFINE_SIMPLE_ATTRIBUTE_SIGNED for signed value

Shang XiaoJing <shangxiaojing@huawei.com>
    irqchip: gic-pm: Use pm_runtime_resume_and_get() in gic_probe()

Yang Yingliang <yangyingliang@huawei.com>
    PNP: fix name memory leak in pnp_alloc_dev()

Yang Yingliang <yangyingliang@huawei.com>
    MIPS: vpe-cmp: fix possible memory leak while module exiting

Yang Yingliang <yangyingliang@huawei.com>
    MIPS: vpe-mt: fix possible memory leak while module exiting

Shang XiaoJing <shangxiaojing@huawei.com>
    ocfs2: fix memory leak in ocfs2_stack_glue_init()

Barnabás Pőcze <pobrn@protonmail.com>
    timerqueue: Use rb_entry_safe() in timerqueue_getnext()

Chen Zhongjin <chenzhongjin@huawei.com>
    perf: Fix possible memleak in pmu_dev_alloc()

Ondrej Mosnacek <omosnace@redhat.com>
    fs: don't audit the capability check in simple_xattr_list()

xiongxin <xiongxin@kylinos.cn>
    PM: hibernate: Fix mistake in kerneldoc comment

Al Viro <viro@zeniv.linux.org.uk>
    alpha: fix syscall entry in !AUDUT_SYSCALL case

Ulf Hansson <ulf.hansson@linaro.org>
    cpuidle: dt: Return the correct numbers of parsed idle states

Michael Kelley <mikelley@microsoft.com>
    tpm/tpm_crb: Fix error message in __crb_relinquish_locality()

Stephen Boyd <swboyd@chromium.org>
    pstore: Avoid kcore oops by vmap()ing with VM_IOREMAP

Doug Brown <doug@schmorgal.com>
    ARM: mmp: fix timer_read delay

Wang Yufen <wangyufen@huawei.com>
    pstore/ram: Fix error return code in ramoops_probe()

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

Zhang Qilong <zhangqilong3@huawei.com>
    soc: ti: smartreflex: Fix PM disable depth imbalance in omap_sr_probe

Kory Maincent <kory.maincent@bootlin.com>
    arm: dts: spear600: Fix clcd interrupt

Chen Jiahao <chenjiahao16@huawei.com>
    drivers: soc: ti: knav_qmss_queue: Mark knav_acc_firmwares as static

Luca Weiss <luca@z3ntu.xyz>
    ARM: dts: qcom: apq8064: fix coresight compatible

Ivaylo Dimitrov <ivo.g.dimitrov.75@gmail.com>
    usb: musb: remove extra check in musb_gadget_vbus_draw

Rasmus Villemoes <linux@rasmusvillemoes.dk>
    net: loopback: use NET_NAME_PREDICTABLE for name_assign_type

Sungwoo Kim <iam@sung-woo.kim>
    Bluetooth: L2CAP: Fix u8 overflow

Tony Nguyen <anthony.l.nguyen@intel.com>
    igb: Initialize mailbox message for VF reset

Bruno Thomsen <bruno.thomsen@gmail.com>
    USB: serial: cp210x: add Kamstrup RF sniffer PIDs

Duke Xin <duke_xinanwen@163.com>
    USB: serial: option: add Quectel EM05-G modem

Szymon Heidrich <szymon.heidrich@gmail.com>
    usb: gadget: uvc: Prevent buffer overflow in setup handler

Jan Kara <jack@suse.cz>
    udf: Fix extending file within last block

Jan Kara <jack@suse.cz>
    udf: Do not bother looking for prealloc extents if i_lenExtents matches i_size

Jan Kara <jack@suse.cz>
    udf: Fix preallocation discarding at indirect extent boundary

Jan Kara <jack@suse.cz>
    udf: Drop unused arguments of udf_delete_aext()

Jan Kara <jack@suse.cz>
    udf: Discard preallocation before extending file with a hole

Tony Jones <tonyj@suse.de>
    perf script python: Remove explicit shebang from tests/attr.c

Charles Keepax <ckeepax@opensource.cirrus.com>
    ASoC: ops: Correct bounds check for second channel on SX controls

Yasushi SHOJI <yasushi.shoji@gmail.com>
    can: mcba_usb: Fix termination command argument

Heiko Schocher <hs@denx.de>
    can: sja1000: fix size of OCR_MODE_MASK define

Mark Brown <broonie@kernel.org>
    ASoC: ops: Check bounds for second channel in snd_soc_put_volsw_sx()

Jialiang Wang <wangjialiang0806@163.com>
    nfp: fix use-after-free in area_cache_get()

Ming Lei <ming.lei@redhat.com>
    block: unhash blkdev part inode when the part is deleted

Jann Horn <jannh@google.com>
    mm/khugepaged: invoke MMU notifiers in shmem/file collapse paths

Jann Horn <jannh@google.com>
    mm/khugepaged: fix GUP-fast interaction by sending IPI

Eric Dumazet <edumazet@google.com>
    once: add DO_ONCE_SLOW() for sleepable contexts

Ben Hutchings <ben@decadent.org.uk>
    libtraceevent: Fix build with binutils 2.35


-------------

Diffstat:

 Documentation/driver-api/spi.rst                   |  4 +-
 Documentation/sphinx/load_config.py                |  6 +-
 Makefile                                           |  4 +-
 arch/alpha/kernel/entry.S                          |  4 +-
 arch/arm/boot/dts/armada-370.dtsi                  |  2 +-
 arch/arm/boot/dts/armada-375.dtsi                  |  2 +-
 arch/arm/boot/dts/armada-380.dtsi                  |  4 +-
 arch/arm/boot/dts/armada-385-turris-omnia.dts      | 18 ++++-
 arch/arm/boot/dts/armada-385.dtsi                  |  6 +-
 arch/arm/boot/dts/armada-39x.dtsi                  |  6 +-
 arch/arm/boot/dts/armada-xp-mv78230.dtsi           |  8 +--
 arch/arm/boot/dts/armada-xp-mv78260.dtsi           | 16 ++---
 arch/arm/boot/dts/dove.dtsi                        |  2 +-
 arch/arm/boot/dts/qcom-apq8064.dtsi                |  2 +-
 arch/arm/boot/dts/spear600.dtsi                    |  2 +-
 arch/arm/mach-mmp/time.c                           | 11 +--
 arch/arm/nwfpe/Makefile                            |  6 ++
 arch/arm64/boot/dts/mediatek/mt6797.dtsi           |  2 +-
 arch/mips/bcm63xx/clk.c                            |  2 +
 arch/mips/kernel/vpe-cmp.c                         |  4 +-
 arch/mips/kernel/vpe-mt.c                          |  4 +-
 arch/parisc/include/uapi/asm/mman.h                | 17 +++--
 arch/parisc/kernel/sys_parisc.c                    | 27 +++++++
 arch/parisc/kernel/syscall_table.S                 |  2 +-
 arch/powerpc/kernel/rtas.c                         | 20 ++++--
 arch/powerpc/perf/callchain.c                      |  1 +
 arch/powerpc/perf/hv-gpci-requests.h               |  4 ++
 arch/powerpc/perf/hv-gpci.c                        | 33 ++++++++-
 arch/powerpc/perf/hv-gpci.h                        |  1 +
 arch/powerpc/perf/req-gen/perf.h                   | 20 ++++++
 arch/powerpc/platforms/52xx/mpc52xx_lpbfifo.c      |  1 +
 arch/powerpc/platforms/83xx/mpc832x_rdb.c          |  2 +-
 arch/powerpc/sysdev/xive/spapr.c                   |  1 +
 arch/s390/include/asm/percpu.h                     |  2 +-
 arch/x86/boot/bioscall.S                           |  4 +-
 arch/x86/kernel/cpu/bugs.c                         |  2 +
 arch/x86/kernel/cpu/microcode/intel.c              |  8 +--
 arch/x86/kernel/uprobes.c                          |  4 +-
 arch/x86/xen/spinlock.c                            |  6 +-
 block/blk-mq-sysfs.c                               | 11 ++-
 block/partition-generic.c                          |  6 ++
 drivers/acpi/acpica/dsmethod.c                     | 10 ++-
 drivers/acpi/acpica/utcopy.c                       |  7 --
 drivers/base/class.c                               |  5 ++
 drivers/base/dd.c                                  |  8 ++-
 drivers/bluetooth/btusb.c                          |  6 +-
 drivers/bluetooth/hci_bcsp.c                       |  2 +-
 drivers/bluetooth/hci_h5.c                         |  2 +-
 drivers/bluetooth/hci_qca.c                        |  2 +-
 drivers/char/hw_random/amd-rng.c                   | 18 +++--
 drivers/char/hw_random/geode-rng.c                 | 36 +++++++---
 drivers/char/ipmi/ipmi_msghandler.c                |  8 ++-
 drivers/char/tpm/tpm_crb.c                         | 31 +++++---
 drivers/char/tpm/tpm_tis.c                         |  9 +--
 drivers/clk/rockchip/clk-pll.c                     |  1 +
 drivers/clk/samsung/clk-pll.c                      |  1 +
 drivers/clk/st/clkgen-fsyn.c                       |  5 +-
 drivers/cpuidle/dt_idle_states.c                   |  2 +-
 drivers/crypto/img-hash.c                          |  8 ++-
 drivers/crypto/n2_core.c                           |  6 ++
 drivers/dio/dio.c                                  |  8 +++
 drivers/edac/edac_device.c                         | 17 +++--
 drivers/edac/edac_module.h                         |  2 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_bios.c           |  1 +
 drivers/gpu/drm/drm_connector.c                    |  3 +
 drivers/gpu/drm/fsl-dcu/fsl_dcu_drm_rgb.c          |  5 +-
 drivers/gpu/drm/radeon/radeon_bios.c               | 19 +++--
 drivers/gpu/drm/sti/sti_dvo.c                      |  7 +-
 drivers/gpu/drm/sti/sti_hda.c                      |  7 +-
 drivers/gpu/drm/sti/sti_hdmi.c                     |  7 +-
 drivers/gpu/drm/vmwgfx/vmwgfx_kms.c                |  3 +-
 drivers/hid/hid-ids.h                              |  3 +
 drivers/hid/hid-plantronics.c                      |  9 +++
 drivers/hid/hid-sensor-custom.c                    |  2 +-
 drivers/hid/wacom_sys.c                            |  8 +++
 drivers/hid/wacom_wac.c                            |  4 ++
 drivers/hid/wacom_wac.h                            |  1 +
 drivers/hsi/controllers/omap_ssi_core.c            | 14 +++-
 drivers/i2c/busses/i2c-ismt.c                      |  3 +
 drivers/i2c/busses/i2c-pxa-pci.c                   | 10 +--
 drivers/iio/adc/ad_sigma_delta.c                   |  8 +--
 drivers/infiniband/hw/hfi1/affinity.c              |  2 +
 drivers/infiniband/hw/hfi1/firmware.c              |  6 ++
 drivers/infiniband/sw/rxe/rxe_qp.c                 |  6 +-
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c       |  7 ++
 drivers/input/touchscreen/elants_i2c.c             |  9 +--
 drivers/iommu/amd_iommu_init.c                     |  7 ++
 drivers/iommu/amd_iommu_v2.c                       |  1 +
 drivers/iommu/fsl_pamu.c                           |  2 +-
 drivers/irqchip/irq-gic-pm.c                       |  2 +-
 drivers/isdn/hardware/mISDN/hfcmulti.c             | 19 +++--
 drivers/isdn/hardware/mISDN/hfcpci.c               | 13 ++--
 drivers/isdn/hardware/mISDN/hfcsusb.c              | 12 ++--
 drivers/macintosh/macio-adb.c                      |  4 ++
 drivers/macintosh/macio_asic.c                     |  2 +-
 drivers/mcb/mcb-core.c                             |  4 +-
 drivers/mcb/mcb-parse.c                            |  2 +-
 drivers/md/dm-cache-metadata.c                     | 54 ++++++++++++--
 drivers/md/dm-cache-target.c                       | 11 +--
 drivers/md/dm-thin-metadata.c                      |  9 +++
 drivers/md/dm-thin.c                               |  2 +
 drivers/md/md.c                                    |  9 ++-
 drivers/md/raid1.c                                 |  1 +
 drivers/media/dvb-core/dmxdev.c                    |  8 +++
 drivers/media/dvb-core/dvb_ca_en50221.c            |  2 +-
 drivers/media/dvb-core/dvb_frontend.c              |  2 +-
 drivers/media/dvb-core/dvbdev.c                    | 33 +++++++--
 drivers/media/dvb-core/dvbdev.h                    | 31 ++++----
 drivers/media/dvb-frontends/bcm3510.c              |  1 +
 drivers/media/dvb-frontends/stv0288.c              |  5 +-
 drivers/media/i2c/ad5820.c                         | 10 +--
 drivers/media/pci/saa7164/saa7164-core.c           |  4 +-
 drivers/media/pci/solo6x10/solo6x10-core.c         |  1 +
 drivers/media/platform/coda/coda-bit.c             | 14 ++--
 drivers/media/platform/exynos4-is/fimc-core.c      |  2 +-
 drivers/media/platform/exynos4-is/media-dev.c      |  6 +-
 .../media/platform/qcom/camss-8x16/camss-video.c   |  3 +-
 drivers/media/platform/s5p-mfc/s5p_mfc.c           | 17 ++++-
 .../media/platform/sti/c8sectpfe/c8sectpfe-core.c  |  1 +
 drivers/media/platform/vivid/vivid-vid-cap.c       |  1 +
 drivers/media/radio/si470x/radio-si470x-usb.c      |  4 +-
 drivers/media/rc/imon.c                            |  6 +-
 drivers/media/usb/dvb-usb/az6027.c                 |  4 ++
 drivers/media/usb/dvb-usb/dvb-usb-init.c           |  4 +-
 drivers/misc/cxl/guest.c                           | 24 ++++---
 drivers/misc/cxl/pci.c                             | 21 +++---
 drivers/misc/sgi-gru/grufault.c                    | 13 +++-
 drivers/misc/sgi-gru/grumain.c                     | 22 ++++--
 drivers/misc/sgi-gru/grutables.h                   |  2 +-
 drivers/misc/tifm_7xx1.c                           |  2 +-
 drivers/mmc/host/mmci.c                            |  4 +-
 drivers/mmc/host/moxart-mmc.c                      |  4 +-
 drivers/mmc/host/mxcmmc.c                          |  4 +-
 drivers/mmc/host/rtsx_usb_sdmmc.c                  | 11 ++-
 drivers/mmc/host/sdhci_f_sdh30.c                   |  3 +
 drivers/mmc/host/toshsd.c                          |  6 +-
 drivers/mmc/host/via-sdmmc.c                       |  4 +-
 drivers/mmc/host/vub300.c                          | 13 +++-
 drivers/mmc/host/wbsd.c                            | 12 +++-
 drivers/mmc/host/wmt-sdmmc.c                       |  6 +-
 drivers/mtd/lpddr/lpddr2_nvm.c                     |  2 +
 drivers/mtd/maps/pxa2xx-flash.c                    |  2 +
 drivers/mtd/mtdcore.c                              |  4 +-
 drivers/net/bonding/bond_main.c                    |  2 +-
 drivers/net/can/usb/mcba_usb.c                     | 10 ++-
 drivers/net/dsa/lan9303-core.c                     |  4 +-
 drivers/net/ethernet/amd/atarilance.c              |  2 +-
 drivers/net/ethernet/amd/lance.c                   |  2 +-
 drivers/net/ethernet/amd/xgbe/xgbe-drv.c           |  3 +
 drivers/net/ethernet/amd/xgbe/xgbe-i2c.c           |  4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-mdio.c          |  4 +-
 drivers/net/ethernet/amd/xgbe/xgbe-phy-v2.c        | 14 +---
 drivers/net/ethernet/apple/bmac.c                  |  2 +-
 drivers/net/ethernet/apple/mace.c                  |  2 +-
 drivers/net/ethernet/dnet.c                        |  4 +-
 drivers/net/ethernet/intel/igb/igb_main.c          | 10 ++-
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |  1 +
 drivers/net/ethernet/neterion/s2io.c               |  2 +-
 .../ethernet/netronome/nfp/nfpcore/nfp_cppcore.c   |  3 +-
 .../net/ethernet/qlogic/qlcnic/qlcnic_83xx_init.c  |  8 ++-
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_dcb.h    | 10 +--
 drivers/net/ethernet/qlogic/qlcnic/qlcnic_main.c   |  8 ++-
 .../ethernet/qlogic/qlcnic/qlcnic_sriov_common.c   |  2 +
 drivers/net/ethernet/rdc/r6040.c                   |  5 +-
 drivers/net/ethernet/renesas/ravb_main.c           |  2 +-
 .../net/ethernet/stmicro/stmmac/stmmac_hwtstamp.c  |  3 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_ptp.h   |  2 +-
 drivers/net/ethernet/ti/netcp_core.c               |  2 +-
 drivers/net/ethernet/xilinx/xilinx_emaclite.c      |  2 +-
 drivers/net/fddi/defxx.c                           | 22 ++++--
 drivers/net/hamradio/baycom_epp.c                  |  2 +-
 drivers/net/hamradio/scc.c                         |  6 +-
 drivers/net/loopback.c                             |  2 +-
 drivers/net/ntb_netdev.c                           |  4 +-
 drivers/net/phy/xilinx_gmii2rgmii.c                |  1 +
 drivers/net/ppp/ppp_generic.c                      |  2 +
 drivers/net/usb/rndis_host.c                       |  3 +-
 drivers/net/wan/farsync.c                          |  2 +
 drivers/net/wireless/ath/ar5523/ar5523.c           |  6 ++
 drivers/net/wireless/ath/ath10k/pci.c              | 20 +++---
 drivers/net/wireless/ath/ath9k/hif_usb.c           | 46 +++++++-----
 .../broadcom/brcm80211/brcmfmac/firmware.c         |  5 ++
 .../wireless/broadcom/brcm80211/brcmfmac/pcie.c    |  2 +-
 .../wireless/broadcom/brcm80211/brcmfmac/sdio.c    |  1 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h   |  2 +-
 drivers/nfc/pn533/pn533.c                          |  4 ++
 drivers/nfc/pn533/usb.c                            | 44 +++++++++++-
 drivers/parisc/led.c                               |  3 +
 drivers/pci/irq.c                                  |  2 +
 drivers/pci/pci-sysfs.c                            | 13 ++--
 drivers/pci/pci.c                                  |  2 +
 drivers/pinctrl/pinconf-generic.c                  |  4 +-
 drivers/platform/x86/mxm-wmi.c                     |  8 +--
 drivers/platform/x86/sony-laptop.c                 | 21 ++++--
 drivers/pnp/core.c                                 |  4 +-
 drivers/power/avs/smartreflex.c                    |  1 +
 drivers/power/supply/power_supply_core.c           |  2 +-
 drivers/rapidio/devices/rio_mport_cdev.c           | 15 ++--
 drivers/rapidio/rio-scan.c                         |  8 ++-
 drivers/rapidio/rio.c                              |  9 ++-
 drivers/regulator/core.c                           |  2 +
 drivers/regulator/da9211-regulator.c               | 11 +--
 drivers/rtc/rtc-snvs.c                             | 16 ++++-
 drivers/rtc/rtc-st-lpc.c                           |  1 +
 drivers/s390/net/ctcm_main.c                       | 11 +--
 drivers/s390/net/lcs.c                             |  8 +--
 drivers/s390/net/netiucv.c                         |  9 +--
 drivers/scsi/fcoe/fcoe.c                           |  1 +
 drivers/scsi/fcoe/fcoe_sysfs.c                     | 19 ++---
 drivers/scsi/hpsa.c                                |  7 +-
 drivers/scsi/ipr.c                                 | 10 ++-
 drivers/scsi/snic/snic_disc.c                      |  3 +
 drivers/soc/ti/knav_qmss_queue.c                   |  2 +-
 drivers/soc/ux500/ux500-soc-id.c                   | 10 ++-
 drivers/staging/rtl8192e/rtllib_rx.c               |  2 +-
 drivers/staging/rtl8192u/ieee80211/ieee80211_rx.c  |  4 +-
 drivers/tty/hvc/hvc_xen.c                          | 46 +++++++-----
 drivers/tty/serial/amba-pl011.c                    |  3 +
 drivers/tty/serial/pch_uart.c                      |  4 ++
 drivers/tty/serial/sunsab.c                        |  8 ++-
 drivers/uio/uio_dmem_genirq.c                      | 13 ++--
 drivers/usb/common/ulpi.c                          |  2 +-
 drivers/usb/dwc3/core.c                            |  7 +-
 drivers/usb/gadget/function/f_uvc.c                |  5 +-
 drivers/usb/gadget/udc/fotg210-udc.c               | 12 ++--
 drivers/usb/musb/musb_gadget.c                     |  2 -
 drivers/usb/serial/cp210x.c                        |  2 +
 drivers/usb/serial/option.c                        |  3 +
 drivers/usb/storage/alauda.c                       |  2 +
 drivers/vfio/platform/vfio_platform_common.c       |  3 +-
 drivers/video/fbdev/Kconfig                        |  1 -
 drivers/video/fbdev/pm2fb.c                        |  9 ++-
 drivers/video/fbdev/uvesafb.c                      |  1 +
 drivers/video/fbdev/vermilion/vermilion.c          |  4 +-
 drivers/video/fbdev/via/via-core.c                 |  9 ++-
 drivers/vme/bridges/vme_fake.c                     |  2 +
 drivers/vme/bridges/vme_tsi148.c                   |  1 +
 fs/binfmt_misc.c                                   |  8 +--
 fs/char_dev.c                                      |  2 +-
 fs/cifs/connect.c                                  |  4 +-
 fs/ext4/ext4.h                                     |  2 +-
 fs/ext4/indirect.c                                 |  9 ++-
 fs/ext4/inode.c                                    | 18 ++++-
 fs/ext4/ioctl.c                                    | 10 +--
 fs/ext4/namei.c                                    |  3 +
 fs/ext4/xattr.c                                    | 15 ++--
 fs/hfs/inode.c                                     | 13 ++--
 fs/hfs/trans.c                                     |  2 +-
 fs/hfsplus/hfsplus_fs.h                            |  2 +
 fs/hfsplus/inode.c                                 | 16 ++---
 fs/hfsplus/options.c                               |  4 ++
 fs/jfs/jfs_dmap.c                                  | 27 +++++--
 fs/libfs.c                                         | 22 +++++-
 fs/nfs/nfs4proc.c                                  | 19 +++--
 fs/nfs/nfs4state.c                                 |  2 +
 fs/nfs/nfs4xdr.c                                   | 10 ++-
 fs/nfsd/nfs4callback.c                             |  4 +-
 fs/nfsd/nfs4xdr.c                                  | 11 +++
 fs/nilfs2/the_nilfs.c                              | 31 ++++++--
 fs/ocfs2/stackglue.c                               |  8 ++-
 fs/orangefs/orangefs-debugfs.c                     |  3 +
 fs/orangefs/orangefs-mod.c                         |  8 +--
 fs/pnode.c                                         |  2 +-
 fs/pstore/Kconfig                                  |  1 +
 fs/pstore/pmsg.c                                   |  7 +-
 fs/pstore/ram.c                                    |  2 +
 fs/pstore/ram_core.c                               |  6 +-
 fs/reiserfs/namei.c                                |  4 ++
 fs/reiserfs/xattr_security.c                       |  2 +-
 fs/sysv/itree.c                                    |  2 +-
 fs/udf/balloc.c                                    |  5 +-
 fs/udf/inode.c                                     | 84 ++++++++++------------
 fs/udf/namei.c                                     |  8 +--
 fs/udf/truncate.c                                  | 48 ++++---------
 fs/udf/udfdecl.h                                   |  3 +-
 fs/xattr.c                                         |  2 +-
 include/asm-generic/tlb.h                          |  6 ++
 include/linux/can/platform/sja1000.h               |  2 +-
 include/linux/eventfd.h                            |  2 +-
 include/linux/fs.h                                 | 12 +++-
 include/linux/once.h                               | 28 ++++++++
 include/linux/sunrpc/rpc_pipe_fs.h                 |  5 ++
 include/linux/timerqueue.h                         |  2 +-
 include/net/mrp.h                                  |  1 +
 include/uapi/linux/swab.h                          |  2 +-
 include/uapi/sound/asequencer.h                    |  8 +--
 kernel/acct.c                                      |  2 +
 kernel/events/core.c                               |  8 ++-
 kernel/gcov/gcc_4_7.c                              |  5 ++
 kernel/power/snapshot.c                            |  4 +-
 kernel/trace/blktrace.c                            |  3 +-
 kernel/trace/trace.c                               | 15 +++-
 lib/notifier-error-inject.c                        |  2 +-
 lib/once.c                                         | 30 ++++++++
 lib/test_firmware.c                                |  1 +
 mm/khugepaged.c                                    | 24 ++++++-
 mm/memory.c                                        |  5 ++
 net/802/mrp.c                                      | 18 +++--
 net/bluetooth/hci_core.c                           |  2 +-
 net/bluetooth/l2cap_core.c                         |  3 +-
 net/bluetooth/rfcomm/core.c                        |  2 +-
 net/caif/cfctrl.c                                  |  6 +-
 net/core/filter.c                                  | 11 ++-
 net/core/skbuff.c                                  |  3 +
 net/core/stream.c                                  |  6 ++
 net/ipv4/inet_connection_sock.c                    | 16 ++++-
 net/ipv4/inet_hashtables.c                         |  4 +-
 net/ipv4/udp_tunnel.c                              |  1 +
 net/ipv6/raw.c                                     |  4 ++
 net/mac80211/iface.c                               |  1 +
 net/netfilter/ipset/ip_set_bitmap_ip.c             |  4 +-
 net/nfc/netlink.c                                  | 52 ++++++++++----
 net/openvswitch/datapath.c                         | 25 ++++---
 net/sched/ematch.c                                 |  2 +
 net/sched/sch_api.c                                | 10 ++-
 net/sched/sch_atm.c                                |  5 +-
 net/sunrpc/auth_gss/auth_gss.c                     | 19 ++++-
 net/sunrpc/clnt.c                                  |  2 +-
 net/vmw_vsock/vmci_transport.c                     |  6 +-
 security/apparmor/apparmorfs.c                     |  4 +-
 security/device_cgroup.c                           | 33 +++++++--
 security/integrity/ima/ima_template.c              |  9 ++-
 sound/core/control_compat.c                        |  4 ++
 sound/drivers/mts64.c                              |  3 +
 sound/pci/asihpi/hpioctl.c                         |  2 +-
 sound/soc/codecs/pcm512x.c                         |  8 +--
 sound/soc/codecs/rt298.c                           |  7 ++
 sound/soc/codecs/rt5670.c                          |  2 -
 sound/soc/codecs/wm8994.c                          |  5 ++
 sound/soc/mediatek/mt8173/mt8173-rt5650-rt5514.c   |  7 +-
 sound/soc/pxa/mmp-pcm.c                            |  2 +-
 sound/soc/rockchip/rockchip_pdm.c                  |  1 +
 sound/soc/rockchip/rockchip_spdif.c                |  1 +
 sound/soc/soc-ops.c                                |  9 ++-
 sound/usb/line6/driver.c                           |  3 +-
 sound/usb/line6/midi.c                             |  6 +-
 sound/usb/line6/midibuf.c                          | 25 ++++---
 sound/usb/line6/midibuf.h                          |  5 +-
 sound/usb/line6/pod.c                              |  3 +-
 tools/arch/parisc/include/uapi/asm/mman.h          | 12 ++--
 tools/lib/traceevent/Makefile                      |  2 +-
 tools/perf/bench/bench.h                           | 12 ----
 tools/perf/tests/attr.py                           |  1 -
 tools/perf/util/auxtrace.c                         |  2 +-
 tools/testing/ktest/ktest.pl                       |  3 +-
 tools/testing/selftests/lib.mk                     |  5 ++
 .../selftests/powerpc/dscr/dscr_sysfs_test.c       |  5 +-
 347 files changed, 1914 insertions(+), 796 deletions(-)


