Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0135A031B
	for <lists+stable@lfdr.de>; Wed, 24 Aug 2022 22:59:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240607AbiHXU6a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 16:58:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230515AbiHXU60 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 16:58:26 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BD6C59267;
        Wed, 24 Aug 2022 13:58:25 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id n7so22214265wrv.4;
        Wed, 24 Aug 2022 13:58:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=X7I7hpdq208v0aA69t/wl3+UqRJqIxKDaZdMc0tHUnQ=;
        b=COxilQZye2gOgfd8S8Fohu0TW1/z1cBTjONF9rWGp281xB/6x0SMIoDqM41E9WyvK5
         Qir4uuvT7IDjd3q5rVwKYjjHfnHlyBE9LnCY+3oaoMx5COUi422gq30Vl7vQ6+4jcJ7Z
         sh6Xl59hqJy+I0dZ4fcta7s7tkj9F84FNPLvCbMRaasUi9jR+78YVkrT9I49A11ugOLw
         b/1QVOgLnlpNGM1C3UySqXs7ohRxgzGfpjw/NAoGBgYW67L08FI99t80kQfHSFH7AdH+
         d1/OjmcrCNgCz7HK/0kW4DjZbR3Xvisbu7Jq34N+U/ZlYnzoYcwb3/Cs7dVJn8XyWv2J
         IiSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=X7I7hpdq208v0aA69t/wl3+UqRJqIxKDaZdMc0tHUnQ=;
        b=nCYhMN7u386bmvNyifKSMtelqSoaMX9pzjK+E126sHACcAupcB1LlXo2Shs1uQfrEq
         zOQI0LxwFmOFdAkJE0lHfK63CGwN68E8VRQpfjSdSsR88IoOAwzLgY++Z0XtEkR0yCzR
         VQLWSl/2i8d3yXOamjCTvpdEMU9VIOXj620G+kuhvDuJR9HRMKoW+D4MC/kz4aP+6975
         Q4BtZyDEQmeTR0rk0bxiaDaVKpvQ6YlGnpywzYzjkmg4bD4Uuj93+c9PbM6xLfwWE10q
         mrZsiWbUWYoogCgskUtytUxm/fnVLb28fvcxOqRc1djB7B/IU7BGZ6fSgTnwmyAsQOiW
         LoXQ==
X-Gm-Message-State: ACgBeo1GutByivMSGNrsKLtbXGF0+CsSQ0sDx23CS+BHGuAzIS6cErxq
        xyyWZ3aRbgnaOBzBG1JBzdU=
X-Google-Smtp-Source: AA6agR79liQdaKq7iCrV5v4MSvnfiU0PVZF64neGFPwl3QVSoYr7fv+BvxNXQZMBBb1ypEViCMnEgw==
X-Received: by 2002:adf:ea09:0:b0:225:559a:b662 with SMTP id q9-20020adfea09000000b00225559ab662mr494175wrm.396.1661374703759;
        Wed, 24 Aug 2022 13:58:23 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id h2-20020a05600c414200b003a511e92abcsm2811100wmm.34.2022.08.24.13.58.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 24 Aug 2022 13:58:23 -0700 (PDT)
Date:   Wed, 24 Aug 2022 21:58:21 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.10 000/157] 5.10.138-rc3 review
Message-ID: <YwaQ7TYreTa03btO@debian>
References: <20220824065856.174558929@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220824065856.174558929@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Wed, Aug 24, 2022 at 09:00:52AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.138 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 26 Aug 2022 06:58:27 +0000.
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

[1]. https://openqa.qa.codethink.co.uk/tests/1694
[2]. https://openqa.qa.codethink.co.uk/tests/1698


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
