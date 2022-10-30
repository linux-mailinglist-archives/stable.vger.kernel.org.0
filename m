Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7AB0612C50
	for <lists+stable@lfdr.de>; Sun, 30 Oct 2022 19:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229576AbiJ3Sow (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Oct 2022 14:44:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiJ3Sov (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Oct 2022 14:44:51 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 610E462CE
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 11:43:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1667155436;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=f++yjA22gDYnyDkTxD8DX0hMfV9eCOWk5hFBUUA9MAI=;
        b=gwwH6Z065COj6rPqUAg6BrM5U4YHyuAeDY0t/k8vTChvv+vmjQcPmknCU1nBkIQ0a3hn8k
        Ux3FhBgdqxu48xViExgf9ydmATAKMPxJK9yjDohPEOuwpAGM5SbIcPRYWQg8iBNVaZVwHw
        BpJFdQDqAjuZYObSAyudjoCuyIE49g8=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-447-y1mOeuECNKqaNgjEVYzgwQ-1; Sun, 30 Oct 2022 14:43:55 -0400
X-MC-Unique: y1mOeuECNKqaNgjEVYzgwQ-1
Received: by mail-qk1-f199.google.com with SMTP id w13-20020a05620a424d00b006e833c4fb0dso7770598qko.2
        for <stable@vger.kernel.org>; Sun, 30 Oct 2022 11:43:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f++yjA22gDYnyDkTxD8DX0hMfV9eCOWk5hFBUUA9MAI=;
        b=uQgKn0wXJlCRzLpAsQGia7MrbJAfswGuWecrWwHxkVPbq/CjtVsfVXT+4v7Z58IXHs
         +SXkb7PxdGty+L0qKa350F62O7RFSMZPOSz2g+/Ab9+fVGSngFmqwuzHk2H8SFeZk42l
         XxkyJCPyqP2IEpeJEGzP0/gDtRzcdQzEGdxPxug43Mi+MD0wAm3sDjxXXI0Q7Ij/HnJ0
         +hazzQwI5arn/V7/YYQ3JD1z5k3U3HRhpoxLD2rWMWllXgi9eSERoxaq5tFloPhnkJ7Y
         noOTOtlOcJ9QpgZ9iY1jqDn6E3iApEsXJn7ESE0ID14IWy7W2Lef4yxYFVgHtdvDk8rW
         Z1vw==
X-Gm-Message-State: ACrzQf118SmKvL2Zhx2zjajyT8OKJM410eNF66WfLnu7UHmKoqZLYym/
        QHq/a+DNd9pjLcjhoOJEZtVA6LSOpy3KurRzQuVB/GqUTZafH07hAg+iyZ2YqNxGWNACqbqZJEi
        uQq66jrx4eeXoJmkN
X-Received: by 2002:a05:620a:2052:b0:6f4:bf55:d1e1 with SMTP id d18-20020a05620a205200b006f4bf55d1e1mr6591372qka.378.1667155434646;
        Sun, 30 Oct 2022 11:43:54 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM4ZtjgSvh3MKmXQEei2IY0LxpBIZeRpVqLEkX1BGa5Gk8Udt5FgooWFawG0eYDtLckR/73qtA==
X-Received: by 2002:a05:620a:2052:b0:6f4:bf55:d1e1 with SMTP id d18-20020a05620a205200b006f4bf55d1e1mr6591364qka.378.1667155434403;
        Sun, 30 Oct 2022 11:43:54 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id bs11-20020ac86f0b000000b0039cc82a319asm2545425qtb.76.2022.10.30.11.43.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 30 Oct 2022 11:43:53 -0700 (PDT)
Date:   Sun, 30 Oct 2022 14:43:51 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>,
        Mike Kravetz <mike.kravetz@oracle.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>,
        Linux-MM <linux-mm@kvack.org>,
        kernel list <linux-kernel@vger.kernel.org>,
        Naoya Horiguchi <naoya.horiguchi@linux.dev>,
        David Hildenbrand <david@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Mina Almasry <almasrymina@google.com>,
        Rik van Riel <riel@surriel.com>,
        Vlastimil Babka <vbabka@suse.cz>,
        Matthew Wilcox <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wei Chen <harperchen1110@gmail.com>, stable@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH v2] hugetlb: don't delete vma_lock in hugetlb
 MADV_DONTNEED processing
Message-ID: <Y17F50ktT9fZw4do@x1n>
References: <20221023025047.470646-1-mike.kravetz@oracle.com>
 <Y1mpwKpwsiN6u6r7@x1n>
 <Y1nImUVseAOpXwPv@monkey>
 <Y1nbErXmHkyrzt8F@x1n>
 <Y1vz7VvQ5zg5KTxk@monkey>
 <Y1v/x5RRpRjU4b/W@x1n>
 <Y1xGzR/nHQTJxTCj@monkey>
 <Y1xjyLWNCK7p0XSv@x1n>
 <Y13CO8iIGfDnV24u@monkey>
 <7048D2B5-5FA5-4F72-8FDC-A02411CFD71D@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <7048D2B5-5FA5-4F72-8FDC-A02411CFD71D@gmail.com>
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 29, 2022 at 05:54:44PM -0700, Nadav Amit wrote:
> On Oct 29, 2022, at 5:15 PM, Mike Kravetz <mike.kravetz@oracle.com> wrote:
> 
> > zap_page_range is a bit confusing.  It appears that the passed range can
> > span multiple vmas.  Otherwise, there would be no do while loop.  Yet, there
> > is only one mmu_notifier_range_init call specifying the passed vma.
> > 
> > It appears all callers pass a range entirely within a single vma.
> > 
> > The modifications above would work for a range within a single vma.  However,
> > things would be more complicated if the range can indeed span multiple vmas.
> > For multiple vmas, we would need to check the first and last vmas for
> > pmd sharing.
> > 
> > Anyone know more about this seeming confusing behavior?  Perhaps, range
> > spanning multiple vmas was left over earlier code?
> 
> I don’t have personal knowledge, but I noticed that it does not make much
> sense, at least for MADV_DONTNEED. I tried to batch the TLB flushes across
> VMAs for madvise’s. [1]

The loop comes from 7e027b14d53e ("vm: simplify unmap_vmas() calling
convention", 2012-05-06), where zap_page_range() was used to replace a call
to unmap_vmas() because the patch wanted to eliminate the zap details
pointer for unmap_vmas(), which makes sense.

I didn't check the old code, but from what I can tell (and also as Mike
pointed out) I don't think zap_page_range() in the lastest code base is
ever used on multi-vma at all.  Otherwise the mmu notifier is already
broken - see mmu_notifier_range_init() where the vma pointer is also part
of the notification.

Perhaps we should just remove the loop?

> 
> Need to get to it sometime.
> 
> [1] https://lore.kernel.org/lkml/20210926161259.238054-7-namit@vmware.com/
> 

-- 
Peter Xu

