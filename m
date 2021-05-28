Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7437A393CD2
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 08:00:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234928AbhE1GBw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 May 2021 02:01:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232975AbhE1GBw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 May 2021 02:01:52 -0400
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B09C061574;
        Thu, 27 May 2021 23:00:17 -0700 (PDT)
Received: by mail-oi1-x22a.google.com with SMTP id d21so3188186oic.11;
        Thu, 27 May 2021 23:00:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=97nT+d3XDzmngTGxz4eqToOVqGtu6b+OscnqnemLY/I=;
        b=SkwoaQD1zoKL/+c2bHRcdvL/Qd6CphaF7Edltm9E7FhDCJZibATDw9/Jb/i9sq/tiG
         MqzKWRVSsKU5hFVxfWrJZF5x6tAEvbRTXgvwyGAuTd6KqsMWQPUHg7c7AxhYV4Ag0SRV
         9h1bass9CgPvq2MT8IYBU0mr3NDUGQuWqGYGzHzcQao5LCxSAEdvUflutrELA3J9WbRb
         uk8/vS5rfab1/T9agv2pAAJhNbr+IEqdJzQa0iLypkXjDubqGAt+JHK6IpotoWjessM4
         62ivmwpDSJa4qj0dcqSwyretNw1KfiyKnrhozfGRPjVMip1p54d/RT1uv/hRLrqG/VS/
         IrIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=97nT+d3XDzmngTGxz4eqToOVqGtu6b+OscnqnemLY/I=;
        b=ufTDxe6wc6pAt2uLbXT7G9GAW2vEMNYFmCZV5/Kblprwv/LyeYPmiEs7BwVtY2/jSl
         7afknIBr9KEVO4uGllxduJ2F05jRwXOKduDLFQIVmFaJzaQfSChRBcyBBYwwsNc1PQF9
         tIBMpfmTt/Oz/3UBVna4qzDKSiJJw4QKNu77bdgGbHJYch6IpBf7KRVwvAVJQWKVkUca
         rOhKksPgKJc4uJbR09e+9HEP1CArv+b7cuBpiQXIhkceySeEoz7vCguuU70c0QERPnmy
         cD/fh85J3oHieK6On0JpxJjxlVKksCmpTI06FKdHPxrb0NFvUacHj0ynQ/Pp02GTSGd3
         3B2A==
X-Gm-Message-State: AOAM533K6ohdvxss4CX52/WBdMeru9dhbSN8m78PcTKLIkRlB3pNiYN1
        VcmMmgBlvQTGMkDqWV4lYSNqld2FHwU=
X-Google-Smtp-Source: ABdhPJyBeBJvsUs+ezACIDpaFfAh/P9tIx5MlEy4Q8wrL/I3iw2QCZOrmMmnIvKNiKvVNK4z0tOmPg==
X-Received: by 2002:a05:6808:2017:: with SMTP id q23mr4758533oiw.41.1622181616688;
        Thu, 27 May 2021 23:00:16 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c19sm965832oiw.7.2021.05.27.23.00.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 May 2021 23:00:16 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 27 May 2021 23:00:15 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 0/9] 5.10.41-rc1 review
Message-ID: <20210528060015.GB2447409@roeck-us.net>
References: <20210527151139.242182390@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210527151139.242182390@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 27, 2021 at 05:12:52PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.41 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 29 May 2021 15:11:29 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 455 pass: 455 fail: 0

Reviewed-by: Guenter Roeck <linux@roeck-us.net>

Guenter
