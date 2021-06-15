Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7847D3A82D0
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 16:27:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230350AbhFOO30 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 10:29:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230438AbhFOO2h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 10:28:37 -0400
Received: from mail-oi1-x22d.google.com (mail-oi1-x22d.google.com [IPv6:2607:f8b0:4864:20::22d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29A9C0611FA;
        Tue, 15 Jun 2021 07:21:52 -0700 (PDT)
Received: by mail-oi1-x22d.google.com with SMTP id d19so14343912oic.7;
        Tue, 15 Jun 2021 07:21:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0UOc0+k84slM7UKhdGabxtjZZIGW06xoCLLVEZe3c4Q=;
        b=Co5YYZampxULbGi9aofM2V4upSjpTDk4Y0B8GkfrpVl9jje8Gb85lvMRFRQpxyPT22
         NQV1dWmJJFkLSc0HesO8KQSp/TXsxwHjA3a6Gog6S3Y9BuS17VjJYzk5mE3aDJKJtn/9
         kmai3BCh06r4gA1Oelx6KfJ5CFVjIENJGYcM4CiDXxmxnqswoERU1Ipr+U4tK8+te0PK
         FftvHIuKUepN/dlnbz74qcsF7hH1qREM8KUr5XtviFV1fjV8qHkxl+qJzJSdqyFg6wrv
         ru0DS2/MB1Yuh+VR4VNwRMkEGuTknDBuZXBweav+zw1kvDYNgkqrDOGpOhC/jlhivber
         LtLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=0UOc0+k84slM7UKhdGabxtjZZIGW06xoCLLVEZe3c4Q=;
        b=JCxUk96tQI7JwejuIMk1mj1eJX5zWFMNiKF6zCnOV5WuKDBX8eRlPgbHjaUoNNvEK7
         LANggaHPPdrtNvFbi6Js5lX1Lj07jdh3/IKcEUha0VtSEJHmU7KalwvAxbSLHO9/KvAJ
         TASWJl5Z9t2WaUyoeLt4YzlDgEoYimo/89hESRfSlq/sCcbGwZuSshOI/PWxLdNKiWp9
         1SqGY/tZiB6fttWkAWtPXju54DTRL2FFVyf9umc/yEErJno44lGnOVZiVXZ+uxpmlg43
         dONHxhFVKC1orSkmgUiGvWAO/NM4mBnmocnq2C7dUwTSh5v+AgS5Q0RvU8ImNcZN5D64
         p7bw==
X-Gm-Message-State: AOAM533fQEupzgjVUXAtXp2zIhbqcmuRrU4madJ3uMsFlhGw1Lvjqiz2
        2Bv9Y9TkZC9u74kGXN0GrFMdU64jrXA=
X-Google-Smtp-Source: ABdhPJwGOfZgNIxf6ie1FlT0MOSEb7aXrjGbS1uaiBGW68l32gesK9MRg2RcS4ExzsHdcJBNsw9uxA==
X-Received: by 2002:aca:cf8d:: with SMTP id f135mr3582023oig.152.1623766912214;
        Tue, 15 Jun 2021 07:21:52 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id z23sm3514990ooz.15.2021.06.15.07.21.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Jun 2021 07:21:51 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 15 Jun 2021 07:21:50 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/173] 5.12.11-rc1 review
Message-ID: <20210615142150.GG958005@roeck-us.net>
References: <20210614102658.137943264@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210614102658.137943264@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 14, 2021 at 12:25:32PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.11 release.
> There are 173 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Jun 2021 10:26:30 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 151 pass: 151 fail: 0
Qemu test results:
	total: 462 pass: 462 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
