Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64D863799D5
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 00:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbhEJWRU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 18:17:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232226AbhEJWRT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 18:17:19 -0400
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01585C061574;
        Mon, 10 May 2021 15:16:14 -0700 (PDT)
Received: by mail-oi1-x22b.google.com with SMTP id w16so9055466oiv.3;
        Mon, 10 May 2021 15:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=3XcCBAdRs/KYBMLqKGYlI+1J150xwrXzrdCIX5oj2BQ=;
        b=g5jKN3I0KOeLBmFgtz7U8n5Fmr8VFAUaNeT2FOBku0x/CCCmucvV6cAMN+4kf7xQ63
         3dGv9Mk5VEq54uLlpHoOYc6GVtsu/YVo8j6VppekEerJotPlpz0IeNstCYCYl2jGQk96
         rmpyHSMlp1dW7XcnE9qn/+Uqb/QIpQMhVjzhns6vrjLro1JREffT2WL7IJABga1rO75e
         htqnXWAFiEPzSQba9lCFFUTTQET3LdC9jn/KQjpWjI0OFOvSozwlmInzpaz2ABf+Bu1M
         AUfSfvf/92K7Ie46OYRXKzDpL3nffh3eSONaaxRJDzyRDh/pTgBhPXWW4EQvo9v0dY56
         nF0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=3XcCBAdRs/KYBMLqKGYlI+1J150xwrXzrdCIX5oj2BQ=;
        b=l5odZTlwlzdeGfF3IFYY1W2Xy6TJBvtc8M5dlneGSqsp4o5EWQjAUIH9QtcrFfzTpg
         8zHk6KW3JIBSBrPfbO0mO12rMakexzcJYQQCDJfOAL572ivNpWLmXeHjBntXEROoQr2q
         QKkqtsXT9GPUz2g+Cj1iXXcDrSOiZ1Tpx7NZ2gA3pABxprY4QlNtB3xZo3xRGhsK67pM
         i5+a5SYdjvXd5rRv9hLGxuzcB1/u1Or5GbGqPRgl6/sJzDNcu2GWPPqHIVsDy7aAxdgy
         zXv/b+JWsh36yMYersE0Lfc6IdB3pZQB/9qQ+Qhzzw9rXizZYDR8pGO+zh3tr+2gPok3
         +3Vg==
X-Gm-Message-State: AOAM532GrWZ88KUaDUQpqSnieQsBZXKwkk5o4cyIs2DdtoTw+umwU9Aw
        Q6d/diL2cvCI6xmwARMygnM=
X-Google-Smtp-Source: ABdhPJw2RgcdNdA9EQYt4YYvbk0s+RkKc0jTEbUCA77Ai56V+z8CMtIFyGsVg/IhK61a82WwXgEWzw==
X-Received: by 2002:aca:c449:: with SMTP id u70mr1057613oif.146.1620684971929;
        Mon, 10 May 2021 15:16:11 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n98sm3404536ota.24.2021.05.10.15.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 15:16:11 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 10 May 2021 15:16:10 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/342] 5.11.20-rc1 review
Message-ID: <20210510221610.GC2334827@roeck-us.net>
References: <20210510102010.096403571@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 12:16:30PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.20 release.
> There are 342 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 461 pass: 461 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
