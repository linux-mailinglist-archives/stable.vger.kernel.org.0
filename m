Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01CE055E46E
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:39:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345345AbiF1N1I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Jun 2022 09:27:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346101AbiF1N0h (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Jun 2022 09:26:37 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44C8A20BCF;
        Tue, 28 Jun 2022 06:23:37 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id v193-20020a1cacca000000b003a051f41541so1215276wme.5;
        Tue, 28 Jun 2022 06:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=oq/jrOXGumg+wFCqwEtn+S0RlpS3zv1lOrwuwTr7d5E=;
        b=VirbE744El0ux/cgboOvd8d9QYO8uE5AfLj9IfXrOwcDZsSqjokZ7wVDb4WdEnTAaW
         l0aRHMiONhF1QdJV5GLvZ32rLh8m0EpAGnAxXAkZXVUL0hI+nrAltIKrDpf0BjyX25cx
         U/3CWEg8an1aCs/vq0JVOv4QBpy9waCFlE3A7adxk+pVZNGe7QGYvBETX7VGSBqmArsJ
         +YrEW5b6CPr4odEgCI6GH58ItSdpjWR/bIBbO4bTHMbfelxKFgGYENq/WuUANDUSxwVb
         Y4h1C6X5xGnCj4jycultrJGvRT/n2paT4oN8PlZb7//2zJlf/OBGAILdQDpdavlN5sFu
         bRdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=oq/jrOXGumg+wFCqwEtn+S0RlpS3zv1lOrwuwTr7d5E=;
        b=Y4zJgmu99i81+ByEcRkaUMd4RIbbrd2STtGFJ6tfN+VthdYzQQp0XT4AUc7IO5fsa2
         kJbevYjzuJjp67BsRrI4hepTibSW3F798KmbeJ9YhVxSIL1xxIGh4WuKvsOrhUc1aVnS
         d5D0fWCpCW4ZuIxzSalj2z4GBwKJkyuLElz4LlwOgfRmcG97V6SUPYrCrNSchJvS529b
         bh3OmVrOLcYl328NvwtUfewFGrs0RaFn97SVKREz8ex4x/PMrAFd9pG1Sb6zP/vUpPx7
         ZwRLpN/8xjudFYQ/5VgMh5YVLCgoRVeyxVsGtvwge+xM8Id2HcY8Cv04IqMPDAZ2VvCM
         Vesw==
X-Gm-Message-State: AJIora83RiQBorCpkA5RZHS1kliAdkiZerMP6ug+96SuIG1qfrHWu3mN
        XvDJv4nqOpTop8mUeNExKoE=
X-Google-Smtp-Source: AGRyM1vX8BVQ0WzLQXw6vwBows4gbxL57lAzxDZuFODUx5D9JLNMYf/bjPG3bvMxQy860HmpMk4o1A==
X-Received: by 2002:a05:600c:35d2:b0:397:84c9:6fe8 with SMTP id r18-20020a05600c35d200b0039784c96fe8mr21334590wmq.206.1656422615815;
        Tue, 28 Jun 2022 06:23:35 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id o4-20020a5d6484000000b0020d02262664sm13835581wri.25.2022.06.28.06.23.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 06:23:35 -0700 (PDT)
Date:   Tue, 28 Jun 2022 14:23:33 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/181] 5.18.8-rc1 review
Message-ID: <YrsA1T8/9XKY+6CM@debian>
References: <20220627111944.553492442@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220627111944.553492442@linuxfoundation.org>
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

On Mon, Jun 27, 2022 at 01:19:33PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.8 release.
> There are 181 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 29 Jun 2022 11:19:09 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.1.1 20220627):
mips: 59 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/1405
[2]. https://openqa.qa.codethink.co.uk/tests/1409
[3]. https://openqa.qa.codethink.co.uk/tests/1411

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip

