Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9E7A56A8110
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 12:32:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229532AbjCBLcw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 06:32:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCBLcv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 06:32:51 -0500
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3318522030;
        Thu,  2 Mar 2023 03:32:50 -0800 (PST)
Received: by mail-wm1-x32e.google.com with SMTP id ay29-20020a05600c1e1d00b003e9f4c2b623so1475366wmb.3;
        Thu, 02 Mar 2023 03:32:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677756768;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=8SpiicYH8xSOqfzRZM/wdYAOIOdFlsIP7PTh93wHnR4=;
        b=h0TW0Xj2nPM39iYp1nu4PQfc8pClsCkrJDs2KqygKgNYNiCynrSB6OU0EktdvHfSrc
         3UnCZJ7nri7huoImTiH2wGh0LX9zeEA+Ua0wZrRlnko+qbUf5q+5jTK5V5i/+sNq173U
         LytwomAS/8aVLBloFtC/o1zKL4uFM9BZwdPsxuYnfR4jDQEcnRq0C01cCYSmXj8GZGRd
         vOnQ7BN0Rs4+zQR8sCpSt13axyYgP96p9+SV1iWixgv7WDtReIKjxXbpoROgJTUqLsEF
         u1FGQYhuRruAGvf1ofYdSKdz69wdjpAa4oSNDaF4oC3xQfC1cbQrVLiuynkVShSJdBfB
         /XYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677756768;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8SpiicYH8xSOqfzRZM/wdYAOIOdFlsIP7PTh93wHnR4=;
        b=XTTC8kwf/dLapbNu5KzFv7hjekzmU/Jhqy/WsvFWnNEms8BpEq4xg6aAp3KzEYwles
         D64ui5kKsktTdYV7zbH4JmDyXEPlydgOtHMXJKNF1pgnJg7vvZCzLBHLMgYgzlGD92rP
         X7JhlhkqwejrMRKVIetuv2jAkWhvhhTNlFh/8MwmKqqhfT9stU2GVSPlg2/H4T2IHmJG
         QZLwnC6abvvj1Pnd94u/YjUQzU33A+RyiNotVJSsmaIs3Y6GM07/XLgU6q59K8fw0jWO
         hgNXNcG+c/1Zy/I++cUfdGrk3WAJ1PT9rHNiB+yl6GEMGBib7XK6+P+2vKFhQEnE7inO
         q5bw==
X-Gm-Message-State: AO0yUKXftPPoOhiaUKaGk3n0jIHKQ81H0Aw5mH/MLSNeqREAd00KgZMe
        zM73Vx8trD4p9S4RHjyYlhk=
X-Google-Smtp-Source: AK7set+iZxK62GWEK4sOjgh6v27Pb9NPjD2OLs7/eVH1I6BtxiWgid3i/EUtu4mQTl7MqI+2z9by6g==
X-Received: by 2002:a05:600c:3549:b0:3eb:25ff:3446 with SMTP id i9-20020a05600c354900b003eb25ff3446mr7262629wmq.4.1677756768570;
        Thu, 02 Mar 2023 03:32:48 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id he11-20020a05600c540b00b003daf7721bb3sm2778576wmb.12.2023.03.02.03.32.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 03:32:48 -0800 (PST)
Date:   Thu, 2 Mar 2023 11:32:46 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.4 00/13] 5.4.234-rc1 review
Message-ID: <ZACJXtFWBPjQQXRj@debian>
References: <20230301180651.177668495@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230301180651.177668495@linuxfoundation.org>
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

On Wed, Mar 01, 2023 at 07:07:23PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.234 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2972


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
