Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBDA6532381
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 08:53:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231942AbiEXGxp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 02:53:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229945AbiEXGxp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 02:53:45 -0400
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B1F184A14;
        Mon, 23 May 2022 23:53:44 -0700 (PDT)
Received: by mail-il1-x132.google.com with SMTP id t13so4392537ilm.9;
        Mon, 23 May 2022 23:53:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=1LOOK5eaUWqnI53NP5MJqFE5NFaX42KOH7g8Jj1sqQw=;
        b=ZHMM8sUAT9TASkfd+Ti9J3EoyI6VZ/9R5zjTUbs/t0bN1xQzNDop6DQaHWSLNiYSyj
         y9zvBXxvzc3UHDpY6YIAPW9TYv+/NALQqNmwSar7s7bKRvLsLi5q7M3bHWB5mLa0oMO8
         vTdVz65oGsVlp4VgdjM5Cq68awx7zaWT78R69J48sPTY//KZ72ahgMqx/2rGMXKYRuk1
         seOBCRNJzPZbZIUIwQyc5m+fonrxkSGW1IaY0rjU+NQ55wvVruoqwiMkWV8shsi1sWzk
         o5CE/S2Bc62gbARaERJH+3Vk/162IajLVnBOE3aqCTfrbYfGZMmlYpN8NDKo4hZ/XGau
         avAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=1LOOK5eaUWqnI53NP5MJqFE5NFaX42KOH7g8Jj1sqQw=;
        b=yev1uv0Fhm4SpUCifUt5wWwRSxDCFDdkb/g3KmPamQjFPYcI6TdwbQU/e6OT91TzA2
         46A39X/bM3hq0yQXHxvXOFJiHZmkbzXo06Tz7b1VAE/Apb+Nfw+G4DTTQuz3TNcw4YqE
         S3+UC2pYgGD7zpKPY/47zxGFrTEfYekswz1H/nGr86zX8lukaYmfUezxMVj6ZhOaq/Tv
         1INVBufkF57Up8UHtrjJWGkVfiEhbePip3AqUxWV4j3z6I71hELI2IzNEyda/b8c7PYz
         ppHiocBElp9f9RRI7ydxKruall+6YWQ9HjPQrwfAJITV+GJd4FBboBPV/Hg/nbPYcG6x
         Y3/Q==
X-Gm-Message-State: AOAM530VbwbCUvulz47yWknvIn+Ffa7VdUwfrcVQpi4CVZehxxbcfcT1
        SNmhS/SJzyQxyv6iwEUTV3A+T2n+qQxIgOTouEM=
X-Google-Smtp-Source: ABdhPJynTUdbvpklBINUlsc1/KShLCTZH+W6kPo9ma0vLoRiInjY7ag+TbSr/+2Hg1QWyhbE+YyHWQ==
X-Received: by 2002:a92:c5d1:0:b0:2bd:fdca:18a8 with SMTP id s17-20020a92c5d1000000b002bdfdca18a8mr7448505ilt.320.1653375223385;
        Mon, 23 May 2022 23:53:43 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id 15-20020a92180f000000b002d1cb55be3bsm148084ily.29.2022.05.23.23.53.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 May 2022 23:53:42 -0700 (PDT)
Message-ID: <628c80f6.1c69fb81.3c569.06f2@mx.google.com>
Date:   Mon, 23 May 2022 23:53:42 -0700 (PDT)
X-Google-Original-Date: Tue, 24 May 2022 06:53:41 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220523165823.492309987@linuxfoundation.org>
Subject: RE: [PATCH 5.15 000/132] 5.15.42-rc1 review
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com,
        Fox Chen <foxhlchen@gmail.com>
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 23 May 2022 19:03:29 +0200, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.15.42 release.
> There are 132 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 May 2022 16:56:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.42-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.15.42-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

