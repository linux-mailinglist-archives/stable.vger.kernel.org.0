Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D5486A0D0C
	for <lists+stable@lfdr.de>; Thu, 23 Feb 2023 16:36:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234271AbjBWPgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 10:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233711AbjBWPgo (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 10:36:44 -0500
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A83B117166;
        Thu, 23 Feb 2023 07:36:43 -0800 (PST)
Received: by mail-il1-x134.google.com with SMTP id z5so2043375ilq.0;
        Thu, 23 Feb 2023 07:36:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:from:to:cc:subject:date:message-id:reply-to;
        bh=36iVwpCV67m9Prkpccx9jdmSBAdJURQNVTWbUuLnUCY=;
        b=BNBb0KjMyeaKHRnNZ7WDhi75KijWDQMh8N6WQCf/Da2M5bwNApRq0nANHRIiNxNKMh
         s3a7nWHBM7ERmCJ6SW3A5VaqmL4mJsqlN0r2aGAf8b1UFo71ejGmLUPGKayOD4R52M+W
         U5UB9KRiWaIQLlOtV4ewfv8naNzKpoqVf3wgNE27maLBb19NcikXU+5vyY0qMd9lIfwH
         jrD0J+XorA/GpgwJP3ohaKVGCD5SQOf4H5oOTn20H3VKoNiCPFZhYEh6UD0L4Q+BUHsS
         UxFg8/Qo8VV3Bu7P2Sbd3CwR4gJLhUVKMpZMLdoqeoGjpRY4I3FTV0kPqh1LnXI8qUzI
         eULA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :sender:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=36iVwpCV67m9Prkpccx9jdmSBAdJURQNVTWbUuLnUCY=;
        b=yIbZ31FbpZg2Wz5lb6vRWOPyqOyCG9xUdATzoY/Fhx+Brn2V2tJ0ZnccFR6WA7RFXp
         Clg3To8W9tyrrqHy3M4ZnG5im4v4zNaT6tS/iil6Sfh05+iZcz8403PwoHoyJzdfaN8b
         W25EaOoE/nSAhsvXBw2FJTl3kjg1xf3gAgfj3mPqpBeSIn6+fBGHapwcAR0n9vq+zalK
         3hRJJvM5exliAdGW2uH/hEclvZBw6TEU7VmFOoZiZxAaoGQBlPZklpka7LDfB8tJwIS/
         TdKZBQaJUipB7lKGonWc4oCPhjpENySB+XW8DfG2HixAHx8N0803o3m9p2cOAbV31NCL
         x5cg==
X-Gm-Message-State: AO0yUKXkfzapqz6TimbfAITjYffVbZdiV4TnynDDRK/ZFnRFHJ7NSMiZ
        udKlFuSUV2ZobEt+rdqrx2Y=
X-Google-Smtp-Source: AK7set/d8ce+nfx1wyPSU2mw0vavT9Dq+UFpy2YXezikwY4hedoZNNyao43+7ZYzg0jJvyuAATDYBA==
X-Received: by 2002:a05:6e02:12c8:b0:316:fcbe:53c0 with SMTP id i8-20020a056e0212c800b00316fcbe53c0mr2230885ilm.6.1677166602642;
        Thu, 23 Feb 2023 07:36:42 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:329c:23ff:fee3:9d7c? ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id a22-20020a056638005600b003a9962a24d1sm1972834jap.122.2023.02.23.07.36.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 07:36:41 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <adc1b0b7-f837-fbb4-332b-4ce18fc55709@roeck-us.net>
Date:   Thu, 23 Feb 2023 07:36:39 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
References: <20230223141542.672463796@linuxfoundation.org>
From:   Guenter Roeck <linux@roeck-us.net>
In-Reply-To: <20230223141542.672463796@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/23/23 06:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 


$ git describe
v5.15.95-38-gd6f4f9746d40
groeck@server:~/src/linux-stable$ !ls
ls -l scripts/pahole-version.sh
-rw-rw-r-- 1 groeck groeck 269 Feb 23 07:33 scripts/pahole-version.sh

This results in:

make[1]: Entering directory '/tmp/buildbot-builddir'
scripts/pahole-flags.sh: 10: /opt/buildbot/slave/stable-queue-5.15/build/scripts/pahole-version.sh: Permission denied
scripts/pahole-flags.sh: 12: [: Illegal number:
scripts/pahole-flags.sh: 16: [: Illegal number:
scripts/pahole-flags.sh: 20: [: Illegal number:

and all builds fail for me.

Guenter

