Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 48E10148E1B
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 19:56:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388423AbgAXS4h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 13:56:37 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:26356 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387900AbgAXS4g (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jan 2020 13:56:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579892194;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=m6Rcrlp2zIVotjXe+0wAjR733FsCzRZLJH4utyqlTaQ=;
        b=Wc1R4XkwlJilyj5u87/C7wZkDk4Ucqb5YBEaNNIkT8qo+eqn8nkeJhKLzc8NZpWee8HHjI
        XCXt32RegD9EAnEEysbOXhC7gMglRnlM2dQfiEfLa9s1CkhcaQWzFddLlFDEiVO2Odry/H
        6xRFhcm1fEZwCMa9LG/I6gYUZcSeSWM=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-178-a-a2XNRbPGmjCpQnN5BpwA-1; Fri, 24 Jan 2020 13:56:33 -0500
X-MC-Unique: a-a2XNRbPGmjCpQnN5BpwA-1
Received: by mail-qt1-f199.google.com with SMTP id m8so1899431qta.20
        for <stable@vger.kernel.org>; Fri, 24 Jan 2020 10:56:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:organization:user-agent:mime-version
         :content-transfer-encoding;
        bh=m6Rcrlp2zIVotjXe+0wAjR733FsCzRZLJH4utyqlTaQ=;
        b=P9wErRFnDMzTW3SYsNFBimXAt60lj0rwmPOyhJcEqHAOr3rX9iKUa+8mH06Fq+oMQ1
         Hm62ivYSs8w15o7flzTSni954R+gzqspEXrSx0dTK5Dbo7MbbRiwKiHowJhiRkG1UTqP
         +nSfaoy8i/WtnGJMkaNrqhxUWaxSC60dc3902P4b9YSMIYsW9rn3Exy+OK6CDITCUl3n
         Vaisa3mGLxIAoTkDVLS1+axsewius4RQjxJi8mCxHiVxWM19x0L6KTiEKqf+lrmAwxF7
         oe7qDA1nQUj+ERIkhdm8imf0JslPuM6a3aYbl9C+ZNG2etIczOC6Y6o3BNrfVvREUfRD
         VxZg==
X-Gm-Message-State: APjAAAU5oDBFrpFi/s3p5Co6gleKLAbxkvKOqlpGBMCIjDQQtIuz2wLu
        PBFozKrLJOwdRHDg+ySvJQlMjFfgn8VcHth94Mzal8KwAFtn87PnDlhKsmAlZr+lYK1/Xhd2EP+
        QHWElGxrZWMtknKk0
X-Received: by 2002:a0c:f404:: with SMTP id h4mr4355545qvl.251.1579892192786;
        Fri, 24 Jan 2020 10:56:32 -0800 (PST)
X-Google-Smtp-Source: APXvYqzEI3PJZ+nqnjSMmh5lq8qW1FYn7L8AmkcPc6B+EbPkYHzHZpXNcrHibrf3408l2iLoBl6Rpw==
X-Received: by 2002:a0c:f404:: with SMTP id h4mr4355516qvl.251.1579892192449;
        Fri, 24 Jan 2020 10:56:32 -0800 (PST)
Received: from dhcp-10-20-1-90.bss.redhat.com ([144.121.20.162])
        by smtp.gmail.com with ESMTPSA id s20sm3584680qkg.131.2020.01.24.10.56.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jan 2020 10:56:31 -0800 (PST)
Message-ID: <290570863e9564165c40624d03ee572ce7c231fa.camel@redhat.com>
Subject: Re: [PATCH] drm/amd/dm/mst: Ignore payload update failures on
 disable
From:   Lyude Paul <lyude@redhat.com>
To:     Mikita Lipski <mlipski@amd.com>, Harry Wentland <hwentlan@amd.com>,
        amd-gfx@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Harry Wentland <harry.wentland@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Christian =?ISO-8859-1?Q?K=F6nig?= <christian.koenig@amd.com>,
        "David (ChunMing) Zhou" <David1.Zhou@amd.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        David Francis <David.Francis@amd.com>,
        Martin Tsai <martin.tsai@amd.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Alvin Lee <alvin.lee2@amd.com>,
        Jean Delvare <jdelvare@suse.de>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        "Lin, Wayne" <Wayne.Lin@amd.com>
Date:   Fri, 24 Jan 2020 13:56:30 -0500
In-Reply-To: <4ddde071-356b-77a0-25e8-26c22e0ffa14@amd.com>
References: <20200124000643.99859-1-lyude@redhat.com>
         <41187639-f077-0212-aa02-d5dcc96c442b@amd.com>
         <4ddde071-356b-77a0-25e8-26c22e0ffa14@amd.com>
Organization: Red Hat
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.3 (3.34.3-1.fc31) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On Fri, 2020-01-24 at 11:39 -0500, Mikita Lipski wrote:
> 
> On 1/24/20 9:55 AM, Harry Wentland wrote:
> > On 2020-01-23 7:06 p.m., Lyude Paul wrote:
> > > Disabling a display on MST can potentially happen after the entire MST
> > > topology has been removed, which means that we can't communicate with
> > > the topology at all in this scenario. Likewise, this also means that we
> > > can't properly update payloads on the topology and as such, it's a good
> > > idea to ignore payload update failures when disabling displays.
> > > Currently, amdgpu makes the mistake of halting the payload update
> > > process when any payload update failures occur, resulting in leaving
> > > DC's local copies of the payload tables out of date.
> > > 
> > > This ends up causing problems with hotplugging MST topologies, and
> > > causes modesets on the second hotplug to fail like so:
> > > 
> > > [drm] Failed to updateMST allocation table forpipe idx:1
> > > ------------[ cut here ]------------
> > > WARNING: CPU: 5 PID: 1511 at
> > > drivers/gpu/drm/amd/amdgpu/../display/dc/core/dc_link.c:2677
> > > update_mst_stream_alloc_table+0x11e/0x130 [amdgpu]
> > > Modules linked in: cdc_ether usbnet fuse xt_conntrack nf_conntrack
> > > nf_defrag_ipv6 libcrc32c nf_defrag_ipv4 ipt_REJECT nf_reject_ipv4
> > > nft_counter nft_compat nf_tables nfnetlink tun bridge stp llc sunrpc
> > > vfat fat wmi_bmof uvcvideo snd_hda_codec_realtek snd_hda_codec_generic
> > > snd_hda_codec_hdmi videobuf2_vmalloc snd_hda_intel videobuf2_memops
> > > videobuf2_v4l2 snd_intel_dspcfg videobuf2_common crct10dif_pclmul
> > > snd_hda_codec videodev crc32_pclmul snd_hwdep snd_hda_core
> > > ghash_clmulni_intel snd_seq mc joydev pcspkr snd_seq_device snd_pcm
> > > sp5100_tco k10temp i2c_piix4 snd_timer thinkpad_acpi ledtrig_audio snd
> > > wmi soundcore video i2c_scmi acpi_cpufreq ip_tables amdgpu(O)
> > > rtsx_pci_sdmmc amd_iommu_v2 gpu_sched mmc_core i2c_algo_bit ttm
> > > drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops cec drm
> > > crc32c_intel serio_raw hid_multitouch r8152 mii nvme r8169 nvme_core
> > > rtsx_pci pinctrl_amd
> > > CPU: 5 PID: 1511 Comm: gnome-shell Tainted: G           O      5.5.0-
> > > rc7Lyude-Test+ #4
> > > Hardware name: LENOVO FA495SIT26/FA495SIT26, BIOS R12ET22W(0.22 )
> > > 01/31/2019
> > > RIP: 0010:update_mst_stream_alloc_table+0x11e/0x130 [amdgpu]
> > > Code: 28 00 00 00 75 2b 48 8d 65 e0 5b 41 5c 41 5d 41 5e 5d c3 0f b6 06
> > > 49 89 1c 24 41 88 44 24 08 0f b6 46 01 41 88 44 24 09 eb 93 <0f> 0b e9
> > > 2f ff ff ff e8 a6 82 a3 c2 66 0f 1f 44 00 00 0f 1f 44 00
> > > RSP: 0018:ffffac428127f5b0 EFLAGS: 00010202
> > > RAX: 0000000000000002 RBX: ffff8d1e166eee80 RCX: 0000000000000000
> > > RDX: ffffac428127f668 RSI: ffff8d1e166eee80 RDI: ffffac428127f610
> > > RBP: ffffac428127f640 R08: ffffffffc03d94a8 R09: 0000000000000000
> > > R10: ffff8d1e24b02000 R11: ffffac428127f5b0 R12: ffff8d1e1b83d000
> > > R13: ffff8d1e1bea0b08 R14: 0000000000000002 R15: 0000000000000002
> > > FS:  00007fab23ffcd80(0000) GS:ffff8d1e28b40000(0000)
> > > knlGS:0000000000000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 00007f151f1711e8 CR3: 00000005997c0000 CR4: 00000000003406e0
> > > Call Trace:
> > >   ? mutex_lock+0xe/0x30
> > >   dc_link_allocate_mst_payload+0x9a/0x210 [amdgpu]
> > >   ? dm_read_reg_func+0x39/0xb0 [amdgpu]
> > >   ? core_link_enable_stream+0x656/0x730 [amdgpu]
> > >   core_link_enable_stream+0x656/0x730 [amdgpu]
> > >   dce110_apply_ctx_to_hw+0x58e/0x5d0 [amdgpu]
> > >   ? dcn10_verify_allow_pstate_change_high+0x1d/0x280 [amdgpu]
> > >   ? dcn10_wait_for_mpcc_disconnect+0x3c/0x130 [amdgpu]
> > >   dc_commit_state+0x292/0x770 [amdgpu]
> > >   ? add_timer+0x101/0x1f0
> > >   ? ttm_bo_put+0x1a1/0x2f0 [ttm]
> > >   amdgpu_dm_atomic_commit_tail+0xb59/0x1ff0 [amdgpu]
> > >   ? amdgpu_move_blit.constprop.0+0xb8/0x1f0 [amdgpu]
> > >   ? amdgpu_bo_move+0x16d/0x2b0 [amdgpu]
> > >   ? ttm_bo_handle_move_mem+0x118/0x570 [ttm]
> > >   ? ttm_bo_validate+0x134/0x150 [ttm]
> > >   ? dm_plane_helper_prepare_fb+0x1b9/0x2a0 [amdgpu]
> > >   ? _cond_resched+0x15/0x30
> > >   ? wait_for_completion_timeout+0x38/0x160
> > >   ? _cond_resched+0x15/0x30
> > >   ? wait_for_completion_interruptible+0x33/0x190
> > >   commit_tail+0x94/0x130 [drm_kms_helper]
> > >   drm_atomic_helper_commit+0x113/0x140 [drm_kms_helper]
> > >   drm_atomic_helper_set_config+0x70/0xb0 [drm_kms_helper]
> > >   drm_mode_setcrtc+0x194/0x6a0 [drm]
> > >   ? _cond_resched+0x15/0x30
> > >   ? mutex_lock+0xe/0x30
> > >   ? drm_mode_getcrtc+0x180/0x180 [drm]
> > >   drm_ioctl_kernel+0xaa/0xf0 [drm]
> > >   drm_ioctl+0x208/0x390 [drm]
> > >   ? drm_mode_getcrtc+0x180/0x180 [drm]
> > >   amdgpu_drm_ioctl+0x49/0x80 [amdgpu]
> > >   do_vfs_ioctl+0x458/0x6d0
> > >   ksys_ioctl+0x5e/0x90
> > >   __x64_sys_ioctl+0x16/0x20
> > >   do_syscall_64+0x55/0x1b0
> > >   entry_SYSCALL_64_after_hwframe+0x44/0xa9
> > > RIP: 0033:0x7fab2121f87b
> > > Code: 0f 1e fa 48 8b 05 0d 96 2c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff
> > > ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f 05 <48> 3d 01
> > > f0 ff ff 73 01 c3 48 8b 0d dd 95 2c 00 f7 d8 64 89 01 48
> > > RSP: 002b:00007ffd045f9068 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> > > RAX: ffffffffffffffda RBX: 00007ffd045f90a0 RCX: 00007fab2121f87b
> > > RDX: 00007ffd045f90a0 RSI: 00000000c06864a2 RDI: 000000000000000b
> > > RBP: 00007ffd045f90a0 R08: 0000000000000000 R09: 000055dbd2985d10
> > > R10: 000055dbd2196280 R11: 0000000000000246 R12: 00000000c06864a2
> > > R13: 000000000000000b R14: 0000000000000000 R15: 000055dbd2196280
> > > ---[ end trace 6ea888c24d2059cd ]---
> > > 
> > > Note as well, I have only been able to reproduce this on setups with 2
> > > MST displays.
> > > 
> > > Signed-off-by: Lyude Paul <lyude@redhat.com>
> > > Cc: stable@vger.kernel.org
> > 
> > LGTM but would like Mikita or Wayne to have a look as well.
> > Acked-by: Harry Wentland <harry.wentland@amd.com>
> 
> I think its a good change and it definetely helps to deal with 
> discreptency between drm and dc payload allocation tables.
> But I think we might not even need extra enable checks.

I think you're right here, I'll remove those in the next respin

> 
> > Harry
> > 
> > > ---
> > >   drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c | 7 ++++---
> > >   1 file changed, 4 insertions(+), 3 deletions(-)
> > > 
> > > diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> > > b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> > > index 069b7a6f5597..252fa60c6775 100644
> > > --- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> > > +++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm_helpers.c
> > > @@ -216,6 +216,7 @@ bool
> > > dm_helpers_dp_mst_write_payload_allocation_table(
> > >   		drm_dp_mst_reset_vcpi_slots(mst_mgr, mst_port);
> > >   	}
> > >   
> > > +	/* If disabling, it's OK for this to fail */
> > >   	ret = drm_dp_update_payload_part1(mst_mgr);
> > >   
> > >   	/* mst_mgr->->payloads are VC payload notify MST branch using
> > > DPCD or
> > > @@ -225,7 +226,7 @@ bool
> > > dm_helpers_dp_mst_write_payload_allocation_table(
> > >   
> > >   	get_payload_table(aconnector, proposed_table);
> > >   
> > > -	if (ret)
> > > +	if (ret && !enable)
> > >   		return false;
> 
> Wouldn't it be better to check ret value, and instead of returning false 
> just throw DRM_ERROR message, since drm_dp_update_payload_part1 only 
> returns error if a port is not validated?

You're right on avoiding returning here, that's probably a better idea since
we want all steps to be run even if they don't succeed. I think we can skip
the error message though, it's expected that modesets which disable displays
will happen on ports that no longer can be validated.

> 
> Thank you,
> Mikita
> 
> > >   
> > >   	return true;
> > > @@ -299,9 +300,9 @@ bool dm_helpers_dp_mst_send_payload_allocation(
> > >   	if (!mst_mgr->mst_state)
> > >   		return false;
> > >   
> > > +	/* If disabling, it's OK for this to fail */
> > >   	ret = drm_dp_update_payload_part2(mst_mgr);
> > > -
> > > -	if (ret)
> > > +	if (enable && ret)
> > >   		return false;
> > >   
> > >   	if (!enable)
-- 
Cheers,
	Lyude Paul

