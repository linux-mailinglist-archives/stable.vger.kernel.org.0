Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09A521AA3EC
	for <lists+stable@lfdr.de>; Wed, 15 Apr 2020 15:23:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2506184AbgDONOc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 15 Apr 2020 09:14:32 -0400
Received: from mga06.intel.com ([134.134.136.31]:20545 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897051AbgDONOW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 09:14:22 -0400
IronPort-SDR: zyWYVqYLG1+7mCynzvuHJqZ5gHp1hXqBVwTDw7L5vLz+ch2kdZMqYtMRTRsupeZGDiRqvy1K5g
 bmVMEciyczxw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 06:14:18 -0700
IronPort-SDR: xVr94etV3Af4K7PjN0/GdVUPobBtSVBpYZC3kdRtQBAUo2a+4aPZtfWXP+FJJNhliJcoNWU4pt
 pNKL2GcdldRg==
X-IronPort-AV: E=Sophos;i="5.72,386,1580803200"; 
   d="scan'208";a="363666827"
Received: from paasikivi.fi.intel.com ([10.237.72.42])
  by fmsmga001-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Apr 2020 06:14:15 -0700
Received: by paasikivi.fi.intel.com (Postfix, from userid 1000)
        id 6FAF820606; Wed, 15 Apr 2020 16:14:12 +0300 (EEST)
Date:   Wed, 15 Apr 2020 16:14:12 +0300
From:   Sakari Ailus <sakari.ailus@linux.intel.com>
To:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Cc:     david@unsolicited.net, hans.verkuil@cisco.com, linux@roeck-us.net,
        mchehab@osg.samsung.com, stable-commits@vger.kernel.org
Subject: Re: Patch "Revert "[media] videobuf2-v4l2: Verify planes array in
 buffer dequeueing"" has been added to the 4.4-stable tree
Message-ID: <20200415131412.GD27762@paasikivi.fi.intel.com>
References: <158694575418840@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <158694575418840@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Apr 15, 2020 at 12:15:54PM +0200, gregkh@linuxfoundation.org wrote:
> 
> This is a note to let you know that I've just added the patch titled
> 
>     Revert "[media] videobuf2-v4l2: Verify planes array in buffer dequeueing"
> 
> to the 4.4-stable tree which can be found at:
>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
> 
> The filename of the patch is:
>      revert-videobuf2-v4l2-verify-planes-array-in-buffer-dequeueing.patch
> and it can be found in the queue-4.4 subdirectory.
> 
> If you, or anyone else, feels it should not be added to the stable tree,
> please let <stable@vger.kernel.org> know about it.
> 
> 
> From 93f0750dcdaed083d6209b01e952e98ca730db66 Mon Sep 17 00:00:00 2001
> From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Date: Wed, 11 May 2016 13:09:34 -0300
> Subject: Revert "[media] videobuf2-v4l2: Verify planes array in buffer dequeueing"
> 
> From: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> 
> commit 93f0750dcdaed083d6209b01e952e98ca730db66 upstream.

This patch has been already applied to the 4.4-stable tree --- and the
original has been re-applied as well, just as in upstream.

The original revert was done because another patch was missing the tree
(commit 93f0750dcdaed083d6209b01e952e98ca730db66 upstream), not because
there was a problem with the patch itself.

In other words, this patch must be dropped.

Thanks.

> 
> This patch causes a Kernel panic when called on a DVB driver.
> 
> This was also reported by David R <david@unsolicited.net>:
> 
> May  7 14:47:35 server kernel: [  501.247123] BUG: unable to handle kernel NULL pointer dereference at 0000000000000004
> May  7 14:47:35 server kernel: [  501.247239] IP: [<ffffffffa0222c71>] __verify_planes_array.isra.3+0x1/0x80 [videobuf2_v4l2]
> May  7 14:47:35 server kernel: [  501.247354] PGD cae6f067 PUD ca99c067 PMD 0
> May  7 14:47:35 server kernel: [  501.247426] Oops: 0000 [#1] SMP
> May  7 14:47:35 server kernel: [  501.247482] Modules linked in: xfs tun xt_connmark xt_TCPMSS xt_tcpmss xt_owner xt_REDIRECT nf_nat_redirect xt_nat ipt_MASQUERADE nf_nat_masquerade_ipv4 ts_kmp ts_bm xt_string ipt_REJECT nf_reject_ipv4 xt_recent xt_conntrack xt_multiport xt_pkttype xt_tcpudp xt_mark nf_log_ipv4 nf_log_common xt_LOG xt_limit iptable_mangle iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4 nf_nat_ipv4 nf_nat nf_conntrack iptable_filter ip_tables ip6table_filter ip6_tables x_tables pppoe pppox dm_crypt ts2020 regmap_i2c ds3000 cx88_dvb dvb_pll cx88_vp3054_i2c mt352 videobuf2_dvb cx8800 cx8802 cx88xx pl2303 tveeprom videobuf2_dma_sg ppdev videobuf2_memops videobuf2_v4l2 videobuf2_core dvb_usb_digitv snd_hda_codec_via snd_hda_codec_hdmi snd_hda_codec_generic radeon dvb_usb snd_hda_intel amd64_edac_mod serio_raw snd_hda_codec edac_core fbcon k10temp bitblit softcursor snd_hda_core font snd_pcm_oss i2c_piix4 snd_mixer_oss tileblit drm_kms_helper syscopyarea snd_pcm snd_seq_dummy
>   sysfillrect snd_seq_oss sysimgblt fb_sys_fops ttm snd_seq_midi r8169 snd_rawmidi drm snd_seq_midi_event e1000e snd_seq snd_seq_device snd_timer snd ptp pps_core i2c_algo_bit soundcore parport_pc ohci_pci shpchp tpm_tis tpm nfsd auth_rpcgss oid_registry hwmon_vid exportfs nfs_acl mii nfs bonding lockd grace lp sunrpc parport
> May  7 14:47:35 server kernel: [  501.249564] CPU: 1 PID: 6889 Comm: vb2-cx88[0] Not tainted 4.5.3 #3
> May  7 14:47:35 server kernel: [  501.249644] Hardware name: System manufacturer System Product Name/M4A785TD-V EVO, BIOS 0211    07/08/2009
> May  7 14:47:35 server kernel: [  501.249767] task: ffff8800aebf3600 ti: ffff8801e07a0000 task.ti: ffff8801e07a0000
> May  7 14:47:35 server kernel: [  501.249861] RIP: 0010:[<ffffffffa0222c71>]  [<ffffffffa0222c71>] __verify_planes_array.isra.3+0x1/0x80 [videobuf2_v4l2]
> May  7 14:47:35 server kernel: [  501.250002] RSP: 0018:ffff8801e07a3de8  EFLAGS: 00010086
> May  7 14:47:35 server kernel: [  501.250071] RAX: 0000000000000283 RBX: ffff880210dc5000 RCX: 0000000000000283
> May  7 14:47:35 server kernel: [  501.250161] RDX: ffffffffa0222cf0 RSI: 0000000000000000 RDI: ffff880210dc5014
> May  7 14:47:35 server kernel: [  501.250251] RBP: ffff8801e07a3df8 R08: ffff8801e07a0000 R09: 0000000000000000
> May  7 14:47:35 server kernel: [  501.250348] R10: 0000000000000000 R11: 0000000000000001 R12: ffff8800cda2a9d8
> May  7 14:47:35 server kernel: [  501.250438] R13: ffff880210dc51b8 R14: 0000000000000000 R15: ffff8800cda2a828
> May  7 14:47:35 server kernel: [  501.250528] FS:  00007f5b77fff700(0000) GS:ffff88021fc40000(0000) knlGS:00000000adaffb40
> May  7 14:47:35 server kernel: [  501.250631] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
> May  7 14:47:35 server kernel: [  501.250704] CR2: 0000000000000004 CR3: 00000000ca19d000 CR4: 00000000000006e0
> May  7 14:47:35 server kernel: [  501.250794] Stack:
> May  7 14:47:35 server kernel: [  501.250822]  ffff8801e07a3df8 ffffffffa0222cfd ffff8801e07a3e70 ffffffffa0236beb
> May  7 14:47:35 server kernel: [  501.250937]  0000000000000283 ffff8801e07a3e94 0000000000000000 0000000000000000
> May  7 14:47:35 server kernel: [  501.251051]  ffff8800aebf3600 ffffffff8108d8e0 ffff8801e07a3e38 ffff8801e07a3e38
> May  7 14:47:35 server kernel: [  501.251165] Call Trace:
> May  7 14:47:35 server kernel: [  501.251200]  [<ffffffffa0222cfd>] ? __verify_planes_array_core+0xd/0x10 [videobuf2_v4l2]
> May  7 14:47:35 server kernel: [  501.251306]  [<ffffffffa0236beb>] vb2_core_dqbuf+0x2eb/0x4c0 [videobuf2_core]
> May  7 14:47:35 server kernel: [  501.251398]  [<ffffffff8108d8e0>] ? prepare_to_wait_event+0x100/0x100
> May  7 14:47:35 server kernel: [  501.251482]  [<ffffffffa023855b>] vb2_thread+0x1cb/0x220 [videobuf2_core]
> May  7 14:47:35 server kernel: [  501.251569]  [<ffffffffa0238390>] ? vb2_core_qbuf+0x230/0x230 [videobuf2_core]
> May  7 14:47:35 server kernel: [  501.251662]  [<ffffffffa0238390>] ? vb2_core_qbuf+0x230/0x230 [videobuf2_core]
> May  7 14:47:35 server kernel: [  501.255982]  [<ffffffff8106f984>] kthread+0xc4/0xe0
> May  7 14:47:35 server kernel: [  501.260292]  [<ffffffff8106f8c0>] ? kthread_park+0x50/0x50
> May  7 14:47:35 server kernel: [  501.264615]  [<ffffffff81697a5f>] ret_from_fork+0x3f/0x70
> May  7 14:47:35 server kernel: [  501.268962]  [<ffffffff8106f8c0>] ? kthread_park+0x50/0x50
> May  7 14:47:35 server kernel: [  501.273216] Code: 0d 01 74 16 48 8b 46 28 48 8b 56 30 48 89 87 d0 01 00 00 48 89 97 d8 01 00 00 5d c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 55 <8b> 46 04 48 89 e5 8d 50 f7 31 c0 83 fa 01 76 02 5d c3 48 83 7e
> May  7 14:47:35 server kernel: [  501.282146] RIP  [<ffffffffa0222c71>] __verify_planes_array.isra.3+0x1/0x80 [videobuf2_v4l2]
> May  7 14:47:35 server kernel: [  501.286391]  RSP <ffff8801e07a3de8>
> May  7 14:47:35 server kernel: [  501.290619] CR2: 0000000000000004
> May  7 14:47:35 server kernel: [  501.294786] ---[ end trace b2b354153ccad110 ]---
> 
> This reverts commit 2c1f6951a8a82e6de0d82b1158b5e493fc6c54ab.
> 
> Cc: Sakari Ailus <sakari.ailus@linux.intel.com>
> Cc: Hans Verkuil <hans.verkuil@cisco.com>
> Cc: stable@vger.kernel.org
> Fixes: 2c1f6951a8a8 ("[media] videobuf2-v4l2: Verify planes array in buffer dequeueing")
> Signed-off-by: Mauro Carvalho Chehab <mchehab@osg.samsung.com>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  drivers/media/v4l2-core/videobuf2-v4l2.c |    6 ------
>  1 file changed, 6 deletions(-)
> 
> --- a/drivers/media/v4l2-core/videobuf2-v4l2.c
> +++ b/drivers/media/v4l2-core/videobuf2-v4l2.c
> @@ -67,11 +67,6 @@ static int __verify_planes_array(struct
>  	return 0;
>  }
>  
> -static int __verify_planes_array_core(struct vb2_buffer *vb, const void *pb)
> -{
> -	return __verify_planes_array(vb, pb);
> -}
> -
>  /**
>   * __verify_length() - Verify that the bytesused value for each plane fits in
>   * the plane length and that the data offset doesn't exceed the bytesused value.
> @@ -436,7 +431,6 @@ static int __fill_vb2_buffer(struct vb2_
>  }
>  
>  static const struct vb2_buf_ops v4l2_buf_ops = {
> -	.verify_planes_array	= __verify_planes_array_core,
>  	.fill_user_buffer	= __fill_v4l2_buffer,
>  	.fill_vb2_buffer	= __fill_vb2_buffer,
>  	.set_timestamp		= __set_timestamp,
> 
> 
> Patches currently in stable-queue which might be from mchehab@osg.samsung.com are
> 
> queue-4.4/revert-videobuf2-v4l2-verify-planes-array-in-buffer-dequeueing.patch

-- 
Kind regards,

Sakari Ailus
