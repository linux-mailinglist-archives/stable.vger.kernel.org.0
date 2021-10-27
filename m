Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDC3A43D5F4
	for <lists+stable@lfdr.de>; Wed, 27 Oct 2021 23:40:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231462AbhJ0Vmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Oct 2021 17:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbhJ0Vma (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Oct 2021 17:42:30 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 90B96C061570;
        Wed, 27 Oct 2021 14:40:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=mj+64iVUFU770oqi2STnF0e0M2cIBSTKCrEACVMYR0Q=; b=danKNLwLstO6xW/jQipEHusI9v
        K5jANdbG4bqgWj5/hnetwQn4FPcjzGYhpRM5BuflIgJOw5iBXfKF3c+KUeUk6IEREAS+J2+hh0P/6
        PP5JV16GvTHfhbLqa9sFRthQzdCVxZaGEa6/eR/sC/h/SdNaVuIo0zrf87wW7rcauxTjnm895u6bW
        EbakBCT9ZP8MadkxT96NXYvrD1UhVC5hR1vUTu11Z+5ywyV2g85xM8cgK6WV2NLWLgZibxn+HO9nJ
        4A6+x9b8RwgIW2CJfLhmlrtUzT/ggfmGp+SzqUPDULYekHsQ8fRB/Yjo4tDJOw6+8UE6TOOlR4MM5
        DfA3459Q==;
Received: from willy by casper.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mfqbV-000Kzm-Eo; Wed, 27 Oct 2021 21:37:24 +0000
Date:   Wed, 27 Oct 2021 22:37:01 +0100
From:   Matthew Wilcox <willy@infradead.org>
To:     Yang Shi <shy828301@gmail.com>
Cc:     Hugh Dickins <hughd@google.com>, Hao Sun <sunhao.th@gmail.com>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Song Liu <songliubraving@fb.com>,
        Andrea Righi <andrea.righi@canonical.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux MM <linux-mm@kvack.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] mm: khugepaged: skip huge page collapse for special files
Message-ID: <YXnGfaw5fh8aBNnG@casper.infradead.org>
References: <20211027195221.3825-1-shy828301@gmail.com>
 <YXm7kHy8uTN1+RRc@casper.infradead.org>
 <CAHbLzkrV1SuqZ8750yD6ZDM9D9uc8svrJ_gARrESq0kMspg+uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHbLzkrV1SuqZ8750yD6ZDM9D9uc8svrJ_gARrESq0kMspg+uw@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 27, 2021 at 02:32:02PM -0700, Yang Shi wrote:
> > This doesn't make sense to me.  if vma->vm_file, we already returned,
> > so this is dead code.
> 
> Yes, Song mentioned the same thing. Fixed by an incremental patch.

I saw that after I sent this.  My email sometimes arrives slowly.
