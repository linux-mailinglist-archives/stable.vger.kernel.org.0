Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F8384CFE0A
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 13:19:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbiCGMUH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 07:20:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233829AbiCGMUG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 07:20:06 -0500
Received: from mail-il1-x12b.google.com (mail-il1-x12b.google.com [IPv6:2607:f8b0:4864:20::12b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18B5A3E0F5;
        Mon,  7 Mar 2022 04:19:07 -0800 (PST)
Received: by mail-il1-x12b.google.com with SMTP id i1so11375477ila.7;
        Mon, 07 Mar 2022 04:19:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=CxRERgirGnLDrVdYflXCvy2HBelraq/vQz0ZO4WiAz8=;
        b=UPmIGJ2dpVy4r5X84CfHwdUVEvmAtgTM6i4wfwBvVCxzhlKUdZgAPPk9wA1WzZXcVl
         Q+ap1qlB5YGh2j6FFY36aFh6e9BY/KozP7l2ph8xXXa/+tVTq1Pq9hJOt0BSplrGyUKo
         aYTg4j2JSreA63lOkBkDSiSrz2fPBF8IqRE1lmEf79m/mcGdGbf6lRJjicyFZScNPZIs
         G8rdCGrEA4wPQxGNQbqv7RJ7Z7eI05gYoiOispfHVOR3GMTxUtBsATagUcO2uqfVYT7z
         gNTNDgsH3bemctmFpB9+K7x7MWhojKUPdeDoD3ByligupDAgI3Epx1wyJlw9oUKhwTeq
         HEXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:from:in-reply-to:subject:to:cc
         :content-transfer-encoding;
        bh=CxRERgirGnLDrVdYflXCvy2HBelraq/vQz0ZO4WiAz8=;
        b=qEoxHHi6a5wx9lFiYWBFiV1q1g6uXZoQdrUAhgPj7Tg88RTlP4K4Ks57KQ8WqYEuUz
         x1S2NHlsREVAOg5YKglvwMJHqjq9cKVYBTJCg7TOnoYlR7WatNGI2gX8xwxTLHyYFddk
         EZH8GM5cLf3bQsAqwVLga0uKIeqAR7G0NsggtUnESSiSaRVO6soRDA1f5IJU8bu3iVS7
         vXYuYeS333Lv3qYYYETBZLPt3K2Va4DLJ64w6/c65Z0PBuxzddNaKrDGaqgVy0lYG1VY
         pCdTPjt1VQl132m0XsJXWTJKXuEPN5cc+I5yNITHNs6D0RKezI8W85e/LerjP79aGjZB
         RpoQ==
X-Gm-Message-State: AOAM530PT7r9yBkoIUA85AStsGtCqrpj35Z7zvBW96JTJqtSi+6v99v2
        ezPR871xFgtZMsDb0/1KZvqpfmkGPac6FienOVIYKA==
X-Google-Smtp-Source: ABdhPJxJ5bWvUNeIEltERNvPwJqsjjmJpmEEa28rT4FSXHcuhgfzzRwjT3IuhsHzo1cu7PyWNwCn+Q==
X-Received: by 2002:a05:6e02:b25:b0:2c6:2043:5862 with SMTP id e5-20020a056e020b2500b002c620435862mr11601093ilu.217.1646655545841;
        Mon, 07 Mar 2022 04:19:05 -0800 (PST)
Received: from cl-arch-kdev (cl-arch-kdev.xen.prgmr.com. [2605:2700:0:2:a800:ff:fed6:fc0d])
        by smtp.gmail.com with ESMTPSA id f5-20020a5d8785000000b00604cdf69dc8sm9267686ion.13.2022.03.07.04.19.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Mar 2022 04:19:05 -0800 (PST)
Message-ID: <6225f839.1c69fb81.2b2af.0387@mx.google.com>
Date:   Mon, 07 Mar 2022 04:19:05 -0800 (PST)
X-Google-Original-Date: Mon, 07 Mar 2022 12:19:03 GMT
From:   Fox Chen <foxhlchen@gmail.com>
In-Reply-To: <20220307091644.179885033@linuxfoundation.org>
Subject: RE: [PATCH 5.10 000/105] 5.10.104-rc1 review
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

On Mon,  7 Mar 2022 10:18:03 +0100, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> This is the start of the stable review cycle for the 5.10.104 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 09 Mar 2022 09:16:25 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.104-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

5.10.104-rc1 Successfully Compiled and booted on my Raspberry PI 4b (8g) (bcm2711)
                
Tested-by: Fox Chen <foxhlchen@gmail.com>

