Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1FA262EF6A3
	for <lists+stable@lfdr.de>; Fri,  8 Jan 2021 18:42:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728395AbhAHRmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jan 2021 12:42:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726011AbhAHRmE (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jan 2021 12:42:04 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF329C061380;
        Fri,  8 Jan 2021 09:41:23 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id r9so10344106otk.11;
        Fri, 08 Jan 2021 09:41:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=eilUWP5R4wV4MoijQE+EsVa5yYDOaYmTSkLVKYEjl2U=;
        b=t8/s63C9zg1APlDSvbhu4E55I8gB9DTCb8v9zh5JSZj/pMFF1FP7xtGjSQkp2Z5zlF
         XUSlru64m6EqBG9LnWcExpvwrwfylKYQMm9xEAagqwmL3N6OPGjf0V0ZQJ8FFqj9n//P
         uVH9jrfhNyoVQAQMWqacUDX+EsA6rKDSYikNbjNGOFHC/81y2vsQt/eZuWeP2/agkxVG
         w3ppxktutf+AM+/Dkxcf3r42Yowu+sRgJcr/Qi+ov3CW2y9bPQByE4nww0jdCZCzr5GE
         szrH5rsjKtCX16xS5YyiM8GrmxBw5nvj2/D48nkMtDYrwak3H8Ie5I2UohdV57o2u90l
         wVBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=eilUWP5R4wV4MoijQE+EsVa5yYDOaYmTSkLVKYEjl2U=;
        b=ms7mxWAxsr2/YI89j4054+7G3WeaiWCEYnBPproSap/D1uf7t3cALVoq6ea0Exv6l+
         8js3K3txOv82ZkId+NmUPk/QQESaYoXwWrB1LZC8XgbX/0NoOt2OBN2PZvLRpIcZsH02
         DKVXvapBAnCKGfJms8HS05g9+9CwoDOOv/Nwqh5M/ixeuZjg3227rTtMH7WTYHZvci+Z
         wVYNy2ryHolaD47EO+5JpZDCHRBYuHhrz9o4UbH7uevMk03eRTuvEKmEwv6vfrHE4xDI
         w1FDu9ofeNSKe7Nm9bfwg9Muuhj7bSA6EVWJ8qJF5OCOe+68EAdHz5WgWfCrw0S9iVwS
         FC2g==
X-Gm-Message-State: AOAM530JwJtSjgsQoGPdYFrZDNH7MbqslvRzxjFGHmoN2NkWvmoopKKC
        S7E2NRTQNfkojci2uFI8v6A=
X-Google-Smtp-Source: ABdhPJwAPkwu6SqOpD1KsEien74X5L/V4G1EgC4lwXdvdaEZvOtxYeDJe2bjwW/4+ZnJuq4GFx7rDA==
X-Received: by 2002:a05:6830:1011:: with SMTP id a17mr3328682otp.97.1610127681820;
        Fri, 08 Jan 2021 09:41:21 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 8sm2136594oii.45.2021.01.08.09.41.20
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 08 Jan 2021 09:41:21 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 8 Jan 2021 09:41:19 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 00/20] 5.10.6-rc1 review
Message-ID: <20210108174119.GA4664@roeck-us.net>
References: <20210107143052.392839477@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210107143052.392839477@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 03:33:55PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.6 release.
> There are 20 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 09 Jan 2021 14:30:35 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 427 pass: 427 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
