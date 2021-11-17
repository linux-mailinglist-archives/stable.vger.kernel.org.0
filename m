Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6099454EA5
	for <lists+stable@lfdr.de>; Wed, 17 Nov 2021 21:35:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbhKQUim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Nov 2021 15:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbhKQUik (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Nov 2021 15:38:40 -0500
Received: from mail-ot1-x32a.google.com (mail-ot1-x32a.google.com [IPv6:2607:f8b0:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3720C061570;
        Wed, 17 Nov 2021 12:35:41 -0800 (PST)
Received: by mail-ot1-x32a.google.com with SMTP id x19-20020a9d7053000000b0055c8b39420bso6933826otj.1;
        Wed, 17 Nov 2021 12:35:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=P9GKLotnpjCwT8eSkrcL/meVfgrl3nnctRdp6Ghogrg=;
        b=H21Wglcw/94OpW/qMZUgxwCzvB9I3/YNMnbuxmrFyX7GkW57ulpUR1m9+hlwVWHPZd
         auSg8XzfZbxe4EFT2BHVKCppfLDtR8Tz8ZLgwpauFINylJWYiyAfUIMlVmKUcTGqgqAY
         VQ4bhD0kOiM44iZep5Zaid9gq7VXdkHY3Nac/Oc9eqrapkqBPY0quaRXarDU1P6VzP2C
         z2aD6Tv5nOG4vJsnTvDxy9y7V/M+mO1YouvrWqhiSBurMX+BETCrveYpqQMe4GkTiubo
         o9/trJc09ayN816gS1exDgGDXd9kPP6oYPfAPGbrSxNO5SQvGe04JTU0LYvO0q2n9gRK
         YScA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=P9GKLotnpjCwT8eSkrcL/meVfgrl3nnctRdp6Ghogrg=;
        b=UkcbvkCVmN5PzkmBggLDQfwk48+MvBzbr4C9BhdiUInsJpwn441NvNhC9KO0C4alYE
         CZMkCGRGpplVoPdA+3lMM+ntWuDZhesWB7Bzp8K5DalP7DuvVbjvTM6TfwFR0AIJzKFF
         89/GMNAT6CACf1mJBrQQVtrSCx2fKKzU6n46pkbY+kQfccU6FouyIJCCIrZ2hzPeYJpv
         tLpE4yiBCcIkFk153LuVmx4O3w2yL9qWghpyDw9Eze7LqxfwLr1GEJqpqbXdbGKEYA7Q
         JaRT5K1MR+I+r0/eQ0No6igpNiL9V9jVJqnrvu65hQQklRqQTeL0lM9j0LYMrqpRVwlA
         vwUg==
X-Gm-Message-State: AOAM533t7G7cnQFueP/8jM7RUiG6BDKdAJ+9P4+ca0UtcFgsP4oCbkMX
        LOJsBv2scr8EdRPTFcoKxyE=
X-Google-Smtp-Source: ABdhPJzRnDswC8nDD3wqM8KReX1QJKK+gPfk9JR223p99GKc+CfepiwuomCMXU4ZnZjui1Ly0e0tLw==
X-Received: by 2002:a9d:f4a:: with SMTP id 68mr16630028ott.327.1637181340971;
        Wed, 17 Nov 2021 12:35:40 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id 16sm191508oix.46.2021.11.17.12.35.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Nov 2021 12:35:40 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 17 Nov 2021 12:35:38 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.15 000/923] 5.15.3-rc3 review
Message-ID: <20211117203538.GB3128294@roeck-us.net>
References: <20211117101657.463560063@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117101657.463560063@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 17, 2021 at 11:19:15AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.3 release.
> There are 923 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Nov 2021 10:14:52 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 154 pass: 154 fail: 0
Qemu test results:
	total: 482 pass: 482 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
