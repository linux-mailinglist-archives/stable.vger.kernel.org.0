Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 365F13CC7EF
	for <lists+stable@lfdr.de>; Sun, 18 Jul 2021 08:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229578AbhGRGVi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 18 Jul 2021 02:21:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229471AbhGRGVi (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 18 Jul 2021 02:21:38 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5ADA5C061762
        for <stable@vger.kernel.org>; Sat, 17 Jul 2021 23:18:40 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id f8-20020a1c1f080000b029022d4c6cfc37so9409828wmf.5
        for <stable@vger.kernel.org>; Sat, 17 Jul 2021 23:18:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:references:to:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=NetWiID8GpfYJD6CPBEGPZ2S1WKSXce7Ui/QaVKslN4=;
        b=aRLmwmCQxZmTvc5y1khebp9CUh1a8AioONi6+SvtclR948gjoEBTtwn6zIha4DJVBh
         va1Xrj1u59XO6qO0UHwdYJzRs0LwWhEWbAMOk5RtUYqbw41YioRRtbCFRq1Ks779iLPZ
         s2lNTmtegl/sc7vMIfmCca6SyZbf0c2UXxagFWWQcQDgqrdPOm5+c8RRhr/DjqxcTvsR
         AkQYTETApbsHYlYYRpw/FMgzS4tT19TifZcsPrYwmouFp4vlu35BlRD8ATUKIzbdgPdX
         0MvQOT1OgfLwqTFOl/TrCGP/fUBzbl4NRxx4CWtnPF9VeoWpnciuZ2sRY8zqDN09OCej
         zcpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:references:to:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=NetWiID8GpfYJD6CPBEGPZ2S1WKSXce7Ui/QaVKslN4=;
        b=cODlqIiaZp2QC1C7d84H1c1DWnF5mm6fQ2rzUsU88TwlqyYBFXrw4fiiPQq3IaIoPl
         k87mefkxm20tfKNYcW8jED252/Y6I4s/GPUqjL2YbVQDZ5ekpuAmelRZJZQdRIZG/0ol
         mb2uC0dURCaLFCW3Zb1kxZJyXN5RnEO0456XgFdpPZ2BG6LbqPoQL1y7OSCTQF/lF7s2
         odnI8GdNr48LIL6uM+zOuKqQ53ngWS+bVRmvejrIKsdylIETMy7igfMrB1tf9sQdRCYn
         Oc9A9piwcnFh1E+H6hJh+iVmkKK6csIyjQpvxbTj1CcAWM15xbCsHMBGX63McLUmbvm4
         zKrA==
X-Gm-Message-State: AOAM533L4UktR4K6ZKV7b2IGa2e468T/nlJ+/6lMme6XB6iwkerMc5uX
        3dIFLppvodmhVhGFEYrYjK2tKIrDBFq1Ti+P
X-Google-Smtp-Source: ABdhPJx0o6H78PUk8QQtRxRIbIQnTXEbxLNzqhs4//1mWZJqLoIdAsG+H26vhJU9Gfp/+df00W66iw==
X-Received: by 2002:a05:600c:2948:: with SMTP id n8mr21572572wmd.11.1626589118978;
        Sat, 17 Jul 2021 23:18:38 -0700 (PDT)
Received: from [192.168.1.10] ([94.10.31.26])
        by smtp.googlemail.com with ESMTPSA id q5sm13083781wmc.0.2021.07.17.23.18.37
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 17 Jul 2021 23:18:38 -0700 (PDT)
Subject: Fwd: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
References: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
To:     stable@vger.kernel.org
From:   Chris Clayton <chris2553@googlemail.com>
X-Forwarded-Message-Id: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
Message-ID: <49a2a0c3-a72f-ec82-cb76-82ddff73aa5a@googlemail.com>
Date:   Sun, 18 Jul 2021 07:18:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <c9fd1311-662c-f993-c8ef-54af036f2f78@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sorry, but last night I sent this to the wrong email address for stable


-------- Forwarded Message --------
Subject: linux-5.13.2: warning from kernel/rcu/tree_plugin.h:359
Date: Sat, 17 Jul 2021 21:22:08 +0100
From: Chris Clayton <chris2553@googlemail.com>
To: LKML <linux-kernel@vger.kernel.org>, linux-stable@vger.kernel.org

Hi

I checked the output from dmesg yesterday and found the following warning:

[Fri Jul 16 09:15:29 2021] ------------[ cut here ]------------
[Fri Jul 16 09:15:29 2021] WARNING: CPU: 11 PID: 2701 at kernel/rcu/tree_plugin.h:359 rcu_note_context_switch+0x37/0x3d0
[Fri Jul 16 09:15:29 2021] Modules linked in: uas hidp rfcomm bnep xt_MASQUERADE iptable_nat nf_nat xt_LOG nf_log_syslog
xt_limit xt_multiport xt_conntrack iptable_filter btusb btintel wmi_bmof uvcvideo videobuf2_vmalloc videobuf2_memops
videobuf2_v4l2 videobuf2_common coretemp hwmon snd_hda_codec_hdmi x86_pkg_temp_thermal snd_hda_codec_realtek
snd_hda_codec_generic ledtrig_audio snd_hda_intel snd_intel_dspcfg snd_hda_codec snd_hwdep snd_hda_core i2c_i801
i2c_smbus iwlmvm mac80211 iwlwifi i915 mei_me mei cfg80211 intel_lpss_pci intel_lpss wmi nf_conntrack_ftp xt_helper
nf_conntrack nf_defrag_ipv4 tun
[Fri Jul 16 09:15:29 2021] CPU: 11 PID: 2701 Comm: lpqd Not tainted 5.13.2 #1
[Fri Jul 16 09:15:29 2021] Hardware name: Notebook                         NP50DE_DB                       /NP50DE_DB
                   , BIOS 1.07.04 02/17/2020
[Fri Jul 16 09:15:29 2021] RIP: 0010:rcu_note_context_switch+0x37/0x3d0
[Fri Jul 16 09:15:29 2021] Code: 02 00 e8 ec a0 6c 00 89 c0 65 4c 8b 2c 25 00 6d 01 00 48 03 1c c5 80 56 e1 b6 40 84 ed
75 0d 41 8b 95 04 03 00 00 85 d2 7e 02 <0f> 0b 65 48 8b 04 25 00 6d 01 00 8b 80 04 03 00 00 85 c0 7e 0a 41
[Fri Jul 16 09:15:29 2021] RSP: 0000:ffffb5d483837c70 EFLAGS: 00010002
[Fri Jul 16 09:15:29 2021] RAX: 000000000000000b RBX: ffff9b77806e1d80 RCX: 0000000000000100
[Fri Jul 16 09:15:29 2021] RDX: 0000000000000001 RSI: ffffffffb6d82ead RDI: ffffffffb6da5e4e
[Fri Jul 16 09:15:29 2021] RBP: 0000000000000000 R08: 0000000000000001 R09: 0000000000000000
[Fri Jul 16 09:15:29 2021] R10: 000000067bce4fff R11: 0000000000000000 R12: ffff9b77806e1100
[Fri Jul 16 09:15:29 2021] R13: ffff9b734a833a00 R14: ffff9b734a833a00 R15: 0000000000000000
[Fri Jul 16 09:15:29 2021] FS:  00007fccbfc5fe40(0000) GS:ffff9b77806c0000(0000) knlGS:0000000000000000
[Fri Jul 16 09:15:29 2021] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[Fri Jul 16 09:15:29 2021] CR2: 00007fccc2db7290 CR3: 00000003fb0b8002 CR4: 00000000007706e0
[Fri Jul 16 09:15:29 2021] PKRU: 55555554
[Fri Jul 16 09:15:29 2021] Call Trace:
[Fri Jul 16 09:15:29 2021]  __schedule+0x86/0x810
[Fri Jul 16 09:15:29 2021]  schedule+0x40/0xe0
[Fri Jul 16 09:15:29 2021]  io_schedule+0x3d/0x60
[Fri Jul 16 09:15:29 2021]  wait_on_page_bit_common+0x129/0x390
[Fri Jul 16 09:15:29 2021]  ? __filemap_set_wb_err+0x10/0x10
[Fri Jul 16 09:15:29 2021]  __lock_page_or_retry+0x13f/0x1d0
[Fri Jul 16 09:15:29 2021]  do_swap_page+0x335/0x5b0
[Fri Jul 16 09:15:29 2021]  __handle_mm_fault+0x444/0xb20
[Fri Jul 16 09:15:29 2021]  handle_mm_fault+0x5c/0x170
[Fri Jul 16 09:15:29 2021]  ? find_vma+0x5b/0x70
[Fri Jul 16 09:15:29 2021]  exc_page_fault+0x1ab/0x610
[Fri Jul 16 09:15:29 2021]  ? fpregs_assert_state_consistent+0x19/0x40
[Fri Jul 16 09:15:29 2021]  ? asm_exc_page_fault+0x8/0x30
[Fri Jul 16 09:15:29 2021]  asm_exc_page_fault+0x1e/0x30
[Fri Jul 16 09:15:29 2021] RIP: 0033:0x7fccc2d3c520
[Fri Jul 16 09:15:29 2021] Code: 68 4c 00 00 00 e9 20 fb ff ff ff 25 7a ad 07 00 68 4d 00 00 00 e9 10 fb ff ff ff 25 72
ad 07 00 68 4e 00 00 00 e9 00 fb ff ff <ff> 25 6a ad 07 00 68 4f 00 00 00 e9 f0 fa ff ff ff 25 62 ad 07 00
[Fri Jul 16 09:15:29 2021] RSP: 002b:00007ffebd529048 EFLAGS: 00010293
[Fri Jul 16 09:15:29 2021] RAX: 0000000000000001 RBX: 00007fccc46e2890 RCX: 0000000000000010
[Fri Jul 16 09:15:29 2021] RDX: 0000000000000010 RSI: 0000000000000000 RDI: 00007fccc46e2890
[Fri Jul 16 09:15:29 2021] RBP: 000056264f1dd4a0 R08: 000056264f21aba0 R09: 000056264f1f58a0
[Fri Jul 16 09:15:29 2021] R10: 0000000000000007 R11: 0000000000000246 R12: 000056264f21ac00
[Fri Jul 16 09:15:29 2021] R13: 000056264f1e0a30 R14: 00007ffebd529080 R15: 00000000000dd87b
[Fri Jul 16 09:15:29 2021] ---[ end trace c8b06e067d8b0fc2 ]---

At the time the warning was issued I was creating a (weekly) backup of my linux system (home-brewed based on the
guidance from Linux From Scratch). My backup routine is completed by copying the archive files (created with dar) and a
directory that contains about 7000 source and binary rpm files to an external USB drive. I didn't spot the warning until
later in the day, so I'm not sure exactly where I was in my backup process.

I haven't seen this warning before. Consequently, I don;t know how easy (or otherwise) it is to reproduce.

Let me know if I can provide any additional diagnostics, but please cc me as I'm not subscribed.

Chris


