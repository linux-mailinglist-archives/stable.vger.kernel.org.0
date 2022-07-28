Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415CB58487B
	for <lists+stable@lfdr.de>; Fri, 29 Jul 2022 00:59:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233234AbiG1W7Z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 Jul 2022 18:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbiG1W7Z (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 28 Jul 2022 18:59:25 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 591135071E;
        Thu, 28 Jul 2022 15:59:24 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id j70so4029936oih.10;
        Thu, 28 Jul 2022 15:59:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=w8p5rLVmoOYMSTT1ZJ/Mdzlqr6J4pbFIfB9dPAMFauE=;
        b=A4LE96Kq6mkz+ZOEYBTwGwjqVy0+CF/Ya+N2juhxJQK4SaZNwXFyFbIZx3R1eSADrb
         sJVQGFTd5s/4sJx6Z+pV/3p96SlOQq1r/TRcpSzCqLQj1vnLO1ihI5Ii2RbW0ZCA5YRi
         bh/RK/Yrg2/TnYaS48YskB2IlFfLWIpXJd6NBH2i9u73a4g+a+aYkUiwGoZI9C2m0Vz8
         +ao+mxXsrmTWq50SOBg91+ArrUTN10xwV3nFQJLblM4QMAWkByAzAG5T2MOs/fqXC1Bd
         aTC0gX6Tcg4j8IyJtbB2p1cM2CcXiaSbsKjIm8HmLABvcx9kCeLpSg86SjmhWmLXHx2i
         bF1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=w8p5rLVmoOYMSTT1ZJ/Mdzlqr6J4pbFIfB9dPAMFauE=;
        b=yMYhVSdsTv1CWdH6/JLCfDSfC4S4p0gAxQxDR4jBBUOCWeTgxQA3/cGvdDBnSGLHu5
         MNTiRfwa7qP2jOPx9pLLwpSnFrptinlTkFNEAYPIwkR1kKJp0wo6XS7CeFWe3HYckpwU
         bSdZ0mbfBJYzV4qRHsyOEWhjCJJ6T9TVEFIL6LmMfv25BCpyNpwxA3AjWk8rjUzLx9+6
         qzgn6X3459UcPxwVEyHRlZnexxTP6a9kyEWq4nBG3y5AIGIWvVFFd8OtVbDLIEy5cV2r
         OfGzDBLbXe6xe0ek2PRQ4YgfUafcsGIVeEZf7uwIHwCAGkrjRej+j8MEcFWTG3oQWB5K
         R92A==
X-Gm-Message-State: AJIora+po4dOzDyLDM9r/XitjfvrUOD8DolXECH8KmqGbyptgbBT9F7J
        2FMLvdX7yDQkErkyUMBAGhw=
X-Google-Smtp-Source: AGRyM1vUWYlzVipIZn/1QIesh6cio5MKdQ/VVcK9GoOoR37ZGLlF+zqR6PvonXjwiVQmlNhsFomQWg==
X-Received: by 2002:a05:6808:912:b0:33a:8c4e:404 with SMTP id w18-20020a056808091200b0033a8c4e0404mr744786oih.91.1659049163741;
        Thu, 28 Jul 2022 15:59:23 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k95-20020a9d19e8000000b0061c9159bb8asm828568otk.61.2022.07.28.15.59.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Jul 2022 15:59:23 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Thu, 28 Jul 2022 15:59:22 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/202] 5.15.58-rc2 review
Message-ID: <20220728225922.GF1979085@roeck-us.net>
References: <20220728133327.660846209@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220728133327.660846209@linuxfoundation.org>
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

On Thu, Jul 28, 2022 at 03:33:50PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.58 release.
> There are 202 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 30 Jul 2022 13:32:45 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 488 pass: 488 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
