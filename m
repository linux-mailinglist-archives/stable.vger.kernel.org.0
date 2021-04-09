Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC0E835A82D
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 22:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhDIUzb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 16:55:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234298AbhDIUzb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 16:55:31 -0400
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FC6CC061762
        for <stable@vger.kernel.org>; Fri,  9 Apr 2021 13:55:18 -0700 (PDT)
Received: by mail-il1-x131.google.com with SMTP id w2so5777510ilj.12
        for <stable@vger.kernel.org>; Fri, 09 Apr 2021 13:55:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=6hMpOiSIwB9P1pmhgUat4Wuzv5g8vXfjIlrMwSbXm4Y=;
        b=g0o7vIE9GPFakyteUScum6iPcfsuHZiUfZcphYRB6bpRXzJFN99ZzUegI3YjpwxeqS
         6UdGOv1+CgMcZH4UtPzm5SmmMm/W+yztlp4MOl6JwfnQHqDWfp8LkcSwT3s9eKZIWedB
         jQxqJ4qbtv0kXgWxDJTC7s34oMBdOwq1c+Hlk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6hMpOiSIwB9P1pmhgUat4Wuzv5g8vXfjIlrMwSbXm4Y=;
        b=QtonkE3x7NyFVf2kBI6WYHUxLY5fmGW786YtivqX+Fl/GyzhLwJPHShpBnctlVp50h
         jDi0snIutrdlFGnXS0SFTssk1yYdfliWHHvSmMI6tUq6L7bSRYlM16zwOPSNAtjxh4H2
         1KX/P1JdFGln7Xy1/kCEw0kRsFfhb7XQKrA1sHVwsJBp2BvEdFVKN3k5HbqtcM3tTU8X
         MkbLxoEpGL7CJeykcnVU0gLlVOhfJ2uNeVwk8gx+2/ETwjLp8PWY2I5lTs6tYAMLQkz8
         69IswPMPEn7kve5gD9bZg3b9euLRFFOaotG6JXwTWN8Bb/RoS1D/YYDBSg4PoXgk1D9A
         OlgQ==
X-Gm-Message-State: AOAM532ldTTSjcveOjyQZzmLir47jqooGEoaWnmF1Y5jre7qPNsVzKOI
        sv1wsnTMTdf0zNF/DDtrwTmHhA==
X-Google-Smtp-Source: ABdhPJx9KZQgGD/mDdUoAWlvowRa2dNB37Vyuo9GzdZxAsl/od8cRd6pWXc/kMPenKZjB3+BKUWcgg==
X-Received: by 2002:a05:6e02:1aab:: with SMTP id l11mr13099966ilv.150.1618001717704;
        Fri, 09 Apr 2021 13:55:17 -0700 (PDT)
Received: from [192.168.1.112] (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.gmail.com with ESMTPSA id t9sm1695900ioi.27.2021.04.09.13.55.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Apr 2021 13:55:17 -0700 (PDT)
Subject: Re: [PATCH 4.19 00/18] 4.19.186-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org,
        Shuah Khan <skhan@linuxfoundation.org>,
        Shuah Khan <skhan@linuxfoundation.org>
References: <20210409095301.525783608@linuxfoundation.org>
From:   Shuah Khan <skhan@linuxfoundation.org>
Message-ID: <a3241bd5-c8cd-dd47-03a8-906b66cf74e8@linuxfoundation.org>
Date:   Fri, 9 Apr 2021 14:55:16 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210409095301.525783608@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/9/21 3:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.186 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.186-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

I am seeing a new warn - will debug later on today and let you know
what I find:


WARNING: CPU: 9 PID: 0 at drivers/net/wireless/ath/ath10k/htt_rx.c:46 
ath10k_htt_rx_pop_paddr+0xde/0x100 [ath10k_core]
Modules linked in: cmac algif_hash algif_skcipher af_alg bnep arc4 
nls_iso8859_1 wmi_bmof snd_hda_codec_realtek snd_hda_codec_generic 
snd_hda_codec_hdmi edac_mce_amd snd_hda_intel snd_hda_codec kvm_amd 
snd_hda_core ccp snd_hwdep kvm snd_pcm snd_seq_midi crct10dif_pclmul 
snd_seq_midi_event ghash_clmulni_intel pcbc snd_rawmidi ath10k_pci 
snd_seq ath10k_core aesni_intel ath snd_seq_device rtsx_usb_ms btusb 
aes_x86_64 snd_timer crypto_simd btrtl cryptd joydev btbcm glue_helper 
memstick mac80211 snd btintel input_leds bluetooth soundcore cfg80211 
ecdh_generic video wmi mac_hid sch_fq_codel parport_pc ppdev lp parport 
drm ip_tables x_tables autofs4 hid_generic rtsx_usb_sdmmc usbhid 
rtsx_usb hid crc32_pclmul uas i2c_piix4 r8169 ahci realtek usb_storage 
libahci gpio_amdpt gpio_generic
CPU: 9 PID: 0 Comm: swapper/9 Not tainted 4.19.186-rc1+ #24
Hardware name: LENOVO 90Q30008US/3728, BIOS O4ZKT1CA 09/16/2020
RIP: 0010:ath10k_htt_rx_pop_paddr+0xde/0x100 [ath10k_core]
Code: 02 00 00 48 85 c9 74 30 4c 8b 49 28 4d 85 c9 74 1e 48 8b 30 45 31 
c0 b9 02 00 00 00 e8 9b 27 ca cc 4c 89 e0 4c 8b 65 f8 c9 c3 <0f> 0b 45 
31 e4 4c 89 e0 4c 8b 65 f8 c9 c3 48 8b 0d 1d df 4c cd eb
RSP: 0018:ffff8d81bf043da0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff8d81927b2150 RCX: ffff8d81b8c01580
RDX: 0000000000000008 RSI: 00000000ff708a80 RDI: ffff8d81b8c01e78
RBP: ffff8d81bf043da8 R08: 0000000000200000 R09: 0000000000000000
R10: ffffdd1f0f40f300 R11: 000ffffffffff000 R12: ffff8d81b8c02068
R13: ffff8d81b8c01580 R14: ffff8d81927b2148 R15: ffff8d81b8c01580
FS:  0000000000000000(0000) GS:ffff8d81bf040000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055a2c99a2000 CR3: 00000003de8d4000 CR4: 0000000000340ee0
Call Trace:
  <IRQ>
  ath10k_htt_txrx_compl_task+0x58d/0xe70 [ath10k_core]
  ath10k_pci_napi_poll+0x52/0x110 [ath10k_pci]
  net_rx_action+0x13c/0x350
  __do_softirq+0xd4/0x2ae
  irq_exit+0x9c/0xe0
  do_IRQ+0x86/0xe0
  common_interrupt+0xf/0xf
  </IRQ>
RIP: 0010:cpuidle_enter_state+0x10b/0x2c0
Code: ff e8 f9 68 85 ff 80 7d c7 00 74 17 9c 58 0f 1f 44 00 00 f6 c4 02 
0f 85 97 01 00 00 31 ff e8 6c 5d 8b ff fb 66 0f 1f 44 00 00 <48> b8 ff 
ff ff ff f3 01 00 00 4c 2b 7d c8 ba ff ff ff 7f 49 39 c7
RSP: 0018:ffffb11e01a77e50 EFLAGS: 00000246 ORIG_RAX: ffffffffffffffda
RAX: ffff8d81bf0626c0 RBX: ffff8d81b2690400 RCX: 00000006e8cb49d2
RDX: 0000000000000689 RSI: 00000006e8cb49d2 RDI: 0000000000000000
RBP: ffffb11e01a77e90 R08: 00000006e8cb505b R09: 0000000000000e29
R10: 0000000000000f04 R11: ffff8d81bf061528 R12: 0000000000000003
R13: ffffffff8df9e860 R14: ffffffff8df9e980 R15: 00000006e8cb505b
  cpuidle_enter+0x17/0x20

thanks,
-- Shuah
