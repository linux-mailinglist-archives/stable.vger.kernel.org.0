Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4819D4E9CF4
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 19:01:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240556AbiC1RBr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Mar 2022 13:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234838AbiC1RBq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Mar 2022 13:01:46 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8D6460DA8;
        Mon, 28 Mar 2022 10:00:04 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id j18so21282689wrd.6;
        Mon, 28 Mar 2022 10:00:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:date:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZEVHtJO6G677L0G9fCsEHBPzXupfvRbVBLDDcKGMsYU=;
        b=GgFcrGvHeEH9/JlDBJIxdBIaTQg6F3si2q5JnsELpGexfHNINgrEkleEGhZEppLibP
         BhiiFQMGXwqq50116/Bkk6wogeLJprQ+5bKwzXN+kMaU0pIxxzAAeTfaSVj+EzjxARRe
         hTZw6+nbuV56dKTaTp0Xqrs5tkC9fEPLbWVzpk9AnrvYhcHTm8e/sCtFI7zmov2sabX9
         ONkVSc+3F+g2yiueHefAvigIqxij9CEOWQW1aR/CHIiA6ThvCKgZoQpTjGWT39Br2UPV
         bAMyeKsdacEE4OMzznwTEGpf5Tmu4LaVw2jJGEYt4g19MVPeiUSaDKSsK++gHzHxsCaF
         8Y5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:date:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZEVHtJO6G677L0G9fCsEHBPzXupfvRbVBLDDcKGMsYU=;
        b=7YXqBeEzFpSstGusFqp57NzZJyd+Qxx0GjMa8CShWBYItLcfIQuJcBS50MaUjLNDGY
         zzXjAD1xOO2x60eXHEFj6RZYWsssqONx5ftwrMUnoYAqpJU6ts+9t0Cm/46HTodvmKPy
         CB1QCRO08o1atJaJl1J8ZvR1OWlbFB+m0yTjGGkiWWSQ43x/UY7fecvSpNQS+AVivQEn
         4yx89lnIsO/VNPe6EY7/lYh66+t89lMxpzFaQgRvVWbYZOVp51kWi56hTsACENc26Sot
         buiEUqt9wCW45/J21b1O/BMX/9hosS4QLbEPiHnjakccG6B0YSB0fCPEh7nBfiL2QdDm
         1AOg==
X-Gm-Message-State: AOAM5314t4FN5Jqa9KExZIRN7144+BF7T9qlx7Aedk+AlDgaib3Qacci
        2ENrYlDrwuldNzDc9mYVQIo=
X-Google-Smtp-Source: ABdhPJxzjh9QUSY5wPmlsFXZZNn50r8F3dt/NEaF/KDOVSxLctYdcEXRjycF7pXgfgOk2gK6TCDYyQ==
X-Received: by 2002:adf:e2cc:0:b0:203:e8ba:c709 with SMTP id d12-20020adfe2cc000000b00203e8bac709mr24899786wrj.713.1648486803349;
        Mon, 28 Mar 2022 10:00:03 -0700 (PDT)
Received: from trex (95.red-81-38-138.dynamicip.rima-tde.net. [81.38.138.95])
        by smtp.gmail.com with ESMTPSA id r12-20020a5d6c6c000000b00203ec2b1255sm16241799wrz.60.2022.03.28.10.00.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Mar 2022 10:00:02 -0700 (PDT)
From:   "Jorge Ramirez-Ortiz, Gmail" <jorge.ramirez.ortiz@gmail.com>
X-Google-Original-From: "Jorge Ramirez-Ortiz, Gmail" <JorgeRamirez-Ortiz>
Date:   Mon, 28 Mar 2022 19:00:01 +0200
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     srinivas.kandagatla@linaro.org, amahesh@qti.qualcomm.com,
        arnd@arndb.de, gregkh@linuxfoundation.org,
        jorge.ramirez-ortiz@linaro.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] misc: fastrpc: fix an incorrect NULL check on list
 iterator
Message-ID: <20220328170001.GA3040725@trex>
References: <20220327062202.5720-1-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220327062202.5720-1-xiam0nd.tong@gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 27/03/22, Xiaomeng Tong wrote:
> The bug is here:
> 	if (!buf) {
> 
> The list iterator value 'buf' will *always* be set and non-NULL
> by list_for_each_entry(), so it is incorrect to assume that the
> iterator value will be NULL if the list is empty (in this case, the
> check 'if (!buf) {' will always be false and never exit expectly).

yes.

> 
> To fix the bug, use a new variable 'iter' as the list iterator,
> while use the original variable 'buf' as a dedicated pointer to
> point to the found element.

LGTM

> 
> Cc: stable@vger.kernel.org
> Fixes: 2419e55e532de ("misc: fastrpc: add mmap/unmap support")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
> ---
>  drivers/misc/fastrpc.c | 9 +++++----
>  1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
> index aa1682b94a23..45aaf54a7560 100644
> --- a/drivers/misc/fastrpc.c
> +++ b/drivers/misc/fastrpc.c
> @@ -1353,17 +1353,18 @@ static int fastrpc_req_munmap_impl(struct fastrpc_user *fl,
>  				   struct fastrpc_req_munmap *req)
>  {
>  	struct fastrpc_invoke_args args[1] = { [0] = { 0 } };
> -	struct fastrpc_buf *buf, *b;
> +	struct fastrpc_buf *buf = NULL, *iter, *b;
>  	struct fastrpc_munmap_req_msg req_msg;
>  	struct device *dev = fl->sctx->dev;
>  	int err;
>  	u32 sc;
>  
>  	spin_lock(&fl->lock);
> -	list_for_each_entry_safe(buf, b, &fl->mmaps, node) {
> -		if ((buf->raddr == req->vaddrout) && (buf->size == req->size))
> +	list_for_each_entry_safe(iter, b, &fl->mmaps, node) {
> +		if ((iter->raddr == req->vaddrout) && (iter->size == req->size)) {
> +			buf = iter;
>  			break;
> -		buf = NULL;
> +		}
>  	}
>  	spin_unlock(&fl->lock);
>  
> -- 
> 2.17.1
> 

