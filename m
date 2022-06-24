Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9B56559824
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 12:47:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbiFXKre (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 06:47:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiFXKr3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 06:47:29 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C91746DB1E;
        Fri, 24 Jun 2022 03:47:28 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id ej4so2863776edb.7;
        Fri, 24 Jun 2022 03:47:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bYg29woknCQ6YI1V/lANnT4EEd595Gb7iV+3ALxohGg=;
        b=cn/pOnKMcNV98NuiqPGmSYGEj1UGVsjmV7glBIVkJCvO9Jv28KRiFY4k7pWJTAdTcD
         fbGFqiW4O8jeIkrkGnE25Vk16Pu9fixA4bCBQHq/ZPNfHCEe0hbzmhA+TLFW4+zN+FVx
         1UJ9vec9+qdLU6QX+LxDsKqpIWlvzDOvAy0vF79vGrMcmXxlGjQICEc/ILhflXwkDgxi
         FLQYt9ja4k7Fp0b6a9ud9PM9mZDMZeCYp7aitqOpY0gogXRT716zKLe3TdvnpH4kb1JK
         nY7nZIqa9ZGnlmVU6hYfzVcjb8MsMX99l1FvKsJv7bRcvRDIK0a9SB9Qyxbvq1/DwP/c
         x71w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bYg29woknCQ6YI1V/lANnT4EEd595Gb7iV+3ALxohGg=;
        b=e2w6MwPSZvqKRlPw2Ogmjn9cROuFsaWziCH+GJNXEQ5tYfvDAYj8tWvroziQWEf+YB
         argTBURqcaT8w+wO1S7UJWMVsDpGTU/Gw0Hc7qngwjJno5S1v31eXWAaSDObF7x1OEDx
         WXz/Mu4p2KqqyAxwcQQ8k3BXUfUHFggss7ztw3cPHIbXbJSU2VAmmCPbXaKiQBk1gLJn
         5febpP8Dgcf+7iVBqb6XkOMCdIOwzfdJ1HeyQMbnJS+SFgwbpeA+ckCZbSqaDfe7g1lR
         LjbQO8ydwIyycWxtxEnDMh8iVtZlWk5nEImIEoa5q1EactbU2hJ3OvJPJwihEf93+oeu
         /0Mw==
X-Gm-Message-State: AJIora8K0H89R9d496N7bFsN858+dtzJ4KLXyMH9iT6D8txa4DsNOqqh
        Us86LmIPCp93uZZI+N3c+r8=
X-Google-Smtp-Source: AGRyM1vDa9qxzihE8irxoVi7/WxiJreOEcAR5Dn1lYa6rM56JcMzV+tcPkBvrhe+YIS0OTBKPk/pNw==
X-Received: by 2002:aa7:c952:0:b0:434:edcc:f247 with SMTP id h18-20020aa7c952000000b00434edccf247mr16383420edt.412.1656067647434;
        Fri, 24 Jun 2022 03:47:27 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id c4-20020a170906340400b0070abf371274sm907323ejb.136.2022.06.24.03.47.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 03:47:27 -0700 (PDT)
Date:   Fri, 24 Jun 2022 11:47:25 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 000/234] 4.19.249-rc1 review
Message-ID: <YrWWPSlx3j6wINAY@debian>
References: <20220623164343.042598055@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623164343.042598055@linuxfoundation.org>
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

On Thu, Jun 23, 2022 at 06:41:07PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.249 release.
> There are 234 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220621):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1383


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
