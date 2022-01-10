Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC6D448A3E7
	for <lists+stable@lfdr.de>; Tue, 11 Jan 2022 00:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345722AbiAJXsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Jan 2022 18:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245340AbiAJXsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Jan 2022 18:48:40 -0500
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A68BC06173F;
        Mon, 10 Jan 2022 15:48:40 -0800 (PST)
Received: by mail-oi1-x22f.google.com with SMTP id q186so15364809oih.8;
        Mon, 10 Jan 2022 15:48:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=gXpk1LxttG+4Yv8QImRngM+cKfk5O65Gb0o0zuu+AJA=;
        b=ZhjR9HH5JUUTY5sdKeLEadHmr9uqyP4yrI3eOoOtb+K58KAm9WF6xIS/U0TygNkFBQ
         oWsFKEtRRpm7zvxHZANsn4o1I9SmQWqS+IDd1jiAx+uXmqvla9qcff5glY5N29dmuV/F
         cUrePhgYaCnMV2zPdUZsJggGLJ7m38VU8aity58vXbERJrAIG1Rt3/j8jQtg/c4QAu8f
         KsoDsC+27FRr0VUyKUbZ90TbWMWkwluT96Bb9hDHIZvXGWKdxpiMIpGcMd+YJXHbOZkf
         GevtCjZnx3veB6dbbRo733nrww2YzGcXdKcK11I4uL7q4SNCIK5baCn8nfD0JzoS2EhM
         85yA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=gXpk1LxttG+4Yv8QImRngM+cKfk5O65Gb0o0zuu+AJA=;
        b=7XtRPmBPsLk+OcuwoKeEdTo9CzO8J+eLKEar9Mdv1+jGKaRBYIiPLxddBMo3Jcw78T
         pwPJqpF/fy+iXzQkT3MkwlF5IxdJkQcmCAl9a8qBYeSCsp+6syIHuWqiSukmAPRzUFdO
         IQZYp5xRkp+IM1Kt4jE9Tvl7ftMlGxtqzMx1wp+sqjhqrtx6+MEn1295GTSb9z/u6Smg
         QGWAuD0WHsdzUBC0BkcAR/SkkCQ4GYwaCgbCepghIbK3TOWyzwGFxJE/+nAshwpAgL6/
         0/9hbc9+aU2vfLyvx6DMT0kKp0k81pCl/IWxLGU/9EuvUPYrHp2QuYNGfd24EV5Pvcbj
         7oDw==
X-Gm-Message-State: AOAM531IQGzTB6RV3W6JIgr4KZPob1o613A8FRFDbsFguAjZnS82/XL9
        zEVE2a6IQOfLTqdTyZXsLek=
X-Google-Smtp-Source: ABdhPJzbbmq7K6lTOUxrQTN6Bak9s0xCpSh7bppN0l+KZQPlni5mX3Wa+0jKlR7yR1Xnv6IKMCM5CA==
X-Received: by 2002:a05:6808:300b:: with SMTP id ay11mr112128oib.120.1641858519486;
        Mon, 10 Jan 2022 15:48:39 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w203sm1405314oie.21.2022.01.10.15.48.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 15:48:38 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 10 Jan 2022 15:48:37 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 00/21] 4.9.297-rc1 review
Message-ID: <20220110234837.GB1633615@roeck-us.net>
References: <20220110071812.806606886@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220110071812.806606886@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 10, 2022 at 08:22:47AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.297 release.
> There are 21 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 12 Jan 2022 07:18:05 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 394 pass: 394 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
