Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B728D10F7C0
	for <lists+stable@lfdr.de>; Tue,  3 Dec 2019 07:25:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726521AbfLCGZK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Dec 2019 01:25:10 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:37369 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbfLCGZJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Dec 2019 01:25:09 -0500
Received: by mail-pj1-f66.google.com with SMTP id ep17so1096216pjb.4
        for <stable@vger.kernel.org>; Mon, 02 Dec 2019 22:25:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=DVbs4fkEGuf5IXVKBq4udJBOFfsKR0wmrJFYc+yCbLU=;
        b=my1eyiERy4GNV5TCtwgMAiy6R7JaXo5Ie7A//llnv2cHjHKvG82MA1pS6XWzEMkupo
         11CPzo7UAuLL0lAVBihRJVtxadpD36j//8wY2b+vOvAl/f3Em8kkksxHsSxTAztsjxGw
         mqAtSo+V7le+7VM/sxfjxZWOSjk4e+1fUm24HOERnI54aHXDlzxHdtNyq4gQsmt8/EYp
         kgbQhl34wGVisElif4xqphcNV+AdjBCBVLdywINZ2J4lcvryMJR6RxCF9f7hLAB4agfL
         SvytQUsoZ7oONljpKOITUzXVvnnCuWXffiMRNYq1YUGkB+YXUuCXr6OSfj99L7roR/Ya
         Xt4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=DVbs4fkEGuf5IXVKBq4udJBOFfsKR0wmrJFYc+yCbLU=;
        b=fKq/znjTP43VJ5ZrN8CI4W8YGyVoOBS+nIQgRVyQ9XZYQxDv3dgT3xXOlLZWLqW32c
         jjMJe/JLDoVqLIJHv3ZMjqLmyrZJKCbB/RK2Af0ch+pSoJwjxS3XU0zrlw34ugcMn+Ul
         YU8WD7qBu4VNE7PGCnDesIUxllUqZRoWxqxSPjf+p9aTvG/UeKkpnjcl8DTawY/DY4yT
         Ze5k4f06FR8ddsj8gb9S0ng9BxyeeFBGo98v10ShVgzuPPhE7E+OB7DjfqmfnceZv5zZ
         1B1J9tG7QvJHCOMWOo+8Djg5cAWAo8E6VvB+E1UBWebay9eT0nVrhFj2wZpPYBddJlt/
         jVsQ==
X-Gm-Message-State: APjAAAWMyrORFbP5nbUd7EJfAYeiG9fqPEopc17EjRmu68r9I/54M0qb
        U0Us0zvdOdNfrQcEJGu+xpKnx9Y3
X-Google-Smtp-Source: APXvYqwq69p1eB+Vf81TDRG8DUhNsPALZp3va5Au8m82zEQToq5MIpKmKCq4NxohSdivSIKBCuCElQ==
X-Received: by 2002:a17:902:820f:: with SMTP id x15mr3421433pln.125.1575354308133;
        Mon, 02 Dec 2019 22:25:08 -0800 (PST)
Received: from workstation-kernel-dev ([139.5.253.93])
        by smtp.gmail.com with ESMTPSA id k19sm1767276pfg.132.2019.12.02.22.25.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Dec 2019 22:25:07 -0800 (PST)
Date:   Tue, 3 Dec 2019 11:55:03 +0530
From:   Amol Grover <frextrite@gmail.com>
To:     stable@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: [STABLE TEST] 5.3.13
Message-ID: <20191203062503.GA3467@workstation-kernel-dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Compiled, Booted, however I'm getting the following errors when running
"make kselftest"

sudo dmesg -l alert

[34381.903893] BUG: kernel NULL pointer dereference, address: 0000000000000008
[34381.903904] #PF: supervisor read access in kernel mode
[34381.903908] #PF: error_code(0x0000) - not-present page

Trace:
[ 1579.452570] BUG: kernel NULL pointer dereference, address: 0000000000000008
[ 1579.452579] #PF: supervisor read access in kernel mode
[ 1579.452582] #PF: error_code(0x0000) - not-present page
[ 1579.452585] PGD 8000000189d75067 P4D 8000000189d75067 PUD 2330c6067 PMD 0 
[ 1579.452594] Oops: 0000 [#1] SMP PTI
[ 1579.452600] CPU: 2 PID: 11596 Comm: tls Tainted: G        W   E K   5.3.13-stable #5
[ 1579.452604] Hardware name: Gigabyte Technology Co., Ltd. Z170-D3H/Z170-D3H-CF, BIOS F21 03/06/2017
[ 1579.452623] RIP: 0010:gcmaes_crypt_by_sg.constprop.0+0x52e/0x6c0 [aesni_intel]
[ 1579.452629] Code: 08 49 89 c2 e9 bd fd ff ff 4c 89 ef 4c 89 5c 24 20 4c 89 4c 24 28 4c 89 54 24 30 e8 8c 68 3c f9 4c 8b 54 24 30 4c 8b 4c 24 28 <44> 8b 60 08 49 89 c5 4c 8b 5c 24 20 41 8b 42 08 41 03 42 0c 85 db
[ 1579.452633] RSP: 0018:ffffa5eb424ab5c0 EFLAGS: 00010246
[ 1579.452637] RAX: 0000000000000000 RBX: 000000000000000d RCX: ffff91c9731a0e00
[ 1579.452640] RDX: ffff91c92b6100d5 RSI: ffffa5eb424ab6a0 RDI: ffff91c9731a0e08
[ 1579.452643] RBP: ffffa5eb424ab860 R08: 0000000000000001 R09: ffff91c933f35e80
[ 1579.452646] R10: ffff91c9731a0af8 R11: ffff91c933f35e80 R12: 0000000000000e01
[ 1579.452649] R13: ffff91c9731a0e08 R14: 00000000000000d6 R15: 0000000000000001
[ 1579.452653] FS:  00007fc08bdbd540(0000) GS:ffff91c976b00000(0000) knlGS:0000000000000000
[ 1579.452656] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1579.452659] CR2: 0000000000000008 CR3: 00000002257ae005 CR4: 00000000003606e0
[ 1579.452663] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[ 1579.452666] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[ 1579.452668] Call Trace:
[ 1579.452684]  ? __ip_finish_output+0x1c0/0x1c0
[ 1579.452691]  ? __ip_queue_xmit+0x157/0x410
[ 1579.452698]  ? lock_timer_base+0x61/0x80
[ 1579.452706]  ? sk_reset_timer+0x14/0x30
[ 1579.452715]  ? __tcp_push_pending_frames+0x32/0xf0
[ 1579.452721]  ? do_tcp_sendpages+0x581/0x5d0
[ 1579.452737]  generic_gcmaes_encrypt+0x5e/0x80 [aesni_intel]
[ 1579.452745]  ? simd_aead_encrypt+0xb0/0xc0 [crypto_simd]
[ 1579.452755]  tls_push_record+0x498/0xaa0 [tls]
[ 1579.452763]  ? scatterwalk_map_and_copy+0x4e/0x70
[ 1579.452772]  bpf_exec_tx_verdict+0x3c2/0x470 [tls]
[ 1579.452789]  tls_sw_sendmsg+0x5af/0x670 [tls]
[ 1579.452798]  sock_sendmsg+0x57/0x60
[ 1579.452806]  ___sys_sendmsg+0x2ae/0x330
[ 1579.452813]  ? tls_sw_recvmsg+0x38e/0x640 [tls]
[ 1579.452822]  ? inet_recvmsg+0xdd/0xf0
[ 1579.452826]  ? __sys_recvfrom+0x166/0x180
[ 1579.452832]  __sys_sendmsg+0x59/0xa0
[ 1579.452842]  do_syscall_64+0x6e/0x200
[ 1579.452849]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
[ 1579.452854] RIP: 0033:0x7fc08bcf5943
[ 1579.452859] Code: c7 c0 ff ff ff ff eb bb 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 2e 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 55 c3 0f 1f 40 00 48 83 ec 28 89 54 24 1c 48
[ 1579.452863] RSP: 002b:00007ffe24bbdb98 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
[ 1579.452867] RAX: ffffffffffffffda RBX: 0000000000411b80 RCX: 00007fc08bcf5943
[ 1579.452870] RDX: 0000000000000000 RSI: 00007ffe24bbdbb0 RDI: 0000000000000005
[ 1579.452873] RBP: 00007ffe24bbdccd R08: 0000000000000000 R09: 0000000000000000
[ 1579.452876] R10: 0000000000000100 R11: 0000000000000246 R12: 00007ffe24bbe040
[ 1579.452879] R13: 00000000000000dd R14: 0000000000000011 R15: 00007ffe24bbdcc0
[ 1579.452884] Modules linked in: tls(E) test_klp_livepatch(EK) ir_rcmm_decoder(E) ir_imon_decoder(E) ir_sharp_decoder(E) ir_rc6_decoder(E) ir_sanyo_decoder(E) ir_nec_decoder(E) ir_sony_decoder(E) ir_jvc_decoder(E) ir_rc5_decoder(E) rc_loopback(E) rc_core(E) test_firmware(E) binfmt_misc(E) fuse(E) af_packet(E) xt_tcpudp(E) ip6t_REJECT(E) nf_reject_ipv6(E) ip6t_rpfilter(E) ipt_REJECT(E) nf_reject_ipv4(E) xt_conntrack(E) ebtable_nat(E) ebtable_broute(E) ip6table_nat(E) ip6table_mangle(E) ip6table_raw(E) ip6table_security(E) iptable_nat(E) nf_nat(E) iptable_mangle(E) iptable_raw(E) iptable_security(E) nf_conntrack(E) nf_defrag_ipv6(E) nf_defrag_ipv4(E) libcrc32c(E) scsi_transport_iscsi(E) ip_set(E) nfnetlink(E) ebtable_filter(E) ebtables(E) ip6table_filter(E) ip6_tables(E) iptable_filter(E) ip_tables(E) x_tables(E) bpfilter(E) dmi_sysfs(E) msr(E) intel_rapl_msr(E) intel_rapl_common(E) x86_pkg_temp_thermal(E) intel_powerclamp(E) coretemp(E) kvm_intel(E) kvm(E) snd_usb_audio(E)
[ 1579.452932]  snd_hda_codec_realtek(E) snd_hda_codec_generic(E) snd_hda_codec_hdmi(E) ledtrig_audio(E) snd_usbmidi_lib(E) irqbypass(E) snd_hda_intel(E) snd_rawmidi(E) snd_seq_device(E) snd_hda_codec(E) mc(E) crct10dif_pclmul(E) iTCO_wdt(E) crc32_pclmul(E) snd_hda_core(E) iTCO_vendor_support(E) ghash_clmulni_intel(E) snd_hwdep(E) aesni_intel(E) snd_pcm(E) aes_x86_64(E) crypto_simd(E) intel_wmi_thunderbolt(E) cryptd(E) glue_helper(E) joydev(E) mei_hdcp(E) i2c_i801(E) pcspkr(E) snd_timer(E) mei_me(E) thermal(E) mei(E) snd(E) e1000e(E) soundcore(E) acpi_pad(E) fan(E) nls_iso8859_1(E) nls_cp437(E) vfat(E) fat(E) hid_generic(E) usbhid(E) nouveau(E) mxm_wmi(E) i2c_algo_bit(E) drm_kms_helper(E) syscopyarea(E) sysfillrect(E) sysimgblt(E) fb_sys_fops(E) crc32c_intel(E) ttm(E) drm(E) xhci_pci(E) xhci_hcd(E) usbcore(E) wmi(E) video(E) button(E) sg(E) dm_multipath(E) dm_mod(E) scsi_dh_rdac(E) scsi_dh_emc(E) scsi_dh_alua(E) efivarfs(E) [last unloaded: notifier_error_inject]
[ 1579.452991] CR2: 0000000000000008
[ 1579.452995] ---[ end trace c3df09d5c7a5ef50 ]---


sudo dmesg -l emerg

[ 1856.860524] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 1866.936476] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 1877.016429] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 1887.096378] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 1897.176330] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 1907.256360] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 1917.336313] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 1927.448251] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 1937.528206] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 1947.608139] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 1957.688112] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 1967.768065] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 1977.848020] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 1987.927952] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 1998.007922] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2008.087865] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2018.167818] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2028.247784] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2038.327732] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2048.407687] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2058.487640] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2068.567603] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2078.647560] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2088.727545] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2098.807492] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2108.887433] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2118.967396] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2129.047352] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2139.159285] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2149.239254] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2159.319218] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2169.403156] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2179.483105] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2189.559067] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2199.639007] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2209.718951] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2219.798926] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2229.878847] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2239.958736] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2250.038738] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2260.118712] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2270.202622] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2280.278568] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2290.358485] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2300.442453] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2310.522393] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2320.598324] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2330.678274] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2340.758260] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2350.838208] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2360.918131] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2370.998092] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2381.078076] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2391.157985] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2401.269942] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2411.349835] unregister_netdevice: waiting for eth0 to become free. Usage count = 1
[ 2421.429831] unregister_netdevice: waiting for eth0 to become free. Usage count = 1


Thanks
Amol
