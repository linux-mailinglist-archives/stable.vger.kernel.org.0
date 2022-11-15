Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 85613629E7E
	for <lists+stable@lfdr.de>; Tue, 15 Nov 2022 17:09:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiKOQJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Nov 2022 11:09:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230020AbiKOQJL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Nov 2022 11:09:11 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D9AB14D2C
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 08:08:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1668528496;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=DqBPgUe4Sm3rQRHQ4BZn8ze3h0OIxC8sEcLBb0IfLqw=;
        b=U5qQ3fGXXXLImqIQpU5HLvI1WJ0pFdgroAZ/1DEi0ZHmL4hj+PjimUO1Ly3M6vcn2J946t
        4R9JpLa0+5WLn9TDDZSsX6v9nZRht3G0sUFcx3v36+ljusW1Cg9G9SVdjRE4j54pwxcKa8
        8G90RSEKD2xgMP5yz6dLECFhJCuwngo=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-275-DgWPeeWpOBaoJKUziBe8ZQ-1; Tue, 15 Nov 2022 11:08:15 -0500
X-MC-Unique: DgWPeeWpOBaoJKUziBe8ZQ-1
Received: by mail-qv1-f71.google.com with SMTP id q16-20020a0ce210000000b004ba8976d3aaso10871793qvl.5
        for <stable@vger.kernel.org>; Tue, 15 Nov 2022 08:08:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DqBPgUe4Sm3rQRHQ4BZn8ze3h0OIxC8sEcLBb0IfLqw=;
        b=mUDBOLf9AqgLPdc6E54+bckoU5yKjAjTYzd1DAL7vWT2e2iRuWD2nUOWTigiRqxFND
         riS8/yiOcekky2zHumaj6l0gWK31bIHcaiIAPgm7aKsuGphi5+WoT1iPkVC3cBM6kAlB
         Izq4AG0rU9CdG6ATLuDH5TFBaaa7ZTsDSOXBI0dvsv7E2Lj5dl0ty0ZUfqvAtG0ycUxQ
         zZuQ00GUWyhl1kFQ0Vw+ydqcVjdGnIa0rSAp1bNlTNAzKFuTdOQsdCWShkfr23yoBK2b
         pC2HfDZ59dWpmOdNucrBU5dD5Ejc6bPRvq/Ul7NeV6caekiMq1i/ueYXefvEL6UttZum
         vyGw==
X-Gm-Message-State: ANoB5plrC/arTDTPfSr9J5ajoBkl6gW4UDA/lE0xsSebElIFJcwu5JAf
        MaFJSkB9do2KLBEa/FlNNr7YPTbam1HiFeNlcYeS0aq2vDUYTd7+mGSMJWkpADxrDavBl9IWjSD
        flNTgOcwPs1K4LB2i
X-Received: by 2002:ad4:444b:0:b0:4bc:22fe:b07c with SMTP id l11-20020ad4444b000000b004bc22feb07cmr17166160qvt.7.1668528494702;
        Tue, 15 Nov 2022 08:08:14 -0800 (PST)
X-Google-Smtp-Source: AA0mqf70mQJUfQ19xOCkCRFYx0GkmNRSEJPLG9Rt+n1xw5LBbvpYTpsOBchqj+H6ysPG6urM3V1fvw==
X-Received: by 2002:ad4:444b:0:b0:4bc:22fe:b07c with SMTP id l11-20020ad4444b000000b004bc22feb07cmr17166134qvt.7.1668528494412;
        Tue, 15 Nov 2022 08:08:14 -0800 (PST)
Received: from x1n (bras-base-aurron9127w-grc-46-70-31-27-79.dsl.bell.ca. [70.31.27.79])
        by smtp.gmail.com with ESMTPSA id s11-20020a05620a29cb00b006ec62032d3dsm8580912qkp.30.2022.11.15.08.08.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 08:08:13 -0800 (PST)
Date:   Tue, 15 Nov 2022 11:08:12 -0500
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Andrea Arcangeli <aarcange@redhat.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Ives van Hoorne <ives@codesandbox.io>,
        Nadav Amit <nadav.amit@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate: Fix read-only page got writable when
 recover pte
Message-ID: <Y3O5bCXSbvKJrjRL@x1n>
References: <20221110203132.1498183-1-peterx@redhat.com>
 <20221110203132.1498183-2-peterx@redhat.com>
 <9af36be3-313b-e39c-85bb-bf30011bccb8@redhat.com>
 <Y3KgYeMTdTM0FN5W@x1n>
 <ec8b3c86-d3b2-f898-7297-c20a58ae2ac1@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ec8b3c86-d3b2-f898-7297-c20a58ae2ac1@redhat.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 15, 2022 at 10:13:24AM +0100, David Hildenbrand wrote:
> > > 
> > > Any particular reason why not to simply glue this to pte_swp_uffd_wp(),
> > > because only that needs special care:
> > > 
> > > if (pte_swp_uffd_wp(*pvmw.pte)) {
> > > 	pte = pte_wrprotect(pte);
> > > 	pte = pte_mkuffd_wp(pte);
> > > }
> > > 
> > > 
> > > And that would match what actually should have been done in commit
> > > f45ec5ff16a7 -- only special-case uffd-wp.
> > > 
> > > Note that I think there are cases where we have a PTE that was !writable,
> > > but after migration we can map it writable.
> > 
> > The thing is recovering the pte into its original form is the safest
> > approach to me, so I think we need justification on why it's always safe to
> > set the write bit.
> > 
> > Or do you perhaps have solid clue and think it's always safe
> The problem I am having with this broader change, is that this changes
> something independent of your original patch/problem.
> 
> If we identify this to be an actual problem, it should most probably be
> separate fix + backport.
> 
> 
> My understanding is that vma->vm_page_prot always tells you what the default
> PTE protection in a mapping is.
> 
> If the mapping is private, it is never writable (due to COW). Similarly, if
> the shared file mapping needs writenotify, it is never writable.

Right.

> 
> 
> I consider UFFD-wp a special case: while the default VMA protection might
> state that it is writable, you actually want individual PTEs to be
> write-protected and have to manually remove the protection.
> 
> softdirty tracking is another special case: however, softdirty tracking is
> enabled for the whole VMA. For remove_migration_pte() that should be fine (I
> guess) because writenotify is active when the VMA needs to track softdirty
> bits, and consequently vma->vm_page_prot has the proper default permissions.
> 
> 
> I wonder if the following (valid), for example is possible:
> 
> 
> 1) clear_refs() clears VM_SOFTDIRTY and pte_wrprotect() the pte.
> -> writenotify is active and vma->vm_page_prot updated accordingly
> 
> VM_SOFTDIRTY is reset due to VMA merging and vma->vm_page_prot is updated
> accordingly. See mmap_region() where we set VM_SOFTDIRTY.
> 
> If you now migrate the (still write-protected in the PTE) page, it was not
> writable, but it can be writable on the destination.

I didn't even notice merging could work with soft-dirty enabled, that's
interesting to know.

Yes I think it's possible and I agree it's safe, as VM_SOFTDIRTY is set for
the merged vma so afaiu the write bit is safe to set.  We get a bunch of
false positives but that's how soft-dirty works.

I think the whole problem is easier if we see this at a higher level.
You're discussing this from vma pov and it's fair to do so, at least I
agree with what you mentioned so far and I can't see anything outside
uffd-wp that can be affected.  However, it is also true when you noticed we
already have quite a few paragraphs trying to discuss the safety for this
and that, that's the part where I think we need justification and it's not
that "natural".

For "natural", I meant fundamentally we're talking about page migrations
here.  The natural way (at least to me) for page migration to happen as a
fundamental rule is that, we leverag the migration pte to make sure the pte
being stable so we can do the migration work, then we "recover" the pte to
present either by a full recovery or just (hopefully) only replace the pfn,
keeping all the rest untouched.

One thing to prove that is we have two migration entries not one (I'm
temporarily put the exclusive read one aside since that's solving different
problems): MIGRATION_READ and MIGRATION_WRITE.  If we only rely on vma
flags logically we don't need MIGRATION_READ and MIGRATION_WRITE, we only
need MIGRATION generic swap pte then we recover the write bit from vma
flags and other things (like uffd-wp, currently we have the bit set in swap
pte besides the swap entry type).

So maybe one day we can use two migration types rather than three
(MIGRATION and MIGRATION_EXCLUSIVE)?  I can't tell, but hopefully that
shows what I meant, that we need further justification to grant write bit
only base on vma, rather than recovering write bit based on migration entry
type.

> 
> > 
> > > 
> > > BTW, does unuse_pte() need similar care?
> > > 
> > > new_pte = pte_mkold(mk_pte(page, vma->vm_page_prot));
> > > if (pte_swp_uffd_wp(*pte))
> > > 	new_pte = pte_mkuffd_wp(new_pte);
> > > set_pte_at(vma->vm_mm, addr, pte, new_pte);
> > 
> > I think unuse path is fine because unuse only applies to private mappings,
> > so we should always have the W bit removed there within mk_pte().
> 
> You're right, however, shmem swapping confuses me. Maybe that does not apply
> here.

Yeah these are confusing.  Actually I think the unuse path should apply to
private mappings on shmem when the page was CoWed already and then got
swapped out, but again as long as it's private mapping I think we don't
have write bit anyway in retval of mk_pte() even if it's shmem.

-- 
Peter Xu

