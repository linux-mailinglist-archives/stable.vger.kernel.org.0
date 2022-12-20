Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F32F651D04
	for <lists+stable@lfdr.de>; Tue, 20 Dec 2022 10:18:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbiLTJSS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 04:18:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233274AbiLTJSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 04:18:17 -0500
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A78D9FE3
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 01:18:15 -0800 (PST)
Received: by mail-pj1-x1030.google.com with SMTP id b13-20020a17090a5a0d00b0021906102d05so11485419pjd.5
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 01:18:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=heitbaum.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jYtnjCT1VE6xPysrQULKJxODm4kr4P07YtrAqXvYELs=;
        b=EAB6OAdYSQC8gvGWV7mv5rj4USmhY3S5d9HSqFJ8llTT+xc5ZjO6lcMWksu3D5bFqK
         X2brA4qbfsjTGuXA9ZVcBlh3Qb2CtAGgHc9oy3Cuh8Ev8zRwaG9Bl2vdzhHi4yaF4zaZ
         ckA86ITd4WtTnMM20VNuFb6IkH2y5/h37i2kQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jYtnjCT1VE6xPysrQULKJxODm4kr4P07YtrAqXvYELs=;
        b=AwdXKjX8YkSS++Mn4S9cPsHYPIusevUie9WV0TSNNep7mXoLrgxnc21XPpxQPjaWLf
         6GjXLQDnaRX1gxSGVNw+FqRt2UwyjFGOBs8CJJ3BR2qmJUFhYo/SshhmcTd75udd2ViS
         xt107YE6qUzjzY9pXqEmZoa1xeV7dFcxtYt3YbfmKnhTRlhbQyOeeSSdIIa9sApHYWDY
         zeVbifsJvKnv5Laaji32qRmkzLzBJHHLqUzl0G0Hq0dr8eB5J/QQ+XVWtSENXMyd0muS
         UtvEDcUfJr0baydLGJGc+dH71n52++A5IvPEemOPJaHi7LZucz7tae3ofINKNMpzdGNQ
         o5gA==
X-Gm-Message-State: ANoB5pnf7tx5nJ7xuyNJSWIfWfPoRwyzjJzJH/JmNOFynpnqDJwsPBRK
        WAd5Csz6/5a8Y2RIMrg0b3za9Q==
X-Google-Smtp-Source: AA0mqf4YwgL2vvSeSQcktLr7W6vtjAyReWbydmWPih2WA9Cv80rZ1vPZsuMdcwjyiPdaNt0ObAngpQ==
X-Received: by 2002:a17:902:eb8b:b0:189:ced9:a5ff with SMTP id q11-20020a170902eb8b00b00189ced9a5ffmr46168902plg.26.1671527894944;
        Tue, 20 Dec 2022 01:18:14 -0800 (PST)
Received: from ec167f3768ca ([220.253.112.46])
        by smtp.gmail.com with ESMTPSA id f15-20020a170902684f00b00189ed861791sm8789543pln.266.2022.12.20.01.18.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Dec 2022 01:18:13 -0800 (PST)
Date:   Tue, 20 Dec 2022 09:18:01 +0000
From:   Rudi Heitbaum <rudi@heitbaum.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/18] 5.10.161-rc1 review
Message-ID: <20221220091801.GA955606@ec167f3768ca>
References: <20221219182940.701087296@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221219182940.701087296@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 19, 2022 at 08:24:53PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.161 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.

Hi Greg,

5.10.161-rc1 tested.

Run tested on:
- Intel Skylake x86_64 (nuc6 i5-6260U)

In addition - build tested for:
- Allwinner A64
- Allwinner H3
- Allwinner H5
- Allwinner H6
- Rockchip RK3288
- Rockchip RK3328
- Rockchip RK3399pro

Tested-by: Rudi Heitbaum <rudi@heitbaum.com>
--
Rudi
