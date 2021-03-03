Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA4432C838
	for <lists+stable@lfdr.de>; Thu,  4 Mar 2021 02:14:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377098AbhCDAe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Mar 2021 19:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387975AbhCCUIE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Mar 2021 15:08:04 -0500
Received: from mail-oi1-x22b.google.com (mail-oi1-x22b.google.com [IPv6:2607:f8b0:4864:20::22b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B24F2C06175F;
        Wed,  3 Mar 2021 12:07:24 -0800 (PST)
Received: by mail-oi1-x22b.google.com with SMTP id f3so27363827oiw.13;
        Wed, 03 Mar 2021 12:07:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=c1MBOBMWN8XJxY79ciuSGoEQnkKI5LGY49UfY78oMr8=;
        b=QODXLp6ddfMYwkWjYVTmyqT7+ub9T3sXL6tzyA0EGoTTklzrUhrbXti1znhzEBusgW
         m+2eNzDeCrJrVK+HFM9Dm+8ve/0c2VtawvFf29AXk0djI93OKUwBn6+oZMkuFyKAW54R
         gF06jt3xWi+nWfzVvaCds+rbqbFOuRmZwAP463WG6aGJ1BNAgW0K5/ySQkDQWwUX0ioH
         kRMlokwam38CmsuHxLPnHad2hqTblw8DSKjUCE4Sslh8L05k4v4o1iPjdKNqLJfOlwdh
         q9BB5m8nzpqcj+KtaGReRfvuiKIajNOXzwgy0tn1//YiUPpRV4frKuttfJ6XiJCCSb0r
         QoFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=c1MBOBMWN8XJxY79ciuSGoEQnkKI5LGY49UfY78oMr8=;
        b=lb4PZxqhK7AdJ26l3gRSut5EyAsL8DMRdrw+ks2OEVXSlYaqc8TSiOn8ZFkGiyCpTR
         MAfIj4euSW+/uTtvaAOB+XTnOcoG1yE8Y0xkmqoKLq6SbPuklAmy81dDjIHPsw/EhX/q
         1B6etyt9y8yioYBoyOAi11BkNxwN0iIj0ZLR2igRocG0QxcXRT8kJc+rxIrPaceNU5iY
         W8rwRae7wjyt4NPzPIb9t2xuzMItdrRKBnaxcn7yr9wHlnjxHOxPZa0xkk6/ogJucegm
         FL65QGdgBHMZUBelJ9tUiXOwKcPMresTj3pO/WMlmUOlCwzfS0jRBg4as1Ty1EdfgzCw
         pxIw==
X-Gm-Message-State: AOAM531EhK/MEWKJC/fUbFOrKtjHnbAj8aZs1RVEzVTSAUOAMXnWKNve
        hB5U0sZup2MlWt/GxzKj9zI=
X-Google-Smtp-Source: ABdhPJwWrvLCknc5k5JT+HUW54oyu66KSaGFshhxWNtsrqZ0+7luE0Zn6kiTazNujcfDP9QdlVm5cw==
X-Received: by 2002:aca:3742:: with SMTP id e63mr442555oia.158.1614802044149;
        Wed, 03 Mar 2021 12:07:24 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id p12sm4931057oon.12.2021.03.03.12.07.22
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 03 Mar 2021 12:07:22 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 3 Mar 2021 12:07:21 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 000/246] 4.19.178-rc4 review
Message-ID: <20210303200721.GD33580@roeck-us.net>
References: <20210302192550.512870321@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210302192550.512870321@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 08:28:20PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.178 release.
> There are 246 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Mar 2021 19:25:07 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 420 pass: 420 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
