Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2D2F390B3C
	for <lists+stable@lfdr.de>; Tue, 25 May 2021 23:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbhEYVXw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 May 2021 17:23:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232146AbhEYVXv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 May 2021 17:23:51 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 910B0C061574;
        Tue, 25 May 2021 14:22:20 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id s19so31631053oic.7;
        Tue, 25 May 2021 14:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Nq5Lyl63Cxp5G8zHQgyIjlov5Lk7a01uqNJZRsLVhWY=;
        b=iZbe2L+hF/jJpwSDM5aBUCxTc6ZuFB0w2E4KwU9llJS4Wc09/W8G7q3sbX/YRa0DwC
         VM1Jumpy0YZ8YFWWUxQ5IO+TqFDq+8dRsz86dL3TxLnZnchMpNnvqPe+xGOj/ww09lq3
         WvX6SI5rg8f5P7aMBoFAt2w8flkn7Q8XJGQAhfD3jVxpuzqhJFJHP0Ut4TjXstV08FRC
         qHNzmz0o1017isHiDmHGRT1CsF/ZtcidAPCkf8xputDYBUMVBITkizy7KsPfqO8aFF6T
         TYJhpkH+JioP9J9SQupM5nw0SjqKS+JQN+rl+TPc7+E4Hvy5EvF6HOHWw87GVB+P/Gj9
         Alkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=Nq5Lyl63Cxp5G8zHQgyIjlov5Lk7a01uqNJZRsLVhWY=;
        b=pccdUlly+oN+/I4JIwZ34EQyBn85ByDBpsR078wXVApn3a7FcQ8BNR5P/aa1q9Z9mn
         uFWOFHH6Tf7t3AzjvLJpf+CA9FMGW+UGtw6et0zSyut1zjfJK84XvMV+f4hmQIJG4gM5
         rJ/xOmr4eJqKV4sDh7doZ73ve60hIBK7we4ZBvw6+fvcerYWohnI/KjdCg064DPmdss2
         gp5crHJJMbow3oZEgl+bvKyVAQRzJ4kK96l5QQaF8I+GKSsW1YCCA1RknBuDJDky9uuS
         QZeyKxAlMqD/cGwj6kWS6jbO/SuK8coWXQ7wB7td2EaXOEHR8PeZgibYs2FEi3aG16cg
         RhqQ==
X-Gm-Message-State: AOAM530rPzMU64k19UGFG1qZdQYMoIhi4BHc264hbqc+uPdhezZzByQI
        XWnzu1nqqC+WT/KoMGnFuIA=
X-Google-Smtp-Source: ABdhPJw0C+r9iElBSfvRs8s7icPI5TvEzGzCuC/710BWv2WrzYV4NR/l7ono15ct0R9MjfWxXctsQQ==
X-Received: by 2002:aca:c753:: with SMTP id x80mr236906oif.25.1621977739945;
        Tue, 25 May 2021 14:22:19 -0700 (PDT)
Received: from localhost ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id o14sm3418351oik.29.2021.05.25.14.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 25 May 2021 14:22:19 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 25 May 2021 14:22:17 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 4.4 00/31] 4.4.270-rc1 review
Message-ID: <20210525212217.GA921026@roeck-us.net>
References: <20210524152322.919918360@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210524152322.919918360@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 24, 2021 at 05:24:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.4.270 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 May 2021 15:23:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 160 pass: 160 fail: 0
Qemu test results:
	total: 326 pass: 326 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
