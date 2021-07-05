Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F603BC36C
	for <lists+stable@lfdr.de>; Mon,  5 Jul 2021 22:38:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbhGEUlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Jul 2021 16:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229794AbhGEUlb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Jul 2021 16:41:31 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0341EC061574;
        Mon,  5 Jul 2021 13:38:54 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id h9so22048692oih.4;
        Mon, 05 Jul 2021 13:38:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=YlmDK1B+K9QkhL4AqthwmgF36JmtP8IbTzramKBN7U4=;
        b=eBNNmH7q+9DmpArt12JIgMzhjmHXyRgSnNiWv6P0/R+KTiNNAPnvqHgNDkfJdgmSAm
         qchoNYxuy//afxLQAniCaQahw5GEVTzdbLDLeAbkLgrW+uoFDtlj2t93l9JV9jYCBMdu
         dhINhYzOXs4gjyGVF0uyAfxAOlYgP2uQ3GEw9mzmmNpMNeWk2CAaobB9Om3vIOEjit5D
         RArbjjQUdISON6IKkkZtZjuMJN5Wj4TACU+/x1BTXKdwke6PmK/d64JpVsj0/71lMgUc
         racYa9J9k9tBnpz6LKUpxhB4BgYfUatHQYc4Lmlz0D5MzuhNy4qH2PlU1JgZpblmI9v5
         zV6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=YlmDK1B+K9QkhL4AqthwmgF36JmtP8IbTzramKBN7U4=;
        b=j191FhoU2EAZG8XX0q3IdJCMjcRJg3Jvz//t5PC1Qgth9DHWCMQCRKf0WjJ+lxJt5x
         0aX/92f9N/3GFj6dXb+dU+x49LgJ6Msqlg9r7yyyxDCZOgG2BRYKN3KDMUxG4D/w3zdA
         PJSwRNGYbzkbS3V2oFEZoYLri88baXicMQwT8uzEitvciwnbCTbqoY8LpZK8XfeA1Cpp
         5gK6n27rwhE0OpQxZA3cmZyJS2q118TRpl8Lg9kcjOQH9CKlDsrsVhUXKVFh/q6fK3Ou
         k/k+AJ/i/lXyq+EH5FY7Bn353eivzOpWYJRHoSLc+rfH8NzhL06rwYdtFwvt5Nl7Bkpz
         3UKw==
X-Gm-Message-State: AOAM5319LxM+2dfGPvcMW1BQhzKtKz0HVzUeHkecM4LBkEqa1Y0Gs5sy
        Q+wCYJqkCCvIq2uVtuXn+Ig=
X-Google-Smtp-Source: ABdhPJx+w1tYhVdcFrONsUb4HULKdzVDO2GnON9TXn+RmzMawmCcju/tfo86KdeyiHBirp7PWNzsAg==
X-Received: by 2002:aca:b18a:: with SMTP id a132mr717491oif.30.1625517533401;
        Mon, 05 Jul 2021 13:38:53 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id n65sm2799992ota.37.2021.07.05.13.38.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 05 Jul 2021 13:38:53 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 5 Jul 2021 13:38:51 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de
Subject: Re: [PATCH 5.10 0/7] 5.10.48-rc1 review
Message-ID: <20210705203851.GB3118687@roeck-us.net>
References: <20210705105957.1513284-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210705105957.1513284-1-sashal@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 05, 2021 at 06:59:50AM -0400, Sasha Levin wrote:
> 
> This is the start of the stable review cycle for the 5.10.48 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed 07 Jul 2021 10:59:49 AM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
