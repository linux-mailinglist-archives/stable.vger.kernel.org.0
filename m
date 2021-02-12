Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5395731A440
	for <lists+stable@lfdr.de>; Fri, 12 Feb 2021 19:08:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231574AbhBLSIc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Feb 2021 13:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231649AbhBLSI3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Feb 2021 13:08:29 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2475BC061756;
        Fri, 12 Feb 2021 10:07:40 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id l23so9180835otn.10;
        Fri, 12 Feb 2021 10:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=/6lubjhkqAIEf66nHQ+jIqqmUQSsup3QTHClxceqdFQ=;
        b=V8p3UNnXQIo6v5Py9Ep+xKjjm91Sw0tdnbSaCiJioYLd/fEbAdo1ULMcTtnnAPAtgG
         qEePifNuHwk85qXizmtfk0TIGMWaXPWiwFltT0hZ8XASlvTWO08kY0SlPlbyupw202xH
         fJYzbVDBMgoqWBLvh+8m6am5ZsrfkqqSz2ZNyOlzdeN7Ao5qWswGTjfiBzGkocwRmTn9
         A5jOe8UBFPzxDJO8lnZXiWx+XHCNyv21RZpDA4uJROUr65hxgzv4pAAQ8tH5j1ZUcDSL
         eoP10YcEMjMjic8zK98IYjONID1qkuD5aCrDzgF745krWGnJj2NlwkHsT7pSNx8zc26/
         bn7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=/6lubjhkqAIEf66nHQ+jIqqmUQSsup3QTHClxceqdFQ=;
        b=d6VyiUul9sThdgWSzoM7Cn7NH95PeaHBXuf1J0E3wUj8uTnnR+LMV9cPcI1VsVAYGM
         2hhOsoialar/0FEnuPwxszWPcZ5fXvAILRnBVDJv6NSpytWMsurhbvf2ZQo0riNRvDTL
         A8BbTNMJafYPg2w+Cus/TJ5Z9mDPsHjJcElm1l+p141pLzmG3LRznklMXxwsPh4d8En2
         ZNol5TPEmcyOZRtCz0oEvsr3Ax7rag/g6sUTYqkg9ibjTBQTH/p0OhwiKegDBBI6Bgcr
         ETqEkcEl1bKMQJPhKSIagkWTm2yE9R0NTYqUSJkE0YCLUV9HAIWDdWX5ujhUCR/5dg1y
         SHOg==
X-Gm-Message-State: AOAM532mhRTGd+chnOAfnV19Wdz+zJY+2OG4XvRCZrkmbU5s6ZIa9JMT
        00tCO1pfnsYX2tFbmigOLzbgOBEtGkE=
X-Google-Smtp-Source: ABdhPJxWBzCZZ2B+p7DmbvIwTZHOF0ayPrqc0r+6HDEf1NttMQ9oi+oMNseTKuJQTET/Fn0WOCnZ0w==
X-Received: by 2002:a05:6830:1b72:: with SMTP id d18mr2901365ote.228.1613153259530;
        Fri, 12 Feb 2021 10:07:39 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b9sm941165otl.14.2021.02.12.10.07.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 12 Feb 2021 10:07:38 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 12 Feb 2021 10:07:37 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/27] 4.19.176-rc2 review
Message-ID: <20210212180737.GA243679@roeck-us.net>
References: <20210212074240.963766197@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210212074240.963766197@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 12, 2021 at 08:55:04AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.176 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 14 Feb 2021 07:42:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 418 pass: 418 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
