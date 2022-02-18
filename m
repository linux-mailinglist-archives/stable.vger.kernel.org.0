Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AFA84BB06F
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 04:56:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229597AbiBRD5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 22:57:00 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:48722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiBRD47 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 22:56:59 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 5025642EC4
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 19:56:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645156601;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bXeZkhLx3l6f5AkCBl9a2bLqsXjuwnfzkgL9f0Sf9iI=;
        b=IMaKH8g9F5gB7EnMQ1a29FC4hRoFEI84Xyv9Donuh6OgXL7qN66D7+xOGt9rQTvZXThByQ
        +6HXPTXBBw78T+FkobYX/kKamVE0fOY/ghJmvTfuahc4t3C8F9Cg/WIfMV1v6tmGANIQrf
        MFTPMud6JAeFGMnVE0vaUTP5MEd1+AQ=
Received: from mail-pg1-f197.google.com (mail-pg1-f197.google.com
 [209.85.215.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-306-EF-7o-D5NZOSyAp_qs_bZg-1; Thu, 17 Feb 2022 22:56:39 -0500
X-MC-Unique: EF-7o-D5NZOSyAp_qs_bZg-1
Received: by mail-pg1-f197.google.com with SMTP id r8-20020a638f48000000b0036c6a881088so4038799pgn.2
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 19:56:39 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=bXeZkhLx3l6f5AkCBl9a2bLqsXjuwnfzkgL9f0Sf9iI=;
        b=6MQVQon516K0bJIix0R1i+sz8n+WCPCivBmhM1lIDIwfUIjeXMI+CNpbSUcz2f6YxH
         vwAW89LUNwmIuJNrhFir4lytxe0BIBVYQDSA9k534R3VaCekMeHT94EEb3Y4ORsDODk8
         s8xueT4pcJiCOg9ZpPb9d8Kj6SgmO07a1bxRpuqQxN1Gf7NCQFGYIvmnEofmwDMVhaDB
         2AFvJHFM+sWiMKi++dC9vx7sAy0tlfCcNHpVXhsqsVH2chU5JxLABUdKdjZK4288qdif
         cT7KZ2yeftOgYGvSbm6ckElcdVtzvf4p5R14dZW+mzlXFT5uleR7zFu6gWqpUGT9EKrd
         lfVw==
X-Gm-Message-State: AOAM532QhFREFsTcQ1cj7wmEjO/r6zZ74EHXBrCU0xVx1f0yp9O4wRar
        DSIZZvA67ewWJedkCiznzLkXqLP+PaY6rXs9grs6bW50piSdeY7bDU1P+ob9b2Q4WJpIG7iFkwF
        PywjE8h7LrmkhTbib
X-Received: by 2002:a63:6a06:0:b0:344:252c:4063 with SMTP id f6-20020a636a06000000b00344252c4063mr4818955pgc.83.1645156598756;
        Thu, 17 Feb 2022 19:56:38 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzugqfiBRiPKlKlsLbvgn+eazeI05CjmJmzf+hsBWZYU8W5VTuGX10AqKj8BfzZlpa/XnVgYQ==
X-Received: by 2002:a63:6a06:0:b0:344:252c:4063 with SMTP id f6-20020a636a06000000b00344252c4063mr4818938pgc.83.1645156598462;
        Thu, 17 Feb 2022 19:56:38 -0800 (PST)
Received: from xz-m1.local ([94.177.118.104])
        by smtp.gmail.com with ESMTPSA id mv17sm2739150pjb.14.2022.02.17.19.56.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 19:56:37 -0800 (PST)
Date:   Fri, 18 Feb 2022 11:56:33 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: mark uffd_wp regardless of VM_WRITE flag
Message-ID: <Yg8Y6PwSjihJ0ogp@xz-m1.local>
References: <20220217211602.2769-1-namit@vmware.com>
 <Yg79WMuYLS1sxASL@xz-m1.local>
 <BDBC90F4-22E1-48CC-9DB8-773C044F0231@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BDBC90F4-22E1-48CC-9DB8-773C044F0231@gmail.com>
X-Spam-Status: No, score=-2.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 06:23:14PM -0800, Nadav Amit wrote:
> 
> 
> > On Feb 17, 2022, at 5:58 PM, Peter Xu <peterx@redhat.com> wrote:
> > 
> > Hello, Nadav,
> > 
> > On Thu, Feb 17, 2022 at 09:16:02PM +0000, Nadav Amit wrote:
> >> From: Nadav Amit <namit@vmware.com>
> >> 
> >> When a PTE is set by UFFD operations such as UFFDIO_COPY, the PTE is
> >> currently only marked as write-protected if the VMA has VM_WRITE flag
> >> set. This seems incorrect or at least would be unexpected by the users.
> >> 
> >> Consider the following sequence of operations that are being performed
> >> on a certain page:
> >> 
> >> 	mprotect(PROT_READ)
> >> 	UFFDIO_COPY(UFFDIO_COPY_MODE_WP)
> >> 	mprotect(PROT_READ|PROT_WRITE)
> > 
> > No objection to the patch, however I'm wondering why this is a valid use
> > case because mprotect seems to be conflict with uffd, because AFAICT
> > mprotect(PROT_READ|PROT_WRITE) can already grant write bit.
> > 
> > In change_pte_range():
> > 
> >        if (dirty_accountable && pte_dirty(ptent) &&
> >                        (pte_soft_dirty(ptent) ||
> >                                !(vma->vm_flags & VM_SOFTDIRTY))) {
> >                ptent = pte_mkwrite(ptent);
> >        }
> 
> I think you are right, and an additional patch is needed to prevent
> mprotect() from making an entry writable if the PTE has _PAGE_UFFD_WP
> set and uffd_wp_resolve was not provided. I missed that.

Perhaps we can simply make this "if" to be "else" so as to connect with the
previous "if"?  After all the three (wp, wp_resolv, dirty_acct) are never
used with more than one flag set.

> 
> I’ll post another patch for this one.
> 
> > 
> > PS: I always think here the VM_SOFTDIRTY check is wrong, IMHO it should be:
> > 
> >        if (dirty_accountable && pte_dirty(ptent) &&
> >                        (pte_soft_dirty(ptent) ||
> >                        (vma->vm_flags & VM_SOFTDIRTY))) {
> >                ptent = pte_mkwrite(ptent);
> >        }
> > 
> > Because when VM_SOFTDIRTY is cleared it means soft dirty enabled.  I wanted
> > to post a patch but I never yet.
> 
> Seems that you are right. Yet, having this wrong code around for
> some time raises the concern whether something will break. By the
> soft-dirty I saw so far, it seems that it is not commonly used.

I'll see whether I should prepare a patch and a test, maybe after yours.

> 
> > Could I ask why you need mprotect() with uffd?
> 
> Sure. I think I mentioned it before, that I want to use userfaultfd
> for other processes [1], by having one monitor UFFD for multiple
> processes that handles their swap/prefetch activities based on custom
> policies.
> 
> I try to set the least amount of constraints on what these processes
> might do, and mprotect() is something they are allowed to do.

I see.  I didn't expect mprotect() can work well with uffd, but it seems
fine at least in this case.

Have you thought about other use of mprotect() other than RO?  Say, I only
know a valid use case of PROT_NONE for region reservation purpose, which
normally will be followed up by a munmap() and remap on the same address.
That sounds okay.  But not sure whether this patch will cover all the
possible mprotect() uses in the tracee.

> 
> I would hopefully send the patches that are required for all of that
> and open source my code soon. In the meanwhile I try to upstream the
> least controversial parts.

Sure, I'm always happy to learn it.  Thanks,

> 
> [1] https://lore.kernel.org/linux-mm/YWZCClDorCCM7KMG@t490s/t/

-- 
Peter Xu

