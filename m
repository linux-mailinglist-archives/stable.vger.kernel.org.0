Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 409F532B25D
	for <lists+stable@lfdr.de>; Wed,  3 Mar 2021 04:48:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343629AbhCCAxU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Mar 2021 19:53:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350317AbhCBSnr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Mar 2021 13:43:47 -0500
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74A47C06178C
        for <stable@vger.kernel.org>; Tue,  2 Mar 2021 10:43:01 -0800 (PST)
Received: by mail-pj1-x102e.google.com with SMTP id i14so2508889pjz.4
        for <stable@vger.kernel.org>; Tue, 02 Mar 2021 10:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=qaYU5ZzeE5zbqFCyLzv3wI18v5WxmwBBNA3YgsmpLlI=;
        b=A4cMHEy/WPGNNldlmPvdCyL8qJBDPbBr4PqhrT29EGjlHnQPdNJoxViUDQYSEUlyNI
         4LODiReAE/+oRoAqmQiwxdRUXb50K8HTQraT7ADeca8U6+fSa8iixrPCz2bHmlu6jLfT
         itjBQGSySkANugOeStoNnEJmRSO9wTNF99x7Q=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=qaYU5ZzeE5zbqFCyLzv3wI18v5WxmwBBNA3YgsmpLlI=;
        b=QdXY4yEsS/r4hUDcwnLmUQWfiLmI18I8sx3PeHAZo/nvTbJU3mIgYGZ7I5bl31H02a
         9JLjtgoyYHsGhez15z4HY7E7px8v6YcrSEPJEwNJygdvWE+3rGTNARUW6kD2LPtstdQr
         qFm8Bs87ppsDlF6WggzIW1NYDiZGB9JkiXDgu1GCVIDSOnn7lx1iilLIju+lWYrTeDQz
         ClExeUXiMt/Ltknjx0gfE3shXZfRwlfN64/TQaorjSCyjhmT5b5bLRpDOGzXWYHxcg1K
         3Epj2afFQFY9o2ZOIFnSriFSYbyKuRXAIJLDdZ1Lxk5TPeTi78Pwazc6ewxMYygItChj
         AuVA==
X-Gm-Message-State: AOAM531r9KMhppPTGeA6pHxHGOusfEcbDPDYjE5ej+QXbDcgUfNq3Ztx
        dkre2mO2Y08LUDoOaWKJPgSy5A==
X-Google-Smtp-Source: ABdhPJw9bvtXVLykthKPXQgOFU9KJFF+Xd6wYvOLOi4V32IeSZRg53OPDLXt09vUxXzmq80DTsJluw==
X-Received: by 2002:a17:902:f688:b029:e4:bde1:1730 with SMTP id l8-20020a170902f688b02900e4bde11730mr4815345plg.41.1614710580860;
        Tue, 02 Mar 2021 10:43:00 -0800 (PST)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id a136sm21760323pfa.66.2021.03.02.10.42.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Mar 2021 10:43:00 -0800 (PST)
Date:   Tue, 2 Mar 2021 10:42:57 -0800
From:   Kees Cook <keescook@chromium.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH AUTOSEL 5.11 31/52] x86, build: use objtool mcount
Message-ID: <202103021042.CBF1600@keescook>
References: <20210302115534.61800-1-sashal@kernel.org>
 <20210302115534.61800-31-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302115534.61800-31-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 06:55:12AM -0500, Sasha Levin wrote:
> From: Sami Tolvanen <samitolvanen@google.com>
> 
> [ Upstream commit 6dafca97803309c3cb5148d449bfa711e41ddef2 ]
> 
> Select HAVE_OBJTOOL_MCOUNT if STACK_VALIDATION is selected to use
> objtool to generate __mcount_loc sections for dynamic ftrace with
> Clang and gcc <5 (later versions of gcc use -mrecord-mcount).
> 
> Signed-off-by: Sami Tolvanen <samitolvanen@google.com>
> Reviewed-by: Kees Cook <keescook@chromium.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

This one doesn't make sense without all the other objtool changes for
it. Please drop this from autosel.

-Kees

> ---
>  arch/x86/Kconfig | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
> index 21f851179ff0..300a9b5296fe 100644
> --- a/arch/x86/Kconfig
> +++ b/arch/x86/Kconfig
> @@ -168,6 +168,7 @@ config X86
>  	select HAVE_CONTEXT_TRACKING		if X86_64
>  	select HAVE_CONTEXT_TRACKING_OFFSTACK	if HAVE_CONTEXT_TRACKING
>  	select HAVE_C_RECORDMCOUNT
> +	select HAVE_OBJTOOL_MCOUNT		if STACK_VALIDATION
>  	select HAVE_DEBUG_KMEMLEAK
>  	select HAVE_DMA_CONTIGUOUS
>  	select HAVE_DYNAMIC_FTRACE
> -- 
> 2.30.1
> 

-- 
Kees Cook
