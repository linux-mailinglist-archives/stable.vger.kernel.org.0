Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5DBB32FF7C
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 08:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230070AbhCGH3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 02:29:50 -0500
Received: from mo4-p01-ob.smtp.rzone.de ([85.215.255.51]:34843 "EHLO
        mo4-p01-ob.smtp.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231357AbhCGH3g (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 7 Mar 2021 02:29:36 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1615101994; cv=none;
    d=strato.com; s=strato-dkim-0002;
    b=p80Nk2wCYoGWK7X6PbZ1QUKdxi7BvGaVHD9QvqwDPEb9UuYKqJQpK5deeAxG5zxQdC
    tSbagLAM3WZ/+ZpCbopamOudP/gtJGj6oEaoxw1OodpgHj1tL9iNnXkhNiVoODwHxxO+
    YA4r/R+WMWarKwi7JCqLkpGkqf33PURWWbgmU9BJc29sT6HG6HW93zzzWZ8lISDCfrHR
    eQCPl5adVuWEWsuMLgOKsd/GndBI8JF2LEUpfBkUXhZBx2IhC1U7nAKHOV74n+QiBv9f
    u+cvf4OH4H3+61Nnq5eMJQ7fTkQQ/QCy6NUHBBRYWjL8i6VrIA7K+W+JAZEAqDVuW0Ni
    3A1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; t=1615101994;
    s=strato-dkim-0002; d=strato.com;
    h=Message-Id:Date:Subject:To:From:Cc:Date:From:Subject:Sender;
    bh=HEEEysoWkKp/UIS/qSkdJPSpBjqYkSPRs79w/tJEBfk=;
    b=BNLUThCiIMO1RGCx4muOvw0W6AgpymeHESx1EjfBY/Z1nYCS60NaGRYTNOONIUX4G/
    JAvIvARrnBPyB+8vQMEaOk28qxqI3HD7AamZT1ACdFKqp4hw7A648Vgtu243u1SuTw7c
    wyRuvQPF8M1fbdmKx+rB3oWr780pdYkSM0dejpcI2J3fNxQi5njKJzPtAt3XkIJw+Nz6
    X+fzrJ2NlxksJ0MsfRGq8EJZUcmNOafjpAddmfxbVWDi/yIVChIrl9+ZbZeLYTr8l5vA
    BVj+q+Y0YVOMEVgNOpRjwXredfYkcvwTnog7KmniA4FTnKXufOExWD39wTyrk+4YgYQZ
    nUjw==
ARC-Authentication-Results: i=1; strato.com;
    dkim=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1615101994;
    s=strato-dkim-0002; d=schoebel-theuer.de;
    h=Message-Id:Date:Subject:To:From:Cc:Date:From:Subject:Sender;
    bh=HEEEysoWkKp/UIS/qSkdJPSpBjqYkSPRs79w/tJEBfk=;
    b=iPXfNWHVfqofq1T4Y5OdJm37Yp8wC1HGYf6dnMJ7IsI8cGTHHK4YRwrwKe/q5nSBE4
    JujBFNzUFR51GVeRhpDGPY5Fyo47VZ42AA1JbpAx3IkKlay2DIi6xHO8VkiHpBXaJtPt
    yDfbuJ96JEacr3KHFSAFNwOaWK+l2ZhQQi/W5vjjBUJcgYVS+pfVF3pXKVzZ/Y/5+hNV
    deaS3DA+fD6pjjD9gwSlVQHSto5A3rg4iO7QroZlHji48qpTJt8W8fqH0B7Ut5r+uoYM
    tj+Yck8NcEE6nu4oXx82/OCuOseehrusHVbOtzT7adfQOQzg5P/qDNDJ1M03X96eNChl
    GeAg==
Authentication-Results: strato.com;
    dkim=none
X-RZG-AUTH: ":OH8QVVOrc/CP6za/qRmbF3BWedPGA1vjs2e0bDjfg8SjapJoMy/ngEsCKWYLcLtzTI+/at5T6HYnAg=="
X-RZG-CLASS-ID: mo00
Received: from localhost.localdomain
    by smtp.strato.de (RZmta 47.20.3 DYNA|AUTH)
    with ESMTPSA id 6007d4x277QX8fL
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
    Sun, 7 Mar 2021 08:26:33 +0100 (CET)
From:   Thomas Schoebel-Theuer <tst@schoebel-theuer.de>
To:     tst@schoebel-theuer.de, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lee Jones <lee.jones@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Schoebel-Theuer <tst@1und1.de>,
        Arnd Bergmann <arnd@arndb.de>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH RESEND v2 STABLE 4.4] futex: fix irq self-deadlock and satisfy assertion
Date:   Sun,  7 Mar 2021 08:26:29 +0100
Message-Id: <20210307072629.5955-1-tst@schoebel-theuer.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Schoebel-Theuer <tst@1und1.de>

This patch and problem analysis is specific for 4.4 LTS, due to incomplete
backporting of other fixes. Later LTS series have different backports.

Since v4.4.257 when CONFIG_PROVE_LOCKING=y
the following triggers right after reboot of our pre-life systems
which equal our production setup:

Mar 03 11:27:33 icpu-test-bap10 kernel: =================================
Mar 03 11:27:33 icpu-test-bap10 kernel: [ INFO: inconsistent lock state ]
Mar 03 11:27:33 icpu-test-bap10 kernel: 4.4.259-rc1-grsec+ #730 Not tainted
Mar 03 11:27:33 icpu-test-bap10 kernel: ---------------------------------
Mar 03 11:27:33 icpu-test-bap10 kernel: inconsistent {IN-HARDIRQ-W} -> {HARDIRQ-ON-W} usage.
Mar 03 11:27:33 icpu-test-bap10 kernel: apache2-ssl/9310 [HC0[0]:SC0[0]:HE1:SE1] takes:
Mar 03 11:27:33 icpu-test-bap10 kernel:  (&p->pi_lock){?.-.-.}, at: [<ffffffff810abb68>] pi_state_update_owner+0x51/0xd7
Mar 03 11:27:33 icpu-test-bap10 kernel: {IN-HARDIRQ-W} state was registered at:
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff81088c4a>] __lock_acquire+0x3a7/0xe4a
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff81089b01>] lock_acquire+0x18d/0x1bc
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff8170151c>] _raw_spin_lock_irqsave+0x3e/0x50
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff810719a5>] try_to_wake_up+0x2c/0x210
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff81071bf3>] default_wake_function+0xd/0xf
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff81083588>] autoremove_wake_function+0x11/0x35
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff810830b2>] __wake_up_common+0x48/0x7c
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff8108311a>] __wake_up+0x34/0x46
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff814c2a23>] megasas_complete_int_cmd+0x31/0x33
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff814c60a0>] megasas_complete_cmd+0x570/0x57b
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff814d05bc>] complete_cmd_fusion+0x23e/0x33d
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff814d0768>] megasas_isr_fusion+0x67/0x74
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff81091ae5>] handle_irq_event_percpu+0x134/0x311
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff81091cf5>] handle_irq_event+0x33/0x51
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff810948b9>] handle_edge_irq+0xa3/0xc2
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff81005f7b>] handle_irq+0xf9/0x101
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff81005700>] do_IRQ+0x80/0xf5
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff81702228>] ret_from_intr+0x0/0x20
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff8100cab0>] arch_cpu_idle+0xa/0xc
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff81083a5a>] default_idle_call+0x1e/0x20
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff81083b9d>] cpu_startup_entry+0x141/0x22f
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff816fb853>] rest_init+0x135/0x13b
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff81d5ce99>] start_kernel+0x3fa/0x40a
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff81d5c2af>] x86_64_start_reservations+0x2a/0x2c
Mar 03 11:27:33 icpu-test-bap10 kernel:   [<ffffffff81d5c3d0>] x86_64_start_kernel+0x11f/0x12c
Mar 03 11:27:33 icpu-test-bap10 kernel: irq event stamp: 1457
Mar 03 11:27:33 icpu-test-bap10 kernel: hardirqs last  enabled at (1457): [<ffffffff81042a69>] get_user_pages_fast+0xeb/0x14f
Mar 03 11:27:33 icpu-test-bap10 kernel: hardirqs last disabled at (1456): [<ffffffff810429dd>] get_user_pages_fast+0x5f/0x14f
Mar 03 11:27:33 icpu-test-bap10 kernel: softirqs last  enabled at (1446): [<ffffffff815e127d>] release_sock+0x142/0x14d
Mar 03 11:27:33 icpu-test-bap10 kernel: softirqs last disabled at (1444): [<ffffffff815e116f>] release_sock+0x34/0x14d
Mar 03 11:27:33 icpu-test-bap10 kernel:
                                        other info that might help us debug this:
Mar 03 11:27:33 icpu-test-bap10 kernel:  Possible unsafe locking scenario:
Mar 03 11:27:33 icpu-test-bap10 kernel:        CPU0
Mar 03 11:27:33 icpu-test-bap10 kernel:        ----
Mar 03 11:27:33 icpu-test-bap10 kernel:   lock(&p->pi_lock);
Mar 03 11:27:33 icpu-test-bap10 kernel:   <Interrupt>
Mar 03 11:27:33 icpu-test-bap10 kernel:     lock(&p->pi_lock);
Mar 03 11:27:33 icpu-test-bap10 kernel:
                                         *** DEADLOCK ***
Mar 03 11:27:33 icpu-test-bap10 kernel: 2 locks held by apache2-ssl/9310:
Mar 03 11:27:33 icpu-test-bap10 kernel:  #0:  (&(&(__futex_data.queues)[i].lock)->rlock){+.+...}, at: [<ffffffff810ae4e6>] do
Mar 03 11:27:33 icpu-test-bap10 kernel:  #1:  (&lock->wait_lock){+.+...}, at: [<ffffffff810ae53a>] do_futex+0x639/0x809
Mar 03 11:27:33 icpu-test-bap10 kernel:
                                        stack backtrace:
Mar 03 11:27:33 icpu-test-bap10 kernel: CPU: 13 PID: 9310 UID: 99 Comm: apache2-ssl Not tainted 4.4.259-rc1-grsec+ #730
Mar 03 11:27:33 icpu-test-bap10 kernel: Hardware name: Dell Inc. PowerEdge R630/02C2CP, BIOS 2.11.0 11/02/2019
Mar 03 11:27:33 icpu-test-bap10 kernel:  0000000000000000 ffff883fb79bfc00 ffffffff816f8fc2 ffff883ffa66d300
Mar 03 11:27:33 icpu-test-bap10 kernel:  ffffffff8eaa71f0 ffff883fb79bfc50 ffffffff81088484 0000000000000000
Mar 03 11:27:33 icpu-test-bap10 kernel:  0000000000000001 0000000000000001 0000000000000002 ffff883ffa66db58
Mar 03 11:27:33 icpu-test-bap10 kernel: Call Trace:
Mar 03 11:27:33 icpu-test-bap10 kernel:  [<ffffffff816f8fc2>] dump_stack+0x94/0xca
Mar 03 11:27:33 icpu-test-bap10 kernel:  [<ffffffff81088484>] print_usage_bug+0x1bc/0x1d1
Mar 03 11:27:33 icpu-test-bap10 kernel:  [<ffffffff81087d76>] ? check_usage_forwards+0x98/0x98
Mar 03 11:27:33 icpu-test-bap10 kernel:  [<ffffffff810885a5>] mark_lock+0x10c/0x203
Mar 03 11:27:33 icpu-test-bap10 kernel:  [<ffffffff81088cb9>] __lock_acquire+0x416/0xe4a
Mar 03 11:27:33 icpu-test-bap10 kernel:  [<ffffffff810abb68>] ? pi_state_update_owner+0x51/0xd7
Mar 03 11:27:33 icpu-test-bap10 kernel:  [<ffffffff81089b01>] lock_acquire+0x18d/0x1bc
Mar 03 11:27:33 icpu-test-bap10 kernel:  [<ffffffff81089b01>] ? lock_acquire+0x18d/0x1bc
Mar 03 11:27:33 icpu-test-bap10 kernel:  [<ffffffff810abb68>] ? pi_state_update_owner+0x51/0xd7
Mar 03 11:27:33 icpu-test-bap10 kernel:  [<ffffffff81700d12>] _raw_spin_lock+0x2a/0x39
Mar 03 11:27:33 icpu-test-bap10 kernel:  [<ffffffff810abb68>] ? pi_state_update_owner+0x51/0xd7
Mar 03 11:27:33 icpu-test-bap10 kernel:  [<ffffffff810abb68>] pi_state_update_owner+0x51/0xd7
Mar 03 11:27:33 icpu-test-bap10 kernel:  [<ffffffff810ae5af>] do_futex+0x6ae/0x809
Mar 03 11:27:33 icpu-test-bap10 kernel:  [<ffffffff810ae83d>] SyS_futex+0x133/0x143
Mar 03 11:27:33 icpu-test-bap10 kernel:  [<ffffffff8100158a>] ? syscall_trace_enter_phase2+0x1a2/0x1bb
Mar 03 11:27:33 icpu-test-bap10 kernel:  [<ffffffff81701848>] tracesys_phase2+0x90/0x95

Bisecting detects 47e452fcf2f
in the above specific scenario using apache-ssl,
but apparently the missing *_irq() was introduced in
34c8e1c2c02.

However, just reverting the old _irq() variants to a similar status
than before 34c8e1c2c02,
or using _irqsave() / _irqrestore() as some other backports are doing
in various places, would not really help.

The fundamental problem is the following violation of the assertion
lockdep_assert_held(&pi_state->pi_mutex.wait_lock) in pi_state_update_owner():

Mar 03 12:50:03 icpu-test-bap10 kernel: ------------[ cut here ]------------
Mar 03 12:50:03 icpu-test-bap10 kernel: WARNING: CPU: 37 PID: 8488 at kernel/futex.c:844 pi_state_update_owner+0x3d/0xd7()
Mar 03 12:50:03 icpu-test-bap10 kernel: Modules linked in: xt_time xt_connlimit xt_connmark xt_NFLOG xt_limit xt_hashlimit veth ip_set_bitmap_port xt_DSCP xt_multiport ip_set_hash_ip xt_owner xt_set ip_set_hash_net xt_state xt_conntrack nf_conntrack_ftp mars lz4_decompress lz4_compress ipmi_devintf x86_pkg_temp_thermal coretemp crct10dif_pclmul crc32_pclmul hed ipmi_si ipmi_msghandler processor crc32c_intel ehci_pci ehci_hcd usbcore i40e usb_common
Mar 03 12:50:03 icpu-test-bap10 kernel: CPU: 37 PID: 8488 UID: 99 Comm: apache2-ssl Not tainted 4.4.259-rc1-grsec+ #737
Mar 03 12:50:03 icpu-test-bap10 kernel: Hardware name: Dell Inc. PowerEdge R630/02C2CP, BIOS 2.11.0 11/02/2019
Mar 03 12:50:03 icpu-test-bap10 kernel:  0000000000000000 ffff883f863f7c70 ffffffff816f9002 0000000000000000
Mar 03 12:50:03 icpu-test-bap10 kernel:  0000000000000009 ffff883f863f7ca8 ffffffff8104cda2 ffffffff810abac7
Mar 03 12:50:03 icpu-test-bap10 kernel:  ffff883ffbfe5e80 0000000000000000 ffff883f82ed4bc0 00007fc01c9bf000
Mar 03 12:50:03 icpu-test-bap10 kernel: Call Trace:
Mar 03 12:50:03 icpu-test-bap10 kernel:  [<ffffffff816f9002>] dump_stack+0x94/0xca
Mar 03 12:50:03 icpu-test-bap10 kernel:  [<ffffffff8104cda2>] warn_slowpath_common+0x94/0xad
Mar 03 12:50:03 icpu-test-bap10 kernel:  [<ffffffff810abac7>] ? pi_state_update_owner+0x3d/0xd7
Mar 03 12:50:03 icpu-test-bap10 kernel:  [<ffffffff8104ce5f>] warn_slowpath_null+0x15/0x17
Mar 03 12:50:03 icpu-test-bap10 kernel:  [<ffffffff810abac7>] pi_state_update_owner+0x3d/0xd7
Mar 03 12:50:03 icpu-test-bap10 kernel:  [<ffffffff810abea8>] free_pi_state+0x2d/0x73
Mar 03 12:50:03 icpu-test-bap10 kernel:  [<ffffffff810abf0b>] unqueue_me_pi+0x1d/0x31
Mar 03 12:50:03 icpu-test-bap10 kernel:  [<ffffffff810ad735>] futex_lock_pi+0x27a/0x2e8
Mar 03 12:50:03 icpu-test-bap10 kernel:  [<ffffffff81088bca>] ? __lock_acquire+0x327/0xe4a
Mar 03 12:50:03 icpu-test-bap10 kernel:  [<ffffffff810ae6a9>] do_futex+0x784/0x809
Mar 03 12:50:03 icpu-test-bap10 kernel:  [<ffffffff810cfa9a>] ? seccomp_phase1+0xde/0x1e7
Mar 03 12:50:03 icpu-test-bap10 kernel:  [<ffffffff810a4503>] ? current_kernel_time64+0xb/0x31
Mar 03 12:50:03 icpu-test-bap10 kernel:  [<ffffffff810d23c3>] ? current_kernel_time+0xb/0xf
Mar 03 12:50:03 icpu-test-bap10 kernel:  [<ffffffff810ae861>] SyS_futex+0x133/0x143
Mar 03 12:50:03 icpu-test-bap10 kernel:  [<ffffffff8100158a>] ? syscall_trace_enter_phase2+0x1a2/0x1bb
Mar 03 12:50:03 icpu-test-bap10 kernel:  [<ffffffff81701888>] tracesys_phase2+0x90/0x95
Mar 03 12:50:03 icpu-test-bap10 kernel: ---[ end trace 968f95a458dea951 ]---

In order to both (1) prevent the self-deadlock, and (2) to satisfy the assertion
at pi_state_update_owner(), some locking with irq disable is needed,
at least in the specific call stack.

Interestingly, there existed a suchalike locking just before
f08a4af5ccb.

This is just a quick hotfix, resurrecting some previous
locks at the old places, but now using ->wait_lock in place
of the previous ->pi_lock (which was in place before
f08a4af5ccb).

The ->pi_lock is now also taken, by the new code
which had been introduced in
34c8e1c2c02.

When this patch is applied, both the above splats are
no longer triggering at my prelife machines.

Without this patch, I cannot ensure stable production at
1&1 Ionos.

Hint for further work: I have not yet tested other call paths,
since I am under time pressure for security reasons.

Hint for further hardening of 4.4.y and probably some more LTS series:
Probably some more systematic testing with CONFIG_PROVE_LOCKING
(and probably some more options) should be invested
in order to make the 4.4 LTS series really "stable" again.

Signed-off-by: Thomas Schoebel-Theuer <tst@1und1.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Lee Jones <lee.jones@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: f08a4af5ccb
Fixes: 34c8e1c2c02
---
 kernel/futex.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/futex.c b/kernel/futex.c
index 4a707bc7cceb..0c42d2313660 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -874,7 +874,9 @@ static void free_pi_state(struct futex_pi_state *pi_state)
 	 * and has cleaned up the pi_state already
 	 */
 	if (pi_state->owner) {
+		raw_spin_lock_irq(&pi_state->pi_mutex.wait_lock);
 		pi_state_update_owner(pi_state, NULL);
+		raw_spin_unlock_irq(&pi_state->pi_mutex.wait_lock);
 		rt_mutex_proxy_unlock(&pi_state->pi_mutex);
 	}
 
-- 
2.26.2

