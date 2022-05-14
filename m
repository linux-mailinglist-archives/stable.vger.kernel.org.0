Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63EE25271F4
	for <lists+stable@lfdr.de>; Sat, 14 May 2022 16:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233230AbiENO1O (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 14 May 2022 10:27:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233223AbiENO1N (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 14 May 2022 10:27:13 -0400
Received: from mail-wr1-x432.google.com (mail-wr1-x432.google.com [IPv6:2a00:1450:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 528692BA;
        Sat, 14 May 2022 07:27:11 -0700 (PDT)
Received: by mail-wr1-x432.google.com with SMTP id w4so14769843wrg.12;
        Sat, 14 May 2022 07:27:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=FHt6ojcVs0Fgl0tNR1AXah2gYxvncnN7tie6W7P3FtU=;
        b=bWta0x7LdYSK2YB8fMIveMZ0KzwwftEseAXcZ4q8/3GAj/BOcxNbV7WhgoqjXpmdV6
         cSpJSyWT3pQnfNK+DEstH+0KSNBjyoV6k9WsE2qg+055cUG4uh6RIrvnoqmsQTr01YaX
         +BW6KXBI5U57ELZgczOgsyrTPSq2Rjf2ZF+wR/rA45TNNMuLUVcl+I/9+YC2PC5MdVnr
         c4g1dfHZ3v7y+9LEoCqljW6mW1XVoyhJ5Nr8KWR/dr+mxRoa2qMudLE4rSQvT4nuT2H7
         y24HQyTisovb1Bg2BNQmVW9C74/D8l96ICA3j0HbRChMwUXvXxFZzaeErWBZCWmxGJyI
         rnHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=FHt6ojcVs0Fgl0tNR1AXah2gYxvncnN7tie6W7P3FtU=;
        b=eUZJZJZ1dplA4/XrBkDDuHMQeqIS2YtrADYEp4GJcIDSO5y1/hMno4tKK8eloc/sed
         5y2co8hksuIMzTTVX3vuPx/+MRH4eYAN97F5G6JJDKmPFc1DLqPxfSUtdN/v/O/VYLVd
         IW2E5gFArqy0Bq05sr4Wyq/Ozsxb2M7fP3YuTebAM8w7f4e5hyQPAJEP1jQTJ4r05c4I
         PJnNKzjEKo8LtCGgNsgpp647P/ab4ZEa8afN8m2d4XF6yvPChRgQWs5u06cSgjOG40LH
         ybCRps6tABECx3gPIiUSx9NxDPb65FVguNIEBr/I+2XHXvn/x8vnDVV9F9LHi/ZumOVH
         pplw==
X-Gm-Message-State: AOAM530fx9RXkqCq61+BTfqaKIBA1tmVYaCAH7wU1GX5rAOHCxFWonsu
        kSPBPS6ddURjv6szh3o8zkg=
X-Google-Smtp-Source: ABdhPJzkn+XAYfIorw3dte6qkkyhE7n7YHZtkyJZOuOghYYjG3a2Ph6xO1qjtyADXbCGbma4k0o3Zw==
X-Received: by 2002:a5d:6d8c:0:b0:20c:599a:4f7e with SMTP id l12-20020a5d6d8c000000b0020c599a4f7emr7871037wrs.324.1652538429924;
        Sat, 14 May 2022 07:27:09 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id p5-20020a7bcc85000000b003942a244f33sm8241263wma.12.2022.05.14.07.27.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 07:27:09 -0700 (PDT)
Date:   Sat, 14 May 2022 15:27:07 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/18] 5.4.194-rc1 review
Message-ID: <Yn+8Ox2+WqgxhYkW@debian>
References: <20220513142229.153291230@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513142229.153291230@linuxfoundation.org>
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

On Fri, May 13, 2022 at 04:23:26PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.194 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 15 May 2022 14:22:19 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220408): 65 configs -> no failure
arm (gcc version 11.2.1 20220408): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220408): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220408): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/1138


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

