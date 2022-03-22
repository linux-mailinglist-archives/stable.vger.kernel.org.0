Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D8D24E393B
	for <lists+stable@lfdr.de>; Tue, 22 Mar 2022 07:54:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237210AbiCVGxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 22 Mar 2022 02:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237206AbiCVGxP (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 22 Mar 2022 02:53:15 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39B0A252B9;
        Mon, 21 Mar 2022 23:51:49 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id e5so2903183pls.4;
        Mon, 21 Mar 2022 23:51:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=bv//rpRl1ECK9RWJHVJsrmIvETsxO2bFKuJlluR2bfI=;
        b=pPkeHSTPuMQRJclGJwjKyUrFv74VOIdMPExU0RcupWHnUrMn2BF916arwgz9TCnSW3
         FyDwRo9wgv7Ma3BCjtKdcUe07pL/eceDqTV0PVmckjHdGUNYU/ZhCKuWtQGJCDyiW2NK
         JxEP3ona/YcLpGTMQL0cbYLxKxz2bpmclqcJBLQuOIyzdYFhBzBT0ek232mUbS5zC0yy
         pnTp4qQfwC9axSoujZJs3Ux6GLRRV5k3w+PkzfhbjBJRSSZOIqUZ1WtjQez2ANlTJMfZ
         tYvDJYP75jHseNeJcwl7zeUb/kEmmp5eStdf2f9FD+nUKKrKvlVTqWDSh5RvX2bIWNRH
         EDJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=bv//rpRl1ECK9RWJHVJsrmIvETsxO2bFKuJlluR2bfI=;
        b=jXZ1dtP4I8yQeFXPUQFMyeZs5TPHm0VF8UvhQ94Ov9rxUhvUx4y5BRDcFVN1jLZzYQ
         z8PqFjksPCI6b21+/vjTs5PuNpypQRN4QwrU1DEfFYcNo254+qDnYuJfusvIOz/xRikw
         vulyaEX6GZjkaf2NMapeu2JkNhvQN7xHWyb0211y4hqGgyG6vfb435Yw99Re5ekWoIe+
         Tl/eRlXIMpvNrAuGTlMp5Xq9S4zDCaA80JVQEVeFco7suod7G43GvhsS4oONTjzqlRr0
         LrcMObjihFv28bJjw5aFyGzUzM3vllm9RWfX0JM47xYhUnqV2FMlueyOie397okVuat7
         2/wg==
X-Gm-Message-State: AOAM530hanXr0/nz5aPg8W7TrJKklPWWyRH8QzTW10CzMXv/mk57w145
        GKFhfVc/yd8BWKs5uKwtDAc=
X-Google-Smtp-Source: ABdhPJzHIrxAGrOTHdcr2IOfIEJKAiut5hB9m6Q5MPNWmXLC3pWdBmMpXv+HcJZ/RGldHchcxLcuSg==
X-Received: by 2002:a17:902:e552:b0:152:ff07:ea7a with SMTP id n18-20020a170902e55200b00152ff07ea7amr16638713plf.82.1647931908674;
        Mon, 21 Mar 2022 23:51:48 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-49.three.co.id. [116.206.28.49])
        by smtp.gmail.com with ESMTPSA id oo16-20020a17090b1c9000b001b89e05e2b2sm1611391pjb.34.2022.03.21.23.51.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 23:51:48 -0700 (PDT)
Message-ID: <21ba5367-ea33-a174-d985-0a8bcde0b491@gmail.com>
Date:   Tue, 22 Mar 2022 13:51:43 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 5.10 00/30] 5.10.108-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, slade@sladewatkins.com
References: <20220321133219.643490199@linuxfoundation.org>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220321133219.643490199@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 21/03/22 20.52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.108 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 

Successfully cross-compiled for arm64 (bcm2711_defconfig, gcc 10.2.0) and
powerpc (ps3_defconfig, gcc 11.2.0).

Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

-- 
An old man doll... just what I always wanted! - Clara
