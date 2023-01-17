Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B922366DDE1
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 13:41:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236753AbjAQMlx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 07:41:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236794AbjAQMlr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 07:41:47 -0500
Received: from mail-wm1-x335.google.com (mail-wm1-x335.google.com [IPv6:2a00:1450:4864:20::335])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC5B92BF32;
        Tue, 17 Jan 2023 04:41:43 -0800 (PST)
Received: by mail-wm1-x335.google.com with SMTP id c10-20020a05600c0a4a00b003db0636ff84so1458125wmq.0;
        Tue, 17 Jan 2023 04:41:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tUsS/S1vhjLGDULVUrqfQT/9OBGJ/diUFEtrNGhsMAY=;
        b=VXXSEFahBgXg/GbFajr+obxLmqF5XdExaJSdjYmFVZmL4NLZLn2FdG47irGA2jV+EU
         2EC9PKZ3hni7876cBe8idyBJSdi0kdNVceDPRnoRtQfBKEkaQF6w3MQ1N6oQ8EFrzMix
         B/3x1DNEysXU8Dva7BEpr8ZnxEmnZwV0w5L3wHVYC/g4MNxXBgEoPDdjDRqwkqJRAxp9
         oLWNBbj2Tx9jt3qkiLd5QtyagbBuBSc7d2LDl9eYZFuSgoY8KZQ9r03PJeC1kQiG4Jhq
         KtAmmU2Py7tB7HWZmUG8H9HW1tadOmlzfnbDzfr4c/3fB4acnTCrt29CRUlGFITIo7CC
         E4lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tUsS/S1vhjLGDULVUrqfQT/9OBGJ/diUFEtrNGhsMAY=;
        b=46EXUKEgGkajNgzIImbMLEx4nxAcZUfhxXKnYWeXXYa2t9hVC9+5vKahGYK5+HJKPf
         ZyyIf6ClYVPsi/vwPzewq4uCxcY8GW5CiOLEDv71gXkQ3HjcGlTch+qibbJTfoegN8m0
         mu3ZkORlCJn1QypYHWDm4d7QcpfMBwAFqirwAoEk9Lqpoj8pr+KEulXnjjGG1bUfBnLg
         0r6YiVXHHSJEKWVuQ1fK2cqgMmYWFZE4Rgk7181vU/qLCW3u2ZpkI1UN1Pv3MNr5Gfj4
         lrE2pYn43z6/fi7VdONdr1AVfBPBEfxfrr4uiF/TUF2ufip+kECo3201cUCSTvoQ9n4P
         BmqQ==
X-Gm-Message-State: AFqh2koonuH/cNLTV9OmZo+mHlz89ebQa032NRX2b/UZCf+X93Jtuf4d
        941qRjc6aQxEFOJcQZAVJig=
X-Google-Smtp-Source: AMrXdXsLgTmUCsSpvSljpNO6M5xKD2LgPxhFYTKrcmAoCAhM39qQe2va32K73GyRUVjhu3TXLOPBBg==
X-Received: by 2002:a05:600c:d3:b0:3da:23a4:627e with SMTP id u19-20020a05600c00d300b003da23a4627emr2895995wmm.6.1673959302119;
        Tue, 17 Jan 2023 04:41:42 -0800 (PST)
Received: from debian ([67.208.52.125])
        by smtp.gmail.com with ESMTPSA id h8-20020a05600c350800b003d990372dd5sm46346344wmq.20.2023.01.17.04.41.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 04:41:41 -0800 (PST)
Date:   Tue, 17 Jan 2023 12:41:39 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.15 00/86] 5.15.89-rc1 review
Message-ID: <Y8aXgxQHjmdUzC1F@debian>
References: <20230116154747.036911298@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
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

On Mon, Jan 16, 2023 at 04:50:34PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.89 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.2.1 20221127):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2662
[2]. https://openqa.qa.codethink.co.uk/tests/2666

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
