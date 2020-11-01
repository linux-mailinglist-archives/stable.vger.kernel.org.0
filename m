Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B49832A2194
	for <lists+stable@lfdr.de>; Sun,  1 Nov 2020 21:40:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727004AbgKAUkk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Nov 2020 15:40:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726848AbgKAUkk (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Nov 2020 15:40:40 -0500
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F802C0617A6;
        Sun,  1 Nov 2020 12:40:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=Et5K4+QvGR3JhUa1dRvhlOlucT8riZ7B3HV1KexVIq0=; b=MWHF81qvj8GEnZmZfZKCoElmVj
        KyShdZpDxmITbNDu0mtUxegzHCRJfMf7mrT3C2O7evXVpFDKblP6+FVMrPE96eEwp3kMGkS6P+Wt0
        ZrqA9o3Rb8s1QNqx7eLRJUva2mSR8VA3gT5S4juaDNzJIW7ymWGDJxsSoXrBil73YfiWuIpPkKA+3
        zqpMc/Cag7ggKJsRBY27doIgbX5oEGhIbmDs3vGwZcZCaKHt0c8zGaEy9Vw/C2zNjD9V2OtoTqvj0
        MItZH5F0aJ2y+qfHweL5rEPIsPNl6iPqXq1Hjk4G4jD0PTYgYfCJdShUMrXg7nEgHUwshOFZYeo3w
        jRK13nPA==;
Received: from [2601:1c0:6280:3f0::60d5]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kZK9J-0004M0-VZ; Sun, 01 Nov 2020 20:40:27 +0000
Subject: Re: [PATCH] compiler.h: Move barrier() back into compiler-*.h
To:     Arvind Sankar <nivedita@alum.mit.edu>,
        Matthew Wilcox <willy@infradead.org>
Cc:     kernel test robot <lkp@intel.com>, linux-next@vger.kernel.org,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        kbuild-all@lists.01.org,
        Linux Memory Management List <linux-mm@kvack.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Masahiro Yamada <masahiroy@kernel.org>
References: <202010312104.Dk9VQJYb-lkp@intel.com>
 <20201101173105.1723648-1-nivedita@alum.mit.edu>
 <20201101173835.GC27442@casper.infradead.org>
 <20201101195110.GA1751707@rani.riverdale.lan>
 <20201101195215.GE27442@casper.infradead.org>
 <20201101195948.GA1760144@rani.riverdale.lan>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <eff5fa5f-2eec-81a9-c6d9-7ec45df61e80@infradead.org>
Date:   Sun, 1 Nov 2020 12:40:19 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201101195948.GA1760144@rani.riverdale.lan>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 11/1/20 11:59 AM, Arvind Sankar wrote:
> On Sun, Nov 01, 2020 at 07:52:15PM +0000, Matthew Wilcox wrote:
>> On Sun, Nov 01, 2020 at 02:51:10PM -0500, Arvind Sankar wrote:
>>> Ok. So I still send it as a separate patch and he does the folding, or
>>> should I send a revised patch that replaces the original one?
>>
>> I think Randy's patch should be merged instead of this patch.
> 
> Ok, if that one works then it's better I agree.
> 

Do I need to resend it to Andrew?


--
~Randy

