Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3409571D3B
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 16:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232972AbiGLOqo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 10:46:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233625AbiGLOqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 10:46:43 -0400
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C8926111A;
        Tue, 12 Jul 2022 07:46:42 -0700 (PDT)
Received: by mail-wr1-x42b.google.com with SMTP id r10so5344955wrv.4;
        Tue, 12 Jul 2022 07:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=5v7ri+BJdcgpfgQ0J3MM2VhodQ3zOiHarfupjfMFRVc=;
        b=iIwLJOmRGc/3/AglvZYoEUS9OF/shQLjSEWip/rIjAEUdM9rcl6DfWMgZ09H1FQ7w3
         X1rQbH8IAr9YsKFYP5vp5ZImzsIxB+KGBPsnTNBU5M1qbASA6IQEZUXwCmIQJHkIKGKH
         Ymo9gVxs0ge7sC7H9UrgUIbFs5zkAQrArUDUTOYVFwMQTvFOs/umdTgA12IzyjAAjUIL
         fI7uiHs6X+rb2aV/XTIao2YLtpEGs6A/z5x32rLh1Es9QnJhOWXOfuP3NboY3XPUWPAT
         HnsNlMryMb/5VejcuoZ69xUtNyybJF3SZlu3E88MEP10tNV7XN+0ljYaf17I+LR6n/q9
         coyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=5v7ri+BJdcgpfgQ0J3MM2VhodQ3zOiHarfupjfMFRVc=;
        b=qNHxKjtXEYWTqOfolE8EWQacTEK4++6uFEf5+yKA7pwC1RBmk7MigPsOwPeFhp9Qhn
         dBLdPyL9KwdkSX3Kb9VPF0SdAh3w/b7HkChtgpox8ooR3C2jbGQYJxe5I4KE3L7olz9u
         rGY7vMMgZaW2wiIu+/67iXAnb3k7lCcg0NLNp7Mcy/QUFhG6sfwuXCarnZIedn3jdSF7
         trFayfsjPyh3R4BDMho6lUv1Xgp66WTskjj0XnbVvskv960nd4/DlZubjHQYoAvGI+0I
         KVjD/onkLjrO04clgsJHJSA3xrKx8gHq7joCf7h+ZGGZj7staStnEJEvl4rKpNgKXcbY
         A1Kg==
X-Gm-Message-State: AJIora/+O4bIYnNHtxVfp1rgPE6EdzMErniGMR/fLNldXEwV9JfMNZY1
        pvDVLFxIElvihUyCX2lwcySSUmyN/A8=
X-Google-Smtp-Source: AGRyM1sRzRRUw+RZYQ/zz9Xdmb0SBdw19bBoJAcSUzJtlTPvrv797Dv/PWoMvqzH/RXl9f/PHD7wTA==
X-Received: by 2002:adf:d1c6:0:b0:21d:8013:cdab with SMTP id b6-20020adfd1c6000000b0021d8013cdabmr21901133wrd.47.1657637201082;
        Tue, 12 Jul 2022 07:46:41 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id s14-20020adfeb0e000000b0021d7fa77710sm8446909wrn.92.2022.07.12.07.46.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 07:46:40 -0700 (PDT)
Date:   Tue, 12 Jul 2022 15:46:38 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 00/38] 5.4.205-rc1 review
Message-ID: <Ys2JTnoPf7nPWhCg@debian>
References: <20220711090538.722676354@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711090538.722676354@linuxfoundation.org>
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

On Mon, Jul 11, 2022 at 11:06:42AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.205 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220706):
mips: 65 configs -> no failure
arm: 106 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1493


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
