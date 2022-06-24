Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 413F055A4DE
	for <lists+stable@lfdr.de>; Sat, 25 Jun 2022 01:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230366AbiFXXdj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 19:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230129AbiFXXdi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 19:33:38 -0400
Received: from mail-pj1-x1034.google.com (mail-pj1-x1034.google.com [IPv6:2607:f8b0:4864:20::1034])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40BFC848A0;
        Fri, 24 Jun 2022 16:33:38 -0700 (PDT)
Received: by mail-pj1-x1034.google.com with SMTP id a11-20020a17090acb8b00b001eca0041455so6281751pju.1;
        Fri, 24 Jun 2022 16:33:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=G1rnhz45TzHhj6EnNM0PnkkCtT3J08/VDHmUDAR/esE=;
        b=PNZV6NxUE/pDSiSgh8XaexOv7ebDaiXAdUEHO/wu+oHevzCNze0ZInr1mrRbs2nuuz
         Y/B5g/ohNIWC1EBBXtmB8GrZZd/tNFME7U5jRXdOZDQSXLWQSCFn684G7+pONbRDM4fa
         2/9SEi1GDTaKyaIieeOw0PPlEq882PhktAl/3Yoee3/r650wsh/kPADbCuCV1/9LLcCJ
         bjK0cDh+bFivyO8h8KU+mJ5SbUgg8rdcSzM63PzfRFWepB/1i/NEKTIl0iEGkX0svXe5
         urb/aBhS+E2yx97F5DcmCEX0DxDMvRdChVGOc7SMIUC2JjtFN5wPwl0UWd+eihQW8T0H
         37Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=G1rnhz45TzHhj6EnNM0PnkkCtT3J08/VDHmUDAR/esE=;
        b=JlNKFQMsevNvVY4chgzakfbrahHXH9bqLw6ILD7ZzHL29purS+KHP2OBxHNEGBSIym
         scTOP0dKTfgeQKuospUbOSRBVYdIkShUAOaWfk0sDYvS+Dx/21d2/9XevBCl9Cl/KiGp
         V1jKEDJ+uEJnFf1T0mORV5GU9vLVpmbiLKhzk+ukxYiktG0MgqlFf6XxvgGJIIOnSDo5
         L24ALw7Tpyk9VtIaWobwF7AZr+2udX/VAisE5C0xKC5QRgrlrRQTYhNa2q75szwDmZPo
         I3OQlektLW3bj28pPJ+N3Q7vqY4B5M02tNy3J9nloTiImeuqfCl4zlXJKQtvF6gTwEFv
         y5tA==
X-Gm-Message-State: AJIora9w6ll9Uoofr5QRqdq3quni+JGT/dFfTixD2hDNGzy8xA40MjJT
        YW8AKk0YCQLj3lYwuGf7euffx5W/4No=
X-Google-Smtp-Source: AGRyM1vWe3/8JZ2O4sR0vzmo8sK7cSl0f6vwDdIePE0TccDzoBtrJfUIgZ4412dczpLJpbFjvtI1vA==
X-Received: by 2002:a17:902:f78c:b0:169:b76f:2685 with SMTP id q12-20020a170902f78c00b00169b76f2685mr1556951pln.41.1656113617741;
        Fri, 24 Jun 2022 16:33:37 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id i3-20020a170902cf0300b0016a0ac06424sm2366866plg.51.2022.06.24.16.33.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jun 2022 16:33:36 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Fri, 24 Jun 2022 16:33:35 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 000/264] 4.9.320-rc1 review
Message-ID: <20220624233335.GA3341529@roeck-us.net>
References: <20220623164344.053938039@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623164344.053938039@linuxfoundation.org>
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

On Thu, Jun 23, 2022 at 06:39:53PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.9.320 release.
> There are 264 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Jun 2022 16:43:11 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 164 pass: 164 fail: 0
Qemu test results:
	total: 397 pass: 397 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
