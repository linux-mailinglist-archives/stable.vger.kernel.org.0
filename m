Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 883105B852C
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 11:38:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbiINJi6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 05:38:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiINJi2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 05:38:28 -0400
Received: from mail-wr1-x436.google.com (mail-wr1-x436.google.com [IPv6:2a00:1450:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DC6A1CB17;
        Wed, 14 Sep 2022 02:37:52 -0700 (PDT)
Received: by mail-wr1-x436.google.com with SMTP id bo13so8238307wrb.1;
        Wed, 14 Sep 2022 02:37:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=9ICPhAk7WSUuojPvhuOrCs4K3x58Me7hs8cZWGyAJus=;
        b=mk1Yv6cJkliM0V8wFmEUe/iffX+9lJuUXJQpCPcJz/NuiF4W5MCtQx/F5lKLsIf13N
         qjDRKkRXb7Uz3h4Qwjvi3oNEW6UiaE46LHNo+q2md7D34mE943/oZjuWjuBlf80usrbf
         jz+C6UXX3Ig4UPtDA+WDBjykKQafKKbYCNrwlhlugGru4i8+q/6Yu03bJ5Zl0XmugQu7
         Sd64tw5QQgczkraFEHhHUxyCSv9LkqR6e85sZu5tWDmjl8LVS0w6+SRVaib5rLefGkp2
         rycahVQpmz/0rNlrpebOb+XZL9qpIc/DG3KHMO6hLJ36lRGy9neM9QPiJM7bQkqLgIz/
         IbkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=9ICPhAk7WSUuojPvhuOrCs4K3x58Me7hs8cZWGyAJus=;
        b=UQ9E/HG8f6vQoLzPGWqDEQBk+FlGSk5yzc2COdD0Vc214YXIAcqIMfZFmq4zWsBFlS
         qtOhczkoSxBLpxIHAp6jy2mTq270BdgsvN8qYT60a/Q4jCdXog3SvUmR5gnSswU8v6b1
         IW5H2/hcVE7mrfneXW8iuP2vNJFrrSE0uDouZP1ltEt4QY7d0KxRjJgIdsascOq5Vf3p
         u4VfLItAlQhv4hnqOXVsjubdyYrP+516Ev3DWvbnOGgQDBqqZCAgmXpXyksrtyIAebjt
         9CPT/hQ1LCjkUNqRZCOjHGdOfHBy5JBOXkDlOTAYQYsVIAp0bZq2HuIr7XUsFI4YWhR6
         2YBA==
X-Gm-Message-State: ACgBeo0j+pIgj+nMS96AxV4b1ZjGXRoZci5+Ar3NAN12IDpVm19tT6Ro
        c/BtA/NV+5juPwc4Gh/Ek/sjrnZ0HlA=
X-Google-Smtp-Source: AA6agR41v9glYIS6dOa+YPWh2Bjpb9yAI3k4G9HdagQvZAFBM+A6DoViLRJ3lZac9fbXlFUnHJi69g==
X-Received: by 2002:adf:d1ce:0:b0:22a:36d6:da05 with SMTP id b14-20020adfd1ce000000b0022a36d6da05mr17331989wrd.719.1663148270787;
        Wed, 14 Sep 2022 02:37:50 -0700 (PDT)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id f12-20020a05600c154c00b003a5f3f5883dsm18853027wmg.17.2022.09.14.02.37.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Sep 2022 02:37:50 -0700 (PDT)
Date:   Wed, 14 Sep 2022 10:37:48 +0100
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.4 000/108] 5.4.212-rc1 review
Message-ID: <YyGg7KOjq6P4Gjkj@debian>
References: <20220913140353.549108748@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220913140353.549108748@linuxfoundation.org>
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

On Tue, Sep 13, 2022 at 04:05:31PM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.212 release.
> There are 108 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Sep 2022 14:03:27 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20220819):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1829


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
