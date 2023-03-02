Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A424F6A8108
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 12:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbjCBLbs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 06:31:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjCBLbr (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 06:31:47 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A958227AF;
        Thu,  2 Mar 2023 03:31:45 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id p23-20020a05600c1d9700b003ead4835046so1976345wms.0;
        Thu, 02 Mar 2023 03:31:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677756704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=YxUs9fQ/V1M0mvAOjqgHaLDvTdZPjpXWiCFQQKoRef8=;
        b=X9G8Um8lNvQnCQ2XEDiNS52KENiWE3MzXGpyyqtLwyNTINESdlkQvKstE2YVhJ5ymE
         4EpeWaeiKQf5uoLqgv5S+AKDN0AS9p5ieIZjoa6FBBFU1gZuu1++gjCYVU1b88YhIVCI
         I5I2CzILdhSd/FzG0bCNFtwag2fRLhyDiLF18w8HFxfReXQDwCcTNevpKPqy+7IfFECB
         snGtbDksKb/eNd8nAnC3m7znkzF1ncUW1LU03GciiDRFByObZtjsj1qcd3O9v2Lgp23I
         OCODtP1w2UKjytsnQrQ/Yvd1scDnQ3CwZQyiDuQ9JNZianpT+9XRuMZluN0GwUs4cvOo
         ej6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677756704;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YxUs9fQ/V1M0mvAOjqgHaLDvTdZPjpXWiCFQQKoRef8=;
        b=N7T04vvZhDlCLc8MgrMjU4umHFpX3qyqlOxjUwAWV00In5HwP9YDCdi8Kkwdr8VvZF
         8dPmmcBjbGVi2EwiH3SbtZopXtVVaCs9MdNi7yrzwiXo6NeJGMTNnIlbMN9T1u4b5W6L
         CCuU3KDlFEn7R0GHQ/KJZh912ebbgiSQuOB7FVRxQ/d/mZa/SXWSGeAhinHDBr1/bAl2
         WfyDdPzzuGsVsdGXL617pNiQWMTKfJ8u9N7EIlyIjGj5kMN2esNmb8m081aNRHoqEZ4v
         fBEDC2RNOCe2BTKO4Ftrmo8bG4iHgrC9gEU9dVZCIrBcsX4bDGzuCD6xqJETCGgNYk6B
         BdLA==
X-Gm-Message-State: AO0yUKWimmYJf0cX99Rt0gF/PozgKBEgxJhA3WWPXBHPGjWJ/1EQyoDR
        fpqeKBfuyycFy5f/5h0VTTc=
X-Google-Smtp-Source: AK7set+39WtzZQ8rxQtBAPLpClVuwY6Ygm+lRAIOqb8ODnldgD+6kl5CDffdMQIPnyDfhBJvYMBlUw==
X-Received: by 2002:a05:600c:3093:b0:3e2:153e:6940 with SMTP id g19-20020a05600c309300b003e2153e6940mr7461131wmn.3.1677756703833;
        Thu, 02 Mar 2023 03:31:43 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id l8-20020a05600c4f0800b003b47b80cec3sm3171681wmq.42.2023.03.02.03.31.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:31:43 -0800 (PST)
Date:   Thu, 2 Mar 2023 11:31:41 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 4.19 0/9] 4.19.275-rc1 review
Message-ID: <ZACJHW152iBecARu@debian>
References: <20230301180650.395562988@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180650.395562988@linuxfoundation.org>
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

On Wed, Mar 01, 2023 at 07:07:16PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.275 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2971


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
