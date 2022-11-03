Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F03C3617C58
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 13:17:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231550AbiKCMRu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 08:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231532AbiKCMRs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 08:17:48 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFEE060F3;
        Thu,  3 Nov 2022 05:17:47 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id h9so2552384wrt.0;
        Thu, 03 Nov 2022 05:17:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WdkIuvjlP1dhOTYraDqnPb0//zs6VzB71u/zOGD5n9Y=;
        b=opRHxLtj1y1lqRuQOQjiwtOjTo3eUOpN/LjEJnVIUe38vkiaKzx0h+i85y9PRIEWqa
         OceIU8GDV8nJIMezFJ0EwoLMdet8qobRfpJlU7LR9hJvrFuK8XxOfPVmIksczwhGtBTZ
         TJPMQli+KMVd3jOu/DdVbVGd6lCzoy4XsFh/6GV71IrEgr//xR/kD0TXa/dIAmnj78mF
         aMNtAhHuLmqKiAxFIir0uoSCj5drX7hYKX1v+ZdrvH1JcPnOtQK30ZhWpVGySuzOQ1/8
         tIXP+5PeZ9c8ts/EeF+bUoAZyDSVegoxdv52hhLxGzNtF/cmGZaNf9muGUKOPYq2LujT
         BmyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WdkIuvjlP1dhOTYraDqnPb0//zs6VzB71u/zOGD5n9Y=;
        b=EFEvOROvJ74jt7aNmqikh31Rw/hHtS2DAjjmFn0DdCLrY9W55QfNw70OQIbr3QbN3x
         hNLLTKuAhcl9ZjEwPph4644zqroC9v1Wsvw7zuz+JkTHBz5UqPpdvWDzHtoIa1jOqCLw
         bbuttZrRJv1DWNSAzSqMq+i2WAd6yd46J3Rxs84sJDkZ1Yysk7itoazi+5mQd1PcD+gp
         EU6fnbxxtsnj3YrILBZIcwqq5aOm9/zn7vD5XVEjYuB59FclU+kARicHHNwwf3zdSiwa
         yQmnCL8ybl88bSLzrAP/fwpbZqerAvuJrGQJlue7vCnJF6SgRf46it1KUstBgKLTC+ui
         eqFg==
X-Gm-Message-State: ACrzQf0CvW75CCdp0IKNCrYefWujmnGkuX3RBms/iwp2qCfwne56YbFR
        9sXUIUtQjDQvklx9Nn7xNmQ=
X-Google-Smtp-Source: AMsMyM45IdI/GW7mL260kptwwJsBWTRJKxir0xVshJKMALJZG3UBPzRYP1XB6DISbWnmCOdDGnzn7Q==
X-Received: by 2002:a5d:6e8e:0:b0:220:5fa1:d508 with SMTP id k14-20020a5d6e8e000000b002205fa1d508mr19373229wrz.337.1667477866140;
        Thu, 03 Nov 2022 05:17:46 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id a13-20020a05600c348d00b003a6125562e1sm1067384wmq.46.2022.11.03.05.17.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 05:17:45 -0700 (PDT)
Date:   Thu, 3 Nov 2022 12:17:43 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 6.0 000/240] 6.0.7-rc1 review
Message-ID: <Y2OxZ58XaYcfOhcG@debian>
References: <20221102022111.398283374@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
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

On Wed, Nov 02, 2022 at 03:29:35AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.7 release.
> There are 240 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
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
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2090
[2]. https://openqa.qa.codethink.co.uk/tests/2096

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
