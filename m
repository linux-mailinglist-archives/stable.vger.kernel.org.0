Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC22953D6CA
	for <lists+stable@lfdr.de>; Sat,  4 Jun 2022 14:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236096AbiFDMhv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jun 2022 08:37:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235386AbiFDMhu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jun 2022 08:37:50 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD142CE11;
        Sat,  4 Jun 2022 05:37:47 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id w27so13232178edl.7;
        Sat, 04 Jun 2022 05:37:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=/hAGMdhjThodGoSt1OTNT3sOvlzaiIFoqWEAAbUn3yM=;
        b=kbcUHAtvLUkX2+hSNR6mP4i1xLJQkUpXfBjsBZA4wdb19hlxkJox7+tq1aFmmFuaLH
         GA4IxnK5MPR1FMYhnMOHSdCNK8lU0+mOYfcVr7H/nl1sVtCH7c4sM3yU1H+Rv9uQAFPo
         RdRLsr2LNnWeKM+hFa1Bu4StIQovKLhiPz80a7FrztJW2kfsaXqphNIOu5PSmXWKZyu3
         3nGBs9Il2m6+7GXfA6s+QeNrMD9u8yFnK+dC4aLXtrWi91GCLWQlHTI5t+Pf3m4TUG3h
         c/KX2r8ZQHbLQ3ldDp29UGmd4/fD/EhXor5dtySotmD6EJEfKaTuW7fNL6XJxcBbm+CI
         QPzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=/hAGMdhjThodGoSt1OTNT3sOvlzaiIFoqWEAAbUn3yM=;
        b=fL2C8zdN2M0OE14i/Hm46srfzYzOahpIq3+fx/RYT+1xoK8mYxHCma2ztPbdIKqVcF
         88FkQ7fTF+qRZ9AwLpfQZZq4lBEDod4iUVLPpxyxYGdOhGV9sr4W9AecOZMMoJGMeyO+
         ldgrB7BVqIdEGY1k3uvQq1Zcsla3ax/zUcZS8lA4Gcipu2w5b6+h90h09Y3lrzFsYKM/
         GhYlC7UC9lol4e8NVcAyqGPai9kqjkwxHtTkSj7VlA4ZWShA42DEPzVmChBtxx+h1qTw
         Idhzmx+PzrwgMRE6ORiBDf6358b2S8OSoXIFwNVMJV/nNJ63ut+w4Ny3h9ukF2toJCSv
         cSag==
X-Gm-Message-State: AOAM530JNj3UA3FHPObtn6eA2/nXAZChZRfFpoUrwXytPkK2MGE4gAtS
        O7CL5b9C4EcMPm9hwacilZE=
X-Google-Smtp-Source: ABdhPJy4ab1s+W8S1Tno2KdWvmIzxVarRex31psNeYm/egj6ZQcvgzhfpuDAZp9aga4Vysv57LFOLg==
X-Received: by 2002:a05:6402:2815:b0:420:c32e:ebe2 with SMTP id h21-20020a056402281500b00420c32eebe2mr16395645ede.1.1654346266060;
        Sat, 04 Jun 2022 05:37:46 -0700 (PDT)
Received: from debian (host-2-98-37-191.as13285.net. [2.98.37.191])
        by smtp.gmail.com with ESMTPSA id 4-20020a170906310400b00705976bcd01sm3930358ejx.206.2022.06.04.05.37.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 Jun 2022 05:37:45 -0700 (PDT)
Date:   Sat, 4 Jun 2022 13:37:42 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 00/66] 5.15.45-rc1 review
Message-ID: <YptSFvJyra42Tcy7@debian>
References: <20220603173820.663747061@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220603173820.663747061@linuxfoundation.org>
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

On Fri, Jun 03, 2022 at 07:42:40PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.45 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 05 Jun 2022 17:38:05 +0000.
> Anything received after that time might be too late.

Build test:
mips (gcc version 11.3.1 20220531): 62 configs -> no failure
arm (gcc version 11.3.1 20220531): 99 configs -> no failure
arm64 (gcc version 11.3.1 20220531): 3 configs -> no failure
x86_64 (gcc version 11.3.1 20220531): 4 configs -> no failure

Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]
arm64: Booted on rpi4b (4GB model). No regression. [2]
mips: Booted on ci20 board. No regression. [3]

[1]. https://openqa.qa.codethink.co.uk/tests/1262
[2]. https://openqa.qa.codethink.co.uk/tests/1268
[3]. https://openqa.qa.codethink.co.uk/tests/1269

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
