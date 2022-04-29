Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9728B51512B
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 18:53:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379347AbiD2Q4r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 12:56:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379340AbiD2Q4q (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 12:56:46 -0400
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89BFFDA6EC
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 09:53:26 -0700 (PDT)
Received: by mail-wm1-x32d.google.com with SMTP id p189so4946010wmp.3
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 09:53:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=gF0XSQXvhEerOtZQE67Fv/RM3gJgfWvh3o2fwzeA8OY=;
        b=hELuasXky3HZCxMFNpSgD5FdIPEXNRdTxdKAxbkPN05aGII+4JoICUbBkMAlUTurAQ
         L6rq3PGkAHUUnTQyc77gwoC8jb5v/4xaWEPra41O5oJAGpi+LgDune8CEKlVMPUtHY5P
         O/eEEHdM+XZr2XIG5aK+qgjTUCrdJ2kHBbMajpFupqsvaP9vRtzwB0Uz4+Gf5AIA7gk1
         KPjzG5830EmbPOv1yaRsPTilWcM1cjJVjRJl5rDGhF8BxYtXAaIZptSN0yV0YbnkLHQr
         wwI4EMsxsemAwyf5szkcjYyIShJriszMFsxF7nBAvq0Ooi0nz6OicKvtuEQr7uHCvJX5
         ePBA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=gF0XSQXvhEerOtZQE67Fv/RM3gJgfWvh3o2fwzeA8OY=;
        b=JhWI4GsBuKriV0CmU4ubDOFufIHKwifR4OfKjy1+AlXM794Te1Ty6PJNmtbzNOwMvU
         fDmmfof7MtE3szFCjFNiiRcAVaaVFuecakihGCXKah3N/zE8Py18mMyc921GyFjcU6Kr
         ZKe4ljTcItPCQ353UYRPogFpeMC6SQrdQ/oZ5LvYyDfv0myuYDp+iPeyPdKzxQKacm4n
         JgHiJOlcByXWbhl1FeAR0Dr+96a6o8wGd3IzkCC7pJt2KRR4vo6lQOPL2J3/WqVJ4eIO
         gsOuo68e4/bQ6sjP7V9i5APnM3SFtMG6itZyW/eSoKsV2jn3ngK6QiM9yhrdav7OYSTH
         JEbQ==
X-Gm-Message-State: AOAM5313N93s5UYy1Sm+0Sw7mqr5uH7pRLGsrIXGrAGMq2psxbLgPgl6
        Ha+uboxU7MWZVKFx5irk0DrP9g==
X-Google-Smtp-Source: ABdhPJx4wGrPBGJPFmNxW8tuM/QQdlgSJgzr9IKK/k91ySYvrwxQTmHM+rRPDy4KJY2hydWvfeXNAg==
X-Received: by 2002:a05:600c:3547:b0:393:eee3:39df with SMTP id i7-20020a05600c354700b00393eee339dfmr3998609wmq.181.1651251205114;
        Fri, 29 Apr 2022 09:53:25 -0700 (PDT)
Received: from [192.168.86.34] (cpc90716-aztw32-2-0-cust825.18-1.cable.virginm.net. [86.26.103.58])
        by smtp.googlemail.com with ESMTPSA id o11-20020a05600c4fcb00b00391447f7fd4sm3642655wmq.24.2022.04.29.09.53.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 29 Apr 2022 09:53:24 -0700 (PDT)
Message-ID: <e368b193-48f9-c8b8-ea70-59bf7ea7304a@linaro.org>
Date:   Fri, 29 Apr 2022 17:53:23 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH] misc: fastrpc: fix an incorrect NULL check on list
 iterator
Content-Language: en-US
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>
Cc:     amahesh@qti.qualcomm.com, arnd@arndb.de,
        gregkh@linuxfoundation.org, jorge.ramirez-ortiz@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220327062202.5720-1-xiam0nd.tong@gmail.com>
From:   Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
In-Reply-To: <20220327062202.5720-1-xiam0nd.tong@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 27/03/2022 07:22, Xiaomeng Tong wrote:
> The bug is here:
> 	if (!buf) {
> 
> The list iterator value 'buf' will *always* be set and non-NULL
> by list_for_each_entry(), so it is incorrect to assume that the
> iterator value will be NULL if the list is empty (in this case, the
> check 'if (!buf) {' will always be false and never exit expectly).
> 
> To fix the bug, use a new variable 'iter' as the list iterator,
> while use the original variable 'buf' as a dedicated pointer to
> point to the found element.
> 
> Cc: stable@vger.kernel.org
> Fixes: 2419e55e532de ("misc: fastrpc: add mmap/unmap support")
> Signed-off-by: Xiaomeng Tong <xiam0nd.tong@gmail.com>
LGTM,

Reviewed-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>

> --- >   drivers/misc/fastrpc.c | 9 +++++----
>   1 file changed, 5 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/misc/fastrpc.c b/drivers/misc/fastrpc.c
> index aa1682b94a23..45aaf54a7560 100644
> --- a/drivers/misc/fastrpc.c
> +++ b/drivers/misc/fastrpc.c
> @@ -1353,17 +1353,18 @@ static int fastrpc_req_munmap_impl(struct fastrpc_user *fl,
>   				   struct fastrpc_req_munmap *req)
>   {
>   	struct fastrpc_invoke_args args[1] = { [0] = { 0 } };
> -	struct fastrpc_buf *buf, *b;
> +	struct fastrpc_buf *buf = NULL, *iter, *b;
>   	struct fastrpc_munmap_req_msg req_msg;
>   	struct device *dev = fl->sctx->dev;
>   	int err;
>   	u32 sc;
>   
>   	spin_lock(&fl->lock);
> -	list_for_each_entry_safe(buf, b, &fl->mmaps, node) {
> -		if ((buf->raddr == req->vaddrout) && (buf->size == req->size))
> +	list_for_each_entry_safe(iter, b, &fl->mmaps, node) {
> +		if ((iter->raddr == req->vaddrout) && (iter->size == req->size)) {
> +			buf = iter;
>   			break;
> -		buf = NULL;
> +		}
>   	}
>   	spin_unlock(&fl->lock);
>   
