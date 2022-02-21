Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F6B04BD633
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 07:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiBUGYX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 01:24:23 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229558AbiBUGYW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 01:24:22 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9457FF29
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 22:23:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1645424637;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=puuW8hJ7l4e8iRoz8oAaTvCPF1M0N8o/5tS0H7Vhi4I=;
        b=FTe7XSz4fHoxr+dWxsTbP0a/8bgnyre4kZFKfcVBiFpERro4mZAV+ZwE5GrEj7bl6peHZn
        +HhqhcEqQQiRstm/Rbr9BtRcH3w5kAjnhkwxJWKKRPYUKjBsqEDjORiBjmDGV1fq6XhH5X
        wgwNbgoronpx0X3kSCqUdAO3uS9IbEg=
Received: from mail-pg1-f199.google.com (mail-pg1-f199.google.com
 [209.85.215.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-394-qucAASjFOkK7QnX4wsofIA-1; Mon, 21 Feb 2022 01:23:55 -0500
X-MC-Unique: qucAASjFOkK7QnX4wsofIA-1
Received: by mail-pg1-f199.google.com with SMTP id bh9-20020a056a02020900b0036c0d29eb3eso8939241pgb.9
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 22:23:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=puuW8hJ7l4e8iRoz8oAaTvCPF1M0N8o/5tS0H7Vhi4I=;
        b=AxrgjgaugrLP57/XaBEzUgYZco3dpE63PA8JzJq9PLaVfXSH2OKNn72pbkzBGGshky
         TWqrNkq3SxB061EmIr/z7eIy+az1z3X/+niamvR0Oaja98kGZgYJiDK1cBrz/mu7sDX9
         Zqzwe9tDfZFtqqSbiZelPyP6iDKvWe5Lg3xfcuD4H2BKNPbOfOOthlg7ap+CWWU7Pr02
         eku75qWzmvsZx7o2Uu0B+qu7SsttbOyzoiV/FglytlKigUI535ee5uDLRv2d8fupRpt3
         kB1xXM9NaGChzgo7bXM151al1NzLH2q00dgvfn1rsYhD9Y+JGyVn8bwWz5KyDbakepol
         VHSA==
X-Gm-Message-State: AOAM53014/EOvHYIRu74+9YhCUEU+DHBcrivL/A/WaCCbD3UKr/JhBEk
        t5k2BdHRZ6MOVxhnyBzFZmynu1VqG05cnpdKGnx4W7wWJHVhlgDUf1kOrp1tGb7+gNbH0Ua8Mrr
        ghPohcvrs/uTd3Kn7
X-Received: by 2002:a17:902:dacd:b0:14f:4e5d:fe0d with SMTP id q13-20020a170902dacd00b0014f4e5dfe0dmr17507754plx.128.1645424634564;
        Sun, 20 Feb 2022 22:23:54 -0800 (PST)
X-Google-Smtp-Source: ABdhPJxELl+aXRX4yzOOiRXovJ46Ax7mtRuEZrDkfrPBs5X56Bykl1cYVANw8DRO28eHUExeVt/FvQ==
X-Received: by 2002:a17:902:dacd:b0:14f:4e5d:fe0d with SMTP id q13-20020a170902dacd00b0014f4e5dfe0dmr17507745plx.128.1645424634270;
        Sun, 20 Feb 2022 22:23:54 -0800 (PST)
Received: from xz-m1.local ([94.177.118.63])
        by smtp.gmail.com with ESMTPSA id c3sm11202930pfd.129.2022.02.20.22.23.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 20 Feb 2022 22:23:53 -0800 (PST)
Date:   Mon, 21 Feb 2022 14:23:47 +0800
From:   Peter Xu <peterx@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Linux-MM <linux-mm@kvack.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH] userfaultfd: mark uffd_wp regardless of VM_WRITE flag
Message-ID: <YhMv8xAH4+bzSpo2@xz-m1.local>
References: <20220217211602.2769-1-namit@vmware.com>
 <Yg79WMuYLS1sxASL@xz-m1.local>
 <BDBC90F4-22E1-48CC-9DB8-773C044F0231@gmail.com>
 <68B04C0D-F8CE-4C95-9032-CF703436DC99@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <68B04C0D-F8CE-4C95-9032-CF703436DC99@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 17, 2022 at 08:00:12PM -0800, Nadav Amit wrote:
> 
> > On Feb 17, 2022, at 6:23 PM, Nadav Amit <nadav.amit@gmail.com> wrote:
> > 
> >> PS: I always think here the VM_SOFTDIRTY check is wrong, IMHO it should be:
> >> 
> >>       if (dirty_accountable && pte_dirty(ptent) &&
> >>                       (pte_soft_dirty(ptent) ||
> >>                       (vma->vm_flags & VM_SOFTDIRTY))) {
> >>               ptent = pte_mkwrite(ptent);
> >>       }
> 
> I know it is off-topic (not directly related to my patch), but
> I tried to understand the logic - both of the existing code and of
> your suggested change - and I failed.
> 
> IIUC dirty_accountable (whose value is taken from
> vma_wants_writenotify()) means that the writes *should* be tracked,
> and therefore the page should remain read-only.

Right.

> 
> So basically the condition should have been based on
> !dirty_accountable, i.e. the inverted value of dirty_accountable.
> 
> The problem is that dirty_accountable also reflects VM_SOFTDIRTY
> considerations, so looking on the PTE does not tell you whether
> the PTE should remain write-protected even if it is dirty.

My understanding is that the dirty bits (especially if both set) means
we've tracked dirty on this pte already so we don't need to, hence we can
set the dirty bit here.  E.g., continuous mprotect(RO), mprotect(RW) upon a
full dirty pte.

When something wants to enable tracking again, it needs to clear the dirty
bit, either the real one or soft-dirty one.  So it's a pure performance
enhancement to conditionally set write bit here, when we're sure we won't
need any further tracking on this pte.

One thing to mention is that this path only applies to VM_SHARED|VM_WRITE,
because that's what checked the first in vma_wants_writenotify():

	/* If it was private or non-writable, the write bit is already clear */
	if ((vm_flags & (VM_WRITE|VM_SHARED)) != ((VM_WRITE|VM_SHARED)))
		return 0;

IOW private mappings are not optimized in current tree yet.

Peter Collingbourne proposed a patch some time ago to optimize it but it
didn't get merged somehow.  Meanwhile even with his latest version it
should still miss the thp case, so if to reference the private optimization
Andrea's tree would be the best:

https://github.com/aagit/aa/commit/fadb5e04d94472614c76819acd979b2f60e4eff6

Hope it clarifies things a bit.  Thanks,

-- 
Peter Xu

