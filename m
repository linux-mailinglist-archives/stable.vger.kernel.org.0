Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC58764BAD2
	for <lists+stable@lfdr.de>; Tue, 13 Dec 2022 18:17:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236230AbiLMRRf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Dec 2022 12:17:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236212AbiLMRRe (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Dec 2022 12:17:34 -0500
Received: from mail-lj1-x22d.google.com (mail-lj1-x22d.google.com [IPv6:2a00:1450:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF99520F5A
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 09:17:33 -0800 (PST)
Received: by mail-lj1-x22d.google.com with SMTP id f16so3972913ljc.8
        for <stable@vger.kernel.org>; Tue, 13 Dec 2022 09:17:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=zxE5lRszqVM0ouHR0vbvVZ4o1ASwrAhhJIoATFIJCtw=;
        b=AsanEacweZDmYofQrypHGYVQOYQhWMaQ7DPTbTDeAqGm981okOHeLFgqt8+bPsalFC
         YQbr+zOzUQoXjCvCeRdW7KjI3GLRCQ1oliWiRi+imvIXQgLs/KON33vHPcuaIF2lK2jh
         ORLobf+h6t/ybb2R2gUGmyFh0waeyLQYzhMzI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zxE5lRszqVM0ouHR0vbvVZ4o1ASwrAhhJIoATFIJCtw=;
        b=wjwaxTR8mr4rKE5lNC1oid6jqtg+HW5mM2rw6R0lQSKWhm06k7i/21B8f/gTEXNzhB
         7ozHqCJ+pLIxpjqv/am+6vYFx1NPsL164AY4N6gECcQyh0BDwNJcl/kMGkBPgvN/VpLa
         kKLNIAxFZrf7wUoYtFjuDH2NkDYc/utHvWykjA8Ptk1Kq+IDugDphwBqZhXBy1eq0P/q
         GWrOM6cRRZWxM3R3+ldfqc1gXIFo6AjhJ2+8OWwWAt9NswU77t/gx0pWy/DV9+efI03D
         02k2FSdDJblQq3xGKlZpK+Or4F7ShSzPB6Tke9ZqFwlvlR78jR+lkWKsrMUuPrpw+1cF
         PgAQ==
X-Gm-Message-State: ANoB5pnV+icO9APy1UDgHdGbICPWG/hkjW4dbEcJW61pUso+QVT5hTa1
        B3sZQj6fEoWCrX3UD1+5l0+HXXY+1d6PZR9zpRiUXqUnUfycfvxx
X-Google-Smtp-Source: AA0mqf7PmojIa/MT3BQvSbSqqZ1O3bxkA4hdVH4RRavcZHM03v32wnRjGtbnouskp7AfYdJTHFDcAYKcdQsgm2bADVU=
X-Received: by 2002:a05:651c:90a:b0:277:309:73cb with SMTP id
 e10-20020a05651c090a00b00277030973cbmr32805994ljq.371.1670951851591; Tue, 13
 Dec 2022 09:17:31 -0800 (PST)
MIME-Version: 1.0
From:   Joel Fernandes <joel@joelfernandes.org>
Date:   Tue, 13 Dec 2022 12:17:20 -0500
Message-ID: <CAEXW_YR=DvPhk5JWUe7gYHeVsn5d4Wba83x2UB9uqP0EURgk1g@mail.gmail.com>
Subject: Please apply to v5.10 stable: 29368e093921 ("x86/smpboot: Move
 rcu_cpu_starting() earlier")
To:     stable <stable@vger.kernel.org>
Cc:     "Paul E. McKenney" <paulmck@kernel.org>, rcu <rcu@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,

Please apply to the stable v5.10 kernel, the commit: 29368e093921
("x86/smpboot:  Move rcu_cpu_starting() earlier").

It made it into the mainline in 5.11.  I am able to reproduce the
following splat without it on v5.10 stable, which is identical to the
one that the commit fixed:

[   42.628511] =============================
[   42.628512] WARNING: suspicious RCU usage
[   42.628513] 5.10.156+ #7 Not tainted
[   42.628514] -----------------------------
[   42.628516] kernel/locking/lockdep.c:3621 RCU-list traversed in
non-reader section!!
[   42.628516]
[   42.628517] other info that might help us debug this:
[   42.628518]
[   42.628519]
[   42.628519] RCU used illegally from offline CPU!
[   42.628520] rcu_scheduler_active = 1, debug_locks = 1
[   42.628521] no locks held by swapper/1/0.
[   42.628522]
[   42.628522] stack backtrace:
[   42.628523] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.10.156+ #7
[   42.628540] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS 1.16.0-debian-1.16.0-4 04/01/2014
[   42.628541] Call Trace:
[   42.628541]
[   42.628542] =============================
[   42.628543] WARNING: suspicious RCU usage
[   42.628544] 5.10.156+ #7 Not tainted
[   42.628561] -----------------------------
[   42.628563] kernel/kprobes.c:300 RCU-list traversed in non-reader section!!
[   42.628563]
[   42.628564] other info that might help us debug this:
[   42.628565]
[   42.628566]
[   42.628567] RCU used illegally from offline CPU!
[   42.628568] rcu_scheduler_active = 1, debug_locks = 1
[   42.628569] no locks held by swapper/1/0.
[   42.628570]
[   42.628570] stack backtrace:
[   42.628571] CPU: 1 PID: 0 Comm: swapper/1 Not tainted 5.10.156+ #7
[   42.628573] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS 1.16.0-debian-1.16.0-4 04/01/2014
[   42.628573] Call Trace:
[   42.628574]  dump_stack+0x77/0x9b
[   42.628575]  __is_insn_slot_addr+0x156/0x170
[   42.628576]  kernel_text_address+0xb1/0xe0
[   42.628577]  ? get_stack_info+0x2b/0x80
[   42.628578]  __kernel_text_address+0x9/0x40
[   42.628578]  show_trace_log_lvl+0x223/0x2f0
[   42.628579]  ? dump_stack+0x77/0x9b
[   42.628580]  dump_stack+0x77/0x9b
[   42.628581]  __lock_acquire.cold+0x326/0x330
[   42.628581]  lock_acquire+0xbd/0x2a0
[   42.628582]  ? vprintk_emit+0x6c/0x310
[   42.628583]  _raw_spin_lock+0x27/0x40
[   42.628584]  ? vprintk_emit+0x6c/0x310
[   42.628584]  vprintk_emit+0x6c/0x310
[   42.628585]  printk+0x63/0x7e
[   42.628586]  start_secondary+0x1c/0xf0
[   42.628587]  secondary_startup_64_no_verify+0xc2/0xcb
[   42.628588]  dump_stack+0x77/0x9b
[   42.628588]  __lock_acquire.cold+0x326/0x330
[   42.628589]  lock_acquire+0xbd/0x2a0
[   42.628590]  ? vprintk_emit+0x6c/0x310
[   42.628591]  _raw_spin_lock+0x27/0x40
[   42.628591]  ? vprintk_emit+0x6c/0x310
[   42.628592]  vprintk_emit+0x6c/0x310

Thanks,

 - Joel
