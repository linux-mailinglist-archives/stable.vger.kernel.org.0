Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A712F665BF2
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 14:01:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231947AbjAKNAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 08:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233845AbjAKNAp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 08:00:45 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D01F1C4;
        Wed, 11 Jan 2023 05:00:44 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id co23so14947762wrb.4;
        Wed, 11 Jan 2023 05:00:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=GciVknUp2+tJrdQZ3wGdbeoH9KpDzgfg+dAYwK6p4NQ=;
        b=hFs0FLeBgkXlb8v7+s7DzG2Gy3uf0Cp4O4WExnbWOF++Vn1pUqBIHMU2Ri+G0wss6p
         4sCe4pfh0UvfFFDYxHWP8738wJvhNliIxM14ZJm2hIdA9i1eDBCqg1qBjDSu7EdlASED
         v9/Xh8XRRAXVDsTmOACbb8iq0NDDhK9XJsyJz2pT5aipt+MGYVnSdi790tR39lG5lS2T
         VXS6gBa8tsPuXPv4aejCiub4BRberdhUIMkG39SOxHskx6UxJ4b7D1Pa8i4shxnxqRP8
         WpyFe9s2atWwRrgkL8rGoH/6SgexZQBhmgoau1ha3tjXqtp2nwPWeMQG0F7in8nXiE3N
         DxZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GciVknUp2+tJrdQZ3wGdbeoH9KpDzgfg+dAYwK6p4NQ=;
        b=TT7vrLdbL8VnS5OR5IhdfPpFBVAGusTGzmRxarigSCtyXsKXs0w7GqHi6e+gS7747/
         ln2qhpATXgCbRckSxAWx9BO3J/qdcgf8u7H5WWjQMg2MAWrfdKduTn3XMbJ7rCOQqawP
         I2E7yh5G9mVgaunkgzwkNReg/rFCPP5NLlq8V7BoaDuA7eeSF9f2cjNr65lSCNcCGyW4
         sJQ9TGXmgyHvpSQxqjDw7zQx3QR3e2vDzEWF1ov6xWP5NVo44b6xbO8hQaFMY26zTlSh
         z8m26ZadUsuuiEDCQRr2Jqz98S/FViMwthMMT8P6IJYu73n3jn4E0ZHl05cK6ztpE68Z
         1q5g==
X-Gm-Message-State: AFqh2koU/YpZXAP1ArmBRHP9G25QEEAOxtjXJTT7RckOZzedmDA/vBOZ
        oxZCWVI4VU8+ergAU26VDko=
X-Google-Smtp-Source: AMrXdXsORqDA5bKI9k1rg0ymSgo23lzq1B638aQ0UaQn2i8MWHUvB5+6xgf5+Q2xQ8/2JEEHid+hBQ==
X-Received: by 2002:a5d:5c12:0:b0:242:800:9a7f with SMTP id cc18-20020a5d5c12000000b0024208009a7fmr48838506wrb.65.1673442042777;
        Wed, 11 Jan 2023 05:00:42 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id c13-20020adffb0d000000b00241fde8fe04sm13629177wrr.7.2023.01.11.05.00.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Jan 2023 05:00:42 -0800 (PST)
Date:   Wed, 11 Jan 2023 13:00:40 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
Message-ID: <Y76y+IsErvZyJEIU@debian>
References: <20230110180017.145591678@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
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

On Tue, Jan 10, 2023 at 07:01:44PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.19 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> NOTE, this will probably be the LAST 6.0.y release.  If there is
> anything preventing you from moving to 6.1.y right now, please let me
> know.
> 
> Responses should be made by Thu, 12 Jan 2023 17:59:42 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
mips: 52 configs -> no failure
arm: 100 configs -> no failure
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

mips: Booted on ci20 board.
Known issue - VNC server fails to start.

[1]. https://openqa.qa.codethink.co.uk/tests/2608
[2]. https://openqa.qa.codethink.co.uk/tests/2611

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
