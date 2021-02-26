Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 785EF325C06
	for <lists+stable@lfdr.de>; Fri, 26 Feb 2021 04:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229491AbhBZDjW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Feb 2021 22:39:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229460AbhBZDjV (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Feb 2021 22:39:21 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB893C061574;
        Thu, 25 Feb 2021 19:38:41 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id a7so8266318iok.12;
        Thu, 25 Feb 2021 19:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=udmluXpMaci3ucoNswUdfC3FZ9ieEv+QjxuH8G5YDsw=;
        b=rBLI57mIfxf3VaxSTdYGQLwKZA6Z/JYCfEg15IScOI4WmQ/kn0RTue+r/qrc2A2eFm
         X1rwQOx0DW9EPQJt8A0ba1HPvwdx+soCfsNIZL/6FemjS5VFOD9whgMH3mJirygLNm4x
         Xk+iXedqd0PlxpBclb8UGQCYPs9L495pDO5/kAs5QrbCSuytxg05cjGMjhUSuBMCQcox
         th+RkfYsceVIhjcBHXAsaGUpRFgEEGUg5rRHzR+IdC9d+yjAl3/yZz4qHB4+Cty5jPxE
         Cg3b/rPpULiuE1Oq5vMXu2g/lKKoJFt8gxj8zKUrYxjVedCdj9+yoLmaHXeHy5KQgHOA
         wIXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=udmluXpMaci3ucoNswUdfC3FZ9ieEv+QjxuH8G5YDsw=;
        b=G1WFPE9jPGvXTyeWLhCFxzq4UFRVmNFmaam9Ex4izj+DRocTsBrs56NTHlxWuHbI/P
         HTBZv701yLsLCQXNTyIpK8at+b05/ePK21PlgmuQ2fvTBPzF/k9qJDSL/YJW0LN4Cmkl
         +omFR67UUbEpJzG60JJ+La7XAJ9xGYCO1M78QdrN5cQUnbdK7p9VZbxJT+b/4NmvKwHy
         4U2LU6F0puhaGzdjuTP8RkNfm68RqXxsfyQVvTSCpQFOY59Oah4LHRz6mt+1oTTTzZPS
         8+ECyv4Ygugm1mOC/SwrrbMCWcoJ12Cq1oEGtlkwNBKu3HjSKhDinx9WFvU/bpS1pAYT
         G19g==
X-Gm-Message-State: AOAM530I8Hznp/FC6f+uiTX3PosowjbhHr6kVivZwAzF8GhYWfWcjc62
        dzm/GRtmX74ZVqzSBnzMf2A=
X-Google-Smtp-Source: ABdhPJx82wb55P6Oj98cuE7Hs/obM9NwK1cIzalWOs8Kbe8jbSONnjuYt9/RGZkKxqL94b5W5Uw88g==
X-Received: by 2002:a05:6638:12cf:: with SMTP id v15mr952778jas.77.1614310721190;
        Thu, 25 Feb 2021 19:38:41 -0800 (PST)
Received: from book ([2601:445:8200:6c90::4121])
        by smtp.gmail.com with ESMTPSA id k14sm1901143ilv.41.2021.02.25.19.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 25 Feb 2021 19:38:40 -0800 (PST)
Date:   Thu, 25 Feb 2021 21:38:38 -0600
From:   Ross Schmidt <ross.schm.dev@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/17] 5.4.101-rc1 review
Message-ID: <20210226033838.GA5461@book>
References: <20210225092515.001992375@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210225092515.001992375@linuxfoundation.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 25, 2021 at 10:53:45AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.101 release.
> There are 17 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>

Compiled and booted with no regressions on x86_64.

Tested-by: Ross Schmidt <ross.schm.dev@gmail.com>


thanks,

Ross
