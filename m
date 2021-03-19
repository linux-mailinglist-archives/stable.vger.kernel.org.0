Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73CD8342799
	for <lists+stable@lfdr.de>; Fri, 19 Mar 2021 22:22:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbhCSVV7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Mar 2021 17:21:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbhCSVVu (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Mar 2021 17:21:50 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8E1EC06175F;
        Fri, 19 Mar 2021 14:21:49 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id z15so6226662oic.8;
        Fri, 19 Mar 2021 14:21:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=TuQ+Qa5Ogrp9ZaqUxqTsJAS6+bv57zVaQ5SqGjIqvOw=;
        b=plR/X/jT6mRo0dB9I66ea+WJ2iqAL+XP7RYtOV3148XUXNzrdTdeganQXzEzYLMdT0
         /PVsFKS2x63l24DUkFmUlMLCWo7EUAsbc5kgUOngVuIRhMQa5oU3DWrOxQqhPGAS+8Yo
         HFeUZruJsF8uAGCvLmbGzlXt4o1Aigkvj8CxzPFSYNyqqFQHwhKuQbxBaR1twenvy+I2
         J1qFQx3awfT8zKBKuXJPCrTV10MayFGuFZEu2iwvJoIX1FEaxOmWGzex7TDpXPJ0PdPA
         2Twfdvh43EGDool3I+kvsfvcxfu0BgRp8lkXN5boMoXVSRkxKgD98EO5d84g+EtyNImI
         vQIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to:user-agent;
        bh=TuQ+Qa5Ogrp9ZaqUxqTsJAS6+bv57zVaQ5SqGjIqvOw=;
        b=mdYgB2aVCjKS3V/99eEzFbqyDXAZSDQnyf2bKTIP97zZ9VTEXYaBICCqIUXtLgdCna
         148nnVeTHMICvIUWv9oNKK726cI93p0q94scbRqU+2+NFh9zmf0iFXzBYJShQk+f8X8j
         qU4gou+6EwRYvOjYVLW8FwrDCW93ZqacQ3MkfZJ/h0eBV5VjPB5hRr/JcSh+a6cgMrA5
         TvY19Km6Xo6MXtKr1j8phc2MYuTGIo6Xg/UqFQNQOG8N/Vj0XFCwGup+cU9qJSngrIJf
         +XPKUIKsxwMmv680r+2aTGiKsaUNQfgwqf1rTTQuNU2LmrzIE+8JSU/U96VEIrX6nUzY
         H9fQ==
X-Gm-Message-State: AOAM533MuDvvR6xIoXDIvWRsTy+8MiYv/OncGmZtDv0ajxzRATHUJf+q
        qIaCZTJSrgGgX3tTJ0v51dD4KfD8C3U=
X-Google-Smtp-Source: ABdhPJx64CL4e2hzY+WbfiUW0+kJvP1YcCNZ0FJ/aoJgL6h1rIxI8BMPtYnPQ6rW3ew1vVMYhYSFmQ==
X-Received: by 2002:a05:6808:3dc:: with SMTP id o28mr2497164oie.120.1616188909386;
        Fri, 19 Mar 2021 14:21:49 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id b22sm1402482ots.59.2021.03.19.14.21.47
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 19 Mar 2021 14:21:48 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 19 Mar 2021 14:21:46 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.19 0/8] 4.19.182-rc1 review
Message-ID: <20210319212146.GA23228@roeck-us.net>
References: <20210319121744.114946147@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210319121744.114946147@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 19, 2021 at 01:18:19PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.182 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 21 Mar 2021 12:17:37 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 154 fail: 1
Failed builds:
	x86_64:tools/perf
Qemu test results:
	total: 420 pass: 420 fail: 0

jvmti/jvmti_agent.c:48:21: error: static declaration of ‘gettid’ follows non-static declaration
   48 | static inline pid_t gettid(void)
      |                     ^~~~~~
In file included from /usr/include/unistd.h:1170,
                 from jvmti/jvmti_agent.c:33:
/usr/include/x86_64-linux-gnu/bits/unistd_ext.h:34:16: note: previous declaration of ‘gettid’ was here

The tools/perf error is not new. It is seen because I started updating
my servers to Ubuntu 20.0. The following patches would be needed to fix the
problem in v4.19.y.

8feb8efef97a tools build feature: Check if get_current_dir_name() is available
11c6cbe706f2 tools build feature: Check if eventfd() is available
4541a8bb13a8 tools build: Check if gettid() is available before providing helper
fc8c0a992233 perf tools: Use %define api.pure full instead of %pure-parser

The first two patches prevent a conflict with the third patch, and the
last patch fixes an unrelated build warning.

Older kernels are also affected. The list of patches needed for v4.14.y is:

0ada120c883d perf: Make perf able to build with latest libbfd
        (this patch is in v4.9.y but not in v4.14.y)
25ab5abf5b14 tools build feature: Check if pthread_barrier_t is available
8feb8efef97a tools build feature: Check if get_current_dir_name() is available
11c6cbe706f2 tools build feature: Check if eventfd() is available
4541a8bb13a8 tools build: Check if gettid() is available before providing helper
fc8c0a992233 perf tools: Use %define api.pure full instead of %pure-parser

I tried to fix the problem in v4.9.y and v4.4.y as well, but that is pretty
much hopeless. I'll have to stop testing perf builds for those kernels.

Anyway,

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
