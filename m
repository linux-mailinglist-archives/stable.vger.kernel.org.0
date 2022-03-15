Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAF0D4D9B28
	for <lists+stable@lfdr.de>; Tue, 15 Mar 2022 13:27:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241936AbiCOM2u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Mar 2022 08:28:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239134AbiCOM2s (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Mar 2022 08:28:48 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E86D9532E4;
        Tue, 15 Mar 2022 05:27:36 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id g7so75213wrb.4;
        Tue, 15 Mar 2022 05:27:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vsPzKwTS+IeFWwMuAO6niSRyxPXe0xb+6y4I6aL7QW0=;
        b=NL+6mVXVc1ULntZn6zGAnso0FAmQ76WRKZ3Jvq9anuufLIQW4RBIIiMcAPEm4jCuDK
         ykfi02g0nCetjIZaq5XYPak7KEGHV0Ad6AXxKhvlnFKzhFx6o/EwwV499I3AQh0hgaS3
         h7UQAbtGfuQ/V2n4944je+hTfTSIBRRPO7CKnDvjsFGWZqviwTzPkndcYnfsNyCkH9cu
         UswbkIffl6AtqT74VVSlcS0rSP1/c5uN4reY/b6n3JRGBFmzko/7MzeQZZ3EMK/yQ7pE
         /BK1OjThtOw472gixxuHu8oGbPSO+0VuluSIHvK+IDe+gOdO92LFnLdmGGsM65nW3ieQ
         B06Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vsPzKwTS+IeFWwMuAO6niSRyxPXe0xb+6y4I6aL7QW0=;
        b=NuXIwvrKI36Xp+KlqDa41kSncuz98xG8C5BCKwsQGm7xSAC7wdw7G0h3nimCigva8A
         McPRoqKXjYUpxLw2n4b9WE0iOZV72RHMK1oSP1r8HDW1Vs708gt265vx4xaApKJnoagB
         rAR0htYIRCpXdSVitTPl9LPBinNg4DrrsSFBN3+U+uVWkk3W3lQiWpxdJh5RtwXp4y9+
         R6PiLVSZRAbqzFIWGlgv88kIDTrV34olbQ5dcUKw6c+WQPqLMkkRvBzSn/NfqdAU81K3
         t0Ci/YhK0YMgJb+g+m44HGB+mhr6t0mfxThQmYQZSmJiKiPm0FnZzmuN0qpsXIPJBqae
         zoBw==
X-Gm-Message-State: AOAM5323K2U+cpR/RRpWGUVftla8LdsuDx2d29rneT5MdemyZI/aC4gj
        sy9Orb5COe55R6EMu8bSlb9ZVo/U3oE=
X-Google-Smtp-Source: ABdhPJw9ZyXSSVehYTlyuH3WFHXnRE2RC1Xiin6VmXbIKq+x3kPvEhih+fOd4MhV9lnNokBxAfg6/A==
X-Received: by 2002:a05:6000:144d:b0:203:7add:fa71 with SMTP id v13-20020a056000144d00b002037addfa71mr19819711wrx.526.1647347255342;
        Tue, 15 Mar 2022 05:27:35 -0700 (PDT)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id g12-20020a5d698c000000b001f1d8bb4618sm24282118wru.36.2022.03.15.05.27.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Mar 2022 05:27:34 -0700 (PDT)
Date:   Tue, 15 Mar 2022 12:27:32 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/29] 4.19.235-rc2 review
Message-ID: <YjCGNH2AWqpbIICA@debian>
References: <20220314145920.247358804@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314145920.247358804@linuxfoundation.org>
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

On Mon, Mar 14, 2022 at 04:00:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.235 release.
> There are 29 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 16 Mar 2022 14:59:12 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220301): 63 configs -> no  failure
arm (gcc version 11.2.1 20220301): 116 configs -> no new failure
arm64 (gcc version 11.2.1 20220301): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220301): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/880


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

