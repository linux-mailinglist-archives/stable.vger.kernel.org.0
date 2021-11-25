Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0821945D2E5
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 03:06:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237940AbhKYCJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 21:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231801AbhKYCHK (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Nov 2021 21:07:10 -0500
Received: from mail-ot1-x335.google.com (mail-ot1-x335.google.com [IPv6:2607:f8b0:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ED47C061A46;
        Wed, 24 Nov 2021 17:44:59 -0800 (PST)
Received: by mail-ot1-x335.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso7132350ota.5;
        Wed, 24 Nov 2021 17:44:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=y1b/Cff7n9MJBeYs2nRdHk2imAlYBhDHBmuhgRVDa6g=;
        b=YvKw9m6g0HfyfUy3XqSGsUMEaG00ZuotH1AllfePBI/e2y5Zibkn2ZY7pOnB6AytCp
         H9IsRCNXLwciAo/z1oh+YvJ0cNQkkwKiLqYrEOqS8Kehl0pIhOjq2UcvC9MO4mvkPMDZ
         Uh8LypfhtouHBNptP+Elb8ZdTMzjsVmuV4dZh8QFLkuJv7QkRC8Dq5wSXHERFqydGyMg
         o9EEuEmCbLaKmhe1jCDGXVdaOYexwFaHkXUm7TRhOdsDN40bs9l5xlqfB47xB/x+sRm7
         tlDfUeSUrPAHVPHeHWqf9M18ux56WvXYEawki5omItIOzrIQqVunwZjjK8LE/DLDfSg5
         Z0XA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=y1b/Cff7n9MJBeYs2nRdHk2imAlYBhDHBmuhgRVDa6g=;
        b=IQ6XhHwzjiGiX2b1XNc/0CAnKKnazYqvsrR2uCfCqxvg6FMiEha5+zk7QAcoLJ9d2s
         uILANttvQ0Gk4JbdZADmoH6PJbvxeWFty5LAHIQrJIXBm8hq1DcD6YNOHZs2Ocw+n2GI
         IhamC/lM9T4pzupibMCylX6FgcG061f6VdQB6TUiz9lVWlZGFHQhPNEiVdZ0Z8UqllF7
         zox0YA3acuR/LoH4Cq880oRmvyLOjfZcyIvp3JvcX+/R5hKq/4QZPGIOYCFVI68JBqzh
         5n+TrK0CnQ8hsIBXWVJDErb/THJMKKgJJaVoAUjsuXQamASbBlkMiNJvIoYmsOmMoOd+
         Yuxw==
X-Gm-Message-State: AOAM533kfZsOHImGu0lytikWpaQzC8ad3j2coKc/p3toQ9aUVlFNZjAA
        nX0nA3skdFBHmH4ZRukH6ao=
X-Google-Smtp-Source: ABdhPJxcyIazi1q8xi3lOS/FpLlZYTvbuUlTggZNjN3I+ywFW0lNxtwsrFARvwjHfCMH+GEcAhv4KA==
X-Received: by 2002:a9d:6d86:: with SMTP id x6mr17196607otp.263.1637804698471;
        Wed, 24 Nov 2021 17:44:58 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id j187sm359408oih.5.2021.11.24.17.44.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Nov 2021 17:44:58 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 24 Nov 2021 17:44:56 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/154] 5.10.82-rc1 review
Message-ID: <20211125014456.GE851427@roeck-us.net>
References: <20211124115702.361983534@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211124115702.361983534@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 24, 2021 at 12:56:36PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.82 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Nov 2021 11:56:36 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 158 fail: 1
Failed builds:
	arm:allmodconfig
Qemu test results:
	total: 477 pass: 446 fail: 31
Failed tests:
	<lots of arm tests>

drivers/cpuidle/cpuidle-tegra.c: In function 'tegra_cpuidle_probe':
drivers/cpuidle/cpuidle-tegra.c:349:45: error: 'TEGRA_SUSPEND_NOT_READY' undeclared

Guenter
