Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3915E5B8536
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:39:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbiINJjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230332AbiINJjG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:39:06 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6732C6F;
        Wed, 14 Sep 2022 02:39:02 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id b5so24718995wrr.5;
        Wed, 14 Sep 2022 02:39:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=USQG9UiTTVxiR1ZIl3PeckbasEWI8JhNB+SIpCx4f4k=;
        b=Y1DBcBHKXXNIt4cheeGCONdEIbrtpszcZ3AunonF0jX2Po08/Az5y0MJWctIwTZt3D
         hEbM2y8AGXgPQyyelKDMSyAK3jGJXB7H0w2s9FC+O7+wzHMxdxFtnaCg3SawRFXjj2YB
         MqnLSd0vhvouxfF+56dM7nL5XzbAh1rXYLfYVFh3YBds36QV832el2bgUtB8ZRkRmG5U
         05RzQiw+mTg112OqaxmtqIzZ4jsaygcPdYCIRX0VBGq5nATNjpnPc/LhtOu/j9l4HF+P
         uTBsJ7rDx8Psq5dqFnANxzF8nGGaI0wGpwKkv75fckP5OLqmiGWcw0lfzMZ9ioWVRQ3F
         FBQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=USQG9UiTTVxiR1ZIl3PeckbasEWI8JhNB+SIpCx4f4k=;
        b=RWJ7iz0trAfOE4+CBuOkwakOFgMFctWc4yulZWWCFYtwGAim74jGWQveYUbOxojrAU
         GaaV3l7BsXRrObz+OdQraeRqB4AIzaTrm1uhQQDMJaFWqk+B/bh+FjhvQtof5sE0yhpc
         3rF1uWjztHVsvf5Q2Vio9VAkJCtu2LU1jXtQzGT/IRVfZIs7nBTO7T984PUwaydZUf9Z
         4PgvocQlse1YN0+1sRZyRnnSe1DBnBL+I0KD0F9DZynyJR60bex0uwbr+5VZ+ew1xnaN
         7L2PaOLw7V+uIqPJV14Hv0av4HML/f/bnJ8ZqNw+rSFzyMcxeWd25fDjg/mJlWvqB1IR
         MaXQ==
X-Gm-Message-State: ACgBeo06q3cc6JykT5aBYR0nHRMVS7pxmJ/TVSlmSaiOgrVPl7uQIyY9
        iIvaSyinQ8HmQ815N6WFiOo=
X-Google-Smtp-Source: AA6agR5+hg4yX2MqtsoU0t8Yyzywo0BIBOaiWsBKxIF0+1AuAjP+D2xH8B9E83erFi5aN6Aic6Yihw==
X-Received: by 2002:adf:ef06:0:b0:228:d60c:cf74 with SMTP id e6-20020adfef06000000b00228d60ccf74mr20750760wro.302.1663148340650;
        Wed, 14 Sep 2022 02:39:00 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id m22-20020a05600c4f5600b003a83ca67f73sm19005661wmq.3.2022.09.14.02.38.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 02:39:00 -0700 (PDT)
Date:   Wed, 14 Sep 2022 10:38:58 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/79] 5.10.143-rc1 review
Message-ID: <YyGhMqpSg7lfV0Uc@debian>
References: <20220913140350.291927556@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913140350.291927556@linuxfoundation.org>
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

On Tue, Sep 13, 2022 at 04:04:05PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.143 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1818
[2]. https://openqa.qa.codethink.co.uk/tests/1823


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
