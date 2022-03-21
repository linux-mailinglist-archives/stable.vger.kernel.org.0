Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F2FB14E3464
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 00:33:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232544AbiCUXaF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Mar 2022 19:30:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232822AbiCUXaA (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Mar 2022 19:30:00 -0400
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693DE54F92;
        Mon, 21 Mar 2022 16:28:33 -0700 (PDT)
Received: by mail-pg1-x532.google.com with SMTP id d76so2071056pga.8;
        Mon, 21 Mar 2022 16:28:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=kcgU7Ygr4hDo5WFjwKdbti0JsL3etMpL87nJF1yX9Fk=;
        b=jBWzIVQbYv/gZClrGlj1CqaZZmtHw9V3gcUREV8rmsIuZvamHvkhVgte4mFL5Uh+NN
         99+3BXh+vtv5+2aPMao2Xn3+TxahjdK8iYMcSJos98P64RUBL/Naay3Rku9vL1URj0Pu
         LyVQnhOf7+/3PKSk7h2oPYTLpxCtZfO3yqXkDOvlufh9+7ZwdxEaY/xEyCdjgWJfZVK3
         rXaQt62DvY+SgMG/Vvv70oIOSTr9e/efLfw8lwq0ePKdTdAWTixieEM6b2yiwKLygEal
         jW71bozhUmWa1s8mCOyQ/EO8ZVCA//D9V7ODMTkfKlfJFjiWEL5Rp2D5bFirp68e6qPo
         rQQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=kcgU7Ygr4hDo5WFjwKdbti0JsL3etMpL87nJF1yX9Fk=;
        b=hx/g8itipTyXSE7lGAFuTdSZ7cEtYv182z9KqJfJ8IdjCfGFW4runx693WjlcXRY6f
         7maaOfOOZvih4qmSvi45lwkd9C2yJv+DSvxTfn/d8HU8TxcEfty9jWkSnvufDjoXX8FO
         ntymY0xKShWatcedFmSz14Wof3Hhg8snFW4vgJfTK0nHt/qfWppRb8xwnCHsrKxyC/z2
         PzxnDGR9uLfKbBvIMe5a1/T9qowWxXZtIkeescDZpKpCFhz6+GGWDupAiIzLXbCI7dBF
         FcEBTvrB3BhdfclX4b0Em1Z7gBZBtqcrbOWMjZXhVz0E8F9ZKYdSiSQ/g9mHRAcxcwGH
         N7nQ==
X-Gm-Message-State: AOAM530vKpaclwaqE7/7PT+V7Sz1eIm1ljNqlP9nrG2X2f7ZDtzpKCYS
        awHxahrY9SubpwuYHUlwabzy1kUuHuPWa/1TkzWnNQ==
X-Google-Smtp-Source: ABdhPJwGIMcmoy8YE6aqOrBHI2doApncoaTodpkHbT6rbeciJiDrZVLFnoKTczgXd5Z8wUFvEGWYwg==
X-Received: by 2002:a65:6d8f:0:b0:380:8b0c:a5b0 with SMTP id bc15-20020a656d8f000000b003808b0ca5b0mr20249219pgb.558.1647905312403;
        Mon, 21 Mar 2022 16:28:32 -0700 (PDT)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [71.19.144.195])
        by smtp.gmail.com with ESMTPSA id c4-20020a056a00248400b004faad8c81bcsm3094531pfv.127.2022.03.21.16.28.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Mar 2022 16:28:31 -0700 (PDT)
Message-ID: <62390a1f.1c69fb81.9e54b.855a@mx.google.com>
Date:   Mon, 21 Mar 2022 16:28:31 -0700 (PDT)
X-Google-Original-Date: Mon, 21 Mar 2022 23:28:25 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220321133221.290173884@linuxfoundation.org>
Subject: RE: [PATCH 5.16 00/37] 5.16.17-rc1 review
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

On Mon, 21 Mar 2022 14:52:42 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.16.17 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 23 Mar 2022 13:32:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.16.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.16.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.16.17-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

