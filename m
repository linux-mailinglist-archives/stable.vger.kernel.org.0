Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E97F3690B69
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 15:12:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230410AbjBIOMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 09:12:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40704 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230405AbjBIOL6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 09:11:58 -0500
Received: from mail-oa1-x2e.google.com (mail-oa1-x2e.google.com [IPv6:2001:4860:4864:20::2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F5B52130
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 06:11:53 -0800 (PST)
Received: by mail-oa1-x2e.google.com with SMTP id 586e51a60fabf-15ff0a1f735so2668645fac.5
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 06:11:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=JFB1o+M1WT64r376ibZ+mxHZwj2asHMqFz3iFJrx2AQ=;
        b=eg0TGvfOTUHTMNXRJ+GlrjdGoYvkiD+UHI5DDibs5zeRyO+2d3UHX3GiD3n1uCmoUq
         VZTw7DL7KuBJvGQiVygUY7uqpyo7+l8henIXwZNfR52yqIc+2Y7ayDrQyG3vPmNdXi7g
         OlYPOck8l4mzUpdUtBQcrdp+fuN8iri9m2VGO+nr/XiUrJunsDTjsfDhBkk1fSlyVGqw
         ljWvka2t+N07Y+H6PF1hgEZz0UeYUmxiebUZH0BmaDEiq/Yy0HDidGLi7mpFpU9sDxiu
         ZP9R8NjoMXdM8GcKNW6Ble1DkyMBBoqu3RqAEFOFUabssIEpDOf/R+vVqYVN8r9ekeHw
         4s/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JFB1o+M1WT64r376ibZ+mxHZwj2asHMqFz3iFJrx2AQ=;
        b=X4LnaIRaskodE1DwDM5TBSuBjzD5c5ZvVBY04+BKpckT1G7PThWGF3uSIkDhMFCII4
         nO4vyXCtIYMygkce25CKgdy0jfLmGiRLswKnklM/qidV0I7ZXJQvzfUbxc7Sbt8icktp
         OEoGHMWFTr5JR2KT6qSqzQoFe50dnx9sIZjXRUkZyi5LKNRwGd8FryHWSMuDBRnucdLi
         AbkLqAxwj4XAD2Vg/GIuuSsg1Yp/LYi7sxASCfyyeZA7nEQPfreS/6NpmmvMvTVBRJef
         lTu28DfpLlUfXrDEz/7U9ENCPSTUazGBNRUnBzD6uY9FoZqwUCD8Wd8es9Ni9tuDmCNn
         FQuQ==
X-Gm-Message-State: AO0yUKXSIHGRK1R0tHLnQOObQAFxafKG/ecIsXa1Fq6Qfz3DHFdXMXk7
        wQa3WNEQiKndlJluQ0gYUoVtZ4S4oF0Ym4ZYJSg=
X-Google-Smtp-Source: AK7set+5BvkASgCVopLhZdPXdr8pMRKwKxKAotvY+K6QKb/dMzp3I4Xyky+P69sIgrxHEwvgn12ND22+oW28RAw35kY=
X-Received: by 2002:a05:6870:392c:b0:163:67a4:8f9f with SMTP id
 b44-20020a056870392c00b0016367a48f9fmr1336048oap.270.1675951912604; Thu, 09
 Feb 2023 06:11:52 -0800 (PST)
MIME-Version: 1.0
References: <CALFERdzKUodLsm6=Ub3g2+PxpNpPtPq3bGBLbff=eZr9_S=YVA@mail.gmail.com>
 <962dfb15-b259-b764-3085-8d6a942f5abb@leemhuis.info> <CALFERdwmt_1yVmeQheTRqv6n0YJUs5cuRpUqT1O4UMydY6ubEA@mail.gmail.com>
In-Reply-To: <CALFERdwmt_1yVmeQheTRqv6n0YJUs5cuRpUqT1O4UMydY6ubEA@mail.gmail.com>
From:   Sasa Ostrouska <casaxa@gmail.com>
Date:   Thu, 9 Feb 2023 15:11:41 +0100
Message-ID: <CALFERdwvq5day_sbDfiUsMSZCQu9HG8-SBpOZDNPeMdZGog6XA@mail.gmail.com>
Subject: Re: Google Pixelbook EVE, no sound in kernel 6.1.x
To:     Linux regressions mailing list <regressions@lists.linux.dev>
Cc:     stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Lukasz Majczak <lma@semihalf.com>,
        Cezary Rojewski <cezary.rojewski@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, I dont know how much this is relevant but I am getting this kind
of traces in dmesg on both, Salckware and Fedora installs.

[   16.286097] ------------[ cut here ]------------
[   16.286100] memcpy: detected field-spanning write (size 100) of
single field "cpr_mconfig->gtw_cfg.config_data" at
sound/soc/intel/skylake/skl-messages.c:554 (size 4)
[   16.286128] WARNING: CPU: 1 PID: 1232 at
sound/soc/intel/skylake/skl-messages.c:554 skl_init_module+0x757/0x770
[snd_soc_skl]
[   16.286156] Modules linked in: nf_nat_ftp nf_conntrack_ftp
nft_objref nf_conntrack_netbios_ns nf_conntrack_broadcast nft_fib_inet
nft_fib_ipv4 nft_fib_ipv6 nft_fib nft_reject_inet nf_reject_ipv4
nf_reject_ipv6 nft_reject nft_ct nft_chain_nat nf_nat nf_conntrack
nf_defrag_ipv6 nf_defrag_ipv4 ip_set nf_tables nfnetlink
snd_soc_skl_ssp_clk snd_sof_pci_intel_skl snd_sof_intel_hda_common
soundwire_intel soundwire_generic_allocation soundwire_cadence
snd_sof_intel_hda snd_sof_pci snd_sof_xtensa_dsp snd_sof snd_sof_utils
qrtr soundwire_bus snd_soc_avs snd_soc_kbl_rt5663_rt5514_max98927
snd_soc_hda_codec cros_ec_light_prox cros_ec_sensors
cros_ec_sensors_core bnep industrialio_triggered_buffer kfifo_buf
snd_soc_hdac_hdmi snd_soc_dmic industrialio i2c_hid_acpi i2c_hid
snd_soc_skl cros_ec_chardev snd_soc_hdac_hda cros_ec_sensorhub
snd_hda_ext_core cros_usbpd_charger cros_ec_sysfs cros_usbpd_logger
snd_soc_sst_ipc binfmt_misc iTCO_wdt snd_soc_sst_dsp
snd_soc_acpi_intel_match intel_pmc_bxt
[   16.286215]  iTCO_vendor_support intel_tcc_cooling
x86_pkg_temp_thermal snd_soc_acpi intel_powerclamp coretemp kvm_intel
snd_hda_intel snd_intel_dspcfg snd_intel_sdw_acpi cros_ec_dev
snd_hda_codec kvm intel_rapl_msr iwlmvm uvcvideo videobuf2_vmalloc
irqbypass mac80211 rapl videobuf2_memops snd_hda_core videobuf2_v4l2
intel_cstate intel_uncore libarc4 pcspkr i2c_i801 sunrpc snd_hwdep
videobuf2_common videodev i2c_smbus btusb btrtl spi_pxa2xx_platform
dw_dmac btbcm iwlwifi btintel mc snd_soc_rt5663 btmtk snd_soc_rt5514
snd_soc_max98927 snd_soc_rt5514_spi snd_soc_rl6231 bluetooth
snd_soc_core cfg80211 mei_me joydev snd_compress mei ac97_bus
snd_pcm_dmaengine intel_pch_thermal rfkill idma64 snd_seq
snd_seq_device snd_pcm snd_timer processor_thermal_device_pci_legacy
processor_thermal_device snd cros_ec_i2c processor_thermal_rfim
processor_thermal_mbox soundcore processor_thermal_rapl cros_ec_lpcs
cros_ec tpm_tis_i2c_cr50 cros_usbpd_notify int3403_thermal
intel_rapl_common
[   16.286285]  int340x_thermal_zone intel_xhci_usb_role_switch
int3400_thermal chromeos_pstore cros_kbd_led_backlight
acpi_thermal_rel chromeos_acpi intel_soc_dts_iosf zram
hid_logitech_hidpp hid_logitech_dj i915 drm_buddy video
crct10dif_pclmul crc32_pclmul crc32c_intel wmi polyval_clmulni nvme
polyval_generic drm_display_helper nvme_core sdhci_pci cqhci cec sdhci
ghash_clmulni_intel hid_multitouch mmc_core sha512_ssse3 nvme_common
serio_raw ttm pinctrl_sunrisepoint r8152 mii ip6_tables ip_tables fuse
[last unloaded: i2c_hid]
[   16.286324] CPU: 1 PID: 1232 Comm: pulseaudio Not tainted
6.1.9-201.pixelbook.fc37.x86_64 #1
[   16.286328] Hardware name: Google Eve/Eve, BIOS
Google_Eve.9584.230.0 09/06/2021
[   16.286330] RIP: 0010:skl_init_module+0x757/0x770 [snd_soc_skl]
[   16.286355] Code: bd fe ff ff b9 04 00 00 00 4c 89 fe 4c 89 04 24
48 c7 c2 00 e7 42 c1 48 c7 c7 58 e7 42 c1 c6 05 0e 36 02 00 01 e8 3f
1b 95 fb <0f> 0b 4c 8b 04 24 e9 8c fe ff ff e9 96 ab 00 00 66 0f 1f 84
00 00
[   16.286358] RSP: 0000:ffffb3c2816c7ae0 EFLAGS: 00010296
[   16.286362] RAX: 000000000000009a RBX: ffff8d7ce355e028 RCX: 0000000000000000
[   16.286364] RDX: 0000000000000001 RSI: ffffffffbd74c48b RDI: 00000000ffffffff
[   16.286366] RBP: ffff8d7cc3854028 R08: 0000000000000000 R09: ffffb3c2816c7980
[   16.286368] R10: 0000000000000003 R11: ffffffffbe1465a8 R12: 00000000000000b8
[   16.286370] R13: 00000000000000b8 R14: ffff8d7d0d73c840 R15: 0000000000000064
[   16.286372] FS:  00007fcb6eca02c0(0000) GS:ffff8d802ec80000(0000)
knlGS:0000000000000000
[   16.286375] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[   16.286377] CR2: 00002dc17c298000 CR3: 000000016ccfa004 CR4: 00000000003706e0
[   16.286379] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[   16.286381] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[   16.286382] Call Trace:
[   16.286386]  <TASK>
[   16.286391]  skl_tplg_mixer_event+0x72f/0xd20 [snd_soc_skl]
[   16.286412]  ? __schedule+0x367/0x1360
[   16.286420]  dapm_seq_check_event+0x108/0x1c0 [snd_soc_core]
[   16.286464]  dapm_seq_run_coalesced+0x84/0x1c0 [snd_soc_core]
[   16.286501]  dapm_seq_run+0x16e/0x3e0 [snd_soc_core]
[   16.286542]  dapm_power_widgets+0x5db/0xa40 [snd_soc_core]
[   16.286581]  snd_soc_dapm_stream_event+0xf5/0x170 [snd_soc_core]
[   16.286619]  __soc_pcm_prepare+0x53/0xf0 [snd_soc_core]
[   16.286659]  dpcm_fe_dai_prepare+0xac/0x150 [snd_soc_core]
[   16.286699]  snd_pcm_do_prepare+0x26/0x40 [snd_pcm]
[   16.286718]  snd_pcm_action_single+0x33/0x80 [snd_pcm]
[   16.286733]  snd_pcm_action_nonatomic+0x95/0xa0 [snd_pcm]
[   16.286749]  snd_pcm_ioctl+0x23/0x40 [snd_pcm]
[   16.286764]  __x64_sys_ioctl+0x8d/0xd0
[   16.286770]  do_syscall_64+0x58/0x80
[   16.286774]  ? syscall_exit_to_user_mode+0x17/0x40
[   16.286777]  ? do_syscall_64+0x67/0x80
[   16.286780]  ? snd_pcm_ioctl+0x23/0x40 [snd_pcm]
[   16.286795]  ? __x64_sys_ioctl+0x8d/0xd0
[   16.286799]  ? syscall_exit_to_user_mode+0x17/0x40
[   16.286801]  ? do_syscall_64+0x67/0x80
[   16.286805]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[   16.286809] RIP: 0033:0x7fcb6f593d6f
[   16.286841] Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24
10 00 00 00 48 89 44 24 08 48 8d 44 24 20 48 89 44 24 10 b8 10 00 00
00 0f 05 <89> c2 3d 00 f0 ff ff 77 18 48 8b 44 24 18 64 48 2b 04 25 28
00 00
[   16.286843] RSP: 002b:00007ffe5ea27370 EFLAGS: 00000246 ORIG_RAX:
0000000000000010
[   16.286847] RAX: ffffffffffffffda RBX: 0000563cd8d93160 RCX: 00007fcb6f593d6f
[   16.286849] RDX: 0000000000000000 RSI: 0000000000004140 RDI: 0000000000000015
[   16.286851] RBP: 0000000000000000 R08: 00000000000012bd R09: 00007ffe5ea27324
[   16.286853] R10: 0000000000000004 R11: 0000000000000246 R12: 00007ffe5ea27aa4
[   16.286855] R13: 00007ffe5ea27680 R14: 00007ffe5ea27a90 R15: 00007fcb6ec07290
[   16.286861]  </TASK>
[   16.286863] ---[ end trace 0000000000000000 ]---

Seems sound related. Also I suffer from not be able to reboot or
powerdown on Slackware with 6.1.8,6.1.9 and 6.1.10 kernels.

Rgds
Sasa

On Fri, Jan 27, 2023 at 11:06 AM Sasa Ostrouska <casaxa@gmail.com> wrote:
>
> Hi Lucasz, I don't know if this could be relevant, but when I
> installed slackware64-current on the other pixelbook I have the sound
> works with
> kernel 6.1.8 but not all the time and seems there are some crashes of
> the sound. Also it is very amplified.
> I attach the dmesg here.
