Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 512E23A27A3
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 11:03:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbhFJJE4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 05:04:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230186AbhFJJEv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Jun 2021 05:04:51 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBAEC0617AD;
        Thu, 10 Jun 2021 02:02:55 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id s70-20020a1ca9490000b02901a589651424so4393371wme.0;
        Thu, 10 Jun 2021 02:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D5peI0fvTDdLMQtpkTKxpUPgAMQQl+CcH+58lkSEfzs=;
        b=Y+1BHZ5Oehgv6FfWzHLRDOMhamJJGxnDJZY7XiA6qdYehMVtcCwo6xmflAh4+VlyyQ
         VpyQvM//jwu60VYmC8KALS814LLWu/CJ6SvpAhoC+RDLk7HPiCtvLa2OVAuAbrEPUduU
         6jzEOHycE8MkDvTyUaR5NloAPoFD6WvT2nT5MI7wzGDS446hF9m4qSP5gRT8xoY9jFhp
         aXQCf/efswRJLJdJoSfpqHpYYccqK62Ng4c1WOY1nW8+WTfW4W1zahT7p3QYFcAt8Bp7
         1fXzXATkdVe+8cau9p0/IoGDYKNPsFN/pl7Yk0DgPZu4qo3gSgNJwoXeJHtvOHBdzav1
         ynhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D5peI0fvTDdLMQtpkTKxpUPgAMQQl+CcH+58lkSEfzs=;
        b=PrgS0UlJmPg8ltTPVupahwP5yr7RsA3o2ej/3IhxjLL2TppdgjmhbmCi/FfZArkUNP
         +ChasPvgePdB3sVUssE4yzP6tlhshE+t6heV3EaO+k2a59SUuZiRNdR4VionRg6r3VfT
         MFbTeToU24xDqLV3oErhwNNyX3o8A56veFzR1W5ufarso0eRRyUmrD6hHD0x5RRDdq/S
         jIUtn58Jq5KNWzN7RW6G3cnrD+lfWPrqwILqqTrtPYhM+8FHuv8HzNVaK8oVHEkUJ410
         htNa35uq8wKK68eaJ+Tb4DiADHG9EBcE1jRIEMF76WCVxtBddnjRZBPw2cPZeqHxFod0
         RP7A==
X-Gm-Message-State: AOAM532cDeta61mLNg7xbOjKwkDnXISqF6nmsGWUHIOHS5uVX1oER+kK
        p/8J326UbMfYRa1iKHFk4a4=
X-Google-Smtp-Source: ABdhPJxRYvyPoio/ogk7KN5c7FMsmVQ8E4TL+rHWdHqs4JJLpbzbLbQPT2H5/T0taZcisCQO+iFwvw==
X-Received: by 2002:a05:600c:3789:: with SMTP id o9mr14213221wmr.78.1623315774281;
        Thu, 10 Jun 2021 02:02:54 -0700 (PDT)
Received: from debian (host-2-98-62-17.as13285.net. [2.98.62.17])
        by smtp.gmail.com with ESMTPSA id u16sm2902092wru.56.2021.06.10.02.02.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Jun 2021 02:02:53 -0700 (PDT)
Date:   Thu, 10 Jun 2021 10:02:52 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/137] 5.10.43-rc1 review
Message-ID: <YMHVPPXkYh9HTOMz@debian>
References: <20210608175942.377073879@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210608175942.377073879@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jun 08, 2021 at 08:25:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.43 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Jun 2021 17:59:18 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.1.1 20210523): 63 configs -> no failure
arm (gcc version 11.1.1 20210523): 105 configs -> no new failure
arm64 (gcc version 11.1.1 20210523): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 2 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression.
arm64: Booted on rpi4b (4GB model). No regression.

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
