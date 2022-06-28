Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9408F55E456
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:39:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346346AbiF1NTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 09:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346339AbiF1NSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 09:18:20 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B445A32063;
        Tue, 28 Jun 2022 06:17:47 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id e28so12495512wra.0;
        Tue, 28 Jun 2022 06:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=C0uiEIzMwM+QS9y9PAfIiiiyx/gud5SpEyh77t+E9fs=;
        b=TeEy0unUdwrY3HLBHdZNg+U/Rzbv/Jw5gmKJBMD/yHvCo30NfpP6861qaswA+RgREX
         ZdfVwMP+0JusRPjyTcdCbvfN6Y2olZIzcTK61wTs69X/Sy5gHeEy0OVnavNpL08iOuKW
         DFM4K4ZAa0Pr8Pwz8C99DX8EeQCDyL/sznivJCMwPvEpN5aFRxPSjAMQUUA2PmWqUk4I
         LzLxdkwRxW2gcodS/i1z5yayu0B6nBLaNzhG4qxYyycvVP7jagFjB/y1lbgZXPbOfxnl
         vn0Rqt2m482yvr+IX8gIHATxFz7KHVhglwY8eIIa/WRvnyAL3h/VSbhLGHP7VK9auK3Y
         ZsJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=C0uiEIzMwM+QS9y9PAfIiiiyx/gud5SpEyh77t+E9fs=;
        b=4RMCmU40ZIzLDoknlsHFVzww5ZxOl83pW9/uYTtVYTD5xMnQ8OTMCaXFBqnR7ZNJgd
         GuC6zV2xhQisnUI933Ed6GTl9l0F+/eMWOudSEIwd6IG06JCeBJq0LFRulTC6mI6yv32
         dtFZRmRh/i1NQ0DTDjpDILHOEz8IIf4fzxGzUdTMIAqusk5LQmzzxmVBJmp0RuNV4YM1
         xVdBy7pPzjnrS5p0EaLVVqcBSMn6ggLMaaEZgsaS7gRRTbp+IUz/FgoljeFrqt1+ze/6
         G+PgylQdEbZdZT7EyZv7YZqDHWSvUto2N869s3GpWVmkdr6/sVatr2zMgoAzi3VYcLEP
         mmSQ==
X-Gm-Message-State: AJIora+FFua6PIxT2rTEICViaxnZKIz1M+uFBNkSqBYVNy9ZnmQ8mG5O
        u6ALNeRzZHceXrCgZvx1KFA=
X-Google-Smtp-Source: AGRyM1vctxmwPDrhhys9VZnDRg8CWt+5VToApgoRArAT+UwtEVSKoOUcWrSuVpsT5y/uPQFpaYYJrw==
X-Received: by 2002:a05:6000:2c6:b0:21b:ad3e:5368 with SMTP id o6-20020a05600002c600b0021bad3e5368mr17567854wry.60.1656422266212;
        Tue, 28 Jun 2022 06:17:46 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id s24-20020a7bc398000000b0039c693a54ecsm20251464wmj.23.2022.06.28.06.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 06:17:45 -0700 (PDT)
Date:   Tue, 28 Jun 2022 14:17:43 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/102] 5.10.127-rc1 review
Message-ID: <Yrr/dyiF2wDLUbQb@debian>
References: <20220627111933.455024953@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627111933.455024953@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jun 27, 2022 at 01:20:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.127 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220627):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/1402
[2]. https://openqa.qa.codethink.co.uk/tests/1407


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
