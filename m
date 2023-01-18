Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D25EE671CC7
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 13:58:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230228AbjARM6n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 07:58:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231169AbjARM5e (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 07:57:34 -0500
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D1982D44;
        Wed, 18 Jan 2023 04:18:52 -0800 (PST)
Received: by mail-wr1-x42c.google.com with SMTP id e3so24510246wru.13;
        Wed, 18 Jan 2023 04:18:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=IzXuhTjwqwTTvvex3uE3V9EMJrJPQwqSYU5zyi+X+lY=;
        b=FXEPCsycYMMAkAKXfIAUXduQz87Ymlp+ZlN4h+kxS7ETHKGdAfbEI3dTSr58ux9cjh
         RuNujA2Vbi3wbeaabw6Ghyl2L5BWCu5agsYLl/+VTsnzr5sgzL/ZwJl//DdtDGQUmpd+
         hBMHydNtbgVkUDCvWmN6vJDW+FgBt/QeD5uq5+pS4K+OE5QIolpzPVbQy8TVpvEg2OzB
         f0vkYT+ana/viHts6dJsqGSb5kpQUrebotf4asW0se6LbPDhBMT853pz/vjaFhVRuu6R
         1A6HU/R3cCJJraauZ3faxlBtKlI/+ABFZ25vwI2/X0dkxn63eoBz8Sj5ahqIcyWGjd7a
         aBRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IzXuhTjwqwTTvvex3uE3V9EMJrJPQwqSYU5zyi+X+lY=;
        b=M0TLlljszfacAMDTw3eweTvqQs+Z7u3kr9cHGeNthr1llxMlBbbm2E6RwLdfn64LPu
         dgVWUtZb375REojEMpcXONBMMYuEcCyaX+nmasPRt2dplb2RzY7Rp7aEI8cgzGpoTAsp
         NGKGlNm0Sg8X8UQlNMmmUIzQWxIjExwKPlc6/Qi+bJY/mhHrUG2mTW4bBl9XL5brd0oB
         Cm4W19NLsJD1vFdL/la4CMLinPDPRpY37+T5n1RtgRkxuMh391aWhf7qDptMZMqY2z33
         3HyScfzCcV/BCxzNsX3qv2NWz5uwX60NCdBxTBzmbD/XteVO3XgAp4T9TNl2T4VauxP3
         jnuw==
X-Gm-Message-State: AFqh2kq1Z/gWyF7eQghkSvN0bSsh/sNe/0zGkrDklxcUxmRoIxBXjpdP
        vRss/CU3h2uXGPssFqemZIOA3g80P6Y=
X-Google-Smtp-Source: AMrXdXu6KyXChBO2hAgogSw1N/qRKhCpFiz5gsLp4sYI8qHA3eLkjrD+DPciPH4/UlkIvhbxBSOR9w==
X-Received: by 2002:a5d:4e01:0:b0:2bd:e531:8e58 with SMTP id p1-20020a5d4e01000000b002bde5318e58mr6039404wrt.24.1674044330613;
        Wed, 18 Jan 2023 04:18:50 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id e20-20020a5d5954000000b002be099f78c0sm6935204wri.69.2023.01.18.04.18.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 04:18:50 -0800 (PST)
Date:   Wed, 18 Jan 2023 12:18:48 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/477] 4.19.270-rc2 review
Message-ID: <Y8fjqFh/pRBpNOz7@debian>
References: <20230117124624.496082438@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117124624.496082438@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, Jan 17, 2023 at 01:47:51PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.270 release.
> There are 477 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230113):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2673


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
