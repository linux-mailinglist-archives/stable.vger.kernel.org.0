Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EF254B1240
	for <lists+stable@lfdr.de>; Thu, 10 Feb 2022 17:01:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243952AbiBJQBG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Feb 2022 11:01:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236524AbiBJQBF (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Feb 2022 11:01:05 -0500
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D433E5D;
        Thu, 10 Feb 2022 08:01:05 -0800 (PST)
Received: by mail-wr1-x430.google.com with SMTP id k18so10371188wrg.11;
        Thu, 10 Feb 2022 08:01:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Vv43b7pMEssZvUBn4Nz22cToBBcn/GrvYK44d38bgMA=;
        b=iezX7bTaaEgUbpDTHPwaaNSihcWk14mvfpkdoJGF6jQMtdtZWH6hVXrbjDwkIDugoP
         cnRQKw9lqry4Z9tVLDmVJDzhAzGAEAkxqLbAAIyhRYPA0zVdBpMI6id32d/iKkpsekGa
         xdYkQSm/xzQMTaAzjrRYKKYnoVN19NryvONwTW/TNrQavLy40g/yWVpBG1TxrdMT0+G7
         4kvsYuCmvxWFdmoKuaaTkVV9u2HeMxU1chZsZNFcpOiZvbArgzJUVbBmBbs8P7pqjGrr
         cOTZ8LzCoTUVFNlZOxW5w1AUaWCN1GTK+KvfWne2qzclsPmgGPL5NFSp4eRDu0QBOEQF
         IIHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Vv43b7pMEssZvUBn4Nz22cToBBcn/GrvYK44d38bgMA=;
        b=SYJTmCCrLc3zyWSgDmWxbiZEkNdroH1VHtEi1HpUPBE88pmZEhGb79aNVoYkteAwvf
         Nx3r9yTImIChTcNtAqB4UEpWr42Gg2ilhhPe/TjdljULOHHVtpUqcNpDL5X7J+vBO8iE
         qO1mstdCHAVt8arH5VUkNbaxkjt+sA1TcZ0Wd+EGAFeTDTel2aNlK9sWewpaUQpvZ94U
         MBY3MSMC5nOe7Gdmk+qT0rHsXIKmCFTRMUV8hfKFMda63zLVtC/jUcQz6auRxXiRmYWl
         kCb6DM20pOM8C+egWeqTbNSNnB4bH+G7vS2ZK9D1RsoDlmYjrIenQob0JOitQKaWNoa6
         bSKA==
X-Gm-Message-State: AOAM531cS6E7qrWWYNlGtKL8HI4y0uZ7aqqyPAiZ32zLFcpaWPYm/JYQ
        37Pj3I6iboMY4KPVbZ0lxgA=
X-Google-Smtp-Source: ABdhPJzs9vfUPgIC0KdpPpzihhTIFuLANEm6zs3lJdOmM4a0p98gXdTlLFPpDZFtKJY8bsac68SgFw==
X-Received: by 2002:a5d:47cb:: with SMTP id o11mr6818424wrc.718.1644508864101;
        Thu, 10 Feb 2022 08:01:04 -0800 (PST)
Received: from debian (host-78-145-97-89.as13285.net. [78.145.97.89])
        by smtp.gmail.com with ESMTPSA id p3sm1939769wmq.40.2022.02.10.08.01.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Feb 2022 08:01:03 -0800 (PST)
Date:   Thu, 10 Feb 2022 16:01:01 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 0/5] 5.15.23-rc1 review
Message-ID: <YgU2vRk8u1VyIcA8@debian>
References: <20220209191249.980911721@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220209191249.980911721@linuxfoundation.org>
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

On Wed, Feb 09, 2022 at 08:14:25PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.23 release.
> There are 5 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Feb 2022 19:12:41 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.2.1 20220121): 62 configs -> no new failure
arm (gcc version 11.2.1 20220121): 100 configs -> no new failure
arm64 (gcc version 11.2.1 20220121): 3 configs -> no failure
x86_64 (gcc version 11.2.1 20220121): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/735
[2]. https://openqa.qa.codethink.co.uk/tests/739
[3]. https://openqa.qa.codethink.co.uk/tests/743

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

