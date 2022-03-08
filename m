Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 365F54D1C3D
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 16:46:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347970AbiCHPrj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 10:47:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347968AbiCHPrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 10:47:39 -0500
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 451024EF79;
        Tue,  8 Mar 2022 07:46:42 -0800 (PST)
Received: by mail-wm1-x32f.google.com with SMTP id bi14-20020a05600c3d8e00b00386f2897400so1634834wmb.5;
        Tue, 08 Mar 2022 07:46:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=wALI3BNBHP4wAWHHorx9ErKsuNnx499LEALEzU6+p48=;
        b=YevuNuxVwow8w4+JHLBABY8IUBVMW5yO46x0YwbwfSqLKVAX4g0SJ1Ow0Dy4S6fL1V
         YG98OS4Iwd/wejszV/mq8x9UeBRR6VJyW4OVoce8iFkQEgB0RT1B8gBc3qwfICDK4JWh
         GbKhTX8xeu5+W6PquPGxZXC//IFU32oGlfuQcNQLfNI7QKnmxuvGHFaj2gXbE7U7UQIe
         EtKNSAetDeqtwmxAWz8MYX+urFoWs1PJHHdtikyBiulmmDsf+42cetDIJ9LGpEJQkJ9R
         YVMbs12bJfaVcW1Ltic06maPfusAkOAGINFL8SAbLMgC/3YryobzqE1laKrPdQ/dQfwI
         dhoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=wALI3BNBHP4wAWHHorx9ErKsuNnx499LEALEzU6+p48=;
        b=bG9Pduk6oWe6Y6+XwQ6xtvRIX/0VuP6pSQDwVMXXC8ZW25RydpPPD2uI+iTtICZDoY
         JfKng5EcrkMt62vIBEp9jXGfZ0juggg/vtA8zKHFIhvMayNjGjJEEhYbPhel87bE/3qT
         gCnmuwhA2Rh0jjy9g7pm1GfGqUzT4lkgP2H2odpqXJsPQqONhUkgEAkzjFUZW5DJm2SW
         kYRZpHmweFRNfgYS3pSS9Tg7EP9q2vTsGWcQSTw7DuNr9igturSJJ1CDYxml0YsIFrys
         ifJtPL3HgR57CB2P3AT0+oKCDlBSmnWgpjyuTyfWZZ2FA/THNsQ5c1qEA5EeGRlkSjoW
         cEww==
X-Gm-Message-State: AOAM530Hgf+aSniJnRJNAWf9fURrG6p7NuY41JESBpMJAVAJ70wDHcoQ
        5U4UOjWcNm+htEwPTwRvKKg=
X-Google-Smtp-Source: ABdhPJyrVfLFkmVtvwkvMB3YJ+1GYQsniduCTsCGvvuoqIFakr/EPNe4PyBK3MrDHUZ2x4PuSRN3SQ==
X-Received: by 2002:a05:600c:4f87:b0:389:9ef5:dd36 with SMTP id n7-20020a05600c4f8700b003899ef5dd36mr4158221wmq.82.1646754400909;
        Tue, 08 Mar 2022 07:46:40 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id n20-20020a05600c501400b0038995ede299sm2487470wmr.17.2022.03.08.07.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Mar 2022 07:46:40 -0800 (PST)
Date:   Tue, 8 Mar 2022 15:46:38 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/64] 5.4.183-rc1 review
Message-ID: <Yid6XoPcvvjp+l2X@debian>
References: <20220307091639.136830784@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
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

On Mon, Mar 07, 2022 at 10:18:33AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.183 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220301): 65 configs -> no failure
arm (gcc version 11.2.1 20220301): 107 configs -> no new failure
arm64 (gcc version 11.2.1 20220301): 2 configs -> no failure
x86_64 (gcc version 11.2.1 20220301): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/853


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

