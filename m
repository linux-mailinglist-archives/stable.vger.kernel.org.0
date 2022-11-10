Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BF2462403D
	for <lists+stable@lfdr.de>; Thu, 10 Nov 2022 11:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230222AbiKJKsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Nov 2022 05:48:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiKJKsO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Nov 2022 05:48:14 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75AF658024;
        Thu, 10 Nov 2022 02:48:13 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id a11-20020a05600c2d4b00b003cf6f5fd9f1so861599wmg.2;
        Thu, 10 Nov 2022 02:48:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=r4lCer0ib8yS53NHws+Bg+/IpBVhxKdIhbbb9FfeQ6Y=;
        b=NswP7BHKj5WrqjQKDpq2XTXXsyeEtBBjanWeho/ilGSVsneCeUtMV2m1Iw3NT7tGcb
         O7tiArYZ49Y23Ah8SuKDp7BJuuLwSZwlgVvdTm28mrEJNaxMbk8x/WWaA+hxSOZ4NY7X
         aDZY9NqY6UkarGWJMy73oHrgpVIpXsXkMk4kx7z248luvsePkZE9xgqipBpyXwbyHj4/
         orfqhQwS5lQnMHBioRoB9QpsI6iM6/Hzq7yWP8Q5YGyUyE+A27ZYQQLxO4d3RLP9JYMl
         rZ2k8tW9Ngoe4huWF6r3f3TeBzx6FgnyZ3CHAgl9b1YIPymeH1zZeMVI9DUupkf7Qr3H
         H5bQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r4lCer0ib8yS53NHws+Bg+/IpBVhxKdIhbbb9FfeQ6Y=;
        b=ea/0p9dVWKvmY02FROZET/C5e9bxEyfYyESWo/7VgwPsFrxu/9GwWtLIgwRn7q3eTv
         cOFnVON5pmi5mEEISZrZ7sXd6UeNRpNELCAHVL6mgYSrqI2wbuJylhs/J/LOVYJa0Xe+
         Qmkp4hKtsefPpN33neTW5W9fTIhKP7RfD/doVMcanq+qT2WFyrDTLZ5fv6eKjRo1VCxt
         WKvpy5KtZa2HcocjKeg7JCIovzVN/G0j5KgfvKrp41B5I5/I1GmEPlvAsnk9PCmo8U7v
         7H0jkIa/Spn1NSds9StGe7srCpYiWoyQpnySRSmUiTTiIQSD8NOxnuhX8bir2d9jqyJW
         h8Iw==
X-Gm-Message-State: ACrzQf3WYzfuVWo/wuwHDxTnnDbktCqZpfcbsM9yV8j1cqJESCSdF81K
        bTf/7JZAsiiPddyY82ie6F8=
X-Google-Smtp-Source: AMsMyM4tGBAOjXlYHpbkc3qZVctPxopJbqfkaYyotAvXQhmIBEBt66Ff0mG9T4P61/bOCLH5sktB7Q==
X-Received: by 2002:a1c:acc5:0:b0:3c6:eebf:feee with SMTP id v188-20020a1cacc5000000b003c6eebffeeemr43577006wme.122.1668077291909;
        Thu, 10 Nov 2022 02:48:11 -0800 (PST)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id m23-20020a05600c3b1700b003cf47556f21sm5145207wms.2.2022.11.10.02.48.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 10 Nov 2022 02:48:11 -0800 (PST)
Date:   Thu, 10 Nov 2022 10:48:09 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 4.19 00/48] 4.19.265-rc1 review
Message-ID: <Y2zW6e3wghpG3egX@debian>
References: <20221108133329.533809494@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
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

On Tue, Nov 08, 2022 at 02:38:45PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.265 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
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

[1]. https://openqa.qa.codethink.co.uk/tests/2131


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
