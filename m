Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6310E32350D
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 02:20:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231193AbhBXBOk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 20:14:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232727AbhBXAkf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Feb 2021 19:40:35 -0500
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAC95C061574
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 16:12:58 -0800 (PST)
Received: by mail-io1-xd2d.google.com with SMTP id n14so180193iog.3
        for <stable@vger.kernel.org>; Tue, 23 Feb 2021 16:12:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=mZKDqHKHj9qwHLca+lbB5XOXD5NDI9hcA0G6Uy9fJ68=;
        b=GPv0rl3IdxPKGPX1LtHCHxw/PnB5w50MhdQRmo8X0IMwDe/X7vIhiCROtiDcMwWIL+
         5YloWTq4v/e+pqLTSExj+HleUlfLkFB8GudIemvY54uLfkOvvcY7wqaO0MWaFu7ik2My
         8kdsNHNMoE39KWqYM5iK9fObtCOky/uyNaTf0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mZKDqHKHj9qwHLca+lbB5XOXD5NDI9hcA0G6Uy9fJ68=;
        b=dyuwu4mcPMlAME1U0yhO2z7j2WP3pZ+dUxJ1NiupEHmLpvKU4OooERKIm6P7THHuWX
         kX/xDQg2crLNJyFkh7CVlINPgEZc+ARr5dzFIq178IdZgvn2xmPwCsxLqimQqbQj1b0R
         Jgf3qTGM0hBDVcz5KQZ2YjMoAe2DFZpbd2G0aoZDzQ5oT/LJbCJoFudF3shVIRYpW0Io
         p6lNW3lkApvBNn3fEhxd/US2HS2PuVDbpoebz701FfU7shXBQiReKEugnXLc436yCN/t
         c1dkCCEkou0aYrspGBmKRBYog0D00cgH/JMPLfcrRV6NMAAhGb5XjjfTRzfoZt9fSkF4
         TWKQ==
X-Gm-Message-State: AOAM531QLNFbO92hpNyx1eCVzSLFg9g4KX2n+g/nRQyIOsRq300x5h/o
        rnRS3bl90FIfQC+F1x7t/VVg4w==
X-Google-Smtp-Source: ABdhPJyWXfN0VZUcedY3IOGrq7iLmDA0JxXvIR6NNj7H+n68+eyQ2eRh4QeTpsj4EUJZ0f6lhyquwA==
X-Received: by 2002:a02:cadd:: with SMTP id f29mr2827082jap.48.1614125578171;
        Tue, 23 Feb 2021 16:12:58 -0800 (PST)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id x15sm299294ilv.31.2021.02.23.16.12.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Feb 2021 16:12:57 -0800 (PST)
Subject: Re: [PATCH 5.11 00/12] 5.11.1-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20210222121013.586597942@linuxfoundation.org>
 <9edd3b90-aa95-379f-01b1-ccbb3afec6ce@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <6359a822-c0b2-75f7-40e3-c0c7bf002e3f@linuxfoundation.org>
Date:   Tue, 23 Feb 2021 17:12:56 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <9edd3b90-aa95-379f-01b1-ccbb3afec6ce@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/23/21 2:05 PM, Shuah Khan wrote:
> On 2/22/21 5:12 AM, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 5.11.1 release.
>> There are 12 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Wed, 24 Feb 2021 12:07:46 +0000.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.11.1-rc1.gz 
>>
>> or in the git tree and branch at:
>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git 
>> linux-5.11.y
>> and the diffstat can be found below.
>>
>> thanks,
>>
>> greg k-h
>>
> 
> Compiled and booted on my test system. No dmesg regressions.
> 
> I made some progress on the drm/amdgpu display and kepboard
> problem.
> 
> My system has
>   amdgpu: ATOM BIOS: 113-RENOIR-026
> 
> I narrowed it down to the following as a possible lead to
> start looking:
> amdgpu 0000:0b:00.0: [drm] Cannot find any crtc or sizes
> 

It is resolved now. A hot-unplugged/plugged the HDMI cable which
triggered reset sequence. There might be link to  AMD_DC_HDCP
support, amdgpu_dm_atomic_commit changes that went into 5.10 and
this behavior.

I am basing this on not seeing the problem on Linux 5.4 and until
Linux 5.10. In any case, I wish I know more, but life is back to
normal now.

When I hot-unplugged/plugged the cable, saw the following dmesg:

amdgpu 0000:0b:00.0: [drm] fb0: amdgpudrmfb frame buffer device
kernel: [ 6704.580326] [drm:drm_atomic_helper_wait_for_flip_done 
[drm_kms_helper]] *ERROR* [CRTC:67:crtc-0] flip_done timed out
kernel: [ 6773.444316] [drm:drm_atomic_helper_wait_for_dependencies 
[drm_kms_helper]] *ERROR* [CRTC:67:crtc-0] flip_done timed out
kernel: [ 6783.684306] [drm:drm_atomic_helper_wait_for_dependencies 
[drm_kms_helper]] *ERROR* [PLANE:55:plane-3] flip_done timed out

The following

WARN_ON(acrtc_attach->pflip_status != AMDGPU_FLIP_NONE); fires:


kernel: [ 6783.750035] WARNING: CPU: 7 PID: 190 at 
drivers/gpu/drm/amd/amdgpu/../display/amdgpu_dm/amdgpu_dm.c:7754 
amdgpu_dm_atomic_commit_tail+0x2542/0x25d0 [amdgpu]
Feb 23 16:20:39 shuah-IC5 kernel: [ 6783.750392] Modules linked in: 
btrfs blake2b_generic xor raid6_pq ufs qnx4 hfsplus hfs minix ntfs msdos 
jfs xfs libcrc32c rfcomm ccm cmac algif_hash algif_skcipher af_alg bnep 
intel_rapl_msr intel_rapl_common amdgpu edac_mce_amd 
snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio nls_iso8859_1 
snd_hda_codec_hdmi snd_hda_intel kvm_amd snd_intel_dspcfg snd_hda_codec 
kvm snd_hda_core ath10k_pci snd_hwdep snd_pcm crct10dif_pclmul 
ath10k_core ghash_clmulni_intel ath iommu_v2 snd_seq_midi gpu_sched 
aesni_intel snd_seq_midi_event drm_ttm_helper mac80211 ttm snd_rawmidi 
btusb drm_kms_helper crypto_simd btrtl snd_seq cryptd btbcm rtsx_usb_ms 
cec glue_helper btintel snd_seq_device snd_timer rapl memstick rc_core 
bluetooth cfg80211 i2c_algo_bit snd fb_sys_fops syscopyarea sysfillrect 
snd_rn_pci_acp3x ecdh_generic wmi_bmof sysimgblt efi_pstore soundcore 
ccp joydev ecc k10temp input_leds snd_pci_acp3x libarc4 mac_hid 
sch_fq_codel parport_pc ppdev lp parport drm ip_tables x_tables autofs4
Feb 23 16:20:39 shuah-IC5 kernel: [ 6783.750506]  hid_generic usbhid 
rtsx_usb_sdmmc hid rtsx_usb nvme crc32_pclmul i2c_piix4 r8169 nvme_core 
ahci xhci_pci realtek libahci xhci_pci_renesas wmi video gpio_amdpt 
gpio_generic

kernel: [ 6783.750532] CPU: 7 PID: 190 Comm: kworker/7:1 Not tainted 
5.11.1 #1
kernel: [ 6783.750537] Hardware name: LENOVO 90Q30008US/3728, BIOS 
O4ZKT1CA 09/16/2020
kernel: [ 6783.750541] Workqueue: events dm_irq_work_func [amdgpu]
kernel: [ 6783.750859] RIP: 
0010:amdgpu_dm_atomic_commit_tail+0x2542/0x25d0 [amdgpu]
kernel: [ 6783.751159] Code: a0 fd ff ff 01 c7 85 9c fd ff ff 37 00 00 
00 c7 85 a4 fd ff ff 20 00 00 00 e8 ca ef 12 00 e9 e9 fa ff ff 0f 0b e9 
39 f9 ff ff <0f> 0b e9 88 f9 ff ff 0f 0b 0f 0b e9 9e f9 ff ff 49 8b 06 
41 0f b6
kernel: [ 6783.751162] RSP: 0018:ffffac390068fa48 EFLAGS: 00010002
kernel: [ 6783.751167] RAX: 0000000000000002 RBX: 0000000000000004 RCX: 
ffff9604442d7918
kernel: [ 6783.751169] RDX: 0000000000000001 RSI: 0000000000000297 RDI: 
ffff960444a80188
kernel: [ 6783.751172] RBP: ffffac390068fd48 R08: 0000000000000005 R09: 
0000000000000000
kernel: [ 6783.751174] R10: ffffac390068f998 R11: ffffac390068f99c R12: 
0000000000000297
kernel: [ 6783.751176] R13: ffff96048d131a00 R14: ffff9604442d7800 R15: 
ffff96048da29c00
kernel: [ 6783.751179] FS:  0000000000000000(0000) 
GS:ffff96073f1c0000(0000) knlGS:0000000000000000
kernel: [ 6783.751182] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
kernel: [ 6783.751185] CR2: 00005612d2a1a000 CR3: 0000000030010000 CR4: 
0000000000350ee0
kernel: [ 6783.751188] Call Trace:
kernel: [ 6783.751197]  ? irq_work_queue+0x2a/0x40
kernel: [ 6783.751205]  ? vprintk_emit+0x139/0x240
kernel: [ 6783.751218]  commit_tail+0x99/0x130 [drm_kms_helper]
kernel: [ 6783.751247]  drm_atomic_helper_commit+0x123/0x150 
[drm_kms_helper]
kernel: [ 6783.751273]  drm_atomic_commit+0x4a/0x50 [drm]
kernel: [ 6783.751323]  dm_restore_drm_connector_state+0xf3/0x170 [amdgpu]
kernel: [ 6783.751628]  handle_hpd_irq+0x11a/0x150 [amdgpu]
kernel: [ 6783.751923]  dm_irq_work_func+0x4e/0x60 [amdgpu]
kernel: [ 6783.752018]  process_one_work+0x220/0x3c0
kernel: [ 6783.752018]  worker_thread+0x53/0x420
kernel: [ 6783.752018]  kthread+0x12f/0x150
kernel: [ 6783.752018]  ? process_one_work+0x3c0/0x3c0
kernel: [ 6783.752018]  ? __kthread_bind_mask+0x70/0x70
kernel: [ 6783.752018]  ret_from_fork+0x22/0x30

thanks,
-- Shuah

