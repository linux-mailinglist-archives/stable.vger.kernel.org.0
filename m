Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3EFBE241C47
	for <lists+stable@lfdr.de>; Tue, 11 Aug 2020 16:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728773AbgHKOXC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Aug 2020 10:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728717AbgHKOXC (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Aug 2020 10:23:02 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0BF95C06174A;
        Tue, 11 Aug 2020 07:23:02 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id u20so7703580pfn.0;
        Tue, 11 Aug 2020 07:23:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=5k6Pc5dkzPfkNmlq1tppZl21+7y9MuaCgsu7Iy0Ocd0=;
        b=obdebTUZFdkdo4fF/KBdSHaMFVt0bKml5BIqF6gx1dyUSfx/ENERz0RcFJctUK9Bhf
         Ttlh+CCyD63T0s/I6sIh05iQijfUQ8SZyOEHdGnL5mKsQJc5xNApueknoVl7y1Wzs0AJ
         uB0YYI/FkobdD1DL8NHSiA7f16kNJfwPLJHP/0/TD8KhZwiYXCaint1ytuPBVX7Zysc6
         /u4y0q3bj+Nk8+7NHM7YpHpDnUeE6M/82Z8ZaOGVK682L6bNzRmQCEF+xgs7yh12kb65
         81fTQsb5YMyBP13KFeN4SV3kbaPxALQKa8rtJXCXTwLjo6/2bna3SNHpmK+rwDiVZake
         G20Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=5k6Pc5dkzPfkNmlq1tppZl21+7y9MuaCgsu7Iy0Ocd0=;
        b=DsCOmo7ZoWXUwz8Epfw52JTZYQT4Nw9tYJD9YA5CnWN87+X9dvJ6Y0TmpxbvfF1ZCM
         M6v66pjZci+r/CQu86uvwXgr7YGYm6siOvLfcQPMrz5dmB0C/wuahyofJgP/HhNf4v8j
         rxV1fqnQPzpxNXQvlZaL3HVeTIzmqVSMEsXumaN2G88/SkwiZJbzUqJ8bCOGExLlbabO
         gOMljAi+swdyVSql0z7+jzmOSYqNuB5xZiIvhI4EJYTRdW4Q+bVsMtnZ8Z/V4eeH5fOD
         3x56QHBjFMptYTf7Ki4hT2YU2WK8/9zeKw1lFqr8E9dwCDA2a/3kcfKNlPObh/4i7HQo
         GSQA==
X-Gm-Message-State: AOAM533eezjoZ40zoh6I4a6JfU9gxZsgCibeT7gfjl7EiFayQhTC9dcp
        suUOQZJzM8VBIOp+BELNStcHFwVN
X-Google-Smtp-Source: ABdhPJwaNbW1QI2zQ7h0MKDVppFJZRJKJ6IZtCwV9cQh8b6YjZYJau9ZcoGwky7hrjuBtzA+BjWSbQ==
X-Received: by 2002:a62:3583:: with SMTP id c125mr6723906pfa.1.1597155781579;
        Tue, 11 Aug 2020 07:23:01 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id m23sm21095809pgv.43.2020.08.11.07.22.59
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 11 Aug 2020 07:23:00 -0700 (PDT)
Date:   Tue, 11 Aug 2020 07:22:58 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.19 00/48] 4.19.139-rc1 review
Message-ID: <20200811142258.GA195702@roeck-us.net>
References: <20200810151804.199494191@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200810151804.199494191@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 05:21:22PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.139 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Aug 2020 15:17:47 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 421 pass: 421 fail: 0

Guenter
