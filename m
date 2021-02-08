Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 750A6314053
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 21:23:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232828AbhBHUXI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 15:23:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236838AbhBHUWw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 8 Feb 2021 15:22:52 -0500
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 501D6C061788;
        Mon,  8 Feb 2021 12:22:12 -0800 (PST)
Received: by mail-qk1-x733.google.com with SMTP id u20so15811122qku.7;
        Mon, 08 Feb 2021 12:22:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Gn15PAlGit56jnPrfE4giJ8DHCVtKKDYLe8OW80tVPI=;
        b=H1jXjFfaMN/gc1QyGO6x/sApCno+Py7+Ij7ty7jYwhBus7J8cCS9ZkySc4QW6btGJ/
         RSBGvSRlYhD4EOr2DBnTHuCpF9z/Kyygbx2FMEH7ZpYOgWiXMZi6R4hSxoTmdouWdmxN
         sqmENksJxaH7GExFm0q5DE9uoaF+WUT4O9Sot+eLobMJJg+1/Jd41PUcjrCaH2mZ2L/U
         Q2W+Yy/V4+a1sfTPoE4lUQd/d0tUDxCOP0XfcIyt7liNWgvubBsgMMfkd+PRIH/UMWRF
         PWtIyCSPfvQ01S1j72EGjoZPpmJqSnDN918hl6zZVU2S/U7MkzS+4aaVdqGFCkN5lE4K
         1Qig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Gn15PAlGit56jnPrfE4giJ8DHCVtKKDYLe8OW80tVPI=;
        b=fR7GjSR5Ben+m4rfZ70A53K79Ehag4ufg16JflOuaQ1lWjpX6OWWQRUm2mjWHn8/8W
         0n4O8Ip2zT7J16Rc5GqlZ3OE7DIuVAXCuB8/1oTyijSFqiYuMNSTNTQbYbR3sTrha+3Y
         nDf6lB+GU163ruZAh+DJg/uUVS71lcEyYPHGn6OadXUxKvfJklrm+E//6Jmft/UTfT/8
         Q3g1J9sDa0R4GVBL1++m06GCXdMKHG7Hy7Hw1FXIx/D7Y/lw6DYs8VWXmMbW1QPN5tIC
         5H5BRxvyDwHuNc8qsrZhw1BanxK7pwRhJJVKUlScTnhxy44HyzcN0qItm8/bMCI1+aZ5
         Z1UA==
X-Gm-Message-State: AOAM531gFoDWry2AM4woMdl+T2Ws81aBCcFsdYNo4hRkJJI+G8upGIit
        DfuFbSJL915zrUxm4iOqMuxiy8Xa8ltwsQ==
X-Google-Smtp-Source: ABdhPJw7ZK5t8XDEA+yQNq9RsIJxJ+wmat/4JPeLtVt7Q6u9VisCMAvqpiML1XzUW48Mq6mRCErUPQ==
X-Received: by 2002:a37:6f01:: with SMTP id k1mr18738029qkc.252.1612815730914;
        Mon, 08 Feb 2021 12:22:10 -0800 (PST)
Received: from theldus.codes ([2804:d45:9905:9600:c57:100:d8b8:6ad3])
        by smtp.gmail.com with ESMTPSA id l24sm7821260qtr.16.2021.02.08.12.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 12:22:10 -0800 (PST)
Date:   Mon, 8 Feb 2021 17:22:07 -0300
From:   Davidson Francis <davidsondfgl@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/120] 5.10.15-rc1 review
Message-ID: <20210208202207.GA6005@theldus.codes>
References: <20210208145818.395353822@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 03:59:47PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.15 release.
> There are 120 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Compiled and boot tested for x86_64, no dmesg regressions found.

Tested-by: Davidson Francis <davidsondfgl@gmail.com>

Regards,
Davidson Francis

