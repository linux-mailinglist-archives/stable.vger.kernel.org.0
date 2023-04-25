Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 404666ED98B
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 03:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232274AbjDYBGa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 21:06:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53170 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232202AbjDYBG3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 21:06:29 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFBCCB47B;
        Mon, 24 Apr 2023 18:06:02 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d2e1a72fcca58-63b5fca48bcso4405191b3a.0;
        Mon, 24 Apr 2023 18:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682384761; x=1684976761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wrCAPeEXhKwKO/yYGy9jgCOEwKGr1fHsPVPzH+QsoQs=;
        b=GyA/wx0uI0tiaynf3OhQ9Bfcrhi555ap0/1eadvAg6PAxN7rSB/5FsbhFRxESCfEWZ
         xgsnpumQIXUuSgY/pFscRfLho9rnV8EDGKhuNt025uImLKJ4jeGo7qlhzjLXOr5xrm3S
         Iu6L3nBi3VTTL3PTgq3JDAttiq8N3tpFI5bT4Da71MpZoR9kRuC/JmmuKk8YD6p2ZhYB
         5jspUrTRCIv4RHvSKys0pZzQnlm2SmyMZZrd9Hs5FIpzBMIUWyN2SykGTu1srBvKUGFP
         n5tpATi0P83IFi/V41mh/MhFQ9Cz07I1L9jKqvMpC5729VXXB5irQA+RasEiJjpy8OQq
         xi7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682384761; x=1684976761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wrCAPeEXhKwKO/yYGy9jgCOEwKGr1fHsPVPzH+QsoQs=;
        b=MtQCg627S/soPwOs03Nkcm8OnTgaqw+hM04chqW4XzaAqkvtU3qfE3eoj1XJ1hB8J5
         5JMC2I1+EGUoh6deV7XWXpXNQRA+Gu+zDbeYi4H6NySzGzDclDSvSd47APOU3x6+5Bqz
         M6aTaCZvonYyEvlGOIrRBB6Ugf/z7pOXOdMrTR1UKBBHCHzOZdoaGJgARNJ4OYNvR6b/
         mc/h/S0CyVFmzM/QLEcNadlX54taJOV2zI1EWCpquro1EBrBXLs5XN45YOL9dmIzs37k
         V9qW88j4XQ5W+E3Fie925yacHX2czkK4ZMfT8eShULDu5d5Ii70eMkwFiFW4aKLvaidh
         Dc1Q==
X-Gm-Message-State: AAQBX9eO5TMfdMzLoqT62+tPINAo+eCQioVOyQUQh5RnqiEvfdDBOFUm
        JYLoJLimguxRmhs7vqHZB/g=
X-Google-Smtp-Source: AKy350ZKKEzwv82QiHFoPFRuqCyiUrmaGrxijZ7bf1D8FVpCDIvl8ezphoghTsA9cC+A9h6vNpqutw==
X-Received: by 2002:a05:6a00:a06:b0:63b:5c82:e209 with SMTP id p6-20020a056a000a0600b0063b5c82e209mr25149281pfh.10.1682384760840;
        Mon, 24 Apr 2023 18:06:00 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w66-20020a628245000000b0063f16daf7dbsm6423564pfd.55.2023.04.24.18.06.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 18:06:00 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 24 Apr 2023 18:05:59 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 00/98] 6.1.26-rc1 review
Message-ID: <6756ff45-c2f9-4689-8d31-87fa8337eb47@roeck-us.net>
References: <20230424131133.829259077@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Apr 24, 2023 at 03:16:23PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.26 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 519 pass: 519 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
