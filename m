Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 784E163EF3B
	for <lists+stable@lfdr.de>; Thu,  1 Dec 2022 12:17:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231389AbiLALRn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Dec 2022 06:17:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231437AbiLALRD (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Dec 2022 06:17:03 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D29E52CC9C;
        Thu,  1 Dec 2022 03:14:30 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id u12so1179205wrr.11;
        Thu, 01 Dec 2022 03:14:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=A05Qt4D9Ellap4EINVcsvsioMqjg/vGDGC8jqUvyTYI=;
        b=AQWKATtzvkMmlcaUcHY89svb5GQg/Bo1zBvsYa45AHCj48B/tFpDgSlo+I91PtmC7t
         EhV6Y9DSD0MLb10876JjHkfQ08r4CxqIk3/YQIpVQkY8RGK46iRcaw5uKvylXmPsPrn9
         yDjH91IoAMPfaQ0oUB3bfCSHvmQ8JsDrXs9qKiLahpCcZRvV+6bLlxB7dBvWGAuDgQj3
         ZpIlIO1L5ZSOnXJSPQmWw7rtiKkeu57nsckXW+k++GrRZyqLvjnF6jWngcNTxIS/6dOU
         ZN2KH2qsC1PLBf+z8t3fj5+jdZo6ys1tdG55AFkARWlm3KDjcj+GdxrKTlajdSCEfdeq
         zc/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A05Qt4D9Ellap4EINVcsvsioMqjg/vGDGC8jqUvyTYI=;
        b=i/9HLAvXDJGZno8+gl6rbzMkEyHge8eSLnZ/d7QOIh5QfChjjgM0friiEhC9uXfNEx
         Si1j6VI4oR8aRWsmDQ9JQB+mIp8wTdWJOAbCQVoxUAL78Bus8kdt//HIWsBDgU4QfJPJ
         +aRLUON0ZLIJbVhmbxQaocQmXywUFHQpU/2NLQgkNg3GIeHWPIKHk9C++pYa+daYctQ2
         80XUxnZl3HBLkPbLKjWYDWhN3Ro7RMwAHvJ74ImKOTBJOVd7RIwjoxHPHtKzupUjtfpN
         1h3iy+4/Zbl85cxK89+sJapjSnnG04LRGd0WEXPjzP4TMSpjvOVAGI6bACXx5tGp3KV7
         hWNQ==
X-Gm-Message-State: ANoB5plhDDwIBdQbTCbXfguqLK5/KiLkOZ27hT5r5xBhGm57G5DgtW6K
        /ufwjHXOolyatIlSbm1f/+s=
X-Google-Smtp-Source: AA0mqf5zuBJwalN4us6585M1gKgEw4ctUsFcPCOkqLCJtxSoxJB+9RJyvheYdkuPjjSO8icseiDkvg==
X-Received: by 2002:adf:fa12:0:b0:242:1c:7507 with SMTP id m18-20020adffa12000000b00242001c7507mr21499950wrr.42.1669893269226;
        Thu, 01 Dec 2022 03:14:29 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id n3-20020a05600c3b8300b003cfbbd54178sm9184251wms.2.2022.12.01.03.14.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 01 Dec 2022 03:14:28 -0800 (PST)
Date:   Thu, 1 Dec 2022 11:14:27 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/289] 6.0.11-rc1 review
Message-ID: <Y4iMk6i8pe1/9ke2@debian>
References: <20221130180544.105550592@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Nov 30, 2022 at 07:19:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.11 release.
> There are 289 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 02 Dec 2022 18:05:05 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
mips: Booted on ci20 board. No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2253
[2]. https://openqa.qa.codethink.co.uk/tests/2258

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
