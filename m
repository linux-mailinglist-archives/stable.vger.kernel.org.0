Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9513CC529
	for <lists+stable@lfdr.de>; Sat, 17 Jul 2021 20:04:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234554AbhGQSHt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 17 Jul 2021 14:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbhGQSHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 17 Jul 2021 14:07:48 -0400
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF5DEC061762;
        Sat, 17 Jul 2021 11:04:50 -0700 (PDT)
Received: by mail-qk1-x72d.google.com with SMTP id z9so12223416qkg.5;
        Sat, 17 Jul 2021 11:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=jOz7UGsKyLzcLw/cxOQIRtu86zl1UcA+7sJKgSlVbP0=;
        b=hjQG41s6Ao5HHcSUkqXhLjYqRAj9LZW4uODK7sP6arUr5zy9MPH0ZmY3XtmsC7RI25
         aaaMMy0Wkaf8hjEUvPhj+Cys+rarB4BD3CkLjLGQ1d+VHVDOKrNltyGEU+rgNl8FRfVf
         DIoQolskylM56ny1fVNlH4yFcWVjwKkWkxlDZ/HsZJz/mzI6KSovYLdtjUVql29Ke9ST
         Uo7xYMKWkqPj62klteIVopiS+7iwyD6zaG9vr0TSmAFe1AFjSEVeS9JeNRqHRkXcAgbl
         8Z4O3AQ7VK000oi9cdgRE9lnu7gCsHB8rlV1XxNIluzg5q1Hnug5UnCopdRkICx+G4sm
         ks5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=jOz7UGsKyLzcLw/cxOQIRtu86zl1UcA+7sJKgSlVbP0=;
        b=dspArXaAsAoiudChY1kjcbbSGDX+3yp8lltD21ntk1ggohsGeoKUw3egvmAL0mqGu0
         KHOhhFZ0uonFlD+Yl8cTP5bWQ7SadldyDArJAunCofrcqjfprtNAvPQabNLUMCvMnEiH
         NQv7lLFcs7kXsuC4fPdiBELiDcbg6Xl/E6aodDoWLPlwr7RC/5PxD6ekmovd2xHAK8a7
         q9jX2ZEJvFf03N4a5sbgQ3dn7syHhu8f9gd48m3A5p1pQRa4OzSb+LxORajz+4QOYnDJ
         +pWcdALU6aw+00odF0UbDXNAcQp1BXYWUKfBWPGqz16doLdIDSDMT8RCqF2ztNjmpsF/
         5mfA==
X-Gm-Message-State: AOAM532hCYuz+PVsDCJ+YXBjl9qa/Y0V+ce0EaoKfeOwSopLkBeD77Nt
        onYpfNlFnQjVg10Nl1Gtuaw=
X-Google-Smtp-Source: ABdhPJzDghhQ7FT/oraTuQVjxNSwvwRo351sl5HGkOTq9f4zWlqOqTO3la9lJDEuqYVxr+e6v6OoBQ==
X-Received: by 2002:a05:620a:124e:: with SMTP id a14mr16140400qkl.356.1626545089993;
        Sat, 17 Jul 2021 11:04:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 197sm5669414qkn.64.2021.07.17.11.04.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 17 Jul 2021 11:04:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Sat, 17 Jul 2021 11:04:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.12 000/235] 5.12.18-rc2 review
Message-ID: <20210717180448.GC772394@roeck-us.net>
References: <20210716182137.994236340@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716182137.994236340@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 08:29:03PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.12.18 release.
> There are 235 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 18 Jul 2021 18:16:27 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 152 fail: 2
Failed builds:
	riscv32:allmodconfig
	riscv:allmodconfig
Qemu test results:
	total: 464 pass: 464 fail: 0

No new failures.

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
