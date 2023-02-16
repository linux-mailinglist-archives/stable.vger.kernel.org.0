Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2125B6998D6
	for <lists+stable@lfdr.de>; Thu, 16 Feb 2023 16:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229495AbjBPP0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Feb 2023 10:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjBPP0T (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Feb 2023 10:26:19 -0500
Received: from mail-io1-xd30.google.com (mail-io1-xd30.google.com [IPv6:2607:f8b0:4864:20::d30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28338552A5
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 07:25:45 -0800 (PST)
Received: by mail-io1-xd30.google.com with SMTP id y2so769580iot.4
        for <stable@vger.kernel.org>; Thu, 16 Feb 2023 07:25:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1676561137;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=YctmQMfQgA5ZBXZuG4fBHoClKPzeu2v9SmsikMdOOyQ=;
        b=5e/zc2lQ9fn3/dmOEtibkVuKyI848bjSiuw2x7SgbM+qW5mEfbLJnD9UDK7wVF2rYm
         JuZ8zUrKSJ07sG5ke6EJKOEt1WoQWsoxsPuMWpWfCGn6oom10YrcOqA0x4qJuLCZjdvb
         6s3raceSql4yiOA8o6txy59JkHjLvtH8UQrRPv6QabSAYY0Hx5TKAYeIK1LXVBWGSCVl
         dz3ehl0l2Fw9Z0RWqeas6CFoEIStbXRS6xvH2SZFGsDdtdbx+QK/gYAFR8SK7cxbGH1C
         Oz2OgyyknuWMlJxNm0bEfgN5FNADTiwekODknr6jfX6Z2FPpz5JLwnvTNbZwWnoPh+Ak
         1MVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676561137;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=YctmQMfQgA5ZBXZuG4fBHoClKPzeu2v9SmsikMdOOyQ=;
        b=DDvGGffVG2C3AFLRS2g3kM0yFOSz10YjpgoYn8dScfbCF0UWjSxEN/epFEP4WWKEoG
         in2k4H1Bgos5cABRj9s4E0AnzP97jyy8Wi1DIwSzn3d8ZtqNDPtpzXfIV+UarwUC+fIR
         /i81YVXOnOuus6qWkzBPphsHOZJxWGJeaTOiRCMdfaP6HkUC7pbPMjZJcPXPYjY9Ip+o
         ScgvOnnw0/jO20QOYhjEgcMOgvCRs6wLUzvZ2awGO6AcdJOrJFg7hRQsgjXwNjKDa2yK
         yFwCQc5Y9ABDIJFEOT0SdPwVTsOxOm5KZx/Pf9VKsxbj5Er1tjY/clhYTX/8tOBq1Pos
         CK/A==
X-Gm-Message-State: AO0yUKU3MHHWbjXKwMHeGPFbeQFILi3LemeKTf/54ol3Yrox1iXmNUpl
        DFy8ItllFVYAe2e6STML4O7xOQ==
X-Google-Smtp-Source: AK7set9ZqYJuHb5bm7y3e0l1CRY2GabRSQzFrWDqQF8YUEuOnnX5fU6lmFpHYiFOqMhZp9kHXhw5nA==
X-Received: by 2002:a05:6602:154b:b0:715:f031:a7f5 with SMTP id h11-20020a056602154b00b00715f031a7f5mr4910015iow.1.1676561136951;
        Thu, 16 Feb 2023 07:25:36 -0800 (PST)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id n23-20020a02a917000000b0037477c3d04asm604387jam.130.2023.02.16.07.25.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Feb 2023 07:25:36 -0800 (PST)
Message-ID: <fe4d770a-69b3-95a5-ead0-f33c5762c67f@kernel.dk>
Date:   Thu, 16 Feb 2023 08:25:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH 3/4] brd: only preload radix tree if we're using a
 blocking gfp mask
Content-Language: en-US
To:     linux-block@vger.kernel.org
Cc:     hch@infradead.org, stable@vger.kernel.org
References: <20230216151918.319585-1-axboe@kernel.dk>
 <20230216151918.319585-4-axboe@kernel.dk>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <20230216151918.319585-4-axboe@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/16/23 8:19?AM, Jens Axboe wrote:
> @@ -104,8 +105,10 @@ static int brd_insert_page(struct brd_device *brd, sector_t sector, gfp_t gfp)
>  	if (radix_tree_insert(&brd->brd_pages, idx, page)) {
>  		__free_page(page);
>  		page = radix_tree_lookup(&brd->brd_pages, idx);
> -		BUG_ON(!page);
> -		BUG_ON(page->index != idx);
> +		if (!page)
> +			ret = -ENOMEM;
> +		else if (page->index != idx)
> +			ret = -EIO;
>  	} else {
>  		brd->brd_nr_pages++;
>  	}

After sending this out, noticed that I forgot to change the return 0 to
return ret instead. This has been done locally, fwiw.

-- 
Jens Axboe

