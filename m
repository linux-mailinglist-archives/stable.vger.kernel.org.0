Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53D3D5E5C16
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 09:15:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230214AbiIVHPX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 03:15:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbiIVHOv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 03:14:51 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01F272F3;
        Thu, 22 Sep 2022 00:14:35 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id v4so8251527pgi.10;
        Thu, 22 Sep 2022 00:14:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=qwhBFHkrFRI0WL04887MY0VeyA92ERb/4wYotDwfmBM=;
        b=NNhVJia7tlvKFUrqhM3RWviBK6nFJYkH1DQfUtvX/7vtQX2S8GGlKNLVSSKLNrrbl7
         b4HEFpuery6qrqZ+K3P95/1AgnKV7TsoNqfG99F0VFdBQiHsBdtOs1BVOjQhslOPKlQz
         fIy1bb2Bt3Bi/LnQGr/xkwMZZK9I+eX2uCdU9yIVmATMRRevbsV0qVlWj1jPV4z/LWSv
         xcXVmMNsK8IUGeuH8ohxy9QvhKjCtEtIdxqIGi+zEQ23QTQSM22o9vWOKtY1shm/DAVd
         4NImNOhbmFjvp2huWnnut5sye9J6P0kYdtxw5KtO/TobIZX9nnlNF54GTfWLyWbF3kK3
         3Gsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=qwhBFHkrFRI0WL04887MY0VeyA92ERb/4wYotDwfmBM=;
        b=HLahgflfMcE/8BHSvtGUAXsGlQlMMa60BN3UNwrKkzqRHLjkQFCnArmnZE4Em2G1zE
         wFyUSCu2UHnSfu2sfrNv8tzv6nST9iu5GlInGq/IbUBmihtKxFkuFAwt4Kx6FXLPpOl7
         ZSv/HhHQSPPJhmS6QdBWCwGeaJd1XFr+sDbkAxmikEeLjPgc1DiipEw1KOZ5ZYFeGe5u
         2nwNkn73m0c5NqY229WNgCvf6eln2091xCISf31i+GQ4z4EaEHCIwoC2fYz0VUmCYM6R
         ZP5Ci6vl5ccFotdGcWR3MYP9ExmkMCduNOZutGnRUm2c9vo3QSaE3SYMhUSApAznANGt
         gKLw==
X-Gm-Message-State: ACrzQf0YCr79sntBccI19n2aRA47J3pR6+dvr8idL+9vbgMkDH8Y/FCR
        oumTbNeEaXs7dBJZTDIpsAU=
X-Google-Smtp-Source: AMsMyM5+tonk6+Bj0IEsMjXpLHRQtzzua4ppeoKomf8hNy4oCZbZ+FlgygGqDA9jKdea+2GuF3x5Ww==
X-Received: by 2002:a05:6a00:2290:b0:541:f19:5197 with SMTP id f16-20020a056a00229000b005410f195197mr2044161pfe.42.1663830874472;
        Thu, 22 Sep 2022 00:14:34 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-90.three.co.id. [180.214.233.90])
        by smtp.gmail.com with ESMTPSA id d20-20020a056a00199400b00537eb00850asm3529248pfl.130.2022.09.22.00.14.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Sep 2022 00:14:33 -0700 (PDT)
Message-ID: <acaf048d-4b7d-a72b-baaf-6f6dbf62b861@gmail.com>
Date:   Thu, 22 Sep 2022 14:14:25 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 5.19 00/38] 5.19.11-rc1 review
Content-Language: en-US
From:   Bagas Sanjaya <bagasdotme@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
References: <20220921153646.298361220@linuxfoundation.org>
 <YywKrx5hyO8pEZNR@debian.me>
In-Reply-To: <YywKrx5hyO8pEZNR@debian.me>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/22/22 14:11, Bagas Sanjaya wrote:
> Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0) and
> powerpc (ps3_defconfig, GCC 12.1.0).
> 
> Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>
> 

Oops, wrong message replied, ignore my Tested-by tag.

-- 
An old man doll... just what I always wanted! - Clara
