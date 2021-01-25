Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388C4302C99
	for <lists+stable@lfdr.de>; Mon, 25 Jan 2021 21:35:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732155AbhAYUe6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 15:34:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732216AbhAYUSu (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Jan 2021 15:18:50 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A25DFC061756;
        Mon, 25 Jan 2021 12:18:09 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id g69so15356517oib.12;
        Mon, 25 Jan 2021 12:18:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=T76zXLihM3diqRLtZIwr3s1pIV8slciUw1jl5T7rp2k=;
        b=K1aG8r0xtnUduoJ378Az/Ll+cK46hNzfniF1kLO/eIfK5oTWlgK29czxbEyQSEWQzv
         AV7K6OP3yFnq1EAt4zpz+TCEyp9wqpa3qFZS/RuVHDLyAeLfdt7G9QUPIBLIhx12NaHb
         +cvCzY/XQUg+RBrhOQ93li6C2A76SLGF0cw4fJUpxPYQf79PignF/2Is4dSV0oQJNnxu
         rpQcsqCFY30Y2b7xgZFWp2zXZ44NzpOZv91Ew57nEg3DMfFuYBpWA7Lpu5cEKrbHmYji
         ambAVCTnpM+nsMX4rf+CmDy6MFRjrIjg+BnxjlSNp0cL77RRVTySyKjwSq3WUMXUtxOw
         8ZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=T76zXLihM3diqRLtZIwr3s1pIV8slciUw1jl5T7rp2k=;
        b=BrsZTAe4MDOtT2V6Dr+MZ+b+A3HzcPyO6nRBkmw8JLQZ8EOdNCB0JGMwWg4oT8iP3n
         DP3y+DVW7FA2R2yB02Hm6DYeRU2qUHakLYNqHZPbJ2AXZkSOhSfnbaR0c4H7qLA3Qext
         LmlrNPOMFfQzybmtStgV45WJJPhHBlVsW+qCnOm4cAOEYdBTs4mbURFjhhfw17GZ5rXf
         A41gOb2IUS9E4s8/1TvoSIcPBhFPgvjQ7UMWOzwQmeJBSk9OymiGBoc1yfDtuV47QYlR
         Pp2HPcwTxIZzZkIuy0F8LlXNa0zXoybNegB/se26ds1F5pe5/lCSbJIZSjR3QGSAyook
         z8+Q==
X-Gm-Message-State: AOAM530vjUxwLXb2CSVug7zNcJcLPu+mpQXhne44/ThKwiWuEZFQ25Tl
        v7505GXH6qgyvZZv7P0ULEU=
X-Google-Smtp-Source: ABdhPJxJj/WRS/F7K4xGjTWcdjNiBM17xYrsbvcw3PGmWj4pzSUlZ0atmhluxxp1xDNUKEOxGJS+sg==
X-Received: by 2002:a05:6808:a09:: with SMTP id n9mr1189205oij.26.1611605889041;
        Mon, 25 Jan 2021 12:18:09 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c18sm2225899oov.20.2021.01.25.12.18.07
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 25 Jan 2021 12:18:08 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 25 Jan 2021 12:18:06 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org, pavel@denx.de, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: [PATCH 5.10 000/199] 5.10.11-rc1 review
Message-ID: <20210125201806.GA78651@roeck-us.net>
References: <20210125183216.245315437@linuxfoundation.org>
 <ef5b0670-83ea-e754-033c-2f3f56a8c822@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <ef5b0670-83ea-e754-033c-2f3f56a8c822@linaro.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 25, 2021 at 01:36:03PM -0600, Daniel Díaz wrote:
> Hello!
> 
> 
> On 1/25/21 12:37 PM, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.10.11 release.
> > There are 199 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Wed, 27 Jan 2021 18:31:44 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.11-rc1.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Sanity results from Linaro’s test farm.
> Regressions detected.
> 
[ ... ]
> 
> Errors look like the following:
> 
>   make --silent --keep-going --jobs=8 O=/home/tuxbuild/.cache/tuxmake/builds/1/tmp ARCH=x86_64 CROSS_COMPILE=x86_64-linux-gnu- 'CC=sccache x86_64-linux-gnu-gcc' 'HOSTCC=sccache gcc'
>   /builds/1nZbYji0zW0SkEnWMrDznWWzerI/arch/x86/kernel/cpu/amd.c: In function 'bsp_init_amd':
>   /builds/1nZbYji0zW0SkEnWMrDznWWzerI/arch/x86/kernel/cpu/amd.c:572:3: error: '__max_die_per_package' undeclared (first use in this function); did you mean 'topology_max_die_per_package'?
>     572 |   __max_die_per_package = nodes_per_socket = ((ecx >> 8) & 7) + 1;
>         |   ^~~~~~~~~~~~~~~~~~~~~
>         |   topology_max_die_per_package
> 
> Will find out more soon.
> 

This may be due to commit 76e2fc63ca40 ("x86/cpu/amd: Set __max_die_per_package
on AMD").

Our patches robot tells me:

SHA 76e2fc63ca40 recursively fixed by: 1eb8f690bcb5

I don't see commit 1eb8f690bcb5 ("x86/topology: Make __max_die_per_package
available unconditionally") in the commit log. I have not checked,
but it is at least possible that applying it fixes the problem.

Guenter
