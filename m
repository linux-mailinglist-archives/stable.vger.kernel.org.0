Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B7F64A31DC
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 21:39:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245267AbiA2UjT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 15:39:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353134AbiA2UjS (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 15:39:18 -0500
Received: from mail-wm1-x330.google.com (mail-wm1-x330.google.com [IPv6:2a00:1450:4864:20::330])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EDFDC061714;
        Sat, 29 Jan 2022 12:39:18 -0800 (PST)
Received: by mail-wm1-x330.google.com with SMTP id i187-20020a1c3bc4000000b0034d2ed1be2aso10819936wma.1;
        Sat, 29 Jan 2022 12:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=zDQYMTu74+UHnQjGMKesC4QW15Ax7DICeDlooHexkfI=;
        b=EBODcl0j+7YN2MVxVrcbUob0KvdNH+X2/LnaVPpRLdFCTQczCICmNF6YuR6xtLM+E3
         f5lFKWyuRofCsHip+FfFMbwRedC9S42x6h8QiBG3e5ZEEgmvNLOwpQ2xrp9y7IO5YsCV
         GTIQKU1rzgH8Nnk86LufrmWJqBaf/u2xqZbZ1/xupT3iNwn4tc9ACkE35h2QHle0F7K6
         y/mL79GDy9RrGqsLllrCHu0bgW7Icns3W3hvoJ6EmkdgrmaZViTIXAu8EDAka1QzWJNi
         FGOcuvVfn0zwQlMlo0+oNwnVvuYGlix55ENvNs8vJSKlRtdz5cjPFlWYrsbFh8lR+wh1
         RSMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=zDQYMTu74+UHnQjGMKesC4QW15Ax7DICeDlooHexkfI=;
        b=B62MaZ948SgH7iK8d3LhWFv0ALU05hr9GReGkm7lFY1DQ5OK6N0JL2diCVzpBoIFUe
         zY99vKwiCWR1ykIXsWTgEY11h8ZSaac+eriWe1Q4dccFrk/TyoRBCp8hOzS0g3Zybr0Q
         VR+42dEOtAJWnJgZ22U2N9jd6esFHxLeSuDBhtIlR6qNvXxcdi5OAEAiQ2TvQMlKrJ44
         ungZk2S4Ru6ad4LlysA8MoUCI8dTn74JuFNoxuw5WNyUa2a8MFSfZIcnEFHhD31Rs9t/
         wPCbQU0haRvCbxICxqe3qDMXXRT/T11XLjV98b0LZ5lc0mhEl3OfmrVN8Sq3kUEK9MO5
         mWLQ==
X-Gm-Message-State: AOAM530DoNaBE8UBmF9QzDf3tspJ7S+SEAVHjJnMM39E4R4vj2pCO1kU
        OWBnRwCw7m/RIo4o8EfftYkkbP/Tvpf+yaSTT71NPBhrJNQ=
X-Google-Smtp-Source: ABdhPJxTk4SQ7bw8zYUzwAzPFhkUh3nADJ0CNH8tPfU4KeM3TnrubFGb+1PMnEQ4S7pIZhkrqDnspyjYuBiSje+Fi2k=
X-Received: by 2002:a05:600c:1e19:: with SMTP id ay25mr12226861wmb.81.1643488756118;
 Sat, 29 Jan 2022 12:39:16 -0800 (PST)
MIME-Version: 1.0
References: <CAMP44s2vAmfHU+h5bSp5FJvks7T+b_tpdU1U4pBvK9jFF6C=eQ@mail.gmail.com>
 <cabdd567-6b8a-476b-ac45-e6ee170247f9@lockie.ca> <CAMP44s0+kOzePb7r6W6c2ok32iWNYOXiSQOV+Pmp0ij7tvgakg@mail.gmail.com>
In-Reply-To: <CAMP44s0+kOzePb7r6W6c2ok32iWNYOXiSQOV+Pmp0ij7tvgakg@mail.gmail.com>
From:   Felipe Contreras <felipe.contreras@gmail.com>
Date:   Sat, 29 Jan 2022 14:39:05 -0600
Message-ID: <CAMP44s2eBi_M72fq4XMdjDCe0tzwpNxoP=V+G4hiSqdePxjE_g@mail.gmail.com>
Subject: Re: Regression in 5.16.3 with mt7921e
To:     James <bjlockie@lockie.ca>
Cc:     Linux stable <stable@vger.kernel.org>,
        Linux wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 29, 2022 at 1:50 PM Felipe Contreras
<felipe.contreras@gmail.com> wrote:
>
> On Sat, Jan 29, 2022 at 1:12 PM James <bjlockie@lockie.ca> wrote:
> >
> > Does dmesg show anything?
>
> It's hard to tell because it seems there are multiple conflating
> issues. I booted into 5.16.3 again, and this time I experienced a
> different problem, so far I've seen these two:
>
> 1. The device appears, but I'm unable to bring it up
> 2. The device doesn't even appear

I removed the nvidia driver and I was still able to reproduce issue #1.

Here are the interesting bits:

[    2.295614] mt7921e 0000:02:00.0: enabling device (0000 -> 0002)
[    2.295810] mt7921e 0000:02:00.0: ASIC revision: 79610010
[    2.377578] mt7921e 0000:02:00.0: HW/SW Version: 0x8a108a10, Build
Time: 20220110230855a
[    2.846987] mt7921e 0000:02:00.0: WM Firmware Version: ____010000,
Build Time: 20220110230951
[    2.874395] mt7921e 0000:02:00.0: Firmware init done
[    7.374118] mt7921e 0000:02:00.0: Message 00020001 (seq 4) timeout
[    7.374180] mt7921e 0000:02:00.0: chip reset
[   13.773763] mt7921e 0000:02:00.0: Message 000046ed (seq 5) timeout
[   13.887279] mt7921e 0000:02:00.0: HW/SW Version: 0x8a108a10, Build
Time: 20220110230855a
[   13.958763] mt7921e 0000:02:00.0: WM Firmware Version: ____010000,
Build Time: 20220110230951
[   13.989292] mt7921e 0000:02:00.0: Firmware init done
[   54.093979] mt7921e 0000:02:00.0: Message 00020001 (seq 10) timeout
[   54.094010] mt7921e 0000:02:00.0: chip reset
[   60.493981] mt7921e 0000:02:00.0: Message 000046ed (seq 11) timeout
[   60.600757] mt7921e 0000:02:00.0: HW/SW Version: 0x8a108a10, Build
Time: 20220110230855a
[   60.672805] mt7921e 0000:02:00.0: WM Firmware Version: ____010000,
Build Time: 20220110230951
[   60.704784] mt7921e 0000:02:00.0: Firmware init done

The last "Firmware init done" happened after I did "ip link set wlan0
up" which failed.

Here's the full dmesg: https://dpaste.org/PVTE

Yet another issue (#3) is that the kernel sometimes crashes when
starting up the system. I've mostly ignored this issue, but looking at
the log when that happens, it seems to be related to the mt7921
driver:

Jan 29 14:21:58 chronos kernel: mt7921e 0000:02:00.0: Timeout for driver own
Jan 29 14:21:58 chronos kernel: BUG: Bad page state in process
systemd-udevd  pfn:103328
Jan 29 14:21:58 chronos kernel: page:00000000128101f9 refcount:-1
mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x103328
Jan 29 14:21:58 chronos kernel: flags:
0x2ffff0000000000(node=0|zone=2|lastcpupid=0xffff)
Jan 29 14:21:58 chronos kernel: raw: 02ffff0000000000 dead000000000100
dead000000000122 0000000000000000
Jan 29 14:21:58 chronos kernel: raw: 0000000000000000 0000000000000000
ffffffffffffffff 0000000000000000
Jan 29 14:21:58 chronos kernel: page dumped because: nonzero _refcount
Jan 29 14:21:58 chronos kernel: Modules linked in: bnep btusb btrtl
btbcm ccm algif_aead cbc btintel des_generic libdes ecb bluetooth
iptable_nat ecdh_generic hid_asus nf_nat algif_skcipher nf_conntrack
cmac nf_defrag_ipv6 nf_defrag_ipv4 libcrc32c md4 algif_hash
iptable_mangle iptable_filter af_alg intel_rapl_msr intel_rapl_common
joydev mousedev mt7921e(+) mt7921_common snd_hda_codec_realtek
mt76_connac_lib snd_hda_codec_generic edac_mce_amd ledtrig_audio mt76
snd_hda_codec_hdmi hid_multitouch snd_hda_intel mac80211 kvm_amd
snd_intel_dspcfg vfat asus_nb_wmi snd_intel_sdw_acpi libarc4 fat
amdgpu kvm irqbypass snd_hda_codec asus_wmi snd_pci_acp6x
crct10dif_pclmul cfg80211 snd_hda_core sparse_keymap crc32_pclmul
snd_hwdep ghash_clmulni_intel platform_profile snd_pcm aesni_intel
i8042 snd_timer crypto_simd gpu_sched snd_pci_acp5x cryptd serio
ucsi_acpi sp5100_tco snd drm_ttm_helper snd_rn_pci_acp3x rapl
typec_ucsi pcspkr wmi_bmof rfkill ttm soundcore ccp snd_pci_acp3x
i2c_piix4 k10temp tpm_crb typec tpm_tis
Jan 29 14:21:58 chronos kernel:  roles mac_hid tpm_tis_core
i2c_hid_acpi tpm i2c_hid amd_pmc rng_core acpi_cpufreq asus_wireless
pinctrl_amd pkcs8_key_parser crypto_user fuse bpf_preload ip_tables
x_tables usbhid ext4 crc32c_generic crc16 mbcache jbd2 xhci_pci
crc32c_intel xhci_pci_renesas wmi video
Jan 29 14:21:58 chronos kernel: CPU: 12 PID: 396 Comm: systemd-udevd
Tainted: G        W         5.16.3-arch1-1 #1
ca51a3fe35922d501638d513dc9548a2c4fed987
Jan 29 14:21:58 chronos kernel: Hardware name: ASUSTeK COMPUTER INC.
ROG Zephyrus G14 GA401QM_GA401QM/GA401QM, BIOS GA401QM.410 12/13/2021
Jan 29 14:21:58 chronos kernel: Call Trace:
Jan 29 14:21:58 chronos kernel:  <TASK>
Jan 29 14:21:58 chronos kernel:  dump_stack_lvl+0x48/0x66
Jan 29 14:21:58 chronos kernel:  bad_page.cold+0x63/0x94
Jan 29 14:21:58 chronos kernel:  free_pcppages_bulk+0x1f2/0x380
Jan 29 14:21:58 chronos kernel:  free_unref_page+0xbd/0x140
Jan 29 14:21:58 chronos kernel:  mt76_dma_rx_cleanup+0x94/0x120 [mt76
d94b4c9690089b7441d9b3262ec58606565d1b82]
Jan 29 14:21:58 chronos kernel:  mt7921_wpdma_reset+0xbc/0x1c0
[mt7921e 7e95012acfae7cc199e541d3b3dbe15de0128110]
Jan 29 14:21:58 chronos kernel:  mt7921_register_device+0x32b/0x5e0
[mt7921_common 19fe4291bf468cdc820d57b91bfc4be907d53377]
Jan 29 14:21:58 chronos kernel:  mt7921_pci_probe+0x1f1/0x230 [mt7921e
7e95012acfae7cc199e541d3b3dbe15de0128110]
Jan 29 14:21:58 chronos kernel:  ? __pm_runtime_resume+0x58/0x80
Jan 29 14:21:58 chronos kernel:  local_pci_probe+0x45/0x90
Jan 29 14:21:58 chronos kernel:  ? pci_match_device+0xdf/0x140
Jan 29 14:21:58 chronos kernel:  pci_device_probe+0xcf/0x1c0
Jan 29 14:21:58 chronos kernel:  really_probe+0x203/0x400
Jan 29 14:21:58 chronos kernel:  __driver_probe_device+0x112/0x190
Jan 29 14:21:58 chronos kernel:  driver_probe_device+0x1e/0x90
Jan 29 14:21:58 chronos kernel:  __driver_attach+0xc8/0x1e0
Jan 29 14:21:58 chronos kernel:  ? __device_attach_driver+0xf0/0xf0
Jan 29 14:21:58 chronos kernel:  ? __device_attach_driver+0xf0/0xf0
Jan 29 14:21:58 chronos kernel:  bus_for_each_dev+0x8d/0xe0
Jan 29 14:21:58 chronos kernel:  bus_add_driver+0x154/0x200
Jan 29 14:21:58 chronos kernel:  driver_register+0x8f/0xf0
Jan 29 14:21:58 chronos kernel:  ? 0xffffffffc0753000
Jan 29 14:21:58 chronos kernel:  do_one_initcall+0x57/0x220
Jan 29 14:21:58 chronos kernel:  do_init_module+0x5c/0x270
Jan 29 14:21:58 chronos kernel:  load_module+0x25d7/0x27a0
Jan 29 14:21:58 chronos kernel:  ? __alloc_pages_bulk+0x5e7/0x740
Jan 29 14:21:58 chronos kernel:  ? __do_sys_init_module+0x12e/0x1b0
Jan 29 14:21:58 chronos kernel:  __do_sys_init_module+0x12e/0x1b0
Jan 29 14:21:58 chronos kernel:  do_syscall_64+0x5c/0x90
Jan 29 14:21:58 chronos kernel:  ? ksys_read+0x67/0xf0
Jan 29 14:21:58 chronos kernel:  ? exc_page_fault+0x72/0x180
Jan 29 14:21:58 chronos kernel:  entry_SYSCALL_64_after_hwframe+0x44/0xae
Jan 29 14:21:58 chronos kernel: RIP: 0033:0x7f261332632e
Jan 29 14:21:58 chronos kernel: Code: 48 8b 0d 45 0b 0c 00 f7 d8 64 89
01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 90 f3 0f 1e fa 49 89
ca b8 af 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 12 0b 0c
00 f7 d8 64 89 01 48
Jan 29 14:21:58 chronos kernel: RSP: 002b:00007ffd2b6d7fd8 EFLAGS:
00000246 ORIG_RAX: 00000000000000af
Jan 29 14:21:58 chronos kernel: RAX: ffffffffffffffda RBX:
000056487d08e8b0 RCX: 00007f261332632e
Jan 29 14:21:58 chronos kernel: RDX: 00007f261347aa9d RSI:
000000000002b3af RDI: 000056487d408720
Jan 29 14:21:58 chronos kernel: RBP: 000056487d408720 R08:
27d4eb2f165667c5 R09: 0000000000000000
Jan 29 14:21:58 chronos kernel: R10: 000056487d0c3830 R11:
0000000000000246 R12: 00007f261347aa9d
Jan 29 14:21:58 chronos kernel: R13: 0000000000000001 R14:
000056487d0e5bd0 R15: 000056487d08e8b0
Jan 29 14:21:58 chronos kernel:  </TASK>
Jan 29 14:21:58 chronos kernel: Disabling lock debugging due to kernel taint

This is not a regression though, as it happens in 5.16.2 too.

Here's a full dmesg of the crash: http://dpaste.org/xtt5

-- 
Felipe Contreras
