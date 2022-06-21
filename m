Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30378552EF0
	for <lists+stable@lfdr.de>; Tue, 21 Jun 2022 11:41:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349287AbiFUJlb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jun 2022 05:41:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349157AbiFUJlJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jun 2022 05:41:09 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A036A27B08;
        Tue, 21 Jun 2022 02:40:58 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id g27so11430492wrb.10;
        Tue, 21 Jun 2022 02:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=D6IK5qAM4+nwclszfBVvija52kRu/tgoXBUL0u5OmCY=;
        b=pokqe+qJlupAZ6NDZWZTOzTmPSkQX0pnKIlKWIFLPw7D7bEIplTLUWtftCEvj+4bhy
         +q7T4liTwQnyFHfrA8hoUEe6lcMFBir6bZIdgccQOXOWcdSO1eQIipzMaaBIX+gedT/+
         1avlXrLpJLG8gPuPQbZR3KeFBT1RF9/ys9A3Q4UvfJ6F3H38+XgDgXpFvgizBSrxxyti
         LbcGMQWcCkEyWXtjMkyoKTonoMgGMIRGvdjIyJR54RUaT6JJYI37+Q9N6NksJ/r2gRCS
         rZ2OOUmkWMidhWalQv8+FMROir2WjfPS1f+FKn/3C3g2Ue6TqXi9M+tIn76g0d3uCUU3
         quOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=D6IK5qAM4+nwclszfBVvija52kRu/tgoXBUL0u5OmCY=;
        b=EisEpKanvDq/RIePrhATZ9fboXlLwQei4cPwnBc7JX+uQAiMjs+SQ686LTuD+MWw4o
         Chn4Jys4RaowyCzhu2IFLvs0lYe5KY0BT/Gn7u4a91JrvBYYm9ZaKb5A8Ftnv2PchDjR
         Mu0JlWn9lWXRQQlBy0ajX6Ecm9Lvg7raLd91stPzjqQssJyC06hsCUgSHgSuuz+GMed6
         GEuCQjw0WqtfaQDvN2FXY+3JN4EAN40MVPJDjWHOBAWmfXmyNo8XJXnbhmhMzwB8KPwT
         yk8ui59SxL/ds0xiLFCkopVPgQlrd2WPTkVEC4S8vZw4nyBFaCur2qQK7gTwU7xR9Dej
         Ii8g==
X-Gm-Message-State: AJIora8ssfPuqQSp78XKkXvPiu3+Qiq9OwvieY2Mz1FujwYL/myV1ed3
        vsIYudam5TO7CRY+UpX0Qt0=
X-Google-Smtp-Source: AGRyM1sl9n1DtRD9NWfc5sYeDqoTz2KL+YuK8EO5rctUOc41AD0GQ4xvno+14k9KMxlCQ3/jXiinPQ==
X-Received: by 2002:a5d:5588:0:b0:21b:9572:6f56 with SMTP id i8-20020a5d5588000000b0021b95726f56mr4385859wrv.566.1655804457025;
        Tue, 21 Jun 2022 02:40:57 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id m14-20020adfdc4e000000b0021a3c960214sm14575154wrj.6.2022.06.21.02.40.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jun 2022 02:40:56 -0700 (PDT)
Date:   Tue, 21 Jun 2022 10:40:54 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/106] 5.15.49-rc1 review
Message-ID: <YrGSJv2FShIunIkt@debian>
References: <20220620124724.380838401@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220620124724.380838401@linuxfoundation.org>
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

On Mon, Jun 20, 2022 at 02:50:19PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.49 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Jun 2022 12:47:02 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220612):
mips: 62 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1362
[2]. https://openqa.qa.codethink.co.uk/tests/1365
[3]. https://openqa.qa.codethink.co.uk/tests/1367

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
