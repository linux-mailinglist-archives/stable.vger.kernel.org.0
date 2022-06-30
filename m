Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0FBF560F21
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 04:24:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231421AbiF3CYj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 Jun 2022 22:24:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231393AbiF3CYi (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 29 Jun 2022 22:24:38 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 9B54423158
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 19:24:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1656555876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jTpWjatM3e8fY4ePrpnhi85t3mu1MuP1MyivO5RpYvM=;
        b=FRBosaK3frzWaAx1wMj+TNmkAc08lY3CjFdQNNmDbEPNZBT4Km7EjRqNp1/C/GjkV26Jls
        NjsyQNul6iytEA5+40lmUA9UAGQRcvePOyRO6oqhG8iete+2bbzRWhBfj7k+s54SVTvwuu
        Llrd80k2WFUcBVH8Dzj5t8b6fc7uwHo=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-41-D6grtT2RMQyDebqO4D6_EQ-1; Wed, 29 Jun 2022 22:24:35 -0400
X-MC-Unique: D6grtT2RMQyDebqO4D6_EQ-1
Received: by mail-qv1-f71.google.com with SMTP id m7-20020ad45dc7000000b0047042480dbfso17010149qvh.9
        for <stable@vger.kernel.org>; Wed, 29 Jun 2022 19:24:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jTpWjatM3e8fY4ePrpnhi85t3mu1MuP1MyivO5RpYvM=;
        b=rhGxsELDdAvyCMymqy0Iwgpe/WP0OzGyc/nHRHdBveNyG9IeToFitXwe1SScn1QjG6
         QKS5IMlmE6uaKkd3MiDGRasi8vy3R+lSZRYVSlDY6D1CllCWS/j7mHTibf6m+e81WRAh
         1Yf5NRi2PqF7aLdIHbTPVAlzriH+9QBmfb6HGG1QMGTmCyiFpLZcH4BcuSdbAQWlK10h
         UkTYnXDktEs9IiNoQ/yfhB3vBjvdmlo+Gls1MA17WoRVOLhl4f2CWapeIwJfsfpRiqAE
         nzBBwQ+sYPynAfYGfkNeEUBEGpDt5I6+NdaDbKN5lGbbIl6sCdoyABNCzsutJ3BGmPV4
         Io1Q==
X-Gm-Message-State: AJIora/YNJTIEQu0F3c7BQTvN7qQH1sA0ZnTwy+7OCQIenUrDB1tx5gZ
        QlKpPLTl8vtPlWyavBu3sT+P05ViueOSUciPtQXLgE8trDoGbAzVRc0tCb28K/VRyJorfQrAKf7
        pFnvR2502IWtf73gl
X-Received: by 2002:a05:620a:2411:b0:6af:22e8:71d7 with SMTP id d17-20020a05620a241100b006af22e871d7mr4656784qkn.457.1656555874847;
        Wed, 29 Jun 2022 19:24:34 -0700 (PDT)
X-Google-Smtp-Source: AGRyM1vinpGqyYzYXampSsd0UFjmJV815VN5VbFI0BVtMhTOJsaq6mbWt/cEH/wui46wQSEunh0yEA==
X-Received: by 2002:a05:620a:2411:b0:6af:22e8:71d7 with SMTP id d17-20020a05620a241100b006af22e871d7mr4656775qkn.457.1656555874643;
        Wed, 29 Jun 2022 19:24:34 -0700 (PDT)
Received: from localhost.localdomain (024-205-208-113.res.spectrum.com. [24.205.208.113])
        by smtp.gmail.com with ESMTPSA id b19-20020ae9eb13000000b006aee672937esm13952098qkg.37.2022.06.29.19.24.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 19:24:34 -0700 (PDT)
Subject: Re: [PATCH] tracing/histograms: Simplify create_hist_fields()
To:     Zheng Yejian <zhengyejian1@huawei.com>, rostedt@goodmis.org,
        mingo@redhat.com, linux-kernel@vger.kernel.org,
        tom.zanussi@linux.intel.com
Cc:     stable@vger.kernel.org, zhangjinhao2@huawei.com
References: <20220630013152.164871-1-zhengyejian1@huawei.com>
From:   Tom Rix <trix@redhat.com>
Message-ID: <d615e7a0-8a7e-7e24-6c87-a8bf034ecb53@redhat.com>
Date:   Wed, 29 Jun 2022 19:24:32 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20220630013152.164871-1-zhengyejian1@huawei.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 6/29/22 6:31 PM, Zheng Yejian wrote:
> When I look into implements of create_hist_fields(), I think there can be
> following two simplifications:
>    1. If something wrong happened in parse_var_defs(), free_var_defs() would
>       have been called in it, so no need goto free again after calling it;
>    2. After calling create_key_fields(), regardless of the value of 'ret', it
>       then always runs into 'out: ', so the judge of 'ret' is redundant.
>
> No functional changes.
>
> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> ---
>   kernel/trace/trace_events_hist.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
>
> diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
> index 2784951e0fc8..832c4ccf41ab 100644
> --- a/kernel/trace/trace_events_hist.c
> +++ b/kernel/trace/trace_events_hist.c
> @@ -4454,7 +4454,7 @@ static int create_hist_fields(struct hist_trigger_data *hist_data,
>   
>   	ret = parse_var_defs(hist_data);
>   	if (ret)
> -		goto out;
> +		return ret;
>   
>   	ret = create_val_fields(hist_data, file);
>   	if (ret)
> @@ -4465,8 +4465,7 @@ static int create_hist_fields(struct hist_trigger_data *hist_data,
>   		goto out;
>   
>   	ret = create_key_fields(hist_data, file);
> -	if (ret)
> -		goto out;
> +
>    out:
>   	free_var_defs(hist_data);
Reviewed-by: Tom Rix <trix@redhat.com>
>   

