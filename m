Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1772D2A20A5
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 18:54:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbgKARyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 12:54:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgKARyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 12:54:06 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36CB6C0617A6;
        Sun,  1 Nov 2020 09:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=FIAU3n1W5EdEaRrZ91VA7lL8l8ICV3trjFrbNqwadfA=; b=oD5LPFSeQVe62lM1vZ1CGZrq+4
        p/iN06bo6BrzJIgkaMeH3b2plfh3sKKhwW7Uhxoa1QTBuP8n37EA4koakhY1+OYd9Fyu5NuWdOgdJ
        hFeDBySVPOJLiFwQ8lrj55aR4SkqpyXuX1pz5oURp0mNZ/olwXUFNlCpgZf1IUGJ/5AlhXCHuML8T
        hyMdtcbXVnMfuqOsMSLmVzq3ZwhyYXl2lCAbVSx5O4p45QIOBDXb3Q25a0VaJSdXIYqe6DrPnrHYS
        CIqaWYCBj5OgGNf2HZcNwCtCQLFc5fVSEy7J65SxFlTtfQiETflL2zxFPLg1ZQe4CjOTUs481NPNC
        +gmZIWHg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kZHYF-0000eW-TZ; Sun, 01 Nov 2020 17:54:00 +0000
Date:   Sun, 1 Nov 2020 17:53:59 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     Arvind Sankar <nivedita@alum.mit.edu>,
        kernel test robot <lkp@intel.com>,
        linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kbuild-all@lists.01.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] compiler.h: Move barrier() back into compiler-*.h
Message-ID: <20201101175359.GD27442@casper.infradead.org>
References: <202010312104.Dk9VQJYb-lkp@intel.com>
 <20201101173105.1723648-1-nivedita@alum.mit.edu>
 <20201101173835.GC27442@casper.infradead.org>
 <163c2869-8ea5-54a4-e146-951619294379@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <163c2869-8ea5-54a4-e146-951619294379@infradead.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 01, 2020 at 09:48:30AM -0800, Randy Dunlap wrote:
> maybe: ?
> 
> https://lore.kernel.org/lkml/20201101030159.15858-1-rdunlap@infradead.org/

Yes
