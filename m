Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD994308C5A
	for <lists+stable@lfdr.de>; Fri, 29 Jan 2021 19:25:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232730AbhA2SX7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Jan 2021 13:23:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232696AbhA2SXc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Jan 2021 13:23:32 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FB40C061793;
        Fri, 29 Jan 2021 10:22:35 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id i20so9506467otl.7;
        Fri, 29 Jan 2021 10:22:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=+I21eOiSLRngJWAIUlePcYeY7GSXghjzEMgNgEBbR+o=;
        b=E06vOaNC101fbEcxU1vMbw5UCNNMCTU8+99BG63k3lm0HAfMRJfFpc+x2xb/2VsKLU
         OVtWU5sWpF2sWXKnCdSo5o2e2rduFPnRsY1Quz/0LjgGij90/qYhIcbAH3/zyIUdau/y
         8Zx7qt7qLeBvmfKlspPIc+O+AgSvNEj/uN+w111Ovy2x0/SQVkLYQdzZgQzl2Jwm1DYq
         eG7fm8kZNZlQmYT/7LkOxrurOAe0mZk4Yoe+JI5m2TuZWeB0DZTKrVZ93AiwAenjzxMu
         1L5BB2lnT22PGnUjJf4WhQ2hS0MDtogz3+JNnCXdEpGIR+bKFPHQzalJQhDmo3RNzTRv
         kEMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=+I21eOiSLRngJWAIUlePcYeY7GSXghjzEMgNgEBbR+o=;
        b=h+3gldsHnf1onNCsR7cFMLqPfpnjWSiuC9BXsRf2khkh4zRpgiEfYuWbaro5+Ovj49
         hVnPIyUi3rwou9PnIAEgx0AcvugK1k1gn9Y8PsFUj6aehjr+599vvV2z/pxy3xCi6IJs
         N/OYpElACDd49BtLUx6ol5XnJWdMOmXWUJTCZ044sx+O6EBuRU7MN9xwKchDnGM4Esdk
         ThEngA3WTJPoxrijCDLvdPCBHSkxCzQbVw8gFliyg+M9HC6lz2mNXk0vkd7nzDy/Rhdt
         qW80YYR+R1Ss9Lh6pMfP3eiYVH1ekJzt1mY8Cm83ftwe9qU/+AJPKE0pI4mooPgjQwCS
         VjnA==
X-Gm-Message-State: AOAM530KeQEox+4toPDwsXr4pxepe/y9a7cKYyiWZPkQD4gF6o8Z2RJb
        tYX9ME/YkX6WG8eznEGFVY4=
X-Google-Smtp-Source: ABdhPJyS0R3lgIbq1ctvEyRJNatqvl0XbFQiOso41g88R5lkqtXkjJYkSt4lb1xN2EKd/Zyr/r+NrA==
X-Received: by 2002:a05:6830:13d3:: with SMTP id e19mr3705580otq.157.1611944554541;
        Fri, 29 Jan 2021 10:22:34 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i26sm2436792oov.47.2021.01.29.10.22.33
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 29 Jan 2021 10:22:33 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 29 Jan 2021 10:22:32 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/26] 4.19.172-rc1 review
Message-ID: <20210129182232.GD146143@roeck-us.net>
References: <20210129105910.685105711@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210129105910.685105711@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 29, 2021 at 12:06:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.172 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 31 Jan 2021 10:59:01 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 418 pass: 418 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
