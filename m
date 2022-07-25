Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54D795806E5
	for <lists+stable@lfdr.de>; Mon, 25 Jul 2022 23:41:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230313AbiGYVlZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jul 2022 17:41:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiGYVlY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jul 2022 17:41:24 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 852CBAE6A
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 14:41:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1658785282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iezcoauBjm3eFRZAxsMkX8ABOzYWxWzYpMePyAltlQQ=;
        b=G26rB2PVSrEo12Xrqs/ya+PSpEsUtVIhtJGxasmehq8jG5RYGPsN8M5SxDkseNTf74hpNz
        S+7qbw7qnZeuhnGZ5wkliQ3IBd/7D4IFib2hJFgebEj7IyUqMSLpN2lb0hEQJ4g3rno9g0
        SJx3yRvXJtjgyilb+gVDEAbQExMBxk8=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-455-6U5YssRKMlGZBpvf9qJmAQ-1; Mon, 25 Jul 2022 17:41:16 -0400
X-MC-Unique: 6U5YssRKMlGZBpvf9qJmAQ-1
Received: by mail-qt1-f197.google.com with SMTP id cj19-20020a05622a259300b0031f01f3933cso6290743qtb.18
        for <stable@vger.kernel.org>; Mon, 25 Jul 2022 14:41:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=iezcoauBjm3eFRZAxsMkX8ABOzYWxWzYpMePyAltlQQ=;
        b=Ezu6mfaycQxffpI4grgbwpsutaCX7pcBZW1BCWuy73rjBWfoNhRsUQk1Rpc/wZ7Te0
         x3Aww6LbfaCPXvRg/BBDcacPaliYow62i0zva0cCzbpneU3GIKQbiEmdfSrpRAF6cko4
         gqhBO/qSKfPA0tJKDIxfg4nHq8ZW7+tpaqE1dNd4OGHqvDGJRt7K64YvA3hBWWtVF84G
         gjtgjXXSrfzttU2oiX/p0WnWTcoEP8bDKLS/hTMwRLwf8BwT9Z58Xz8eEC5lZZO7bs/p
         VQbPtF/7Ng9OfFuz0I6NmAhQxR74x8DRxret7JIQR5cf5QqnnobERHFV41vmoar31pZz
         4/Wg==
X-Gm-Message-State: AJIora8IJvtYipjlLBRvvUu2NPvcp+3cVZQOUqM9plmYjLMfnpoHF2c3
        67P6dQaZgrSqFibDNABMomoSeDjBdU2/A0x+xRZjEaBp9LfQKnFwOIWyd1KyhRY2xdaSt6ZAujE
        Bj0s5IFf2gBvukXxSEUD906U9A0TuaQ6+
X-Received: by 2002:a0c:f58d:0:b0:474:48e:fc99 with SMTP id k13-20020a0cf58d000000b00474048efc99mr11989863qvm.2.1658785276001;
        Mon, 25 Jul 2022 14:41:16 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1tdPKES8mswmwSbImCkQhQkLdHJX3Dr41zU/flZ02Nfij0DMKLyF6PHlW0qfnXIFlYIrkSJOIjoODIGD3UK3no=
X-Received: by 2002:a0c:f58d:0:b0:474:48e:fc99 with SMTP id
 k13-20020a0cf58d000000b00474048efc99mr11989848qvm.2.1658785275786; Mon, 25
 Jul 2022 14:41:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220725195322.857226-1-aahringo@redhat.com> <20220725195322.857226-2-aahringo@redhat.com>
In-Reply-To: <20220725195322.857226-2-aahringo@redhat.com>
From:   Alexander Aring <aahringo@redhat.com>
Date:   Mon, 25 Jul 2022 17:41:04 -0400
Message-ID: <CAK-6q+joxVt1D854jYRKTRjx_Bm8kPWqH+9Rma2Ke_TbkFEfEw@mail.gmail.com>
Subject: Re: [PATCHv2 dlm/next 1/2] fs: dlm: fix race in lowcomms
To:     David Teigland <teigland@redhat.com>
Cc:     cluster-devel <cluster-devel@redhat.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-3.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

On Mon, Jul 25, 2022 at 3:53 PM Alexander Aring <aahringo@redhat.com> wrote=
:
>
> This patch fixes a race between queue_work() in
> _dlm_lowcomms_commit_msg() and srcu_read_unlock(). The queue_work() can
> take the final reference of a dlm_msg and so msg->idx can contain
> garbage which is signaled by the following warning:
>
> [  676.237050] ------------[ cut here ]------------
> [  676.237052] WARNING: CPU: 0 PID: 1060 at include/linux/srcu.h:189 dlm_=
lowcomms_commit_msg+0x41/0x50
> [  676.238945] Modules linked in: dlm_locktorture torture rpcsec_gss_krb5=
 intel_rapl_msr intel_rapl_common iTCO_wdt iTCO_vendor_support qxl kvm_inte=
l drm_ttm_helper vmw_vsock_virtio_transport kvm vmw_vsock_virtio_transport_=
common ttm irqbypass crc32_pclmul joydev crc32c_intel serio_raw drm_kms_hel=
per vsock virtio_scsi virtio_console virtio_balloon snd_pcm drm syscopyarea=
 sysfillrect sysimgblt snd_timer fb_sys_fops i2c_i801 lpc_ich snd i2c_smbus=
 soundcore pcspkr
> [  676.244227] CPU: 0 PID: 1060 Comm: lock_torture_wr Not tainted 5.19.0-=
rc3+ #1546
> [  676.245216] Hardware name: Red Hat KVM/RHEL-AV, BIOS 1.16.0-2.module+e=
l8.7.0+15506+033991b0 04/01/2014
> [  676.246460] RIP: 0010:dlm_lowcomms_commit_msg+0x41/0x50
> [  676.247132] Code: fe ff ff ff 75 24 48 c7 c6 bd 0f 49 bb 48 c7 c7 38 7=
c 01 bd e8 00 e7 ca ff 89 de 48 c7 c7 60 78 01 bd e8 42 3d cd ff 5b 5d c3 <=
0f> 0b eb d8 66 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 55 48
> [  676.249253] RSP: 0018:ffffa401c18ffc68 EFLAGS: 00010282
> [  676.249855] RAX: 0000000000000001 RBX: 00000000ffff8b76 RCX: 000000000=
0000006
> [  676.250713] RDX: 0000000000000000 RSI: ffffffffbccf3a10 RDI: ffffffffb=
cc7b62e
> [  676.251610] RBP: ffffa401c18ffc70 R08: 0000000000000001 R09: 000000000=
0000001
> [  676.252481] R10: 0000000000000001 R11: 0000000000000001 R12: 000000000=
0000005
> [  676.253421] R13: ffff8b76786ec370 R14: ffff8b76786ec370 R15: ffff8b767=
86ec480
> [  676.254257] FS:  0000000000000000(0000) GS:ffff8b7777800000(0000) knlG=
S:0000000000000000
> [  676.255239] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  676.255897] CR2: 00005590205d88b8 CR3: 000000017656c003 CR4: 000000000=
0770ee0
> [  676.256734] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000000000=
0000000
> [  676.257567] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 000000000=
0000400
> [  676.258397] PKRU: 55555554
> [  676.258729] Call Trace:
> [  676.259063]  <TASK>
> [  676.259354]  dlm_midcomms_commit_mhandle+0xcc/0x110
> [  676.259964]  queue_bast+0x8b/0xb0
> [  676.260423]  grant_pending_locks+0x166/0x1b0
> [  676.261007]  _unlock_lock+0x75/0x90
> [  676.261469]  unlock_lock.isra.57+0x62/0xa0
> [  676.262009]  dlm_unlock+0x21e/0x330
> [  676.262457]  ? lock_torture_stats+0x80/0x80 [dlm_locktorture]
> [  676.263183]  torture_unlock+0x5a/0x90 [dlm_locktorture]
> [  676.263815]  ? preempt_count_sub+0xba/0x100
> [  676.264361]  ? complete+0x1d/0x60
> [  676.264777]  lock_torture_writer+0xb8/0x150 [dlm_locktorture]
> [  676.265555]  kthread+0x10a/0x130
> [  676.266007]  ? kthread_complete_and_exit+0x20/0x20
> [  676.266616]  ret_from_fork+0x22/0x30
> [  676.267097]  </TASK>
> [  676.267381] irq event stamp: 9579855
> [  676.267824] hardirqs last  enabled at (9579863): [<ffffffffbb14e6f8>] =
__up_console_sem+0x58/0x60
> [  676.268896] hardirqs last disabled at (9579872): [<ffffffffbb14e6dd>] =
__up_console_sem+0x3d/0x60
> [  676.270008] softirqs last  enabled at (9579798): [<ffffffffbc200349>] =
__do_softirq+0x349/0x4c7
> [  676.271438] softirqs last disabled at (9579897): [<ffffffffbb0d54c0>] =
irq_exit_rcu+0xb0/0xf0
> [  676.272796] ---[ end trace 0000000000000000 ]---
>
> I reproduced this warning with dlm_locktorture test which is currently
> not upstream. However this patch fix the issue by make a additional
> refcount between dlm_lowcomms_new_msg() and dlm_lowcomms_commit_msg().
> In case of the race the kref_put() in dlm_lowcomms_commit_msg() will be
> the final put.
>
> Signed-off-by: Alexander Aring <aahringo@redhat.com>

grml, now I forgot in this patch Cc: stable and fixes-tag. Will send v3. So=
rry.

- Alex

