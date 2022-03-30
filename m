Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71B2F4EB9D2
	for <lists+stable@lfdr.de>; Wed, 30 Mar 2022 07:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242691AbiC3FES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Mar 2022 01:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242687AbiC3FER (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Mar 2022 01:04:17 -0400
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C08CFB9D
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 22:02:32 -0700 (PDT)
Received: by mail-pj1-x102a.google.com with SMTP id o3-20020a17090a3d4300b001c6bc749227so5075978pjf.1
        for <stable@vger.kernel.org>; Tue, 29 Mar 2022 22:02:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Q85yzQxuckTI85t4cJc6DzVDpQWWYMYpPgEAz27AZ68=;
        b=ZHB4+/xxhnaUd9srMjdIbuyk3a2PTfBvLvGAfiBjML6/F3kNlVnSuQW/XM+IzgUwbY
         5/NhAggjA+JF2LrMbYNU0lxeZapTt/wS0JljVhTU2i2oWKUpxI0lxEbsL585kyDCCiUG
         wX4xh6bQKFgWZjJI2nBt95FnpSNviAw4BfWG0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Q85yzQxuckTI85t4cJc6DzVDpQWWYMYpPgEAz27AZ68=;
        b=XP49ctMe5sKpmi/Xu/aOo7Iajx8lrR9Lg5OxGP5FnKPtDGLe6WcY5rU88hAGvZ2yZR
         zDYwFZfhxHGJ8q6lWhtbbSTXSf2rdk3abieb5oglfsJxqW1cbtjcCC9znRe/95R81kZ5
         OXMSPcRkX3GabYx8vnvhAGAnmvXGfzhJxKU5NThucjaGyXbg3Xmcg3irehfzBPQ7tiWG
         uH85qRLzN/bVxdijKnY7NifuxycNMmuhxGBayMFVGxCLBTgBNsrBQgNcFmx0augZgDSb
         /FkQx/NnSBwIPu0YXcBdjjLIPs2woKiENclnzBXBauBH8bo1k5anxryGaQjMIcRVVa35
         NAxg==
X-Gm-Message-State: AOAM533HrBtg+g4TutM6QiPiFdOnEXLlABfXVJ9zsmrkMSdklFbnVxsq
        OvoZYy3nXTf/FcjEhS/wKzTFnQ==
X-Google-Smtp-Source: ABdhPJynLoJHDRoNgTS6HubmG1wyKYpNp3nof3cTY8dxxZLdxGtQyIunL3E09HMqA82pa808/H7T4Q==
X-Received: by 2002:a17:902:d4cf:b0:154:2416:218e with SMTP id o15-20020a170902d4cf00b001542416218emr32897719plg.60.1648616552074;
        Tue, 29 Mar 2022 22:02:32 -0700 (PDT)
Received: from google.com ([2401:fa00:8f:203:1719:a115:46dd:6b80])
        by smtp.gmail.com with ESMTPSA id y8-20020a17090aa40800b001c6ccb2c395sm4524541pjp.9.2022.03.29.22.02.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Mar 2022 22:02:31 -0700 (PDT)
Date:   Wed, 30 Mar 2022 14:02:26 +0900
From:   Sergey Senozhatsky <senozhatsky@chromium.org>
To:     Minchan Kim <minchan@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     mm-commits@vger.kernel.org, stable@vger.kernel.org,
        senozhatsky@chromium.org, ngupta@vflare.org, ivan@cloudflare.com,
        david@redhat.com, axboe@kernel.dk, minchan@kernel.org
Subject: Re: + mm-fix-unexpected-zeroed-page-mapping-with-zram-swap.patch
 added to -mm tree
Message-ID: <YkPkYmn6E7DY7EPP@google.com>
References: <20220326034321.2589FC340E8@smtp.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220326034321.2589FC340E8@smtp.kernel.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On (22/03/25 20:43), Andrew Morton wrote:
> Two processes under CLONE_VM cloning, user process can be corrupted by
> seeing zeroed page unexpectedly.
> 
>     CPU A                        CPU B
> 
> do_swap_page                do_swap_page
> SWP_SYNCHRONOUS_IO path     SWP_SYNCHRONOUS_IO path
> swap_readpage valid data
>   swap_slot_free_notify
>     delete zram entry
>                             swap_readpage zeroed(invalid) data
>                             pte_lock
>                             map the *zero data* to userspace
>                             pte_unlock
> pte_lock
> if (!pte_same)
>   goto out_nomap;
> pte_unlock
> return and next refault will
> read zeroed data
> 
> The swap_slot_free_notify is bogus for CLONE_VM case since it doesn't
> increase the refcount of swap slot at copy_mm so it couldn't catch up
> whether it's safe or not to discard data from backing device.  In the
> case, only the lock it could rely on to synchronize swap slot freeing is
> page table lock.  Thus, this patch gets rid of the swap_slot_free_notify
> function.  With this patch, CPU A will see correct data.
> 
>     CPU A                        CPU B
> 
> do_swap_page                do_swap_page
> SWP_SYNCHRONOUS_IO path     SWP_SYNCHRONOUS_IO path
>                             swap_readpage original data
>                             pte_lock
>                             map the original data
>                             swap_free
>                               swap_range_free
>                                 bd_disk->fops->swap_slot_free_notify
> swap_readpage read zeroed data
>                             pte_unlock
> pte_lock
> if (!pte_same)
>   goto out_nomap;
> pte_unlock
> return
> on next refault will see mapped data by CPU B
> 
> The concern of the patch would increase memory consumption since it could
> keep wasted memory with compressed form in zram as well as uncompressed
> form in address space.  However, most of cases of zram uses no readahead
> and do_swap_page is followed by swap_free so it will free the compressed
> form from in zram quickly.

Minchan, a quick question, shouldn't this instead revert 3f2b1a04f4493?
