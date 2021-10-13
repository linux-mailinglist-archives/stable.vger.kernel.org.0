Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A3DF342BCCE
	for <lists+stable@lfdr.de>; Wed, 13 Oct 2021 12:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239285AbhJMKbt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Oct 2021 06:31:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239036AbhJMKbt (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Oct 2021 06:31:49 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D86E5C061570;
        Wed, 13 Oct 2021 03:29:45 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id o20so6695263wro.3;
        Wed, 13 Oct 2021 03:29:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=hSQquE92GDIuuMjM8ONsdIor4uJxoCxMYcxZ2sqF8q4=;
        b=UQAuEDBMIoT6kzbdTnB/fM1CLB7BXXJz5uZV0VM8Bg4RKlMPdSIDcZz8VqwP/8/fLa
         B/MlmhNYGstOL4WTkrqJNACagDNc+URX0stJSpzuBuBDyFvcPWjRsUFXDy5kcbxNWwB+
         VqEbAO+0AyeVN+jcSv5n29dBp7/p152qB+yPnYGULnw1CDlGqCKm8Qtd4nJC5tassKLK
         dugjuE4Otc4D07YlTi7UrYSeieKwJPHaHcxM+jgvJ42pXLcjqWAf5CgO2KykZ7kErmNa
         2XSl6HP4DidsUgf8p8i6bowy7RygE/feJ8amKl+BaLDNNlnz/QrkMo6wSm4HiwTSbv/y
         vuTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=hSQquE92GDIuuMjM8ONsdIor4uJxoCxMYcxZ2sqF8q4=;
        b=a9SZ/PPztCAGqyhFB2VeHP5GDthDsEnCPD1Kju0xbxLgp9fTNoyRzT0S5UKujuGY8S
         6JDa2IlA5RVs6dpaDwt5j2k1+Q4VwCa02U5wlbmtY+OlvukDhS8la/e6hxdQYl0kiAGo
         /1JlmGoPQnRjqgkn3vEGf7wuySC+nWEe33P0HYfdKbnYC6yWRhVG6zmKu2o0rhpOjxoC
         ySsEaGYVTxVscOJHeisRs5bfzgkxut0dGP9dnXcKisPCBB9S9b9xU3GxcTZ8TyyYiiPK
         Ak/uX1uOLdos2LtAPYDrtT3j+I1jCxQYCd8Wkb0/IzlPRhZVwl09PqogPEqDvmxTYOox
         P1KA==
X-Gm-Message-State: AOAM532kW8vwooR5RyD50ct8uT2uekV+bfZgVktU1IwBfoeHTrUV61HH
        /MUQ0WEGkIxA3XtPgELNu6E=
X-Google-Smtp-Source: ABdhPJx1HlDJSRWXvnkLDu8qeckp6tcf3and983LajrUGkC1CoaeqlQY7BxhLjxgqse8LR7C0ZfI9A==
X-Received: by 2002:a5d:6c69:: with SMTP id r9mr38195357wrz.280.1634120984469;
        Wed, 13 Oct 2021 03:29:44 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id g144sm5082913wmg.5.2021.10.13.03.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Oct 2021 03:29:44 -0700 (PDT)
Date:   Wed, 13 Oct 2021 11:29:42 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, stable@vger.kernel.org
Subject: Re: [PATCH 5.4 00/51] 5.4.153-rc3 review
Message-ID: <YWa1FgMT8axoV7Ez@debian>
References: <20211012093344.002301190@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211012093344.002301190@linuxfoundation.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Oct 12, 2021 at 11:37:04AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.153 release.
> There are 51 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 14 Oct 2021 09:33:32 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20211012): 65 configs -> no new failure
arm (gcc version 11.2.1 20211012): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20211012): 2 configs -> no failure
x86_64 (gcc version 10.2.1 20210110): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/255


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

