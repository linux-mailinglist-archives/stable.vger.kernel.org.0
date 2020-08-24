Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E0E52506F1
	for <lists+stable@lfdr.de>; Mon, 24 Aug 2020 19:53:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726075AbgHXRxO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Aug 2020 13:53:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725905AbgHXRxN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Aug 2020 13:53:13 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E8DC061574
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 10:53:13 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id d139so3197316qke.11
        for <stable@vger.kernel.org>; Mon, 24 Aug 2020 10:53:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=F6L9gJYSM3CFnfhDCdV5J1S0uEAPlOKwat0cu3mLPwk=;
        b=iX6voTRcSoNkg4iEGUGoccrWQDqKXamQl9YWfzWPv2FkfOUzoZz5gVN6x7NAaGPYpI
         Yc4/ghzZX+GoIWHDWFvNLY8UyKCc/7IntTwVnzy/x2JBE7CmP1JmTtks+2fXfK4+Vh3S
         6BWDOPDZs1Ry1fO4LnKFSfqeTjyUp3H221lWZM5Io1OCrbTv2O9wqA3HGrjUQyYLkPJr
         FlZ6N2oltUhezOIMG1SkVH6B25x/1OIha6+e46Vjj8bqDpjQ6x9dssUmv189fP1Qozww
         yYsKERIQ4C2oW2FXhzcomkGhIVcBhJQ0yT5Xuul5i6r7PoAV3ioZDXZvXsR4FrEXL/yD
         W32Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=F6L9gJYSM3CFnfhDCdV5J1S0uEAPlOKwat0cu3mLPwk=;
        b=tLn5MX7cx8zAg6/6y+AblMRuNbQHaPR3VZdpNOlSzFesfGpqwt0GLtYpJ/G+QzClZg
         cZjTObEh9/n3VyqSunSDiOtFJZMu8scDbBUWAVjgmkubSesDKX6aKLTRWMX8ADsyp5Vm
         l1yT+c+vKxTfdEjD9EIThORpQPUVPGPyhBH2RbYgh2dK8vily2OQG0/70Mj8unLOuTyi
         JK6GrChbZM5MTHg1UftdX3xvfcmTr8J+Lejjm/tWe83QzjJ5SqnJ4hBLdO8ozyHMo+hO
         ZaurdIxt+ZIlDzKYopNw1/Q6GIuSnvRyJvwwOKHAMZeyUT/paKv1eBAhc0N44z9wIveH
         gFXg==
X-Gm-Message-State: AOAM531gol6UR1TsvzsU3d3Hgh+cpXLGJpnJEjY1hqIpZiuKuazJYyUp
        0FeyXFfupnAEg3pwy7kQwm2gGQ==
X-Google-Smtp-Source: ABdhPJzwY8PQBX23G8M7rQvXZAvG1LMZd4PrzCK7N5y0oEc4p9QrcdOnZioE67HlMSivrQZn3Tiasw==
X-Received: by 2002:a37:9a93:: with SMTP id c141mr5601938qke.145.1598291591287;
        Mon, 24 Aug 2020 10:53:11 -0700 (PDT)
Received: from lca.pw (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id b206sm7405981qkc.11.2020.08.24.10.53.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2020 10:53:10 -0700 (PDT)
Date:   Mon, 24 Aug 2020 13:53:08 -0400
From:   Qian Cai <cai@lca.pw>
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     open list <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, X86 ML <x86@kernel.org>,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, green.hu@gmail.com,
        Christian Brauner <christian.brauner@ubuntu.com>,
        tsbogend@alpha.franken.de, jpoimboe@redhat.com,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>
Subject: Re: WARNING: kernel stack regs at 00000000d9dac8ad in fork13:28354
 has bad 'bp' value 0000000000000000
Message-ID: <20200824175307.GD4337@lca.pw>
References: <CA+G9fYvyrY7FEM18OK1XVF7-C=_FPiwsss-3_TCXrSbPwyJgGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+G9fYvyrY7FEM18OK1XVF7-C=_FPiwsss-3_TCXrSbPwyJgGQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 24, 2020 at 10:21:51PM +0530, Naresh Kamboju wrote:
> on x86_64 kasan enabled build this kernel warning noticed while running
> LTP syscalls fork13 test case.
> 
> metadata:
>   git branch: linux-5.8.y
>   git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
>   git commit: 8960c0bf1993f3bdce3a3de5f03aaf5755f661e5
>   git describe: v5.8.3-149-g8960c0bf1993
>   make_kernelversion: 5.8.4-rc1
>   kernel-config:
> https://builds.tuxbuild.com/VSP7j-bv11LJRxPxnvOq_w/kernel.config
> 
> 
> steps to reproduce:
> - boot x86_64 kasan enabled kernel
> - run ltp fork13 test case
> - cd /opt/ltp/testcases/bin
> - ./fork13 -i 1000000

I saw something like this before using the trinity fuzzer. I stop chasing it
because I have no luck to reproduce it easily. How reproducible is this for
you?

> 
> 
> [  928.754534] WARNING: kernel stack regs at 00000000d9dac8ad in
> fork13:28354 has bad 'bp' value 0000000000000000
> [  928.754536] unwind stack type:0 next_sp:0000000000000000 mask:0x6 graph_idx:0
> [  928.754541] 00000000908d9a89: ffff88841fb89ad0 (0xffff88841fb89ad0)
> [  928.754546] 00000000713a6f3f: ffffffffb6b2524c (arch_stack_walk+0x8c/0xf0)
> [  928.754548] 00000000a333e33a: 0000000000000000 ...
> [  928.754550] 000000001f131381: ffff888410c68000 (0xffff888410c68000)
> [  928.754553] 00000000ac56adaf: ffff888410c70000 (0xffff888410c70000)
> [  928.754554] 00000000499c7993: 0000000000000000 ...
> [  928.754556] 0000000066f48100: 0000000000000006 (0x6)
> [  928.754558] 0000000040f166c1: ffff888370a0de80 (0xffff888370a0de80)
> [  928.754560] 00000000c1358a0a: 0000010100000000 (0x10100000000)
> [  928.754561] 00000000443f0920: 0000000000000000 ...
> [  928.754564] 00000000f5fcc5eb: ffff88841fb89a38 (0xffff88841fb89a38)
> [  928.754568] 000000000ef6da08: ffffffffb6a02be0 (ret_from_fork+0x10/0x30)
> [  928.754569] 000000009addfc01: 0000000000000000 ...
> [  928.754571] 0000000022937aad: ffff888410c6fea8 (0xffff888410c6fea8)
> [  928.754574] 0000000087461b55: 664ad2b25ee06300 (0x664ad2b25ee06300)
> [  928.754576] 00000000f22c5014: ffffed1083f7135c (0xffffed1083f7135c)
> [  928.754578] 00000000107b8b83: 0000000000000800 (0x800)
> [  928.754580] 000000004da2ec53: ffff88840506bc40 (0xffff88840506bc40)
> [  928.754582] 000000005cd5c950: ffff88841dc03800 (0xffff88841dc03800)
> [  928.754585] 000000009a4f2b77: ffff88841fb89b68 (0xffff88841fb89b68)
> [  928.754590] 0000000004a910d6: ffffffffb6d1f9c4 (stack_trace_save+0x94/0xc0)
> [  928.754592] 00000000f32d9cce: 0000000041b58ab3 (0x41b58ab3)
> [  928.754597] 0000000098ca7ca5: ffffffffb8e094cc (.LC0+0x3362/0xd896)
> [  928.754601] 000000000d66da7d: ffffffffb6d1f930
> (stack_trace_consume_entry+0x90/0x90)
> [  928.754603] 00000000b7422065: 0000000000000131 (0x131)
> [  928.754605] 00000000d72ffaa0: ffff88841fb89b78 (0xffff88841fb89b78)
> [  928.754607] 000000000a6419c1: 0000000000000040 (0x40)
> [  928.754609] 0000000037248aa1: 000000000000000f (0xf)
> [  928.754610] 00000000abdbdb84: 0000000000000000 ...
> [  928.754612] 0000000003573c3a: ffff88841dd7f400 (0xffff88841dd7f400)
> [  928.754617] 00000000e5cbebfd: ffffffffb6c43c10
> (child_wait_callback+0x100/0x100)
> [  928.754619] 000000009cd94b8b: ffff88841fb89d50 (0xffff88841fb89d50)
> [  928.754623] 00000000ef01908b: ffffffffb6f1ef52 (save_stack+0x42/0x50)
> [  928.754626] 00000000f51ece9d: ffffffffb6f1ef33 (save_stack+0x23/0x50)
> [  928.754629] 0000000008f796f9: ffff88841df15600 (0xffff88841df15600)
> [  928.754631] 000000002a34dcbb: 664ad2b25ee06300 (0x664ad2b25ee06300)
> [  928.754633] 0000000075fa49a4: 0000000000000001 (0x1)
> [  928.754635] 0000000072ccf51e: ffff88841fb89d80 (0xffff88841fb89d80)
> [  928.754638] 00000000db7a013f: ffffffffb6f1ef33 (save_stack+0x23/0x50)
> [  928.754642] 00000000c99d8de7: ffffffffb6f1ef33 (save_stack+0x23/0x50)
> [  928.754645] 00000000f5b105c3: ffffffffb6f1f097
> (__kasan_slab_free+0x137/0x180)
> [  928.754649] 00000000a195921a: ffffffffb6f1f70e (kasan_slab_free+0xe/0x10)
> [  928.754652] 00000000eaf32c2c: ffffffffb6f1cea8 (kfree+0x98/0x240)
> [  928.754657] 0000000003a3d4ee: ffffffffb722793a (security_cred_free+0x6a/0x90)
> [  928.754661] 0000000081df44fc: ffffffffb6c86eb9 (put_cred_rcu+0x49/0x160)
> [  928.754664] 00000000def4eebb: ffffffffb6d13e8a (rcu_core+0x37a/0xc80)
> [  928.754668] 00000000ccf0e376: ffffffffb6d1479e (rcu_core_si+0xe/0x10)
> [  928.754672] 0000000081e253b5: ffffffffb8400160 (__do_softirq+0x160/0x467)
> [  928.754675] 00000000a4956b3b: ffffffffb8200f82 (asm_call_on_stack+0x12/0x20)
> [  928.754680] 000000006f1e3f6a: ffffffffb6b0e9af
> (do_softirq_own_stack+0x3f/0x50)
> [  928.754684] 00000000d6c45a50: ffffffffb6c4a69f (irq_exit_rcu+0xff/0x110)
> [  928.754688] 000000008d42b2e0: ffffffffb81aca68
> (sysvec_apic_timer_interrupt+0x38/0x90)
> [  928.754692] 0000000064c4c87d: ffffffffb8200c42
> (asm_sysvec_apic_timer_interrupt+0x12/0x20)
> [  928.754695] 0000000053a861de: ffffffffb6a02be0 (ret_from_fork+0x10/0x30)
> [  928.754696] 00000000d3e710f8: 0000000000000000 ...
> [  928.754698] 00000000939b28dd: 0000000100000001 (0x100000001)
> [  928.754700] 00000000166726c9: 0000000000000000 ...
> [  928.754702] 000000004a199aa9: 0000000000204000 (0x204000)
> [  928.754706] 0000000001bd65d9: ffffffffb901a400
> (root_mountflags+0x1c60/0x1c60)
> [  928.754708] 000000008a52f042: 0000000000000000 ...
> [  928.754710] 00000000e32080da: ffff88841fb89c30 (0xffff88841fb89c30)
> [  928.754713] 00000000c125a613: ffffffffb6f1ef04
> (__kasan_check_write+0x14/0x20)
> [  928.754716] 0000000008596419: ffff88841fb89c50 (0xffff88841fb89c50)
> [  928.754719] 00000000572202ef: ffffffffb6c8fcac (set_nr_if_polling+0x2c/0x60)
> [  928.754722] 00000000b05e066e: ffff88841fa31380 (0xffff88841fa31380)
> [  928.754723] 00000000465aa8dc: 0000000000000000 ...
> [  928.754725] 00000000c3b0a1f0: ffff88841fb89c78 (0xffff88841fb89c78)
> [  928.754730] 00000000dcd6ae89: ffffffffb6c9dc08
> (send_call_function_single_ipi+0x48/0xf0)
> [  928.754732] 00000000f47550ca: 0000000000032280 (0x32280)
> [  928.754734] 0000000066af3953: ffff88841fa313a0 (0xffff88841fa313a0)
> [  928.754736] 00000000057c28b8: ffff88841fa313a0 (0xffff88841fa313a0)
> [  928.754739] 00000000937ead47: ffff88841fb89ca8 (0xffff88841fb89ca8)
> [  928.754743] 000000002b02c73b: ffffffffb6d4e275
> (__smp_call_single_queue+0x55/0x60)
> [  928.754744] 00000000b602744d: 0000000000000000 ...
> [  928.754746] 0000000053fef878: ffff88841fb89ce0 (0xffff88841fb89ce0)
> [  928.754750] 00000000df88a55e: ffffffffb6d1a024
> (rcu_segcblist_accelerate+0xf4/0x160)
> [  928.754753] 00000000ac50318b: ffff888370a0a8d0 (0xffff888370a0a8d0)
> [  928.754754] 000000005dff8b79: 0000000000000002 (0x2)
> [  928.754757] 000000001e23ce54: ffff88841fbb20c0 (0xffff88841fbb20c0)
> [  928.754759] 00000000cfe3366f: 00000000bfab7701 (0xbfab7701)
> [  928.754761] 00000000445fd255: ffff88841fbb2110 (0xffff88841fbb2110)
> [  928.754763] 0000000054eaac2b: ffff88841fbb2110 (0xffff88841fbb2110)
> [  928.754765] 00000000bf54e941: ffff88841fbb20c0 (0xffff88841fbb20c0)
> [  928.754768] 0000000019f1e2f6: ffff88841fb89d88 (0xffff88841fb89d88)
> [  928.754771] 0000000026e375a0: ffffffffb6d12996
> (rcu_accelerate_cbs+0x96/0xbe0)
> [  928.754774] 00000000433e4156: ffffffffb8e0acc8 (.LC0+0x4b5e/0xd896)
> [  928.754779] 00000000bff23f74: ffffffffb6d3d2c0
> (posix_cpu_timers_exit_group+0x30/0x30)
> [  928.754781] 000000007f6445da: ffff88841fb89d40 (0xffff88841fb89d40)
> [  928.754784] 00000000c896ef50: ffffffffb6ca608d (kick_ilb+0x12d/0x140)
> [  928.754788] 00000000ce36df4f: ffffffffb8ebd6e0
> (intel_graphics_stolen_res+0x40/0x40)
> [  928.754791] 00000000ebc96e1c: ffff88841dc3c500 (0xffff88841dc3c500)
> [  928.754793] 00000000651157d2: ffff88841dc3c504 (0xffff88841dc3c504)
> [  928.754797] 00000000c9e845c7: ffffffffb9129548 (rcu_state+0x8/0xc20)
> [  928.754799] 000000004e722d83: ffff88841fb89d28 (0xffff88841fb89d28)
> [  928.754801] 0000000048052b14: 00000000ffffff01 (0xffffff01)
> [  928.754803] 0000000034d84484: 00000000000ac013 (0xac013)
> [  928.754806] 000000007b2eac65: ffff88841fbb20c0 (0xffff88841fbb20c0)
> [  928.754809] 00000000d50a50cf: ffffffffb9129540 (use_softirq+0x60/0x60)
> [  928.754811] 00000000486acfa2: 00000000000ac014 (0xac014)
> [  928.754813] 000000006daca0b4: ffff88841fbb20c0 (0xffff88841fbb20c0)
> [  928.754815] 0000000015cc7f50: ffff88841fbb20c0 (0xffff88841fbb20c0)
> [  928.754819] 0000000033fc3ffa: ffffffffb9129540 (use_softirq+0x60/0x60)
> [  928.754821] 000000008d4ada29: ffff88840506bc60 (0xffff88840506bc60)
> [  928.754823] 00000000b72c7012: ffff88841fb89db0 (0xffff88841fb89db0)
> [  928.754827] 0000000013131ed6: ffffffffb6f1f097
> (__kasan_slab_free+0x137/0x180)
> [  928.754829] 00000000141ace5e: ffff88840506bc40 (0xffff88840506bc40)
> [  928.754832] 000000008f18ed6b: ffffea0010141ac0 (0xffffea0010141ac0)
> [  928.754834] 00000000854484b9: ffff88841dc03800 (0xffff88841dc03800)
> [  928.754838] 00000000d8e6fa3d: ffffffffb722793a (security_cred_free+0x6a/0x90)
> [  928.754840] 00000000cd0db824: ffff88841fb89dc0 (0xffff88841fb89dc0)
> [  928.754843] 00000000d12cc674: ffffffffb6f1f70e (kasan_slab_free+0xe/0x10)
> [  928.754846] 00000000d2fe93eb: ffff88841fb89df0 (0xffff88841fb89df0)
> [  928.754849] 000000002f99711c: ffffffffb6f1cea8 (kfree+0x98/0x240)
> [  928.754850] 000000001e270a90: 0000000000000000 ...
> [  928.754852] 00000000337178b6: ffff888370c1e700 (0xffff888370c1e700)
> [  928.754854] 000000005c3c88e3: ffff888370c1e778 (0xffff888370c1e778)
> [  928.754857] 000000007f105a7c: ffff888370c1e790 (0xffff888370c1e790)
> [  928.754859] 000000007b44dd80: ffff88841fb89e18 (0xffff88841fb89e18)
> [  928.754863] 0000000063bf068a: ffffffffb722793a (security_cred_free+0x6a/0x90)
> [  928.754865] 000000003f216245: ffff888370c1e798 (0xffff888370c1e798)
> [  928.754867] 000000008589c9e2: ffff888370c1e700 (0xffff888370c1e700)
> [  928.754870] 0000000037fdebf4: ffff888370c1e7a0 (0xffff888370c1e7a0)
> [  928.754872] 0000000011170bcd: ffff88841fb89e48 (0xffff88841fb89e48)
> [  928.754876] 0000000096cc7c1a: ffffffffb6c86eb9 (put_cred_rcu+0x49/0x160)
> [  928.754878] 0000000070879447: ffff888370a0de80 (0xffff888370a0de80)
> [  928.754880] 00000000682e6d5c: ffff888370c1e798 (0xffff888370c1e798)
> [  928.754882] 0000000017bd914a: ffff888370c1e7a0 (0xffff888370c1e7a0)
> [  928.754885] 00000000e9fdeb0a: ffff88841fbb2110 (0xffff88841fbb2110)
> [  928.754887] 00000000878de49a: ffff88841fb89f50 (0xffff88841fb89f50)
> [  928.754890] 0000000087802692: ffffffffb6d13e8a (rcu_core+0x37a/0xc80)
> [  928.754892] 00000000877e0f44: 000000001fb89f40 (0x1fb89f40)
> [  928.754894] 000000002fbb38c9: ffff88841fbb2110 (0xffff88841fbb2110)
> [  928.754897] 0000000018de5cdc: ffff88841fbb20c0 (0xffff88841fbb20c0)
> [  928.754899] 00000000241aa4ea: ffff88841fbb2178 (0xffff88841fbb2178)
> [  928.754901] 000000004062f053: ffff88841fbb2158 (0xffff88841fbb2158)
> [  928.754903] 00000000a414ceab: 000000000000000a (0xa)
> [  928.754904] 00000000c8e44445: 0000000000000000 ...
> [  928.754906] 0000000041c7dc5a: ffff88841fb89ec8 (0xffff88841fb89ec8)
> [  928.754908] 00000000c535acba: 0000000000000202 (0x202)
> [  928.754910] 000000003ae773c1: 1ffff11083f713d5 (0x1ffff11083f713d5)
> [  928.754912] 00000000142abd02: 0000000041b58ab3 (0x41b58ab3)
> [  928.754916] 000000001e373199: ffffffffb8e08c03 (.LC0+0x2a99/0xd896)
> [  928.754919] 00000000c1de8fa0: ffffffffb6d13b10
> (rcu_accelerate_cbs_unlocked+0xa0/0xa0)
> [  928.754922] 0000000034ba5504: ffff88841fb9f480 (0xffff88841fb9f480)
> [  928.754924] 00000000f8bf3cbb: ffff888370c1e198 (0xffff888370c1e198)
> [  928.754926] 00000000c67e6ed5: ffff888370c1e198 (0xffff888370c1e198)
> [  928.754929] 000000009738e749: ffffffffffffffff (0xffffffffffffffff)
> [  928.754933] 00000000de4b30f7: ffffffffb6d41049
> (clockevents_program_event+0xf9/0x160)
> [  928.754934] 000000005c5e2481: 0000000000000000 ...
> [  928.754936] 000000001c17fec4: 000000d7ff8aaaca (0xd7ff8aaaca)
> [  928.754939] 000000004eb3090f: ffff88841fb9f480 (0xffff88841fb9f480)
> [  928.754941] 00000000c5a20623: ffff888370a0de80 (0xffff888370a0de80)
> [  928.754944] 00000000d725334d: ffffffffb84000e1 (__do_softirq+0xe1/0x467)
> [  928.754946] 00000000a6e6a75b: 0000000000000000 ...
> [  928.754949] 000000008550bcb4: ffffffffb8200f82 (asm_call_on_stack+0x12/0x20)
> [  928.754951] 00000000b72a8966: 664ad2b25ee06300 (0x664ad2b25ee06300)
> [  928.754954] 000000009e71c01b: ffffffffb9009108 (softirq_vec+0x48/0x80)
> [  928.754956] 000000008e3f22f5: 0000000000000009 (0x9)
> [  928.754958] 000000002f829dec: 000000000000000a (0xa)
> [  928.754960] 000000002b9e876f: 0000000000000009 (0x9)
> [  928.754961] 00000000939823af: 0000000000000009 (0x9)
> [  928.754964] 000000004caecea0: ffff88841fb89f60 (0xffff88841fb89f60)
> [  928.754967] 000000003f0196cf: ffffffffb6d1479e (rcu_core_si+0xe/0x10)
> [  928.754969] 00000000e36b5944: ffff88841fb89fe8 (0xffff88841fb89fe8)
> [  928.754973] 000000004accbdfe: ffffffffb8400160 (__do_softirq+0x160/0x467)
> [  928.754975] 00000000b0a2d50d: ffff88841fb89fa0 (0xffff88841fb89fa0)
> [  928.754977] 00000000ff468aa1: 01ffffff00404040 (0x1ffffff00404040)
> [  928.754979] 00000000e7a176a7: ffff888370a0de80 (0xffff888370a0de80)
> [  928.754982] 0000000077951761: 00000001000990ef (0x1000990ef)
> [  928.754984] 0000000011ba65e6: ffff888370a0de80 (0xffff888370a0de80)
> [  928.754985] 000000009e2e350a: 0000000000000009 (0x9)
> [  928.754987] 00000000dab4e498: 0000000000000050 (0x50)
> [  928.754989] 000000000316aa9d: 000001000000000a (0x1000000000a)
> [  928.754992] 00000000d9349f42: ffffffffb90090c0 (tasklist_lock+0x40/0x40)
> [  928.754995] 0000000048c95adf: 000002000000000a (0x2000000000a)
> [  928.754996] 00000000253ce758: 0000000000000000 ...
> [  928.754998] 00000000c7bd4c18: ffff888410c6fea8 (0xffff888410c6fea8)
> [  928.754999] 00000000a3d59497: 0000000000000000 ...
> [  928.755002] 000000009d07f93e: ffff888410c6fe48 (0xffff888410c6fe48)
> [  928.755005] 000000005450b87d: ffffffffb8200f82 (asm_call_on_stack+0x12/0x20)
> [  928.755007] 00000000602e6f06: ffff888410c6fe48 (0xffff888410c6fe48)
> [  928.755010] 000000007a1ceca1: ffff888410c6fe58 (0xffff888410c6fe58)
> [  928.755014] 00000000fac24b13: ffffffffb6b0e9af
> (do_softirq_own_stack+0x3f/0x50)
> [  928.755016] 00000000f0ab3a1a: ffff888410c6fe78 (0xffff888410c6fe78)
> [  928.755019] 000000009d4da3e0: ffffffffb6c4a69f (irq_exit_rcu+0xff/0x110)
> [  928.755021] 00000000ad2e8d71: 0000000000000000 ...
> [  928.755023] 000000002ae1c7a1: ffff888410c6fea8 (0xffff888410c6fea8)
> [  928.755025] 000000002253613e: ffff888410c6fe98 (0xffff888410c6fe98)
> [  928.755029] 00000000c9123cb8: ffffffffb81aca68
> (sysvec_apic_timer_interrupt+0x38/0x90)
> [  928.755030] 0000000016819571: 0000000000000000 ...
> [  928.755032] 0000000005613fad: ffff888410c6fea9 (0xffff888410c6fea9)
> [  928.755036] 000000008ce730cd: ffffffffb8200c42
> (asm_sysvec_apic_timer_interrupt+0x12/0x20)
> [  928.755037] 00000000d9dac8ad: 0000000000000000 ...
> [  928.755040] 00000000b6032801: ffffed106e141bd0 (0xffffed106e141bd0)
> [  928.755042] 00000000bfa496b0: ffff888370a0de87 (0xffff888370a0de87)
> [  928.755044] 000000006b980fc2: ffffed106e141bd1 (0xffffed106e141bd1)
> [  928.755046] 0000000074e46078: 0000000000000001 (0x1)
> [  928.755048] 000000002aab3b34: ffff888410c6ff20 (0xffff888410c6ff20)
> [  928.755052] 00000000fce3bf98: ffffffffb6c5876d
> (calculate_sigpending+0x5d/0x70)
> [  928.755054] 0000000018ef6c93: 1ffff11080c16d20 (0x1ffff11080c16d20)
> [  928.755058] 000000009d1359d5: ffffffffb6c9f1cb (schedule_tail+0x7b/0x90)
> [  928.755060] 000000002fc55bea: ffff888410c6ff58 (0xffff888410c6ff58)
> [  928.755063] 0000000030fd457b: ffffffffffffffff (0xffffffffffffffff)
> [  928.755066] 00000000d49034b8: ffffffffb6a02be0 (ret_from_fork+0x10/0x30)
> [  928.755067] 00000000f6bd93cf: 0000000000000010 (0x10)
> [  928.755069] 000000003a683af5: 0000000000000246 (0x246)
> [  928.755072] 00000000b0490886: ffff888410c6ff58 (0xffff888410c6ff58)
> [  928.755073] 0000000067f6e028: 0000000000000018 (0x18)
> [  928.755076] 00000000a41e2047: ffffffffb6a02bd8 (ret_from_fork+0x8/0x30)
> [  928.755078] 0000000044a1e2e9: 0000000000000000 ...
> [  928.755080] 000000001dcd6329: 00007f43e4063000 (0x7f43e4063000)
> [  928.755082] 000000002cfa998b: 00007ffd5fa4e5d0 (0x7ffd5fa4e5d0)
> [  928.755083] 0000000026dbca06: 0000000000000000 ...
> [  928.755085] 000000001ea8b60c: 0000000000000246 (0x246)
> [  928.755087] 000000000694b3b3: 00007f43e405c850 (0x7f43e405c850)
> [  928.755089] 000000008c89cce5: 00007ffd5fa4e463 (0x7ffd5fa4e463)
> [  928.755091] 00000000dc105046: 00007f43e405c580 (0x7f43e405c580)
> [  928.755092] 00000000617a0390: 0000000000000000 ...
> [  928.755095] 00000000c5f510bf: 00007f43e3b4c54d (0x7f43e3b4c54d)
> [  928.755096] 00000000cb6c8d60: 0000000000000000 ...
> [  928.755098] 000000001fc7e35f: 0000000001200011 (0x1200011)
> [  928.755100] 00000000b9ac1c0b: 0000000000000038 (0x38)
> [  928.755102] 000000004f3f3b5b: 00007f43e3b4c54d (0x7f43e3b4c54d)
> [  928.755104] 000000005506661c: 0000000000000033 (0x33)
> [  928.755105] 00000000e6c2599e: 0000000000000246 (0x246)
> [  928.755108] 000000008306f770: 00007ffd5fa4e590 (0x7ffd5fa4e590)
> [  928.755109] 000000003a4ebad9: 000000000000002b (0x2b)
> 
> ref:
> https://lkft.validation.linaro.org/scheduler/job/1703012#L6510
> 
> -- 
> Linaro LKFT
> https://lkft.linaro.org
> 
