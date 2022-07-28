Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 755AD58400B
	for <lists+stable@lfdr.de>; Thu, 28 Jul 2022 15:34:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230290AbiG1Nd7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 09:33:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiG1Nd5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 09:33:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 053C3558DD;
        Thu, 28 Jul 2022 06:33:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5AE5261D40;
        Thu, 28 Jul 2022 13:33:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B4BC433D7;
        Thu, 28 Jul 2022 13:33:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659015233;
        bh=ak2eC00hCwPn0uHOXCvhONbbdp5yXxQ30OhI98tc8H4=;
        h=From:To:Cc:Subject:Date:From;
        b=QX3cIE2UarjCZImeK5GLPNZHosIHWLaxBkBJ22hd7pJEsis4FqcKVhVXLw2P2Ru3F
         oKOl8zFUdV7Anl3v0la19G5E/kWRoJP0G+3WmO6iZeiLInsjLoHTobtQP/fKTfhTaT
         HeMewwiMFIw+JKBSBzFiEo9v82b1KodFFVcynMFs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
Subject: [PATCH 5.15 000/202] 5.15.58-rc2 review
Date:   Thu, 28 Jul 2022 15:33:50 +0200
Message-Id: <20220728133327.660846209@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
MIME-Version: 1.0
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.58-rc2.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.15.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.15.58-rc2
X-KernelTest-Deadline: 2022-07-30T13:33+00:00
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is the start of the stable review cycle for the 5.15.58 release.
There are 202 patches in this series, all will be posted as a response
to this one.  If anyone has any issues with these being applied, please
let me know.

Responses should be made by Sat, 30 Jul 2022 13:32:45 +0000.
Anything received after that time might be too late.

The whole patch series can be found in one patch at:
	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.58-rc2.gz
or in the git tree and branch at:
	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
and the diffstat can be found below.

thanks,

greg k-h

-------------
Pseudo-Shortlog of commits:

Greg Kroah-Hartman <gregkh@linuxfoundation.org>
    Linux 5.15.58-rc2

Hayden Goodfellow <Hayden.Goodfellow@amd.com>
    drm/amd/display: Fix wrong format specifier in amdgpu_dm.c

Peter Zijlstra <peterz@infradead.org>
    x86/entry_32: Fix segment exceptions

Dan Carpenter <dan.carpenter@oracle.com>
    drm/amdgpu: Off by one in dm_dmub_outbox1_low_irq()

Jan Beulich <jbeulich@suse.com>
    x86: drop bogus "cc" clobber from __try_cmpxchg_user_asm()

Maxim Levitsky <mlevitsk@redhat.com>
    KVM: x86: fix typo in __try_cmpxchg_user causing non-atomicness

Nick Desaulniers <ndesaulniers@google.com>
    x86/extable: Prefer local labels in .set directives

José Expósito <jose.exposito89@gmail.com>
    drm/amd/display: invalid parameter check in dmub_hpd_callback

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Don't lock connection_mutex for DMUB HPD

Linus Torvalds <torvalds@linux-foundation.org>
    watch-queue: remove spurious double semicolon

Jose Alonso <joalonsof@gmail.com>
    net: usb: ax88179_178a needs FLAG_SEND_ZLP

Jiri Slaby <jirislaby@kernel.org>
    tty: use new tty_insert_flip_string_and_push_buffer() in pty_write()

Jiri Slaby <jirislaby@kernel.org>
    tty: extract tty_flip_buffer_commit() from tty_flip_buffer_push()

Jiri Slaby <jirislaby@kernel.org>
    tty: drop tty_schedule_flip()

Jiri Slaby <jirislaby@kernel.org>
    tty: the rest, stop using tty_schedule_flip()

Jiri Slaby <jirislaby@kernel.org>
    tty: drivers/tty/, stop using tty_schedule_flip()

Linus Torvalds <torvalds@linux-foundation.org>
    watchqueue: make sure to serialize 'wqueue->defunct' properly

Kees Cook <keescook@chromium.org>
    x86/alternative: Report missing return thunk details

Peter Zijlstra <peterz@infradead.org>
    x86/amd: Use IBPB for firmware calls

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Fix surface optimization regression on Carrizo

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Optimize bandwidth on following fast update

Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
    drm/amd/display: Reset DMCUB before HW init

Sungjong Seo <sj1557.seo@samsung.com>
    exfat: use updated exfat_chain directly during renaming

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix bt_skb_sendmmsg not allocating partial chunks

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SCO: Fix sco_send_frame returning skb->len

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Fix passing NULL to PTR_ERR

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: RFCOMM: Replace use of memcpy_from_msg with bt_skb_sendmmsg

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: SCO: Replace use of memcpy_from_msg with bt_skb_sendmsg

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Add bt_skb_sendmmsg helper

Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
    Bluetooth: Add bt_skb_sendmsg helper

Johannes Berg <johannes.berg@intel.com>
    um: virtio_uml: Fix broken device handling in time-travel

Vincent Whitchurch <vincent.whitchurch@axis.com>
    um: virtio_uml: Allow probing from devicetree

Wonhyuk Yang <vvghjk1234@gmail.com>
    tracing: Fix return value of trace_pid_write()

Steven Rostedt (VMware) <rostedt@goodmis.org>
    tracing: Place trace_pid_list logic into abstract functions

Steven Rostedt (Google) <rostedt@goodmis.org>
    tracing: Have event format check not flag %p* on __get_dynamic_array()

Yuezhang Mo <Yuezhang.Mo@sony.com>
    exfat: fix referencing wrong parent directory information after renaming

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - re-enable registration of algorithms

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - add param check for DH

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - add param check for RSA

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - remove dma_free_coherent() for DH

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - remove dma_free_coherent() for RSA

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - fix memory leak in RSA

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - add backlog mechanism

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - refactor submission logic

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - use pre-allocated buffers in datapath

Giovanni Cabiddu <giovanni.cabiddu@intel.com>
    crypto: qat - set to zero DH parameters before free

Johannes Berg <johannes.berg@intel.com>
    iwlwifi: fw: uefi: add missing include guards

Felix Fietkau <nbd@nbd.name>
    mt76: fix use-after-free by removing a non-RCU wcid pointer

Kishon Vijay Abraham I <kishon@ti.com>
    xhci: Set HCD flag to defer primary roothub registration

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: Rename xhci_dbc_init and xhci_dbc_exit

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: create and remove dbc structure in dbgtty driver.

Mathias Nyman <mathias.nyman@linux.intel.com>
    xhci: dbc: refactor xhci_dbc_init()

Sean Christopherson <seanjc@google.com>
    KVM: x86: Use __try_cmpxchg_user() to emulate atomic accesses

Peter Zijlstra <peterz@infradead.org>
    x86/futex: Remove .fixup usage

Peter Zijlstra <peterz@infradead.org>
    x86/msr: Remove .fixup usage

Peter Zijlstra <peterz@infradead.org>
    x86/extable: Extend extable functionality

Peter Zijlstra <peterz@infradead.org>
    x86/entry_32: Remove .fixup usage

Peter Zijlstra <peterz@infradead.org>
    bitfield.h: Fix "type of reg too small for mask" test

Thomas Gleixner <tglx@linutronix.de>
    x86/extable: Provide EX_TYPE_DEFAULT_MCE_SAFE and EX_TYPE_FAULT_MCE_SAFE

Thomas Gleixner <tglx@linutronix.de>
    x86/extable: Rework the exception table mechanics

Thomas Gleixner <tglx@linutronix.de>
    x86/mce: Deduplicate exception handling

Thomas Gleixner <tglx@linutronix.de>
    x86/extable: Get rid of redundant macros

Thomas Gleixner <tglx@linutronix.de>
    x86/extable: Tidy up redundant handler functions

Peter Zijlstra <peterz@infradead.org>
    x86/uaccess: Implement macros for CMPXCHG on user addresses

Alexander Aring <aahringo@redhat.com>
    dlm: fix pending remove if msg allocation fails

Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
    x86/bugs: Warn when "ibrs" mitigation is selected on Enhanced IBRS parts

Juri Lelli <juri.lelli@redhat.com>
    sched/deadline: Fix BUG_ON condition for deboosted tasks

Eric Dumazet <edumazet@google.com>
    bpf: Make sure mac_header was set before using it

Wang Cheng <wanngchenng@gmail.com>
    mm/mempolicy: fix uninit-value in mpol_rebind_policy()

Alexey Kardashevskiy <aik@ozlabs.ru>
    KVM: Don't null dereference ops->destroy

Marc Kleine-Budde <mkl@pengutronix.de>
    spi: bcm2835: bcm2835_spi_handle_err(): fix NULL pointer deref for non DMA transfers

Gavin Shan <gshan@redhat.com>
    KVM: selftests: Fix target thread to be migrated in rseq_test

Srinivas Neeli <srinivas.neeli@xilinx.com>
    gpio: gpio-xilinx: Fix integer overflow

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_max_reordering.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_abort_on_overflow.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_rfc1337.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_stdurg.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_retrans_collapse.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_slow_start_after_idle.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_thin_linear_timeouts.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_recovery.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_early_retrans.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl knobs related to SYN option.

Kuniyuki Iwashima <kuniyu@amazon.com>
    udp: Fix a data-race around sysctl_udp_l3mdev_accept.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_prot_sock.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: Fix data-races around sysctl_fib_multipath_hash_fields.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: Fix data-races around sysctl_fib_multipath_hash_policy.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ipv4: Fix a data-race around sysctl_fib_multipath_use_neigh.

Liang He <windhl@126.com>
    drm/imx/dcss: Add missing of_node_put() in fail path

Oleksij Rempel <linux@rempel-privat.de>
    net: dsa: vitesse-vsc73xx: silent spi_device_id warnings

Oleksij Rempel <linux@rempel-privat.de>
    net: dsa: sja1105: silent spi_device_id warnings

Hristo Venev <hristo@venev.name>
    be2net: Fix buffer overflow in be_get_module_eeprom

Haibo Chen <haibo.chen@nxp.com>
    gpio: pca953x: use the correct register address when regcache sync during init

Haibo Chen <haibo.chen@nxp.com>
    gpio: pca953x: use the correct range when do regmap sync

Haibo Chen <haibo.chen@nxp.com>
    gpio: pca953x: only use single read/write for No AI mode

Wong Vee Khee <vee.khee.wong@linux.intel.com>
    net: stmmac: remove redunctant disable xPCS EEE call

Piotr Skajewski <piotrx.skajewski@intel.com>
    ixgbe: Add locking to prevent panic when setting sriov_numvfs to zero

Dawid Lukwinski <dawid.lukwinski@intel.com>
    i40e: Fix erroneous adapter reinitialization during recovery process

Vladimir Oltean <vladimir.oltean@nxp.com>
    pinctrl: armada-37xx: use raw spinlocks for regmap to avoid invalid wait context

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: armada-37xx: Convert to use dev_err_probe()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: armada-37xx: Make use of the devm_platform_ioremap_resource()

Andy Shevchenko <andriy.shevchenko@linux.intel.com>
    pinctrl: armada-37xx: Use temporary variable for struct device

Przemyslaw Patynowski <przemyslawx.patynowski@intel.com>
    iavf: Fix handling of dummy receive descriptors

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_fastopen_blackhole_timeout.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_fastopen.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_max_syn_backlog.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_tw_reuse.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_notsent_lowat.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around some timeout sysctl knobs.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_reordering.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_migrate_req.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_syncookies.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_syn(ack)?_retries.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around keepalive sysctl knobs.

Kuniyuki Iwashima <kuniyu@amazon.com>
    igmp: Fix data-races around sysctl_igmp_max_msf.

Kuniyuki Iwashima <kuniyu@amazon.com>
    igmp: Fix a data-race around sysctl_igmp_max_memberships.

Kuniyuki Iwashima <kuniyu@amazon.com>
    igmp: Fix data-races around sysctl_igmp_llm_reports.

Tariq Toukan <tariqt@nvidia.com>
    net/tls: Fix race in TLS device down flow

Junxiao Chang <junxiao.chang@intel.com>
    net: stmmac: fix dma queue left shift overflow issue

Adrian Hunter <adrian.hunter@intel.com>
    perf tests: Fix Convert perf time to TSC test for hybrid

Robert Hancock <robert.hancock@calian.com>
    i2c: cadence: Change large transfer count reset logic to be unconditional

Vadim Pasternak <vadimp@nvidia.com>
    i2c: mlxcpld: Fix register setting for 400KHz frequency

Menglong Dong <imagedong@tencent.com>
    net: ipv4: use kfree_skb_reason() in ip_rcv_finish_core()

Menglong Dong <imagedong@tencent.com>
    net: ipv4: use kfree_skb_reason() in ip_rcv_core()

Menglong Dong <imagedong@tencent.com>
    net: netfilter: use kfree_drop_reason() for NF_DROP

Menglong Dong <imagedong@tencent.com>
    net: skb_drop_reason: add document for drop reasons

Menglong Dong <imagedong@tencent.com>
    net: socket: rename SKB_DROP_REASON_SOCKET_FILTER

Menglong Dong <imagedong@tencent.com>
    net: skb: use kfree_skb_reason() in __udp4_lib_rcv()

Menglong Dong <imagedong@tencent.com>
    net: skb: use kfree_skb_reason() in tcp_v4_rcv()

Menglong Dong <imagedong@tencent.com>
    net: skb: introduce kfree_skb_reason()

Liang He <windhl@126.com>
    net: dsa: microchip: ksz_common: Fix refcount leak bug

Sascha Hauer <s.hauer@pengutronix.de>
    mtd: rawnand: gpmi: Set WAIT_FOR_READY timeout based on program/erase times

Dario Binacchi <dario.binacchi@amarulasolutions.com>
    mtd: rawnand: gpmi: validate controller clock rate

Biao Huang <biao.huang@mediatek.com>
    net: stmmac: fix unbalanced ptp clock issue in suspend/resume flow

Biao Huang <biao.huang@mediatek.com>
    net: stmmac: fix pm runtime issue in stmmac_dvr_remove()

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_probe_interval.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_probe_threshold.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix a data-race around sysctl_tcp_mtu_probe_floor.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_min_snd_mss.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_base_mss.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_mtu_probing.

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_l3mdev_accept.

Eric Dumazet <edumazet@google.com>
    tcp: sk->sk_bound_dev_if once in inet_request_bound_dev_if()

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp/dccp: Fix a data-race around sysctl_tcp_fwmark_accept.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix a data-race around sysctl_fwmark_reflect.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix a data-race around sysctl_ip_autobind_reuse.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_nonlocal_bind.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_fwd_update_priority.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_fwd_use_pmtu.

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_no_pmtu_disc.

Lennert Buytenhek <buytenh@wantstofly.org>
    igc: Reinstate IGC_REMOVED logic and implement it properly

Sasha Neftin <sasha.neftin@intel.com>
    Revert "e1000e: Fix possible HW unit hang after an s0ix exit"

Sasha Neftin <sasha.neftin@intel.com>
    e1000e: Enable GPT clock before sending message to CSME

Israel Rukshin <israelr@nvidia.com>
    nvme: fix block device naming collision

Christoph Hellwig <hch@lst.de>
    nvme: check for duplicate identifiers earlier

Bjorn Andersson <bjorn.andersson@linaro.org>
    scsi: ufs: core: Drop loglevel of WriteBoost message

Ming Lei <ming.lei@redhat.com>
    scsi: megaraid: Clear READ queue map's nr_queues

Fangzhi Zuo <Jerry.Zuo@amd.com>
    drm/amd/display: Ignore First MST Sideband Message Return Error

Alex Deucher <alexander.deucher@amd.com>
    drm/amdgpu/display: add quirk handling for stutter mode

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Fork thread to offload work of hpd_rx_irq

Wayne Lin <Wayne.Lin@amd.com>
    drm/amd/display: Add option to defer works of hpd_rx_irq

Jude Shih <shenshih@amd.com>
    drm/amd/display: Support for DMUB HPD interrupt handling

Kuniyuki Iwashima <kuniyu@amazon.com>
    tcp: Fix data-races around sysctl_tcp_ecn.

Xiaoming Ni <nixiaoming@huawei.com>
    sysctl: move some boundary constants from sysctl.c to sysctl_vals

Suren Baghdasaryan <surenb@google.com>
    mm/pagealloc: sysctl: change watermark_scale_factor max limit to 30%

Dongli Zhang <dongli.zhang@oracle.com>
    net: tun: split run_ebpf_filter() and pskb_trim() into different "if statement"

Eric Dumazet <edumazet@google.com>
    ipv4/tcp: do not use per netns ctl sockets

Peter Zijlstra <peterz@infradead.org>
    perf/core: Fix data race between perf_event_set_output() and perf_mmap_close()

William Dean <williamsukatube@gmail.com>
    pinctrl: ralink: Check for null return of devm_kcalloc

Arınç ÜNAL <arinc.unal@arinc9.com>
    pinctrl: ralink: rename pinctrl-rt2880 to pinctrl-ralink

Arınç ÜNAL <arinc.unal@arinc9.com>
    pinctrl: ralink: rename MT7628(an) functions to MT76X8

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Fix sleep from invalid context BUG

Mustafa Ismail <mustafa.ismail@intel.com>
    RDMA/irdma: Do not advertise 1GB page size for x722

Miaoqian Lin <linmq006@gmail.com>
    power/reset: arm-versatile: Fix refcount leak in versatile_reboot_probe

Hangyu Hua <hbh25y@gmail.com>
    xfrm: xfrm_policy: fix a possible double xfrm_pols_put() in xfrm_bundle_lookup()

Kuniyuki Iwashima <kuniyu@amazon.com>
    ip: Fix data-races around sysctl_ip_default_ttl.

Hayes Wang <hayeswang@realtek.com>
    r8152: fix a WOL issue

Dan Carpenter <dan.carpenter@oracle.com>
    xfs: prevent a WARN_ONCE() in xfs_ioc_attr_list()

Brian Foster <bfoster@redhat.com>
    xfs: fix perag reference leak on iteration race with growfs

Brian Foster <bfoster@redhat.com>
    xfs: terminate perag iteration reliably on agcount

Brian Foster <bfoster@redhat.com>
    xfs: rename the next_agno perag iteration variable

Brian Foster <bfoster@redhat.com>
    xfs: fold perag loop iteration logic into helper function

Darrick J. Wong <djwong@kernel.org>
    xfs: fix maxlevels comparisons in the btree staging code

Christophe JAILLET <christophe.jaillet@wanadoo.fr>
    mt76: mt7921: Fix the error handling path of mt7921_pci_probe()

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921e: fix possible probe failure after reboot

Sean Wang <sean.wang@mediatek.com>
    mt76: mt7921: use physical addr to unify register access

Sean Wang <sean.wang@mediatek.com>
    Revert "mt76: mt7921e: fix possible probe failure after reboot"

Sean Wang <sean.wang@mediatek.com>
    Revert "mt76: mt7921: Fix the error handling path of mt7921_pci_probe()"

Sebastian Andrzej Siewior <bigeasy@linutronix.de>
    batman-adv: Use netif_rx_any_context() any.

Pali Rohár <pali@kernel.org>
    serial: mvebu-uart: correctly report configured baudrate value

Jeffrey Hugo <quic_jhugo@quicinc.com>
    PCI: hv: Fix interrupt mapping for multi-MSI

Jeffrey Hugo <quic_jhugo@quicinc.com>
    PCI: hv: Reuse existing IRTE allocation in compose_msi_msg()

Jeffrey Hugo <quic_jhugo@quicinc.com>
    PCI: hv: Fix hv_arch_irq_unmask() for multi-MSI

Jeffrey Hugo <quic_jhugo@quicinc.com>
    PCI: hv: Fix multi-MSI to allow more than one MSI vector

Oleksandr Tymoshenko <ovt@google.com>
    Revert "selftest/vm: verify mmap addr in mremap_test"

Oleksandr Tymoshenko <ovt@google.com>
    Revert "selftest/vm: verify remap destination address in mremap_test"

Daniele Palmas <dnlplm@gmail.com>
    bus: mhi: host: pci_generic: add Telit FN990

Daniele Palmas <dnlplm@gmail.com>
    bus: mhi: host: pci_generic: add Telit FN980 v1 hardware revision

Christian König <christian.koenig@amd.com>
    drm/ttm: fix locking in vmap/vunmap TTM GEM helpers

Eric Snowberg <eric.snowberg@oracle.com>
    lockdown: Fix kexec lockdown bypass with ima policy

Ido Schimmel <idosch@nvidia.com>
    mlxsw: spectrum_router: Fix IPv4 nexthop gateway indication

Ben Dooks <ben.dooks@codethink.co.uk>
    riscv: add as-options for modules with assembly compontents

Fabien Dessenne <fabien.dessenne@foss.st.com>
    pinctrl: stm32: fix optional IRQ support to gpios


-------------

Diffstat:

 Documentation/admin-guide/sysctl/vm.rst            |   2 +-
 Makefile                                           |   4 +-
 arch/alpha/kernel/srmcons.c                        |   2 +-
 arch/riscv/Makefile                                |   1 +
 arch/um/drivers/virtio_uml.c                       |  81 +++-
 arch/x86/entry/entry_32.S                          |  35 +-
 arch/x86/include/asm/asm.h                         |  85 ++--
 arch/x86/include/asm/cpufeatures.h                 |   1 +
 arch/x86/include/asm/extable.h                     |  44 +-
 arch/x86/include/asm/extable_fixup_types.h         |  58 +++
 arch/x86/include/asm/fpu/internal.h                |   4 +-
 arch/x86/include/asm/futex.h                       |  28 +-
 arch/x86/include/asm/insn-eval.h                   |   2 +
 arch/x86/include/asm/mshyperv.h                    |   7 -
 arch/x86/include/asm/msr.h                         |  30 +-
 arch/x86/include/asm/nospec-branch.h               |   2 +
 arch/x86/include/asm/segment.h                     |   2 +-
 arch/x86/include/asm/uaccess.h                     | 142 +++++++
 arch/x86/kernel/alternative.c                      |   4 +-
 arch/x86/kernel/cpu/bugs.c                         |  14 +-
 arch/x86/kernel/cpu/mce/core.c                     |  40 +-
 arch/x86/kernel/cpu/mce/internal.h                 |  10 -
 arch/x86/kernel/cpu/mce/severity.c                 |  23 +-
 arch/x86/kvm/x86.c                                 |  35 +-
 arch/x86/lib/insn-eval.c                           |  71 ++--
 arch/x86/mm/extable.c                              | 193 +++++----
 arch/x86/net/bpf_jit_comp.c                        |  11 +-
 drivers/accessibility/speakup/spk_ttyio.c          |   4 +-
 drivers/bus/mhi/pci_generic.c                      |  79 ++++
 drivers/crypto/qat/qat_4xxx/adf_drv.c              |   7 -
 drivers/crypto/qat/qat_common/Makefile             |   1 +
 drivers/crypto/qat/qat_common/adf_transport.c      |  11 +
 drivers/crypto/qat/qat_common/adf_transport.h      |   1 +
 .../crypto/qat/qat_common/adf_transport_internal.h |   1 +
 drivers/crypto/qat/qat_common/qat_algs.c           | 138 ++++---
 drivers/crypto/qat/qat_common/qat_algs_send.c      |  86 ++++
 drivers/crypto/qat/qat_common/qat_algs_send.h      |  11 +
 drivers/crypto/qat/qat_common/qat_asym_algs.c      | 304 +++++++-------
 drivers/crypto/qat/qat_common/qat_crypto.c         |  10 +-
 drivers/crypto/qat/qat_common/qat_crypto.h         |  39 ++
 drivers/gpio/gpio-pca953x.c                        |  22 +-
 drivers/gpio/gpio-xilinx.c                         |   2 +-
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c  | 446 +++++++++++++++++++--
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.h  |  97 ++++-
 .../amd/display/amdgpu_dm/amdgpu_dm_mst_types.c    |  17 +
 drivers/gpu/drm/amd/display/dc/core/dc.c           |  24 +-
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c   |  89 ++--
 drivers/gpu/drm/amd/display/dc/dc_link.h           |   9 +-
 drivers/gpu/drm/drm_gem_ttm_helper.c               |   9 +-
 drivers/gpu/drm/imx/dcss/dcss-dev.c                |   3 +
 drivers/i2c/busses/i2c-cadence.c                   |  30 +-
 drivers/i2c/busses/i2c-mlxcpld.c                   |   2 +-
 drivers/infiniband/hw/irdma/cm.c                   |  50 ---
 drivers/infiniband/hw/irdma/i40iw_hw.c             |   1 +
 drivers/infiniband/hw/irdma/icrdma_hw.c            |   1 +
 drivers/infiniband/hw/irdma/irdma.h                |   1 +
 drivers/infiniband/hw/irdma/verbs.c                |   4 +-
 drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c         |  28 +-
 drivers/net/dsa/microchip/ksz_common.c             |   5 +-
 drivers/net/dsa/sja1105/sja1105_main.c             |  16 +
 drivers/net/dsa/vitesse-vsc73xx-spi.c              |  10 +
 .../chelsio/inline_crypto/chtls/chtls_cm.c         |   8 +-
 drivers/net/ethernet/emulex/benet/be_cmds.c        |  10 +-
 drivers/net/ethernet/emulex/benet/be_cmds.h        |   2 +-
 drivers/net/ethernet/emulex/benet/be_ethtool.c     |  31 +-
 drivers/net/ethernet/intel/e1000e/hw.h             |   1 -
 drivers/net/ethernet/intel/e1000e/ich8lan.c        |   4 -
 drivers/net/ethernet/intel/e1000e/ich8lan.h        |   1 -
 drivers/net/ethernet/intel/e1000e/netdev.c         |  30 +-
 drivers/net/ethernet/intel/i40e/i40e_main.c        |  13 +-
 drivers/net/ethernet/intel/iavf/iavf_txrx.c        |   5 +-
 drivers/net/ethernet/intel/igc/igc_main.c          |   3 +
 drivers/net/ethernet/intel/igc/igc_regs.h          |   5 +-
 drivers/net/ethernet/intel/ixgbe/ixgbe.h           |   1 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_main.c      |   3 +
 drivers/net/ethernet/intel/ixgbe/ixgbe_sriov.c     |   6 +
 .../net/ethernet/mellanox/mlxsw/spectrum_router.c  |   9 +-
 drivers/net/ethernet/netronome/nfp/flower/action.c |   2 +-
 drivers/net/ethernet/stmicro/stmmac/dwmac4_core.c  |   3 +
 .../net/ethernet/stmicro/stmmac/stmmac_ethtool.c   |   8 -
 drivers/net/ethernet/stmicro/stmmac/stmmac_main.c  |  22 +-
 .../net/ethernet/stmicro/stmmac/stmmac_platform.c  |   8 +-
 drivers/net/tun.c                                  |   5 +-
 drivers/net/usb/ax88179_178a.c                     |  20 +-
 drivers/net/usb/r8152.c                            |  16 +-
 drivers/net/wireless/intel/iwlwifi/fw/uefi.h       |   5 +-
 drivers/net/wireless/mediatek/mt76/mac80211.c      |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76.h          |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7603/main.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7615/main.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt76x02_util.c  |   4 +-
 drivers/net/wireless/mediatek/mt76/mt7915/main.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/main.c   |   2 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mcu.c    |  30 +-
 drivers/net/wireless/mediatek/mt76/mt7921/mt7921.h |   1 +
 drivers/net/wireless/mediatek/mt76/mt7921/pci.c    |  30 +-
 drivers/net/wireless/mediatek/mt76/mt7921/regs.h   |  22 +-
 drivers/net/wireless/mediatek/mt76/tx.c            |   9 +-
 drivers/nvme/host/core.c                           |  19 +-
 drivers/pci/controller/pci-hyperv.c                | 106 ++++-
 drivers/pinctrl/mvebu/pinctrl-armada-37xx.c        |  97 +++--
 drivers/pinctrl/ralink/Kconfig                     |  16 +-
 drivers/pinctrl/ralink/Makefile                    |   2 +-
 drivers/pinctrl/ralink/pinctrl-mt7620.c            | 252 ++++++------
 drivers/pinctrl/ralink/pinctrl-mt7621.c            |  30 +-
 .../ralink/{pinctrl-rt2880.c => pinctrl-ralink.c}  |  92 ++---
 .../pinctrl/ralink/{pinmux.h => pinctrl-ralink.h}  |  16 +-
 drivers/pinctrl/ralink/pinctrl-rt288x.c            |  20 +-
 drivers/pinctrl/ralink/pinctrl-rt305x.c            |  44 +-
 drivers/pinctrl/ralink/pinctrl-rt3883.c            |  28 +-
 drivers/pinctrl/stm32/pinctrl-stm32.c              |  18 +-
 drivers/power/reset/arm-versatile-reboot.c         |   1 +
 drivers/s390/char/keyboard.h                       |   4 +-
 drivers/scsi/megaraid/megaraid_sas_base.c          |   3 +
 drivers/scsi/ufs/ufshcd.c                          |   2 +-
 drivers/spi/spi-bcm2835.c                          |  12 +-
 drivers/tty/goldfish.c                             |   2 +-
 drivers/tty/moxa.c                                 |   4 +-
 drivers/tty/pty.c                                  |  14 +-
 drivers/tty/serial/lpc32xx_hs.c                    |   2 +-
 drivers/tty/serial/mvebu-uart.c                    |  25 +-
 drivers/tty/tty.h                                  |   3 +
 drivers/tty/tty_buffer.c                           |  66 ++-
 drivers/tty/vt/keyboard.c                          |   6 +-
 drivers/tty/vt/vt.c                                |   2 +-
 drivers/usb/host/xhci-dbgcap.c                     | 135 +++----
 drivers/usb/host/xhci-dbgcap.h                     |  13 +-
 drivers/usb/host/xhci-dbgtty.c                     |  22 +-
 drivers/usb/host/xhci.c                            |   6 +-
 fs/dlm/lock.c                                      |   3 +-
 fs/exfat/namei.c                                   |  31 +-
 fs/proc/proc_sysctl.c                              |   2 +-
 fs/xfs/libxfs/xfs_ag.h                             |  36 +-
 fs/xfs/libxfs/xfs_btree_staging.c                  |   4 +-
 fs/xfs/xfs_ioctl.c                                 |   2 +-
 fs/xfs/xfs_ioctl.h                                 |   5 +-
 include/linux/bitfield.h                           |  19 +-
 include/linux/skbuff.h                             |  47 ++-
 include/linux/sysctl.h                             |  13 +-
 include/linux/tty_flip.h                           |   1 -
 include/net/bluetooth/bluetooth.h                  |  65 +++
 include/net/inet_hashtables.h                      |   2 +-
 include/net/inet_sock.h                            |  12 +-
 include/net/ip.h                                   |   6 +-
 include/net/netns/ipv4.h                           |   1 -
 include/net/route.h                                |   2 +-
 include/net/tcp.h                                  |  18 +-
 include/net/udp.h                                  |   2 +-
 include/trace/events/skb.h                         |  48 ++-
 kernel/bpf/core.c                                  |   8 +-
 kernel/events/core.c                               |  45 ++-
 kernel/sched/deadline.c                            |   5 +-
 kernel/sysctl.c                                    |  44 +-
 kernel/trace/Makefile                              |   1 +
 kernel/trace/ftrace.c                              |   6 +-
 kernel/trace/pid_list.c                            | 160 ++++++++
 kernel/trace/pid_list.h                            |  13 +
 kernel/trace/trace.c                               |  84 ++--
 kernel/trace/trace.h                               |  14 +-
 kernel/trace/trace_events.c                        |  13 +-
 kernel/watch_queue.c                               |  53 ++-
 mm/mempolicy.c                                     |   2 +-
 net/batman-adv/bridge_loop_avoidance.c             |   2 +-
 net/bluetooth/rfcomm/core.c                        |  50 ++-
 net/bluetooth/rfcomm/sock.c                        |  46 +--
 net/bluetooth/sco.c                                |  30 +-
 net/core/dev.c                                     |   3 +-
 net/core/drop_monitor.c                            |  10 +-
 net/core/filter.c                                  |   4 +-
 net/core/secure_seq.c                              |   4 +-
 net/core/skbuff.c                                  |  12 +-
 net/core/sock_reuseport.c                          |   4 +-
 net/ipv4/af_inet.c                                 |   4 +-
 net/ipv4/fib_semantics.c                           |   2 +-
 net/ipv4/icmp.c                                    |   2 +-
 net/ipv4/igmp.c                                    |  25 +-
 net/ipv4/inet_connection_sock.c                    |   5 +-
 net/ipv4/ip_forward.c                              |   2 +-
 net/ipv4/ip_input.c                                |  26 +-
 net/ipv4/ip_sockglue.c                             |   8 +-
 net/ipv4/netfilter/nf_reject_ipv4.c                |   4 +-
 net/ipv4/proc.c                                    |   2 +-
 net/ipv4/route.c                                   |  10 +-
 net/ipv4/syncookies.c                              |  11 +-
 net/ipv4/sysctl_net_ipv4.c                         |   8 +-
 net/ipv4/tcp.c                                     |  13 +-
 net/ipv4/tcp_fastopen.c                            |   9 +-
 net/ipv4/tcp_input.c                               |  53 ++-
 net/ipv4/tcp_ipv4.c                                |  77 ++--
 net/ipv4/tcp_metrics.c                             |   3 +-
 net/ipv4/tcp_minisocks.c                           |   4 +-
 net/ipv4/tcp_output.c                              |  31 +-
 net/ipv4/tcp_recovery.c                            |   6 +-
 net/ipv4/tcp_timer.c                               |  30 +-
 net/ipv4/udp.c                                     |  10 +-
 net/ipv6/af_inet6.c                                |   2 +-
 net/ipv6/syncookies.c                              |   3 +-
 net/netfilter/core.c                               |   3 +-
 net/netfilter/nf_synproxy_core.c                   |   2 +-
 net/sctp/protocol.c                                |   2 +-
 net/smc/smc_llc.c                                  |   2 +-
 net/tls/tls_device.c                               |   8 +-
 net/xfrm/xfrm_policy.c                             |   5 +-
 net/xfrm/xfrm_state.c                              |   2 +-
 scripts/sorttable.c                                |   4 +-
 security/integrity/ima/ima_policy.c                |   4 +
 tools/perf/tests/perf-time-to-tsc.c                |  18 +-
 tools/testing/selftests/kvm/rseq_test.c            |   8 +-
 tools/testing/selftests/vm/mremap_test.c           |  53 ---
 virt/kvm/kvm_main.c                                |   5 +-
 210 files changed, 3381 insertions(+), 1897 deletions(-)


