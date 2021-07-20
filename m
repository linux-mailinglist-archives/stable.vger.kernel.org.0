Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B45B3D02B8
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 22:39:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbhGTT3i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 15:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230166AbhGTT1d (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 15:27:33 -0400
Received: from mail-oi1-x233.google.com (mail-oi1-x233.google.com [IPv6:2607:f8b0:4864:20::233])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AEA9C061762;
        Tue, 20 Jul 2021 13:08:10 -0700 (PDT)
Received: by mail-oi1-x233.google.com with SMTP id h9so490163oih.4;
        Tue, 20 Jul 2021 13:08:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=8yIP1UIE5kr+Z/0KRE/RBxitVEH3voGzqGqJhGFyomo=;
        b=BuJdgAmV+WH8FYyjqz/ro/oJLclNXl14dlM8bIoEGcypmcklhjCHSOk5cgV7VwV+Yr
         gSu0kGL5sNbBNjJvEYUWQY8c9cOsp/lCiPozsRs3NNJ/+4sLAZ0WXWBU4O5GFjkc0BfI
         KvGPZbFaqG8w4zdDki6wul1enfV/ExcjweiFYJKSMT8GD7YNhsLeVNUCm6LxkaH9iw4t
         RCKl6v1sWNpBTJOA4C0yXk3WwLFJBqUmkng+EmpX9JSiocOYiB5WuVyBOs+CpwVCAFtB
         Kw4syw/bIjkwfZHZh3JdVmbfSiJ44BWcY4mR3XNg7JvJr/xso71Ky8qZz3gssKbQ8Fzq
         7PmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=8yIP1UIE5kr+Z/0KRE/RBxitVEH3voGzqGqJhGFyomo=;
        b=kvnJHGUUGT4ppArCVikInGzRGQNEOocKCxDiV9zq1dlAKVjqQMKxwbTqEmRk9ldZjA
         zMqSRSyrdDE9X1pDfgv5ESNq+qw/1I1UaJtJGkaBhbd8AbRJGJDfFLBSFP6aG1WzX4eM
         VpxatUbhIE2iACBmenkQnpHerR/59m9gTKNhA4f6xl8abZnMElihrz2+xePeB/LT5TWX
         0MbkbS+r3ncviTiCaEmnWO+PpdZlygb1EK31jVc5iqOu0C0v3dwQb6Ga+BpN2+m2HZZ2
         B9CKaVMJuaT0YXFBzBs3wOyzCcVXtwJYDLXicCVi6GO2VERduZ6v3MkYnRGkvo0YJvB8
         WTKQ==
X-Gm-Message-State: AOAM530xD0vFI+S00C6tYy6eSJVfjLPdubPOTVN9Z5fGkJOEom3PrLSX
        Jg9mq2WvMaaPvS4fCpAt/5BHvy87Kz0=
X-Google-Smtp-Source: ABdhPJyWWg8fkTUa1c3QN2/ikOmYY0jQrVEZkoSIzCze+gz7pGHFSOl08qROLl2tK6ZKWLBB0gFeZA==
X-Received: by 2002:aca:1817:: with SMTP id h23mr22852787oih.146.1626811689906;
        Tue, 20 Jul 2021 13:08:09 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id c64sm4665419oif.30.2021.07.20.13.08.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Jul 2021 13:08:09 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 20 Jul 2021 13:08:08 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.9 000/245] 4.9.276-rc1 review
Message-ID: <20210720200808.GB2360284@roeck-us.net>
References: <20210719144940.288257948@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 19, 2021 at 04:49:02PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.276 release.
> There are 245 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jul 2021 14:47:42 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 163 fail: 0
Qemu test results:
	total: 384 pass: 384 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
