Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBB8F3E357D
	for <lists+stable@lfdr.de>; Sat,  7 Aug 2021 15:16:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232254AbhHGNQw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Aug 2021 09:16:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232192AbhHGNQv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Aug 2021 09:16:51 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1A9C0613CF;
        Sat,  7 Aug 2021 06:16:34 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id dw2-20020a17090b0942b0290177cb475142so26879081pjb.2;
        Sat, 07 Aug 2021 06:16:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=6TT4hOLY1K73fDIL51uEPsxccZa0W+CXeROOV5HZmgA=;
        b=INhakPtYip3LHyQDHcAWledr4vurbhhp5vxYJLOVifH6M96tcXwotbEjxK26wHAgVB
         gSIeiawHk55m9LpRmXCBSqxd8CsLg7A8KQGJVQeDAUww4L4paQ18MMN0jI9Z2SROcxGU
         ZzOCSqrzObMtHf3WxsBknuGolGy7cs8geWt86HCOHUrzUjfZ9/fQQbqxAUvb7+uJb81C
         eUK54X8CqAWxp2UCI64bA2EL87Ef1o6i9c+xWxJERDa/0hnY40nlKZOZ/odwwOUYvGDl
         LU7BzvU3spDK0yoIOhLX9ui9PzTtoGF1koBbAB1TsgowoYaldgDM/KEpPKagavkmqv65
         A/MQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=6TT4hOLY1K73fDIL51uEPsxccZa0W+CXeROOV5HZmgA=;
        b=hvseuAsUfCkQXZ4AsZiarL/a6iSUR2L+i9MrmsBtmwNRZ7bmgP2PJ4JOWF5EC7s3Gt
         PAX8iA9kbEHfCghSgoZuZy7/Y7+SsVE5iwZFt9VhkB0+/K/mrZ34uD2SngfJ4OQo/XQK
         clxC5rxWdnmh6HBemhnX/+KuFt9STlfmfBpd5NQ2onZvl4ybohOX8MugkLvfj/HNnRTb
         6hYpRG7RR/7vxWODA6Tex3QVcUelQFCvsMrcMn1I1ouolnUZ/cMGe+ZDn7N2qP1AYimj
         YJxkOE6YpKDpL+X1FrcQeB7ab+9SD0F2rtebILmnQ8wuGTzfWBbnE9CgmWAeEYOgXL4l
         44BQ==
X-Gm-Message-State: AOAM530Z6cWaVwD1LUok7LdwKno7pkDQv9v5WNEEe+P8vcA0xBAlvevF
        xfA/2EEY1zlOh/c6qdTarI0=
X-Google-Smtp-Source: ABdhPJysE6YSCCLLPFzwRL4lYhNbyDmnNOcco0kdfRGWbndFhstFV3cFeKjCKIo0qtiupNPZaZ/qsg==
X-Received: by 2002:a17:90a:69c5:: with SMTP id s63mr15218482pjj.190.1628342194170;
        Sat, 07 Aug 2021 06:16:34 -0700 (PDT)
Received: from localhost ([49.207.135.150])
        by smtp.gmail.com with ESMTPSA id v5sm1979460pjs.45.2021.08.07.06.16.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Aug 2021 06:16:33 -0700 (PDT)
Date:   Sat, 7 Aug 2021 18:46:31 +0530
From:   Aakash Hemadri <aakashhemadri123@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.13 00/35] 5.13.9-rc1 review
Message-ID: <20210807131631.7ca4rrl6744i6rhx@xps.yggdrail>
References: <20210806081113.718626745@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210806081113.718626745@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/08/06 10:16AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.13.9 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 08 Aug 2021 08:11:03 +0000.
> Anything received after that time might be too late.

Compiled, booted, with no regressions

Tested-by: Aakash Hemadri <aakashhemdri123@gmail.com>

Aakash Hemdri
