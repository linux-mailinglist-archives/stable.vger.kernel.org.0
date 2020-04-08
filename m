Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 848DF1A1C54
	for <lists+stable@lfdr.de>; Wed,  8 Apr 2020 09:10:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726436AbgDHHKB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Apr 2020 03:10:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:60508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725763AbgDHHKA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Apr 2020 03:10:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CE43B20747;
        Wed,  8 Apr 2020 07:09:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586329799;
        bh=Pn07GfUi2OBrRK0vy9ZgztVMrpwsIlZqILaFJ8JMT8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E+oUWj65Yc8b7rVWri5Q7a9ChCF1by475i5lsSAtyPiIl4CGoMobw71X6Fc3aUBOz
         kl/wAysGZfnauP+YYMlMI4fXsmhC1nGgUqNl88WzOYnBM6JLH7Vvh0FPwL1aWi13go
         7tFK/+EEsg9miqOQLUNWA7YnUmyuatmdWF/Gz9h8=
Date:   Wed, 8 Apr 2020 09:09:57 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     shuah <shuah@kernel.org>
Cc:     Guenter Roeck <linux@roeck-us.net>, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
Subject: Re: [PATCH 5.6 00/30] 5.6.3-rc2 review
Message-ID: <20200408070957.GB1019278@kroah.com>
References: <20200407154752.006506420@linuxfoundation.org>
 <ecfe71d8-41f5-9579-555a-3678b3588dea@kernel.org>
 <09e7cfc4-52c3-4412-cf7a-4138e52f6580@kernel.org>
 <59277ae6-76ba-de79-eaa6-624e55ac56c9@roeck-us.net>
 <3b0a2f46-d30d-f818-e295-699e819b4ccd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3b0a2f46-d30d-f818-e295-699e819b4ccd@kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 07, 2020 at 01:51:06PM -0600, shuah wrote:
> On 4/7/20 1:33 PM, Guenter Roeck wrote:
> > On 4/7/20 12:18 PM, shuah wrote:
> > > On 4/7/20 1:02 PM, shuah wrote:
> > > > On 4/7/20 10:39 AM, Greg Kroah-Hartman wrote:
> > > > > This is the start of the stable review cycle for the 5.6.3 release.
> > > > > There are 30 patches in this series, all will be posted as a response
> > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > let me know.
> > > > > 
> > > > > Responses should be made by Thu, 09 Apr 2020 15:46:32 +0000.
> > > > > Anything received after that time might be too late.
> > > > > 
> > > > > The whole patch series can be found in one patch at:
> > > > >      https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.3-rc2.gz
> > > > > or in the git tree and branch at:
> > > > >      git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
> > > > > and the diffstat can be found below.
> > > > > 
> > > > > thanks,
> > > > > 
> > > > > greg k-h
> > > > > 
> > > > 
> > > > Compiled and booted on my test system. No dmesg regressions.
> > > > 
> > > > thanks,
> > > > -- Shuah
> > > > 
> > > 
> > > Okay. After a reboot ran into the following problem with wifi.
> > > Turning wifi off and on worked.
> > > 
> > > 
> > > [    4.499152] Generic FE-GE Realtek PHY r8169-100:00: attached PHY driver [Generic FE-GE Realtek PHY] (mii_bus:phy_addr=r8169-100:00, irq=IGNORE)
> > > [    4.596676] r8169 0000:01:00.0 enp1s0f0: Link is Down
> > > [    9.916063] ath10k_pci 0000:02:00.0: wmi service ready event not received
> > > [    9.996205] ath10k_pci 0000:02:00.0: Could not init core: -110
> > > [   10.127822] rfkill: input handler disabled
> > > [   15.268624] wlp2s0: authenticate with c0:56:27:75:aa:b4
> > > [   15.336248] wlp2s0: send auth to c0:56:27:75:aa:b4 (try 1/3)
> > > [   15.357599] wlp2s0: authenticated
> > > [   15.358081] wlp2s0: associating with AP with corrupt probe response
> > > [   15.360036] wlp2s0: associate with c0:56:27:75:aa:b4 (try 1/3)
> > > [   15.388367] wlp2s0: RX AssocResp from c0:56:27:75:aa:b4 (capab=0x411 status=0 aid=1)
> > > [   15.389937] ------------[ cut here ]------------
> > > [   15.389955] WARNING: CPU: 5 PID: 0 at drivers/net/wireless/ath/ath10k/htt_rx.c:35 ath10k_htt_rx_pop_paddr.isra.0+0xca/0x100 [ath10k_core]
> > > [   15.389956] Modules linked in: cmac bnep binfmt_misc nls_iso8859_1 edac_mce_amd kvm_amd kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel amdgpu snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio snd_usb_audio snd_hda_codec_hdmi snd_usbmidi_lib snd_seq_midi snd_hda_intel snd_seq_midi_event snd_intel_dspcfg snd_hda_codec aesni_intel snd_rawmidi crypto_simd snd_hda_core btusb amd_iommu_v2 cryptd snd_hwdep ath10k_pci glue_helper btrtl gpu_sched ath10k_core btbcm ttm btintel mc snd_seq bluetooth snd_pcm ath serio_raw k10temp wmi_bmof snd_seq_device drm_kms_helper pl2303 input_leds ecdh_generic ecc snd_pci_acp3x mac80211 cec snd_timer drm snd cfg80211 i2c_algo_bit fb_sys_fops ipmi_devintf syscopyarea sysfillrect sysimgblt ccp soundcore libarc4 ipmi_msghandler mac_hid sch_fq_codel parport_pc ppdev lp parport ip_tables x_tables autofs4 hid_generic usbhid hid ahci psmouse i2c_piix4 libahci nvme nvme_core r8169 realtek wmi video
> > > [   15.389998] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 5.6.3-rc2+ #4
> > > [   15.389999] Hardware name: LENOVO 10VGCTO1WW/3130, BIOS M1XKT45A 08/21/2019
> > > [   15.390011] RIP: 0010:ath10k_htt_rx_pop_paddr.isra.0+0xca/0x100 [ath10k_core]
> > > [   15.390014] Code: 8b b8 a8 02 00 00 48 8b 87 40 02 00 00 48 85 c0 74 24 48 8b 40 28 48 85 c0 74 14 45 31 c0 b9 02 00 00 00 e8 08 1e 6b fc eb 05 <0f> 0b 45 31 e4 4c 89 e0 41 5c 5d c3 48 8b 05 b3 2d 3d fd 48 85 c0
> > > [   15.390016] RSP: 0018:ffffa10d002ecd78 EFLAGS: 00010246
> > > [   15.390017] RAX: 0000000000000000 RBX: ffff8d94fd1a4750 RCX: ffff8d952f761e80
> > > [   15.390019] RDX: 000000007fee6d00 RSI: ffff8d952f76293c RDI: ffff8d952f762828
> > > [   15.390020] RBP: ffffa10d002ecd80 R08: 0000000000200000 R09: ffff8d94fd08b758
> > > [   15.390021] R10: 0000000000000000 R11: 000ffffffffff000 R12: ffff8d94fd1a4748
> > > [   15.390022] R13: ffffa10d002ece28 R14: ffff8d952f761e80 R15: ffff8d952f761e80
> > > [   15.390024] FS:  0000000000000000(0000) GS:ffff8d9537b40000(0000) knlGS:0000000000000000
> > > [   15.390025] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [   15.390026] CR2: 0000561a638de9c0 CR3: 000000023171a000 CR4: 00000000003406e0
> > > [   15.390027] Call Trace:
> > > [   15.390029]  <IRQ>
> > > [   15.390042]  ath10k_htt_txrx_compl_task+0x758/0x14b0 [ath10k_core]
> > > [   15.390048]  ath10k_pci_napi_poll+0x56/0x120 [ath10k_pci]
> > > [   15.390053]  net_rx_action+0x13a/0x370
> > > [   15.390057]  __do_softirq+0xe1/0x2d6
> > > [   15.390061]  irq_exit+0xae/0xb0
> > > [   15.390064]  do_IRQ+0x5a/0xf0
> > > [   15.390067]  common_interrupt+0xf/0xf
> > > [   15.390068]  </IRQ>
> > > [   15.390072] RIP: 0010:cpuidle_enter_state+0xca/0x3e0
> > > [   15.390074] Code: ff e8 8a 56 80 ff 80 7d c7 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 ea 02 00 00 31 ff e8 1d d6 86 ff fb 66 0f 1f 44 00 00 <45> 85 e4 0f 88 3f 02 00 00 49 63 d4 4c 8b 7d d0 4c 2b 7d c8 48 8d
> > > [   15.390075] RSP: 0018:ffffa10d0018fe38 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffd9
> > > [   15.390077] RAX: ffff8d9537b6ce40 RBX: ffff8d9534a93c00 RCX: 000000000000001f
> > > [   15.390078] RDX: 0000000000000000 RSI: 00000000280a5e6f RDI: 0000000000000000
> > > [   15.390079] RBP: ffffa10d0018fe78 R08: 00000003954e39cc R09: ffffffffbd977140
> > > [   15.390079] R10: ffff8d9537b6bb04 R11: ffff8d9537b6bae4 R12: 0000000000000001
> > > [   15.390080] R13: ffffffffbd977140 R14: 0000000000000001 R15: ffff8d9534a93c00
> > > [   15.390086]  ? cpuidle_enter_state+0xa6/0x3e0
> > > [   15.390089]  cpuidle_enter+0x2e/0x40
> > > [   15.390092]  call_cpuidle+0x23/0x40
> > > [   15.390094]  do_idle+0x1e7/0x280
> > > [   15.390097]  cpu_startup_entry+0x20/0x30
> > > [   15.390100]  start_secondary+0x167/0x1c0
> > > [   15.390103]  secondary_startup_64+0xa4/0xb0
> > > [   15.390106] ---[ end trace 60c3cabcf041b110 ]---
> > > [   15.390118] ath10k_pci 0000:02:00.0: failed to pop paddr list: -2
> > > [   15.390840] wlp2s0: associated
> > > [   19.387476] wlp2s0: deauthenticated from c0:56:27:75:aa:b4 (Reason: 2=PREV_AUTH_NOT_VALID)
> > > [   24.377944] wlp2s0: authenticate with c0:56:27:75:aa:b4
> > > 
> > 
> > I don't immediately see a change that might be responsible for this problem. Since v5.5,
> > possibly, but not since v5.6. That makes me wonder if this is reproducible. Any idea ?
> > 
> > Thanks,
> > Guenter
> 
> Yeah I didn't see anything obvious either.
> 
> I am running into an existing problem. No reason to hold this release
> up for this problem.

Thanks for testing all of these, and hopefully this doesn't act up again


greg k-h
