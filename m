Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B0A45065EA
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 09:32:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236225AbiDSHev (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Apr 2022 03:34:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233072AbiDSHeu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Apr 2022 03:34:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6796ADF75;
        Tue, 19 Apr 2022 00:32:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DA84F60FD2;
        Tue, 19 Apr 2022 07:32:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B076C385AA;
        Tue, 19 Apr 2022 07:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1650353526;
        bh=orKO8ZVDMRE3lso8z2IbWLX3Y3Spn8uuvmP9sHGfSpk=;
        h=From:To:Cc:Subject:Date:From;
        b=de4V+SE+fAd7uWHHMmpd6Orj/iR+6aqgtSrcTr/+karlP96u9SKLbOK2xWqP1WVwL
         k3I/0iV4o1uEVCHYRrP7C3j7j5JoSDXgqGU16a4EPEzMIOpEaHL8+5G9dkpeh/zkKS
         Vx9uVzGd+OzuJ5yFZA7bTlMHqmy8VFA8/iqByPy4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/189] 5.15.35-rc2 review
Date:   Tue, 19 Apr 2022 09:32:02 +0200
Message-Id: <20220419073048.315594917@linuxfoundation.org>
X-Mailer: git-send-email 2.35.3
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.35-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.35-rc2
X-KernelTest-Deadline: 2022-04-21T07:30+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.35 release.
There are 189 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Thu, 21 Apr 2022 07:30:20 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.35-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.35-rc2

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix UAF bugs in ax25 timers

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix NULL pointer dereferences in ax25 timers

Duoming Zhou <duoming@zju.edu.cn>
    ax25: fix NPD bug in ax25_disconnect

Duoming Zhou <duoming@zju.edu.cn>
    ax25: fix UAF bug in ax25_send_control()

Duoming Zhou <duoming@zju.edu.cn>
    ax25: Fix refcount leaks caused by ax25_cb_del()

Duoming Zhou <duoming@zju.edu.cn>
    ax25: fix UAF bugs of net_device caused by rebinding operation

Duoming Zhou <duoming@zju.edu.cn>
    ax25: fix reference count leaks of ax25_dev

Duoming Zhou <duoming@zju.edu.cn>
    ax25: add refcount in ax25_dev to avoid UAF bugs

Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
    cpufreq: intel_pstate: ITMT support for overclocked system

Alex Elder <elder@linaro.org>
    net: ipa: fix a build dependency

Miaoqian Lin <linmq006@gmail.com>
    soc: qcom: aoss: Fix missing put_device call in qmp_get

Steven Price <steven.price@arm.com>
    cpu/hotplug: Remove the 'cpu' member of cpuhp_cpu_state

Matt Roper <matthew.d.roper@intel.com>
    drm/i915: Sunset igpu legacy mmap support based on GRAPHICS_VER_FULL

Chao Gao <chao.gao@intel.com>
    dma-direct: avoid redundant memory sync for swiotlb

Anna-Maria Behnsen <anna-maria@linutronix.de>
    timers: Fix warning condition in __run_timers()

Dongjin Yang <dj76.yang@samsung.com>
    dt-bindings: net: snps: remove duplicate name

Martin Povišer <povik+lin@cutebit.org>
    i2c: pasemi: Wait for write xfers to finish

Nadav Amit <namit@vmware.com>
    smp: Fix offline cpu check in flush_smp_call_function_queue()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    i2c: dev: check return value when calling dev_set_name()

Mikulas Patocka <mpatocka@redhat.com>
    dm integrity: fix memory corruption when tag_size is less than digest size

Nathan Chancellor <nathan@kernel.org>
    ARM: davinci: da850-evm: Avoid NULL pointer dereference

Paul Gortmaker <paul.gortmaker@windriver.com>
    tick/nohz: Use WARN_ON_ONCE() to prevent console saturation

Rei Yamamoto <yamamoto.rei@jp.fujitsu.com>
    genirq/affinity: Consider that CPUs on nodes can be unbalanced

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/tsx: Disable TSX development mode at boot

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/tsx: Use MSR_TSX_CTRL to clear CPUID bits

Tomasz Moń <desowin@gmail.com>
    drm/amdgpu: Enable gfxoff quirk on MacBook Pro

Melissa Wen <mwen@igalia.com>
    drm/amd/display: don't ignore alpha property on pre-multiplied mode

Nicolas Dichtel <nicolas.dichtel@6wind.com>
    ipv6: fix panic when forwarding a pkt with no in6 dev

Johannes Berg <johannes.berg@intel.com>
    nl80211: correctly check NL80211_ATTR_REG_ALPHA2 size

Fabio M. De Francesco <fmdefrancesco@gmail.com>
    ALSA: pcm: Test for "silence" field in struct "pcm_format_data"

Tao Jin <tao-j@outlook.com>
    ALSA: hda/realtek: add quirk for Lenovo Thinkpad X12 speakers

Tim Crawford <tcrawford@system76.com>
    ALSA: hda/realtek: Add quirk for Clevo PD50PNT

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: mark resumed async balance as writing

Jia-Ju Bai <baijiaju1990@gmail.com>
    btrfs: fix root ref counts in error handling in btrfs_get_root_ref

Toke Høiland-Jørgensen <toke@redhat.com>
    ath9k: Fix usage of driver-private space in tx_info

Toke Høiland-Jørgensen <toke@toke.dk>
    ath9k: Properly clear TX status area before reporting to mac80211

Ronnie Sahlberg <lsahlber@redhat.com>
    cifs: verify that tcon is valid before dereference in cifs_kill_sb

Jason A. Donenfeld <Jason@zx2c4.com>
    gcc-plugins: latent_entropy: use /dev/urandom

Johan Hovold <johan@kernel.org>
    memory: renesas-rpc-if: fix platform-device leak in error path

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix NFSD's request deferral on RDMA transports

Oliver Upton <oupton@google.com>
    KVM: Don't create VM debugfs files outside of the VM directory

Sean Christopherson <seanjc@google.com>
    KVM: x86/mmu: Resolve nx_huge_pages when kvm.ko is loaded

Patrick Wang <patrick.wang.shcn@gmail.com>
    mm: kmemleak: take a full lowmem check in kmemleak_*_phys()

Minchan Kim <minchan@kernel.org>
    mm: fix unexpected zeroed page mapping with zram swap

Juergen Gross <jgross@suse.com>
    mm, page_alloc: fix build_zonerefs_node()

Axel Rasmussen <axelrasmussen@google.com>
    mm/secretmem: fix panic when growing a memfd_secret

Borislav Petkov <bp@suse.de>
    perf/imx_ddr: Fix undefined behavior due to shift overflowing the constant

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: use nospec annotation for more indexes

Pavel Begunkov <asml.silence@gmail.com>
    io_uring: zero tag on rsrc removal

Duoming Zhou <duoming@zju.edu.cn>
    drivers: net: slip: fix NPD bug in sl_tx_timeout()

Chandrakanth patil <chandrakanth.patil@broadcom.com>
    scsi: megaraid_sas: Target with invalid LUN ID is deleted during scan

Alexey Galakhov <agalakhov@gmail.com>
    scsi: mvsas: Add PCI ID of RocketRaid 2640

Sreekanth Reddy <sreekanth.reddy@broadcom.com>
    scsi: mpt3sas: Fail reset operation if config request timed out

Christoph Böhmwalder <christoph@boehmwalder.at>
    drbd: set QUEUE_FLAG_STABLE_WRITES

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Fix allocate_mst_payload assert on resume

Martin Leung <Martin.Leung@amd.com>
    drm/amd/display: Revert FEC check in validation

Roman Li <Roman.Li@amd.com>
    drm/amd/display: Enable power gating before init_pipes

Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
    spi: cadence-quadspi: fix protocol setup for non-1-1-X operations

Xiaomeng Tong <xiam0nd.tong@gmail.com>
    myri10ge: fix an incorrect free for skb in myri10ge_sw_tso

Marcin Kozlowski <marcinguy@gmail.com>
    net: usb: aqc111: Fix out-of-bounds accesses in RX fixup

Boqun Feng <boqun.feng@gmail.com>
    Drivers: hv: balloon: Disable balloon and hot-add accordingly

Andy Chiu <andy.chiu@sifive.com>
    net: axienet: setup mdio unconditionally

Steve Capper <steve.capper@arm.com>
    tlb: hugetlb: Add more sizes to tlb_remove_huge_tlb_entry

Joey Gouly <joey.gouly@arm.com>
    arm64: alternatives: mark patch_alternative() as `noinstr`

Jonathan Bakker <xc-racer2@live.ca>
    regulator: wm8994: Add an off-on delay for WM8994 variant

Leo Ruan <tingquan.ruan@cn.bosch.com>
    gpu: ipu-v3: Fix dev_dbg frequency output

Christian Lamparter <chunkeey@gmail.com>
    ata: libata-core: Disable READ LOG DMA EXT for Samsung 840 EVOs

Randy Dunlap <rdunlap@infradead.org>
    net: micrel: fix KS8851_MLL Kconfig

Tyrel Datwyler <tyreld@linux.ibm.com>
    scsi: ibmvscsis: Increase INITIAL_SRP_LIMIT to 1024

James Smart <jsmart2021@gmail.com>
    scsi: lpfc: Fix queue failures when recovering from PCI parity error

Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>
    scsi: target: tcmu: Fix possible page UAF

Michael Kelley <mikelley@microsoft.com>
    Drivers: hv: vmbus: Prevent load re-ordering when reading ring buffer

Michael Kelley <mikelley@microsoft.com>
    PCI: hv: Propagate coherence from VMbus device to PCI device

Andrea Parri (Microsoft) <parri.andrea@gmail.com>
    Drivers: hv: vmbus: Deactivate sysctl_record_panic_msg by default in isolated guests

QintaoShen <unSimple1993@163.com>
    drm/amdkfd: Check for potential null return of kmalloc_array()

Tianci Yin <tianci.yin@amd.com>
    drm/amdgpu/vcn: improve vcn dpg stop procedure

Tushar Patel <tushar.patel@amd.com>
    drm/amdkfd: Fix Incorrect VMIDs passed to HWS

Leo (Hanghong) Ma <hanghong.ma@amd.com>
    drm/amd/display: Update VTEM Infopacket definition

Chiawen Huang <chiawen.huang@amd.com>
    drm/amd/display: FEC check in timing validation

Charlene Liu <Charlene.Liu@amd.com>
    drm/amd/display: fix audio format not updated after edid updated

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/gmc: use PCI BARs for APUs in passthrough

Guchun Chen <guchun.chen@amd.com>
    drm/amdgpu: conduct a proper cleanup of PDB bo

Josef Bacik <josef@toxicpanda.com>
    btrfs: do not warn for free space inode in cow_file_range

Darrick J. Wong <djwong@kernel.org>
    btrfs: fix fallocate to use file_modified to update permissions consistently

Aurabindo Pillai <aurabindo.pillai@amd.com>
    drm/amd: Add USBC connector ID

Ming Lei <ming.lei@redhat.com>
    block: fix offset/size check in bio_trim()

Jeremy Linton <jeremy.linton@arm.com>
    net: bcmgenet: Revert "Use stronger register read/writes to assure ordering"

Jason Gunthorpe <jgg@ziepe.ca>
    vfio/pci: Fix vf_token mechanism when device-specific VF drivers are used

Khazhismel Kumykov <khazhy@google.com>
    dm mpath: only use ktime_get_ns() in historical selector

Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
    cifs: potential buffer overflow in handling symlinks

Lin Ma <linma@zju.edu.cn>
    nfc: nci: add flush_workqueue to prevent uaf

Dylan Hung <dylan_hung@aspeedtech.com>
    net: ftgmac100: access hardware register after clock ready

Martin Willi <martin@strongswan.org>
    macvlan: Fix leaking skb in source mode with nodst option

Adrian Hunter <adrian.hunter@intel.com>
    perf tools: Fix misleading add event PMU debug message

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Limit max buffer and period sizes per time

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Increase max buffer size

Athira Rajeev <atrajeev@linux.vnet.ibm.com>
    testing/selftests/mqueue: Fix mq_perf_tests to free the allocated cpu set

Dylan Yudaken <dylany@fb.com>
    io_uring: verify pad field is 0 in io_get_ext_arg

Dylan Yudaken <dylany@fb.com>
    io_uring: verify that resv2 is 0 in io_uring_rsrc_update2

Dylan Yudaken <dylany@fb.com>
    io_uring: move io_uring_rsrc_update2 validation

Takashi Iwai <tiwai@suse.de>
    ALSA: mtpav: Don't call card private_free at probe error path

Takashi Iwai <tiwai@suse.de>
    ALSA: ad1889: Fix the missing snd_card_free() call at probe error

Antoine Tenart <atenart@kernel.org>
    netfilter: nf_tables: nft_parse_register can return a negative value

Petr Malat <oss@malat.biz>
    sctp: Initialize daddr on peeled off socket

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix unbound endpoint error handling

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix conn cleanup and stop race during iscsid restart

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix endpoint reuse regression

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Fix offload conn cleanup when iscsid restarts

Mike Christie <michael.christie@oracle.com>
    scsi: iscsi: Move iscsi_ep_disconnect()

Ajish Koshy <Ajish.Koshy@microchip.com>
    scsi: pm80xx: Enable upper inbound, outbound queues

Ajish Koshy <Ajish.Koshy@microchip.com>
    scsi: pm80xx: Mask and unmask upper interrupt vectors 32-63

Karsten Graul <kgraul@linux.ibm.com>
    net/smc: Fix NULL pointer dereference in smc_pnet_find_ib()

Kuogee Hsieh <quic_khsieh@quicinc.com>
    drm/msm/dp: add fail safe mode outside of event_mutex context

Stephen Boyd <swboyd@chromium.org>
    drm/msm/dsi: Use connector directly in msm_dsi_manager_connector_init()

Rob Clark <robdclark@chromium.org>
    drm/msm: Fix range size vs end confusion

Florian Westphal <fw@strlen.de>
    netfilter: nft_socket: make cgroup match work in input too

Rameshkumar Sundaram <quic_ramess@quicinc.com>
    cfg80211: hold bss_lock while updating nontrans_list

Benedikt Spranger <b.spranger@linutronix.de>
    net/sched: taprio: Check if socket flags are valid

Dinh Nguyen <dinguyen@kernel.org>
    net: ethernet: stmmac: fix altr_tse_pcs function when using a fixed-link

Michael Walle <michael@walle.cc>
    net: dsa: felix: suppress -EPROBE_DEFER errors

Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
    net/sched: fix initialization order when updating chain 0 head

Vadim Pasternak <vadimp@nvidia.com>
    mlxsw: i2c: Fix initialization error flow

Vladimir Oltean <vladimir.oltean@nxp.com>
    net: mdio: don't defer probe forever if PHY IRQ provider is missing

Shyam Prasad N <sprasad@microsoft.com>
    cifs: release cached dentries only if mount is complete

Linus Torvalds <torvalds@linux-foundation.org>
    gpiolib: acpi: use correct format characters

Guillaume Nault <gnault@redhat.com>
    veth: Ensure eth header is in skb's linear part

Vlad Buslov <vladbu@nvidia.com>
    net/sched: flower: fix parsing of ethertype following VLAN header

Chuck Lever <chuck.lever@oracle.com>
    SUNRPC: Fix the svc_deferred_event trace class

Kyle Copperfield <kmcopper@danwin1210.me>
    media: rockchip/rga: do proper error checking in probe

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Fix sorting of retrieved clock rates

Anilkumar Kolli <quic_akolli@quicinc.com>
    Revert "ath11k: mesh: add support for 256 bitmap in blockack frames in 11ax"

Miaoqian Lin <linmq006@gmail.com>
    memory: atmel-ebi: Fix missing of_node_put in atmel_ebi_probe

Cristian Marussi <cristian.marussi@arm.com>
    firmware: arm_scmi: Remove clear channel call on the TX channel

Rob Clark <robdclark@chromium.org>
    drm/msm: Add missing put_task_struct() in debugfs path

Takashi Iwai <tiwai@suse.de>
    ALSA: nm256: Don't call card private_free at probe error path

Takashi Iwai <tiwai@suse.de>
    ALSA: usb-audio: Cap upper limits of buffer/period bytes for implicit fb

Takashi Iwai <tiwai@suse.de>
    ALSA: via82xx: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: sonicvibes: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: sc6000: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: rme96: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: rme9652: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: rme32: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: riptide: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: oxygen: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: maestro3: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: lx6464es: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: lola: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: korg1212: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: intel_hdmi: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: intel8x0: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: ice1724: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: hdspm: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: hdsp: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: galaxy: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: fm801: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: es1968: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: es1938: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: ens137x: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: emu10k1x: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: echoaudio: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: cs5535audio: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: cs4281: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: cmipci: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: ca0106: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: bt87x: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: azt3328: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: aw2: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: au88x0: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: atiixp: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: als4000: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: als300: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: ali5451: Fix the missing snd_card_free() call at probe error

Takashi Iwai <tiwai@suse.de>
    ALSA: sis7019: Fix the missing error handling

Takashi Iwai <tiwai@suse.de>
    ALSA: core: Add snd_card_free_on_error() helper

Naohiro Aota <naohiro.aota@wdc.com>
    btrfs: release correct delalloc amount in direct IO write path

Alex Elder <elder@linaro.org>
    net: ipa: request IPA register values be retained

Alex Elder <elder@linaro.org>
    dt-bindings: net: qcom,ipa: add optional qcom,qmp property

Deepak Kumar Singh <deesin@codeaurora.org>
    soc: qcom: aoss: Expose send for generic usecase

Nathan Chancellor <nathan@kernel.org>
    btrfs: remove unused variable in btrfs_{start,write}_dirty_block_groups()

Filipe Manana <fdmanana@suse.com>
    btrfs: remove no longer used counter when reading data page

Qu Wenruo <wqu@suse.com>
    btrfs: remove unused parameter nr_pages in add_ra_bio_pages()

Woody Suwalski <wsuwalski@gmail.com>
    ACPI: processor: idle: fix lockup regression on 32-bit ThinkPad T40

Richard Gong <richard.gong@amd.com>
    ACPI: processor idle: Allow playing dead in C3 state

Mario Limonciello <mario.limonciello@amd.com>
    ACPI: processor idle: Check for architectural support for LPI

Mario Limonciello <mario.limonciello@amd.com>
    cpuidle: PSCI: Move the `has_lpi` check to the beginning of the function

Lin Ma <linma@zju.edu.cn>
    hamradio: remove needs_free_netdev to avoid UAF

Lin Ma <linma@zju.edu.cn>
    hamradio: defer 6pack kfree after unregister_netdev

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Fix p-state allow debug index on dcn31

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Add pstate verification and recovery for DCN31


-------------

Diffstat:

 .../devicetree/bindings/net/qcom,ipa.yaml          |   6 +
 .../devicetree/bindings/net/snps,dwmac.yaml        |   6 +-
 Makefile                                           |   4 +-
 arch/arm/mach-davinci/board-da850-evm.c            |   4 +-
 arch/arm64/kernel/alternative.c                    |   6 +-
 arch/arm64/kernel/cpuidle.c                        |   6 +-
 arch/x86/include/asm/kvm_host.h                    |   5 +-
 arch/x86/include/asm/msr-index.h                   |   4 +-
 arch/x86/kernel/cpu/common.c                       |   2 +
 arch/x86/kernel/cpu/cpu.h                          |   5 +-
 arch/x86/kernel/cpu/intel.c                        |   7 -
 arch/x86/kernel/cpu/tsx.c                          | 104 +++++++++++--
 arch/x86/kvm/mmu/mmu.c                             |  20 ++-
 arch/x86/kvm/x86.c                                 |  20 ++-
 block/bio.c                                        |   2 +-
 drivers/acpi/processor_idle.c                      |  23 ++-
 drivers/ata/libata-core.c                          |   3 +
 drivers/base/dd.c                                  |   1 +
 drivers/block/drbd/drbd_main.c                     |   1 +
 drivers/cpufreq/intel_pstate.c                     |  10 ++
 drivers/firmware/arm_scmi/clock.c                  |   3 +-
 drivers/firmware/arm_scmi/driver.c                 |   3 +-
 drivers/gpio/gpiolib-acpi.c                        |   4 +-
 drivers/gpu/drm/amd/amdgpu/ObjectID.h              |   1 +
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c         |   4 +-
 drivers/gpu/drm/amd/amdgpu/amdgpu_drv.c            |   2 +-
 drivers/gpu/drm/amd/amdgpu/gfx_v9_0.c              |   2 +
 drivers/gpu/drm/amd/amdgpu/gmc_v10_0.c             |   2 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v7_0.c              |   5 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v8_0.c              |   2 +-
 drivers/gpu/drm/amd/amdgpu/gmc_v9_0.c              |   4 +-
 drivers/gpu/drm/amd/amdgpu/vcn_v3_0.c              |   3 +
 drivers/gpu/drm/amd/amdkfd/kfd_device.c            |  11 +-
 drivers/gpu/drm/amd/amdkfd/kfd_events.c            |   2 +
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  |   3 +-
 drivers/gpu/drm/amd/display/dc/core/dc_resource.c  |   4 +-
 .../gpu/drm/amd/display/dc/dcn10/dcn10_hubbub.c    |   1 +
 .../drm/amd/display/dc/dcn10/dcn10_hw_sequencer.c  |  29 ++--
 drivers/gpu/drm/amd/display/dc/dcn20/dcn20_hwseq.c |  14 +-
 .../gpu/drm/amd/display/dc/dcn30/dcn30_hubbub.c    |   1 +
 drivers/gpu/drm/amd/display/dc/dcn30/dcn30_hwseq.c |   5 +-
 .../gpu/drm/amd/display/dc/dcn301/dcn301_hubbub.c  |   1 +
 .../gpu/drm/amd/display/dc/dcn31/dcn31_hubbub.c    |  63 ++++++++
 drivers/gpu/drm/amd/display/dc/dcn31/dcn31_hwseq.c |   5 +-
 .../gpu/drm/amd/display/dc/dcn31/dcn31_resource.c  |   2 +-
 drivers/gpu/drm/amd/display/dc/inc/hw/dchubbub.h   |   2 +
 .../amd/display/modules/info_packet/info_packet.c  |   5 +-
 drivers/gpu/drm/i915/gem/i915_gem_mman.c           |   2 +-
 drivers/gpu/drm/msm/adreno/a6xx_gpu.c              |   2 +-
 drivers/gpu/drm/msm/dp/dp_display.c                |   6 +
 drivers/gpu/drm/msm/dp/dp_panel.c                  |  20 +--
 drivers/gpu/drm/msm/dp/dp_panel.h                  |   1 +
 drivers/gpu/drm/msm/dsi/dsi_manager.c              |   2 +-
 drivers/gpu/drm/msm/msm_gem.c                      |   1 +
 drivers/gpu/ipu-v3/ipu-di.c                        |   5 +-
 drivers/hv/hv_balloon.c                            |  36 ++++-
 drivers/hv/ring_buffer.c                           |  11 +-
 drivers/hv/vmbus_drv.c                             |  18 ++-
 drivers/i2c/busses/i2c-pasemi.c                    |   6 +
 drivers/i2c/i2c-dev.c                              |  15 +-
 drivers/md/dm-integrity.c                          |   7 +-
 drivers/md/dm-ps-historical-service-time.c         |  10 +-
 drivers/media/platform/rockchip/rga/rga.c          |   2 +-
 drivers/memory/atmel-ebi.c                         |  23 ++-
 drivers/memory/renesas-rpc-if.c                    |  10 +-
 drivers/net/dsa/ocelot/felix_vsc9959.c             |   2 +-
 drivers/net/ethernet/broadcom/genet/bcmgenet.c     |   4 +-
 drivers/net/ethernet/faraday/ftgmac100.c           |  10 +-
 drivers/net/ethernet/mellanox/mlxsw/i2c.c          |   1 +
 drivers/net/ethernet/micrel/Kconfig                |   1 +
 drivers/net/ethernet/myricom/myri10ge/myri10ge.c   |   6 +-
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.c |   8 -
 drivers/net/ethernet/stmicro/stmmac/altr_tse_pcs.h |   4 +
 .../net/ethernet/stmicro/stmmac/dwmac-socfpga.c    |  13 +-
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c  |  13 +-
 drivers/net/hamradio/6pack.c                       |   5 +-
 drivers/net/ipa/Kconfig                            |   1 +
 drivers/net/ipa/ipa_power.c                        |  52 +++++++
 drivers/net/ipa/ipa_power.h                        |   7 +
 drivers/net/ipa/ipa_uc.c                           |   5 +
 drivers/net/macvlan.c                              |   8 +-
 drivers/net/mdio/fwnode_mdio.c                     |   5 +
 drivers/net/slip/slip.c                            |   2 +-
 drivers/net/usb/aqc111.c                           |   9 +-
 drivers/net/veth.c                                 |   2 +-
 drivers/net/wireless/ath/ath11k/mac.c              |  21 ++-
 drivers/net/wireless/ath/ath9k/main.c              |   2 +-
 drivers/net/wireless/ath/ath9k/xmit.c              |  33 ++--
 drivers/pci/controller/pci-hyperv.c                |   9 ++
 drivers/perf/fsl_imx8_ddr_perf.c                   |   2 +-
 drivers/regulator/wm8994-regulator.c               |  42 +++++-
 drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c           |   2 +-
 drivers/scsi/lpfc/lpfc_init.c                      |   2 +
 drivers/scsi/megaraid/megaraid_sas.h               |   3 +
 drivers/scsi/megaraid/megaraid_sas_base.c          |   7 +
 drivers/scsi/mpt3sas/mpt3sas_config.c              |   9 +-
 drivers/scsi/mvsas/mv_init.c                       |   1 +
 drivers/scsi/pm8001/pm80xx_hwi.c                   |  33 ++--
 drivers/scsi/scsi_transport_iscsi.c                | 168 +++++++++++++--------
 drivers/soc/qcom/qcom_aoss.c                       |  58 ++++++-
 drivers/spi/spi-cadence-quadspi.c                  |  46 ++----
 drivers/target/target_core_user.c                  |   3 +-
 drivers/vfio/pci/vfio_pci_core.c                   | 124 +++++++++------
 fs/btrfs/block-group.c                             |   4 -
 fs/btrfs/compression.c                             |   2 -
 fs/btrfs/disk-io.c                                 |   5 +-
 fs/btrfs/extent_io.c                               |   5 +-
 fs/btrfs/file.c                                    |  13 +-
 fs/btrfs/inode.c                                   |   7 +-
 fs/btrfs/volumes.c                                 |   2 +
 fs/cifs/cifsfs.c                                   |  28 ++--
 fs/cifs/link.c                                     |   3 +
 fs/io_uring.c                                      |  24 +--
 include/asm-generic/tlb.h                          |  10 +-
 include/linux/soc/qcom/qcom_aoss.h                 |  38 +++++
 include/linux/sunrpc/svc.h                         |   1 +
 include/linux/vfio_pci_core.h                      |   2 +
 include/net/ax25.h                                 |  12 ++
 include/net/flow_dissector.h                       |   2 +
 include/scsi/scsi_transport_iscsi.h                |   2 +
 include/sound/core.h                               |   1 +
 include/trace/events/sunrpc.h                      |   7 +-
 kernel/cpu.c                                       |  36 ++---
 kernel/dma/direct.h                                |   3 +-
 kernel/irq/affinity.c                              |   5 +-
 kernel/smp.c                                       |   2 +-
 kernel/time/tick-sched.c                           |   2 +-
 kernel/time/timer.c                                |  11 +-
 mm/kmemleak.c                                      |   8 +-
 mm/page_alloc.c                                    |   2 +-
 mm/page_io.c                                       |  54 -------
 mm/secretmem.c                                     |  17 +++
 net/ax25/af_ax25.c                                 |  38 ++++-
 net/ax25/ax25_dev.c                                |  28 +++-
 net/ax25/ax25_route.c                              |  13 +-
 net/ax25/ax25_subr.c                               |  20 ++-
 net/core/flow_dissector.c                          |   1 +
 net/ipv6/ip6_output.c                              |   2 +-
 net/netfilter/nf_tables_api.c                      |   2 +-
 net/netfilter/nft_socket.c                         |   7 +-
 net/nfc/nci/core.c                                 |   4 +
 net/sched/cls_api.c                                |   2 +-
 net/sched/cls_flower.c                             |  18 ++-
 net/sched/sch_taprio.c                             |   3 +-
 net/sctp/socket.c                                  |   2 +-
 net/smc/smc_pnet.c                                 |   5 +-
 net/sunrpc/svc_xprt.c                              |   3 +
 net/sunrpc/xprtrdma/svc_rdma_recvfrom.c            |   2 +-
 net/wireless/nl80211.c                             |   3 +-
 net/wireless/scan.c                                |   2 +
 scripts/gcc-plugins/latent_entropy_plugin.c        |  44 +++---
 sound/core/init.c                                  |  28 ++++
 sound/core/pcm_misc.c                              |   2 +-
 sound/drivers/mtpav.c                              |   4 +-
 sound/isa/galaxy/galaxy.c                          |   7 +-
 sound/isa/sc6000.c                                 |   7 +-
 sound/pci/ad1889.c                                 |  10 +-
 sound/pci/ali5451/ali5451.c                        |  10 +-
 sound/pci/als300.c                                 |   8 +-
 sound/pci/als4000.c                                |  10 +-
 sound/pci/atiixp.c                                 |  10 +-
 sound/pci/atiixp_modem.c                           |  10 +-
 sound/pci/au88x0/au88x0.c                          |   8 +-
 sound/pci/aw2/aw2-alsa.c                           |   8 +-
 sound/pci/azt3328.c                                |   8 +-
 sound/pci/bt87x.c                                  |  10 +-
 sound/pci/ca0106/ca0106_main.c                     |  10 +-
 sound/pci/cmipci.c                                 |   8 +-
 sound/pci/cs4281.c                                 |  10 +-
 sound/pci/cs5535audio/cs5535audio.c                |  10 +-
 sound/pci/echoaudio/echoaudio.c                    |   9 +-
 sound/pci/emu10k1/emu10k1x.c                       |  10 +-
 sound/pci/ens1370.c                                |  10 +-
 sound/pci/es1938.c                                 |  10 +-
 sound/pci/es1968.c                                 |  10 +-
 sound/pci/fm801.c                                  |  10 +-
 sound/pci/hda/patch_realtek.c                      |   2 +
 sound/pci/ice1712/ice1724.c                        |  10 +-
 sound/pci/intel8x0.c                               |  10 +-
 sound/pci/intel8x0m.c                              |  10 +-
 sound/pci/korg1212/korg1212.c                      |   8 +-
 sound/pci/lola/lola.c                              |  10 +-
 sound/pci/lx6464es/lx6464es.c                      |   8 +-
 sound/pci/maestro3.c                               |   8 +-
 sound/pci/nm256/nm256.c                            |   2 +-
 sound/pci/oxygen/oxygen_lib.c                      |  12 +-
 sound/pci/riptide/riptide.c                        |   8 +-
 sound/pci/rme32.c                                  |   8 +-
 sound/pci/rme96.c                                  |  10 +-
 sound/pci/rme9652/hdsp.c                           |   8 +-
 sound/pci/rme9652/hdspm.c                          |   8 +-
 sound/pci/rme9652/rme9652.c                        |   8 +-
 sound/pci/sis7019.c                                |  14 +-
 sound/pci/sonicvibes.c                             |  10 +-
 sound/pci/via82xx.c                                |  10 +-
 sound/pci/via82xx_modem.c                          |  10 +-
 sound/usb/pcm.c                                    |  16 +-
 sound/x86/intel_hdmi_audio.c                       |   7 +-
 tools/arch/x86/include/asm/msr-index.h             |   4 +-
 tools/perf/util/parse-events.c                     |   5 +-
 tools/testing/selftests/mqueue/mq_perf_tests.c     |  25 ++-
 virt/kvm/kvm_main.c                                |  10 +-
 202 files changed, 1653 insertions(+), 654 deletions(-)


