Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77D406C95C0
	for <lists+stable@lfdr.de>; Sun, 26 Mar 2023 16:47:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231987AbjCZOrO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Mar 2023 10:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232020AbjCZOrN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Mar 2023 10:47:13 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05549468E
        for <stable@vger.kernel.org>; Sun, 26 Mar 2023 07:46:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1679841987;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=NCwOxvpkJi/AFwFKPQO+eqD2wLsuChYdcKGvoGw4Tsg=;
        b=Lg5t5cvTOKmuZ2hG0tMHvhn51sbYjW7adE2UzK+wf0mjSHiBK1ul87WnTra8Ig+B4bAgTe
        +Q9xM0OjFjqqPWDRNHDP9idVHf15+lBIJuklcDmvmuzZCyXIO1TSIZJIH4UusY6RzjJEVZ
        jYX5cQycnhDqy61yaCBSx8nLzmSXh0k=
Received: from mail-yb1-f199.google.com (mail-yb1-f199.google.com
 [209.85.219.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-14-ELwHKYbMNqubAVZWVCNj4Q-1; Sun, 26 Mar 2023 10:46:26 -0400
X-MC-Unique: ELwHKYbMNqubAVZWVCNj4Q-1
Received: by mail-yb1-f199.google.com with SMTP id 3f1490d57ef6-ae8fa653140so51631276.1
        for <stable@vger.kernel.org>; Sun, 26 Mar 2023 07:46:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679841985;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NCwOxvpkJi/AFwFKPQO+eqD2wLsuChYdcKGvoGw4Tsg=;
        b=cbKEiZwvc0kNkESGhaEm7D9Ab9+uA1Ifv1qrbt6J44KPaCX5mZ6K4tsJbcnaZ5rGSb
         48p7tb94CeR+QqegzFkGvEGhbPLMKru7ZlGk2VD5890o/kT/vRoUZC4wAKguPe6654tJ
         Gl0oQhY/p/+1s+4X+F8OMtyeS4sg/CmDLW9dPckhMB63iWBNiJQCLxebo5rEBjyJoMs2
         lvX//g+XTyDZmi2nR8AbucBtTMmJQ/CirVzOGO6uopx92n/ePnr3nR+bu/JOIq7L2JP2
         aXA8ez3GVZpmtKs453gK6+Vtp0i7J3GIHDE+uqQvaXj9fT+fO8qhULMUr3X/tMQPy5Ij
         3iXA==
X-Gm-Message-State: AAQBX9fLzLw0EUDDX13uRfdkykWULV7Xb4dOzSDI2xr+n7Ra4KOLw+0x
        2GuoP4TUkF4UYGWi40QEZrA/z+elpQncrFttqlG3rdoV6hgyXLFeCsZOYByq6OMJDJ1S6T8X2Fs
        Z3RNMsY7OBMRHL6BM
X-Received: by 2002:a25:aca5:0:b0:b74:4bff:53fa with SMTP id x37-20020a25aca5000000b00b744bff53famr7539674ybi.6.1679841985576;
        Sun, 26 Mar 2023 07:46:25 -0700 (PDT)
X-Google-Smtp-Source: AKy350YwUtNBIndgSxYzqwugmAmBRIBhZIM5sj8jN4/1PlF/IgGjICiMvRd09ICIR43QOI24xOaQ8A==
X-Received: by 2002:a25:aca5:0:b0:b74:4bff:53fa with SMTP id x37-20020a25aca5000000b00b744bff53famr7539662ybi.6.1679841985233;
        Sun, 26 Mar 2023 07:46:25 -0700 (PDT)
Received: from x1n (bras-base-aurron9127w-grc-40-70-52-229-124.dsl.bell.ca. [70.52.229.124])
        by smtp.gmail.com with ESMTPSA id v130-20020a252f88000000b00b7767ca7490sm1755262ybv.45.2023.03.26.07.46.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Mar 2023 07:46:24 -0700 (PDT)
Date:   Sun, 26 Mar 2023 10:46:22 -0400
From:   Peter Xu <peterx@redhat.com>
To:     David Hildenbrand <david@redhat.com>
Cc:     Mike Kravetz <mike.kravetz@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Nadav Amit <nadav.amit@gmail.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Muhammad Usama Anjum <usama.anjum@collabora.com>,
        linux-stable <stable@vger.kernel.org>
Subject: Re: [PATCH v3] mm/hugetlb: Fix uffd wr-protection for CoW
 optimization path
Message-ID: <ZCBavqZE2cyVOzaW@x1n>
References: <20230324142620.2344140-1-peterx@redhat.com>
 <20230324222707.GA3046@monkey>
 <8a06be33-1b44-b992-f80a-8764810ebf3f@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <8a06be33-1b44-b992-f80a-8764810ebf3f@redhat.com>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 24, 2023 at 11:36:53PM +0100, David Hildenbrand wrote:
> > > @@ -5487,6 +5487,17 @@ static vm_fault_t hugetlb_wp(struct mm_struct *mm, struct vm_area_struct *vma,
> > >   	unsigned long haddr = address & huge_page_mask(h);
> > >   	struct mmu_notifier_range range;
> > > +	/*
> > > +	 * Never handle CoW for uffd-wp protected pages.  It should be only
> > > +	 * handled when the uffd-wp protection is removed.
> > > +	 *
> > > +	 * Note that only the CoW optimization path (in hugetlb_no_page())
> > > +	 * can trigger this, because hugetlb_fault() will always resolve
> > > +	 * uffd-wp bit first.
> > > +	 */
> > > +	if (!unshare && huge_pte_uffd_wp(pte))
> > > +		return 0;
> > 
> > This looks correct.  However, since the previous version looked correct I must
> > ask.  Can we have unshare set and huge_pte_uffd_wp true?  If so, then it seems
> > we would need to possibly propogate that uffd_wp to the new pte as in v2

Good point, thanks for spotting!

> 
> We can. A reproducer would share an anon hugetlb page because parent and
> child. In the parent, we would uffd-wp that page. We could trigger unsharing
> by R/O-pinning that page.

Right.  This seems to be a separate bug..  It should be triggered in
totally different context and much harder due to rare use of RO pins,
meanwhile used with userfault-wp.

If both of you agree, I can prepare a separate patch for this bug, and I'll
better prepare a reproducer/selftest with it.

-- 
Peter Xu

