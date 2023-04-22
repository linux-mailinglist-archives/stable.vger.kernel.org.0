Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 014E96EB600
	for <lists+stable@lfdr.de>; Sat, 22 Apr 2023 02:03:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232094AbjDVADD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Apr 2023 20:03:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbjDVADD (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Apr 2023 20:03:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27050210B;
        Fri, 21 Apr 2023 17:03:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
        Message-ID:Sender:Reply-To:Content-ID:Content-Description;
        bh=+0dfV1eYp/+nsnlca8imSwnEvVZPr6k/2shPoq7dM34=; b=Wil964yehIc5HstIQLofzUOEMb
        X28bUyCxE9QFQi4OhBIwvd0Yqul1/mB+ZaiOz93EXGeSVRHO6adfd/F4RBqTWR7WHhvkGRHjZMgd7
        61xwVjKVxIpbqWOejQOYikYZd7IKF6YHi5EtqoaiyxCkFenn1AGK44hUIs8vEBFeSwsIQPagttjRl
        /3fYumaohcGWwEOBmZS4uA3uS/x7CZjBrTqEYuFTl5slwdr+xMhiIP2Z3XoGzkWnV5A0bWC0lAs8H
        pTqVuLfmNbdD8SJQIAAJerKLr1aE1oeo2ey3x+70j+Orn0Ep8FlFP/ni0Fk1pA0TBN4fkqZnbAROF
        YDxBuCLw==;
Received: from [2601:1c2:980:9ec0::2764]
        by bombadil.infradead.org with esmtpsa (Exim 4.96 #2 (Red Hat Linux))
        id 1pq0iS-00C7L7-0t;
        Sat, 22 Apr 2023 00:03:00 +0000
Message-ID: <81229999-c4c1-61f0-1277-4b7a7c0a1d98@infradead.org>
Date:   Fri, 21 Apr 2023 17:02:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.9.0
Subject: Re: [PATCH] docs: futex: Fix kernel-doc references after code
 split-up preparation
Content-Language: en-US
To:     Salvatore Bonaccorso <carnil@debian.org>,
        stable <stable@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        =?UTF-8?Q?Andr=c3=a9_Almeida?= <andrealmeid@collabora.com>,
        linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
        Jonathan Corbet <corbet@lwn.net>
References: <20230421210531.1816665-1-carnil@debian.org>
From:   Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <20230421210531.1816665-1-carnil@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please see https://lore.kernel.org/all/20211012135549.14451-1-andrealmeid@collabora.com/

Don't know what has happened to it though.  :(


On 4/21/23 14:05, Salvatore Bonaccorso wrote:
> In upstream commit 77e52ae35463 ("futex: Move to kernel/futex/") the
> futex code from kernel/futex.c was moved into kernel/futex/core in
> preparation of the split-up of the implementation in various files.
> 
> Point kernel-doc references to the new files as otherwise the
> documentation shows errors on build:
> 
> [...]
> Error: Cannot open file ./kernel/futex.c
> Error: Cannot open file ./kernel/futex.c
> [...]
> WARNING: kernel-doc './scripts/kernel-doc -rst -enable-lineno -sphinx-version 3.4.3 -internal ./kernel/futex.c' failed with return code 2
> 
> There is no direct upstream commit for this change. It is made in
> analogy to commit bc67f1c454fb ("docs: futex: Fix kernel-doc
> references") applied as consequence of the restructuring of the futex
> code.
> 
> Fixes: 77e52ae35463 ("futex: Move to kernel/futex/")
> Signed-off-by: Salvatore Bonaccorso <carnil@debian.org>
> ---
>  Documentation/kernel-hacking/locking.rst                    | 2 +-
>  Documentation/translations/it_IT/kernel-hacking/locking.rst | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/kernel-hacking/locking.rst b/Documentation/kernel-hacking/locking.rst
> index 6ed806e6061b..a6d89efede79 100644
> --- a/Documentation/kernel-hacking/locking.rst
> +++ b/Documentation/kernel-hacking/locking.rst
> @@ -1358,7 +1358,7 @@ Mutex API reference
>  Futex API reference
>  ===================
>  
> -.. kernel-doc:: kernel/futex.c
> +.. kernel-doc:: kernel/futex/core.c
>     :internal:
>  
>  Further reading
> diff --git a/Documentation/translations/it_IT/kernel-hacking/locking.rst b/Documentation/translations/it_IT/kernel-hacking/locking.rst
> index bf1acd6204ef..192ab8e28125 100644
> --- a/Documentation/translations/it_IT/kernel-hacking/locking.rst
> +++ b/Documentation/translations/it_IT/kernel-hacking/locking.rst
> @@ -1400,7 +1400,7 @@ Riferimento per l'API dei Mutex
>  Riferimento per l'API dei Futex
>  ===============================
>  
> -.. kernel-doc:: kernel/futex.c
> +.. kernel-doc:: kernel/futex/core.c
>     :internal:
>  
>  Approfondimenti

-- 
~Randy
