Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AAA9588135
	for <lists+stable@lfdr.de>; Tue,  2 Aug 2022 19:42:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231160AbiHBRmX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Aug 2022 13:42:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231132AbiHBRmW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 2 Aug 2022 13:42:22 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A166DF4E;
        Tue,  2 Aug 2022 10:42:22 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id bv3so4857047wrb.5;
        Tue, 02 Aug 2022 10:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc;
        bh=uMymkjvhOIcHe+sIXSnW+UwLBk8H2QUc7FOOoXpXHb8=;
        b=CVwJje0b8xNV+ysA9tcGpwaEVno/l6Tq8zWv67ZEG1DfK5dfpo+4C9fTA1CphUJ2da
         cNLz9c7GZrNl7TD0YRKB38XxC2jEGi3/KcrgPT+GHBMxkSliruQlyR1+ujfcWIL1AZXS
         gnkbDZ4IZic20zBg+IUusKcqSMCZy9Dim1VBgIit9s0V/Kxvh5ycx9jCIGrNFYYORssw
         os69pEp6+8JC4741xhtr9jON7usmqtfz8sWsKMROlIMfpDZPbfni4a/jsLnpuM6eFSKg
         eJ8Ch7l/OmbORXKiDPjrLPzkh5DjIBmSBzvNVn6OfoVW7m79/2MLnYC5Hb45FCYGPO+I
         KhUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=uMymkjvhOIcHe+sIXSnW+UwLBk8H2QUc7FOOoXpXHb8=;
        b=XeQsAbPhXvUFrVIwF17KqCWXupt3ZD4/lDD1MSfbK54iW6gp6YNYYGYmcy6f0zYETr
         GLiEJXPP3t4TbYzMekJZHORn5/VDaRj4SxhuXPoO3z6Oi35k5fOMp1G+iivZ50NahVqy
         3BUDfadl2SWy93vLlXzgTurSu0aXuKjdro8r17FSUA6HPFOY7+vlglqv2OUTZy1yAGX0
         OqFipSzU+XTl19tw+B8rFEBTIbabg/SOuRjSVTPWDIllL4wK98/UFwWWYEJFoVtiJiiM
         hdYocgm17jQxx+8bQ7Atho5AIJgurjd3jU7Y/0iMxmfFIOUg2EystWQXcqeJMyJjHBqz
         lKog==
X-Gm-Message-State: ACgBeo0UpHy33J7jWaqh/LM5OM/K9ion7nw59lu7N3dv6n7xCEbavXOV
        EAoEo4mYbLHDSDO/2aKCw98=
X-Google-Smtp-Source: AA6agR4GttsrbDq2JcA/FdVMaSkFZw2cy0s/eZMfGRftJ3DZCpwitW95thj2EbUhKal9LHyP829itw==
X-Received: by 2002:adf:f6cb:0:b0:220:7859:7bf with SMTP id y11-20020adff6cb000000b00220785907bfmr789777wrp.683.1659462140622;
        Tue, 02 Aug 2022 10:42:20 -0700 (PDT)
Received: from debian ([2405:201:8005:8149:e5c9:c0ac:4d82:e94b])
        by smtp.gmail.com with ESMTPSA id s14-20020a5d424e000000b0021d7fa77710sm15725446wrr.92.2022.08.02.10.42.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Aug 2022 10:42:20 -0700 (PDT)
Date:   Tue, 2 Aug 2022 18:42:09 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.18 00/88] 5.18.16-rc1 review
Message-ID: <Yulh8fzUJWY89i4J@debian>
References: <20220801114138.041018499@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
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

On Mon, Aug 01, 2022 at 01:46:14PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.16 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 03 Aug 2022 11:41:16 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.1.1 20220724):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1607
[2]. https://openqa.qa.codethink.co.uk/tests/1608
[3]. https://openqa.qa.codethink.co.uk/tests/1611

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
