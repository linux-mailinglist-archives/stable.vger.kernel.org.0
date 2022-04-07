Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28AB94F784C
	for <lists+stable@lfdr.de>; Thu,  7 Apr 2022 09:56:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237940AbiDGH5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 7 Apr 2022 03:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232102AbiDGH5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 7 Apr 2022 03:57:23 -0400
Received: from mail-pj1-x1032.google.com (mail-pj1-x1032.google.com [IPv6:2607:f8b0:4864:20::1032])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 600F211408F;
        Thu,  7 Apr 2022 00:55:23 -0700 (PDT)
Received: by mail-pj1-x1032.google.com with SMTP id h23-20020a17090a051700b001c9c1dd3acbso5444671pjh.3;
        Thu, 07 Apr 2022 00:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=hXFL6dt8fzomsRfTKg2cZXYSU0EaDUXh0qhqf00N78s=;
        b=cB/9zbGxVzgJtrojzRPPWewU3eQT7WraZRZMYHPPVF3YkemFCXxs5BavHD8YHmgCAu
         LKe2uxkoHiDtzmEKYrwowY1P3wcaVF+QckKuuBBYRrbBrk3NFagCZwH4huLYgMp1eU8g
         YX1ox4lWaPX5h84FvyWyRodBnBaxdzdKEHsCklwEcRFBRokQaXtgW3hnuPgOMiMfg5+U
         idTaNmvVvVHnoODKvwGwZJSW/T/JlCgxoUTNhzo/bSWaHx3rehbuhoyvt7JbIYST0wdH
         Y54ZWhnM8AVIcojJkOpW2iwcBezpBLNw8v1V3AAKEZd2YUdYNzoPO8pgqo7LceJUFoIz
         DRVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=hXFL6dt8fzomsRfTKg2cZXYSU0EaDUXh0qhqf00N78s=;
        b=yZbLB7tK0sknNNx1MwPNhvXFIx9aQVJkpCgt7aaF29FoPD35uqJ9Fkz0xOb89p/3H3
         u7wHpukkL/070g3vuDprVy+IxDxdx64rTePi9ivyYTe09SMwEX6jJCy5TzgteD3BJDV2
         OxvWk7wSdW3eKw/zYYXweNJPzmP1kgjSqhtMRIRG4a92NjsFLwRoPQK30uvOq6a5TUv/
         +WXom6GpFT9xLprp/kkWZQkC+eDEFp77aItwtdGgsIlpcXgJxDOW4xTFQoVXzbJhSXxE
         IXxTyLMwO0FP+wgTJlhApWyHWba3HWi3963KqF4Q3rapr9bHpDGXjqeJzHRe28sVS6pA
         bp/w==
X-Gm-Message-State: AOAM530lMdtnN9vv+nZceFnvF9eOPt2R3hHGotVGAiDN+y4Iiq1dORaZ
        jJkON/0+F3LsJQRYcZ9pJDk=
X-Google-Smtp-Source: ABdhPJw34TPpqd8Fk7OJJK8jvwwIKFltZPgezXY8lsOChy5En/uMzCJ8DdIp/oXuGletRxOJvN6Nhg==
X-Received: by 2002:a17:902:ce85:b0:156:bf3d:55e8 with SMTP id f5-20020a170902ce8500b00156bf3d55e8mr12860314plg.22.1649318122885;
        Thu, 07 Apr 2022 00:55:22 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-88.three.co.id. [180.214.233.88])
        by smtp.gmail.com with ESMTPSA id 83-20020a621556000000b004fe5d8c5cf3sm3584147pfv.156.2022.04.07.00.55.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Apr 2022 00:55:22 -0700 (PDT)
Message-ID: <67ad4f44-1968-333e-cca3-b496ed251f66@gmail.com>
Date:   Thu, 7 Apr 2022 14:55:16 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.10 000/597] 5.10.110-rc2 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220406133013.264188813@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220406133013.264188813@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 06/04/22 20.43, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.110 release.
> There are 597 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
