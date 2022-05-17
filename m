Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D53FE52ABF7
	for <lists+stable@lfdr.de>; Tue, 17 May 2022 21:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245427AbiEQTay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 May 2022 15:30:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352058AbiEQTaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 May 2022 15:30:52 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB96634F;
        Tue, 17 May 2022 12:30:50 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-edf9ddb312so25459779fac.8;
        Tue, 17 May 2022 12:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=MIM/0zZZYs3VXT5IhW15ExsYKi1hqKjT10ypkCUM/Ms=;
        b=K9XaT25DcIX2IgPBm1Gzc8kOfWkeNkyeBtx4GYepEC8h+VG3Bnpijk5ih1lq7E8zJH
         rEhuRh8PSBHCJc7jxOmAAp1KTlFSUy+UrH6NFyYbSL6J7aHZ7buVCWrUCo9MPNbEZld6
         ih1KSC+nkYYBAZeJE0Pne/K8g8K8STK0VPp/eyFdQj5YEBXqkPWd42HZe4x+tPbXuOJa
         ez13J+K+Aead3anq/HdKo6F4mS0yGEQF5exarrpp5YOHWH29gq18LJTutwVYqcDyhGHx
         GE0jVOIpSk5atW0SP4dn8UW1RXm9p0elnYaC1TVkoDsvT5SR+XwJHxiBTlFkaEGlAr3R
         TxTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition:in-reply-to;
        bh=MIM/0zZZYs3VXT5IhW15ExsYKi1hqKjT10ypkCUM/Ms=;
        b=nBb2JcYQaVolINVlciNOcM+X5jXTyK28vLyMiXFj0Eq3Qtp3tx3qJRXQk9jzu+nW8f
         EGPtFsAk7f0u8aiuVlsvw+Xghac8H3MP3Tyc3TIPtKt/L7JC1XyBz8L8x6XT80VJr1hZ
         4rTFXopSnD7InXAMO8xBbTmu5B03acNUdvp3ANbmBDy0h3QjuPT8VFBSpBE56/Yl36n8
         oT5lafzr9l/4kyZA7Ccz91o5NdLbh89P3DdBdEk0PSjWB8W0cwgTjIN6BzLHkLgP0gXd
         0jwzeoVfAV4VFtASYUP7bwvUzjQaoRpAzvRFZnUTsLh4LWWaQD/2+iIC5CMEKDbEYXGh
         4UPg==
X-Gm-Message-State: AOAM531KlPSkXim17XMaTxdx+rO96CTmezeuGcl9WDuICX7q1+ilSZy7
        PwccoBbuz/DKwocEO8mdtdo=
X-Google-Smtp-Source: ABdhPJwVq5plJYJDImmFdLRw2uj0mEp1GKn2vLq4s+d7GQyixXVoZjT7FJLnEJsEwuiuRMCD3Pt32w==
X-Received: by 2002:a05:6870:391f:b0:f1:b015:e268 with SMTP id b31-20020a056870391f00b000f1b015e268mr4987532oap.90.1652815849996;
        Tue, 17 May 2022 12:30:49 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id w6-20020a9d5386000000b0060603221236sm114220otg.6.2022.05.17.12.30.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 May 2022 12:30:49 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 17 May 2022 12:30:48 -0700
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/43] 5.4.195-rc1 review
Message-ID: <20220517193048.GD1013289@roeck-us.net>
References: <20220516193614.714657361@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220516193614.714657361@linuxfoundation.org>
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

On Mon, May 16, 2022 at 09:36:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.195 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 May 2022 19:36:02 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 159 pass: 159 fail: 0
Qemu test results:
	total: 449 pass: 449 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
