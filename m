Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A09F600991
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 10:58:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230385AbiJQI6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Oct 2022 04:58:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230379AbiJQI54 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Oct 2022 04:57:56 -0400
Received: from mail-wm1-x32a.google.com (mail-wm1-x32a.google.com [IPv6:2a00:1450:4864:20::32a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 103262C10E;
        Mon, 17 Oct 2022 01:57:54 -0700 (PDT)
Received: by mail-wm1-x32a.google.com with SMTP id bh7-20020a05600c3d0700b003c6fb3b2052so316553wmb.2;
        Mon, 17 Oct 2022 01:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RvRmS/WWzelRJOm1Lkr41F5O2sysUeeeMCFTqIhnxlI=;
        b=X8Iniqp7ft/cRkqlHIOk6f4ucvveaOtCDNF5nLh7Vv8j7wKQDDPBQe04oq5jN3AkkH
         /Qukw0qejWCJxllcYifZ7weapbs2ZLgg1UXnQpMFvTAgbaIWflXDXR73aarUUeXrflAo
         MPHGsDlHCr3DNxhBmBEU9JnESfTN5Pccmba9PRMhsJ3fuQzbyjQ87URHUBqpn4uvKJ2n
         tw5lwlsds5mG3VDwWsudZis/gBbwLIJIwQi/HoAOM8KNVhpOmuY9dRYThN1E1MMI2/ja
         8wLsfoagt68VyobkH4h4PGHIXTzFEU2yBLLsVWVcpktOsP7gYnmC15Buz25pInVry2I5
         YSng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RvRmS/WWzelRJOm1Lkr41F5O2sysUeeeMCFTqIhnxlI=;
        b=EjFvjje4JOsKvBae8zklm5I7k9cF8+f3hwoyLu6/UvQ5GSvdWL60jJ96SX/2AdviNZ
         zUDByNSf/NuRUjuAjJCCjO0nT9eBTVYgL2s17NNuwMjl/LRPnbhEMCpYxcnQO+gfgIIo
         GWrsoAidKOiA7zcWVcaiyVYfdxucvDIMtlRzLjeNXy3L3vzDQnW/5r9NtzDnqIb0wepm
         +9rbE1BmQwLZ38/9wgBCS3AEmAuG3oqg215U8muaP4IoBJW4F3DNWFKSShwo//u8eYhv
         FxtPLJWNV5+om5NVqlV6Bv6DyOccdbrLk+qF4FqsaIPFzh0yR6VSNtUlBbaoGAwK8qg9
         CA3Q==
X-Gm-Message-State: ACrzQf14RLYHMYYfzXNJmb5hdX/WLSgwuWi2gqzCEntv0QSFKuD79pik
        OipDXvTMevWHL7p06crKWuM=
X-Google-Smtp-Source: AMsMyM7E0cl2iR9aiKGC26BCbNZbxZlE0p7YosJheMrZ1APzB2K6JT8Gclpa+gJ6ExA5u46LYqBN0g==
X-Received: by 2002:a05:600c:3d05:b0:3b4:9a42:10d0 with SMTP id bh5-20020a05600c3d0500b003b49a4210d0mr6720793wmb.135.1665997072581;
        Mon, 17 Oct 2022 01:57:52 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id f16-20020a05600c155000b003a3442f1229sm1048213wmg.29.2022.10.17.01.57.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Oct 2022 01:57:52 -0700 (PDT)
Date:   Mon, 17 Oct 2022 09:57:50 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 0/4] 5.10.149-rc1 review
Message-ID: <Y00ZDkbQlVi5b2Vn@debian>
References: <20221016064454.382206984@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221016064454.382206984@linuxfoundation.org>
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

On Sun, Oct 16, 2022 at 08:46:10AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.149 release.
> There are 4 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 18 Oct 2022 06:44:46 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220925):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2011
[2]. https://openqa.qa.codethink.co.uk/tests/2012


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
