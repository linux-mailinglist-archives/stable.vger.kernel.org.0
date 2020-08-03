Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F33BA23AA00
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 17:58:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgHCP6Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 11:58:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgHCP6X (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 11:58:23 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFF8C06174A;
        Mon,  3 Aug 2020 08:58:23 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id w17so20893350ply.11;
        Mon, 03 Aug 2020 08:58:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=uNcX+w5uM4upQQA3Q+enW7rhMX5vu+tOoGt/oT0GACA=;
        b=jw5pRmV9q6/UvCiaUhYwloQRKVn8t/5dmLyXg3Efzy5/vKGDlYI1ercQIWgjA0zpAl
         ab2Ad58P29yddolAAqK0zI0w4+Fd2akKc0o3sRUbMhJybq2g4Vmt+Qi7Ea+fPbBHHjL+
         yHmU5mDakyOOY7GVDpUdgImlO/hsIaLkt03JRSo81YNAQiSuqmvnm/s+AIxpbvGUts12
         qJA2UKxYzH7SjsiZLS21otYRPGWp47UNoONIg00DTu7noD5kRrvyNOl5sA/8wCBLDa7F
         F46TYX4BF6u2pgbI0XMyykvrPqZdC+rl6QEscExSJFLjZ5vv0hkt+/9x9XmvBW0FDkW9
         ZSTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=uNcX+w5uM4upQQA3Q+enW7rhMX5vu+tOoGt/oT0GACA=;
        b=mFEb4mlfwOArdiv/+3wXys664id5zEoY5xZzZCcEA2U6vWrqnJ1enOHF5uh7QrLCvW
         B+sGzgUTsYMgEa0/k0i5MNfAiHL3ghjc8IINfI8yAZlUFnOG33IHwJJh1CvBRy6VGZzz
         QH8bIoD/PW9a+Wd92Gkd/vbfW3wWTUDyYxDsNkDpIJepyAvXnbjeI2FqBdO+N0klSZr4
         cD5fpYzp/gGo+UPxotNhTichfuweFwVUP12ngz5opcoQfyJVWuX3yqwVytPs4pr6vxk7
         rFPgvggkqi1/vooqypO+U7Fb8BJJWabcSpML3YhOdyb/Dme+46VHUdeVRfCWFfRah0og
         IFvw==
X-Gm-Message-State: AOAM533tNivxj1uQdU8vkxBLODyJxokTdvF0qJ/RZ0Rto2KryBgjxKT7
        7Np4uKMttcTaAWvX8FCy6/I=
X-Google-Smtp-Source: ABdhPJzAC/Hkdp9eGSxOKQDvUjMdkM74ZCW1KpdISI5JmiVIczYDHX0LyNKJ/dbtHAzPETGKwK9yRA==
X-Received: by 2002:a17:902:a418:: with SMTP id p24mr16008521plq.55.1596470303083;
        Mon, 03 Aug 2020 08:58:23 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x7sm20131022pfc.209.2020.08.03.08.58.21
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 03 Aug 2020 08:58:22 -0700 (PDT)
Date:   Mon, 3 Aug 2020 08:58:20 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.7 000/120] 5.7.13-rc1 review
Message-ID: <20200803155820.GA160756@roeck-us.net>
References: <20200803121902.860751811@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200803121902.860751811@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 03, 2020 at 02:17:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.7.13 release.  There
> are 120 patches in this series, all will be posted as a response to this one.
> If anyone has any issues with these being applied, please let me know.
> 
> Responses should be made by Wed, 05 Aug 2020 12:18:33 +0000.  Anything
> received after that time might be too late.
> 

Building sparc64:allmodconfig ... failed
--------------
Error log:
<stdin>:1511:2: warning: #warning syscall clone3 not implemented [-Wcpp]
In file included from arch/sparc/include/asm/percpu_64.h:11,
                 from arch/sparc/include/asm/percpu.h:5,
                 from include/linux/random.h:14,
                 from fs/crypto/policy.c:13:
arch/sparc/include/asm/trap_block.h:54:39: error: 'NR_CPUS' undeclared here (not in a function)
   54 | extern struct trap_per_cpu trap_block[NR_CPUS];

Inherited from mainline. Builds are not complete yet;
we may see a few more failures (powerpc:ppc64e_defconfig
fails to build in mainline as well).

Guenter
