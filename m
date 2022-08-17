Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00246597675
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 21:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236908AbiHQT1j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 15:27:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiHQT1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 15:27:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D01181B11
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 12:27:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1660764456;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dmDD/m9rVXOHRexADGf5nUOz3ccETHTRAhO5DzNVEqY=;
        b=Vo6lxKbULmO4EZRaY9c+k593rH5sBqkgmKWt3KWqHdRPc9QTx+l6vqNt2SE23NheogGZCn
        cKSZ3AvwVrK0GPj6ww8WMqhWgGK+IaJUOsH/y/0TltbRs3rOq/EVTbiQosIRdiik9KVgAY
        27RKhKFNR/T94D/tJm4TydSw6xsAsMA=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-574-cLVN68IaP7OhWzPanncOig-1; Wed, 17 Aug 2022 15:27:35 -0400
X-MC-Unique: cLVN68IaP7OhWzPanncOig-1
Received: by mail-qt1-f200.google.com with SMTP id e30-20020ac8011e000000b00342f61e67aeso11079025qtg.3
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 12:27:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc;
        bh=dmDD/m9rVXOHRexADGf5nUOz3ccETHTRAhO5DzNVEqY=;
        b=0bFhuq13IpL21cEJBSFP96dnvPHfEL3TWaH4esfe8Phu+Xh0tEkkOdpm7lbjVygbqj
         8L7Yvtax0dKvw8pUXW04Mu+AJkdiEs7xpRV6KPMXAwcfHJ9+AvVnaUUIB7kiCYLbpi5J
         umL6FeNXX7MBMdfbu/D2Uaz61Iaph+QbhyXEaINggCF9CxN7fcuhIkU6AV91eROTnWpM
         B+3ZvSYhRP9f2tPJJ2bPDB9Y/zRhdgXdeFfhRaR/fZM69yTiPu30PX4RMby2IxNL8d8U
         BjgcdE/t11j4kWVHIGAGIJh5lgAT+zI81FOdjMtJnv/A9zKUS4s5Y50sLfvtCzRbGVBx
         sfBg==
X-Gm-Message-State: ACgBeo1mS45J2ro5cVzFX72F+IqimrGKqmzZ/YjPIKd3FlUs7htg86bX
        PAxb1PwvCwmbfgN+XyLxn2CgY3ZmEkYXXKsK1xViKroNtT7kbSp/I3JB/HwwD5JJlxdjxxZEn95
        ESgflRFfWfH1oNuuK
X-Received: by 2002:a05:6214:b6c:b0:476:8321:db81 with SMTP id ey12-20020a0562140b6c00b004768321db81mr23492932qvb.100.1660764455093;
        Wed, 17 Aug 2022 12:27:35 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6vqYZw2nSP0al2QOlYxSI+caDpn668z2wTq0sUdA1GVvZZhov4a4lSRj3rYF0hmqY4tBw2Ng==
X-Received: by 2002:a05:6214:b6c:b0:476:8321:db81 with SMTP id ey12-20020a0562140b6c00b004768321db81mr23492907qvb.100.1660764454794;
        Wed, 17 Aug 2022 12:27:34 -0700 (PDT)
Received: from xz-m1.local (bras-base-aurron9127w-grc-35-70-27-3-10.dsl.bell.ca. [70.27.3.10])
        by smtp.gmail.com with ESMTPSA id bj38-20020a05620a192600b006bb5cdd4031sm5016365qkb.40.2022.08.17.12.27.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Aug 2022 12:27:34 -0700 (PDT)
Date:   Wed, 17 Aug 2022 15:27:32 -0400
From:   Peter Xu <peterx@redhat.com>
To:     Nadav Amit <nadav.amit@gmail.com>
Cc:     "Huang, Ying" <ying.huang@intel.com>,
        Alistair Popple <apopple@nvidia.com>,
        huang ying <huang.ying.caritas@gmail.com>,
        Linux MM <linux-mm@kvack.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Sierra Guiza, Alejandro (Alex)" <alex.sierra@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        John Hubbard <jhubbard@nvidia.com>,
        David Hildenbrand <david@redhat.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Matthew Wilcox <willy@infradead.org>,
        Karol Herbst <kherbst@redhat.com>,
        Lyude Paul <lyude@redhat.com>, Ben Skeggs <bskeggs@redhat.com>,
        Logan Gunthorpe <logang@deltatee.com>, paulus@ozlabs.org,
        linuxppc-dev@lists.ozlabs.org, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] mm/migrate_device.c: Copy pte dirty bit to page
Message-ID: <Yv1BJKb5he3dOHdC@xz-m1.local>
References: <6e77914685ede036c419fa65b6adc27f25a6c3e9.1660635033.git-series.apopple@nvidia.com>
 <CAC=cRTPGiXWjk=CYnCrhJnLx3mdkGDXZpvApo6yTbeW7+ZGajA@mail.gmail.com>
 <Yvv/eGfi3LW8WxPZ@xz-m1.local>
 <871qtfvdlw.fsf@nvdebian.thelocal>
 <YvxWUY9eafFJ27ef@xz-m1.local>
 <87o7wjtn2g.fsf@nvdebian.thelocal>
 <87tu6bbaq7.fsf@yhuang6-desk2.ccr.corp.intel.com>
 <1D2FB37E-831B-445E-ADDC-C1D3FF0425C1@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1D2FB37E-831B-445E-ADDC-C1D3FF0425C1@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 17, 2022 at 02:41:19AM -0700, Nadav Amit wrote:
> 4. Having multiple TLB flushing infrastructures makes all of these
> discussions very complicated and unmaintainable. I need to convince myself
> in every occasion (including this one) whether calls to
> flush_tlb_batched_pending() and tlb_flush_pending() are needed or not.
> 
> What I would like to have [3] is a single infrastructure that gets a
> “ticket” (generation when the batching started), the old PTE and the new PTE
> and checks whether a TLB flush is needed based on the arch behavior and the
> current TLB generation. If needed, it would update the “ticket” to the new
> generation. Andy wanted a ring for pending TLB flushes, but I think it is an
> overkill with more overhead and complexity than needed.
> 
> But the current situation in which every TLB flush is a basis for long
> discussions and prone to bugs is impossible.
> 
> I hope it helps. Let me know if you want me to revive the patch-set or other
> feedback.
> 
> [1] https://lore.kernel.org/all/20220711034615.482895-5-21cnbao@gmail.com/
> [2] https://lore.kernel.org/all/20220718120212.3180-13-namit@vmware.com/
> [3] https://lore.kernel.org/all/20210131001132.3368247-16-namit@vmware.com/

I need more reading on tlb code and also [3] which looks useful to me.
It's definitely sad to make tlb flushing so complicated.  It'll be great if
things can be sorted out someday.

In this specific case, the only way to do safe tlb batching in my mind is:

	pte_offset_map_lock();
	arch_enter_lazy_mmu_mode();
        // If any pending tlb, do it now
        if (mm_tlb_flush_pending())
		flush_tlb_range(vma, start, end);
        else
                flush_tlb_batched_pending();
        loop {
                ...
                pte = ptep_get_and_clear();
                ...
                if (pte_present())
                        unmapped++;
                ...
        }
	if (unmapped)
		flush_tlb_range(walk->vma, start, end);
	arch_leave_lazy_mmu_mode();
	pte_unmap_unlock();

I may miss something, but even if not it already doesn't look pretty.

Thanks,

-- 
Peter Xu

