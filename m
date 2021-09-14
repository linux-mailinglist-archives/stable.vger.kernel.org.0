Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 499B840B3EF
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 17:57:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234946AbhINP6R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 11:58:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235291AbhINP6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 11:58:16 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67D50C061762;
        Tue, 14 Sep 2021 08:56:59 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id g66-20020a9d12c8000000b0051aeba607f1so19158812otg.11;
        Tue, 14 Sep 2021 08:56:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vbnsPdOab4hDZ7/BQd8SKMRDF26Rph3hyJ+zpoVPI64=;
        b=SrG4xc3TSbiJJMfA8MsqGAGyjVYe85LfTz4MkPkcxEOyRmuBGIquM90nYzfubNihaz
         HuJu9b24uWX+6Oe/bGNL1h+LhDHLSOljJVyTb/HfXeCfKIQYTl/UYmj42DmpCj2QYH/X
         dPlAAjQtFJ8W8AfZxwNMN/C1iyMCKWx4A65JR1JbSA2P6dd6w00+4wpgZwpMhiaqdtYa
         liAG6roMt132+aX39yqjVlDLMURKgxg7FKRDdJOolaYjHQe7F5/QuuBhK+kEaEp34MMc
         YuIhtE8uCHH5K79wm2w9dzZ5z9emUFJItE9LaN5jLaDBSeyBipKJf5QMAMkhs9ZP5tZb
         YO9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=vbnsPdOab4hDZ7/BQd8SKMRDF26Rph3hyJ+zpoVPI64=;
        b=UN4hF06cWqBj1SbZIwiwrkkdQg/7Gr+RYS1KU8AmtFEI09rp5QpYEM9/YF9lsjfDpU
         JIzjnRuKMLU1QdpVsTdF8of2J2LDqtgCDRS5Hv6esZRlhgE1x+2g7siTKm+2POvmAhJh
         fnlYp7bmj4jfc3ldPWVXptYx8w76qnH1EjB2fdRGO9lvg6ZCdF/mRiyk5ckwUOjSeZIK
         Ry5EKtCwHxqNZ2AKX/g5uXPbhnaqRdu0h5Wqbs7cQCZUh+quLGTuQJIu7qAqnhi9loj/
         TcDuBNCEQa3osILOjp58CJrAJe6Yj5Cke26VIzXUCbm5Gu6oWhSx1gxCWQ8bdz2Xfa3J
         q7rA==
X-Gm-Message-State: AOAM5329WRIfL2FRZRFg3QELkhTdlFjQTionhFkAWYMghCLGWXIpfXMn
        I4Wt6cvTQuyrs1Wi42I1dzg=
X-Google-Smtp-Source: ABdhPJwAz+VmulyDGVeIKtETtjym88W20uU13Ezvafg3IgI0863/S1YC68tuUotR8/1Lqb0AoD7SOA==
X-Received: by 2002:a9d:17c5:: with SMTP id j63mr15813883otj.208.1631635018853;
        Tue, 14 Sep 2021 08:56:58 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id d8sm2581905oij.53.2021.09.14.08.56.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Sep 2021 08:56:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 14 Sep 2021 08:56:57 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.10 000/236] 5.10.65-rc1 review
Message-ID: <20210914155657.GB4074868@roeck-us.net>
References: <20210913131100.316353015@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 13, 2021 at 03:11:45PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.65 release.
> There are 236 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Sep 2021 13:10:21 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 471 pass: 471 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
