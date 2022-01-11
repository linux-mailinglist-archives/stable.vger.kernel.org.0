Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6C8948B5F7
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 19:44:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346333AbiAKSo1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jan 2022 13:44:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346214AbiAKSo0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jan 2022 13:44:26 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96D31C061751;
        Tue, 11 Jan 2022 10:44:25 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id y18so6093172iln.3;
        Tue, 11 Jan 2022 10:44:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:message-id:subject:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=tFQdNQtIewtBRmToXsBxMfMj4p5l4AEslzFqKCLLZoo=;
        b=GdEjlM8FyzZ4u7cfUSmXq9/e8NZxUgid+VOT/R6BIHZ5aD7SFRsoNjIpkQaFGbcG8j
         19fy/aHOQ0207AUuCGfdVh9WnvoV15WvgHQ5kbLmY1GF6ohyIxKSVKYoNrw9yMkYZQvK
         B5Rr8jAOLYajqR8P6y6mDbDT7FtPCd7Klqo52FNrNvOodGHJ89nJnEdPZdFN2iK7Bgyd
         JwvZQ907iFM0gO9kh//euTlVC5zoELSyW+vRET2zt/VXeD8JlB/R/3almX44YnAxV4mU
         psuy8QJjYKcfPyBrx5wEYe93qU0nBZLt5PmidG3ScCW2LZ/+CYpTHfKsssHS12ZgoQK9
         B9GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:message-id:subject:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=tFQdNQtIewtBRmToXsBxMfMj4p5l4AEslzFqKCLLZoo=;
        b=JJlFppgoahnR3ZR5sOi//xPmmd56r0otXlJTdcU/h/dWFRVmTzXPyMc11ZKn39uxAJ
         B2KhFMk3mlzLtFVgH5hoyVhudj8KDDQRuWCDOA021GxzSUudQPEx6HkbXkQveNluLNYS
         jGm9ymwvQBRs7OcejcXHBzzSfHZyfHLchsWKd7lHd+D+6modo4owPI2ct3SpY2yKPPFg
         pqOlkD7flUvpUgrNxEwRQprQLNbnBU3/zA5ZR9aDyXvPh9V0OdEM92ofZyUgTcav0+vZ
         MGM5gx/1td38BBKZeBNycPxlK+Wy6ETth4r43VxMk2abuScxEWJxeTO4L5D1pPKgK365
         7qIA==
X-Gm-Message-State: AOAM533A0ckEMZn40ZD3J7LlmiXvj2Nxy17lvxVQ5jqQWzIfXYD6a+JA
        oaEZr5YVs5sVXUHSmVxLO+4=
X-Google-Smtp-Source: ABdhPJycIt+kcebpXTE6Q4i4yJqb8HjKebhXN8no1tlBBpnhYCUis/oMlIg+OSiYmNDyhc95tlcGyw==
X-Received: by 2002:a05:6e02:1aad:: with SMTP id l13mr3290017ilv.4.1641926664781;
        Tue, 11 Jan 2022 10:44:24 -0800 (PST)
Received: from lat7420.internal (c-24-9-64-241.hsd1.co.comcast.net. [24.9.64.241])
        by smtp.googlemail.com with ESMTPSA id d11sm6381489ilv.6.2022.01.11.10.44.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Jan 2022 10:44:24 -0800 (PST)
From:   Khalid Aziz <gonehacking@gmail.com>
X-Google-Original-From: Khalid Aziz <khalid.aziz@oracle.com>
Message-ID: <fa014bc2ddc85363dd6b8d34e9db1301817cb33d.camel@oracle.com>
Subject: Re: [PATCH] mm/pgtable: define pte_index so that preprocessor could
 recognize it
To:     Mike Rapoport <rppt@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Christian Dietrich <stettberger@dokucode.de>,
        Mike Rapoport <rppt@linux.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Date:   Tue, 11 Jan 2022 11:44:23 -0700
In-Reply-To: <20220111145457.20748-1-rppt@kernel.org>
References: <20220111145457.20748-1-rppt@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 2022-01-11 at 16:54 +0200, Mike Rapoport wrote:
> From: Mike Rapoport <rppt@linux.ibm.com>
> 
> Since commit 974b9b2c68f3 ("mm: consolidate pte_index() and
> pte_offset_*()
> definitions") pte_index is a static inline and there is no define for
> it
> that can be recognized by the preprocessor. As the result,
> vm_insert_pages() uses slower loop over vm_insert_page() instead of
> insert_pages() that amortizes the cost of spinlock operations when
> inserting multiple pages.
> 
> Fixes: 974b9b2c68f3 ("mm: consolidate pte_index() and pte_offset_*()
> definitions")
> Reported-by: Christian Dietrich <stettberger@dokucode.de>
> Signed-off-by: Mike Rapoport <rppt@linux.ibm.com>
> Cc: stable@vger.kernel.org
> ---
>  include/linux/pgtable.h | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index e24d2c992b11..d468efcf48f4 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -62,6 +62,7 @@ static inline unsigned long pte_index(unsigned long
> address)
>  {
>         return (address >> PAGE_SHIFT) & (PTRS_PER_PTE - 1);
>  }
> +#define pte_index pte_index
>  
>  #ifndef pmd_index
>  static inline unsigned long pmd_index(unsigned long address)
> 
> base-commit: 2585cf9dfaaddf00b069673f27bb3f8530e2039c

This is a good fix with positive performance impact.

Reviewed-by: Khalid Aziz <khalid.aziz@oracle.com>


