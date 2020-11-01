Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E8852A20A1
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 18:48:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgKARsp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 12:48:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727086AbgKARsp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 12:48:45 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20B39C0617A6;
        Sun,  1 Nov 2020 09:48:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=rHIUsRqrjkVztjUWi8Epx0pSoF2undlIvOpK0aQ9PcQ=; b=cNDELfK3gq95oiPePm7nSbAv1k
        Wl+Qr9avH+rXbIJ6p+Z90+8Sqt2LMeZvzbeY6quEy0MuFis5MPhbEA62qTxDtNsHe9xNUu1Ikf3H2
        PLOt9PVea67kW3WtqgijmQglDRMK0YTkZLgKArDIbF+NFj2pU/bwFp/84ztd0bpZzzwkWCVacNog7
        wdph9yQrkAN9rN7kH3WUBQFzC8L+z4nl2Yh1Mg4bDFAPzhZCTx1yVgZStEiu3ZKZqRiwmewC8P2Od
        jm/UXaKjLy5qPH02aVOrq0s8J4jHoRENlNF9bW8YfEGTvDe9b6iACuO8vwGI4olc9dx7YK1/RqkvK
        MrwzVaqA==;
Received: from [2601:1c0:6280:3f0::371c]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kZHT2-0002jC-Io; Sun, 01 Nov 2020 17:48:36 +0000
Subject: Re: [PATCH] compiler.h: Move barrier() back into compiler-*.h
To:     Matthew Wilcox <willy@infradead.org>,
        Arvind Sankar <nivedita@alum.mit.edu>
Cc:     kernel test robot <lkp@intel.com>, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kbuild-all@lists.01.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org
References: <202010312104.Dk9VQJYb-lkp@intel.com>
 <20201101173105.1723648-1-nivedita@alum.mit.edu>
 <20201101173835.GC27442@casper.infradead.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <163c2869-8ea5-54a4-e146-951619294379@infradead.org>
Date:   Sun, 1 Nov 2020 09:48:30 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201101173835.GC27442@casper.infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/1/20 9:38 AM, Matthew Wilcox wrote:
> On Sun, Nov 01, 2020 at 12:31:05PM -0500, Arvind Sankar wrote:
>> Commit
>>   b9de06783f01 ("compiler.h: fix barrier_data() on clang")
>> moved the definition of barrier() into compiler.h.
> 
> That's not a real commit ID.  It only exists in linux-next and
> will expire after a few weeks.
> 
> The right way to fix a patch in Andrew's tree is to send an email
> asking him to apply it as a -fix patch.  As part of Andrew's submission
> process, he folds all the -fix patches into the parent patch and it
> shows up pristine in Linus' tree.
> 
>> This causes build failures at least on alpha, because there are files
>> that rely on barrier() being defined via the implicit include of
>> compiler_types.h.
> 
> That seems like a bug that should be fixed rather than reverting this
> part of the patch?
> 

maybe: ?

https://lore.kernel.org/lkml/20201101030159.15858-1-rdunlap@infradead.org/

-- 
~Randy

