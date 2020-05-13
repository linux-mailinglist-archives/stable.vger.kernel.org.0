Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 836EF1D1D14
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 20:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390018AbgEMSLc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 14:11:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1732488AbgEMSLa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 14:11:30 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96795C061A0E
        for <stable@vger.kernel.org>; Wed, 13 May 2020 11:11:28 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id x73so339811lfa.2
        for <stable@vger.kernel.org>; Wed, 13 May 2020 11:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=ObQlcmE8BfFq8Ky5Jwc1TYQdNQsyuoQ2Kp6DlZPPc5o=;
        b=dVPGGocmIS4UbIdLVm5TxEpkEAAL98rpb0YI2DcHGmEjmRz7g0SohWQMZ/kS5Nl26n
         dTJIut8pjHT1NjHultJmh7248RmvxyV9VydD6gShfiCFn82LNBeGbF62KiOZaIAfcYPx
         JE30OzV9woNAyUJLZFcb2SpFWL+rtyUvqUQ/Q7GxNvop9dChe/9FrOQ07eT3SqmAZiZK
         NcgMi1ttywIJrnISDUi1+Bg4GUJmJaOB3Xro8sDZm+8IaMcsCZfUzNHutFZlMfLr3d/F
         nJfdmWPAs0kEVxs3SV5vouD1bcgr2S2fRaS/xhlWwLCzbr7GdMEd9J2NhmBqLXSxbpwr
         KVZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=ObQlcmE8BfFq8Ky5Jwc1TYQdNQsyuoQ2Kp6DlZPPc5o=;
        b=nhPndC1OOeoY2hTI3DuoGf8Vo+TPphvbLZuFmXrXc+Lkb1eHElpqWQ6058HPUjPR9s
         I5tyT/rclOhqdkH0jIcXvrCxaLbOWMGkbakSTb4LCMRaDETomnJw7JZ0lgWAe+T2k42X
         Ctg+T6Z8aGvTAjFOiDkpZYdLQ+FGg9ue2K9sq5BEoC/j8bL1HoxhNOI1WoRDfMToUicd
         VSNMbzij0W36O4+B++gZxKkMO2/82dNwfwAg+C+10RPMeJdHvsloHQ+gD8aNr07J/I8L
         BewznqXyO+l27Vocxx5TUjRlDLCS2TFpQC+XtYH8sbH4zifRTcmRGEocD+ct0tVyhzFz
         UGfA==
X-Gm-Message-State: AOAM531OVbfdhwdgwQF0EL4IMbpZpEl8mZJ5UyKAu8tbj/lUG/bjTK6o
        rzh9vNxG3wJlzjdCDqY6QL2dg8CQmm5LJU0ZKoALlRF+D6+sQA==
X-Google-Smtp-Source: ABdhPJx0KOUh6sL02rdB0AEtbrAtqFrwh3AQ1og21m0BqmN7OaV+aRMwJkoagbhA3WfzwhIHIOD7zDlZkNRBvsIcYao=
X-Received: by 2002:a19:40d2:: with SMTP id n201mr506128lfa.82.1589393486021;
 Wed, 13 May 2020 11:11:26 -0700 (PDT)
MIME-Version: 1.0
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Wed, 13 May 2020 23:41:14 +0530
Message-ID: <CA+G9fYvo2yUVicoZ7fOYf8=QxTtS8nW-Z2JGD4iLtU61E6xNdw@mail.gmail.com>
Subject: stable-rc 4.19: WARNING: at lib/refcount.c:187 refcount_sub_and_test_checked
To:     linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     lkft-triage@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Todd Kjos <tkjos@google.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Ard Biesheuvel <ard.biesheuvel@linaro.org>, ardb@kernel.org,
        Kees Cook <keescook@chromium.org>,
        Will Deacon <will@kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

While running LTP sched on stable-rc 4.19 branch kernel on arm64 hikey device.
Thermal alarm triggered and followed by kernel warnings and Internal
error: Oops:

steps to reproduce:
cd /opt/ltp
./runltp -f sched

Test running hackbench test case from LTP sched

Test case: hackbench 50 process 1000

Running with 50*40 (== 2000) tasks.
[   33.758553] LDO2_2V8: disabling
[   33.761846] LDO13_1V8: disabling
[   33.767592] LDO14_2V8: disabling
[   33.771918] LDO17_2V5: disabling
[   34.182704] hisi_thermal f7030700.tsensor: THERMAL ALARM: 66385 > 65000
[   39.518923] ------------[ cut here ]------------
[   39.525600] refcount_t: underflow; use-after-free.
[   39.532816] WARNING: CPU: 1 PID: 5624 at lib/refcount.c:187
refcount_sub_and_test_checked+0xa0/0xa8
[   39.542099] Modules linked in: wl18xx wlcore mac80211 cfg80211
hci_uart adv7511 snd_soc_audio_graph_card crc32_ce btbcm
snd_soc_simple_card_utils crct10dif_ce cec kirin_drm bluetooth
drm_kms_helper dw_drm_dsi drm wlcore_sdio rfkill
drm_panel_orientation_quirks fuse
[   39.566135] CPU: 1 PID: 5624 Comm: hackbench Not tainted
4.19.123-rc1-00049-g6d5c161fb73d #1
[   39.574768] Hardware name: HiKey Development Board (DT)
[   39.580122] pstate: 40000005 (nZcv daif -PAN -UAO)
[   39.585043] pc : refcount_sub_and_test_checked+0xa0/0xa8
[   39.590491] lr : refcount_sub_and_test_checked+0xa0/0xa8
[   39.595933] sp : ffff0000142bba60
[   39.599331] x29: ffff0000142bba60 x28: ffff80004e20d4c8
[   39.604771] x27: ffff800048273f28 x26: 0000000000000064
[   39.610213] x25: ffff800048273f00 x24: 0000000000000000
[   39.615657] x23: 0000000000000064 x22: ffff80004e20d740
[   39.621097] x21: 0000000000000000 x20: ffff800058991944
[   39.626538] x19: 0000000000000000 x18: 0000000000000000
[   39.631980] x17: 0000000000000000 x16: 0000000000000000
[   39.637418] x15: 0000000000000400 x14: 0000000000000333
[   39.642857] x13: 0000000000000001 x12: 0000000000000000
[   39.648295] x11: 0000000000000002 x10: 0000000000000960
[   39.653734] x9 : ffff0000142bb7a0 x8 : ffff80004e2573c0
[   39.659174] x7 : ffff8000757a6c00 x6 : 0000000000000010
[   39.664612] x5 : ffff800077f1a790 x4 : ffff800077f1b0d0
[   39.670053] x3 : ffff800077f21eb0 x2 : ffff800077f1b0d0
[   39.675493] x1 : d13523b333b73d00 x0 : 0000000000000000
[   39.680930] Call trace:
[   39.683455]  refcount_sub_and_test_checked+0xa0/0xa8
[   39.688550]  sock_wfree+0x4c/0xa0
[   39.691957]  unix_destruct_scm+0x70/0x90
[   39.695986]  skb_release_head_state+0x5c/0xf0
[   39.700460]  skb_release_all+0x14/0x30
[   39.704306]  consume_skb+0x2c/0x58
[   39.707801]  unix_stream_read_generic+0x680/0x750
[   39.712623]  unix_stream_recvmsg+0x4c/0x70
[   39.716829]  sock_read_iter+0x94/0xe8
[   39.720589]  __vfs_read+0xf8/0x148
[   39.724084]  vfs_read+0xa8/0x160
[   39.727400]  ksys_read+0x64/0xd8
[   39.730714]  __arm64_sys_read+0x18/0x20
[   39.734655]  el0_svc_common+0x70/0x168
[   39.738509]  el0_svc_handler+0x2c/0x80
[   39.742360]  el0_svc+0x8/0xc
[   39.745321] ---[ end trace 6e44f0c23e5d9fb1 ]---
[   44.241524] ------------[ cut here ]------------
[   44.248838] WARNING: CPU: 0 PID: 5624 at net/unix/af_unix.c:498
unix_sock_destructor+0xf4/0x100
[   44.257760] Modules linked in: wl18xx wlcore mac80211 cfg80211
hci_uart adv7511 snd_soc_audio_graph_card crc32_ce btbcm
snd_soc_simple_card_utils crct10dif_ce cec kirin_drm bluetooth
drm_kms_helper dw_drm_dsi drm wlcore_sdio rfkill
drm_panel_orientation_quirks fuse
[   44.281801] CPU: 0 PID: 5624 Comm: hackbench Tainted: G        W
     4.19.123-rc1-00049-g6d5c161fb73d #1
[   44.291854] Hardware name: HiKey Development Board (DT)
[   44.297209] pstate: 40000005 (nZcv daif -PAN -UAO)
[   44.302126] pc : unix_sock_destructor+0xf4/0x100
[   44.306863] lr : unix_sock_destructor+0xf4/0x100
[   44.311593] sp : ffff0000142bb9f0
[   44.314990] x29: ffff0000142bb9f0 x28: ffff80004e20d4c8
[   44.320429] x27: ffff800048273f28 x26: 0000000000000064
[   44.325869] x25: ffff800048273f00 x24: 0000000000000000
[   44.331308] x23: 0000000000000064 x22: ffff80004e20d740
[   44.336747] x21: ffff800058991800 x20: ffff8000589916b8
[   44.342186] x19: ffff800058991800 x18: 0000000000000000
[   44.347625] x17: 0000000000000000 x16: 0000000000000000
[   44.353066] x15: 0000000000000400 x14: 0000000000000333
[   44.358508] x13: 0000000000000001 x12: 0000000000000000
[   44.370733] x11: 0000000000000002 x10: 0000000000000960
[   44.382900] x9 : ffff0000142bb760 x8 : ffff80004e2573c0
[   44.395054] x7 : ffff8000757a6a00 x6 : 0000000000000010
[   44.406985] x5 : ffff800077f04790 x4 : ffff800077f050d0
[   44.418678] x3 : ffff800077f0beb0 x2 : d13523b333b73d00
[   44.430478] x1 : 0000000000000000 x0 : 0000000000000024
[   44.442258] Call trace:
[   44.451166]  unix_sock_destructor+0xf4/0x100
[   44.461909]  __sk_destruct+0x2c/0x150
[   44.471973]  sk_destruct+0x48/0x60
[   44.481725]  __sk_free+0x38/0xd0
[   44.491237]  sock_wfree+0x7c/0xa0
[   44.500416]  unix_destruct_scm+0x70/0x90
[   44.509821]  skb_release_head_state+0x5c/0xf0
[   44.519571]  skb_release_all+0x14/0x30
[   44.528610]  consume_skb+0x2c/0x58
[   44.537257]  unix_stream_read_generic+0x680/0x750
[   44.547227]  unix_stream_recvmsg+0x4c/0x70
[   44.556616]  sock_read_iter+0x94/0xe8
[   44.565510]  __vfs_read+0xf8/0x148
[   44.574124]  vfs_read+0xa8/0x160
[   44.582578]  ksys_read+0x64/0xd8
[   44.591057]  __arm64_sys_read+0x18/0x20
[   44.600160]  el0_svc_common+0x70/0x168
[   44.609177]  el0_svc_handler+0x2c/0x80
[   44.618194]  el0_svc+0x8/0xc
[   44.626370] ---[ end trace 6e44f0c23e5d9fb2 ]---
[   44.804127] ------------[ cut here ]------------
[   44.851402] refcount_t: addition on 0; use-after-free.
[   45.083709] ------------[ cut here ]------------
[   45.095872] WARNING: CPU: 1 PID: 5624 at net/unix/af_unix.c:499
unix_sock_destructor+0xe0/0x100
[   45.110316] Modules linked in: wl18xx wlcore mac80211 cfg80211
hci_uart adv7511 snd_soc_audio_graph_card crc32_ce btbcm
snd_soc_simple_card_utils crct10dif_ce cec kirin_drm bluetooth
drm_kms_helper dw_drm_dsi drm wlcore_sdio rfkill
drm_panel_orientation_quirks fuse
[   45.146603] CPU: 1 PID: 5624 Comm: hackbench Tainted: G        W
     4.19.123-rc1-00049-g6d5c161fb73d #1
[   45.163052] Hardware name: HiKey Development Board (DT)
[   45.174863] pstate: 40000005 (nZcv daif -PAN -UAO)
[   45.186303] pc : unix_sock_destructor+0xe0/0x100
[   45.197560] lr : unix_sock_destructor+0xe0/0x100
[   45.208757] sp : ffff0000142bb9f0
[   45.218636] x29: ffff0000142bb9f0 x28: ffff80004e20d4c8
[   45.230537] x27: ffff800048273f28 x26: 0000000000000064
[   45.242423] x25: ffff800048273f00 x24: 0000000000000000
[   45.254317] x23: 0000000000000064 x22: ffff80004e20d740
[   45.266248] x21: ffff800058991800 x20: ffff8000589916b8
[   45.278128] x19: ffff800058991800 x18: 0000000000000000
[   45.289964] x17: 0000000000000000 x16: 0000000000000000
[   45.301854] x15: 0000000000000400 x14: 0000000000000333
[   45.313691] x13: 0000000000000001 x12: 0000000000000000
[   45.325466] x11: 0000000000000002 x10: 0000000000000960
[   45.337205] x9 : ffff0000142bb760 x8 : ffff80004e2573c0
[   45.349011] x7 : ffff8000757a6c00 x6 : 0000000000000010
[   45.360826] x5 : ffff800077f1a790 x4 : ffff800077f1b0d0
[   45.372682] x3 : ffff800077f21eb0 x2 : d13523b333b73d00
[   45.384432] x1 : 0000000000000000 x0 : 0000000000000024
[   45.396161] Call trace:
[   45.404576]  unix_sock_destructor+0xe0/0x100
[   45.414505]  __sk_destruct+0x2c/0x150
[   45.423673]  sk_destruct+0x48/0x60
[   45.432482]  __sk_free+0x38/0xd0
[   45.441123]  sock_wfree+0x7c/0xa0
[   45.449751]  unix_destruct_scm+0x70/0x90
[   45.459098]  skb_release_head_state+0x5c/0xf0
[   45.468851]  skb_release_all+0x14/0x30
[   45.477977]  consume_skb+0x2c/0x58
[   45.486728]  unix_stream_read_generic+0x680/0x750
[   45.496892]  unix_stream_recvmsg+0x4c/0x70
[   45.506383]  sock_read_iter+0x94/0xe8
[   45.515494]  __vfs_read+0xf8/0x148
[   45.524328]  vfs_read+0xa8/0x160
[   45.532979]  ksys_read+0x64/0xd8
[   45.541711]  __arm64_sys_read+0x18/0x20
[   45.551056]  el0_svc_common+0x70/0x168
[   45.560334]  el0_svc_handler+0x2c/0x80
[   45.569595]  el0_svc+0x8/0xc
[   45.577983] ---[ end trace 6e44f0c23e5d9fb3 ]---
[   46.230081] unix: Attempt to release alive unix socket: 00000000c16f8bab
[   46.581410] WARNING: CPU: 7 PID: 4201 at lib/refcount.c:102
refcount_add_checked+0x40/0x48
[   46.595469] Modules linked in: wl18xx wlcore mac80211 cfg80211
hci_uart adv7511 snd_soc_audio_graph_card crc32_ce btbcm
snd_soc_simple_card_utils crct10dif_ce cec kirin_drm bluetooth
drm_kms_helper dw_drm_dsi drm wlcore_sdio rfkill
drm_panel_orientation_quirks fuse
[   46.631752] CPU: 7 PID: 4201 Comm: hackbench Tainted: G        W
     4.19.123-rc1-00049-g6d5c161fb73d #1
[   46.648192] Hardware name: HiKey Development Board (DT)
[   46.660070] pstate: 40000005 (nZcv daif -PAN -UAO)
[   46.671520] pc : refcount_add_checked+0x40/0x48
[   46.682787] lr : refcount_add_checked+0x40/0x48
[   46.693921] sp : ffff000011653b10
[   46.703835] x29: ffff000011653b10 x28: 0000000000000000
[   46.715810] x27: 0000000000000003 x26: 0000000000000000
[   46.727832] x25: 7fffffffffffffff x24: ffff000011653c74
[   46.739766] x23: ffff0000092198c8 x22: ffff0000081187c8
[   46.751748] x21: ffff800058991400 x20: ffff800058991800
[   46.763739] x19: ffff80004bcad300 x18: 0000000000000000
[   46.775673] x17: 0000000000000000 x16: 0000000000000000
[   46.787641] x15: 0000000000000400 x14: 0000000000000333
[   46.799574] x13: 0000000000000001 x12: 0000000000000000
[   46.811479] x11: 0000000000000070 x10: 0000000000000960
[   46.823383] x9 : ffff000011653850 x8 : ffff800058b43180
[   46.835276] x7 : ffff8000757a7800 x6 : 0000000000000010
[   46.847198] x5 : ffff800077f9e790 x4 : ffff800077f9f0d0
[   46.859090] x3 : ffff800077fa5eb0 x2 : ffff800077f9f0d0
[   46.870964] x1 : d13523b333b73d00 x0 : 0000000000000000
[   46.882829] Call trace:
[   46.891741]  refcount_add_checked+0x40/0x48
[   46.902369]  skb_set_owner_w+0x60/0xa8
[   46.912144]  sock_alloc_send_pskb+0x200/0x210
[   46.922202]  unix_stream_sendmsg+0x1d0/0x340
[   46.931999]  sock_sendmsg+0x18/0x30
[   46.940976]  sock_write_iter+0x8c/0xe0
[   46.950159]  __vfs_write+0xf8/0x160
[   46.959014]  vfs_write+0xa4/0x1b0
[   46.967712]  ksys_write+0x64/0xd8
[   46.976420]  __arm64_sys_write+0x18/0x20
[   46.985743]  el0_svc_common+0x70/0x168
[   46.994915]  el0_svc_handler+0x2c/0x80
[   47.004074]  el0_svc+0x8/0xc
[   47.012329] ---[ end trace 6e44f0c23e5d9fb4 ]---
[   51.942160] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000008
[   51.956600] Mem abort info:
[   51.964994]   ESR = 0x96000046
[   51.973658]   Exception class = DABT (current EL), IL = 32 bits
[   51.985323]   SET = 0, FnV = 0
[   51.994116]   EA = 0, S1PTW = 0
[   52.002991] Data abort info:
[   52.011559]   ISV = 0, ISS = 0x00000046
[   52.021139]   CM = 0, WnR = 1
[   52.029826] user pgtable: 4k pages, 48-bit VAs, pgdp = 00000000cd136acc
[   52.042281] [0000000000000008] pgd=000000004e23d003,
pud=000000004e23e003, pmd=0000000000000000
[   52.056947] Internal error: Oops: 96000046 [#1] PREEMPT SMP
[   52.068511] Modules linked in: wl18xx wlcore mac80211 cfg80211
hci_uart adv7511 snd_soc_audio_graph_card crc32_ce btbcm
snd_soc_simple_card_utils crct10dif_ce cec kirin_drm bluetooth
drm_kms_helper dw_drm_dsi drm wlcore_sdio rfkill
drm_panel_orientation_quirks fuse
[   52.105341] Process hackbench (pid: 5616, stack limit = 0x00000000a84269cf)
[   52.119153] CPU: 2 PID: 5616 Comm: hackbench Tainted: G        W
     4.19.123-rc1-00049-g6d5c161fb73d #1
[   52.136027] Hardware name: HiKey Development Board (DT)
[   52.148385] pstate: 60000085 (nZCv daIf -PAN -UAO)
[   52.160272] pc : skb_unlink+0x40/0x60
[   52.171005] lr : skb_unlink+0x24/0x60
[   52.181698] sp : ffff00001427bb20
[   52.191997] x29: ffff00001427bb20 x28: ffff80004e2094c8
[   52.204398] x27: ffff800048273528 x26: 0000000000000064
[   52.216760] x25: ffff800048273500 x24: 0000000000000000
[   52.229121] x23: 0000000000000064 x22: ffff80004e209740
[   52.241486] x21: ffff80004e2094dc x20: ffff80004e2094c8
[   52.253822] x19: ffff800048273500 x18: 0000000000000000
[   52.266159] x17: 0000000000000000 x16: 0000000000000000
[   52.278498] x15: 0000000000000000 x14: 00000000226300a0
[   52.290796] x13: 00000000226300a0 x12: 00000000004012f8
[   52.303077] x11: 00000000004014b4 x10: 0000fffff7fe03b0
[   52.315350] x9 : 00000000226300a0 x8 : 0000000000000008
[   52.327541] x7 : 0000000000000007 x6 : 0000000000000001
[   52.339623] x5 : 0000000000000001 x4 : 0000000000000002
[   52.351279] x3 : 0000000000000000 x2 : 0000000000000000
[   52.362553] x1 : 0000000000000000 x0 : ffff80004e2094dc
[   52.373690] Call trace:
[   52.381864]  skb_unlink+0x40/0x60
[   52.390837]  unix_stream_read_generic+0x678/0x750
[   52.401221]  unix_stream_recvmsg+0x4c/0x70
[   52.411043]  sock_read_iter+0x94/0xe8
[   52.420417]  __vfs_read+0xf8/0x148
[   52.429510]  vfs_read+0xa8/0x160
[   52.438457]  ksys_read+0x64/0xd8
[   52.447370]  __arm64_sys_read+0x18/0x20
[   52.456911]  el0_svc_common+0x70/0x168
[   52.466376]  el0_svc_handler+0x2c/0x80
[   52.475801]  el0_svc+0x8/0xc
[   52.484345] Code: 51000442 b9001282 a9400a63 a9007e7f (f9000462)
[   52.496245] ---[ end trace 6e44f0c23e5d9fb5 ]---
[   52.506922] note: hackbench[5616] exited with preempt_count 1

Broadcast message from systemd-journald@hikey (Sun 2019-03-24 19:24:41 UTC):

kernel[3032]: [   52.056947] Internal error: Oops: 96000046 [#1] PREEMPT SMP


Broadcast message from systemd-journald@hikey (Sun 2019-03-24 19:24:41 UTC):

kernel[3032]: [   52.105341] Process hackbench (pid: 5616, stack limit
= 0x00000000a84269cf)


Broadcast message from systemd-journald@hikey (Sun 2019-03-24 19:24:41 UTC):

kernel[3032]: [   52.484345] Code: 51000442 b9001282 a9400a63 a9007e7f
(f9000462)

SERVER: read (error: Bad address)
Running with 20*40 (== 800) tasks.
[   53.050369] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000000
[   53.065286] Mem abort info:
[   53.074084]   ESR = 0x96000044
[   53.083135]   Exception class = DABT (current EL), IL = 32 bits
[   53.095174]   SET = 0, FnV = 0
[   53.104314]   EA = 0, S1PTW = 0
[   53.113497] Data abort info:
[   53.122392]   ISV = 0, ISS = 0x00000044
[   53.132261]   CM = 0, WnR = 1
[   53.141238] user pgtable: 4k pages, 48-bit VAs, pgdp = 000000005aa0b283
[   53.153996] [0000000000000000] pgd=0000000000000000
[   53.165047] Internal error: Oops: 96000044 [#2] PREEMPT SMP
[   53.176817] Modules linked in: wl18xx wlcore mac80211 cfg80211
hci_uart adv7511 snd_soc_audio_graph_card crc32_ce btbcm
snd_soc_simple_card_utils crct10dif_ce cec kirin_drm bluetooth
drm_kms_helper dw_drm_dsi drm wlcore_sdio rfkill
drm_panel_orientation_quirks fuse
[   53.214090] Process hackbench (pid: 5624, stack limit = 0x0000000092e9188f)
[   53.228138] CPU: 7 PID: 5624 Comm: hackbench Tainted: G      D W
     4.19.123-rc1-00049-g6d5c161fb73d #1
[   53.245231] Hardware name: HiKey Development Board (DT)
[   53.257701] pstate: 80000085 (Nzcv daIf -PAN -UAO)
[   53.269773] pc : skb_dequeue+0x4c/0x90
[   53.280804] lr : skb_dequeue+0x20/0x90
[   53.291782] sp : ffff0000142bbae0
[   53.302190] x29: ffff0000142bbae0 x28: ffff80004e256a00
[   53.314558] x27: 0000000000000000 x26: ffff80004e20db40
[   53.326910] x25: 0000000000000003 x24: 0000000000000001
[   53.339232] x23: ffff0000092198c8 x22: ffff80004e20d4c8
[   53.351527] x21: ffff80004e20d4dc x20: ffff800048273500
[   53.363836] x19: ffff80004e20d4c8 x18: 0000000000000333
[   53.376137] x17: 0000000000000000 x16: 0000000000000000
[   53.388449] x15: 0000000000000400 x14: 0000000000000333
[   53.400697] x13: 0000000000000001 x12: 0000000000000000
[   53.412874] x11: 0000000000000002 x10: ffff800005f0a800
[   53.424943] x9 : 0000000000000010 x8 : ffff800077fac8e8
[   53.436880] x7 : 0000000044040000 x6 : 0000000000000002
[   53.448446] x5 : 0000000000000001 x4 : 0000000000000003
[   53.459613] x3 : ffff80004e20d4dc x2 : ffff800048273c00
[   53.470707] x1 : 0000000000000000 x0 : 0000000000000000
[   53.481673] Call trace:
[   53.489657]  skb_dequeue+0x4c/0x90
[   53.498571]  unix_release_sock+0x138/0x268
[   53.508190]  unix_release+0x20/0x38
[   53.517203]  __sock_release+0x40/0xb8
[   53.526390]  sock_close+0x14/0x20
[   53.535243]  __fput+0x88/0x1b0
[   53.543818]  ____fput+0xc/0x18
[   53.552379]  task_work_run+0x90/0xb0
[   53.561486]  do_exit+0x350/0x9a8
[   53.570250]  do_group_exit+0x34/0x98
[   53.579335]  get_signal+0xac/0x618
[   53.588266]  do_signal+0x8c/0x2a0
[   53.597122]  do_notify_resume+0xd0/0x110
[   53.606623]  work_pending+0x8/0x10
[   53.615588] Code: b9001260 a9400282 a9007e9f f9000440 (f9000002)
[   53.627346] ---[ end trace 6e44f0c23e5d9fb6 ]---
[   53.637660] Fixing recursive fault but reboot is needed!

Broadcast message from systemd-journald@hikey (Sun 2019-03-24 19:24:42 UTC):

kernel[3032]: [   53.165047] Internal error: Oops: 96000044 [#2] PREEMPT SMP


Broadcast message from systemd-journald@hikey (Sun 2019-03-24 19:24:42 UTC):

kernel[3032]: [   53.214090] Process hackbench (pid: 5624, stack limit
= 0x0000000092e9188f)


Broadcast message from systemd-journald@hikey (Sun 2019-03-24 19:24:42 UTC):

kernel[3032]: [   53.615588] Code: b9001260 a9400282 a9007e9f f9000440
(f9000002)

[   54.489871] hisi_thermal f7030700.tsensor: THERMAL ALARM stopped:
61675 < 65000
[   74.654864] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[   74.666836] rcu: 2-...0: (1 GPs behind)
idle=daa/1/0x4000000000000000 softirq=3834/3912 fqs=2623
[   74.681934] rcu: (detected by 5, t=5252 jiffies, g=2345, q=677)
[   74.694094] Task dump for CPU 2:
[   74.703435] hackbench       R  running task        0  5616      1 0x0000022e
[   74.716735] Call trace:
[   74.725367]  __switch_to+0xe8/0x148
[   74.735044]            (null)
[   74.744269] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[   74.756718] rcu: 2-...0: (1 GPs behind)
idle=daa/1/0x4000000000000000 softirq=3836/3912 fqs=2623
[   74.772141] rcu: (detected by 5, t=5273 jiffies, g=2645, q=16353)
[   74.784812] Task dump for CPU 2:
[   74.794529] hackbench       R  running task        0  5616      1 0x0000022e
[   74.808210] Call trace:
[   74.817173]  __switch_to+0xe8/0x148
[   74.827156]            (null)
[  137.674820] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[  137.687231] rcu: 2-...0: (1 GPs behind)
idle=daa/1/0x4000000000000000 softirq=3834/3912 fqs=10479
[  137.702783] rcu: (detected by 5, t=21007 jiffies, g=2345, q=677)
[  137.715437] Task dump for CPU 2:
[  137.725159] hackbench       R  running task        0  5616      1 0x0000022e
[  137.738781] Call trace:
[  137.747752]  __switch_to+0xe8/0x148
[  137.757797]            (null)
[  137.767359] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[  137.780138] rcu: 2-...0: (1 GPs behind)
idle=daa/1/0x4000000000000000 softirq=3836/3912 fqs=10464
[  137.795939] rcu: (detected by 5, t=21029 jiffies, g=2645, q=16636)
[  137.808940] Task dump for CPU 2:
[  137.818844] hackbench       R  running task        0  5616      1 0x0000022e
[  137.832327] Call trace:
[  137.840756]  __switch_to+0xe8/0x148
[  137.850166]            (null)
[  185.305855] audit: type=1701 audit(1553455613.779:3):
auid=4294967295 uid=993 gid=990 ses=4294967295 pid=2943
comm=\"systemd-network\" exe=\"/lib/systemd/systemd-networkd\" sig=6
res=1
[  185.326450] dwmmc_k3 f723d000.dwmmc0: Unexpected interrupt latency
[  200.694868] rcu: INFO: rcu_sched detected stalls on CPUs/tasks:

Ref:
https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/build/v4.19.122-49-g6d5c161fb73d/testrun/1429265/log
https://qa-reports.linaro.org/lkft/linux-stable-rc-4.19-oe/build/v4.19.122-49-g6d5c161fb73d/testrun/1429265

kernel config:
https://builds.tuxbuild.com/CiEjvux-yM6p2wRSLY2A0Q/kernel.config

-- 
Linaro LKFT
https://lkft.linaro.org
