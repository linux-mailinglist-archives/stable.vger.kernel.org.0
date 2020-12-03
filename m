Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E7F32CCBDD
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 02:53:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727134AbgLCBvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 2 Dec 2020 20:51:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726263AbgLCBvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 2 Dec 2020 20:51:13 -0500
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F13A7C061A4D;
        Wed,  2 Dec 2020 17:50:26 -0800 (PST)
Received: by mail-qt1-x82d.google.com with SMTP id o1so329795qtp.5;
        Wed, 02 Dec 2020 17:50:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=kyVim3g1ZgvCklZC8yhQqBOa4C12iOCyA31F5yUOrys=;
        b=jEdgYTBEjvWRNu7WJU73JtcD71zfKPuyCc8Etm/KnZTTd7SkZiI+xTlD9n8zScGPaP
         CoeiYvjqXDCAHwsXUDBsb3jEvnrI3J/0tZePofy8ooE+SfxkX3wbpqfzkWfniVWJVQ17
         F3a/ebV0+UvoyJDUDKhLZFVFmF3JyChSkMI9Dae62DBr3xn9JW6XMgCQ9kePrnnU2zqv
         loLmEMxsTeazv7vyOL/06syD3WlvBg2D3rt3BLR5aggaoyqbqXjZDzqRaD66qLEYCufD
         dpXnx2qmirnPu7fAl92ifmZr7mufiY6SA3J8ePVKUlP2SnLm4TC/owQMZ0MSL64hL+p/
         RIEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=kyVim3g1ZgvCklZC8yhQqBOa4C12iOCyA31F5yUOrys=;
        b=otjpg+yGD853tVxSZfYlQ0nuHq7bZ+b2QXTGnFctq3rVtf0l3PckgXYZzB5XNMYFpp
         BsQSzMbf5da/Pb9A9372zcKv5l8DULchSfnPXFpU+Xn/Adz3fqIdvF9izBwoVH+p13WY
         RyuR3fyzJ0tZYWXmn4nNJOgSWCpJCBnGJI+4Mx6H4Dzx/oiBsbu1TICZt6tZj6em4joX
         rQVKeezKXd/O4MOLk7PvNb/KHJh5gkbRYs6DJZTFmku8X1judRSmMiWOz6A1pbJWdDDT
         xpOJ1UWuKBO9/EuzcFicVAKJbxYZML+uSKEXDR0RHw51mrnMPe3QcAsJ2lO/3ww13vVU
         KnDw==
X-Gm-Message-State: AOAM532VHeEb2BDB9gUGLqeKoF4nQOXORrKosj2TAkpusjAwLfVBK68D
        Ly4juwzvSb3zTHBWmajWRMA=
X-Google-Smtp-Source: ABdhPJzyhjiLB/riNKk41l4mTm9zv6wmMCtqzIxV93yXnHPAIrM+H9FNH8gFLfJOjYre2VsMVPmtqg==
X-Received: by 2002:aed:2664:: with SMTP id z91mr1128689qtc.290.1606960226216;
        Wed, 02 Dec 2020 17:50:26 -0800 (PST)
Received: from auth1-smtp.messagingengine.com (auth1-smtp.messagingengine.com. [66.111.4.227])
        by smtp.gmail.com with ESMTPSA id g143sm580100qke.102.2020.12.02.17.50.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Dec 2020 17:50:25 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailauth.nyi.internal (Postfix) with ESMTP id 9CB7927C0054;
        Wed,  2 Dec 2020 20:50:22 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 02 Dec 2020 20:50:22 -0500
X-ME-Sender: <xms:XkTIX0G7jmr8f1-vj4Xdo-bW9dyrFEO6w_z-ofb5SHE5XVxylJCm7A>
    <xme:XkTIX9U85OCP3HyU_OlELGpNgjgempOOQyInro2p9knQd4UQ4ZSl4k9DxKQ2XfrR8
    gASUd6IrjwjkkLNyA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudeihedgfeekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhquhhn
    ucfhvghnghcuoegsohhquhhnrdhfvghnghesghhmrghilhdrtghomheqnecuggftrfgrth
    htvghrnhepgeektddvtdekleetvdekffevleelkefffeegiedvffeufffhiefggfehffdv
    vdegnecuffhomhgrihhnpehkvghrnhgvlhdrohhrghdplhhinhgrrhhordhorhhgnecukf
    hppeduieejrddvvddtrddvrdduvdeinecuvehluhhsthgvrhfuihiivgeptdenucfrrghr
    rghmpehmrghilhhfrhhomhepsghoqhhunhdomhgvshhmthhprghuthhhphgvrhhsohhnrg
    hlihhthidqieelvdeghedtieegqddujeejkeehheehvddqsghoqhhunhdrfhgvnhhgpeep
    ghhmrghilhdrtghomhesfhhigihmvgdrnhgrmhgv
X-ME-Proxy: <xmx:XkTIX-KckZHR-_CTMh8gcf7mwyojqPs0lYyaAAWXZbyT3jYy1RhGDw>
    <xmx:XkTIX2FELq8U_wOJI1581Bw8vaVg2U95H9vtVl8fmqdDxzBt_lrBTA>
    <xmx:XkTIX6UH0os_M18AQpb3-zShx8Nf3tYWIlTdq7piKdbOK3DDTv3MVA>
    <xmx:XkTIX2Q_UVC9giMe6nVnaPol8vEb05YhW2YnX0w0ERZBM4bN7j1FQWSClX0>
Received: from localhost (unknown [167.220.2.126])
        by mail.messagingengine.com (Postfix) with ESMTPA id CCAF4240059;
        Wed,  2 Dec 2020 20:50:21 -0500 (EST)
Date:   Thu, 3 Dec 2020 09:49:22 +0800
From:   Boqun Feng <boqun.feng@gmail.com>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>, rcu@vger.kernel.org,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Will Deacon <will@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        "Paul E. McKenney" <paulmck@kernel.org>
Subject: Re: [arm64] db410c: BUG: Invalid wait context
Message-ID: <20201203014922.GA1785576@boqun-archlinux>
References: <CA+G9fYupbQK02Yor=U-80JEdkwacZ7bi3RKt3+D=e+qZ-o0uCA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYupbQK02Yor=U-80JEdkwacZ7bi3RKt3+D=e+qZ-o0uCA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Naresh,

On Wed, Dec 02, 2020 at 10:15:44AM +0530, Naresh Kamboju wrote:
> While running kselftests on arm64 db410c platform "BUG: Invalid wait context"
> noticed at different runs this specific platform running stable-rc 5.9.12-rc1.
> 
> While running these two test cases we have noticed this BUG and not easily
> reproducible.
> 
> # selftests: bpf: test_xdp_redirect.sh
> # selftests: net: ip6_gre_headroom.sh
> 
> [  245.694901] kauditd_printk_skb: 100 callbacks suppressed
> [  245.694913] audit: type=1334 audit(251.699:25757): prog-id=12883 op=LOAD
> [  245.735658] audit: type=1334 audit(251.743:25758): prog-id=12884 op=LOAD
> [  245.801299] audit: type=1334 audit(251.807:25759): prog-id=12885 op=LOAD
> [  245.832034] audit: type=1334 audit(251.839:25760): prog-id=12886 op=LOAD
> [  245.888601]
> [  245.888631] =============================
> [  245.889156] [ BUG: Invalid wait context ]
> [  245.893071] 5.9.12-rc1 #1 Tainted: G        W
> [  245.897056] -----------------------------
> [  245.902091] pool/1279 is trying to lock:
> [  245.906083] ffff000032fc1218
> (&child->perf_event_mutex){+.+.}-{3:3}, at:
> perf_event_exit_task+0x34/0x3a8
> [  245.910085] other info that might help us debug this:
> [  245.919539] context-{4:4}
> [  245.924484] 1 lock held by pool/1279:
> [  245.927087]  #0: ffff8000127819b8 (rcu_read_lock){....}-{1:2}, at:
> dput+0x54/0x460
> [  245.930739] stack backtrace:
> [  245.938203] CPU: 1 PID: 1279 Comm: pool Tainted: G        W
> 5.9.12-rc1 #1
> [  245.941243] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
> [  245.948621] Call trace:
> [  245.955390]  dump_backtrace+0x0/0x1f8
> [  245.957560]  show_stack+0x2c/0x38
> [  245.961382]  dump_stack+0xec/0x158
> [  245.964679]  __lock_acquire+0x59c/0x15c8
> [  245.967978]  lock_acquire+0x124/0x4d0
> [  245.972058]  __mutex_lock+0xa4/0x970
> [  245.975615]  mutex_lock_nested+0x54/0x70
> [  245.979261]  perf_event_exit_task+0x34/0x3a8
> [  245.983168]  do_exit+0x394/0xad8
> [  245.987420]  do_group_exit+0x4c/0xa8
> [  245.990633]  get_signal+0x16c/0xb40
> [  245.994193]  do_notify_resume+0x2ec/0x678
> [  245.997404]  work_pending+0x8/0x200
> 

For the PoV of lockdep, this means some one tries to acquire a mutex
inside an RCU read-side critical section, which is bad, because one can
not sleep (voluntarily) inside RCU.

However I don't think it's the true case here, because 1) normally
people are very careful not putting mutex or other sleepable locks
inside RCU and 2) in the above splats, lockdep find the rcu read lock is
held at dput() while the acquiring of the mutex is at ret_to_user(),
clearly there is no call site (in the same context) from the RCU
read-side critial section of dput() to ret_to_user().

One chance of hitting this is that there is a bug in context/irq tracing
that makes the contexts of dput() and ret_to_user() as one contexts so
that lockdep gets confused and reports a false postive.

FWIW, I think this might be related to some know issues for ARM64 with
lockdep and irq tracing:

	https://lore.kernel.org/lkml/20201119225352.GA5251@willie-the-truck/

And Mark already has series to fix them:

	https://git.kernel.org/pub/scm/linux/kernel/git/mark/linux.git/log/?h=arm64/irq-fixes

But I must defer to Mark for the latest fix ;-)

Regards,
Boqun

> and BUG in an other run,
> 
> [ 1012.068407] audit: type=1700 audit(1018.803:25886): dev=eth0 prom=0
> old_prom=256 auid=4294967295 uid=0 gid=0 ses=4294967295
> [ 1012.250561] IPv6: ADDRCONF(NETDEV_CHANGE): swp1: link becomes ready
> [ 1012.251298] IPv6: ADDRCONF(NETDEV_CHANGE): h1: link becomes ready
> [ 1012.252559]
> [ 1012.261892] =============================
> [ 1012.263453] [ BUG: Invalid wait context ]
> [ 1012.267363] 5.9.12-rc1 #1 Tainted: G        W
> [ 1012.271354] -----------------------------
> [ 1012.276389] systemd/454 is trying to lock:
> [ 1012.280381] ffff00003985a918 (&mm->mmap_lock){++++}-{3:3}, at:
> __might_fault+0x60/0xa8
> [ 1012.284378] other info that might help us debug this:
> [ 1012.292275] context-{4:4}
> [ 1012.297396] 1 lock held by systemd/454:
> [ 1012.299997]  #0: ffff8000127d1f38 (rcu_read_lock){....}-{1:2}, at:
> path_init+0x40/0x718
> [ 1012.303649] stack backtrace:
> [ 1012.311638] CPU: 2 PID: 454 Comm: systemd Tainted: G        W
>   5.9.12-rc1 #1
> [ 1012.314760] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
> [ 1012.322139] Call trace:
> [ 1012.329084]  dump_backtrace+0x0/0x1f8
> [ 1012.331254]  show_stack+0x2c/0x38
> [ 1012.335075]  dump_stack+0xec/0x158
> [ 1012.338371]  __lock_acquire+0x59c/0x15c8
> [ 1012.341672]  lock_acquire+0x124/0x4d0
> [ 1012.345751]  __might_fault+0x84/0xa8
> [ 1012.349311]  cp_new_stat+0x114/0x1b8
> [ 1012.352956]  __do_sys_newfstat+0x44/0x70
> [ 1012.356513]  __arm64_sys_newfstat+0x24/0x30
> [ 1012.358652] IPv6: ADDRCONF(NETDEV_CHANGE): swp3: link becomes ready
> [ 1012.360424]  el0_svc_common.constprop.3+0x7c/0x198
> [ 1012.370575]  do_el0_svc+0x34/0xa0
> [ 1012.375437]  el0_sync_handler+0x16c/0x210
> [ 1012.378824]  el0_sync+0x140/0x180
> 
> 
> Full test log links,
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.y/build/v5.9.11-153-gfb49ad2107f4/testrun/3516257/suite/linux-log-parser/test/check-kernel-bug-1997042/log
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.9.y/build/v5.9.11-153-gfb49ad2107f4/testrun/3515038/suite/linux-log-parser/test/check-kernel-bug-1996797/log
> 
> metadata:
>   git branch: linux-5.9.y
>   git commit: fb49ad2107f4b740257c84ec2991fc6afb447f53
>   git describe: v5.9.11-153-gfb49ad2107f4
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   kernel-config:
> http://snapshots.linaro.org/openembedded/lkft/lkft/sumo/dragonboard-410c/lkft/linux-stable-rc-5.9/44/config
> 
> -- 
> Linaro LKFT
> https://lkft.linaro.org
