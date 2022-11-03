Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 619A2617C73
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 13:22:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231610AbiKCMWW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 08:22:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231657AbiKCMWS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 08:22:18 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC9D3BF44;
        Thu,  3 Nov 2022 05:22:15 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id bs21so2515176wrb.4;
        Thu, 03 Nov 2022 05:22:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=pSgf6jiYcfVtPWJQMVHTmOxF85M+YtjytNm5UST5O0k=;
        b=izbaHHxtCFkvePT07BD1qfeuZBIWMdSM+hGVg49RzP/uKs+dO61RU5yF15Tg80cJoq
         gaRYbkyeksP+CTqljNIUQ0b6AgBz92SuOMvC9RcHexPmGB+G9BDCy28SF/16XYIvUTjq
         46UPaoUy4I8cpxmn/a5bk7+7IPvMgFQxUZOvIaX6BV4eGUsUbHKOb7MpLaBHuRFCx7O7
         PTST+o5fKhtQZSgkTBqmGt8PlhMlJXbUCM3BwLoeu/8MunSi+4yO8K89IToJ6uvlhajS
         6N9qAe2PRBx9xkrBYYwknkRCHm95OJpq9bIEvl8o+8uSabL2d44JDmYSooqWV70imV0e
         xm7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pSgf6jiYcfVtPWJQMVHTmOxF85M+YtjytNm5UST5O0k=;
        b=T8PxuMVePJwyloHNqKhWlTgJd/G8Cmf62luEVp3memYHaikydDKcT1aqZs0wZ7Bif9
         1hDwI1wJDb8df1tbaahI5cRzL1SE2NRKDw8akoBm/FnchqgUlCzQAM1VhlWANz7f7cMZ
         foN+DRk8oUW32AcKPkP6ODuObpqfol/IiGvMXfBH4PsAU9Xxq87reeOuZSxCLyzmQmzl
         /l4akzaEFKSJstP0bVsPDlcyHPaOc6ztVzNukDctgiBbMEpJp1irEepRAkhJFW8qtvFW
         aNjDYgMhXWs2KN1VNFxA/gWG/SRa2x75VHJANgiS0D9j3lyvzGWtmYtcnNbncazfyYVe
         mVsw==
X-Gm-Message-State: ACrzQf0mhuvjjgZyqw+X2s2q1xRFihS5eUAXSczM4p0MukEGtRJqaYSW
        MmV9DWaINqwbs7b9lu94gKQ=
X-Google-Smtp-Source: AMsMyM6fUf6Ip8ggD+ZWUZAq2zpubt3x556zczWNAjLLXW0IGOAdHI5bI99XkXh1Q+13mLb6xGThUQ==
X-Received: by 2002:adf:e6ce:0:b0:236:76a2:fc80 with SMTP id y14-20020adfe6ce000000b0023676a2fc80mr18647287wrm.163.1667478134068;
        Thu, 03 Nov 2022 05:22:14 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id ay5-20020a5d6f05000000b0022e57e66824sm966032wrb.99.2022.11.03.05.22.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 05:22:13 -0700 (PDT)
Date:   Thu, 3 Nov 2022 12:22:12 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 4.19 00/78] 4.19.264-rc1 review
Message-ID: <Y2OydDkyWRIWMu+t@debian>
References: <20221102022052.895556444@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022052.895556444@linuxfoundation.org>
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

On Wed, Nov 02, 2022 at 03:33:45AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.264 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2086


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
