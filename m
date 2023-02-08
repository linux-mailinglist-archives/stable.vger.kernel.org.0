Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 12B2568E774
	for <lists+stable@lfdr.de>; Wed,  8 Feb 2023 06:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229487AbjBHFV4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Feb 2023 00:21:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjBHFVz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Feb 2023 00:21:55 -0500
Received: from mail-oi1-x22a.google.com (mail-oi1-x22a.google.com [IPv6:2607:f8b0:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21E499010;
        Tue,  7 Feb 2023 21:21:52 -0800 (PST)
Received: by mail-oi1-x22a.google.com with SMTP id c15so14441878oic.8;
        Tue, 07 Feb 2023 21:21:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3MwmDRYUiuIP57TOBUiF1qHto6HgRj8SQTrIXOF32BM=;
        b=iCYhwZVndf4CvbPAhBWO9qXxO58yn/R+TRMRJDES916/nKD/q3sUQ2BH0+ArUNQPfk
         Rq1DJyp/UwqRYopWxZr66bBw1pwxFGEvqbtole0iLlFlVQ/D3q5VR+1eKoSU5LlriNfb
         OGeLkb3+FJQHkZVz5CXmaiTLkpqzYRpE2dC+7GuuTXa0QRi/nQW8MjVtOKkU1Uj1MzWF
         hH8Qeb16IYFre2QIxxGTT43mIgPyodgVHsTqLJgbZVtW9yAcDsm927K35+OEVBWI2wnU
         ztkB7pC7XK3b5nksxW/yorfIsiCfzJRG43JjaPmfnNIV0tBgvrtcN1LdRBa37JZL7/vt
         6rZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3MwmDRYUiuIP57TOBUiF1qHto6HgRj8SQTrIXOF32BM=;
        b=XpzNVVWiLFnBvAOiSOyR5PuGynT7bZcQVApfuAo0xc7kCYjcscV2DBwDKYAVkrqU8V
         3kx+RboSR17rMCpX5DdJAGmaCMac2vgnI3qwIkoeKzsxWqprEUdRnr63XHKL6QPeFEeh
         7wEZI34KA52M4Fdt/vldIiT7WWAZ7F6MCtsMzy4RT1NuBmCaO0DxrelBMH0GfpUTmQxv
         McA6x1Yjzw3xjQBsihpxXMEG5DHSwEnuRNYFPs4gmOZWip6jc538oGFMMRpc5rIgCXVk
         KwVwGmcteLc14oG8CsZPXZpbLTokYApnSbZwJouCE4ZgeTA15OpB79cWQskUJ50h7a44
         7vbQ==
X-Gm-Message-State: AO0yUKX6ILkwn1I1RIDBAdElH29/nP0Hdw59yKlSxD7GqMUHE/xBoJOd
        XqF3iWpxl/HndVIPomi6kBY=
X-Google-Smtp-Source: AK7set+AmIP3G3E1ULYY9y6UVKx6pW82UaxIXTbUgyyET4glnGpStsLrrDCWZUQWXKU4GtZBuzcbcw==
X-Received: by 2002:a05:6808:434d:b0:367:7633:30f0 with SMTP id dx13-20020a056808434d00b00367763330f0mr2514784oib.20.1675833711641;
        Tue, 07 Feb 2023 21:21:51 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id g12-20020a9d620c000000b0068bbb818c64sm7651846otj.25.2023.02.07.21.21.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Feb 2023 21:21:51 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 7 Feb 2023 21:21:50 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
Message-ID: <20230208052150.GB3509133@roeck-us.net>
References: <20230207125634.292109991@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 07, 2023 at 01:54:14PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.11 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 155 pass: 155 fail: 0
Qemu test results:
	total: 503 pass: 503 fail: 0

Tested-by: Guenter Roeck <linux@roeck-us.net>

Guenter
