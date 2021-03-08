Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EEC5331A2E
	for <lists+stable@lfdr.de>; Mon,  8 Mar 2021 23:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbhCHW36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Mar 2021 17:29:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230342AbhCHW34 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Mar 2021 17:29:56 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC8ACC06174A;
        Mon,  8 Mar 2021 14:29:55 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id w65so12733857oie.7;
        Mon, 08 Mar 2021 14:29:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=hGlsdkJu1W2sJUs3QO8VEczlnXVYXOCy18Ok9D/ssU4=;
        b=AJ276aoiHbwTsBKH2gTC3bFt1Fci4IAWMOEzmySEEoBri+mRlwIkeYuW1J885Sh0xO
         a3LMmj3tqLOvFUvC2QTgvCK8UbwLFmyxhyIxcZ0BMQMYOk4POITwPCHFf4hOvYPBAWus
         n0HnsR5jJ4Zuw0yLojpzFnvL4VtPnNxKi9moRHb8fTmWsEbZ5jix49cYRsMCMTwOooWb
         3CZzikWJtF9csT010/Cq1C2hQo+mu6YJnUjrr1qxEGOPR/Y63QV8YUTYvzCxwoSsOAuw
         oJXcxz+tO616+A8mirZLc7Bb1k36pzeeq1GEpZQ04t1A+LgU0w/hcGn7vltifL0WDCqM
         EPNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=hGlsdkJu1W2sJUs3QO8VEczlnXVYXOCy18Ok9D/ssU4=;
        b=Ka1PIdkj7toVAkjgWzK6IFDoXIUWvjVKlG1Gi96wcmCvC9UqD+PJpPjLTaL4mZoa9X
         iJSJxv+0Yn2AQ+2jCi/oCy9aUG7xjAinaiHEjVp8PiBqOC6/eFP3sw2gqmXGro2QLJ49
         IrpMbLMJLvt+VgYcxj2K2ZaK3Yest7fhfe44E6xkpfW87wdyBNi/PGrGOrWiwXgZkhjy
         Bmv1Q6G533AOD8d76ijrVmlpWH+sklP62RbKUGOavG8bY3yvAJkxRetBYs7QLZ6Rb1LV
         4CxbzBNlrYu6YE8Y+QNgLap8Mqr4l/2u3t2f6PHiIkL9GVV9l/Uxj48xvlxyyDSCY5RM
         vGgw==
X-Gm-Message-State: AOAM530kTZ8BlXnEST2KCd+if3jVMqXnH4l7IiSZmCydGJptJ22cA+em
        WkL6v6j3I2JRw3pxjXpOqp4=
X-Google-Smtp-Source: ABdhPJzmRJZHQUmUwV+gFs8cvSFl1bA6JucpLLuIpIlaSD79YaYILFZHmGV6tDFQHTE3mCxCxjJH2g==
X-Received: by 2002:a05:6808:bc3:: with SMTP id o3mr824329oik.134.1615242595406;
        Mon, 08 Mar 2021 14:29:55 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m8sm2936523otl.50.2021.03.08.14.29.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Mar 2021 14:29:55 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 8 Mar 2021 14:29:53 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 00/44] 5.11.5-rc1 review
Message-ID: <20210308222953.GC185990@roeck-us.net>
References: <20210308122718.586629218@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210308122718.586629218@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 08, 2021 at 01:34:38PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.11.5 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 10 Mar 2021 12:27:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 435 pass: 435 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
