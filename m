Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3D1B5B854E
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:41:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiINJlj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:41:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56318 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231343AbiINJlG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:41:06 -0400
Received: from mail-wm1-x32c.google.com (mail-wm1-x32c.google.com [IPv6:2a00:1450:4864:20::32c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12ABB6257;
        Wed, 14 Sep 2022 02:40:37 -0700 (PDT)
Received: by mail-wm1-x32c.google.com with SMTP id r66-20020a1c4445000000b003b494ffc00bso2589865wma.0;
        Wed, 14 Sep 2022 02:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=XD4iucFLxgzqc21UBjYM/+y/OF171eyd76SQF2Uz+Uo=;
        b=Czzyg5Ii39bIdATod6MYoXL+0ce1NHBJMEk5TXZlBfgIm8ER3DsZC6h4FuXBm2TArw
         ahIrgNi083lSn5WMJocUb612EwQfUxM/QifkRkx2M08u2VpJ0wQ8VjeE9YUHBR2vOesw
         l1dxRUn6Haq+w0PZv2tSSi2mmwdZLIbmZxW5zf03GEYOZVfmnfDSWDF1cQE2FFcagrgO
         ld62sKv5+mybj6HNRhW9L+yGTSriIKBHC1eHfgwUb71y3WS3s5g3Qugxq4cp51ThXNdz
         CPWl+ebblrUq0EWj65OGURHb4M1+2/eRZv7HhWTiRvQ3oyrFfpHliFYZpWIBIEA/ULRn
         cGSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=XD4iucFLxgzqc21UBjYM/+y/OF171eyd76SQF2Uz+Uo=;
        b=yvIpADFUkSh1IriEnQlL4bLoYnWsHcnv842VxwXbZieAqK28njatYvEva1p7zRE5ea
         m9GsANVWC2G0kLcdBTtr9pTBKV2nNqut8+Yk6Saj6X9ehPcefvu2+ALIy4GcykZ09bix
         Kw+7JLOyyBaOYe2n8drao6yRqrUmX6cWiw028TaEv1N4ul7ec3fNlfib1ge/7rpaASNK
         ++y3jNSqM5HvXdpvu1FZoBoP9r/hLSDVSKTNyLowiQx/IxzBHgAgVZA16DfovGhvIxnl
         4QEq+miD5XQkT+O3K9WtvPSmQI30ab3ZrRQfLfraPnOYU2AIddNd53LOOADkBN40HnY/
         jivA==
X-Gm-Message-State: ACgBeo0cjSUrItdhppHwVJmv8TWshSP65R0dayiQSJ3RpNHnBzZhPU7J
        RqHupPBe8KWEvihMAegqzu4z1Tovr6c=
X-Google-Smtp-Source: AA6agR4a8T838OGuXPNJH58/mS7gzcHZP9BkO9ZJV29Q+dpwCsDZK5c2tOKebo4VXYuWV41KLkN6nA==
X-Received: by 2002:a05:600c:1c05:b0:3b4:9504:9904 with SMTP id j5-20020a05600c1c0500b003b495049904mr2413030wms.69.1663148435548;
        Wed, 14 Sep 2022 02:40:35 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id f7-20020a5d4dc7000000b00226dba960b4sm13107772wru.3.2022.09.14.02.40.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 02:40:35 -0700 (PDT)
Date:   Wed, 14 Sep 2022 10:40:33 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/121] 5.15.68-rc1 review
Message-ID: <YyGhkWGp8w/Q1yif@debian>
References: <20220913140357.323297659@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
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

On Tue, Sep 13, 2022 at 04:03:11PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.68 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20220819):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1819
[2]. https://openqa.qa.codethink.co.uk/tests/1825
[3]. https://openqa.qa.codethink.co.uk/tests/1827

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
