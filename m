Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B1750DB566
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 20:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406570AbfJQSC5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Oct 2019 14:02:57 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:35459 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2403968AbfJQSC4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Oct 2019 14:02:56 -0400
Received: by mail-pg1-f193.google.com with SMTP id p30so1806998pgl.2;
        Thu, 17 Oct 2019 11:02:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=p+yS83MygakS1KCBwVQcnvCy+jIMv5rCDjVZzHk9bJQ=;
        b=YT1OUWT5CKqOigca3AV3M1lsMclwyw//RdVyxfmMqMfK7DkKyV32RgAs/o40On7TZY
         iqw7DfNywwMptM2jUQRC3QtJ7tcdF1eOW1aW73j2QDemOH7kHSvDzpQcE72Elw1s4BYN
         vCpJGBVe08undQAQyipewtv7RO8Clag7j7Halt9aeTRvvvM4p+ey/gyTZwFWBZ/9ewOq
         bOYNdVVeZAhojWXVuIX37U/LJnSRuNmcmN3nKPL9qs/SXlMF3CKpWcY4m9H5yy+M5NlD
         xCZQFzu6qCmDZHnDkEM2cKW34F6F/ZXVJZQkuDO3GJmHlTzASWFQsSJFPljUzRVpwpap
         ABqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=p+yS83MygakS1KCBwVQcnvCy+jIMv5rCDjVZzHk9bJQ=;
        b=Nz4shm5Na4DRMnTtrQV9RoIp8xxw5xRyw7E5UhrUbY4oIwaztUA9LfjNd9bCD/W7Jh
         6cGxsf/MQYECd4XAaZ6FikCCrinRrDdC2yWkPhZpijlPUpBxjqTEAfRwoFvtv3feqMxX
         1pdHPMBvR3IdmzXRPv3KAtzp45MkiPMggNxZmNGH0VrIohM4Vgn2KAMT4hogNzqqqsos
         Uoa5fBeAjmoCtrJoxG6t2eApuwxzjCiNFw9tiPrCiuOoZRSJSwXSCPAo+HOUqDjGItWS
         C0jjPGBVU1V4ktaGKsbwVyxdKq4Zc5xYXQ4vU4ddYEkIuDucMv2RbDMaGW+EPql9RVLp
         ejkA==
X-Gm-Message-State: APjAAAVZRx6O4lkBMOflB7GxbZrsyhXWj+Qo2n6XyxZ/0kCVeQ2/QRDr
        Q7zOvpyBoZqLWn4j+NHP4eg=
X-Google-Smtp-Source: APXvYqz9FwFV5ls8d18O6sph7QTMr4Ky4vJmGk+01F4UD19Vdm2FTn0eZ0n9ihEdjarVwacJEJOVJw==
X-Received: by 2002:a17:90a:3702:: with SMTP id u2mr5905597pjb.57.1571335376226;
        Thu, 17 Oct 2019 11:02:56 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i126sm3833749pfc.29.2019.10.17.11.02.53
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 17 Oct 2019 11:02:54 -0700 (PDT)
Date:   Thu, 17 Oct 2019 11:02:52 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        ben.hutchings@codethink.co.uk, lkft-triage@lists.linaro.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/79] 4.4.197-stable review
Message-ID: <20191017180252.GA29239@roeck-us.net>
References: <20191016214729.758892904@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191016214729.758892904@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 16, 2019 at 02:49:35PM -0700, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.197 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri 18 Oct 2019 09:43:41 PM UTC.
> Anything received after that time might be too late.
> 

Build results:
	total: 170 pass: 170 fail: 0
Qemu test results:
	total: 324 pass: 324 fail: 0

Guenter
