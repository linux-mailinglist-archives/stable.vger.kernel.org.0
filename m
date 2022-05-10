Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12DC15213D5
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 13:33:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233564AbiEJLgs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 07:36:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233899AbiEJLgr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 07:36:47 -0400
Received: from wout3-smtp.messagingengine.com (wout3-smtp.messagingengine.com [64.147.123.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B923C13EAC
        for <stable@vger.kernel.org>; Tue, 10 May 2022 04:32:50 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 1D8223200302;
        Tue, 10 May 2022 07:32:49 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 10 May 2022 07:32:50 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1652182368; x=1652268768; bh=A4Mqlicbgg
        7DKPf46uHGJvepQF1BZTcfXOvLLa4wIYM=; b=Dc1R0QjGrYmO4l3D2PNJOusljG
        XiqaAubmeCryUzXreV+9qn01uUz4298wV1QUMOsgP4IHY+vs5H+KUS2qykLPmlo9
        46pfDEXFjCWVu98h1PAh5TuxPmOmnXSU3emEEDlMByfPqkrGphh+FvoB2GqvFTvW
        v6QjtO/n4hAvxvsy3E3cdPgQQfCzSgXgv0xwk0+VJ8bMRPF9IV9fqxA1FbAelxbT
        0Z2R1v3DcHlDDPfmnhbgnD3PgNjonM2jELZp+DNf6mCRIh14QxqS6hnAtjMmkG6S
        jD6l4IUMz2YEXKvN7hoYtpGzyXSrAxj5sMCXY8W2/GmBvn2T/sWaIax1eSAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1652182368; x=
        1652268768; bh=A4Mqlicbgg7DKPf46uHGJvepQF1BZTcfXOvLLa4wIYM=; b=U
        7627Z65DQSLxCSoSUZNyfz0sQZYZFJGgU+YQljvqXZfWAieueZtHPHk6/D8EHKg/
        XiBtLVFl11lZF6Tt+bDcD+fifvoBh4crg19R/zHwwfhbqP56z/lIfWoOaR7gAfwC
        qdaiLXjdqv9sckmNdX9TDFt6Zw1ktBwh1GPvySpTDbycgwdVkcAbixCOBvR3zrog
        KEd0ZGYNmVHNCfXwuXS5Ykn28fkQiVanOjYmpgcVbpiFNo5tesjzfZXRXQTJ0MfW
        GiUUzZWwz9YcIgIPdg0EJHp36+g5JKjo6mEDHm1WaZk5NiM+pc7Wm4miKkSME/VH
        mcEhsWZOWHT9a8XAweYlQ==
X-ME-Sender: <xms:YE16YopO4ugW3la_Qnr6dfM_rB9bM4Ko2gecwQYalmS5HWwuMdTN6w>
    <xme:YE16YuqIGdaR7WtTcdfdV-Rsta9hmQiHd0WFP1-fu_m5_mEw43c-U7TUCSN_IG5-z
    iHt-V7qtf1vcQ>
X-ME-Received: <xmr:YE16YtPf-TR9rZvjD3pyUJTyfBQL-zQY4U9mkEjuXoek8OX8zbR78D1wpRuglD6VAKuGDYi3y8z8pHfC5lxtXo9lDS7-DMG9>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrgedugdefjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpefhfefhtd
    fggeeutdfgjeevueelhfeijeejledtffduueehtefggeekvdeljefhjeenucffohhmrghi
    nhepohhpvghnfigrlhhlrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:YE16Yv5K46KthEYM5pzP3HZx7Xd6biiJb43HW-n7whlIkzttwuoNfg>
    <xmx:YE16Yn7mkjJJBBiqw5mnHdrOYiRDv11w4oxhGyor7FWoNvjkIdW-0A>
    <xmx:YE16Yvjzr8QLWIkrfdvHCXmcQmyhBjLfbAAwWOepG81qrKUYrhI8YQ>
    <xmx:YE16YhtjfCpI_TUrBFD57Ho4rrLkRKt03GISSDqZokh_waYHajewug>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 10 May 2022 07:32:47 -0400 (EDT)
Date:   Tue, 10 May 2022 13:32:45 +0200
From:   Greg KH <greg@kroah.com>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org, tiwai@suse.de, perex@perex.cz,
        kirin.say@gmail.com
Subject: Re: [PATCH 5.4 0/5] ALSA: pcm: backports for CVE-2022-1048
Message-ID: <YnpNXSAjV4DVZj/m@kroah.com>
References: <20220506091013.1746159-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220506091013.1746159-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 06, 2022 at 12:10:08PM +0300, Ovidiu Panait wrote:
> Contextual adjustments were made to apply to 5.4 stable tree.
> 
> Testing
> -------
> Running the PoC from [1] on 5.4.191 kernel produces the following oops:
> 
> qemu-system-x86_64 -nographic -serial mon:stdio -serial null -enable-kvm \
> -net user,hostname=qemu0,hostfwd=tcp::36074-:22 -net nic \
> -drive file=rootfs.ext4,format=raw -cpu host -m 4096 -kernel bzImage \
> -append "console=ttyS0,115200 root=/dev/sda rw ip=dhcp " -soundhw ac97 -smp 2
> root@intel-x86-64:~# ./poc
> ...
> [   95.839647] BUG: Bad page state in process poc  pfn:bb860
> [   95.841277] page:ffffea0002ee1800 refcount:-1 mapcount:0 mapping:0000000000000000 index:0x0
> [   95.843521] flags: 0x100000000000000()
> [   95.844539] raw: 0100000000000000 dead000000000100 dead000000000122 0000000000000000
> [   95.846306] raw: 0000000000000000 0000000000000000 ffffffffffffffff 0000000000000000
> [   95.847164] page dumped because: nonzero _refcount
> [   95.847705] Modules linked in:
> [   95.848063] CPU: 0 PID: 357 Comm: poc Tainted: G        W         5.4.191 #6
> [   95.848839] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> [   95.849847] Call Trace:
> [   95.850145]  dump_stack+0x76/0x9c
> [   95.850549]  bad_page.cold+0xff/0x124
> [   95.850980]  ? si_mem_available+0x2f0/0x2f0
> [   95.851464]  ? _raw_spin_trylock_bh+0x120/0x120
> [   95.851988]  ? __module_text_address+0xe/0x140
> [   95.852494]  get_page_from_freelist+0x16f9/0x35b0
> [   95.853034]  ? __isolate_free_page+0x460/0x460
> [   95.853543]  ? save_stack+0x4c/0x80
> [   95.853938]  ? save_stack+0x1b/0x80
> [   95.854343]  ? __kasan_kmalloc.constprop.0+0xc2/0xd0
> [   95.854897]  ? snd_pcm_lib_malloc_pages+0x2b8/0x680
> [   95.855433]  ? snd_intel8x0_hw_params+0x106/0x550
> [   95.855964]  ? snd_pcm_hw_params+0x2b5/0x1290
> [   95.856438]  ? snd_pcm_common_ioctl+0x332/0x1a20
> [   95.856954]  __alloc_pages_nodemask+0x274/0x610
> [   95.857460]  ? __alloc_pages_slowpath+0x1ff0/0x1ff0
> [   95.857992]  ? snd_pcm_hw_refine+0x8de/0xdd0
> [   95.858467]  ? kfree+0x8c/0x230
> [   95.858823]  __dma_direct_alloc_pages+0x18d/0x390
> [   95.859339]  dma_direct_alloc_pages+0x1b/0x170
> [   95.859827]  snd_dma_alloc_pages+0x1ae/0x380
> [   95.860294]  snd_pcm_lib_malloc_pages+0x371/0x680
> [   95.860812]  snd_intel8x0_hw_params+0x106/0x550
> [   95.861311]  snd_pcm_hw_params+0x2b5/0x1290
> [   95.861780]  ? _copy_from_user+0x70/0xa0
> [   95.862214]  snd_pcm_common_ioctl+0x332/0x1a20
> [   95.862699]  ? up_read+0x10/0x90
> [   95.863070]  ? n_tty_write+0x7ba/0xf70
> [   95.863484]  ? snd_pcm_status_user+0x120/0x120
> [   95.863974]  ? _raw_spin_lock_irqsave+0x7b/0xd0
> [   95.864473]  ? _raw_spin_trylock_bh+0x120/0x120
> [   95.864975]  snd_pcm_ioctl+0x62/0xa0
> [   95.865382]  do_vfs_ioctl+0x9af/0xf30
> [   95.865790]  ? selinux_file_ioctl+0x3ca/0x530
> [   95.866271]  ? ioctl_preallocate+0x1a0/0x1a0
> [   95.866739]  ? selinux_capable+0x20/0x20
> [   95.867172]  ? __fget_light+0xab/0x4c0
> [   95.867588]  ? syscall_trace_enter+0x50e/0xb40
> [   95.868074]  ? iterate_fd+0x180/0x180
> [   95.868478]  ksys_ioctl+0x59/0x90
> [   95.868853]  __x64_sys_ioctl+0x6a/0xb0
> [   95.869278]  do_syscall_64+0x89/0x2e0
> [   95.869681]  ? prepare_exit_to_usermode+0xec/0x190
> [   95.870213]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   95.870764] RIP: 0033:0x7f6f375c8717
> [   95.871157] Code: 00 00 90 48 8b 05 69 57 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 8
> [   95.873187] RSP: 002b:00007ffdbdb71b48 EFLAGS: 00000206 ORIG_RAX: 0000000000000010
> [   95.874009] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6f375c8717
> [   95.874780] RDX: 0000564d6f23c2a0 RSI: 00000000c2604111 RDI: 0000000000000003
> [   95.875555] RBP: 00007ffdbdb71c20 R08: 0000000000000000 R09: 0000000000000010
> [   95.876322] R10: 00007ffdbdb71a27 R11: 0000000000000206 R12: 0000564d6f15e120
> [   95.877093] R13: 00007ffdbdb71d00 R14: 0000000000000000 R15: 0000000000000000
> [   95.877864] Disabling lock debugging due to kernel taint
> [   95.881630] ==================================================================
> [   95.883522] BUG: KASAN: double-free or invalid-free in snd_pcm_lib_free_pages+0xe1/0x230
> [   95.885570] 
> [   95.885976] CPU: 1 PID: 371 Comm: poc Tainted: G    B   W         5.4.191 #6
> [   95.887787] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
> [   95.890095] Call Trace:
> [   95.890505]  dump_stack+0x76/0x9c
> [   95.890859]  print_address_description.constprop.0+0x16/0x200
> [   95.891454]  ? snd_pcm_lib_free_pages+0xe1/0x230
> [   95.891940]  kasan_report_invalid_free+0x61/0xa0
> [   95.892429]  ? snd_pcm_lib_free_pages+0xe1/0x230
> [   95.892921]  __kasan_slab_free+0x15e/0x170
> [   95.893350]  ? snd_pcm_lib_free_pages+0xe1/0x230
> [   95.893843]  kfree+0x8c/0x230
> [   95.894163]  snd_pcm_lib_free_pages+0xe1/0x230
> [   95.894633]  snd_pcm_common_ioctl+0x599/0x1a20
> [   95.895089]  ? snd_pcm_status_user+0x120/0x120
> [   95.895543]  snd_pcm_ioctl+0x62/0xa0
> [   95.895912]  do_vfs_ioctl+0x9af/0xf30
> [   95.896292]  ? selinux_file_ioctl+0x3ca/0x530
> [   95.896752]  ? ioctl_preallocate+0x1a0/0x1a0
> [   95.897184]  ? selinux_capable+0x20/0x20
> [   95.897589]  ? __fget_light+0x2ab/0x4c0
> [   95.898002]  ? iterate_fd+0x180/0x180
> [   95.898385]  ksys_ioctl+0x59/0x90
> [   95.898739]  __x64_sys_ioctl+0x6a/0xb0
> [   95.899139]  do_syscall_64+0x89/0x2e0
> [   95.899521]  ? syscall_return_slowpath+0x17a/0x1e0
> [   95.900013]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> [   95.900532] RIP: 0033:0x7f6f375c8717
> [   95.900905] Code: 00 00 90 48 8b 05 69 57 0c 00 64 c7 00 26 00 00 00 48 c7 c0 ff ff ff ff c3 66 2e 0f 1f 84 00 00 8
> [   95.902809] RSP: 002b:00007f6f30b72ee8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> [   95.903572] RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f6f375c8717
> [   95.904294] RDX: 0000000000000000 RSI: 0000000000004112 RDI: 0000000000000003
> [   95.905009] RBP: 00007f6f30b72f00 R08: 00007f6f30b73700 R09: 00007f6f30b73700
> [   95.905723] R10: 00007f6f30b739d0 R11: 0000000000000246 R12: 00007ffdbdb71ace
> [   95.906442] R13: 00007ffdbdb71acf R14: 00007f6f30b72fc0 R15: 00007f6f30b73700
> 
> 
> The testcase runs successfully after applying this patchset.
> 
> [1] https://www.openwall.com/lists/oss-security/2022/03/28/4
> 
> 
> Takashi Iwai (5):
>   ALSA: pcm: Fix races among concurrent hw_params and hw_free calls
>   ALSA: pcm: Fix races among concurrent read/write and buffer changes
>   ALSA: pcm: Fix races among concurrent prepare and hw_params/hw_free
>     calls
>   ALSA: pcm: Fix races among concurrent prealloc proc writes
>   ALSA: pcm: Fix potential AB/BA lock with buffer_mutex and mmap_lock
> 
>  include/sound/pcm.h     |   2 +
>  sound/core/pcm.c        |   3 ++
>  sound/core/pcm_lib.c    |   5 ++
>  sound/core/pcm_memory.c |  11 ++--
>  sound/core/pcm_native.c | 110 ++++++++++++++++++++++++++++------------
>  5 files changed, 95 insertions(+), 36 deletions(-)
> 
> -- 
> 2.36.0
> 

All now queued up, thanks.

greg k-h
