Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 885605FF7DE
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 03:34:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229663AbiJOBeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 21:34:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229683AbiJOBeS (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 21:34:18 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39E637655F
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 18:34:09 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id pq16so6427802pjb.2
        for <stable@vger.kernel.org>; Fri, 14 Oct 2022 18:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=WWoZiJApWyCBKdB70ZB9Vo9hMSoVXmauhEs7d1wasQE=;
        b=DU5MvItccSyjFFbxc7gy0hUbfcvU8j3qj+2YZhgcfolUKe8NEGXzxCIFIgEJTg2cFo
         Rs9sUDSmeC8ZWkFAfI2zXS0/O6ui0yseW8X1JNpHQHvWXy32GcTJADggkXdMmNfVuUXA
         51UHi4ZzzL2NkKtx9m8wXJ4AAucHssSl9Pxr8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WWoZiJApWyCBKdB70ZB9Vo9hMSoVXmauhEs7d1wasQE=;
        b=DbaV8tp4u/Glb0olkCr5HcBE3OU01mfhP8hq41h91qmsuolCmygpvzu8diOU5ta4mf
         0Xu4/nBZZesMDsljpR1Nym2gSY7vZvh1QJYAXEJQfggWs9dEXqQxe0HmkvxJQsgIVkFk
         ZDPnNzBBNRCuuSkuG9NO/2VTtMVX/s3Wxm2of/cqD5DQ8na4L/20/6K8DvGSLvFe3sTS
         +3MSSwnm0WneKoSBdOwfS7KL50kHe0h7y2ziphe4TVuavWOG/NgR5150Qfbnb2X9QiDh
         +Xk/KDvwQoqRYCBxB2rRPaYPX5JLG1FJMSJ0ydscPWPaPh1JSge056UkLAQSZh5yEVqT
         rN5w==
X-Gm-Message-State: ACrzQf0nM2ZiQ5PeaOQPmz5rDoYVLc22fzqUU+JiKh+VH8tjBjptCiuP
        uex+m+BVNQ1ZF4hBbOrKsl9Llw==
X-Google-Smtp-Source: AMsMyM60v+OB85OF8dkEL5Ks5ZQlhXou3ViEFXWWTw9dnSluXa5cG2aN519MXXpxU4VxmIHVNy8nPA==
X-Received: by 2002:a17:90b:388e:b0:20d:4a1f:d5a2 with SMTP id mu14-20020a17090b388e00b0020d4a1fd5a2mr791136pjb.135.1665797647949;
        Fri, 14 Oct 2022 18:34:07 -0700 (PDT)
Received: from 90cf639d7f59 ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id x1-20020a170902ec8100b0017da2798025sm2306202plg.295.2022.10.14.18.34.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Oct 2022 18:34:06 -0700 (PDT)
Date:   Sat, 15 Oct 2022 01:33:59 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 6.0 00/34] 6.0.2-rc1 review
Message-ID: <20221015013359.GA78889@90cf639d7f59>
References: <20221013175146.507746257@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221013175146.507746257@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 13, 2022 at 07:52:38PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 15 Oct 2022 17:51:33 +0000.
> Anything received after that time might be too late.

Hi Greg,

6.0.2-rc1 tested.

Run tested on:
- Intel Alder Lake x86_64 (nuc12 i7-1260P)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos5422

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
