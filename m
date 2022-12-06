Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EBA4644DF4
	for <lists+stable@lfdr.de>; Tue,  6 Dec 2022 22:28:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229507AbiLFV2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Dec 2022 16:28:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229452AbiLFV2c (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Dec 2022 16:28:32 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F52F632A
        for <stable@vger.kernel.org>; Tue,  6 Dec 2022 13:27:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1670362056;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=PRGbK9k8R9uzFMCG9ps6sFZXam1J9ub+EnEOXkruzkY=;
        b=dBm4DUqcec8iQeDw8nOsoZnfinJnIXxbTLjszgSDPG82dRF+ZUgCs/OPKS0eUZ7dSKgySa
        CpG2yUR8RMYI/yVIykcA1pEV68qKrxjd3FWmzufxnfXTe3QCyeerJCmH3aSquBtKo/0zsF
        ruPzINCC1xphxzF9nuPdRBjuAbtmeTM=
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com
 [209.85.219.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-588-sq89k0F4Mt6yRZe4UTqkjw-1; Tue, 06 Dec 2022 16:27:34 -0500
X-MC-Unique: sq89k0F4Mt6yRZe4UTqkjw-1
Received: by mail-qv1-f72.google.com with SMTP id nn2-20020a056214358200b004bb7bc3dfdcso35578652qvb.23
        for <stable@vger.kernel.org>; Tue, 06 Dec 2022 13:27:34 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PRGbK9k8R9uzFMCG9ps6sFZXam1J9ub+EnEOXkruzkY=;
        b=7JUMNQ8G2YrpHR2jb7JA3o01xuGh1iDiAIFFBDmVE1GdBy0JcC8vauu+RV4huGNpb3
         HEL8d5NpIjEvXP+Jn9v6QMbknkggPQCKod750E/LN6a00pz3LzzHbzbYai0uxfN5WBXD
         j48tUHY9b9xAh0RYv5duLx6+MIBtN2S9WcZy1jzcNbOgcl2p6tCM2+j6Z9NO1rApkgSt
         Q6tLgMBj0XKhvUclKwmIgwMZM0oxoFDpkjm+3RKXHg6mee3dZfN16iaGpJrPs2x8cP07
         AsaPE8wrsGQI7w8QJ0zKE7lUl6j3E05GXhsHWxAakkiuvXECJgwZULpSi7vxPCkrRlDC
         oEAA==
X-Gm-Message-State: ANoB5pnm9TtHFdzfGu8bQFUNddKkiWdIwZ00pyJp00UvOM0Usbj0RyEi
        Ke4mAHNKFveoUrx6gAOPteWKG1NkSvxUL9EGYvmi5ebTeNQUj7v4lxvWBSwjDs0VySBTPCdKYVu
        WfsJf5ZEqCfYe6UkS
X-Received: by 2002:ac8:5508:0:b0:39c:da20:688 with SMTP id j8-20020ac85508000000b0039cda200688mr612920qtq.43.1670362054291;
        Tue, 06 Dec 2022 13:27:34 -0800 (PST)
X-Google-Smtp-Source: AA0mqf4kmVlOInGq/Pojb+UUeaVf8jYPRob7UOLmrRyKTTf+RHP6JcKzENk2Gdwl4icvTqnqDou07g==
X-Received: by 2002:ac8:5508:0:b0:39c:da20:688 with SMTP id j8-20020ac85508000000b0039cda200688mr612909qtq.43.1670362054063;
        Tue, 06 Dec 2022 13:27:34 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id k17-20020ac84791000000b003a50c9993e1sm12431610qtq.16.2022.12.06.13.27.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 06 Dec 2022 13:27:33 -0800 (PST)
Date:   Tue, 6 Dec 2022 16:27:31 -0500
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Ives van Hoorne <ives@codesandbox.io>,
        stable@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hugh@veritas.com>,
        Alistair Popple <apopple@nvidia.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH RFC] mm/userfaultfd: enable writenotify while
 userfaultfd-wp is enabled for a VMA
Message-ID: <Y4+zw4JU7JMlDHbM@x1n>
References: <20221202122748.113774-1-david@redhat.com>
 <Y4oo6cN1a4Yz5prh@x1n>
 <690afe0f-c9a0-9631-b365-d11d98fdf56f@redhat.com>
 <19800718-9cb6-9355-da1c-c7961b01e922@redhat.com>
 <Y45duzmGGUT0+u8t@x1n>
 <92173bad-caa3-6b43-9d1e-9a471fdbc184@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <92173bad-caa3-6b43-9d1e-9a471fdbc184@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 05:28:07PM +0100, David Hildenbrand wrote:
> > If no one is using mprotect() with uffd-wp like that, then the reproducer
> > may not be valid - the reproducer is defining how it should work, but does
> > that really stand?  That's why I said it's ambiguous, because the
> > definition in this case is unclear.
> 
> There are interesting variations like:
> 
> mmap(PROT_READ, MAP_POPULATE|MAP_SHARED)
> uffd_wp()
> mprotect(PROT_READ|PROT_WRITE)
> 
> Where we start out with all-write permissions before we enable selective
> write permissions.

Could you elaborate what's the difference of above comparing to:

mmap(PROT_READ|PROT_WRITE, MAP_POPULATE|MAP_SHARED)
uffd_wp()

?

[...]

> Yes, you are correct. I added that to the patch description:
> 
> "
> Note that we don't optimize for the actual migration case:
>     (1) When migration succeeds the new PTE will not be writable because
>         the source PTE was not writable (protnone); in the future we
>         might just optimize that case similarly by reusing
>         can_change_pte_writable()/can_change_pmd_writable() when
>         removing migration PTEs.
>     (2) When migration fails, we'd have to recalculate the "writable"
>         flag because we temporarily dropped the PT lock; for now keep it
>         simple and set "writable=false".
> "
> 
> Case (1) would, with your current patch, always lose the write bit during
> migration, even if vma->vm_page_prot included it. We most might want to
> optimize that in the future.
> 
> Case (2) is rather a corner case, and unless people complain about it being
> a real performance issue, it felt cleaner (less code) to not optimize for
> that now.

As I didn't have a closer look on the savedwrite removal patchset so I may
not speak anything sensible here..  What I hope is that we don't lose write
bits easily, after all we tried to even safe the dirty and young bits to
avoid the machine cycles in the MMUs.

> 
> Again Peter, I am not against you, not at all. Sorry if I gave you the
> impression. I highly appreciate your work and this discussion.

No worry on that part.  You're doing great in this email explaining things
and write things up, especially I'm happy Hugh confirmed it so it's good to
have those.  Let's start with something like this when you NAK something
next time. :)

Thanks,

-- 
Peter Xu

