Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 400163015ED
	for <lists+stable@lfdr.de>; Sat, 23 Jan 2021 15:36:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725984AbhAWOeV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 09:34:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725935AbhAWOeU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jan 2021 09:34:20 -0500
Received: from mail-oi1-x231.google.com (mail-oi1-x231.google.com [IPv6:2607:f8b0:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60BA7C06174A;
        Sat, 23 Jan 2021 06:33:40 -0800 (PST)
Received: by mail-oi1-x231.google.com with SMTP id h6so8161729oie.5;
        Sat, 23 Jan 2021 06:33:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=7b4ygAp0CUYJZu/XVNRrGWHKjRjKqVXmcebsLsvfSGw=;
        b=V+tcIxtdlkjAHrgTjmHzQJuzWYTjKMuMJuUmM30q6gpaXlVmeZ7yKtRr/9eZNxJI+H
         +D2SPBNxPO5vCwQXbywA3hpJurgqZ69w6Lew8dzy0zafiSE+jFPOUuSE5ZN4DL7EW5BM
         Bd+KwS60u+YGDeJXUXATo2XZi9SI77Yf/Oczivxa32wrHs0ecDCNrmJpodUz5WuNyR+L
         qqGZzgMbKPz265RgRfmwvdS1uiB7IN5IjLDpoLUYIQfh5vr1kH9OyzS1PDM7NViz5LKS
         f+9KMZ8A+Ml9s1IIC0J07tvxiDr8gHQuA3nxwCM2Y/caW4hwv1AECU2zm9ipaLopCcze
         88AQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=7b4ygAp0CUYJZu/XVNRrGWHKjRjKqVXmcebsLsvfSGw=;
        b=oiFhESmmklSFQK0y4AVjNgz52akffmF4u8DdskpqxLmEbvzlge9X/2apRKgWq58wOp
         6Xzu/SzcOrFVBa2+7exFqo+EQ8VxDEUPx4Xj6zdMgSiqAswek/AZQaQ79A8czRcCcjJv
         DI8t09fA5wjwFkL59S0uHojM4bNp44oSadmUD79Rl+IunXaNFOAaC5/YyaSaIYqAdBWF
         pqwz/EzPdcBZkvXmhkfbEgqTG5K7swj4dsCSsIBIChSHFRwT4lYfH5xBssUbDBObw8gE
         ALu8oDXe/WDORoHgK0gnunkPU5PKYc5emVOS1T0U2forM5znYmb4VfayB93WEErInjTw
         b48g==
X-Gm-Message-State: AOAM5316Mm+Hio16h6vH6ZFmt/vDxbe86QaUOFMqXs/Tpp5W8Gzms5g+
        0p79gpAgFRB2Mr2FslE/bu0=
X-Google-Smtp-Source: ABdhPJyOgFNQdTSU9uFYQflPtGZ9LHkF14KBuPbQKXzkOw3v2WOntBAtztGK1PpBv5ThK8lyXhJhOw==
X-Received: by 2002:aca:1a06:: with SMTP id a6mr6329498oia.29.1611412419840;
        Sat, 23 Jan 2021 06:33:39 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d127sm2206627oob.14.2021.01.23.06.33.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Sat, 23 Jan 2021 06:33:39 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 23 Jan 2021 06:33:37 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/29] 4.4.253-rc2 review
Message-ID: <20210123143337.GA87927@roeck-us.net>
References: <20210122160822.198606273@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210122160822.198606273@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 22, 2021 at 05:09:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.253 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 24 Jan 2021 16:08:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 165 pass: 165 fail: 0
Qemu test results:
	total: 328 pass: 328 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
