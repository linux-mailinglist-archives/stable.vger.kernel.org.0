Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 222CB336828
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 00:54:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233308AbhCJXxH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 18:53:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40744 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbhCJXxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 10 Mar 2021 18:53:04 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D23EFC061574;
        Wed, 10 Mar 2021 15:53:03 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id a17so18274199oto.5;
        Wed, 10 Mar 2021 15:53:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=QGsODkhhL41wg532zpWxhPWmD7owWhACv5lE7FKfsjo=;
        b=cI5mkYF7HM3lfOe/5ouPCKH+w5xAGe88uuJRpmpCWRi6H+V6ybzS4pmQihxstZypGI
         z3xaCWwWs9uKLF7nZtoSU6+O7hweNtobuks954nLif2TYTm8Y0dUATKYbmoaif9JQALO
         lvj7cQv6SV4zIYH2zpnB77jxOtQRZYIQ//Y+sDqtpwW5z5jkrPgb7gIeDzZ93HJrL3bu
         OmXwwdeLGFcrGMm/hLTEzasxte55o1Vqrs3yWQWRBC/fWXa9Ncxyu1b+0+YC7mHCV7nj
         weS5BmkaQTp4RwF9Ox/OZWqGg6MI8EVZGq0KoV57kgiEjv7XcbmVdURFpJATXhYLDXqf
         g1ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to:user-agent;
        bh=QGsODkhhL41wg532zpWxhPWmD7owWhACv5lE7FKfsjo=;
        b=RX6DCvIuW+vurXq7WA/OUYjEJVc7ymiOoulD/NgJngumpzMkVsqyJEBWA33nhIrCdM
         S8knq/pJdXc1ChCN1J3lXAb15T8lxundIrgq6olycHlndIaJlt6L1pGShZ77UzxQ7jZQ
         faNzZ0YR7XJuHtG96LcJOQeFgVFj772npb41VdfrrNSPdLdgIgMFSffVdYewOzJ4g3aU
         kBvhx8src50KLpYea6Tp9fkefpXP0DXY69LRix2Yk4HVpeanjvhpSDyuEEnysDRRKIav
         jNtMvyEFXDzjPNs6GIPk4sRQSqlIaIUG4U/mm5B1o0+yhTH6Z0XsL29CusNN2QaZLcUw
         y3JA==
X-Gm-Message-State: AOAM532eGwP4fZM8m6XUxGbhj/Pca6P+pLeITL4X3RBO8TcPn1LHaZNT
        ZkmvLr1RAu8CUulArhW8x6s=
X-Google-Smtp-Source: ABdhPJwxerpE3c3MMbbbA0VlPZN0Yu9/wcyykxV5FP/D2kVpRDLc1WBSyjQGAuyjK4I9wrKA35Iqzw==
X-Received: by 2002:a9d:6ad9:: with SMTP id m25mr4743390otq.267.1615420383341;
        Wed, 10 Mar 2021 15:53:03 -0800 (PST)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 64sm277699otu.80.2021.03.10.15.53.02
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 10 Mar 2021 15:53:02 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 10 Mar 2021 15:53:01 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     gregkh@linuxfoundation.org
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.11 00/36] 5.11.6-rc1 review
Message-ID: <20210310235301.GG195769@roeck-us.net>
References: <20210310132320.510840709@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210310132320.510840709@linuxfoundation.org>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 10, 2021 at 02:23:13PM +0100, gregkh@linuxfoundation.org wrote:
> From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> This is the start of the stable review cycle for the 5.11.6 release.
> There are 36 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 12 Mar 2021 13:23:09 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 437 pass: 437 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
