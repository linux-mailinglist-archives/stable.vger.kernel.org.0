Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8C557BB21
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 18:12:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbiGTQMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 12:12:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235591AbiGTQMB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 12:12:01 -0400
X-Greylist: delayed 352 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 20 Jul 2022 09:11:58 PDT
Received: from mout2.freenet.de (mout2.freenet.de [IPv6:2001:748:100:40::2:4])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1838252FC4;
        Wed, 20 Jul 2022 09:11:57 -0700 (PDT)
Received: from [195.4.92.123] (helo=sub4.freenet.de)
        by mout2.freenet.de with esmtpa (ID viktor.jaegerskuepper@freenet.de) (port 25) (Exim 4.94.2 #2)
        id 1oECD3-002J1t-KU; Wed, 20 Jul 2022 18:06:01 +0200
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=freenet.de;
        s=mjaymdexmjqk; h=Content-Transfer-Encoding:Content-Type:In-Reply-To:From:
        References:Cc:To:Subject:MIME-Version:Date:Message-ID:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=8j+UKl8OA3EZbQtFXJKm/du5VU2mBMoBEFGMIANonCI=; b=Nh10TbhJ20zmojFXEWzNp2qBZz
        vSSnb2h0VzyAzRc8QZFDS0ee6vaMKjZH/KomwUrbANpWAhEIvfhHmhiv82VuoFa5cchK5eNWeO8ZW
        4Bcd/eoIzLPd3Cq/FwDzaQH0eNdhmgZVspmHsh7JmuFeNHNI9CL3V3GgichB7cH/Y/l8sLLpn3rE7
        np77AcLtQ82bO4rixgi2g7nxn8Guu8ZmQCvJENXEV8WtVswLQRg4U1CWSpBbGhMtppG30ezpnqbFr
        TOKtkULxfhLgTA7tebGHIzlTzbQg7DZIkyP7RJG6OJTnykoORQ3fwKu7dvowy/irOiVQ1ihh7yP6l
        3ZyrNM7Q==;
Received: from ip-176-199-208-060.um44.pools.vodafone-ip.de ([176.199.208.60]:36472 helo=[127.0.0.1])
        by sub4.freenet.de with esmtpsa (ID viktor.jaegerskuepper@freenet.de) (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128) (port 465) (Exim 4.94.2 #2)
        id 1oECD3-0088H9-5w; Wed, 20 Jul 2022 18:06:00 +0200
Message-ID: <9038467b-5ada-9384-84b9-e7db11782d43@freenet.de>
Date:   Wed, 20 Jul 2022 18:05:55 +0200
MIME-Version: 1.0
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Content-Language: en-US-large
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220719114714.247441733@linuxfoundation.org>
From:   =?UTF-8?B?VmlrdG9yIErDpGdlcnNrw7xwcGVy?= 
        <viktor_jaegerskuepper@freenet.de>
In-Reply-To: <20220719114714.247441733@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-FN-MUUID: 16583331606AFFC35E130FO
X-Originated-At: 176.199.208.60!36472
X-Scan-TS: Wed, 20 Jul 2022 18:06:00 +0200
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 5.18.13 release.
> There are 231 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Hi Greg,

I noticed that there are several patches in the list which are also part of your
retbleed-5.18 queue. If I am not mistaken, these are:

[PATCH 5.18 145/231] x86/kvm: Fix SETcc emulation for return thunks
[PATCH 5.18 146/231] x86/sev: Avoid using __x86_return_thunk
[PATCH 5.18 147/231] x86/bugs: Report AMD retbleed vulnerability
[PATCH 5.18 148/231] objtool: Update Retpoline validation
[PATCH 5.18 149/231] x86/xen: Rename SYS* entry points
[PATCH 5.18 150/231] x86/cpu/amd: Add Spectral Chicken

I'm wondering if this is intended or if it would be better to release a stable
kernel with all the retbleed patches later because of the problems that came up
with these patches so far. I'm just a user, so I can't say anything about the
technical side, and I don't know how the patches were selected.

Thanks,
Viktor

> 
> Responses should be made by Thu, 21 Jul 2022 11:43:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.18.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.18.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 
> -------------
> Pseudo-Shortlog of commits:
> 
> Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>     Linux 5.18.13-rc1
> 
> Juergen Gross <jgross@suse.com>
>     x86/pat: Fix x86_has_pat_wp()
> 
> Pali Rohár <pali@kernel.org>
>     serial: mvebu-uart: correctly report configured baudrate value
> 
> Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>     serial: 8250: Fix PM usage_count for console handover
> 
> Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>     serial: pl011: UPSTAT_AUTORTS requires .throttle/unthrottle
> 
> Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
>     serial: stm32: Clear prev values before setting RTS delays
> 
> Dorian Rudolph <mail@dorianrudolph.com>
>     power: supply: core: Fix boundary conditions in interpolation
> 
> Yi Yang <yiyang13@huawei.com>
>     serial: 8250: fix return error code in serial8250_request_std_resource()
> 
> Mario Limonciello <mario.limonciello@amd.com>
>     ACPI: CPPC: Fix enabling CPPC on AMD systems with shared memory
> 
> Tony Krowiak <akrowiak@linux.ibm.com>
>     s390/ap: fix error handling in __verify_queue_reservations()
> 
> Yangxi Xiang <xyangxi5@gmail.com>
>     vt: fix memory overlapping when deleting chars in the buffer
> 
> Hans de Goede <hdegoede@redhat.com>
>     ACPI: video: Fix acpi_video_handles_brightness_key_presses()
> 
> Linus Torvalds <torvalds@linux-foundation.org>
>     signal handling: don't use BUG_ON() for debugging
> 
> Jason A. Donenfeld <Jason@zx2c4.com>
>     wireguard: selftests: always call kernel makefile
> 
> Jason A. Donenfeld <Jason@zx2c4.com>
>     wireguard: selftests: set fake real time in init
> 
> Keith Busch <kbusch@kernel.org>
>     nvme: use struct group for generic command dwords
> 
> Keith Busch <kbusch@kernel.org>
>     nvme-pci: phison e16 has bogus namespace ids
> 
> Egor Vorontsov <sdoregor@sdore.me>
>     ALSA: usb-audio: Add quirk for Fiero SC-01 (fw v1.0.0)
> 
> Egor Vorontsov <sdoregor@sdore.me>
>     ALSA: usb-audio: Add quirk for Fiero SC-01
> 
> John Veness <john-linux@pelago.org.uk>
>     ALSA: usb-audio: Add quirks for MacroSilicon MS2100/MS2106 devices
> 
> Srinivas Neeli <srinivas.neeli@xilinx.com>
>     Revert "can: xilinx_can: Limit CANFD brp to 2"
> 
> Gabriel Fernandez <gabriel.fernandez@foss.st.com>
>     ARM: dts: stm32: use the correct clock source for CEC on stm32mp151
> 
> Linus Walleij <linus.walleij@linaro.org>
>     soc: ixp4xx/npe: Fix unused match warning
> 
> Juergen Gross <jgross@suse.com>
>     x86: Clear .brk area at early boot
> 
> Jacky Bai <ping.bai@nxp.com>
>     pinctrl: imx: Add the zero base flag for imx93
> 
> Stafford Horne <shorne@gmail.com>
>     irqchip: or1k-pic: Undefine mask_ack for level triggered hardware
> 
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     ASoC: madera: Fix event generation for rate controls
> 
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     ASoC: madera: Fix event generation for OUT1 demux
> 
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     ASoC: cs47l15: Fix event generation for low power mux control
> 
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     ASoC: cs35l41: Add ASP TX3/4 source to register patch
> 
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     ASoC: dapm: Initialise kcontrol data for mux/demux controls
> 
> Shuming Fan <shumingf@realtek.com>
>     ASoC: rt711-sdca: fix kernel NULL pointer dereference when IO error
> 
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     ASoC: cs35l41: Correct some control names
> 
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     ASoC: wm5110: Fix DRE control
> 
> Charles Keepax <ckeepax@opensource.cirrus.com>
>     ASoC: wm_adsp: Fix event for preloader
> 
> Hans de Goede <hdegoede@redhat.com>
>     ASoC: Intel: bytcr_wm5102: Fix GPIO related probe-ordering problem
> 
> Mark Brown <broonie@kernel.org>
>     ASoC: wcd938x: Fix event generation for some controls
> 
> Mark Brown <broonie@kernel.org>
>     ASoC: wcd9335: Fix spurious event generation
> 
> Yassine Oudjana <y.oudjana@protonmail.com>
>     ASoC: wcd9335: Remove RX channel from old list before adding it to a new one
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>     ASoC: SOF: Intel: hda-loader: Clarify the cl_dsp_init() flow
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>     ASoC: SOF: Intel: hda-loader: Make sure that the fw load sequence is followed
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>     ASoC: SOF: Intel: hda-dsp: Expose hda_dsp_core_power_up()
> 
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>     ASoC: codecs: rt700/rt711/rt711-sdca: initialize workqueues in probe
> 
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>     ASoC: rt7*-sdw: harden jack_detect_handler
> 
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>     ASoC: rt711: fix calibrate mutex initialization
> 
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>     ASoC: Intel: sof_sdw: handle errors on card registration
> 
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>     ASoC: rt711-sdca-sdw: fix calibrate mutex initialization
> 
> Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>     ASoC: Realtek/Maxim SoundWire codecs: disable pm_runtime on remove
> 
> Haowen Bai <baihaowen@meizu.com>
>     pinctrl: aspeed: Fix potential NULL dereference in aspeed_pinmux_set_mux()
> 
> Mark Brown <broonie@kernel.org>
>     ASoC: ops: Fix off by one in range control validation
> 
> Jianglei Nie <niejianglei2021@163.com>
>     net: sfp: fix memory leak in sfp_probe()
> 
> Ruozhu Li <liruozhu@huawei.com>
>     nvme: fix regression when disconnect a recovering ctrl
> 
> Sagi Grimberg <sagi@grimberg.me>
>     nvme-tcp: always fail a request when sending it failed
> 
> Michael Walle <michael@walle.cc>
>     NFC: nxp-nci: don't print header length mismatch on i2c error
> 
> Hangyu Hua <hbh25y@gmail.com>
>     net: tipc: fix possible refcount leak in tipc_sk_create()
> 
> Javier Martinez Canillas <javierm@redhat.com>
>     fbdev: Disable sysfb device registration when removing conflicting FBs
> 
> Javier Martinez Canillas <javierm@redhat.com>
>     firmware: sysfb: Add sysfb_disable() helper function
> 
> Javier Martinez Canillas <javierm@redhat.com>
>     firmware: sysfb: Make sysfb_create_simplefb() return a pdev pointer
> 
> Kai-Heng Feng <kai.heng.feng@canonical.com>
>     platform/x86: hp-wmi: Ignore Sanitization Mode event
> 
> Mark Pearson <markpearson@lenovo.com>
>     platform/x86: thinkpad_acpi: do not use PSC mode on Intel platforms
> 
> Mark Pearson <markpearson@lenovo.com>
>     platform/x86: thinkpad-acpi: profile capabilities as integer
> 
> Liang He <windhl@126.com>
>     cpufreq: pmac32-cpufreq: Fix refcount leak bug
> 
> John Garry <john.garry@huawei.com>
>     scsi: hisi_sas: Limit max hw sectors for v3 HW
> 
> Florian Westphal <fw@strlen.de>
>     netfilter: br_netfilter: do not skip all hooks with 0 priority
> 
> Florian Westphal <fw@strlen.de>
>     netfilter: nf_tables: avoid skb access on nf_stolen
> 
> Stephan Gerhold <stephan.gerhold@kernkonzept.com>
>     virtio_mmio: Restore guest page size on resume
> 
> Stephan Gerhold <stephan.gerhold@kernkonzept.com>
>     virtio_mmio: Add missing PM calls to freeze/restore
> 
> Gayatri Kammela <gayatri.kammela@linux.intel.com>
>     platform/x86: intel/pmc: Add Alder Lake N support to PMC core driver
> 
> Parav Pandit <parav@nvidia.com>
>     vduse: Tie vduse mgmtdev and its device
> 
> Eli Cohen <elic@nvidia.com>
>     vdpa/mlx5: Initialize CVQ vringh only once
> 
> Nathan Lynch <nathanl@linux.ibm.com>
>     powerpc/xive/spapr: correct bitmap allocation size
> 
> Namjae Jeon <linkinjeon@kernel.org>
>     ksmbd: use SOCK_NONBLOCK type for kernel_accept()
> 
> Israel Rukshin <israelr@nvidia.com>
>     nvme: fix block device naming collision
> 
> Bjorn Andersson <bjorn.andersson@linaro.org>
>     scsi: ufs: core: Drop loglevel of WriteBoost message
> 
> Ming Lei <ming.lei@redhat.com>
>     scsi: megaraid: Clear READ queue map's nr_queues
> 
> Vasily Gorbik <gor@linux.ibm.com>
>     s390/nospec: build expoline.o for modules_prepare target
> 
> Jiri Slaby <jirislaby@kernel.org>
>     tty: use new tty_insert_flip_string_and_push_buffer() in pty_write()
> 
> Jiri Slaby <jirislaby@kernel.org>
>     tty: extract tty_flip_buffer_commit() from tty_flip_buffer_push()
> 
> Marc Kleine-Budde <mkl@pengutronix.de>
>     tee: tee_get_drvdata(): fix description of return value
> 
> Bryan O'Donoghue <bryan.odonoghue@linaro.org>
>     ASoC: dt-bindings: Fix description for msm8916
> 
> Linus Walleij <linus.walleij@linaro.org>
>     ARM: 9212/1: domain: Modify Kconfig help text
> 
> Linus Walleij <linus.walleij@linaro.org>
>     ARM: 9211/1: domain: drop modify_domain()
> 
> Peter Zijlstra <peterz@infradead.org>
>     x86/cpu/amd: Add Spectral Chicken
> 
> Peter Zijlstra <peterz@infradead.org>
>     x86/xen: Rename SYS* entry points
> 
> Peter Zijlstra <peterz@infradead.org>
>     objtool: Update Retpoline validation
> 
> Alexandre Chartre <alexandre.chartre@oracle.com>
>     x86/bugs: Report AMD retbleed vulnerability
> 
> Kim Phillips <kim.phillips@amd.com>
>     x86/sev: Avoid using __x86_return_thunk
> 
> Peter Zijlstra <peterz@infradead.org>
>     x86/kvm: Fix SETcc emulation for return thunks
> 
> Muchun Song <songmuchun@bytedance.com>
>     mm: sysctl: fix missing numa_stat when !CONFIG_HUGETLB_PAGE
> 
> Tariq Toukan <tariqt@nvidia.com>
>     net/tls: Check for errors in tls_device_init
> 
> Vitaly Kuznetsov <vkuznets@redhat.com>
>     KVM: x86: Fully initialize 'struct kvm_lapic_irq' in kvm_pv_kick_cpu_op()
> 
> Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
>     net: atlantic: remove aq_nic_deinit() when resume
> 
> Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
>     net: atlantic: remove deep parameter on suspend/resume functions
> 
> Íñigo Huguet <ihuguet@redhat.com>
>     sfc: fix kernel panic when creating VF
> 
> Andrea Mayer <andrea.mayer@uniroma2.it>
>     seg6: bpf: fix skb checksum in bpf_push_seg6_encap()
> 
> Andrea Mayer <andrea.mayer@uniroma2.it>
>     seg6: fix skb checksum in SRv6 End.B6 and End.B6.Encaps behaviors
> 
> Andrea Mayer <andrea.mayer@uniroma2.it>
>     seg6: fix skb checksum evaluation in SRH encapsulation/insertion
> 
> Xiubo Li <xiubli@redhat.com>
>     netfs: do not unlock and put the folio twice
> 
> Íñigo Huguet <ihuguet@redhat.com>
>     sfc: fix use after free when disabling sriov
> 
> Steve French <stfrench@microsoft.com>
>     smb3: workaround negprot bug in some Samba servers
> 
> Michel Dänzer <mdaenzer@redhat.com>
>     drm/amd/display: Ensure valid event timestamp for cursor-only commits
> 
> Yefim Barashkin <mr.b34r@kolabnow.com>
>     drm/amd/pm: Prevent divide by zero
> 
> Mario Kleiner <mario.kleiner.de@gmail.com>
>     drm/amd/display: Only use depth 36 bpp linebuffers on DCN display engines.
> 
> Prike Liang <Prike.Liang@amd.com>
>     drm/amdkfd: correct the MEC atomic support firmware checking for GC 10.3.7
> 
> Fangzhi Zuo <Jerry.Zuo@amd.com>
>     drm/amd/display: Ignore First MST Sideband Message Return Error
> 
> Jianglei Nie <niejianglei2021@163.com>
>     ima: Fix potential memory leak in ima_init_crypto()
> 
> Coiby Xu <coxu@redhat.com>
>     ima: force signature verification when CONFIG_KEXEC_SIG is configured
> 
> Dan Carpenter <dan.carpenter@oracle.com>
>     net: stmmac: fix leaks in probe
> 
> Liang He <windhl@126.com>
>     net: ftgmac100: Hold reference returned by of_get_child_by_name()
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     nexthop: Fix data-races around nexthop_compat_mode.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     ipv4: Fix data-races around sysctl_ip_dynaddr.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     tcp: Fix a data-race around sysctl_tcp_ecn_fallback.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     tcp: Fix data-races around sysctl_tcp_ecn.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     raw: Fix a data-race around sysctl_raw_l3mdev_accept.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     icmp: Fix a data-race around sysctl_icmp_ratemask.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     icmp: Fix a data-race around sysctl_icmp_ratelimit.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     icmp: Fix a data-race around sysctl_icmp_errors_use_inbound_ifaddr.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     icmp: Fix a data-race around sysctl_icmp_ignore_bogus_error_responses.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     icmp: Fix a data-race around sysctl_icmp_echo_ignore_broadcasts.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     icmp: Fix data-races around sysctl_icmp_echo_enable_probe.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     icmp: Fix a data-race around sysctl_icmp_echo_ignore_all.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     tcp: Fix a data-race around sysctl_max_tw_buckets.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     sysctl: Fix data-races in proc_dointvec_ms_jiffies().
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     sysctl: Fix data-races in proc_dou8vec_minmax().
> 
> Pavan Chebbi <pavan.chebbi@broadcom.com>
>     bnxt_en: Fix bnxt_refclk_read()
> 
> Vikas Gupta <vikas.gupta@broadcom.com>
>     bnxt_en: fix livepatch query
> 
> Michael Chan <michael.chan@broadcom.com>
>     bnxt_en: Fix bnxt_reinit_after_abort() code path
> 
> Kashyap Desai <kashyap.desai@broadcom.com>
>     bnxt_en: reclaim max resources if sriov enable fails
> 
> Andrzej Hajda <andrzej.hajda@intel.com>
>     drm/i915/selftests: fix subtraction overflow bug
> 
> Chris Wilson <chris.p.wilson@intel.com>
>     drm/i915/gt: Serialize TLB invalidates with GT resets
> 
> Chris Wilson <chris@chris-wilson.co.uk>
>     drm/i915/gt: Serialize GRDOM access between multiple engine resets
> 
> Matthew Auld <matthew.auld@intel.com>
>     drm/i915/ttm: fix sg_table construction
> 
> Dan Carpenter <dan.carpenter@oracle.com>
>     drm/i915/selftests: fix a couple IS_ERR() vs NULL tests
> 
> Douglas Anderson <dianders@chromium.org>
>     tracing: Fix sleeping while atomic in kdb ftdump
> 
> Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
>     ice: change devlink code to read NVM in blocks
> 
> Paul M Stillwell Jr <paul.m.stillwell.jr@intel.com>
>     ice: handle E822 generic device ID in PLDM header
> 
> Yevhen Orlov <yevhen.orlov@plvision.eu>
>     net: marvell: prestera: fix missed deinit sequence
> 
> Jeff Layton <jlayton@kernel.org>
>     lockd: fix nlm_close_files
> 
> Jeff Layton <jlayton@kernel.org>
>     lockd: set fl_owner when unlocking files
> 
> Chuck Lever <chuck.lever@oracle.com>
>     NFSD: Decode NFSv4 birth time attribute
> 
> Paolo Abeni <pabeni@redhat.com>
>     mptcp: fix subflow traversal at disconnect time
> 
> Demi Marie Obenour <demi@invisiblethingslab.com>
>     xen/gntdev: Ignore failure to unmap INVALID_GRANT_HANDLE
> 
> Dan Carpenter <dan.carpenter@oracle.com>
>     drm/i915/gvt: IS_ERR() vs NULL bug in intel_gvt_update_reg_whitelist()
> 
> Anup Patel <apatel@ventanamicro.com>
>     RISC-V: KVM: Fix SRCU deadlock caused by kvm_riscv_check_vcpu_requests()
> 
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nf_tables: replace BUG_ON by element length check
> 
> Eric Dumazet <edumazet@google.com>
>     vlan: fix memory leak in vlan_newlink()
> 
> Baowen Zheng <baowen.zheng@corigine.com>
>     nfp: fix issue of skb segments exceeds descriptor limitation
> 
> Pablo Neira Ayuso <pablo@netfilter.org>
>     netfilter: nf_log: incorrect offset to network header
> 
> William Zhang <william.zhang@broadcom.com>
>     arm64: dts: broadcom: bcm4908: Fix cpu node for smp boot
> 
> William Zhang <william.zhang@broadcom.com>
>     arm64: dts: broadcom: bcm4908: Fix timer node for BCM4906 SoC
> 
> Michal Suchanek <msuchanek@suse.de>
>     ARM: dts: sunxi: Fix SPI NOR campatible on Orange Pi Zero
> 
> Ryan Wanner <Ryan.Wanner@microchip.com>
>     ARM: dts: at91: sama5d2: Fix typo in i2s1 node
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     ipv4: Fix a data-race around sysctl_fib_sync_mem.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     icmp: Fix data-races around sysctl.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     cipso: Fix data-races around sysctl.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     net: Fix data-races around sysctl_mem.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     inetpeer: Fix data-races around sysctl.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     tcp: Fix a data-race around sysctl_tcp_max_orphans.
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     sysctl: Fix data races in proc_dointvec_jiffies().
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     sysctl: Fix data races in proc_doulongvec_minmax().
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     sysctl: Fix data races in proc_douintvec_minmax().
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     sysctl: Fix data races in proc_dointvec_minmax().
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     sysctl: Fix data races in proc_douintvec().
> 
> Kuniyuki Iwashima <kuniyu@amazon.com>
>     sysctl: Fix data races in proc_dointvec().
> 
> Pavel Skripkin <paskripkin@gmail.com>
>     net: ocelot: fix wrong time_after usage
> 
> Siddharth Vadapalli <s-vadapalli@ti.com>
>     net: ethernet: ti: am65-cpsw: Fix devlink port register sequence
> 
> Jon Hunter <jonathanh@nvidia.com>
>     net: stmmac: dwc-qos: Disable split header for Tegra194
> 
> Florian Westphal <fw@strlen.de>
>     netfilter: conntrack: fix crash due to confirmed bit load reordering
> 
> Florian Westphal <fw@strlen.de>
>     netfilter: conntrack: remove the percpu dying list
> 
> Florian Westphal <fw@strlen.de>
>     netfilter: conntrack: include ecache dying list in dumps
> 
> Florian Westphal <fw@strlen.de>
>     netfilter: ecache: use dedicated list for event redelivery
> 
> Florian Westphal <fw@strlen.de>
>     netfilter: conntrack: split inner loop of list dumping to own function
> 
> Florian Westphal <fw@strlen.de>
>     netfilter: ecache: move to separate structure
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>     ASoC: Intel: Skylake: Correct the handling of fmt_config flexible array
> 
> Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
>     ASoC: Intel: Skylake: Correct the ssp rate discovery in skl_get_ssp_clks()
> 
> Hector Martin <marcan@marcan.st>
>     ASoC: tas2764: Fix amp gain register offset & default
> 
> Hector Martin <marcan@marcan.st>
>     ASoC: tas2764: Correct playback volume range
> 
> Martin Povišer <povik+lin@cutebit.org>
>     ASoC: tas2764: Fix and extend FSYNC polarity handling
> 
> Martin Povišer <povik+lin@cutebit.org>
>     ASoC: tas2764: Add post reset delays
> 
> Francesco Dolcini <francesco.dolcini@toradex.com>
>     ASoC: sgtl5000: Fix noise on shutdown/remove
> 
> Huaxin Lu <luhuaxin1@huawei.com>
>     ima: Fix a potential integer overflow in ima_appraise_measurement
> 
> Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
>     drm/i915/guc: ADL-N should use the same GuC FW as ADL-S
> 
> Hangyu Hua <hbh25y@gmail.com>
>     drm/i915: fix a possible refcount leak in intel_dp_add_mst_connector()
> 
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu/display: disable prefer_shadow for generic fb helpers
> 
> Alex Deucher <alexander.deucher@amd.com>
>     drm/amdgpu: keep fbdev buffers pinned during suspend
> 
> Maxim Mikityanskiy <maximmi@nvidia.com>
>     net/mlx5e: Ring the TX doorbell on DMA errors
> 
> Gal Pressman <gal@nvidia.com>
>     net/mlx5e: Fix capability check for updating vnic env counters
> 
> Roi Dayan <roid@nvidia.com>
>     net/mlx5e: CT: Use own workqueue instead of mlx5e priv
> 
> Paul Blakey <paulb@nvidia.com>
>     net/mlx5e: Fix enabling sriov while tc nic rules are offloaded
> 
> Tariq Toukan <tariqt@nvidia.com>
>     net/mlx5e: kTLS, Fix build time constant test in RX
> 
> Tariq Toukan <tariqt@nvidia.com>
>     net/mlx5e: kTLS, Fix build time constant test in TX
> 
> Zhen Lei <thunder.leizhen@huawei.com>
>     ARM: 9210/1: Mark the FDT_FIXED sections as shareable
> 
> Ard Biesheuvel <ardb@kernel.org>
>     ARM: 9209/1: Spectre-BHB: avoid pr_info() every time a CPU comes out of idle
> 
> Cristian Ciocaltea <cristian.ciocaltea@collabora.com>
>     spi: amd: Limit max transfer and message size
> 
> Conor Dooley <conor.dooley@microchip.com>
>     riscv: dts: microchip: hook up the mpfs' l2cache
> 
> Kris Bahnsen <kris@embeddedTS.com>
>     ARM: dts: imx6qdl-ts7970: Fix ngpio typo and count
> 
> Sean Anderson <sean.anderson@seco.com>
>     arm64: dts: ls1028a: Update SFP node to include clock
> 
> Serge Semin <Sergey.Semin@baikalelectronics.ru>
>     reset: Fix devm bulk optional exclusive control getter
> 
> Xiu Jianfeng <xiujianfeng@huawei.com>
>     Revert "evm: Fix memleak in init_desc"
> 
> Geert Uytterhoeven <geert+renesas@glider.be>
>     sh: convert nommu io{re,un}map() to static inline functions
> 
> Ryusuke Konishi <konishi.ryusuke@gmail.com>
>     nilfs2: fix incorrect masking of permission flags for symlinks
> 
> Dave Chinner <dchinner@redhat.com>
>     fs/remap: constrain dedupe of EOF blocks
> 
> Dmitry Osipenko <dmitry.osipenko@collabora.com>
>     drm/panfrost: Fix shrinker list corruption by madvise IOCTL
> 
> Dmitry Osipenko <dmitry.osipenko@collabora.com>
>     drm/panfrost: Put mapping instead of shmem obj on panfrost_mmu_map_fault_addr() error
> 
> Christoph Hellwig <hch@lst.de>
>     btrfs: zoned: fix a leaked bioc in read_zone_info
> 
> Filipe Manana <fdmanana@suse.com>
>     btrfs: return -EAGAIN for NOWAIT dio reads/writes on compressed and inline extents
> 
> Tejun Heo <tj@kernel.org>
>     cgroup: Use separate src/dst nodes when preloading css_sets for migration
> 
> Felix Fietkau <nbd@nbd.name>
>     wifi: mac80211: fix queue selection for mesh/OCB interfaces
> 
> Ard Biesheuvel <ardb@kernel.org>
>     ARM: 9214/1: alignment: advance IT state after emulating Thumb instruction
> 
> Dmitry Osipenko <dmitry.osipenko@collabora.com>
>     ARM: 9213/1: Print message about disabled Spectre workarounds only once
> 
> Nicolas Dichtel <nicolas.dichtel@6wind.com>
>     ip: fix dflt addr selection for connected nexthop
> 
> Steven Rostedt (Google) <rostedt@goodmis.org>
>     net: sock: tracing: Fix sock_exceed_buf_limit not to dereference stale pointer
> 
> Zheng Yejian <zhengyejian1@huawei.com>
>     tracing/histograms: Fix memory leak problem
> 
> Baolin Wang <baolin.wang@linux.alibaba.com>
>     mm/damon: use set_huge_pte_at() to make huge pte old
> 
> Gowans, James <jgowans@amazon.com>
>     mm: split huge PUD on wp_huge_pud fallback
> 
> Muchun Song <songmuchun@bytedance.com>
>     mm: sparsemem: fix missing higher order allocation splitting
> 
> Axel Rasmussen <axelrasmussen@google.com>
>     mm: userfaultfd: fix UFFDIO_CONTINUE on fallocated shmem pages
> 
> Oleg Nesterov <oleg@redhat.com>
>     fix race between exit_itimers() and /proc/pid/timers
> 
> Juergen Gross <jgross@suse.com>
>     xen/netback: avoid entering xenvif_rx_next_skb() with an empty rx queue
> 
> Meng Tang <tangmeng@uniontech.com>
>     ALSA: hda/realtek - Enable the headset-mic on a Xiaomi's laptop
> 
> Meng Tang <tangmeng@uniontech.com>
>     ALSA: hda/realtek - Fix headset mic problem for a HP machine with alc221
> 
> Jeremy Szu <jeremy.szu@canonical.com>
>     ALSA: hda/realtek: fix mute/micmute LEDs for HP machines
> 
> Meng Tang <tangmeng@uniontech.com>
>     ALSA: hda/realtek - Fix headset mic problem for a HP machine with alc671
> 
> Meng Tang <tangmeng@uniontech.com>
>     ALSA: hda/realtek: Fix headset mic for Acer SF313-51
> 
> Meng Tang <tangmeng@uniontech.com>
>     ALSA: hda/conexant: Apply quirk for another HP ProDesk 600 G3 model
> 
> Meng Tang <tangmeng@uniontech.com>
>     ALSA: hda - Add fixup for Dell Latitidue E5430
> 
> Juergen Gross <jgross@suse.com>
>     x86/xen: Use clear_bss() for Xen PV guests
> 
> Chanho Park <chanho61.park@samsung.com>
>     tty: serial: samsung_tty: set dma burst_size to 1
> 
> Bartosz Golaszewski <brgl@bgdev.pl>
>     gpio: sim: fix the chip_name configfs item
> 
> Thinh Nguyen <Thinh.Nguyen@synopsys.com>
>     usb: dwc3: gadget: Fix event pending check
> 
> Linyu Yuan <quic_linyyuan@quicinc.com>
>     usb: typec: add missing uevent when partner support PD
> 
> Lucien Buchmann <lucien.buchmann@gmx.net>
>     USB: serial: ftdi_sio: add Belimo device ids
> 
> 
> -------------
> 
> Diffstat:
> 
>  .../devicetree/bindings/sound/qcom,lpass-cpu.yaml  |   8 +-
>  .../driver-api/firmware/other_interfaces.rst       |   6 +
>  Documentation/filesystems/netfs_library.rst        |   8 +-
>  Documentation/networking/ip-sysctl.rst             |   4 +-
>  Makefile                                           |   4 +-
>  arch/arm/boot/dts/imx6qdl-ts7970.dtsi              |   2 +-
>  arch/arm/boot/dts/sama5d2.dtsi                     |   2 +-
>  arch/arm/boot/dts/stm32mp151.dtsi                  |   2 +-
>  arch/arm/boot/dts/sun8i-h2-plus-orangepi-zero.dts  |   2 +-
>  arch/arm/include/asm/domain.h                      |  13 --
>  arch/arm/include/asm/mach/map.h                    |   1 +
>  arch/arm/include/asm/ptrace.h                      |  26 +++
>  arch/arm/mm/Kconfig                                |   6 +-
>  arch/arm/mm/alignment.c                            |   3 +
>  arch/arm/mm/mmu.c                                  |  15 +-
>  arch/arm/mm/proc-v7-bugs.c                         |   9 +-
>  arch/arm/probes/decode.h                           |  26 +--
>  arch/arm64/boot/dts/broadcom/bcm4908/bcm4906.dtsi  |   8 +
>  arch/arm64/boot/dts/broadcom/bcm4908/bcm4908.dtsi  |   2 +
>  arch/arm64/boot/dts/freescale/fsl-ls1028a.dtsi     |   5 +-
>  arch/powerpc/sysdev/xive/spapr.c                   |   5 +-
>  arch/riscv/boot/dts/microchip/microchip-mpfs.dtsi  |   4 +
>  arch/riscv/kvm/vcpu.c                              |   2 +
>  arch/s390/Makefile                                 |   8 +-
>  arch/s390/lib/Makefile                             |   3 +-
>  arch/s390/lib/expoline/Makefile                    |   3 +
>  arch/s390/lib/{ => expoline}/expoline.S            |   0
>  arch/sh/include/asm/io.h                           |   8 +-
>  arch/x86/include/asm/cpufeatures.h                 |   1 +
>  arch/x86/include/asm/msr-index.h                   |   3 +
>  arch/x86/include/asm/nospec-branch.h               |   6 +
>  arch/x86/include/asm/setup.h                       |   3 +
>  arch/x86/kernel/acpi/cppc.c                        |   6 +
>  arch/x86/kernel/cpu/amd.c                          |  23 +-
>  arch/x86/kernel/cpu/bugs.c                         |  13 ++
>  arch/x86/kernel/cpu/common.c                       |  19 ++
>  arch/x86/kernel/cpu/cpu.h                          |   2 +
>  arch/x86/kernel/cpu/hygon.c                        |   6 +
>  arch/x86/kernel/head64.c                           |   4 +-
>  arch/x86/kvm/emulate.c                             |  28 +--
>  arch/x86/kvm/x86.c                                 |  18 +-
>  arch/x86/mm/init.c                                 |  14 +-
>  arch/x86/mm/mem_encrypt_boot.S                     |  10 +-
>  arch/x86/xen/enlighten_pv.c                        |   8 +-
>  arch/x86/xen/setup.c                               |   6 +-
>  arch/x86/xen/xen-asm.S                             |  20 +-
>  arch/x86/xen/xen-head.S                            |  11 +-
>  arch/x86/xen/xen-ops.h                             |   6 +-
>  drivers/acpi/acpi_video.c                          |  11 +-
>  drivers/base/cpu.c                                 |   8 +
>  drivers/cpufreq/pmac32-cpufreq.c                   |   4 +
>  drivers/firmware/sysfb.c                           |  58 ++++-
>  drivers/firmware/sysfb_simplefb.c                  |  16 +-
>  drivers/gpio/gpio-sim.c                            |  16 +-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_display.c        |  25 ++-
>  drivers/gpu/drm/amd/amdgpu/amdgpu_vkms.c           |   3 +-
>  drivers/gpu/drm/amd/amdgpu/dce_v10_0.c             |   3 +-
>  drivers/gpu/drm/amd/amdgpu/dce_v11_0.c             |   3 +-
>  drivers/gpu/drm/amd/amdgpu/dce_v6_0.c              |   3 +-
>  drivers/gpu/drm/amd/amdgpu/dce_v8_0.c              |   3 +-
>  drivers/gpu/drm/amd/amdkfd/kfd_device.c            |   2 +
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |  85 ++++++-
>  drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |   8 +
>  .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  17 ++
>  drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |  11 +-
>  drivers/gpu/drm/amd/pm/swsmu/smu11/smu_v11_0.c     |   2 +
>  drivers/gpu/drm/i915/display/intel_dp_mst.c        |   1 +
>  drivers/gpu/drm/i915/gem/i915_gem_ttm.c            |  11 +-
>  drivers/gpu/drm/i915/gt/intel_gt.c                 |  15 +-
>  drivers/gpu/drm/i915/gt/intel_reset.c              |  37 ++-
>  drivers/gpu/drm/i915/gt/selftest_lrc.c             |   8 +-
>  drivers/gpu/drm/i915/gt/uc/intel_uc_fw.c           |   9 +
>  drivers/gpu/drm/i915/gvt/cmd_parser.c              |   6 +-
>  drivers/gpu/drm/i915/i915_scatterlist.c            |  19 +-
>  drivers/gpu/drm/i915/i915_scatterlist.h            |   6 +-
>  drivers/gpu/drm/i915/intel_region_ttm.c            |  10 +-
>  drivers/gpu/drm/i915/intel_region_ttm.h            |   3 +-
>  drivers/gpu/drm/i915/selftests/i915_gem_gtt.c      |   2 +-
>  .../gpu/drm/i915/selftests/intel_memory_region.c   |  21 +-
>  drivers/gpu/drm/i915/selftests/mock_region.c       |   3 +-
>  drivers/gpu/drm/panfrost/panfrost_drv.c            |   4 +-
>  drivers/gpu/drm/panfrost/panfrost_mmu.c            |   2 +-
>  drivers/irqchip/irq-or1k-pic.c                     |   1 -
>  drivers/net/can/xilinx_can.c                       |   4 +-
>  .../net/ethernet/aquantia/atlantic/aq_pci_func.c   |  23 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.c          |   5 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt.h          |   1 +
>  drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c  |   8 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_ptp.c      |  13 +-
>  drivers/net/ethernet/broadcom/bnxt/bnxt_sriov.c    |   7 +-
>  .../chelsio/inline_crypto/chtls/chtls_cm.c         |   2 +-
>  drivers/net/ethernet/faraday/ftgmac100.c           |  15 +-
>  drivers/net/ethernet/intel/ice/ice_devids.h        |   1 +
>  drivers/net/ethernet/intel/ice/ice_devlink.c       |  59 +++--
>  drivers/net/ethernet/intel/ice/ice_fw_update.c     |  96 +++++++-
>  drivers/net/ethernet/intel/ice/ice_main.c          |   1 +
>  .../ethernet/marvell/prestera/prestera_router.c    |   1 +
>  drivers/net/ethernet/mellanox/mlx5/core/en/tc_ct.c |  20 +-
>  .../ethernet/mellanox/mlx5/core/en_accel/ktls_rx.c |   3 +-
>  .../ethernet/mellanox/mlx5/core/en_accel/ktls_tx.c |   3 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_stats.c |   2 +-
>  drivers/net/ethernet/mellanox/mlx5/core/en_tx.c    |  39 +++-
>  .../net/ethernet/mellanox/mlx5/core/esw/legacy.c   |   5 +-
>  drivers/net/ethernet/mscc/ocelot_fdma.c            |  17 +-
>  drivers/net/ethernet/netronome/nfp/nfdk/dp.c       |  33 ++-
>  drivers/net/ethernet/sfc/ef10.c                    |   3 +
>  drivers/net/ethernet/sfc/ef10_sriov.c              |  10 +-
>  .../ethernet/stmicro/stmmac/dwmac-dwc-qos-eth.c    |   1 +
>  .../net/ethernet/stmicro/stmmac/dwmac-ingenic.c    |   6 +-
>  drivers/net/ethernet/ti/am65-cpsw-nuss.c           |  17 +-
>  drivers/net/phy/sfp.c                              |   2 +-
>  drivers/net/xen-netback/rx.c                       |   1 +
>  drivers/nfc/nxp-nci/i2c.c                          |   8 +-
>  drivers/nvme/host/core.c                           |   8 +-
>  drivers/nvme/host/nvme.h                           |   1 +
>  drivers/nvme/host/pci.c                            |   3 +-
>  drivers/nvme/host/rdma.c                           |  12 +-
>  drivers/nvme/host/tcp.c                            |  13 +-
>  drivers/nvme/host/trace.h                          |   2 +-
>  drivers/pinctrl/aspeed/pinctrl-aspeed.c            |   4 +-
>  drivers/pinctrl/freescale/pinctrl-imx93.c          |   1 +
>  drivers/platform/x86/hp-wmi.c                      |   3 +
>  drivers/platform/x86/intel/pmc/core.c              |   1 +
>  drivers/platform/x86/thinkpad_acpi.c               |  50 ++---
>  drivers/power/supply/power_supply_core.c           |  24 +-
>  drivers/s390/crypto/ap_bus.c                       |   2 +-
>  drivers/scsi/hisi_sas/hisi_sas_v3_hw.c             |   7 +
>  drivers/scsi/megaraid/megaraid_sas_base.c          |   3 +
>  drivers/scsi/ufs/ufshcd.c                          |   2 +-
>  drivers/soc/ixp4xx/ixp4xx-npe.c                    |   2 +-
>  drivers/spi/spi-amd.c                              |   8 +
>  drivers/tee/tee_core.c                             |   2 +-
>  drivers/tty/pty.c                                  |  14 +-
>  drivers/tty/serial/8250/8250_core.c                |   4 +
>  drivers/tty/serial/8250/8250_port.c                |   4 +-
>  drivers/tty/serial/amba-pl011.c                    |  23 +-
>  drivers/tty/serial/mvebu-uart.c                    |  25 ++-
>  drivers/tty/serial/samsung_tty.c                   |   5 +-
>  drivers/tty/serial/serial_core.c                   |   5 -
>  drivers/tty/serial/stm32-usart.c                   |   2 +
>  drivers/tty/tty.h                                  |   3 +
>  drivers/tty/tty_buffer.c                           |  46 +++-
>  drivers/tty/vt/vt.c                                |   2 +-
>  drivers/usb/dwc3/gadget.c                          |   4 +-
>  drivers/usb/serial/ftdi_sio.c                      |   3 +
>  drivers/usb/serial/ftdi_sio_ids.h                  |   6 +
>  drivers/usb/typec/class.c                          |   1 +
>  drivers/vdpa/mlx5/net/mlx5_vnet.c                  |  31 ++-
>  drivers/vdpa/vdpa_user/vduse_dev.c                 |  60 +++--
>  drivers/video/fbdev/core/fbmem.c                   |  12 +
>  drivers/virtio/virtio_mmio.c                       |  26 +++
>  drivers/xen/gntdev.c                               |   6 +-
>  fs/afs/file.c                                      |   2 +-
>  fs/btrfs/inode.c                                   |  14 +-
>  fs/btrfs/zoned.c                                   |  13 +-
>  fs/ceph/addr.c                                     |  11 +-
>  fs/cifs/smb2pdu.c                                  |  13 +-
>  fs/exec.c                                          |   2 +-
>  fs/ksmbd/transport_tcp.c                           |   2 +-
>  fs/lockd/svcsubs.c                                 |  14 +-
>  fs/netfs/buffered_read.c                           |  17 +-
>  fs/nfsd/nfs4xdr.c                                  |   9 +
>  fs/nfsd/nfsd.h                                     |   3 +-
>  fs/nilfs2/nilfs.h                                  |   3 +
>  fs/remap_range.c                                   |   3 +-
>  include/linux/cgroup-defs.h                        |   3 +-
>  include/linux/cpu.h                                |   2 +
>  include/linux/kexec.h                              |   6 +
>  include/linux/netfs.h                              |   2 +-
>  include/linux/nvme.h                               |   2 +
>  include/linux/reset.h                              |   2 +-
>  include/linux/sched/task.h                         |   2 +-
>  include/linux/serial_core.h                        |   5 +
>  include/linux/sysfb.h                              |  22 +-
>  include/net/netfilter/nf_conntrack.h               |   9 +-
>  include/net/netfilter/nf_conntrack_ecache.h        |   4 +-
>  include/net/netfilter/nf_tables.h                  |  30 ++-
>  include/net/netns/conntrack.h                      |   1 -
>  include/net/raw.h                                  |   2 +-
>  include/net/sock.h                                 |   2 +-
>  include/net/tls.h                                  |   4 +-
>  include/trace/events/sock.h                        |   6 +-
>  kernel/cgroup/cgroup.c                             |  37 +--
>  kernel/exit.c                                      |   2 +-
>  kernel/kexec_file.c                                |  11 +-
>  kernel/signal.c                                    |   8 +-
>  kernel/sysctl.c                                    |  57 ++---
>  kernel/time/posix-timers.c                         |  19 +-
>  kernel/trace/trace.c                               |  11 +-
>  kernel/trace/trace_events_hist.c                   |   2 +
>  mm/damon/vaddr.c                                   |   3 +-
>  mm/memory.c                                        |  27 +--
>  mm/sparse-vmemmap.c                                |   8 +
>  mm/userfaultfd.c                                   |   5 +-
>  net/8021q/vlan_netlink.c                           |  10 +-
>  net/bridge/br_netfilter_hooks.c                    |  21 +-
>  net/core/filter.c                                  |   1 -
>  net/ipv4/af_inet.c                                 |   4 +-
>  net/ipv4/cipso_ipv4.c                              |  12 +-
>  net/ipv4/fib_semantics.c                           |   4 +-
>  net/ipv4/fib_trie.c                                |   2 +-
>  net/ipv4/icmp.c                                    |  20 +-
>  net/ipv4/inet_timewait_sock.c                      |   3 +-
>  net/ipv4/inetpeer.c                                |  12 +-
>  net/ipv4/nexthop.c                                 |   5 +-
>  net/ipv4/syncookies.c                              |   2 +-
>  net/ipv4/sysctl_net_ipv4.c                         |  12 +
>  net/ipv4/tcp.c                                     |   3 +-
>  net/ipv4/tcp_input.c                               |   2 +-
>  net/ipv4/tcp_output.c                              |   4 +-
>  net/ipv6/icmp.c                                    |   2 +-
>  net/ipv6/route.c                                   |   2 +-
>  net/ipv6/seg6_iptunnel.c                           |   5 +-
>  net/ipv6/seg6_local.c                              |   2 -
>  net/mac80211/wme.c                                 |   4 +-
>  net/mptcp/protocol.c                               |   4 +-
>  net/netfilter/nf_conntrack_core.c                  |  86 ++++---
>  net/netfilter/nf_conntrack_ecache.c                | 139 ++++++------
>  net/netfilter/nf_conntrack_netlink.c               | 125 ++++++++---
>  net/netfilter/nf_conntrack_standalone.c            |   3 +
>  net/netfilter/nf_log_syslog.c                      |   8 +-
>  net/netfilter/nf_tables_api.c                      |  72 ++++--
>  net/netfilter/nf_tables_core.c                     |  24 +-
>  net/netfilter/nf_tables_trace.c                    |  44 ++--
>  net/tipc/socket.c                                  |   1 +
>  net/tls/tls_device.c                               |   4 +-
>  net/tls/tls_main.c                                 |   7 +-
>  security/integrity/evm/evm_crypto.c                |   7 +-
>  security/integrity/ima/ima_appraise.c              |   3 +-
>  security/integrity/ima/ima_crypto.c                |   1 +
>  security/integrity/ima/ima_efi.c                   |   2 +
>  sound/pci/hda/patch_conexant.c                     |   1 +
>  sound/pci/hda/patch_realtek.c                      |  20 ++
>  sound/soc/codecs/cs35l41-lib.c                     |  10 +-
>  sound/soc/codecs/cs35l41.c                         |  12 +-
>  sound/soc/codecs/cs47l15.c                         |   5 +-
>  sound/soc/codecs/madera.c                          |  14 +-
>  sound/soc/codecs/max98373-sdw.c                    |  12 +-
>  sound/soc/codecs/rt1308-sdw.c                      |  11 +
>  sound/soc/codecs/rt1316-sdw.c                      |  11 +
>  sound/soc/codecs/rt5682-sdw.c                      |   5 +-
>  sound/soc/codecs/rt700-sdw.c                       |   6 +-
>  sound/soc/codecs/rt700.c                           |  14 +-
>  sound/soc/codecs/rt711-sdca-sdw.c                  |   9 +-
>  sound/soc/codecs/rt711-sdca.c                      |  18 +-
>  sound/soc/codecs/rt711-sdw.c                       |   9 +-
>  sound/soc/codecs/rt711.c                           |  16 +-
>  sound/soc/codecs/rt715-sdca-sdw.c                  |  12 +
>  sound/soc/codecs/rt715-sdw.c                       |  12 +
>  sound/soc/codecs/sgtl5000.c                        |   9 +
>  sound/soc/codecs/sgtl5000.h                        |   1 +
>  sound/soc/codecs/tas2764.c                         |  46 ++--
>  sound/soc/codecs/tas2764.h                         |   6 +-
>  sound/soc/codecs/wcd9335.c                         |   8 +-
>  sound/soc/codecs/wcd938x.c                         |  12 +
>  sound/soc/codecs/wm5110.c                          |   8 +-
>  sound/soc/codecs/wm_adsp.c                         |   2 +-
>  sound/soc/intel/boards/bytcr_wm5102.c              |  13 +-
>  sound/soc/intel/boards/sof_sdw.c                   |  51 +++--
>  sound/soc/intel/skylake/skl-nhlt.c                 |  40 ++--
>  sound/soc/soc-dapm.c                               |   5 +
>  sound/soc/soc-ops.c                                |   4 +-
>  sound/soc/sof/intel/hda-dsp.c                      |  10 +-
>  sound/soc/sof/intel/hda-loader.c                   |  10 +-
>  sound/soc/sof/intel/hda.h                          |   1 +
>  sound/usb/quirks-table.h                           | 248 +++++++++++++++++++++
>  sound/usb/quirks.c                                 |   9 +
>  tools/objtool/check.c                              |  19 +-
>  tools/testing/selftests/wireguard/qemu/Makefile    |   5 +-
>  .../selftests/wireguard/qemu/arch/arm.config       |   1 +
>  .../selftests/wireguard/qemu/arch/armeb.config     |   1 +
>  .../selftests/wireguard/qemu/arch/i686.config      |   1 +
>  .../selftests/wireguard/qemu/arch/m68k.config      |   1 +
>  .../selftests/wireguard/qemu/arch/mips.config      |   1 +
>  .../selftests/wireguard/qemu/arch/mipsel.config    |   1 +
>  .../selftests/wireguard/qemu/arch/powerpc.config   |   1 +
>  tools/testing/selftests/wireguard/qemu/init.c      |  11 +
>  277 files changed, 2493 insertions(+), 955 deletions(-)
> 
> 
> 
