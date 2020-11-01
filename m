Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F05A2A2089
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 18:38:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727155AbgKARin (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 12:38:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727024AbgKARim (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 12:38:42 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AFF9C0617A6;
        Sun,  1 Nov 2020 09:38:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=XmCp6bSuR9tTVxgEFeisGEza8G1MS4j5+U46dEfFIBw=; b=dDb9DLvIr15G5snKku84SYDgWL
        fpqE8OUDzp5grbtLbZDIu3y9WELk7vE2e7GrM6w0J9oD6aU4KF1lwzokCmH1YyLCSHhTlFT1VPxic
        Whb5+xnf210VD4UbA6+pjKQqCQFVzbX3ggAV7+cwFMv/+TJrbojd1Qxa950d8oUU+0dng0X4v5dC5
        VK7bW45dTCRwzxXL8wd+8zMTaDKxNTXosNpBD7ouArYOVkxlxg6G2vAp5YIBsj0+WLvLCCYAPDRI3
        ifwjs+sFN5qLYXR7gE9KxJVrkmyvvjc3cf+49M9XYXjZpqSeVFSl5FagBVqVCMB5uRbPmW9lZaFQJ
        XZ/MO1hg==;
Received: from willy by casper.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kZHJL-0008G9-HQ; Sun, 01 Nov 2020 17:38:35 +0000
Date:   Sun, 1 Nov 2020 17:38:35 +0000
From:   Matthew Wilcox <willy@infradead.org>
To:     Arvind Sankar <nivedita@alum.mit.edu>
Cc:     kernel test robot <lkp@intel.com>, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kbuild-all@lists.01.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
Subject: Re: [PATCH] compiler.h: Move barrier() back into compiler-*.h
Message-ID: <20201101173835.GC27442@casper.infradead.org>
References: <202010312104.Dk9VQJYb-lkp@intel.com>
 <20201101173105.1723648-1-nivedita@alum.mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201101173105.1723648-1-nivedita@alum.mit.edu>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Nov 01, 2020 at 12:31:05PM -0500, Arvind Sankar wrote:
> Commit
>   b9de06783f01 ("compiler.h: fix barrier_data() on clang")
> moved the definition of barrier() into compiler.h.

That's not a real commit ID.  It only exists in linux-next and
will expire after a few weeks.

The right way to fix a patch in Andrew's tree is to send an email
asking him to apply it as a -fix patch.  As part of Andrew's submission
process, he folds all the -fix patches into the parent patch and it
shows up pristine in Linus' tree.

> This causes build failures at least on alpha, because there are files
> that rely on barrier() being defined via the implicit include of
> compiler_types.h.

That seems like a bug that should be fixed rather than reverting this
part of the patch?

