Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E32A4635769
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:43:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237968AbiKWJmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238061AbiKWJls (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:41:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 635F1112C5A;
        Wed, 23 Nov 2022 01:39:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8635B81E54;
        Wed, 23 Nov 2022 09:39:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AE7EC433C1;
        Wed, 23 Nov 2022 09:39:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196365;
        bh=D38d03MibhQB2prEHblvV8NABFospTMFB1CosEV2uL8=;
        h=From:To:Cc:Subject:Date:From;
        b=u4KIdW50eO3mXtJw9Kv3dCO7w74PbmeGvrGZt1CArdmiTvN1g10sxM5jSSbG/Vfwf
         x0vg0HKKcZqiQC6zqThcQkTLHif9VpvVjMFRDn2ZHJRTwmlkaUfjHxKpJCD9pvxX9f
         AUEXv829YNnm2tu1KllowgTXb7CEk2u0sn/Q76qM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: [PATCH 6.0 000/314] 6.0.10-rc1 review
Date:   Wed, 23 Nov 2022 09:47:25 +0100
Message-Id: <20221123084625.457073469@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.10-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-6.0.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 6.0.10-rc1
X-KernelTest-Deadline: 2022-11-25T08:46+00:00
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

This is the start of the stable review cycle for the 6.0.10 release.
There are 314 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.10-rc1.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 6.0.10-rc1

Hawkins Jiawei <yin31149@gmail.com>
    ntfs: check overflow when iterating ATTR_RECORDs

Hawkins Jiawei <yin31149@gmail.com>
    ntfs: fix out-of-bounds read in ntfs_attr_find()

Hawkins Jiawei <yin31149@gmail.com>
    ntfs: fix use-after-free in ntfs_attr_find()

Jiri Olsa <jolsa@kernel.org>
    bpf: Prevent bpf program recursion for raw tracepoint probes

Dominique Martinet <asmadeus@codewreck.org>
    net/9p: use a dedicated spinlock for trans_fd

Alexander Potapenko <glider@google.com>
    mm: fs: initialize fsdata passed to write_begin/write_end interface

Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    rseq: Use pr_warn_once() when deprecated/unknown ABI flags are encountered

Hawkins Jiawei <yin31149@gmail.com>
    wifi: wext: use flex array destination for memcpy()

Kees Cook <keescook@chromium.org>
    netlink: Bounds-check struct nlmsgerr creation

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    9p/trans_fd: always use O_NONBLOCK read/write

Andreas Gruenbacher <agruenba@redhat.com>
    gfs2: Switch from strlcpy to strscpy

Andrew Price <anprice@redhat.com>
    gfs2: Check sb_bsize_shift after reading superblock

Dominique Martinet <asmadeus@codewreck.org>
    9p: trans_fd/p9_conn_cancel: drop client lock earlier

Eiichi Tsukata <eiichi.tsukata@nutanix.com>
    KVM: x86/xen: Fix eventfd error handling in kvm_xen_eventfd_assign()

Eric Dumazet <edumazet@google.com>
    kcm: avoid potential race in kcm_tx_work

Eric Dumazet <edumazet@google.com>
    tcp: cdg: allow tcp_cdg_release() to be called multiple times

Eric Dumazet <edumazet@google.com>
    macvlan: enforce a consistent minimal mtu

Chen Jun <chenjun102@huawei.com>
    Input: i8042 - fix leaking of platform device on module removal

Liu Shixin <liushixin2@huawei.com>
    arm64/mm: fix incorrect file_map_count for non-leaf pmd/pud

Zheng Yejian <zhengyejian1@huawei.com>
    tracing: Fix potential null-pointer-access of entry in list 'tr->err_log'

Li Huafei <lihuafei1@huawei.com>
    kprobes: Skip clearing aggrprobe's post_handler in kprobe-on-ftrace case

Yuan Can <yuancan@huawei.com>
    scsi: scsi_debug: Fix possible UAF in sdebug_add_host_helper()

Yang Yingliang <yangyingliang@huawei.com>
    scsi: target: tcm_loop: Fix possible name leak in tcm_loop_setup_hba_bus()

Hangbin Liu <liuhangbin@gmail.com>
    net: use struct_group to copy ip/ipv6 header addresses

Alexandru Tachici <alexandru.tachici@analog.com>
    net: usb: smsc95xx: fix external PHY reset

Aashish Sharma <shraash@google.com>
    tracing: Fix warning on variable 'struct trace_array'

Steven Rostedt (Google) <rostedt@goodmis.org>
    ring-buffer: Include dropped pages in counting dirty patches

Ravi Bangoria <ravi.bangoria@amd.com>
    perf/x86/amd: Fix crash due to race between amd_pmu_enable_all, perf NMI and throttling

Jason Gunthorpe <jgg@ziepe.ca>
    vfio: Split the register_device ops call into functions

Jason Gunthorpe <jgg@ziepe.ca>
    vfio: Rename vfio_ioctl_check_extension()

Marco Elver <elver@google.com>
    perf: Improve missing SIGTRAP checking

Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
    ASoC: SOF: topology: No need to assign core ID if token parsing failed

Keith Busch <kbusch@kernel.org>
    nvme: ensure subsystem reset is single threaded

Keith Busch <kbusch@kernel.org>
    nvme: restrict management ioctls to admin

Adrian Hunter <adrian.hunter@intel.com>
    perf/x86/intel/pt: Fix sampling using single range output

Sandipan Das <sandipan.das@amd.com>
    perf/x86/amd/uncore: Fix memory leak for events array

Mel Gorman <mgorman@techsingularity.net>
    x86/fpu: Drop fpregs lock before inheriting FPU permissions

Borys Popławski <borysp@invisiblethingslab.com>
    x86/sgx: Add overflow check in sgx_validate_offset_length()

Chris Mason <clm@fb.com>
    blk-cgroup: properly pin the parent in blkcg_css_online

Alexander Potapenko <glider@google.com>
    misc/vmw_vmci: fix an infoleak in vmci_host_do_receive_datagram()

Gerald Schaefer <gerald.schaefer@linux.ibm.com>
    s390/dcssblk: fix deadlock when adding a DCSS

Akira Yokosawa <akiyks@gmail.com>
    docs/driver-api/miscellaneous: Remove kernel-doc of serial_core.c

Shuah Khan <skhan@linuxfoundation.org>
    docs: update mediator contact information in CoC doc

Xiongfeng Wang <wangxiongfeng2@huawei.com>
    mmc: sdhci-pci: Fix possible memory leak caused by missing pci_dev_put()

Chevron Li <chevron.li@bayhubtech.com>
    mmc: sdhci-pci-o2micro: fix card detect fail issue caused by CD# debounce timeout

Yann Gautier <yann.gautier@foss.st.com>
    mmc: core: properly select voltage range without power cycle

Brian Norris <briannorris@chromium.org>
    firmware: coreboot: Register bus in module init

Tina Zhang <tina.zhang@intel.com>
    iommu/vt-d: Set SRE bit only when hardware has SRS cap

Tina Zhang <tina.zhang@intel.com>
    iommu/vt-d: Preset Access bit for IOVA in FL non-leaf paging entries

Benjamin Block <bblock@linux.ibm.com>
    scsi: zfcp: Fix double free of FSF request when qdio send fails

Aminuddin Jamaluddin <aminuddin.jamaluddin@intel.com>
    net: phy: marvell: add sleep time after enabling the loopback bit

Alban Crequy <albancrequy@linux.microsoft.com>
    maccess: Fix writing offset in case of fault in strncpy_from_kernel_nofault()

Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
    Input: iforce - invert valid length check when fetching device IDs

Xiubo Li <xiubli@redhat.com>
    ceph: avoid putting the realm twice when decoding snaps fails

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: disallow self-propelled ring polling

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix multishot recv request leaks

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix multishot accept request leaks

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: fix tw losing poll events

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_lpss: Use 16B DMA burst with Elkhart Lake

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250_lpss: Configure DMA also w/o DMA filter

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Flush DMA Rx on RLSI

Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
    serial: 8250: Fall back to non-DMA Rx if IIR_RDI occurs

Mikulas Patocka <mpatocka@redhat.com>
    dm ioctl: fix misbehavior if list_versions races with module loading

Zhihao Cheng <chengzhihao1@huawei.com>
    dm bufio: Fix missing decrement of no_sleep_enabled if dm_bufio_client_create failed

Mitja Spes <mitja@lxnav.com>
    iio: pressure: ms5611: changed hardcoded SPI speed to value limited

Mitja Spes <mitja@lxnav.com>
    iio: pressure: ms5611: fixed value compensation bug

Saravanan Sekar <sravanhome@gmail.com>
    iio: adc: mp2629: fix potential array out of bound access

Saravanan Sekar <sravanhome@gmail.com>
    iio: adc: mp2629: fix wrong comparison of channel

Yang Yingliang <yangyingliang@huawei.com>
    iio: trigger: sysfs: fix possible memory leak in iio_sysfs_trig_init()

Yang Yingliang <yangyingliang@huawei.com>
    iio: adc: at91_adc: fix possible memory leak in at91_adc_allocate_trigger()

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    iio: accel: bma400: Ensure VDDIO is enable defore reading the chip ID.

Sven Peter <sven@svenpeter.dev>
    usb: typec: tipd: Prevent uninitialized event{1,2} in IRQ handler

Rajat Khandelwal <rajat.khandelwal@linux.intel.com>
    usb: typec: mux: Enter safe mode only when pins need to be reconfigured

Li Jun <jun.li@nxp.com>
    usb: cdns3: host: fix endless superspeed hub port reset

Duoming Zhou <duoming@zju.edu.cn>
    usb: chipidea: fix deadlock in ci_otg_del_timer

Nicolas Dumazet <ndumazet@google.com>
    usb: add NO_LPM quirk for Realforce 87U Keyboard

Reinhard Speyerer <rspmn@arcor.de>
    USB: serial: option: add Fibocom FM160 0x0111 composition

Davide Tronchin <davide.tronchin.94@gmail.com>
    USB: serial: option: add u-blox LARA-L6 modem

Davide Tronchin <davide.tronchin.94@gmail.com>
    USB: serial: option: add u-blox LARA-R6 00B modem

Davide Tronchin <davide.tronchin.94@gmail.com>
    USB: serial: option: remove old LARA-R6 PID

Benoît Monin <benoit.monin@gmx.fr>
    USB: serial: option: add Sierra Wireless EM9191

Linus Walleij <linus.walleij@linaro.org>
    USB: bcma: Make GPIO explicitly optional

Đoàn Trần Công Danh <congdanhqx@gmail.com>
    speakup: replace utils' u_char with unsigned char

Mushahid Hussain <mushi.shar@gmail.com>
    speakup: fix a segfault caused by switching consoles

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    slimbus: stream: correct presence rate frequencies

Zheng Bin <zhengbin13@huawei.com>
    slimbus: qcom-ngd: Fix build error when CONFIG_SLIM_QCOM_NGD_CTRL=y && CONFIG_QCOM_RPROC_COMMON=m

Tiago Dias Ferreira <tiagodfer@gmail.com>
    nvme-pci: add NVME_QUIRK_BOGUS_NID for Netac NV7000

Bean Huo <beanhuo@micron.com>
    nvme-pci: add NVME_QUIRK_BOGUS_NID for Micron Nitro

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: update res mask in io_poll_check_events

Janne Grunau <j@jannau.net>
    usb: dwc3: Do not get extcon device when usb-role-switch is used

Johan Hovold <johan+linaro@kernel.org>
    Revert "usb: dwc3: disable USB core PHY management"

Takashi Iwai <tiwai@suse.de>
    ALSA: hda/realtek: Fix the speaker output on Samsung Galaxy Book Pro 360

Emil Flink <emil.flink@gmail.com>
    ALSA: hda/realtek: fix speakers for Samsung Galaxy Book Pro

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Drop snd_BUG_ON() from snd_usbmidi_output_open()

Dillon Varone <Dillon.Varone@amd.com>
    drm/amd/display: Fix prefetch calculations for dcn32

Melissa Wen <mwen@igalia.com>
    drm/amd/display: don't enable DRM CRTC degamma property for DCE

Roman Li <roman.li@amd.com>
    drm/amd/display: Fix optc2_configure warning on dcn314

George Shen <george.shen@amd.com>
    drm/amd/display: Support parsing VRAM info v3.0 from VBIOS

Stylon Wang <stylon.wang@amd.com>
    drm/amd/display: Fix access timeout to DPIA AUX at boot time

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Add HUBP surface flip interrupt handler

Stylon Wang <stylon.wang@amd.com>
    drm/amd/display: Fix invalid DPIA AUX reply causing system hang

Simon Rettberg <simon.rettberg@rz.uni-freiburg.de>
    drm/display: Don't assume dual mode adaptors support i2c sub-addressing

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: fix SMU13 runpm hang due to unintentional workaround

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: enable runpm support over BACO for SMU13.0.0

Evan Quan <evan.quan@amd.com>
    drm/amd/pm: enable runpm support over BACO for SMU13.0.7

Shyam Sundar S K <Shyam-sundar.S-k@amd.com>
    platform/x86/amd: pmc: Add new ACPI ID AMDI0009

Mario Limonciello <mario.limonciello@amd.com>
    platform/x86/amd: pmc: Remove more CONFIG_DEBUG_FS checks

Yi Yang <yiyang13@huawei.com>
    rethook: fix a potential memleak in rethook_alloc()

Shang XiaoJing <shangxiaojing@huawei.com>
    tracing: kprobe: Fix potential null-ptr-deref on trace_array in kprobe_event_gen_test_exit()

Shang XiaoJing <shangxiaojing@huawei.com>
    tracing: kprobe: Fix potential null-ptr-deref on trace_event_file in kprobe_event_gen_test_exit()

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Fix race where eprobes can be called before the event

Shang XiaoJing <shangxiaojing@huawei.com>
    tracing: Fix wild-memory-access in register_synth_event()

Shang XiaoJing <shangxiaojing@huawei.com>
    tracing: Fix memory leak in test_gen_synth_cmd() and test_empty_synth_event()

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing/ring-buffer: Have polling block on watermark

Wang Yufen <wangyufen@huawei.com>
    tracing: Fix memory leak in tracing_read_pipe()

Daniil Tatianin <d-tatianin@yandex-team.ru>
    ring_buffer: Do not deactivate non-existant pages

Xiu Jianfeng <xiujianfeng@huawei.com>
    ftrace: Fix null pointer dereference in ftrace_add_mod()

Wang Wensheng <wangwensheng4@huawei.com>
    ftrace: Optimize the allocation for mcount entries

Wang Wensheng <wangwensheng4@huawei.com>
    ftrace: Fix the possible incorrect kernel message

Keith Busch <kbusch@kernel.org>
    dm-crypt: provide dma_alignment limit in io_hints

Keith Busch <kbusch@kernel.org>
    block: make dma_alignment a stacking queue_limit

Wang Yufen <wangyufen@huawei.com>
    netdevsim: Fix memory leak of nsim_dev->fa_cookie

Anastasia Belova <abelova@astralinux.ru>
    cifs: add check for returning value of SMB2_set_info_init

Vasily Gorbik <gor@linux.ibm.com>
    s390: avoid using global register for current_stack_pointer

Yuan Can <yuancan@huawei.com>
    net: thunderbolt: Fix error handling in tbnet_init()

Shang XiaoJing <shangxiaojing@huawei.com>
    net: microchip: sparx5: Fix potential null-ptr-deref in sparx_stats_init() and sparx5_start()

Shang XiaoJing <shangxiaojing@huawei.com>
    net: lan966x: Fix potential null-ptr-deref in lan966x_stats_init()

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix wrong return value checking when GETFLAGS

Sagi Grimberg <sagi@grimberg.me>
    nvmet: fix a memory leak in nvmet_auth_set_key

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: don't leak tagger-owned storage on switch driver unbind

Wei Yongjun <weiyongjun1@huawei.com>
    net/x25: Fix skb leak in x25_lapb_receive_frame()

Liu Jian <liujian56@huawei.com>
    net: ag71xx: call phylink_disconnect_phy if ag71xx_hw_enable() fail in ag71xx_open()

Anastasia Belova <abelova@astralinux.ru>
    cifs: add check for returning value of SMB2_close_init

David Howells <dhowells@redhat.com>
    netfs: Fix dodgy maths

David Howells <dhowells@redhat.com>
    netfs: Fix missing xas_retry() calls in xarray iteration

Maximilian Luz <luzmaximilian@gmail.com>
    platform/surface: aggregator: Do not check for repeated unsequenced packets

Roger Pau Monné <roger.pau@citrix.com>
    platform/x86/intel: pmc: Don't unconditionally attach Intel PMC when virtualized

Dan Carpenter <error27@gmail.com>
    drbd: use after free in drbd_create_device()

Ido Schimmel <idosch@nvidia.com>
    bridge: switchdev: Fix memory leaks when changing VLAN protocol

Guangbin Huang <huangguangbin2@huawei.com>
    net: hns3: fix setting incorrect phy link ksettings for firmware in resetting process

Jie Wang <wangjie125@huawei.com>
    net: hns3: fix return value check bug of rx copybreak

Jian Shen <shenjian15@huawei.com>
    net: hns3: fix incorrect hw rss hash type of rx packet

Yuan Can <yuancan@huawei.com>
    net: ena: Fix error handling in ena_init()

Cong Wang <cong.wang@bytedance.com>
    kcm: close race conditions on sk_receive_queue

Yuan Can <yuancan@huawei.com>
    net: ionic: Fix error handling in ionic_init_module()

Amit Cohen <amcohen@nvidia.com>
    mlxsw: Avoid warnings when not offloaded FDB entry with IPv6 is removed

Jingbo Xu <jefflexu@linux.alibaba.com>
    erofs: fix missing xas_retry() in fscache mode

Yang Yingliang <yangyingliang@huawei.com>
    xen/pcpu: fix possible memory leak in register_pcpu()

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: dsa: make dsa_master_ioctl() see through port_hwtstamp_get() shims

Wei Yongjun <weiyongjun1@huawei.com>
    net: mhi: Fix memory leak in mhi_net_dellink()

Erico Nunes <nunes.erico@gmail.com>
    drm/lima: Fix opp clkname setting in case of missing regulator

Ziyang Xuan <william.xuanziyang@huawei.com>
    octeon_ep: ensure get mac address successfully before eth_hw_addr_set()

Ziyang Xuan <william.xuanziyang@huawei.com>
    octeon_ep: fix potential memory leak in octep_device_setup()

Ziyang Xuan <william.xuanziyang@huawei.com>
    octeon_ep: ensure octep_get_link_status() successfully before octep_link_up()

Ziyang Xuan <william.xuanziyang@huawei.com>
    octeon_ep: delete unnecessary napi rollback under set_queues_err in octep_open()

Gaosheng Cui <cuigaosheng1@huawei.com>
    bnxt_en: Remove debugfs when pci_register_driver failed

Zhengchao Shao <shaozhengchao@huawei.com>
    net: caif: fix double disconnect client in chnl_net_open()

Chuang Wang <nashuiliang@gmail.com>
    net: macvlan: Use built-in RCU list checking

Wang ShaoBo <bobo.shaobowang@huawei.com>
    mISDN: fix misuse of put_device() in mISDN_register_device()

Zhengchao Shao <shaozhengchao@huawei.com>
    net: liquidio: release resources when liquidio driver open failed

Xiaolei Wang <xiaolei.wang@windriver.com>
    soc: imx8m: Enable OCOTP clock before reading the register

Jeremy Kerr <jk@codeconstruct.com.au>
    mctp i2c: don't count unused / invalid keys for flow release

Mohd Faizal Abdul Rahim <faizal.abdul.rahim@intel.com>
    net: stmmac: ensure tx function is not running in stmmac_xdp_release()

Michael Sit Wei Hong <michael.wei.hong.sit@intel.com>
    net: phy: dp83867: Fix SGMII FIFO depth for non OF devices

Yuan Can <yuancan@huawei.com>
    net: hinic: Fix error handling in hinic_module_init()

Yang Yingliang <yangyingliang@huawei.com>
    mISDN: fix possible memory leak in mISDN_dsp_element_register()

Wei Yongjun <weiyongjun1@huawei.com>
    net: bgmac: Drop free_netdev() from bgmac_enet_remove()

Niklas Cassel <niklas.cassel@wdc.com>
    ata: libata-core: do not issue non-internal commands once EH is pending

Xu Kuohai <xukuohai@huawei.com>
    bpf: Initialize same number of free nodes for each pcpu_freelist

Zhang Xiaoxu <zhangxiaoxu5@huawei.com>
    cifs: Fix connections leak when tlink setup failed

Pavel Begunkov <asml.silence@gmail.com>
    io_uring/poll: fix double poll req->flags races

Liao Chang <liaochang1@huawei.com>
    MIPS: Loongson64: Add WARN_ON on kexec related kmalloc failed

Rongwei Zhang <pudh4418@gmail.com>
    MIPS: fix duplicate definitions for exported symbols

Jaco Coetzee <jaco.coetzee@corigine.com>
    nfp: change eeprom length to max length enumerators

Yang Yingliang <yangyingliang@huawei.com>
    ata: libata-transport: fix error handling in ata_tdev_add()

Yang Yingliang <yangyingliang@huawei.com>
    ata: libata-transport: fix error handling in ata_tlink_add()

Yang Yingliang <yangyingliang@huawei.com>
    ata: libata-transport: fix error handling in ata_tport_add()

Yang Yingliang <yangyingliang@huawei.com>
    ata: libata-transport: fix double ata_host_put() in ata_tport_add()

Peng Fan <peng.fan@nxp.com>
    arm64: dts: imx93-pinfunc: drop execution permission

Marek Vasut <marex@denx.de>
    arm64: dts: imx8mn: Fix NAND controller size-cells

Jingbo Xu <jefflexu@linux.alibaba.com>
    erofs: put metabuf in error path in fscache mode

Marek Vasut <marex@denx.de>
    arm64: dts: imx8mm: Fix NAND controller size-cells

Marek Vasut <marex@denx.de>
    ARM: dts: imx7: Fix NAND controller size-cells

Alexander Stein <alexander.stein@ew.tq-group.com>
    arm64: dts: imx8mm-tqma8mqml-mba8mx: Fix USB DR

Shang XiaoJing <shangxiaojing@huawei.com>
    drm: Fix potential null-ptr-deref in drm_vblank_destroy_worker()

Shang XiaoJing <shangxiaojing@huawei.com>
    drm/drv: Fix potential memory leak in drm_dev_init()

Aishwarya Kothari <aishwarya.kothari@toradex.com>
    drm/panel: simple: set bpc field for logic technologies displays

Gaosheng Cui <cuigaosheng1@huawei.com>
    drm/vc4: kms: Fix IS_ERR() vs NULL check for vc4_kms

Zeng Heng <zengheng4@huawei.com>
    pinctrl: devicetree: fix null pointer dereferencing in pinctrl_dt_to_map

Yang Jihong <yangjihong1@huawei.com>
    selftests/bpf: Fix test_progs compilation failure in 32-bit arch

Pu Lehui <pulehui@huawei.com>
    selftests/bpf: Fix casting error when cross-compiling test_verifier for 32-bit platforms

Maciej W. Rozycki <macro@orcam.me.uk>
    parport_pc: Avoid FIFO port location truncation

Yang Yingliang <yangyingliang@huawei.com>
    siox: fix possible memory leak in siox_device_add()

Sagi Grimberg <sagi@grimberg.me>
    nvmet: fix a memory leak

D Scott Phillips <scott@os.amperecomputing.com>
    arm64: Fix bit-shifting UB in the MIDR_CPU_MODEL() macro

AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
    pinctrl: mediatek: common-v2: Fix bias-disable for PULL_PU_PD_RSEL_TYPE

Dylan Yudaken <dylany@meta.com>
    io_uring: calculate CQEs from the user visible value

Wang Yufen <wangyufen@huawei.com>
    bpf: Fix memory leaks in __check_func_call

Jeff Layton <jlayton@kernel.org>
    nfsd: put the export reference in nfsd4_verify_deleg_dentry

Serge Semin <Sergey.Semin@baikalelectronics.ru>
    block: sed-opal: kmalloc the cmd/resp buffers

Jingbo Xu <jefflexu@linux.alibaba.com>
    erofs: get correct count for unmapped range in fscache mode

Jingbo Xu <jefflexu@linux.alibaba.com>
    erofs: clean up .read_folio() and .readahead() in fscache mode

Xin Long <lucien.xin@gmail.com>
    sctp: clear out_curr if all frag chunks of current msg are pruned

Xin Long <lucien.xin@gmail.com>
    sctp: remove the unnecessary sinfo_stream check in sctp_prsctp_prune_unsent

Yang Yingliang <yangyingliang@huawei.com>
    scsi: scsi_transport_sas: Fix error handling in sas_phy_add()

Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
    mtd: onenand: omap2: add dependency on GPMC

Quentin Schulz <quentin.schulz@theobroma-systems.com>
    pinctrl: rockchip: list all pins in a possible mux route for PX30

Chen Zhongjin <chenzhongjin@huawei.com>
    ASoC: soc-utils: Remove __exit for snd_soc_util_exit()

Vikas Gupta <vikas.gupta@broadcom.com>
    bnxt_en: fix the handling of PCIE-AER

Vikas Gupta <vikas.gupta@broadcom.com>
    bnxt_en: refactor bnxt_cancel_reservations()

Baisong Zhong <zhongbaisong@huawei.com>
    bpf, test_run: Fix alignment problem in bpf_prog_test_run_skb()

Jason Montleon <jmontleo@redhat.com>
    ASoC: rt5677: fix legacy dai naming

Jason Montleon <jmontleo@redhat.com>
    ASoC: rt5514: fix legacy dai naming

Duoming Zhou <duoming@zju.edu.cn>
    tty: n_gsm: fix sleep-in-atomic-context bug in gsm_control_send

Shawn Guo <shawn.guo@linaro.org>
    serial: imx: Add missing .thaw_noirq hook

Sherry Sun <sherry.sun@nxp.com>
    tty: serial: fsl_lpuart: don't break the on-going transfer when global reset

Tony Lindgren <tony@atomide.com>
    serial: 8250: omap: Flush PM QOS work on remove

Tony Lindgren <tony@atomide.com>
    serial: 8250: omap: Fix unpaired pm_runtime_put_sync() in omap8250_remove()

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    serial: 8250_omap: remove wait loop from Errata i202 workaround

Tony Lindgren <tony@atomide.com>
    serial: 8250: omap: Fix missing PM runtime calls for omap8250_set_mctrl()

Claudiu Beznea <claudiu.beznea@microchip.com>
    ARM: at91: pm: avoid soft resetting AC DLL

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2780: Fix set_tdm_slot in case of single slot

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2764: Fix set_tdm_slot in case of single slot

Martin Povišer <povik+lin@cutebit.org>
    ASoC: tas2770: Fix set_tdm_slot in case of single slot

Ulf Hansson <ulf.hansson@linaro.org>
    arm64: dts: qcom: sm8250: Disable the not yet supported cluster idle state

Maarten Zanders <maarten.zanders@mind.be>
    ASoC: fsl_asrc fsl_esai fsl_sai: allow CONFIG_PM=N

Chen Zhongjin <chenzhongjin@huawei.com>
    ASoC: core: Fix use-after-free in snd_soc_exit()

Mihai Sain <mihai.sain@microchip.com>
    ARM: dts: at91: sama7g5: fix signal name of pin PB2

Marek Vasut <marex@denx.de>
    spi: stm32: Print summary 'callbacks suppressed' message

Satya Priya <quic_c_skakit@quicinc.com>
    arm64: dts: qcom: sc7280: Add the reset reg for lpass audiocc on SC7280

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sc8280xp: fix UFS PHY serdes size

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sc8280xp: drop broken DP PHY nodes

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sc8280xp: fix USB PHY PCS registers

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sc8280xp: fix USB1 PHY RX1 registers

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sc8280xp: fix USB0 PHY PCS_MISC registers

Brian Masney <bmasney@redhat.com>
    arm64: dts: qcom: sc8280xp: correct ref clock for ufs_mem_phy

Johan Hovold <johan+linaro@kernel.org>
    arm64: dts: qcom: sc8280xp: fix ufs_card_phy ref clock

Douglas Anderson <dianders@chromium.org>
    arm64: dts: qcom: sm8350-hdk: Specify which LDO modes are allowed

Douglas Anderson <dianders@chromium.org>
    arm64: dts: qcom: sm8250-xperia-edo: Specify which LDO modes are allowed

Douglas Anderson <dianders@chromium.org>
    arm64: dts: qcom: sm8150-xperia-kumano: Specify which LDO modes are allowed

Douglas Anderson <dianders@chromium.org>
    arm64: dts: qcom: sc8280xp-crd: Specify which LDO modes are allowed

Douglas Anderson <dianders@chromium.org>
    arm64: dts: qcom: sa8295p-adp: Specify which LDO modes are allowed

Douglas Anderson <dianders@chromium.org>
    arm64: dts: qcom: sa8155p-adp: Specify which LDO modes are allowed

Robert Marko <robimarko@gmail.com>
    arm64: dts: qcom: ipq8074: correct APCS register space size

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SVM: move MSR_IA32_SPEC_CTRL save/restore to assembly

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SVM: restore host save area from assembly

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SVM: do not allocate struct svm_cpu_data dynamically

Paolo Bonzini <pbonzini@redhat.com>
    KVM: SVM: remove dead field from struct svm_cpu_data

James Houghton <jthoughton@google.com>
    hugetlbfs: don't delete error page from pagecache

Mike Kravetz <mike.kravetz@oracle.com>
    hugetlb: rename remove_huge_page to hugetlb_delete_from_page_cache

Ard Biesheuvel <ardb@kernel.org>
    arm64: fix rodata=full again

Mike Rapoport <rppt@kernel.org>
    arm64/mm: fold check for KFENCE into can_set_direct_map()

Colin Ian King <colin.i.king@gmail.com>
    ASoC: codecs: jz4725b: Fix spelling mistake "Sourc" -> "Source", "Routee" -> "Route"

Shyam Prasad N <sprasad@microsoft.com>
    cifs: always iterate smb sessions using primary channel

Dan Williams <dan.j.williams@intel.com>
    tools/testing/cxl: Fix some error exits

Tony Luck <tony.luck@intel.com>
    x86/cpu: Add several Intel server CPU model numbers

Yu Zhe <yuzhe@nfschina.com>
    cxl/pmem: Use size_add() against integer overflow

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: L2CAP: Fix l2cap_global_chan_by_psm

Nevenko Stupar <Nevenko.Stupar@amd.com>
    drm/amd/display: Investigate tool reported FCLK P-state deviations

George Shen <george.shen@amd.com>
    drm/amd/display: Round up DST_after_scaler to nearest int

George Shen <george.shen@amd.com>
    drm/amd/display: Use forced DSC bpp in DML

George Shen <george.shen@amd.com>
    drm/amd/display: Fix DCN32 DSC delay calculation

Mario Limonciello <mario.limonciello@amd.com>
    drm/amd: Fail the suspend if resources can't be evicted

Yifan Zhang <yifan1.zhang@amd.com>
    drm/amdgpu: set fb_modifiers_not_supported in vkms

Alvin Lee <Alvin.Lee2@amd.com>
    drm/amd/display: Enable timing sync on DCN32

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Ignore Cable ID Feature

Filipe Manana <fdmanana@suse.com>
    btrfs: remove pointless and double ulist frees in error paths of qgroup tests

Nathan Huckleberry <nhuck@google.com>
    drm/imx: imx-tve: Fix return type of imx_tve_connector_mode_valid

Nam Cao <namcaov@gmail.com>
    i2c: i801: add lis3lv02d's I2C address for Vostro 5568

Thierry Reding <treding@nvidia.com>
    i2c: tegra: Allocate DMA memory for DMA engine

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Make tx_prepare time out eventually

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Cleanup the core driver removal callback

Al Viro <viro@zeniv.linux.org.uk>
    block: blk_add_rq_to_plug(): clear stale 'last' after flush

Michael Ellerman <mpe@ellerman.id.au>
    powerpc/64e: Fix amdgpu build on Book3E w/o AltiVec

Li Zhijian <lizhijian@fujitsu.com>
    ksefltests: pidfd: Fix wait_states: Test terminated by timeout

Michael Tretter <m.tretter@pengutronix.de>
    drm/rockchip: vop2: disable planes when disabling the crtc

Michael Tretter <m.tretter@pengutronix.de>
    drm/rockchip: vop2: fix null pointer in plane_atomic_disable

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: x86: Add another system to quirk list for forcing StorageD3Enable

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix crasher in gss_unwrap_resp_integ()

Benjamin Coddington <bcodding@redhat.com>
    NFSv4: Retry LOCK on OLD_STATEID during delegation return

Qu Wenruo <wqu@suse.com>
    btrfs: raid56: properly handle the error when unable to find the missing stripe

Michael Margolin <mrgolin@amazon.com>
    RDMA/efa: Add EFA 0xefa2 PCI ID

Jonathan Cameron <Jonathan.Cameron@huawei.com>
    cxl/mbox: Add a check on input payload size

Hans de Goede <hdegoede@redhat.com>
    ACPI: scan: Add LATT2021 to acpi_ignore_dep_ids[]

Christian König <christian.koenig@amd.com>
    drm/scheduler: fix fence ref counting

Alvin Lee <Alvin.Lee2@amd.com>
    drm/amd/display: Don't return false if no stream

Rodrigo Siqueira <Rodrigo.Siqueira@amd.com>
    drm/amd/display: Remove wrong pipe control lock

Gayatri Kammela <gayatri.kammela@linux.intel.com>
    platform/x86/intel: pmc/core: Add Raptor Lake support to pmc core driver

Jelle van der Waa <jvanderwaa@redhat.com>
    platform/x86: thinkpad_acpi: Fix reporting a non present second fan on some models

Yiqing Yao <yiqing.yao@amd.com>
    drm/amdgpu: Adjust MES polling timeout for sriov

Leohearts <leohearts@leohearts.com>
    ASoC: amd: yc: Add Lenovo Thinkbook 14+ 2022 21D0 to quirks table

linkt <xazrael@hotmail.com>
    ASoC: amd: yc: Adding Lenovo ThinkBook 14 Gen 4+ ARA and Lenovo ThinkBook 16 Gen 4+ ARA to the Quirks List

Shuming Fan <shumingf@realtek.com>
    ASoC: rt1308-sdw: add the default value of some registers

Alexandre Belloni <alexandre.belloni@bootlin.com>
    rtc: cmos: fix build on non-ACPI platforms

Yong Zhi <yong.zhi@intel.com>
    ASoC: Intel: sof_rt5682: Add quirk for Rex board

Ricardo Cañuelo <ricardo.canuelo@collabora.com>
    selftests/kexec: fix build for ARCH=x86_64

Ricardo Cañuelo <ricardo.canuelo@collabora.com>
    selftests/intel_pstate: fix build for ARCH=x86_64

Ricardo Cañuelo <ricardo.canuelo@collabora.com>
    selftests/futex: fix build for clang

Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
    ASoC: Intel: sof_sdw: add quirk variant for LAPBC710 NUC15

Siarhei Volkau <lis8215@gmail.com>
    ASoC: codecs: jz4725b: fix capture selector naming

Siarhei Volkau <lis8215@gmail.com>
    ASoC: codecs: jz4725b: use right control for Capture Volume

Siarhei Volkau <lis8215@gmail.com>
    ASoC: codecs: jz4725b: fix reported volume for Master ctl

Siarhei Volkau <lis8215@gmail.com>
    ASoC: codecs: jz4725b: add missed Line In power control bit

Mauro Lima <mauro.lima@eclypsium.com>
    spi: intel: Fix the offset to get the 64K erase opcode

Xiaolei Wang <xiaolei.wang@windriver.com>
    ASoC: wm8962: Add an event handler for TEMP_HP and TEMP_SPK

Derek Fang <derek.fang@realtek.com>
    ASoC: rt1019: Fix the TDM settings

Derek Fang <derek.fang@realtek.com>
    ASoC: rt5682s: Fix the TDM Tx settings

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: mt6660: Keep the pm_runtime enables before component stuff in mt6660_i2c_probe

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: wm8997: Revert "ASoC: wm8997: Fix PM disable depth imbalance in wm8997_probe"

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: wm5110: Revert "ASoC: wm5110: Fix PM disable depth imbalance in wm5110_probe"

Zhang Qilong <zhangqilong3@huawei.com>
    ASoC: wm5102: Revert "ASoC: wm5102: Fix PM disable depth imbalance in wm5102_probe"

Krishna Yarlagadda <kyarlagadda@nvidia.com>
    spi: tegra210-quad: Fix combined sequence

Akhil P Oommen <quic_akhilpo@quicinc.com>
    drm/msm/gpu: Fix crash during system suspend after unbind

Christian Marangi <ansuelsmth@gmail.com>
    mtd: rawnand: qcom: handle ret from parse with codeword_fixup


-------------

Diffstat:

 Documentation/driver-api/miscellaneous.rst         |   5 +-
 .../process/code-of-conduct-interpretation.rst     |   2 +-
 Makefile                                           |   4 +-
 arch/arm/boot/dts/imx7s.dtsi                       |   4 +-
 arch/arm/boot/dts/sama7g5-pinfunc.h                |   2 +-
 arch/arm/mach-at91/pm_suspend.S                    |   7 +-
 .../boot/dts/freescale/imx8mm-tqma8mqml-mba8mx.dts |  32 ++-
 arch/arm64/boot/dts/freescale/imx8mm.dtsi          |   4 +-
 arch/arm64/boot/dts/freescale/imx8mn.dtsi          |   2 +-
 arch/arm64/boot/dts/freescale/imx93-pinfunc.h      |   0
 arch/arm64/boot/dts/qcom/ipq8074.dtsi              |   2 +-
 arch/arm64/boot/dts/qcom/sa8155p-adp.dts           |  13 +-
 arch/arm64/boot/dts/qcom/sa8295p-adp.dts           |  12 ++
 arch/arm64/boot/dts/qcom/sc7280.dtsi               |   3 +-
 arch/arm64/boot/dts/qcom/sc8280xp-crd.dts          |   6 +
 arch/arm64/boot/dts/qcom/sc8280xp.dtsi             |  36 +---
 .../boot/dts/qcom/sm8150-sony-xperia-kumano.dtsi   |   6 +
 .../boot/dts/qcom/sm8250-sony-xperia-edo.dtsi      |   6 +
 arch/arm64/boot/dts/qcom/sm8250.dtsi               |   1 +
 arch/arm64/boot/dts/qcom/sm8350-hdk.dts            |  12 ++
 arch/arm64/include/asm/cputype.h                   |   2 +-
 arch/arm64/include/asm/pgtable.h                   |   4 +-
 arch/arm64/mm/mmu.c                                |   8 +-
 arch/arm64/mm/pageattr.c                           |  11 +-
 arch/mips/kernel/relocate_kernel.S                 |  15 +-
 arch/mips/loongson64/reset.c                       |  10 +
 arch/powerpc/Kconfig                               |   2 +-
 arch/s390/include/asm/processor.h                  |  11 +-
 arch/x86/events/amd/core.c                         |   5 +-
 arch/x86/events/amd/uncore.c                       |   1 +
 arch/x86/events/intel/pt.c                         |   9 +
 arch/x86/include/asm/intel-family.h                |  11 +-
 arch/x86/kernel/cpu/bugs.c                         |  13 +-
 arch/x86/kernel/cpu/sgx/ioctl.c                    |   3 +
 arch/x86/kernel/fpu/core.c                         |   2 +-
 arch/x86/kvm/kvm-asm-offsets.c                     |   2 +
 arch/x86/kvm/svm/sev.c                             |   4 +-
 arch/x86/kvm/svm/svm.c                             |  91 ++++-----
 arch/x86/kvm/svm/svm.h                             |  10 +-
 arch/x86/kvm/svm/svm_ops.h                         |   5 -
 arch/x86/kvm/svm/vmenter.S                         | 136 ++++++++++++-
 arch/x86/kvm/xen.c                                 |   7 +-
 block/blk-cgroup.c                                 |   2 +-
 block/blk-core.c                                   |   1 -
 block/blk-mq.c                                     |   1 +
 block/blk-settings.c                               |   8 +-
 block/sed-opal.c                                   |  32 ++-
 drivers/accessibility/speakup/main.c               |   2 +-
 drivers/accessibility/speakup/utils.h              |   2 +-
 drivers/acpi/scan.c                                |   1 +
 drivers/acpi/x86/utils.c                           |   6 +
 drivers/ata/libata-scsi.c                          |  10 +
 drivers/ata/libata-transport.c                     |  19 +-
 drivers/block/drbd/drbd_main.c                     |   4 +-
 drivers/cxl/core/mbox.c                            |   2 +-
 drivers/cxl/pmem.c                                 |   2 +-
 drivers/firmware/arm_scmi/bus.c                    |  11 +
 drivers/firmware/arm_scmi/common.h                 |   5 +-
 drivers/firmware/arm_scmi/driver.c                 |  32 +--
 drivers/firmware/arm_scmi/mailbox.c                |   2 +-
 drivers/firmware/arm_scmi/optee.c                  |   2 +-
 drivers/firmware/arm_scmi/shmem.c                  |  31 ++-
 drivers/firmware/arm_scmi/smc.c                    |   2 +-
 drivers/firmware/google/coreboot_table.c           |  37 +++-
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |  15 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c           |   2 +
 drivers/gpu/drm/amd/amdgpu/mes_v11_0.c             |   9 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  35 +++-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |   6 -
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_crtc.c |  10 +-
 drivers/gpu/drm/amd/display/dc/bios/bios_parser2.c |  30 +++
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |  12 +-
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hubp.c  |   1 +
 .../gpu/drm/amd/display/dc/dcn314/dcn314_optc.c    |   2 +-
 .../amd/display/dc/dcn32/dcn32_resource_helpers.c  |   2 +-
 .../gpu/drm/amd/display/dc/dml/dcn20/dcn20_fpu.c   |   1 +
 .../amd/display/dc/dml/dcn32/display_mode_vba_32.c |   7 +-
 .../dc/dml/dcn32/display_mode_vba_util_32.c        |   2 +-
 .../display/dc/dml/dcn32/display_rq_dlg_calc_32.c  |   4 +-
 .../gpu/drm/amd/display/dc/dml/display_mode_vba.c  |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/amdgpu_smu.c          |  23 +--
 drivers/gpu/drm/amd/pm/swsmu/inc/amdgpu_smu.h      |   8 +
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v11_0.h       |  10 +-
 drivers/gpu/drm/amd/pm/swsmu/inc/smu_v13_0.h       |  11 +-
 drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |   2 +-
 drivers/gpu/drm/amd/pm/swsmu/smu13/smu_v13_0.c     |   9 +
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_0_ppt.c   |  30 ++-
 .../gpu/drm/amd/pm/swsmu/smu13/smu_v13_0_7_ppt.c   |  30 ++-
 drivers/gpu/drm/display/drm_dp_dual_mode_helper.c  |  51 +++--
 drivers/gpu/drm/drm_drv.c                          |   2 +-
 drivers/gpu/drm/drm_internal.h                     |   3 +-
 drivers/gpu/drm/imx/imx-tve.c                      |   5 +-
 drivers/gpu/drm/lima/lima_devfreq.c                |  15 +-
 drivers/gpu/drm/msm/adreno/adreno_device.c         |  10 +-
 drivers/gpu/drm/msm/msm_gpu.c                      |   2 +
 drivers/gpu/drm/msm/msm_gpu.h                      |   4 +
 drivers/gpu/drm/panel/panel-simple.c               |   2 +
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c       |  10 +-
 drivers/gpu/drm/scheduler/sched_entity.c           |   6 +-
 drivers/gpu/drm/vc4/vc4_kms.c                      |   8 +-
 drivers/i2c/busses/i2c-i801.c                      |   1 +
 drivers/i2c/busses/i2c-tegra.c                     |  16 +-
 drivers/iio/accel/bma400_core.c                    |  24 +--
 drivers/iio/adc/at91_adc.c                         |   4 +-
 drivers/iio/adc/mp2629_adc.c                       |   5 +-
 drivers/iio/pressure/ms5611.h                      |  12 +-
 drivers/iio/pressure/ms5611_core.c                 |  51 ++---
 drivers/iio/pressure/ms5611_spi.c                  |   2 +-
 drivers/iio/trigger/iio-trig-sysfs.c               |   6 +-
 drivers/infiniband/hw/efa/efa_main.c               |   4 +-
 drivers/input/joystick/iforce/iforce-main.c        |   8 +-
 drivers/input/serio/i8042.c                        |   4 -
 drivers/iommu/intel/iommu.c                        |   8 +-
 drivers/iommu/intel/pasid.c                        |   5 +-
 drivers/isdn/mISDN/core.c                          |   2 +-
 drivers/isdn/mISDN/dsp_pipeline.c                  |   3 +-
 drivers/md/dm-bufio.c                              |   2 +
 drivers/md/dm-crypt.c                              |   1 +
 drivers/md/dm-ioctl.c                              |   4 +-
 drivers/misc/vmw_vmci/vmci_queue_pair.c            |   2 +
 drivers/mmc/core/core.c                            |   8 +-
 drivers/mmc/host/sdhci-pci-core.c                  |   2 +
 drivers/mmc/host/sdhci-pci-o2micro.c               |   7 +
 drivers/mtd/nand/onenand/Kconfig                   |   1 +
 drivers/mtd/nand/raw/qcom_nandc.c                  |  12 +-
 drivers/net/ethernet/amazon/ena/ena_netdev.c       |   8 +-
 drivers/net/ethernet/atheros/ag71xx.c              |   3 +-
 drivers/net/ethernet/broadcom/bgmac.c              |   1 -
 drivers/net/ethernet/broadcom/bnxt/bnxt.c          |  62 +++++-
 drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
 drivers/net/ethernet/broadcom/bnxt/bnxt_hwrm.c     |   3 +-
 drivers/net/ethernet/cavium/liquidio/lio_main.c    |  34 +++-
 drivers/net/ethernet/hisilicon/hns3/hnae3.h        |   1 -
 .../hisilicon/hns3/hns3_common/hclge_comm_rss.c    |  20 --
 .../hisilicon/hns3/hns3_common/hclge_comm_rss.h    |   2 -
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.c    | 167 ++++++++-------
 drivers/net/ethernet/hisilicon/hns3/hns3_enet.h    |   1 +
 .../ethernet/hisilicon/hns3/hns3pf/hclge_main.c    |  11 +-
 drivers/net/ethernet/huawei/hinic/hinic_main.c     |   9 +-
 .../net/ethernet/marvell/octeon_ep/octep_main.c    |  16 +-
 .../ethernet/mellanox/mlxsw/spectrum_switchdev.c   |   2 +
 .../ethernet/microchip/lan966x/lan966x_ethtool.c   |   3 +
 .../net/ethernet/microchip/sparx5/sparx5_ethtool.c |   3 +
 .../net/ethernet/microchip/sparx5/sparx5_main.c    |   3 +
 .../net/ethernet/netronome/nfp/nfp_net_ethtool.c   |   6 +-
 drivers/net/ethernet/pensando/ionic/ionic_main.c   |   8 +-
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |   3 +
 drivers/net/macvlan.c                              |   6 +-
 drivers/net/mctp/mctp-i2c.c                        |  47 +++--
 drivers/net/mhi_net.c                              |   2 +
 drivers/net/netdevsim/dev.c                        |   1 +
 drivers/net/phy/dp83867.c                          |   7 +
 drivers/net/phy/marvell.c                          |  16 +-
 drivers/net/thunderbolt.c                          |  19 +-
 drivers/net/usb/smsc95xx.c                         |  46 ++++-
 drivers/nvme/host/ioctl.c                          |   6 +
 drivers/nvme/host/nvme.h                           |  16 +-
 drivers/nvme/host/pci.c                            |   4 +
 drivers/nvme/target/auth.c                         |   2 +
 drivers/nvme/target/configfs.c                     |   1 +
 drivers/parport/parport_pc.c                       |   2 +-
 drivers/pinctrl/devicetree.c                       |   2 +
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c   |   3 +
 drivers/pinctrl/pinctrl-rockchip.c                 |  40 ++++
 .../platform/surface/aggregator/ssh_packet_layer.c |  24 ++-
 drivers/platform/x86/amd/pmc.c                     |   3 +-
 drivers/platform/x86/intel/pmc/core.c              |   2 +
 drivers/platform/x86/intel/pmc/pltdrv.c            |   9 +
 drivers/platform/x86/thinkpad_acpi.c               |   4 +-
 drivers/rtc/rtc-cmos.c                             |   3 +
 drivers/s390/block/dcssblk.c                       |   1 +
 drivers/s390/scsi/zfcp_fsf.c                       |   2 +-
 drivers/scsi/scsi_debug.c                          |   6 +-
 drivers/scsi/scsi_transport_sas.c                  |  13 +-
 drivers/siox/siox-core.c                           |   2 +
 drivers/slimbus/Kconfig                            |   2 +-
 drivers/slimbus/stream.c                           |   8 +-
 drivers/soc/imx/soc-imx8m.c                        |  11 +
 drivers/spi/spi-intel.c                            |   2 +-
 drivers/spi/spi-stm32.c                            |   1 +
 drivers/spi/spi-tegra210-quad.c                    |   5 +
 drivers/target/loopback/tcm_loop.c                 |   3 +-
 drivers/tty/n_gsm.c                                |   2 +-
 drivers/tty/serial/8250/8250_lpss.c                |  17 +-
 drivers/tty/serial/8250/8250_omap.c                |  45 ++--
 drivers/tty/serial/8250/8250_port.c                |   7 +-
 drivers/tty/serial/fsl_lpuart.c                    |  76 ++++---
 drivers/tty/serial/imx.c                           |   1 +
 drivers/usb/cdns3/host.c                           |  56 ++---
 drivers/usb/chipidea/otg_fsm.c                     |   2 +
 drivers/usb/core/quirks.c                          |   3 +
 drivers/usb/dwc3/core.c                            |  10 +
 drivers/usb/dwc3/host.c                            |  10 -
 drivers/usb/host/bcma-hcd.c                        |  10 +-
 drivers/usb/serial/option.c                        |  19 +-
 drivers/usb/typec/mux/intel_pmc_mux.c              |  15 +-
 drivers/usb/typec/tipd/core.c                      |   6 +-
 drivers/vfio/vfio_main.c                           |  50 +++--
 drivers/xen/pcpu.c                                 |   2 +-
 fs/btrfs/raid56.c                                  |   6 +-
 fs/btrfs/tests/qgroup-tests.c                      |  16 +-
 fs/buffer.c                                        |   4 +-
 fs/ceph/snap.c                                     |   3 +-
 fs/cifs/connect.c                                  |  14 +-
 fs/cifs/ioctl.c                                    |   4 +-
 fs/cifs/misc.c                                     |   6 +-
 fs/cifs/smb2misc.c                                 |  12 +-
 fs/cifs/smb2ops.c                                  |  10 +-
 fs/cifs/smb2transport.c                            |   6 +-
 fs/erofs/fscache.c                                 | 226 +++++++++------------
 fs/gfs2/ops_fstype.c                               |  17 +-
 fs/hugetlbfs/inode.c                               |  32 ++-
 fs/namei.c                                         |   2 +-
 fs/netfs/buffered_read.c                           |  20 +-
 fs/netfs/io.c                                      |   3 +
 fs/nfs/nfs4proc.c                                  |   6 +-
 fs/nfsd/nfs4state.c                                |   1 +
 fs/ntfs/attrib.c                                   |  28 ++-
 fs/ntfs/inode.c                                    |   7 +
 include/linux/blkdev.h                             |  15 +-
 include/linux/bpf.h                                |   5 +
 include/linux/hugetlb.h                            |   2 +-
 include/linux/io_uring.h                           |   3 +
 include/linux/ring_buffer.h                        |   2 +-
 include/linux/trace.h                              |   4 +-
 include/linux/wireless.h                           |  10 +-
 include/net/ip.h                                   |   2 +-
 include/net/ipv6.h                                 |   2 +-
 include/soc/at91/sama7-ddr.h                       |   5 +-
 include/uapi/linux/ip.h                            |   6 +-
 include/uapi/linux/ipv6.h                          |   6 +-
 io_uring/io_uring.c                                |  12 +-
 io_uring/io_uring.h                                |   4 +-
 io_uring/net.c                                     |  23 +--
 io_uring/poll.c                                    |  41 ++--
 kernel/bpf/percpu_freelist.c                       |  23 +--
 kernel/bpf/syscall.c                               |  11 +
 kernel/bpf/trampoline.c                            |  15 +-
 kernel/bpf/verifier.c                              |  14 +-
 kernel/events/core.c                               |  25 ++-
 kernel/kprobes.c                                   |   8 +-
 kernel/rseq.c                                      |  19 +-
 kernel/trace/bpf_trace.c                           |   6 +
 kernel/trace/ftrace.c                              |   5 +-
 kernel/trace/kprobe_event_gen_test.c               |  48 +++--
 kernel/trace/rethook.c                             |   4 +-
 kernel/trace/ring_buffer.c                         |  71 +++++--
 kernel/trace/synth_event_gen_test.c                |  16 +-
 kernel/trace/trace.c                               |  12 +-
 kernel/trace/trace_eprobe.c                        |   3 +
 kernel/trace/trace_events_synth.c                  |   5 +-
 mm/filemap.c                                       |   2 +-
 mm/hugetlb.c                                       |  12 +-
 mm/maccess.c                                       |   2 +-
 mm/memory-failure.c                                |   5 +-
 net/9p/trans_fd.c                                  |  45 ++--
 net/bluetooth/l2cap_core.c                         |   2 +-
 net/bpf/test_run.c                                 |   1 +
 net/bridge/br_vlan.c                               |  17 +-
 net/caif/chnl_net.c                                |   3 -
 net/dsa/dsa2.c                                     |  10 +
 net/dsa/dsa_priv.h                                 |   1 +
 net/dsa/master.c                                   |   3 +-
 net/dsa/port.c                                     |  16 ++
 net/ipv4/tcp_cdg.c                                 |   2 +
 net/kcm/kcmsock.c                                  |  60 +-----
 net/netfilter/ipset/ip_set_core.c                  |   8 +-
 net/netlink/af_netlink.c                           |   8 +-
 net/sctp/outqueue.c                                |  13 +-
 net/sunrpc/auth_gss/auth_gss.c                     |   2 +-
 net/wireless/wext-core.c                           |  17 +-
 net/x25/x25_dev.c                                  |   2 +-
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/soc/amd/yc/acp6x-mach.c                      |  21 ++
 sound/soc/codecs/jz4725b.c                         |  34 ++--
 sound/soc/codecs/mt6660.c                          |   8 +-
 sound/soc/codecs/rt1019.c                          |  20 +-
 sound/soc/codecs/rt1019.h                          |   6 +
 sound/soc/codecs/rt1308-sdw.h                      |   2 +
 sound/soc/codecs/rt5514-spi.c                      |  15 +-
 sound/soc/codecs/rt5677-spi.c                      |  19 +-
 sound/soc/codecs/rt5682s.c                         |  15 +-
 sound/soc/codecs/rt5682s.h                         |   1 +
 sound/soc/codecs/tas2764.c                         |  19 +-
 sound/soc/codecs/tas2770.c                         |  20 +-
 sound/soc/codecs/tas2780.c                         |  19 +-
 sound/soc/codecs/wm5102.c                          |   6 +-
 sound/soc/codecs/wm5110.c                          |   6 +-
 sound/soc/codecs/wm8962.c                          |  54 ++++-
 sound/soc/codecs/wm8997.c                          |   6 +-
 sound/soc/fsl/fsl_asrc.c                           |   2 +-
 sound/soc/fsl/fsl_esai.c                           |   2 +-
 sound/soc/fsl/fsl_sai.c                            |   2 +-
 sound/soc/intel/boards/sof_rt5682.c                |  12 ++
 sound/soc/intel/boards/sof_sdw.c                   |  11 +
 sound/soc/soc-core.c                               |  17 +-
 sound/soc/soc-utils.c                              |   2 +-
 sound/soc/sof/topology.c                           |  20 +-
 sound/usb/midi.c                                   |   4 +-
 tools/testing/cxl/test/cxl.c                       |   4 +-
 tools/testing/selftests/bpf/test_progs.c           |   2 +-
 tools/testing/selftests/bpf/test_verifier.c        |   2 +-
 tools/testing/selftests/futex/functional/Makefile  |   6 +-
 tools/testing/selftests/intel_pstate/Makefile      |   6 +-
 tools/testing/selftests/kexec/Makefile             |   6 +-
 tools/testing/selftests/pidfd/pidfd_wait.c         |  10 +
 306 files changed, 2496 insertions(+), 1295 deletions(-)


