Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E551C3F9C6A
	for <lists+stable@lfdr.de>; Fri, 27 Aug 2021 18:29:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231936AbhH0Q3n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Aug 2021 12:29:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230363AbhH0Q3n (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Aug 2021 12:29:43 -0400
Received: from mail-qk1-x735.google.com (mail-qk1-x735.google.com [IPv6:2607:f8b0:4864:20::735])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216E0C0613CF
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 09:28:54 -0700 (PDT)
Received: by mail-qk1-x735.google.com with SMTP id b64so7918756qkg.0
        for <stable@vger.kernel.org>; Fri, 27 Aug 2021 09:28:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=HsecH+zskpsc+sAnBqxr5ZuZz+jO6o+sSCHY/MtxvCQ=;
        b=O1ffWDj7gAU7klyHfuCVwiedzSG5T6fkgdQCMhj0P1ar6RbFlyx71pvhEk1OKUDQGq
         /AQ/MfTpQwfDq/xNUNkLrzBbSZbOMJudxV2IYXIRHPsYsHK9M18TcS3EslzExK2Y2aUO
         ipvMFYA2RcVazQeT+Rk6gR0SxP8dqlXpAPDz3mLV+JwGaoQlpUqTwjrqWRaIPB1G40kV
         ay2uWYYWefjPTGoyFqUJk/FMyA8illo3bCr41jvANHIKZXmZ5BVnRdcwMxW5TRG3M894
         7aWMZbWdJcR/I29AcajAzsoNg6jT9xhbcHoQwvwsyv9YST2s9AQRc4SbM5KnHZXIiVgU
         CanQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=HsecH+zskpsc+sAnBqxr5ZuZz+jO6o+sSCHY/MtxvCQ=;
        b=bq5r/fJL2q4YerKtgO8ooh+XRxeEQsJpgvAJm4pbXCY4Jpn6WTaZsMwuI+VFsN41gj
         YpM50+fjFh6g7mnr+zMEkW0obR4/0XFQn+ZVmSFL7y8cJmem8mORjxqO2ZpbrowrA7nJ
         QYzZ4jUSgAg+Ec2KGwb4OY1/JXxoKnJFQFDYiSaEgODH4MdmNiK1D6gcZcdeop4E7CHO
         n/AUorppnSADxboeOYdXq+OijgVuZO/NVonh1guuGImxihoaKgqICeO/i7uoURidYzq0
         zs61JgL/soupeOd1ib2TNEsLvBj5D7SB0YnchV7Aw2Jcv5CVCqeWBP101SlKit6AYmam
         Vfpw==
X-Gm-Message-State: AOAM533kWo3MVV8wW2FowuXptoQtRlGz1WWlrTep1q+HCaTqEcbkAYxj
        ycwOZvHzcBMMjwuY7D14Z9Wyqg==
X-Google-Smtp-Source: ABdhPJyEcY7aHVkmZaX3V0QWCBw0ZIrtvIgwijSbOHgj0i3rDzXComqPaqDsO3KbB50/gP6092KbSA==
X-Received: by 2002:ae9:ec0f:: with SMTP id h15mr10159256qkg.224.1630081733346;
        Fri, 27 Aug 2021 09:28:53 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-142-162-113-129.dhcp-dynamic.fibreop.ns.bellaliant.net. [142.162.113.129])
        by smtp.gmail.com with ESMTPSA id c2sm3754947qte.22.2021.08.27.09.28.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Aug 2021 09:28:52 -0700 (PDT)
Received: from jgg by mlx with local (Exim 4.94)
        (envelope-from <jgg@ziepe.ca>)
        id 1mJeiq-005jqI-8p; Fri, 27 Aug 2021 13:28:52 -0300
Date:   Fri, 27 Aug 2021 13:28:52 -0300
From:   Jason Gunthorpe <jgg@ziepe.ca>
To:     Li Zhijian <lizhijian@cn.fujitsu.com>
Cc:     linux-mm@kvack.org, linux-rdma@vger.kernel.org,
        akpm@linux-foundation.org, jglisse@redhat.com, yishaih@nvidia.com,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] mm/hmm: bypass devmap pte when all pfn requested flags
 are fulfilled
Message-ID: <20210827162852.GL1200268@ziepe.ca>
References: <20210827144500.2148-1-lizhijian@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210827144500.2148-1-lizhijian@cn.fujitsu.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 27, 2021 at 10:45:00PM +0800, Li Zhijian wrote:
> Previously, we noticed the one rpma example was failed[1] since 36f30e486d,
> where it will use ODP feature to do RDMA WRITE between fsdax files.
> 
> After digging into the code, we found hmm_vma_handle_pte() will still
> return EFAULT even though all the its requesting flags has been
> fulfilled. That's because a DAX page will be marked as
> (_PAGE_SPECIAL | PAGE_DEVMAP) by pte_mkdevmap().
> 
> [1]: https://github.com/pmem/rpma/issues/1142
> 
> CC: stable@vger.kernel.org
> Signed-off-by: Li Zhijian <lizhijian@cn.fujitsu.com>

You need to add a 

Fixes: 405506274922 ("mm/hmm: add missing call to hmm_pte_need_fault in HMM_PFN_SPECIAL handling")

> diff --git a/mm/hmm.c b/mm/hmm.c
> index fad6be2bf072..4766bdefb6c3 100644
> +++ b/mm/hmm.c
> @@ -294,6 +294,12 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, unsigned long addr,
>  	if (required_fault)
>  		goto fault;
>  
> +	/*
> +	 * just bypass devmap pte such as DAX page when all pfn requested
> +	 * flags(pfn_req_flags) are fulfilled.
> +	 */
> +	if (pte_devmap(pte))
> +		goto out;

I liked your ealier version better where this was added to the
pte_special test - logically this is about disambiguating the
pte_special and the devmap case as they are different things.

Jason
