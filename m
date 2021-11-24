Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CFFF45CE36
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 21:40:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238305AbhKXUni (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 15:43:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:44369 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237855AbhKXUnh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 15:43:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1637786426;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MFdPdhp5Qz+NviYpkRN6ONk+r/OSHt7a4bF0r1DLLLQ=;
        b=DZKnU5dtCM7dJF3knhlRVjQ7TrHBU+t36hH3o3mjf7PJjeZdCYk8gwRGHoXgiM95cQhUho
        EO67RQFIG5KPiVlm/qZiTpdWHPF7Dun5jfUe4OICpKnJ28Y5HlfS/WbwPHxJH4EFxf5+tK
        zk6e/n3+MJ3jsW4k+tkXIJBoz7019G8=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-316-TkUEYug6MuGnpq8WUzwYXg-1; Wed, 24 Nov 2021 15:40:25 -0500
X-MC-Unique: TkUEYug6MuGnpq8WUzwYXg-1
Received: by mail-wm1-f72.google.com with SMTP id r6-20020a1c4406000000b0033119c22fdbso1876154wma.4
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 12:40:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=MFdPdhp5Qz+NviYpkRN6ONk+r/OSHt7a4bF0r1DLLLQ=;
        b=CszogCfCTvCofMdDORPfWfmD4aKDpGtGCG4TYhBKpUunqBNy0+v5w1VK2r0TjZLNdO
         wvnQtSPYpyqH/5iLUMaFyLiULSiSbUwaFzGF5EJ9k/ihp1H6d7DzsS1a7+kXGZpfNYq1
         p9ppTkj0MBnggU0PSgOJMYjhlU+05ENwOQwLefx8+YTyI8lFH17QLXJCyZSoXh/SGMKQ
         MbwMx3jOH6RsmJvOc1liotrSu91KIqSwd/8lV2JOcSsIzxk+FAjGVT1cuo+a4kvRyPSg
         /miJB8BOnJjkBKRDpBfYeC/mVDwPn5Lacers16gA1Ite6khvp832A5NQxK2j0tMXci4E
         dCYA==
X-Gm-Message-State: AOAM531q+45FASvKKeF5B1/5jCgknm/cG+ZmJck4nx6NmPhRXs4hMEk/
        MwSCuKaI7r+x/YaLvR7+LfDSF94kDOYABToT9P6E8+txeugCoIadXrtiV7W3UDq44LsvTUCQsw0
        /0JymHW1Ad5RIBPqcMfSxoLhlA8Z+RTRkP54LeQv1BEf+zYGGWkgZcO+0xhlYT/X6
X-Received: by 2002:a7b:c752:: with SMTP id w18mr19475418wmk.96.1637786424318;
        Wed, 24 Nov 2021 12:40:24 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxmDYUPhZlLA/4M84pCiX9ZS4sa/PA9TcJjJGPKyvmYnhDx0m75BZEGL9zO9WFyZVI/Nc9xMQ==
X-Received: by 2002:a7b:c752:: with SMTP id w18mr19475373wmk.96.1637786424071;
        Wed, 24 Nov 2021 12:40:24 -0800 (PST)
Received: from [192.168.3.132] (p5b0c6380.dip0.t-ipconnect.de. [91.12.99.128])
        by smtp.gmail.com with ESMTPSA id m9sm1001529wmq.1.2021.11.24.12.40.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Nov 2021 12:40:23 -0800 (PST)
Message-ID: <afd898ea-99b0-dbfc-1180-f95cf6041414@redhat.com>
Date:   Wed, 24 Nov 2021 21:40:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Subject: Re: [PATCH for 4.9-stable] proc/vmcore: fix clearing user buffer by
 properly using clear_user()
Content-Language: en-US
To:     stable@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        akpm@linux-foundation.org, Baoquan He <bhe@redhat.com>,
        Dave Young <dyoung@redhat.com>,
        Vivek Goyal <vgoyal@redhat.com>,
        Philipp Rudo <prudo@redhat.com>
References: <linux-4.14.y> <20211124203530.26170-1-david@redhat.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20211124203530.26170-1-david@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 24.11.21 21:35, David Hildenbrand wrote:
> commit c1e63117711977cc4295b2ce73de29dd17066c82 upstream.
> 
> To clear a user buffer we cannot simply use memset, we have to use
> clear_user().  With a virtio-mem device that registers a vmcore_cb and
> has some logically unplugged memory inside an added Linux memory block,
> I can easily trigger a BUG by copying the vmcore via "cp":
> 
>   systemd[1]: Starting Kdump Vmcore Save Service...
>   kdump[420]: Kdump is using the default log level(3).
>   kdump[453]: saving to /sysroot/var/crash/127.0.0.1-2021-11-11-14:59:22/
>   kdump[458]: saving vmcore-dmesg.txt to /sysroot/var/crash/127.0.0.1-2021-11-11-14:59:22/
>   kdump[465]: saving vmcore-dmesg.txt complete
>   kdump[467]: saving vmcore
>   BUG: unable to handle page fault for address: 00007f2374e01000
>   #PF: supervisor write access in kernel mode
>   #PF: error_code(0x0003) - permissions violation
>   PGD 7a523067 P4D 7a523067 PUD 7a528067 PMD 7a525067 PTE 800000007048f867
>   Oops: 0003 [#1] PREEMPT SMP NOPTI
>   CPU: 0 PID: 468 Comm: cp Not tainted 5.15.0+ #6
>   Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS rel-1.14.0-27-g64f37cc530f1-prebuilt.qemu.org 04/01/2014
>   RIP: 0010:read_from_oldmem.part.0.cold+0x1d/0x86
>   Code: ff ff ff e8 05 ff fe ff e9 b9 e9 7f ff 48 89 de 48 c7 c7 38 3b 60 82 e8 f1 fe fe ff 83 fd 08 72 3c 49 8d 7d 08 4c 89 e9 89 e8 <49> c7 45 00 00 00 00 00 49 c7 44 05 f8 00 00 00 00 48 83 e7 f81
>   RSP: 0018:ffffc9000073be08 EFLAGS: 00010212
>   RAX: 0000000000001000 RBX: 00000000002fd000 RCX: 00007f2374e01000
>   RDX: 0000000000000001 RSI: 00000000ffffdfff RDI: 00007f2374e01008
>   RBP: 0000000000001000 R08: 0000000000000000 R09: ffffc9000073bc50
>   R10: ffffc9000073bc48 R11: ffffffff829461a8 R12: 000000000000f000
>   R13: 00007f2374e01000 R14: 0000000000000000 R15: ffff88807bd421e8
>   FS:  00007f2374e12140(0000) GS:ffff88807f000000(0000) knlGS:0000000000000000
>   CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>   CR2: 00007f2374e01000 CR3: 000000007a4aa000 CR4: 0000000000350eb0
>   Call Trace:
>    read_vmcore+0x236/0x2c0
>    proc_reg_read+0x55/0xa0
>    vfs_read+0x95/0x190
>    ksys_read+0x4f/0xc0
>    do_syscall_64+0x3b/0x90
>    entry_SYSCALL_64_after_hwframe+0x44/0xae
> 
> Some x86-64 CPUs have a CPU feature called "Supervisor Mode Access
> Prevention (SMAP)", which is used to detect wrong access from the kernel
> to user buffers like this: SMAP triggers a permissions violation on
> wrong access.  In the x86-64 variant of clear_user(), SMAP is properly
> handled via clac()+stac().
> 
> To fix, properly use clear_user() when we're dealing with a user buffer.
> 
> Link: https://lkml.kernel.org/r/20211112092750.6921-1-david@redhat.com
> Fixes: 997c136f518c ("fs/proc/vmcore.c: add hook to read_from_oldmem() to check for non-ram pages")
> Signed-off-by: David Hildenbrand <david@redhat.com>
> Acked-by: Baoquan He <bhe@redhat.com>
> Cc: Dave Young <dyoung@redhat.com>
> Cc: Baoquan He <bhe@redhat.com>
> Cc: Vivek Goyal <vgoyal@redhat.com>
> Cc: Philipp Rudo <prudo@redhat.com>
> Cc: <stable@vger.kernel.org>
> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
> Signed-off-by: David Hildenbrand <david@redhat.com>
> ---
>  fs/proc/vmcore.c | 15 ++++++++++-----
>  1 file changed, 10 insertions(+), 5 deletions(-)

Please ignore this patch, I just resend with the correct --in-reply-to.


-- 
Thanks,

David / dhildenb

