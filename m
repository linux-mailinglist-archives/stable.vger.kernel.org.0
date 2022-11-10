Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF54B62409A
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 12:02:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbiKJLCG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 06:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230381AbiKJLBy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 06:01:54 -0500
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208E16C72A;
        Thu, 10 Nov 2022 03:01:51 -0800 (PST)
Received: by mail-wr1-x436.google.com with SMTP id bk15so1670882wrb.13;
        Thu, 10 Nov 2022 03:01:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qwVlhKyjAqadEs+EcXaVXZXm59VZBVI2UWpnsWBfohc=;
        b=ArAT78dtQ1LjisEGZG3pTBQt5HrIKKY04HEkhLvfGO/r/9e67iqQOAyWor/GxtaA4F
         ClSQKShwC+9MQp2KfENv2A/a0skEJw2MHN8enpTq/q40eEI0SvyEFsDWmeynwdRCRlTn
         sYmGCbiGz3Jgc6Uce+UQsTTtZUMJS2DJk+5K7Pi+PXgWRGc9m780827nEffQ/hPG2r0l
         4Dzc2WtERcC40Nljm+esM94mU0WWn9grwUqq9xTEQUmle8xGC4V11rqtI+TacBtoptlj
         ty5yLxhkKf7hNzDjVK9VqE3/jbPKKdK1qFpYmKDZ9DtcFUStQ6Va5HBsdioIT+DsoBOd
         tZNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qwVlhKyjAqadEs+EcXaVXZXm59VZBVI2UWpnsWBfohc=;
        b=sVAsvhQLXCLR4ODC21eoBWR4E7A8qjooqVynme0SXeGuPEa5Dq8V2yZvgxnSkFYaAd
         D6bgzq73P1FNh3z8WsX76CtXiRtXW4d12d+eNELZz2PCDE6Gz64kANemLAU0Z0inZ6br
         8X5+8KpOi6XmS/iYfaylDg+3OiZ+Q/5KbU6QlaLj9+qfz2FGysIwzR3pQ3epydlEJwKz
         9JHgfuUIY6jxWTG6Yr0ePafjHBYYO0OoocKXCae3u7bTMQd72qW10TaX5/ZgI63aG886
         1wNcaJ3H5NJpYdBFegWjErGDMzHWZOvJ9DG7cux8wHp9yfDI3iyjjqh+8D4l7gnNI5oa
         vIyg==
X-Gm-Message-State: ACrzQf0ZhnQgBLI3FQ6VCcE7etb7zfWN73ZP6UHC6v2uN/BCc3OukNoI
        1VwWHdGzD8gNVby093p2rsvTkyhrq90=
X-Google-Smtp-Source: AMsMyM661UjkKr37EV1uSH5xPOCcFl3fqWzZ+QPAv7YAdSe7Bt/HNMU7Wa2/TjPm/VlvVn+PbPTGAw==
X-Received: by 2002:a05:6000:1888:b0:236:8b32:cb47 with SMTP id a8-20020a056000188800b002368b32cb47mr39150806wri.601.1668078109562;
        Thu, 10 Nov 2022 03:01:49 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id o4-20020a05600c510400b003c6d21a19a0sm5274531wms.29.2022.11.10.03.01.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 03:01:49 -0800 (PST)
Date:   Thu, 10 Nov 2022 11:01:47 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.15 000/144] 5.15.78-rc1 review
Message-ID: <Y2zaGx2TV0bGf3gM@debian>
References: <20221108133345.346704162@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
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

On Tue, Nov 08, 2022 at 02:37:57PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.78 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221016):
mips: 62 configs -> no failure
arm: 99 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2128
[2]. https://openqa.qa.codethink.co.uk/tests/2134

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
