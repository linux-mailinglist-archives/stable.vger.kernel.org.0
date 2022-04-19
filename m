Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 677FE506092
	for <lists+stable@lfdr.de>; Tue, 19 Apr 2022 02:06:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238396AbiDSAI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Apr 2022 20:08:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239537AbiDSAHs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 18 Apr 2022 20:07:48 -0400
Received: from mail-oa1-x32.google.com (mail-oa1-x32.google.com [IPv6:2001:4860:4864:20::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A30B6591;
        Mon, 18 Apr 2022 17:05:03 -0700 (PDT)
Received: by mail-oa1-x32.google.com with SMTP id 586e51a60fabf-e5c42b6e31so5892949fac.12;
        Mon, 18 Apr 2022 17:05:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=0orZeYknOY12OejbDomskHSucpnNCNkiN75Kkq16RxA=;
        b=lge2Pii527u6RTuBxNx/bkgQyRSQM8xFLTTyHQ+BQ5eXd1NXQBTfuP2JPMQpl1JcCf
         izZ+LBZjsqGDXI33BvRUUsFahonr7sEV4TGSuY8uhJRZIMknhu2Rt/PlHtq2cRvaCnNA
         9X96YMg7infYcM5iUdmdi9OGl5zncKvYAu1gnjM7xI2jmQw4ktNEHt99Y16jOFYrLfMZ
         nAvwesNqsIdL+Y4h1wiobxrrhSwQ6zsBocVBBIjp8pEY5JrRTuNujzvvvPZcJ9SNUlJD
         Mkkux0H8N/dpHZ6yK0rPS3t3Xy2jZHNOj/tdoidUQ9MLgofCKv1wE+FAt1M9fAPvSEb9
         5Byg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=0orZeYknOY12OejbDomskHSucpnNCNkiN75Kkq16RxA=;
        b=HU62AGI+neCMCRELLpapSHnuKsP6rFcV9Th8WB1Zz3JFYIoEEJwHGzX/sodwUMKBpy
         ribPhH+Vn7Zj5yfRxgA3BXTgJzOMsJkWf9tchGUh6NqPxY5ZeH6mUPxpoaeExffE7+1J
         /bMoPgG4YuBSW6ef7ljnMr/I9gQLu7boctQKnoqr2GRAaEtm7VB33BJ5bOuv18SDKHkc
         ZiSopwmjoPIKtTdD+AL+I7DMB56VyvQYiB7BX1pnHaxJrZpJI92llQH+sMaDvmmhmbNR
         9So+cll6RGLKA/I0bpaV6FIv2bDXxb0gF7zsNTiDoRzAcH4mTgxX2/lCLNX3iib+vUNs
         wcPA==
X-Gm-Message-State: AOAM5319ubdtL7UTLGkw15Sn4fVaFiDfjNpZ2zJYd44tDInn/08Yg2qL
        ab5QT9bPJxAS911gUdJf5kQ=
X-Google-Smtp-Source: ABdhPJyXVyKn/7wMMLs0QScHZc7wG2kdgSVci2CYGQ6JBsUVc+/pslIZwi0hIM7+I5gPxfJqHkc9oQ==
X-Received: by 2002:a05:6871:5cb:b0:e5:db16:5297 with SMTP id v11-20020a05687105cb00b000e5db165297mr3507735oan.66.1650326703278;
        Mon, 18 Apr 2022 17:05:03 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i7-20020a9d68c7000000b006054aec0025sm2086530oto.69.2022.04.18.17.05.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Apr 2022 17:05:02 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Mon, 18 Apr 2022 17:05:01 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/32] 4.19.239-rc1 review
Message-ID: <20220419000501.GC1369577@roeck-us.net>
References: <20220418121127.127656835@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220418121127.127656835@linuxfoundation.org>
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

On Mon, Apr 18, 2022 at 02:13:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.239 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 20 Apr 2022 12:11:14 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 156 pass: 156 fail: 0
Qemu test results:
	total: 425 pass: 425 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
