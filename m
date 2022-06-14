Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E923B54AE27
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 12:19:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240603AbiFNKSn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 06:18:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232782AbiFNKSm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 06:18:42 -0400
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 335D84198C;
        Tue, 14 Jun 2022 03:18:41 -0700 (PDT)
Received: by mail-ej1-x62e.google.com with SMTP id g25so16198319ejh.9;
        Tue, 14 Jun 2022 03:18:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Ze3SRAskg20JXJZ29Ve01HSTHFs9NMQSYeleX04FJAk=;
        b=k8tK+4gV51dcJ00Qn/WZLlZbw+9YHuWTTNKynVzDFuvMoC2PI3VEAYSeAt131MJMZB
         MBRrUmVqGI2OyHj1j8sXzqF762wKn7uZrQjWAXqAxQNT1qrdD1yoG/siW4/GPY2VG+Hi
         IxewsLps2P4pBFR3MNzjymdLktFh0E4UmDOF/eS4DWoaj9+3bdlFdvXnH6tA0UCV4TqZ
         iHhhP8/s8aCnAzL5hi4wj1DoOTp6ZmNrji/oc0Ocs57th2izIlUCaVJJzcUlr/ziOgHy
         5+BOjeXc/gMP8ud+ICAOxjkNIsO2BqbgUsCNJRVBp5BQlie7iz43HxfpagfgkQfx55Ey
         CG2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Ze3SRAskg20JXJZ29Ve01HSTHFs9NMQSYeleX04FJAk=;
        b=ZLhmSD6sWhd4BWnNTUHr6keQ1nuU1Pf1E3gjv352K1hkg1UQxGzP2l1rZStUgW0ZuA
         p8NiwBssJ1jReWfsTKvjUCExSLPBf8g7u17oSdHS5ycG3WSudPL4Mao0gQDOdxFdW3gn
         F1C3X61WySX6exx+t70qr1hnG2iuTRdeSeuBrDnaDFirUHNTYjZRbCvsRPc55nttXqlw
         OAVZL/QqN2PG2xnpSgLk09dcsUT8LDSVhx1XumybVlwzGVLaCBzj1hAppbBgFKKcq+zB
         34hkIMrb3xq+qrxF7JvkwyJb9NHp3hmsBQoUyJ/snrGZAZDPTsTMraQV5mw5WV3I8jnv
         8pnw==
X-Gm-Message-State: AJIora/6xaGccJjw+13iL59jFJ8zexGM4jFsR1JW5CCPtppxgTmBslZ3
        BaphqyxhnwbwvHA1rtlemETJdC1jIxg=
X-Google-Smtp-Source: ABdhPJz+Ch1mkI5+VQm7KfUmXExE0ZPqv7g7Hu6x77+U+1NMWsSdIP+KmHflx9THIgJlxH+y2uUpjg==
X-Received: by 2002:a17:906:5256:b0:711:ee4d:fbe4 with SMTP id y22-20020a170906525600b00711ee4dfbe4mr3380132ejm.312.1655201919680;
        Tue, 14 Jun 2022 03:18:39 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id bk19-20020a170906b0d300b006feb3d65337sm4867252ejb.102.2022.06.14.03.18.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Jun 2022 03:18:39 -0700 (PDT)
Date:   Tue, 14 Jun 2022 11:18:37 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.17 000/303] 5.17.15-rc2 review
Message-ID: <YqhgfReks+Qac9l4@debian>
References: <20220613181529.324450680@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613181529.324450680@linuxfoundation.org>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Mon, Jun 13, 2022 at 08:18:43PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.17.15 release.
> There are 303 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Jun 2022 18:14:43 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220612):
mips: 60 configs -> no failure
arm: 99 configs -> no failure
arm64: 3 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
csky allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> no failure
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1322
[2]. https://openqa.qa.codethink.co.uk/tests/1325
[3]. https://openqa.qa.codethink.co.uk/tests/1327

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

