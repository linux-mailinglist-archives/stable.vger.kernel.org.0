Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB5442A212B
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 20:52:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726845AbgKATwY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 14:52:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726790AbgKATwX (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 14:52:23 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF019C0617A6;
        Sun,  1 Nov 2020 11:52:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=UpbRQYzHYbL4xPaGYfXrPvw9eVridnN8jRYW8ThbdIo=; b=iBlhfTPNSBb2lYpYV5ISwdzqW/
        djQhm1PUD8QQ9sWwL/ZLKgFsQePX2OxgcI2x5DJDGEpU0UI7qloLDI49qFa2oAPwrESUdGQyiX/5t
        pX2YvQ7Z0j0RXG0AcVHZb/zGZmJV7R5To/jEjzFdBu4VV0YicrBDtYw3PXucP9SrdvpzEn6Zq5+Sa
        uTRUULhN67h6SbUfPRnenckyZAtaypoMlxBcSBtyLHCfbf/nr/JBXqqnK9VQFg2cnPMi+KPno0s7s
        DMKjssYTLIS+mTO6LUg7zMRV0MLiPmicoFHVc3PnLoaNluYnA9vtsismTb/RU8+MetBgd4th+q9bU
        lNBb9oqw==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kZJOi-0007i7-0L; Sun, 01 Nov 2020 19:52:16 +0000
Date:   Sun, 1 Nov 2020 19:52:15 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     kernel test robot <lkp@intel.com>, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kbuild-all@lists.01.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
Subject: Re: [PATCH] compiler.h: Move barrier() back into compiler-*.h
Message-ID: <20201101195215.GE27442@casper.infradead.org>
References: <202010312104.Dk9VQJYb-lkp@intel.com>
 <20201101173105.1723648-1-nivedita@alum.mit.edu>
 <20201101173835.GC27442@casper.infradead.org>
 <20201101195110.GA1751707@rani.riverdale.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201101195110.GA1751707@rani.riverdale.lan>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 01, 2020 at 02:51:10PM -0500, Arvind Sankar wrote:
> Ok. So I still send it as a separate patch and he does the folding, or
> should I send a revised patch that replaces the original one?

I think Randy's patch should be merged instead of this patch.
