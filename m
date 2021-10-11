Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85D4F42986A
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 22:51:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235092AbhJKUxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 16:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235089AbhJKUxO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 16:53:14 -0400
Received: from mail-oo1-xc34.google.com (mail-oo1-xc34.google.com [IPv6:2607:f8b0:4864:20::c34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B96ABC061570;
        Mon, 11 Oct 2021 13:51:13 -0700 (PDT)
Received: by mail-oo1-xc34.google.com with SMTP id b5-20020a4ac285000000b0029038344c3dso5754263ooq.8;
        Mon, 11 Oct 2021 13:51:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:to:cc:references:from:subject:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Zpp+ByPTuu11cRdb4qZvSO4X5qVzsBdD+2ORz/hi9KM=;
        b=e7oJKJ0jv9KnyF/1q2zozxqTQmuwcVt8JrTBvgebjwazhwOq8RvHuUnhxU7D0KQGN6
         gcSSu0lMd9bNLsDvcXDq9erVShUaxhJGmJvV1bVGwQUYMdxmrYpG9BdoTR/rrYtLqt2K
         aRKCIh+fOx3vIeqKY2QK7Yf8k5EZy53oq0GZ2uO8qqsIp+PfW3LuspSm08agAv/++cK7
         Uw++h9W2YNdAxcOVmOAzmBo7WQaJgS+gpLq/fAAIDpujGjRxon9sf5cVI9A31t+UxIEd
         MLYxv8VJq8Jv2vpC1llP99XlBe8+eB4RA+8H1qr6yL7ifpITa7JzB4AoIB/nNan9zrPC
         oLOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:to:cc:references:from:subject:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zpp+ByPTuu11cRdb4qZvSO4X5qVzsBdD+2ORz/hi9KM=;
        b=AzhfM6WUVi1dAuBUbqZhfhLwBxqciA5cKNz6CQ4EZtbnxsX5YZQKooKWjADB9I0LIt
         h1pSEFSlKipe8rweaLfXYRARYA5V1judMy0VyEsW6tsH39g8BlwY2Y7v6YUevnlJIkir
         tv5kcaJqe42QBwzcnTnY4e5pB++EUkLfXwtouZf5kfPaewKNLCEGpywB26fQysTgVeq6
         IQu4wBnUS66LlbXY2EIVuAWL9+mV1wAQAnqCvmxC0tONb0gQzNy4oqgj8rLzVqaLUJMl
         d1Q2EoBl5xohQpminkIC8kSUb4P+Zw0kF2dIYFM/MrLkdGgMylWYVwVxAlcee8LsR1Fq
         zt+Q==
X-Gm-Message-State: AOAM531AUr9UzJ0q8+Qpbl0r+P2CaQTQBCXxei80ZyNFYYbgLJsJXzd8
        2sseOR5lU9h8PamMo9rBbi9H0rOIFM8=
X-Google-Smtp-Source: ABdhPJzx9T/NF6ecmyYusbJp+EleQrbTzkuBFNNqvCY3uOEW302AgOCWSXFQvwwxigVRS5U7luC9lA==
X-Received: by 2002:a05:6820:1015:: with SMTP id v21mr7158053oor.47.1633985472933;
        Mon, 11 Oct 2021 13:51:12 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h5sm1946940oti.58.2021.10.11.13.51.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Oct 2021 13:51:12 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
References: <20211011134640.711218469@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
Subject: Re: [PATCH 4.19 00/28] 4.19.211-rc1 review
Message-ID: <d8d3263e-f97e-402e-e390-b96a4223c45b@roeck-us.net>
Date:   Mon, 11 Oct 2021 13:51:10 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <20211011134640.711218469@linuxfoundation.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 10/11/21 6:46 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.211 release.
> There are 28 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Oct 2021 13:46:31 +0000.
> Anything received after that time might be too late.
> 

arch/powerpc/net/bpf_jit_comp64.c: In function 'bpf_jit_build_body':
arch/powerpc/net/bpf_jit_comp64.c:392:46: error: implicit declaration of function 'PPC_RAW_LI'; did you mean 'PPC_RLWIMI'?

This problem affects all release candidates from v4.9.y to v5.4.y.

Guenter
