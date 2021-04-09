Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B88135A7B5
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 22:14:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhDIUOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 16:14:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234242AbhDIUOQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Apr 2021 16:14:16 -0400
Received: from mail-oo1-xc30.google.com (mail-oo1-xc30.google.com [IPv6:2607:f8b0:4864:20::c30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4ED51C061762;
        Fri,  9 Apr 2021 13:14:02 -0700 (PDT)
Received: by mail-oo1-xc30.google.com with SMTP id 125-20020a4a1a830000b02901b6a144a417so1604982oof.13;
        Fri, 09 Apr 2021 13:14:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HwPepH31J6yOI+JO1D/opAn1X9rCZMmW+8TSUzrdRjk=;
        b=L5icP4RxUwEDB8/RoT7oSpEH80kZekWQZ12mLQDBuunphSKbcKm0/6cPHBulM6xGIj
         JOj2R3YA1t5VYp+b4RI8h7cUh8mWzaKx+dXzeKMH7o9+9jVhujmojvCJXu0BwpPk/u9D
         sdb/BM8E2zcrlUyQoEXwUa7gAYCQ/jE+8JKyMvPFE4hoqn/H4lbi3YQSqGgxb4Dw8SPI
         DI/372h89mWlIp+jOc9IDJkZktUXl2RetJlTDCpjYcZJsdU+KWhTQQIVJrrB7iEfdyyc
         9UMKCe1O4+C0dA83g75DQyWXyzA0cgtd8hnhFnnSRBFDUaT1inq0OPi+fNIjo+vBDn4y
         Su6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=HwPepH31J6yOI+JO1D/opAn1X9rCZMmW+8TSUzrdRjk=;
        b=E600xxoRqw7VdU6YL9tOKp0ule6SXe8OGgDfj8YoTSkGLf+aJboCajOGRHlLsfxJFW
         GqCGkwosPuRrEB7d645x9hWUBGz1cBpEzkiqjOGmszevB9L4pheZZ55zFWC5KL94gYom
         jfo3pqfKTiPV+P6SgzLJyjOcUbWpnoQRs8tn/9wFfcOIZA9NmGgp5XbTMa5P6Pymuy2+
         umN9JayACHTDltVPeAQQddCFG4+v1iNDFXpw4t7YvY/JasBOcTAAgIgIMGHm3ZVoX5GP
         fJIKw3risZ6yl8HZU1vqEjqXap4GjM4rMgeuoKHwr0Hm3wG2UvG/+LUiW8Qs5ZkbwkWl
         kExQ==
X-Gm-Message-State: AOAM5323HTpwKTzMrnuJ+lVNPwjph3Jg1dv+WQuxlKl8HVVMXqfkh18s
        2ORhQPrEJv+9R7VncgEGHdxcL6nEpsI=
X-Google-Smtp-Source: ABdhPJwMNpFQ+XJUdCkMD41aBBVaxDvu+uMbRpWyoL8z9xHDqCZSboQexEDiZZxwyaJllKJBstdjwg==
X-Received: by 2002:a4a:b305:: with SMTP id m5mr13226042ooo.76.1617999241795;
        Fri, 09 Apr 2021 13:14:01 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d26sm701987oos.32.2021.04.09.13.14.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 09 Apr 2021 13:14:01 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 9 Apr 2021 13:14:00 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/23] 5.4.111-rc1 review
Message-ID: <20210409201400.GE227412@roeck-us.net>
References: <20210409095302.894568462@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409095302.894568462@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 09, 2021 at 11:53:30AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.111 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 11 Apr 2021 09:52:52 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 157 pass: 157 fail: 0
Qemu test results:
	total: 433 pass: 433 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
