Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC90E62224D
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 03:56:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbiKIC4f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 21:56:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbiKIC4e (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 21:56:34 -0500
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD2B29813;
        Tue,  8 Nov 2022 18:56:33 -0800 (PST)
Received: by mail-ot1-x329.google.com with SMTP id a7-20020a056830008700b0066c82848060so9284112oto.4;
        Tue, 08 Nov 2022 18:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QLPNV0cxTVZ0YEjcA2rMUchDxxcB6FsSnvmyCsRVSOI=;
        b=Vn19NOXE+3OPxX1boSEy69mLr9tlCgIV8Qgdj98DOghW3NdDv+m5o2BDk9M/4R1ah7
         LrQ6xuUZjyd7IUxrW1HbADXL3CjX1JZjh1rwvauBTtlJJ+ZZJIUf1hSVT3nf4dapYjQf
         qgCuKclCL5ug0DS0gcmeeavqhfa+0ejhhgfk4ZMF36gtOmnJDl7fmSwLoCcqKE4gIfmE
         CYEiYJPDlZ6rslsih6Z1tn3mZ1Tm7USMTeAMM1am5ufEbRU/1SFZxbo+6xRn7rUyUHsg
         DYQ5XEDZI5MAlrdMTTrllNqCvWc5SLSeK/3C/8QJm8Dhf8jxySX+SBYYi6LrnrNo3ygt
         RpLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QLPNV0cxTVZ0YEjcA2rMUchDxxcB6FsSnvmyCsRVSOI=;
        b=y0XKVujjx5mr37qqr6/yUnudYh646mW9pcFocAeoPwghT3lmHzn0d3m8H4KzqAYrGk
         vaW6X3XvH9uathfx1dZH+55TgqorllmSLiqKLfwNQh2BoH5YMbICB1rtzi5rAINsHS78
         MEW0fslS4wit5dODBU1iGbHXggHcYF5fzM8S/ib/YlhOOPPQHMqZgtHE1z+T715qQlua
         QdICYzNFpvt+VAqECJRfxBOXdCAiP7fzBLK/dfLsolQ2SR50Lsd8mDurYLwxxGQZdzxx
         kQsH4qw/GqrJpSXciNX2n7TjCBVSFGqep1PdueleIzmVsvnP8FYJQauZrHMmI1DWWzUq
         BMNA==
X-Gm-Message-State: ANoB5pkeRkZqGgLCZdqFxbUwZgfZDqrpI6QUg1+Jomfl9rGUDjIUrfuf
        4e+mjCOO70rFe+ei5IJ8XHo=
X-Google-Smtp-Source: AA0mqf7ApFpoef99ywAEL4C4OKkaJSll9tR/lJJcLt/cgo3cU8DNjfbg5js1j6Yp65Eupd9oOzvZmQ==
X-Received: by 2002:a9d:655a:0:b0:66d:12d7:5705 with SMTP id q26-20020a9d655a000000b0066d12d75705mr4276756otl.140.1667962592431;
        Tue, 08 Nov 2022 18:56:32 -0800 (PST)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id k15-20020a056870350f00b0010d5d5c3fc3sm5521441oah.8.2022.11.08.18.56.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Nov 2022 18:56:32 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Date:   Tue, 8 Nov 2022 18:56:30 -0800
From:   Guenter Roeck <linux@roeck-us.net>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.10 000/118] 5.10.154-rc1 review
Message-ID: <20221109025630.GC2033086@roeck-us.net>
References: <20221108133340.718216105@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
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

On Tue, Nov 08, 2022 at 02:37:58PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.154 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 163 pass: 161 fail: 2
Failed builds:
	arm64:defconfig
	arm64:allmodconfig
Qemu test results:
	total: 475 pass: 431 fail: 44
Failed tests:
	<all arm64>
	<all arm64be>

As already reported by others, the failures are due to syntax errors
in devicetree files.

Guenter
