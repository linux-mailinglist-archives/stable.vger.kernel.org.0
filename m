Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5DB73CCE84
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 09:32:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbhGSHfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 03:35:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233759AbhGSHfV (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 03:35:21 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F172C061762;
        Mon, 19 Jul 2021 00:32:21 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id d12so20695233wre.13;
        Mon, 19 Jul 2021 00:32:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=DtUq5QndHQB6F6YkqSnVGACCyGdHUihJ0/gPYf6mMAQ=;
        b=YMH7ZePXjhGt0czla36MTUNlil3M3fXG8oCHjJBm2GHLjqJe+mNV8jGUd52dfn2cGa
         /OxcS5jQPsF2MdTx9QlhWYEbmpxAHgg/8JQLe1pC0kTUqmoZ7hlev7CQrCeF+Sh9R4jw
         PvVG7wNfUezW9/6dmSRJkYHFuEu/d8+znaShUR9D4oPMoV1oOUrWNVWMm0a7aszL5I2O
         xmJtpBoTD1h0S/lqIpm7E1f7zUUvFaBvv45VJ/zLn1jqB4phcGLr2HPfmHTHdKMMYK4Z
         KPcvFgJ40N7ohzesY7ArWvnbvlVMMMdZofrLeNlLnIzaqHC/C7sUwsnaq2GrKDKD69D9
         DWzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=DtUq5QndHQB6F6YkqSnVGACCyGdHUihJ0/gPYf6mMAQ=;
        b=T3X99dZe9rJ/1CHvf8vI4INDDLnCPmSF7g1RzQ2wAUPwfQy3jmXNxw8c7q+KRcX9wI
         zvHW5/1hHJEWorBBWS5NVMfPWZ2qEXKosEXH+xMalnOscOhZp0Zz8oKcA3QFxYV47p4T
         x/DNea6mbZYe8/6leQbnRt5MdFZZUiEkW0GykgFjOsQErJaMVMT9rnigkQ5hizVRDURj
         8C91BffcBeJlM5zFYV/Pt9NHW0IrNoh4Ql3BQPMxcN32SQeEzccSMolfO14mzDKdcGBB
         tx/ADaBVxwbEJw03H2c96sQ+6HzzTbUhdjC7kQZYRSNzfE0De4I7z7olHfgOUwll7KM/
         CDCA==
X-Gm-Message-State: AOAM533rxuRZF0oSrlGo0YQNbDgHdkr2QzsxHIafpb29jY3fxzrQyaMr
        RUklMwc15eKbSN9nyOj2rCUPae3cQeO8DvZL2Wg=
X-Google-Smtp-Source: ABdhPJzu5hSrVvuqrrqkCFTxkGeN9COxIYF+mbSmPTcYLnzmXJQ8BjH/NRrT3scOLP6URsXNc/Lipw==
X-Received: by 2002:adf:dfc4:: with SMTP id q4mr27572584wrn.329.1626679939401;
        Mon, 19 Jul 2021 00:32:19 -0700 (PDT)
Received: from [192.168.1.10] ([94.10.31.26])
        by smtp.googlemail.com with ESMTPSA id m32sm18455949wms.23.2021.07.19.00.32.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Jul 2021 00:32:18 -0700 (PDT)
Subject: Re: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
To:     paulmck@kernel.org, Oleksandr Natalenko <oleksandr@natalenko.name>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Chris Rankin <rankincj@gmail.com>,
        Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <jiangshanlai@gmail.com>,
        Joel Fernandes <joel@joelfernandes.org>, rcu@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
 <2245518.LNIG0phfVR@natalenko.name> <6698965.kvI7vG0SvZ@natalenko.name>
 <20210718215914.GQ4397@paulmck-ThinkPad-P17-Gen-1>
From:   Chris Clayton <chris2553@googlemail.com>
Message-ID: <dc7e0e8b-9b2d-bdde-f362-a58cfe937bbe@googlemail.com>
Date:   Mon, 19 Jul 2021 08:32:16 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210718215914.GQ4397@paulmck-ThinkPad-P17-Gen-1>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 18/07/2021 22:59, Paul E. McKenney wrote:
> On Sun, Jul 18, 2021 at 11:03:51PM +0200, Oleksandr Natalenko wrote:
>> + stable@vger.kernel.org
>>
>> On neděle 18. července 2021 23:01:24 CEST Oleksandr Natalenko wrote:
>>> Hello.
>>>
>>> On sobota 17. července 2021 22:22:08 CEST Chris Clayton wrote:
>>>> I checked the output from dmesg yesterday and found the following warning:
>>>>
>>>> [Fri Jul 16 09:15:29 2021] ------------[ cut here ]------------
>>>> [Fri Jul 16 09:15:29 2021] WARNING: CPU: 11 PID: 2701 at
>>>> kernel/rcu/tree_plugin.h:359 rcu_note_context_switch+0x37/0x3d0 [Fri Jul
>>>> 16
> 
> I am not seeing a warning at line 359 of either v5.13.2 or v5.12.7.
> 

Mmm, in the 5.13.2 tarball downloaded from https://cdn.kernel.org/pub/linux/kernel/v5.x/ I see:

    350  */
    351 void rcu_note_context_switch(bool preempt)
    352 {
    353         struct task_struct *t = current;
    354         struct rcu_data *rdp = this_cpu_ptr(&rcu_data);
    355         struct rcu_node *rnp;
    356
    357         trace_rcu_utilization(TPS("Start context switch"));
    358         lockdep_assert_irqs_disabled();
    359         WARN_ON_ONCE(!preempt && rcu_preempt_depth() > 0);
    360         if (rcu_preempt_depth() > 0 &&
    361             !t->rcu_read_unlock_special.b.blocked) {
    362

>>>> 09:15:29 2021] Modules linked in: uas hidp rfcomm bnep xt_MASQUERADE
>>>> iptable_nat nf_nat xt_LOG nf_log_syslog xt_limit xt_multiport xt_conntrack
>>>> iptable_filter btusb btintel wmi_bmof uvcvideo videobuf2_vmalloc
>>>> videobuf2_memops videobuf2_v4l2 videobuf2_common coretemp hwmon
>>>> snd_hda_codec_hdmi x86_pkg_temp_thermal snd_hda_codec_realtek
>>>> snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_intel_dspcfg
>>>> snd_hda_codec snd_hwdep snd_hda_core i2c_i801 i2c_smbus iwlmvm mac80211
>>>> iwlwifi i915 mei_me mei cfg80211 intel_lpss_pci intel_lpss wmi
>>>> nf_conntrack_ftp xt_helper nf_conntrack nf_defrag_ipv4 tun
>>>> [Fri Jul 16 09:15:29 2021] CPU: 11 PID: 2701 Comm: lpqd Not tainted 5.13.2
>>>> #1 [Fri Jul 16 09:15:29 2021] Hardware name: Notebook
>>>>
>>>>   NP50DE_DB                       /NP50DE_DB , BIOS 1.07.04 02/17/2020
>>>>
>>>> [Fri Jul 16 09:15:29 2021] RIP: 0010:rcu_note_context_switch+0x37/0x3d0
>>>> [Fri Jul 16 09:15:29 2021] Code: 02 00 e8 ec a0 6c 00 89 c0 65 4c 8b 2c 25
>>>> 00 6d 01 00 48 03 1c c5 80 56 e1 b6 40 84 ed 75 0d 41 8b 95 04 03 00 00 85
>>>> d2 7e 02 <0f> 0b 65 48 8b 04 25 00 6d 01 00 8b 80 04 03 00 00 85 c0 7e 0a
>>>> 41 [Fri Jul 16 09:15:29 2021] RSP: 0000:ffffb5d483837c70 EFLAGS: 00010002
>>>> [Fri Jul 16 09:15:29 2021] RAX: 000000000000000b RBX: ffff9b77806e1d80
>>>> RCX:
>>>> 0000000000000100 [Fri Jul 16 09:15:29 2021] RDX: 0000000000000001 RSI:
>>>> ffffffffb6d82ead RDI: ffffffffb6da5e4e [Fri Jul 16 09:15:29 2021] RBP:
>>>> 0000000000000000 R08: 0000000000000001 R09: 0000000000000000 [Fri Jul 16
>>>> 09:15:29 2021] R10: 000000067bce4fff R11: 0000000000000000 R12:
>>>> ffff9b77806e1100 [Fri Jul 16 09:15:29 2021] R13: ffff9b734a833a00 R14:
>>>> ffff9b734a833a00 R15: 0000000000000000 [Fri Jul 16 09:15:29 2021] FS:
>>>> 00007fccbfc5fe40(0000) GS:ffff9b77806c0000(0000) knlGS:0000000000000000
>>>> [Fri Jul 16 09:15:29 2021] CS:  0010 DS: 0000 ES: 0000 CR0:
>>>> 0000000080050033 [Fri Jul 16 09:15:29 2021] CR2: 00007fccc2db7290 CR3:
>>>> 00000003fb0b8002 CR4: 00000000007706e0 [Fri Jul 16 09:15:29 2021] PKRU:
>>>> 55555554
>>>> [Fri Jul 16 09:15:29 2021] Call Trace:
>>>> [Fri Jul 16 09:15:29 2021]  __schedule+0x86/0x810
>>>> [Fri Jul 16 09:15:29 2021]  schedule+0x40/0xe0
>>>> [Fri Jul 16 09:15:29 2021]  io_schedule+0x3d/0x60
>>>> [Fri Jul 16 09:15:29 2021]  wait_on_page_bit_common+0x129/0x390
>>>> [Fri Jul 16 09:15:29 2021]  ? __filemap_set_wb_err+0x10/0x10
>>>> [Fri Jul 16 09:15:29 2021]  __lock_page_or_retry+0x13f/0x1d0
>>>> [Fri Jul 16 09:15:29 2021]  do_swap_page+0x335/0x5b0
>>>> [Fri Jul 16 09:15:29 2021]  __handle_mm_fault+0x444/0xb20
>>>> [Fri Jul 16 09:15:29 2021]  handle_mm_fault+0x5c/0x170
>>>> [Fri Jul 16 09:15:29 2021]  ? find_vma+0x5b/0x70
>>>> [Fri Jul 16 09:15:29 2021]  exc_page_fault+0x1ab/0x610
>>>> [Fri Jul 16 09:15:29 2021]  ? fpregs_assert_state_consistent+0x19/0x40
>>>> [Fri Jul 16 09:15:29 2021]  ? asm_exc_page_fault+0x8/0x30
>>>> [Fri Jul 16 09:15:29 2021]  asm_exc_page_fault+0x1e/0x30
>>>> [Fri Jul 16 09:15:29 2021] RIP: 0033:0x7fccc2d3c520
>>>> [Fri Jul 16 09:15:29 2021] Code: 68 4c 00 00 00 e9 20 fb ff ff ff 25 7a ad
>>>> 07 00 68 4d 00 00 00 e9 10 fb ff ff ff 25 72 ad 07 00 68 4e 00 00 00 e9 00
>>>> fb ff ff <ff> 25 6a ad 07 00 68 4f 00 00 00 e9 f0 fa ff ff ff 25 62 ad 07
>>>> 00 [Fri Jul 16 09:15:29 2021] RSP: 002b:00007ffebd529048 EFLAGS: 00010293
>>>> [Fri Jul 16 09:15:29 2021] RAX: 0000000000000001 RBX: 00007fccc46e2890
>>>> RCX:
>>>> 0000000000000010 [Fri Jul 16 09:15:29 2021] RDX: 0000000000000010 RSI:
>>>> 0000000000000000 RDI: 00007fccc46e2890 [Fri Jul 16 09:15:29 2021] RBP:
>>>> 000056264f1dd4a0 R08: 000056264f21aba0 R09: 000056264f1f58a0 [Fri Jul 16
>>>> 09:15:29 2021] R10: 0000000000000007 R11: 0000000000000246 R12:
>>>> 000056264f21ac00 [Fri Jul 16 09:15:29 2021] R13: 000056264f1e0a30 R14:
>>>> 00007ffebd529080 R15: 00000000000dd87b [Fri Jul 16 09:15:29 2021] ---[ end
>>>> trace c8b06e067d8b0fc2 ]---
>>>>
>>>> At the time the warning was issued I was creating a (weekly) backup of my
>>>> linux system (home-brewed based on the guidance from Linux From Scratch).
>>>> My backup routine is completed by copying the archive files (created with
>>>> dar) and a directory that contains about 7000 source and binary rpm files
>>>> to an external USB drive. I didn't spot the warning until later in the
>>>> day,
>>>> so I'm not sure exactly where I was in my backup process.
>>>>
>>>> I haven't seen this warning before. Consequently, I don;t know how easy
>>>> (or
>>>> otherwise) it is to reproduce.
>>>>
>>>> Let me know if I can provide any additional diagnostics, but please cc me
>>>> as I'm not subscribed.
>>>
>>> Confirming the same for me with v5.13.2, and cross-referencing another
>>> report [1] against v5.12.17.
>>>
>>> Also Cc'ing relevant people on this.
>>>
>>> Thanks.
>>>
>>> [1]
>>> https://lore.kernel.org/lkml/CAK2bqVK0Q9YcpakE7_Rc6nr-E4e2GnMOgi5jJj=_Eh_1k
>>> EHLHA@mail.gmail.com/
> 
> But this one does show this warning in v5.12.17:
> 
> 	WARN_ON_ONCE(!preempt && rcu_preempt_depth() > 0);
> 
> This is in rcu_note_context_switch(), and could be caused by something
> like a schedule() within an RCU read-side critical section.  This would
> of course be RCU-usage bugs, given that you are not permitted to block
> within an RCU read-side critical section.
> 
> I suggest checking the functions in the stack trace to see where the
> rcu_read_lock() is hiding.  CONFIG_PROVE_LOCKING might also be helpful.
> 
> 							Thanx, Paul
> 
