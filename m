Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3281A1606
	for <lists+stable@lfdr.de>; Tue,  7 Apr 2020 21:34:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgDGTeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Apr 2020 15:34:03 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:40749 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726339AbgDGTeC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Apr 2020 15:34:02 -0400
Received: by mail-pl1-f193.google.com with SMTP id h11so1609922plk.7;
        Tue, 07 Apr 2020 12:34:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:subject:to:cc:references:from:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KnISTUXkrpJOZNOLPPUeUlOo5++rnfSlFlIlo8bnd+0=;
        b=LmHI60sijLK24tnaTgLI9USJH4trCoNz+tsOrTzALI5vx4Pi/Tu2Hxbz1hbeG1xn/o
         /0eYmRAytZKzXOdynp8Cm9ciwzRMLY8RH5NbfvoarLUczw18yb3pnEctT6+x7R3KwYKL
         cbn3ebS+q/p4ylPgee0GWT9pcxGZUYGiduXnOznnwusEMudU41p9M91HhfTfbF4on2us
         wUxT2b2zLpvapQe2M45tEkpu6XSuJ5IzMvKFeqgPb7hrYxiOsMDZMMNJQkrWZjvcl0YS
         uEZQYIYGF+HNi1c9xNybwew27/icDKSEYaKbH/cX7XoUtl7fC4NNUwAw6f6ghWFGJQpY
         UaIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=KnISTUXkrpJOZNOLPPUeUlOo5++rnfSlFlIlo8bnd+0=;
        b=szyG9c+DlqaHDo0xp+le8443SVPA9iVsMrD/pEpTVTsL3cIEwyyNA7MxCx4r/AkmnY
         lzjV5xfIwXeDiraenBdhYIT0Nz38tCCxnx6Z+LrtbyjvUWQQmokUhi+bpT8NdTxti4Kz
         hWoNVuzTABnNUUDORezmi7aRr1u5fNDv4uiurARKZBFEmaKwVK8m6ChLTH/5pjwySJHD
         g2Z8dDFM7UGDHWINN7IN2iqk2NFkwvaH+h+4POxkhK5mGwXQUa9HUU6+adsOt8Oxipi3
         NP1LgYV3ITSe33YebtAMeC9/GcyxSSWU0ZgRpQqdFb98rQM9qFOJptu/9D9HblEgH2a1
         9iAQ==
X-Gm-Message-State: AGi0Pua7pz7rlf1HReXJzyVahFWW2UmrpbWB7bg5MGz48jlm2pK8Aly1
        UfxDRpHP0TT4LJRI8M94aXg7/9zn
X-Google-Smtp-Source: APiQypLrgvKUpOFX+keraR7EmzRuo/iaVm0q5wQphkIc6J6+G9NuvAFkKSfMpZDOyNjRHvgY1UTBgA==
X-Received: by 2002:a17:902:988e:: with SMTP id s14mr3785963plp.179.1586288041170;
        Tue, 07 Apr 2020 12:34:01 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z66sm14412677pfz.30.2020.04.07.12.33.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Apr 2020 12:34:00 -0700 (PDT)
Subject: Re: [PATCH 5.6 00/30] 5.6.3-rc2 review
To:     shuah <shuah@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org, stable@vger.kernel.org
References: <20200407154752.006506420@linuxfoundation.org>
 <ecfe71d8-41f5-9579-555a-3678b3588dea@kernel.org>
 <09e7cfc4-52c3-4412-cf7a-4138e52f6580@kernel.org>
From:   Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
Message-ID: <59277ae6-76ba-de79-eaa6-624e55ac56c9@roeck-us.net>
Date:   Tue, 7 Apr 2020 12:33:58 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <09e7cfc4-52c3-4412-cf7a-4138e52f6580@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/7/20 12:18 PM, shuah wrote:
> On 4/7/20 1:02 PM, shuah wrote:
>> On 4/7/20 10:39 AM, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 5.6.3 release.
>>> There are 30 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Thu, 09 Apr 2020 15:46:32 +0000.
>>> Anything received after that time might be too late.
>>>
>>> The whole patch series can be found in one patch at:
>>>     https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.6.3-rc2.gz
>>> or in the git tree and branch at:
>>>     git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.6.y
>>> and the diffstat can be found below.
>>>
>>> thanks,
>>>
>>> greg k-h
>>>
>>
>> Compiled and booted on my test system. No dmesg regressions.
>>
>> thanks,
>> -- Shuah
>>
> 
> Okay. After a reboot ran into the following problem with wifi.
> Turning wifi off and on worked.
> 
> 
> [    4.499152] Generic FE-GE Realtek PHY r8169-100:00: attached PHY driver [Generic FE-GE Realtek PHY] (mii_bus:phy_addr=r8169-100:00, irq=IGNORE)
> [    4.596676] r8169 0000:01:00.0 enp1s0f0: Link is Down
> [    9.916063] ath10k_pci 0000:02:00.0: wmi service ready event not received
> [    9.996205] ath10k_pci 0000:02:00.0: Could not init core: -110
> [   10.127822] rfkill: input handler disabled
> [   15.268624] wlp2s0: authenticate with c0:56:27:75:aa:b4
> [   15.336248] wlp2s0: send auth to c0:56:27:75:aa:b4 (try 1/3)
> [   15.357599] wlp2s0: authenticated
> [   15.358081] wlp2s0: associating with AP with corrupt probe response
> [   15.360036] wlp2s0: associate with c0:56:27:75:aa:b4 (try 1/3)
> [   15.388367] wlp2s0: RX AssocResp from c0:56:27:75:aa:b4 (capab=0x411 status=0 aid=1)
> [   15.389937] ------------[ cut here ]------------
> [   15.389955] WARNING: CPU: 5 PID: 0 at drivers/net/wireless/ath/ath10k/htt_rx.c:35 ath10k_htt_rx_pop_paddr.isra.0+0xca/0x100 [ath10k_core]
> [   15.389956] Modules linked in: cmac bnep binfmt_misc nls_iso8859_1 edac_mce_amd kvm_amd kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel amdgpu snd_hda_codec_realtek snd_hda_codec_generic ledtrig_audio snd_usb_audio snd_hda_codec_hdmi snd_usbmidi_lib snd_seq_midi snd_hda_intel snd_seq_midi_event snd_intel_dspcfg snd_hda_codec aesni_intel snd_rawmidi crypto_simd snd_hda_core btusb amd_iommu_v2 cryptd snd_hwdep ath10k_pci glue_helper btrtl gpu_sched ath10k_core btbcm ttm btintel mc snd_seq bluetooth snd_pcm ath serio_raw k10temp wmi_bmof snd_seq_device drm_kms_helper pl2303 input_leds ecdh_generic ecc snd_pci_acp3x mac80211 cec snd_timer drm snd cfg80211 i2c_algo_bit fb_sys_fops ipmi_devintf syscopyarea sysfillrect sysimgblt ccp soundcore libarc4 ipmi_msghandler mac_hid sch_fq_codel parport_pc ppdev lp parport ip_tables x_tables autofs4 hid_generic usbhid hid ahci psmouse i2c_piix4 libahci nvme nvme_core r8169 realtek wmi video
> [   15.389998] CPU: 5 PID: 0 Comm: swapper/5 Not tainted 5.6.3-rc2+ #4
> [   15.389999] Hardware name: LENOVO 10VGCTO1WW/3130, BIOS M1XKT45A 08/21/2019
> [   15.390011] RIP: 0010:ath10k_htt_rx_pop_paddr.isra.0+0xca/0x100 [ath10k_core]
> [   15.390014] Code: 8b b8 a8 02 00 00 48 8b 87 40 02 00 00 48 85 c0 74 24 48 8b 40 28 48 85 c0 74 14 45 31 c0 b9 02 00 00 00 e8 08 1e 6b fc eb 05 <0f> 0b 45 31 e4 4c 89 e0 41 5c 5d c3 48 8b 05 b3 2d 3d fd 48 85 c0
> [   15.390016] RSP: 0018:ffffa10d002ecd78 EFLAGS: 00010246
> [   15.390017] RAX: 0000000000000000 RBX: ffff8d94fd1a4750 RCX: ffff8d952f761e80
> [   15.390019] RDX: 000000007fee6d00 RSI: ffff8d952f76293c RDI: ffff8d952f762828
> [   15.390020] RBP: ffffa10d002ecd80 R08: 0000000000200000 R09: ffff8d94fd08b758
> [   15.390021] R10: 0000000000000000 R11: 000ffffffffff000 R12: ffff8d94fd1a4748
> [   15.390022] R13: ffffa10d002ece28 R14: ffff8d952f761e80 R15: ffff8d952f761e80
> [   15.390024] FS:  0000000000000000(0000) GS:ffff8d9537b40000(0000) knlGS:0000000000000000
> [   15.390025] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   15.390026] CR2: 0000561a638de9c0 CR3: 000000023171a000 CR4: 00000000003406e0
> [   15.390027] Call Trace:
> [   15.390029]  <IRQ>
> [   15.390042]  ath10k_htt_txrx_compl_task+0x758/0x14b0 [ath10k_core]
> [   15.390048]  ath10k_pci_napi_poll+0x56/0x120 [ath10k_pci]
> [   15.390053]  net_rx_action+0x13a/0x370
> [   15.390057]  __do_softirq+0xe1/0x2d6
> [   15.390061]  irq_exit+0xae/0xb0
> [   15.390064]  do_IRQ+0x5a/0xf0
> [   15.390067]  common_interrupt+0xf/0xf
> [   15.390068]  </IRQ>
> [   15.390072] RIP: 0010:cpuidle_enter_state+0xca/0x3e0
> [   15.390074] Code: ff e8 8a 56 80 ff 80 7d c7 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 0f 85 ea 02 00 00 31 ff e8 1d d6 86 ff fb 66 0f 1f 44 00 00 <45> 85 e4 0f 88 3f 02 00 00 49 63 d4 4c 8b 7d d0 4c 2b 7d c8 48 8d
> [   15.390075] RSP: 0018:ffffa10d0018fe38 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffd9
> [   15.390077] RAX: ffff8d9537b6ce40 RBX: ffff8d9534a93c00 RCX: 000000000000001f
> [   15.390078] RDX: 0000000000000000 RSI: 00000000280a5e6f RDI: 0000000000000000
> [   15.390079] RBP: ffffa10d0018fe78 R08: 00000003954e39cc R09: ffffffffbd977140
> [   15.390079] R10: ffff8d9537b6bb04 R11: ffff8d9537b6bae4 R12: 0000000000000001
> [   15.390080] R13: ffffffffbd977140 R14: 0000000000000001 R15: ffff8d9534a93c00
> [   15.390086]  ? cpuidle_enter_state+0xa6/0x3e0
> [   15.390089]  cpuidle_enter+0x2e/0x40
> [   15.390092]  call_cpuidle+0x23/0x40
> [   15.390094]  do_idle+0x1e7/0x280
> [   15.390097]  cpu_startup_entry+0x20/0x30
> [   15.390100]  start_secondary+0x167/0x1c0
> [   15.390103]  secondary_startup_64+0xa4/0xb0
> [   15.390106] ---[ end trace 60c3cabcf041b110 ]---
> [   15.390118] ath10k_pci 0000:02:00.0: failed to pop paddr list: -2
> [   15.390840] wlp2s0: associated
> [   19.387476] wlp2s0: deauthenticated from c0:56:27:75:aa:b4 (Reason: 2=PREV_AUTH_NOT_VALID)
> [   24.377944] wlp2s0: authenticate with c0:56:27:75:aa:b4
> 

I don't immediately see a change that might be responsible for this problem. Since v5.5,
possibly, but not since v5.6. That makes me wonder if this is reproducible. Any idea ?

Thanks,
Guenter
