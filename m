Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 717CE4EEBC3
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 12:46:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345147AbiDAKr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 06:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345136AbiDAKry (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 06:47:54 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 43C721D760E
        for <stable@vger.kernel.org>; Fri,  1 Apr 2022 03:46:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1648809964;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xiOEHMN+N8h0zJ0SMcJZz4gaUnk1cTnEy4jqmAnZpc4=;
        b=hMQj6QlCz3E7irNVUh+kG5DBsczDjPsBo2W7yXaQtNqfBMqwntlhp3xDKgokiVYnnR/pqo
        NgJogRCnjye0eNRkG9Ko7t9MEmlSjksA4eg1SJWhMOpC1jYFMmOKMEboIk3XZ0Mt1blBLK
        HYDC+eIga6W/+br+1Cr6giy1zN7kQOc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-605-T6QJcwarNdqh6BukaBa_Xg-1; Fri, 01 Apr 2022 06:46:03 -0400
X-MC-Unique: T6QJcwarNdqh6BukaBa_Xg-1
Received: by mail-wm1-f72.google.com with SMTP id r64-20020a1c2b43000000b0038b59eb1940so2522390wmr.0
        for <stable@vger.kernel.org>; Fri, 01 Apr 2022 03:46:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=xiOEHMN+N8h0zJ0SMcJZz4gaUnk1cTnEy4jqmAnZpc4=;
        b=8KC4G6ZHk4wh8bOomJGzbjj5G06TaRVYRB77JzkA07bbSxxpy5hRfl/ZGMMYtCboVx
         ek2QbuMcRxixg1KCcQdqLwiT6+D8Bjz+ZHYy+sZh9IXg6r21P5D20N/AB7qYRTed/NTR
         +E5xvcRyNJ+DlbvvGWqvsyFbIOT/7NsqFWcy3vv9z+RPm6e9tRLNIXHQJ0FYzQWq6Pvz
         8ZnTyj0gvas1biPo/CTlfoTaNEvU6B/tSE5iqYDEpn3QKojAvWU2dUkuCKkvCI0vZ7HJ
         DJW2GgAEwo9cV6mgW+2fE4Lqn3HtZK1CAzG/F9GmeGvL5K3+WVUlQCRorcecHFuQAVD1
         uJlg==
X-Gm-Message-State: AOAM532Xj0XyG3eTk+wXsWaPelDgxzOaEI4n1qSOUCWi4t0b6N9LfoEQ
        oy6QmHga9arXvzxrGW4LlLiLo5PYt5E0Fr7pE6Av5Tnbyaq8mTbKUJZvXX9sVaymMF52vJKYCBd
        ngMtJTm8mSWsKFvco
X-Received: by 2002:a05:6000:15c3:b0:204:1185:7033 with SMTP id y3-20020a05600015c300b0020411857033mr7152792wry.625.1648809961979;
        Fri, 01 Apr 2022 03:46:01 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwxG6qdtKkHpCzK5kfgnGP3ksdgfaziO7qjWnqOtF8DYMjkpdW5H7mcAyR9Skz1fhr1WB/9Aw==
X-Received: by 2002:a05:6000:15c3:b0:204:1185:7033 with SMTP id y3-20020a05600015c300b0020411857033mr7152778wry.625.1648809961748;
        Fri, 01 Apr 2022 03:46:01 -0700 (PDT)
Received: from ?IPV6:2003:cb:c706:9e00:229d:4a10:2574:c6fa? (p200300cbc7069e00229d4a102574c6fa.dip0.t-ipconnect.de. [2003:cb:c706:9e00:229d:4a10:2574:c6fa])
        by smtp.gmail.com with ESMTPSA id az19-20020a05600c601300b0038cadf3aa69sm14215057wmb.36.2022.04.01.03.46.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Apr 2022 03:46:01 -0700 (PDT)
Message-ID: <533f85f9-82e2-bfa7-3788-4b2a668daedf@redhat.com>
Date:   Fri, 1 Apr 2022 12:46:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH v2 2/2] hugetlb: Fix return value of __setup handlers
Content-Language: en-US
To:     Peng Liu <liupeng256@huawei.com>, mike.kravetz@oracle.com,
        akpm@linux-foundation.org, yaozhenguo1@gmail.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220401101232.2790280-1-liupeng256@huawei.com>
 <20220401101232.2790280-3-liupeng256@huawei.com>
From:   David Hildenbrand <david@redhat.com>
Organization: Red Hat
In-Reply-To: <20220401101232.2790280-3-liupeng256@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 01.04.22 12:12, Peng Liu wrote:
> When __setup() return '0', using invalid option values causes the
> entire kernel boot option string to be reported as Unknown. Hugetlb
> calls __setup() and will return '0' when set invalid parameter
> string.
> 
> The following phenomenon is observed:
>  cmdline:
>   hugepagesz=1Y hugepages=1
>  dmesg:
>   HugeTLB: unsupported hugepagesz=1Y
>   HugeTLB: hugepages=1 does not follow a valid hugepagesz, ignoring
>   Unknown kernel command line parameters "hugepagesz=1Y hugepages=1"
> 
> Since hugetlb will print warn or error information before return for
> invalid parameter string, just use return '1' to avoid print again.
> 
> Signed-off-by: Peng Liu <liupeng256@huawei.com>
> ---
>  mm/hugetlb.c | 18 ++++++++----------
>  1 file changed, 8 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 9cd746432ca9..6dde34c115c9 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -4131,12 +4131,11 @@ static int __init hugepages_setup(char *s)
>  	int count;
>  	unsigned long tmp;
>  	char *p = s;
> -	int ret = 1;

Adding this in #1 to remove it in #2 is a bit sub-optimal IMHO.


-- 
Thanks,

David / dhildenb

