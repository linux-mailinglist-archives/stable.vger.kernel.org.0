Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8FA12397283
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 13:37:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231201AbhFALjB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 07:39:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230308AbhFALjB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 07:39:01 -0400
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BA88C061574
        for <stable@vger.kernel.org>; Tue,  1 Jun 2021 04:37:20 -0700 (PDT)
Received: by mail-pl1-x632.google.com with SMTP id e1so2439560pld.13
        for <stable@vger.kernel.org>; Tue, 01 Jun 2021 04:37:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=CS1n4sRHqpOQsFkP1CCTSFKBKWDyW0xQAW3QzafXtXc=;
        b=lq0SA5HGo+yQXaRg89NNd2j8VGI0VwV8xL3rruVRjC52JKktGKja2NuzY0NIrOVutl
         aNvbC+J6h7hptSZD/4SZ4HNEPYPyXv/ka5RtjVDhKQEgMll/aEvDwstR27JmEu3Xxv/X
         eSoztdPaHC3ZMW7nNx9yX9hP1rU2G/0BU8RLY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=CS1n4sRHqpOQsFkP1CCTSFKBKWDyW0xQAW3QzafXtXc=;
        b=CQ1UcmzkXE6HicqSWuSyEVcVQ1yrdabv9LQ6MlhWrzQi/T9pE9PQmev5JopspfOICJ
         hhWApaWpOHZlfMsOjCNtDmlBdiLRyW2TIgxwJ+elXpyzxIq2qMDUn7/1ggMQWzRy46cc
         mRRDzUDd7ygw0tz/5/9xmHRwMXZx2PLIRCch/GDfdRVnFhfbVnwiiM5kAHpjEYwF6lZn
         8ggajqT1VF/4D9msouY4Yxt4qEB/f82D+xZa5sn1D0Qzmg8UnCzsMMom6I2cjKXZ9lnb
         mLCt3by8u64xQgIXSXHZWQdQMFnKjIhErkzAmitScPzg8HC6RDs9zlytukCUxitMNJc9
         4A1w==
X-Gm-Message-State: AOAM533kXgxti+rBX+Gra/4fQYygCsokwyTfz4LfI44LjNGWh4k4MPNC
        h3lTXol6W46OhO5IjvBjYT/5Zg==
X-Google-Smtp-Source: ABdhPJznkRs//17VYuRFjTcDDl4U/eW721ciFqOI6XZslBYAQsi+1iDme+p1FAJ9YlPw9ZmeNBufbw==
X-Received: by 2002:a17:90a:117:: with SMTP id b23mr24609895pjb.183.1622547439593;
        Tue, 01 Jun 2021 04:37:19 -0700 (PDT)
Received: from 19e0a75b4758 ([124.170.34.40])
        by smtp.gmail.com with ESMTPSA id i8sm13462728pgt.58.2021.06.01.04.37.15
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 01 Jun 2021 04:37:19 -0700 (PDT)
Date:   Tue, 1 Jun 2021 11:37:12 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/296] 5.12.9-rc1 review
Message-ID: <20210601113707.GA270394@19e0a75b4758>
References: <20210531130703.762129381@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531130703.762129381@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 03:10:55PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.9 release.
> There are 296 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 02 Jun 2021 13:06:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.12.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.12.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Tested ok on:
- Tiger Lake x86_64
- Radxa ROCK Pi N10 (rk3399pro)

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
-- 
Rudi
