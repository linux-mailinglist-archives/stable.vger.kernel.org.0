Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E3FC3CC52B
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 20:05:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234272AbhGQSI3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 14:08:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234042AbhGQSI2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 14:08:28 -0400
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB09FC061762;
        Sat, 17 Jul 2021 11:05:30 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id w26so9705343qto.9;
        Sat, 17 Jul 2021 11:05:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=j7wxshbhAOOgEOPYYZAz65QNyVC6oy79e1hHBvzR2TQ=;
        b=fuTUCkKIgBl/k/kcOyuMVeIzl+k2TuJcJEEzgQULrRE5EfG2nSmtki3jQ25BVYLYMD
         zsDoXx/J+nZm+ch/s4a7fsD82mUkIxDApEAYQYpbYgwA5VMwXAKf8qI+VYYA/soyJFi/
         dRcxR5/iafgL27SiKMGX9BDbBuC/rwJlUyXt/h3KKo0sH1eSsvjJRt9ch5AcTnSWXlKf
         Z4dEmh23ndHsRO2nPzGL9KmWUU7ohl1/hqtmiPeSXAmgE3Nct+X7jOQH2iB6sYwp0r+e
         j8J5nC43SWQKgaPpH1vvGGtO3+B7DiMomatc3+NGK+LSzp7K1bDDFn41HtrZGv7Em5Ma
         PxlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=j7wxshbhAOOgEOPYYZAz65QNyVC6oy79e1hHBvzR2TQ=;
        b=Cgearv1Niq7f6RitM0L/mdcFGbyyXike2U2CfkINeBr9tKMhrXlfjECUky++77oTOE
         V5p0YkTECwNnWIsi6wGjQ08FV8so3A64DtI8Ua8aG/rnZHjOw13CrwWe5JtnwaWwRjy+
         z0S7FB0sFQwQuNrLQXiFbei+AO+SytEVLEIfcLgWW14tuv6Zs0eFJw12gFdCfeE7xPgB
         qiKbP/gNxnEDbqKj0oLuh2ytB9+sWxJ7MkxcI/GTNj44nu4gMQUOZV/GZGIKMazE3CVE
         vDQpiIOhmLBQwkca4Qz6WegUKsZtHrT8Zp3qu6iK9KYRiBgrKxM2WZ5iIuiiTeF14Tc6
         jAnA==
X-Gm-Message-State: AOAM533qhM9uvzutdqI8lzKYnX/oYxEdqH/sTymuC/jQbHoQSqyn8WUw
        SVF8OfZFbG1Ggt4+gwS6ZUY=
X-Google-Smtp-Source: ABdhPJzF9wZbKi8Ygs3jGYVC8f9hKZoMPYiZC1mwvUg9IhKXVCievBPqxqQZyfvehNxAzOAbOjcomg==
X-Received: by 2002:ac8:4a8c:: with SMTP id l12mr15204249qtq.68.1626545130161;
        Sat, 17 Jul 2021 11:05:30 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b8sm4658741qtr.77.2021.07.17.11.05.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 11:05:29 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 17 Jul 2021 11:05:28 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 000/258] 5.13.3-rc2 review
Message-ID: <20210717180528.GD772394@roeck-us.net>
References: <20210716182150.239646976@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716182150.239646976@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 08:29:21PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.3 release.
> There are 258 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 153 fail: 1
Failed builds:
	riscv32:allmodconfig
Qemu test results:
	total: 465 pass: 465 fail: 0

No new failures.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
