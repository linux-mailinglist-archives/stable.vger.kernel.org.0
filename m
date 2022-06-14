Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7107D54AF7B
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 13:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242657AbiFNLr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 07:47:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242714AbiFNLr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 07:47:27 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E40392674
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 04:47:25 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id e11so8353304pfj.5
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 04:47:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9yjCf6oY3gJS5YNfh+t2xkU3PyOSCOkeJrjT3Jr85cM=;
        b=CsOKP9DatAjY5ULn1fGBTaFBmXY9q1bDyoUJkLdt8pcLNG+jg8zcWSdECEqagQgv9f
         9NUv02jJYfl30AI+RjDo+TVdnSTbeN6eyjchgdnP2U4r+epXoaE049dEaQBjBMNEaT9k
         VSWjg0OznvQcuuCo6Uk/o/3VT9XnbQjHbmVEg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9yjCf6oY3gJS5YNfh+t2xkU3PyOSCOkeJrjT3Jr85cM=;
        b=Pn8MVfJnHOTnumtmbmagfL+Jz8MXnIp+9HLbKv6EqlzzWmHkk+lcti7K/+wMialF54
         3c+6P8fQXLOWXZOiY/glEFMh4fCQJ5sHl5iv8pLe4YzjfPkwGupTQDbouzlP33ZoB9AK
         38XOk3hFZDBCEngWo/P5vuFPaYEPiXQPTfq0mKonDang8NcbdUfr/MRreryJ+dIY3z7x
         rdqmIbNg5cjCVTGs5vO0WmPO+7swwoJQzKzeBKziqZmEoAXiha78rqGQVosaayyhTnyM
         SH2nD4v8AhY9Pw/KYMkyr5oh6+K7MxZQc56IrJzsBvM5LeZX/IY78obIQkr3V4WCLTbf
         83BA==
X-Gm-Message-State: AOAM530IeNbaQV5KEe0DbVNjvTv6T3K8zcbVSWAY+fqHM+9p0e0Pic0M
        S2y7IIzhSlINVEzF2ScQh0SLXg==
X-Google-Smtp-Source: ABdhPJyS2jpnvZtL2c84oCGG7GjdOJvENERd3a1AmtOYUUk7rt0xRQr3M6SYy0NcwUttJzfbYRg4RQ==
X-Received: by 2002:a63:864a:0:b0:3fd:97a1:79f with SMTP id x71-20020a63864a000000b003fd97a1079fmr4237636pgd.51.1655207244652;
        Tue, 14 Jun 2022 04:47:24 -0700 (PDT)
Received: from 4207e2866154 (194-193-162-175.tpgi.com.au. [194.193.162.175])
        by smtp.gmail.com with ESMTPSA id m5-20020a170902bb8500b0015e8d4eb2d8sm6992433pls.290.2022.06.14.04.47.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 04:47:24 -0700 (PDT)
Date:   Tue, 14 Jun 2022 11:47:15 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/343] 5.18.4-rc2 review
Message-ID: <20220614114715.GA31790@4207e2866154>
References: <20220613181233.078148768@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613181233.078148768@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 08:18:34PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.4 release.
> There are 343 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:11:39 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.18.4-rc2 tested.

Run tested on:
- Allwinner H6 (Tanix TX6)
- Intel Tiger Lake x86_64 (nuc11 i7-1165G7)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- NXP iMX6
- NXP iMX8
- Qualcomm Dragonboard
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro
- Samsung Exynos

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
