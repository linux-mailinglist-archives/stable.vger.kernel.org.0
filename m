Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24260645C7F
	for <lists+stable@lfdr.de>; Wed,  7 Dec 2022 15:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229886AbiLGO1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 7 Dec 2022 09:27:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiLGO0g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 7 Dec 2022 09:26:36 -0500
Received: from mail-oa1-x33.google.com (mail-oa1-x33.google.com [IPv6:2001:4860:4864:20::33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A5E5E9DF;
        Wed,  7 Dec 2022 06:26:18 -0800 (PST)
Received: by mail-oa1-x33.google.com with SMTP id 586e51a60fabf-1443a16b71cso17957886fac.13;
        Wed, 07 Dec 2022 06:26:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ovp7RN5SJxtC9JYyhzfJ5fXBmFrl0V1pv9Cshdr2tKo=;
        b=X1hMrMShFbyKPASWyO2nsxVvM/4/yGxaobGzSRQzeijHIzLzaMcBPewA8jyEKrnbHX
         yRefLWVmModh8H10gfRhygNwI1/Te/91zVm+uZJGbLTtBN3aFBfVTgw3Inm+gAiMvUjA
         jquqyc9GzythWR0QpJwcnNhE86IU3ghX6nVYz5IXueF7Sq+EusnbRlckGqIi5oUv1V6V
         /tA39D6Yl9bRbTBFdc/fRKL3gG5kY024oVhFUKf6ldl+c3J9yA8k/JF7i1zPQ6nE0u0n
         QXoBMikiNqKZmPSL9eYkPQVGp37MgA8pIVWdLVE4H97+ZZ4rzVvRDKInZHxl4yckAqtM
         0wLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ovp7RN5SJxtC9JYyhzfJ5fXBmFrl0V1pv9Cshdr2tKo=;
        b=K50zYc4oWFyfmw9uPILMScOwZWsZsIxFV4A8aMZz8oXnuMKFPV1PUhs3cRBuDHGtxh
         HuJXsBScIPsxpGLVqzI71kVYszSLDbK+TuUJYLLGYnjp81FCLuPxaVljU7+fdW4AqWLi
         kBjw9CEjFjEBuNNqocdLOSyBtyCDaJx0Q2KJ7M1EA2cGZ1mjdI7QUqdgTHpzWvHSC/Pk
         Smww9YUfHes39g6XffwPwfBMwuZjLm2Un7PbBhgjgUTdrD/duZ80wrl4rdiIa+e604ks
         pstdvaT4dIl+2NS8SddYtRBDohpJp5YRVn0hdYJ79EMH23BfaSY+4dbDwlGAkqDqZ6Is
         RzIQ==
X-Gm-Message-State: ANoB5plrKJoa54WcNEDz8yJGrqcnrYve3eC0UpSvOOnm34T6YTo/ahtl
        OmCBp1dCGRaASuq2WOtSLMHuQ2hd4tM=
X-Google-Smtp-Source: AA0mqf5MfrSnhU8Me+2xR0btOmSBuCr+p7EbXonY79Kaqx6iEurxY/odxuSdvQvLUWloBhr5eJVwuA==
X-Received: by 2002:a05:6870:d985:b0:13b:6d76:8bcb with SMTP id gn5-20020a056870d98500b0013b6d768bcbmr43910294oab.281.1670423177845;
        Wed, 07 Dec 2022 06:26:17 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id q5-20020acac005000000b00339befdfad0sm9463395oif.50.2022.12.07.06.26.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 06:26:17 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Wed, 7 Dec 2022 06:26:16 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/157] 5.4.226-rc2 review
Message-ID: <20221207142616.GD319836@roeck-us.net>
References: <20221206124054.310184563@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221206124054.310184563@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 06, 2022 at 01:42:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.226 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 447 pass: 447 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
