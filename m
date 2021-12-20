Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720CF47A6F0
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 10:23:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232144AbhLTJXz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 04:23:55 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:54646 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232442AbhLTJXk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 04:23:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1639992219;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Nnk2J4ZoXBtJE9rH5Olhc2v3ow2o0jQFMpDHq6LmjfY=;
        b=JLubTvJE+shGgYyM8XaCV9zCyitSymWQtImMUs+qNL+vqqP7KDSLqgwdSSPVCBg/dSnX3g
        8Bdx/4Kh4e3VE20HB8931fBj6oplfgfzyMALtVSO0ehSaww3O8VdORaGU5GJooj5VlPhfr
        c8o38tp0WmgccVHpwrVx34WKvLsIltU=
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com
 [209.85.208.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-562-4LLwJ3JBPbKK5qlruxWgjQ-1; Mon, 20 Dec 2021 04:23:38 -0500
X-MC-Unique: 4LLwJ3JBPbKK5qlruxWgjQ-1
Received: by mail-ed1-f71.google.com with SMTP id o20-20020a056402439400b003f83cf1e472so2885634edc.18
        for <stable@vger.kernel.org>; Mon, 20 Dec 2021 01:23:38 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version;
        bh=Nnk2J4ZoXBtJE9rH5Olhc2v3ow2o0jQFMpDHq6LmjfY=;
        b=X42/5doUwIW62cy8VeB8J+73IvW1WG6NslIS79o8EV3UkyFszraF5LlSl8zJ+3ZXKS
         WKQWMK353xtN9C/3KwoIX9VgBvG+JqhCfXOss1qQdQ6icuTw2Fhyk4TD7a76xjMTag1r
         Qg4aUup+rYaW+OGmSojtv0bn4Xk4jWcWg2EMO2cIvC+Qvp6ZoPRMag8UznePWkYlzU8q
         I/NwbtZo5Ww21uriSrpV1BwxgWTfRNxXJjAlEFRmYp5T1dpqEWLVC01XKvEQ92AbgZll
         mYDqcux0Beq3hrsvGo9hoVMS+86Gg+X5TbovqtGi3ZiDKm6d92CAJOndj+zhrbUqVCYl
         HhUw==
X-Gm-Message-State: AOAM531YrgbP6dHbCzi7gfUVI9dzAR5RhPc0qONGNxuOolHBHPyP7ty1
        3mLgi6aFvDeLOdCStdbM1gAJuqGHFkVCam/pdKxJ8bJuV61EeXOjlob9hhlp3Y69vUmYLWB/nBC
        ew/CIDnqcJUGipFSh
X-Received: by 2002:a05:6402:c0a:: with SMTP id co10mr14695510edb.295.1639992217399;
        Mon, 20 Dec 2021 01:23:37 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzUAbBEWaDB55xFPv1shMHEPRY0K/FLkT72nUjo6PPZahsoOBnw0777NBsB1oiVAcMaXdj8AQ==
X-Received: by 2002:a05:6402:c0a:: with SMTP id co10mr14695500edb.295.1639992217232;
        Mon, 20 Dec 2021 01:23:37 -0800 (PST)
Received: from fedora (nat-2.ign.cz. [91.219.240.2])
        by smtp.gmail.com with ESMTPSA id j11sm6434339edv.0.2021.12.20.01.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Dec 2021 01:23:36 -0800 (PST)
From:   Vitaly Kuznetsov <vkuznets@redhat.com>
To:     Andra Paraschiv <andraprs@amazon.com>,
        linux-kernel <linux-kernel@vger.kernel.org>
Cc:     Alexandru Ciobotaru <alcioa@amazon.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alexandru Vasile <lexnv@amazon.com>,
        Marcelo Cerri <marcelo.cerri@canonical.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        kvm <kvm@vger.kernel.org>,
        ne-devel-upstream <ne-devel-upstream@amazon.com>,
        stable <stable@vger.kernel.org>,
        Andra Paraschiv <andraprs@amazon.com>
Subject: Re: [PATCH =?utf-8?Q?v1=C2=A0=5D?= nitro_enclaves: Add
 mmap_read_lock() for the
 get_user_pages() call
In-Reply-To: <20211218103525.26739-1-andraprs@amazon.com>
References: <20211218103525.26739-1-andraprs@amazon.com>
Date:   Mon, 20 Dec 2021 10:23:35 +0100
Message-ID: <87o85btyso.fsf@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Andra Paraschiv <andraprs@amazon.com> writes:

> After commit 5b78ed24e8ec (mm/pagemap: add mmap_assert_locked()
> annotations to find_vma*()), the call to get_user_pages() will trigger
> the mmap assert.
>
> static inline void mmap_assert_locked(struct mm_struct *mm)
> {
> 	lockdep_assert_held(&mm->mmap_lock);
> 	VM_BUG_ON_MM(!rwsem_is_locked(&mm->mmap_lock), mm);
> }
>
> [   62.521410] kernel BUG at include/linux/mmap_lock.h:156!
> ...........................................................
> [   62.538938] RIP: 0010:find_vma+0x32/0x80
> ...........................................................
> [   62.605889] Call Trace:
> [   62.608502]  <TASK>
> [   62.610956]  ? lock_timer_base+0x61/0x80
> [   62.614106]  find_extend_vma+0x19/0x80
> [   62.617195]  __get_user_pages+0x9b/0x6a0
> [   62.620356]  __gup_longterm_locked+0x42d/0x450
> [   62.623721]  ? finish_wait+0x41/0x80
> [   62.626748]  ? __kmalloc+0x178/0x2f0
> [   62.629768]  ne_set_user_memory_region_ioctl.isra.0+0x225/0x6a0 [nitro_enclaves]
> [   62.635776]  ne_enclave_ioctl+0x1cf/0x6d7 [nitro_enclaves]
> [   62.639541]  __x64_sys_ioctl+0x82/0xb0
> [   62.642620]  do_syscall_64+0x3b/0x90
> [   62.645642]  entry_SYSCALL_64_after_hwframe+0x44/0xae
>
> Add mmap_read_lock() for the get_user_pages() call when setting the
> enclave memory regions.
>
> Signed-off-by: Andra Paraschiv <andraprs@amazon.com>
> Cc: stable@vger.kernel.org

In case commit 5b78ed24e8ec broke Nitro Enclaves driver, we need to
explicitly state this:

Fixes: 5b78ed24e8ec ("mm/pagemap: add mmap_assert_locked() annotations to find_vma*()")

> ---
>  drivers/virt/nitro_enclaves/ne_misc_dev.c | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/drivers/virt/nitro_enclaves/ne_misc_dev.c b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> index 8939612ee0e0..6c51ff024036 100644
> --- a/drivers/virt/nitro_enclaves/ne_misc_dev.c
> +++ b/drivers/virt/nitro_enclaves/ne_misc_dev.c
> @@ -886,8 +886,13 @@ static int ne_set_user_memory_region_ioctl(struct ne_enclave *ne_enclave,
>  			goto put_pages;
>  		}
>  
> +		mmap_read_lock(current->mm);
> +
>  		gup_rc = get_user_pages(mem_region.userspace_addr + memory_size, 1, FOLL_GET,
>  					ne_mem_region->pages + i, NULL);
> +
> +		mmap_read_unlock(current->mm);
> +

This looks very much like get_user_pages_unlocked(), I think we can use
it instead of open-coding it.

>  		if (gup_rc < 0) {
>  			rc = gup_rc;

-- 
Vitaly

