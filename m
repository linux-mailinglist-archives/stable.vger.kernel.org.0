Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 254314F1ADF
	for <lists+stable@lfdr.de>; Mon,  4 Apr 2022 23:17:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343741AbiDDVTF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Apr 2022 17:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380061AbiDDSvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 4 Apr 2022 14:51:32 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9693137D;
        Mon,  4 Apr 2022 11:49:34 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id r13so21892350ejd.5;
        Mon, 04 Apr 2022 11:49:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3ZJa7P2AbXCXeW6xvXsCiP3LWm5yyogWWr/a7zJOtNM=;
        b=Z2O7Cf61jq3MA+6JmnvTQucNZTDvkuC3L31nRoKLs+MYgic7gmyFaIZd/dkFh5aBSy
         yybjMXv34DiHGp70+T/er+yow225iYtDeGfvYYHH7UtDRGN3mabZEzCR9lIHvxz4c+E7
         SYW9CCKPeFKOWv6xQBwvAynEKPQ+Eow2WweiX3V6MS0T7jNQpEuWY9sc5o6SgK42iIOh
         /OJbRv6fF4KO96xoSVcUArV9dohPkNn0SpXXnfLHufCv3crlrdc5rLXY/u8kjI98G1oV
         yOYovniIhXr838pa8UYXLhCPqpW+4Cda0gOXT5SGG+hbrzmo+UMSB7R3QxkcybHRe5dy
         SmPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3ZJa7P2AbXCXeW6xvXsCiP3LWm5yyogWWr/a7zJOtNM=;
        b=BrxjOJwOfNrScpflHofERFa6FUHY53GlXbQnWlr65H3uXXm0X6uCF61Tqh6GW+0RQ8
         sD0UPRT9j+iyPuQvhcyGJUfhwOZe3jEFNPdUnMPVnbwr9wZUKX8Xa8121Y13Gfqoi6Oj
         M7Oi8V4ncCObKXxFh9ye5WHeryGFXXFfXaUAVHnFOHf7MzXbdeaebfCE3y0RJs2EAqYx
         GfYs47q2c2M9rInlVS+uCtoKPD3X9MfWLZE+2h2mIh9AefslnV4+SZOzA89la3QyU4z7
         2udSjbjcrN/rvPB8B3q8xRBzBK/s07HsqQGmA9FIo9pkXGLJLCZAWOlaRmtq6Kz3OA9f
         J6rQ==
X-Gm-Message-State: AOAM533OpsgQPuenpmXD6eai4CyA5PUNAfQLJxyzfYYdPGFRRP2Ssmcs
        1OBSSTtVMFMC/kRf5YxHWSI=
X-Google-Smtp-Source: ABdhPJy3+nGdpgaPHslQ1iHZwzN+x4swcFMaonp/MMXGm2yUuNXTbNdm6Ti54jFv3tSh8i1d4eM73w==
X-Received: by 2002:a17:907:8a01:b0:6e5:1f4:afa with SMTP id sc1-20020a1709078a0100b006e501f40afamr1452481ejc.691.1649098172495;
        Mon, 04 Apr 2022 11:49:32 -0700 (PDT)
Received: from darkstar.example.org (host-79-21-204-193.retail.telecomitalia.it. [79.21.204.193])
        by smtp.gmail.com with ESMTPSA id b14-20020a170906d10e00b006e803595901sm375275ejz.172.2022.04.04.11.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 04 Apr 2022 11:49:31 -0700 (PDT)
Date:   Mon, 4 Apr 2022 20:49:30 +0200
From:   Michele Ballabio <ballabio.m@gmail.com>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Possible regression in 5.16-stable
Message-ID: <20220404204854.22338b7d@darkstar.example.org>
In-Reply-To: <9fd4d3df-ef82-4a9b-1ba9-289181eb0d0a@leemhuis.info>
References: <20220403132152.23330380@darkstar.example.org>
        <9fd4d3df-ef82-4a9b-1ba9-289181eb0d0a@leemhuis.info>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-slackware-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 4 Apr 2022 09:12:41 +0200
Thorsten Leemhuis <regressions@leemhuis.info> wrote:

> > Kernels 5.16.10 do not have the following regression, 5.16.11-16  
> 
> 5.16.11-16 sounds like this is a distro kernel that might or might not
> be patched. Or is 11-16 just meant as a range. Could you clarify?

Sorry, I meant the problem occurred on 5.16.11, .12 and .16.

> > do. My machine would freeze completely about once a week, no oops in
> > the logs, sysrq won't work either. I managed to log only the
> > following (and only once) with netconsole, while running kernel
> > 5.16.16. I could not reproduce the problem since.  
> 
> Hmmm. Of course ideally all regressions get fixed, but that beeing
> said: 5.16 will likely be EOL in round about two weeks anway and
> getting to the root of this problem might take some time and effort.
> That's why I'm not sure myself what's the best way forward here.

I'm aware of this, but given the nature of the problem and how difficult
it is to reproduce, I thought it was better to report it.
Meanwhile I'm now on 5.17.1: let's say this is on hold until someone
has a similar problem with 5.17.x.

> Maybe testing 5.17 to see if the problem still shows up would be
> good; bisection would help, but I guess that will be hard here. But I
> guess there is one thing that could help: could you maybe decode the
> panic you have as described in this document:
> https://www.kernel.org/doc/html/latest/admin-guide/reporting-issues.html

Thanks, I tried but I'm not sure it's of any help:

----------
0,1493,12767657117,-;traps: PANIC: double fault, error_code: 0x0
4,1494,12767657121,-;double fault: 0000 [#1] PREEMPT SMP NOPTI
4,1496,12767657126,-;Hardware name: System manufacturer System Product Name/PRIME B350-PLUS, BIOS 4011 04/19/2018
4,1497,12767657127,-;RIP: entry_SYSCALL_64+0x3/0x29 
4,1498,12767657133,-;Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc 0f 01 f8 <65> 48 89 24 25 14 60 00 00 eb 12 0f 20 dc 0f 1f 44 00 00 48 81 e4
All code
========
   0:	cc                   	int3   
   1:	cc                   	int3   
   2:	cc                   	int3   
   3:	cc                   	int3   
   4:	cc                   	int3   
   5:	cc                   	int3   
   6:	cc                   	int3   
   7:	cc                   	int3   
   8:	cc                   	int3   
   9:	cc                   	int3   
   a:	cc                   	int3   
   b:	cc                   	int3   
   c:	cc                   	int3   
   d:	cc                   	int3   
   e:	cc                   	int3   
   f:	cc                   	int3   
  10:	cc                   	int3   
  11:	cc                   	int3   
  12:	cc                   	int3   
  13:	cc                   	int3   
  14:	cc                   	int3   
  15:	cc                   	int3   
  16:	cc                   	int3   
  17:	cc                   	int3   
  18:	cc                   	int3   
  19:	cc                   	int3   
  1a:	cc                   	int3   
  1b:	cc                   	int3   
  1c:	cc                   	int3   
  1d:	cc                   	int3   
  1e:	cc                   	int3   
  1f:	cc                   	int3   
  20:	cc                   	int3   
  21:	cc                   	int3   
  22:	cc                   	int3   
  23:	cc                   	int3   
  24:	cc                   	int3   
  25:	cc                   	int3   
  26:	cc                   	int3   
  27:	0f 01 f8             	swapgs 
  2a:*	65 48 89 24 25 14 60 	mov    %rsp,%gs:0x6014		<-- trapping instruction
  31:	00 00 
  33:	eb 12                	jmp    0x47
  35:	0f 20 dc             	mov    %cr3,%rsp
  38:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  3d:	48                   	rex.W
  3e:	81                   	.byte 0x81
  3f:	e4                   	.byte 0xe4

Code starting with the faulting instruction
===========================================
   0:	65 48 89 24 25 14 60 	mov    %rsp,%gs:0x6014
   7:	00 00 
   9:	eb 12                	jmp    0x1d
   b:	0f 20 dc             	mov    %cr3,%rsp
   e:	0f 1f 44 00 00       	nopl   0x0(%rax,%rax,1)
  13:	48                   	rex.W
  14:	81                   	.byte 0x81
  15:	e4                   	.byte 0xe4
4,1499,12767657134,-;RSP: 0018:00007f2a8bcbd438 EFLAGS: 00010002
4,1500,12767657136,-;RAX: 00000000000000ca RBX: 000000000000005d RCX: 00007f2aa45e8aab
4,1501,12767657138,-;RDX: 0000000000000002 RSI: 0000000000000080 RDI: 00007f2aa4400018
4,1502,12767657139,-;RBP: 00007f2aa4400018 R08: 0000000000000000 R09: 00007f2a8ed00000
4,1503,12767657140,-;R10: 0000000000000000 R11: 0000000000000282 R12: 00000000000000a8
4,1504,12767657141,-;R13: 0000000000000003 R14: 0000000000000030 R15: 00007f2aa4400000
4,1505,12767657142,-;FS:  00007f2a8bcbe640(0000) GS:ffff8b110ed00000(0000) knlGS:0000000000000000
4,1506,12767657143,-;CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
4,1507,12767657144,-;CR2: 00007f2a8bcbd428 CR3: 00000002953f2000 CR4: 00000000003506e0
4,1508,12767657146,-;Call Trace:
4,1509,12767657146,-,ncfrag=0/986;Modules linked in: nfnetlink_queue nfnetlink_log nfnetlink bluetooth ecdh_generic ecc netconsole uas usb_storage snd_seq_dummy snd_hrtimer snd_seq snd_seq_device iptable_filter xt_tcpudp ip_tables
 x_tables hwmon_vid 8021q garp mrp stp llc ipv6 fuse rt73usb rt2x00usb rt2x00lib mac80211 hid_logitech cfg80211 joydev hid_generic usbhid hid amdgpu intel_rapl_msr iommu_v2 intel_rapl_common gpu_sched eeepc_wmi asus_wmi drm_ttm_helper
 ttm platform_profile battery drm_kms_helper sparse_keymap edac_mce_amd rfkill drm kvm_amd snd_hda_codec_realtek video snd_hda_codec_generic ledtrig_audio kvm snd_hda_codec_hdmi snd_hda_intel agpgart snd_intel_dspcfg snd_intel_sdw_acpi
 wmi_bmof snd_hda_codec evdev i2c_algo_bit snd_hda_core fb_sys_fops syscopyarea sysfillrect sysimgblt snd_hwdep mfd_core snd_pcm r8169 irqbypass snd_timer realtek snd xhci_pci xhci_pci_renesas xhci_hcd mdio_devres crct10dif_pclmul
 crc32_pclmul i2c_piix4 soundcore ccp libphy ghash_clmulni_intel i2c_co4,1509,12767657146,-,ncfrag=966/986;re rapl k10temp wmi
4,1510,12767657189,c; acpi_cpufreq gpio_amdpt button gpio_generic loop [last unloaded: netconsole]
4,1511,12767657207,-;------------[ cut here ]------------
4,1512,12767657207,-;WARNING: CPU: 4 PID: 16786 at kernel/softirq.c:362 __local_bh_enable_ip+0x43/0x70 
4,1513,12767657212,-,ncfrag=0/986;Modules linked in: nfnetlink_queue nfnetlink_log nfnetlink bluetooth ecdh_generic ecc netconsole uas usb_storage snd_seq_dummy snd_hrtimer snd_seq snd_seq_device iptable_filter xt_tcpudp ip_tables
 x_tables hwmon_vid 8021q garp mrp stp llc ipv6 fuse rt73usb rt2x00usb rt2x00lib mac80211 hid_logitech cfg80211 joydev hid_generic usbhid hid amdgpu intel_rapl_msr iommu_v2 intel_rapl_common gpu_sched eeepc_wmi asus_wmi drm_ttm_helper
 ttm platform_profile battery drm_kms_helper sparse_keymap edac_mce_amd rfkill drm kvm_amd snd_hda_codec_realtek video snd_hda_codec_generic ledtrig_audio kvm snd_hda_codec_hdmi snd_hda_intel agpgart snd_intel_dspcfg snd_intel_sdw_acpi
 wmi_bmof snd_hda_codec evdev i2c_algo_bit snd_hda_core fb_sys_fops syscopyarea sysfillrect sysimgblt snd_hwdep mfd_core snd_pcm r8169 irqbypass snd_timer realtek snd xhci_pci xhci_pci_renesas xhci_hcd mdio_devres crct10dif_pclmul
 crc32_pclmul i2c_piix4 soundcore ccp libphy ghash_clmulni_intel i2c_co4,1513,12767657212,-,ncfrag=966/986;re rapl k10temp wmi
4,1514,12767657248,c; acpi_cpufreq gpio_amdpt button gpio_generic loop [last unloaded: netconsole]
4,1516,12767657254,-;Hardware name: System manufacturer System Product Name/PRIME B350-PLUS, BIOS 4011 04/19/2018
4,1517,12767657255,-;RIP: __local_bh_enable_ip+0x43/0x70 
4,1518,12767657257,-;Code: 01 35 61 1d f3 7d 65 8b 05 5a 1d f3 7d a9 00 ff ff 00 74 1a bf 01 00 00 00 e8 99 b5 02 00 65 8b 05 42 1d f3 7d 85 c0 74 25 c3 <0f> 0b eb cc 48 c7 c7 d9 53 42 83 e8 4d ec a6 00 65 66 8b 05 25 19
All code
========
   0:	01 35 61 1d f3 7d    	add    %esi,0x7df31d61(%rip)        # 0x7df31d67
   6:	65 8b 05 5a 1d f3 7d 	mov    %gs:0x7df31d5a(%rip),%eax        # 0x7df31d67
   d:	a9 00 ff ff 00       	test   $0xffff00,%eax
  12:	74 1a                	je     0x2e
  14:	bf 01 00 00 00       	mov    $0x1,%edi
  19:	e8 99 b5 02 00       	call   0x2b5b7
  1e:	65 8b 05 42 1d f3 7d 	mov    %gs:0x7df31d42(%rip),%eax        # 0x7df31d67
  25:	85 c0                	test   %eax,%eax
  27:	74 25                	je     0x4e
  29:	c3                   	ret    
  2a:*	0f 0b                	ud2    		<-- trapping instruction
  2c:	eb cc                	jmp    0xfffffffffffffffa
  2e:	48 c7 c7 d9 53 42 83 	mov    $0xffffffff834253d9,%rdi
  35:	e8 4d ec a6 00       	call   0xa6ec87
  3a:	65                   	gs
  3b:	66                   	data16
  3c:	8b                   	.byte 0x8b
  3d:	05                   	.byte 0x5
  3e:	25                   	.byte 0x25
  3f:	19                   	.byte 0x19

Code starting with the faulting instruction
===========================================
   0:	0f 0b                	ud2    
   2:	eb cc                	jmp    0xffffffffffffffd0
   4:	48 c7 c7 d9 53 42 83 	mov    $0xffffffff834253d9,%rdi
   b:	e8 4d ec a6 00       	call   0xa6ec5d
  10:	65                   	gs
  11:	66                   	data16
  12:	8b                   	.byte 0x8b
  13:	05                   	.byte 0x5
  14:	25                   	.byte 0x25
  15:	19                   	.byte 0x19
4,1519,12767657259,-;RSP: 0018:fffffe00000f69a0 EFLAGS: 00010006
4,1520,12767657260,-;RAX: 0000000080110203 RBX: ffff8b0e05bd2000 RCX: ffff8b0e05bd2000
4,1521,12767657261,-;RDX: ffff8b0e0ac28000 RSI: 0000000000000201 RDI: ffffffffc12f12c3
4,1522,12767657262,-;RBP: ffff8b0e0c977a30 R08: fffffe00000f69e8 R09: ffff8b0e0d085000
4,1523,12767657263,-;R10: ffff8b0e03234300 R11: 0000000000000fff R12: ffff8b0e0d0850d0
4,1524,12767657264,-;R13: fffffe00000f69e8 R14: ffff8b0e0ddfc980 R15: ffff8b0e0d085a58
4,1525,12767657265,-;FS:  00007f2a8bcbe640(0000) GS:ffff8b110ed00000(0000) knlGS:0000000000000000
4,1526,12767657266,-;CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
----------

Thanks,
    Michele Ballabio

