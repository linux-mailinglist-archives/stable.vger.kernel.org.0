Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DD0A671CBE
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 13:55:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbjARMze (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 07:55:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231219AbjARMyl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 07:54:41 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED3E1558C;
        Wed, 18 Jan 2023 04:17:11 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id f19-20020a1c6a13000000b003db0ef4dedcso1257936wmc.4;
        Wed, 18 Jan 2023 04:17:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nkpzOUujUL/bH5pG79UVQRHaTTKQoLKlTvXHncVMSXU=;
        b=UsajSL/h4KOodrBAOWeq4h2gvPN/ifdI+pGmybkA31mnmB1LIPMUN48Hf3S92UcrAh
         b+Bz+U/ZcdRNtvjpwhNLQL7H953xZlpzL3o6Co0ID6gDAk8LE8/Qni5Q5GZ+KCAPdTa2
         BbWcWxkKaZyCwt4lnj6ABUkrG2/mJiH8jHtyJWCFxk6AzmCf0JOfse0xO0M4+mU/WxXx
         FImhtCum1QGCzm5NMEQMy5XmpbKxAsfzpMqdZO2pTHyo0PACSvk6ZNDIG+mdk3B6ZORg
         sCZABmjsIxdE3P3JvJ1ex3oAemq8ca94mr+1/B2ASGZkMtJa6+QKE9t/tPAiZIL/5Etc
         uRcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nkpzOUujUL/bH5pG79UVQRHaTTKQoLKlTvXHncVMSXU=;
        b=XxBEFJoevFgOXNwirViv6697BshjlrhIhSnpYsRgj8Fh3e7HtmSOZKF/EvE5qrs3qb
         Gr3HADChPnclzydQ/4tNyYeOfhVkHUfZ8cY/SRIGjgGgFT7NolEefDI4rLgxQ2JIKEBo
         HIb/sbY8dtp/Uef1SCRkTzmQhagOqx6Rj131bW43fg88XxZAeEo962657o2pfGz68hTY
         rZZnTxgmjbWaIjw/JuZDP2Yzrt1jFdlH6FJGpczBIHoLJNkTzuDVEP4BTvvjwR56UUuh
         hQ9EX2ijJ4i5JvRZo+uI7mSknItm4OesVc4RqfhB7oLiQ7SQ/7aZQcPvOUzMbirCTpHI
         cPcw==
X-Gm-Message-State: AFqh2kpd+gS2w+XYLDWi+M5tKZ19/SfweCzL/4DWMa1xOjjWbrl0sGO0
        Ki3Na3qgNPbtZNi/Nu0jQL4=
X-Google-Smtp-Source: AMrXdXt98Cg68MzymuRIgwrgiV16gUS9AyNfHMl3DQSLJx2Z5tzO+T398OXxWwRWRRohm5fJpmHhCg==
X-Received: by 2002:a05:600c:3b18:b0:3db:eab:3c5c with SMTP id m24-20020a05600c3b1800b003db0eab3c5cmr3527109wms.32.1674044220067;
        Wed, 18 Jan 2023 04:17:00 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id o2-20020a05600c510200b003c6f8d30e40sm1957845wms.31.2023.01.18.04.16.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Jan 2023 04:16:59 -0800 (PST)
Date:   Wed, 18 Jan 2023 12:16:57 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/64] 5.10.164-rc2 review
Message-ID: <Y8fjOblGA1JjOF+E@debian>
References: <20230117124526.766388541@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230117124526.766388541@linuxfoundation.org>
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

On Tue, Jan 17, 2023 at 01:48:01PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.164 release.
> There are 64 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230113):
mips: 63 configs -> no failure
arm: 104 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]

[1]. https://openqa.qa.codethink.co.uk/tests/2675
[2]. https://openqa.qa.codethink.co.uk/tests/2682


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
