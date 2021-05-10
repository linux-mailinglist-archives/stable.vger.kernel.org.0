Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80CEE3799CA
	for <lists+stable@lfdr.de>; Tue, 11 May 2021 00:15:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231400AbhEJWQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 18:16:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230136AbhEJWQk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 18:16:40 -0400
Received: from mail-ot1-x32c.google.com (mail-ot1-x32c.google.com [IPv6:2607:f8b0:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208DCC061574;
        Mon, 10 May 2021 15:15:35 -0700 (PDT)
Received: by mail-ot1-x32c.google.com with SMTP id d25-20020a0568300459b02902f886f7dd43so2414021otc.6;
        Mon, 10 May 2021 15:15:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=2Gcj00cuBmY81XYE95k0HpmAkZGRIejMfib2zxca4pc=;
        b=dwXJ1N8487cr86WAxN31AZX5P8J1N/dDH3kb1wcBqy4pZ1zFxO1T8z4paUMeGs/LVf
         Dz+BKI/PI6mw44iOnkehNHE+qKRhCCG3JL0ByRNRk3u/++uIOV+ho6NTeUnQQwfEEbUI
         TTZK5zpp1EdCSPmvNcwKyKa9HK2j7H+jeX2ukzEiDU8I1mmIdJUY461/IaUeu4Y5M2IS
         np1BSoBHZkuU9lVlXv/wzKktqdCs2dAvx15hzRtbpG7r4JFKHQaQGbqyKIidv6s7jTTR
         UadYw7+2jrEeqBBly15OcdJk/PIPN9CAi+U+jHPgCbupnlSO2LhmjoEix/49CjHPMgLA
         vgeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=2Gcj00cuBmY81XYE95k0HpmAkZGRIejMfib2zxca4pc=;
        b=OSe4+oyiqEYfAJF2V/l46p2RWP+3G45ZLBWgEi54XVDOyq0851Zk4DRdBHtUb9s86V
         Gj+YjVd9IgX8OYazyAy35o8INPfUSpsC9agDYcxV3U3bafNAI1olXiLIjsKJJ73nt/NN
         6BWZQR1Xeiu8Ct2IECT9hnqVIjcL3YYwo3roIJIVsBQkdas26i5UjmA4EH7+YyZIZ9OA
         3E1GbUjPTaYFYRIPR3C4IFWQedFOC1PySU7hi0IZRS38fh+1R/g+HHfBhJ7D5hJJ9YKO
         T89R/CZiRWSvDBT8uXp1AH7nvvTmh3NT8EwQCfll1T4cpdDzqJI2LZ4kSjaDGj+ttztJ
         v6zA==
X-Gm-Message-State: AOAM5330kzpU3x/B7xFHNb4jXfWnX5e4tpc/LOhFEJ8Of4uowL1m+vGk
        zlxP1Z8osmjpBtMmoxvQ17c=
X-Google-Smtp-Source: ABdhPJz1PDgi8DdUr4K6+WwB0CVFomWQtsi78XarGh+y9kTdF6dyZX1fZ8h3Q3LP6SR1HhrSBSo0Zw==
X-Received: by 2002:a9d:7997:: with SMTP id h23mr23438326otm.366.1620684934620;
        Mon, 10 May 2021 15:15:34 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id y5sm2898281oig.18.2021.05.10.15.15.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 May 2021 15:15:34 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 10 May 2021 15:15:33 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/299] 5.10.36-rc1 review
Message-ID: <20210510221533.GB2334827@roeck-us.net>
References: <20210510102004.821838356@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510102004.821838356@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 10, 2021 at 12:16:37PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.36 release.
> There are 299 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 May 2021 10:19:23 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
