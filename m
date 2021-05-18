Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A475388211
	for <lists+stable@lfdr.de>; Tue, 18 May 2021 23:20:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352453AbhERVWH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 May 2021 17:22:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236472AbhERVWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 May 2021 17:22:07 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14A39C061573;
        Tue, 18 May 2021 14:20:49 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id t20so8644454qtx.8;
        Tue, 18 May 2021 14:20:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=zzExhpuG9xrx+5ygEhfYQTdPQOez+oeyluEKF4Na9zM=;
        b=oy+twmjrNxzK7GdlHjIuYEcgQ8uobX+thy47/6v8RWwLnWDTGt1U6DDH2mA4m14rEg
         d77O42Y4qgw0SDdEah/iK92rkVnxvn+xT4KSJAWOXUkw1xlk1r0AtkbRkAvEnfsn/E7b
         77CAH/y+3bt5F9nihZUK6hM8CeWwW1Uv4Mca2AztRNihnHxt2yTBRjuUrGX/DflgLM56
         XX60sq00AxT6GXwScEvlGDXJnBpqgg6D2Q1UO5ct4t9oMLbhSnZWgy/H5QzHapS/bGhI
         IJy5CFlXSeaG5+q/56LwgbD3vYowcSJD4e/bHFpwPYZxYeBGZ628mv+B4EaPtDMIgnjs
         0P4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=zzExhpuG9xrx+5ygEhfYQTdPQOez+oeyluEKF4Na9zM=;
        b=uLQkERk10EyBkOLv7edfk7o/XvguqjEA8T6DlUq0XblxiTFGwSTuY8zKldWS4+GHuO
         rf0cXEAkAEK5eOYrBvMUmWmTNBoP9H5Vx0Dodkyi28zJx4+J5KeDrF8VVpcWGKXmgB+4
         YWaHjf8BvHJmVUHs7V5iPDBmvxY4oBeNj37zFcZ1ZRtwVKGiWSJrPspCZC3RC/Ac+JdG
         gFwVOZThesyDfLLa2HnmNyTLlDM2nPsmFEZXfoC5N4u1zoQEf3rwm09NYr4xfY9r89nF
         TUKckdP0OIwSgEablVYuj2oUiQBcfFZIHKgGyn1GvDVu+erbmYGn0TubvRus/g8aAxFP
         XkDA==
X-Gm-Message-State: AOAM533dn0QzZ1MaRtjvpQDyct+5RqLHWYPlhh8J4XX8RBdhzJvmqjdl
        /q1qxlJX6z9XgJF368XOUqDV/1hmKi0=
X-Google-Smtp-Source: ABdhPJwdtfJKFeevJCcDfWFdRe+iFkYA+wsxjTVmy0aSptaS9XulKNf+iSU4R6gIKzuUUY2gtTivKw==
X-Received: by 2002:ac8:5886:: with SMTP id t6mr7324572qta.212.1621372848396;
        Tue, 18 May 2021 14:20:48 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id h10sm14059738qka.26.2021.05.18.14.20.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 May 2021 14:20:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 18 May 2021 14:20:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 000/329] 5.11.22-rc1 review
Message-ID: <20210518212046.GD3533378@roeck-us.net>
References: <20210517140302.043055203@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 17, 2021 at 03:58:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.11.22 release.
> There are 329 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 May 2021 14:02:16 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 461 pass: 461 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
