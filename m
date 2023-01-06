Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99A3765F7FB
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 01:05:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235799AbjAFAFg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Jan 2023 19:05:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235622AbjAFAFG (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Jan 2023 19:05:06 -0500
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 721CB3C0D2
        for <stable@vger.kernel.org>; Thu,  5 Jan 2023 16:05:05 -0800 (PST)
Received: by mail-pf1-x430.google.com with SMTP id x26so20311478pfq.10
        for <stable@vger.kernel.org>; Thu, 05 Jan 2023 16:05:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=i2xgnS6P8oE/KrpMlccAZ+Y4dEgvLfcHqD32J1lx09Y=;
        b=dnJOdhDpc89F27/WUX9nX/el+s3gnF3ZFn+gfhDkX1Ru/RHLLlQw/kAE0Deju/pbny
         I85LE0iTbKlSKzqfvP8TWYcLKjVYicKGuQ+rUD/BB/weWJp8lO0X7QGvgPdfFvOgQMQg
         iCo9aRFzfyeqv2Jl9OfOaUxBOV4PWxb5uCbqo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=i2xgnS6P8oE/KrpMlccAZ+Y4dEgvLfcHqD32J1lx09Y=;
        b=GPW7vjgoCtrSVAG9w9nZ0OMAaLrNWdUqRbhd6u7p0HuyFHFknkBogQxoziUBuSJ/0z
         Ar+HY3y+Ikrinw0GwA8zfRWbqgJcwanQuOFLP9n7UT1DcB2avY8Dx0JC+JEFjCbiSnYo
         PLlKZYBU5Zg3ccHRk8mrI3WBS/ilGzJ7y8a4aoMZOivx+Y9upnKvdn4I6IEAsukvb7oh
         HFO1Q4sujFj59KdI6zxkCrtXmFLTodnpGDVJ+7ml8naO7hF4uTzldAjypfxnMdpslmeq
         BEk7LvjYHdz9A2A4WXV0k3Kn4tMN7myxgztTmpivSQkCZPGFfkD5hAy7Tj83zlIzwq7V
         yZ7A==
X-Gm-Message-State: AFqh2kpX5mbxpLuobjT4h5SaZr2KTCAQFfdD8zXvgk4Y1mBwn+whsx52
        if6BsWoMM0y0QZt8i5xszv8BeObmP4IGPMbOui7Wsw==
X-Google-Smtp-Source: AMrXdXuxy5OrJQPhjeuVD3E7jCOyZE9sgowf8xRuV/O6+/U+amwrJK46YAwEYVaaF4IJ3A8aKJQU9A==
X-Received: by 2002:a05:6a00:706:b0:580:d409:396c with SMTP id 6-20020a056a00070600b00580d409396cmr47276929pfl.6.1672963504915;
        Thu, 05 Jan 2023 16:05:04 -0800 (PST)
Received: from 5627e7ec9cfd (124-148-239-102.tpgi.com.au. [124.148.239.102])
        by smtp.gmail.com with ESMTPSA id 9-20020a621709000000b00580e07cc338sm22768631pfx.175.2023.01.05.16.04.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Jan 2023 16:05:03 -0800 (PST)
Date:   Fri, 6 Jan 2023 00:04:55 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/207] 6.1.4-rc1 review
Message-ID: <20230106000455.GA1929704@5627e7ec9cfd>
References: <20230104160511.905925875@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 04, 2023 at 05:04:18PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.4 release.
> There are 207 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.1.4-rc1 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Alder Lake x86_64 (nuc12 i7-1260P)
- SolidRun Cubox-i Dual/Quad - NXP iMX6 (Cubox-i4Pro)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
