Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DB1869E2E9
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 16:01:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234597AbjBUPBD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 10:01:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234603AbjBUPBB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 10:01:01 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7499C2B61F;
        Tue, 21 Feb 2023 07:00:58 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id o4so4761692wrs.4;
        Tue, 21 Feb 2023 07:00:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=bOHnaqumSzvCkeAdCi/JvKB/RmaESjli5/JpvR7XJaQ=;
        b=TJRIv4K9Y005WXgOmnzBfsBi7OZwRev7SsWnoqIIMZI33gso2oXRcs0dYcOwFnWHdH
         N0mY6OOkGZypHI36Fcn24ElYS1uvVSKQk2MiemFhUArVR/2TDjaY5FJtoC2QdZ2mjyl8
         MImTvpNTk4pqSFb5dV+VmXiBOQ58urpu6ufQ+O0piYHURbkLX/EPMPEhw4buag9z/6mM
         fTb33CbMcYcemO+6KsNc5uGyxHC59jorV4xcgJTtY4kIxpaldWM+QesELmndD4eYcHuU
         EMIdwUTC9q/l0xnBPPpD16ajIwZKb7U22twdSgzDkteJuif4LUbPoAqzoCkzzgGeeOFN
         jAbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bOHnaqumSzvCkeAdCi/JvKB/RmaESjli5/JpvR7XJaQ=;
        b=egBaA8k6DAhCKsv8aOuXXwxeiWFBuZd+tRJRS2XbQaAa0c2DliDq0efrY6j3VB93kX
         JQ9coGVSHo0etRiq1Qzx1UY/hW9zcTZ250prqqTvHlT6mb9SE4sAzhDgAHVlg2uLYmgE
         FJxchepjRT5G1cyr3b/H4DJIpw77KTHNEpK/VuZ89MsAmmVDj5Lw+swBBaxu+wq3A0kh
         xbcpseUx4Dh0r9Eu4akRsQxQx2LKrjQm7cHfobKmVM2n7UpT+2H+ozBEhPGtrmIkvcZh
         2qBwJtKvUE2UBrUYSU0QbYejMRpTG85Lb4/7m5OW/B9a1bdDthtt9FaRpkj6vuRXMocW
         lUNQ==
X-Gm-Message-State: AO0yUKXwj2aNH9VPb+47UuXlHW9E7y/c4CHNLRHgJmJA6aW5WEYDJPjd
        /VLrVa3rTRaX1dfa7aT2D2I=
X-Google-Smtp-Source: AK7set8fOwARuarbsrKvPo0bsg1/oz8pvXlTOLIEu/dsO0MVjoWl03a9N2+ebT9YQI6DQ59mNfAErg==
X-Received: by 2002:a05:6000:110d:b0:2c5:5d18:4311 with SMTP id z13-20020a056000110d00b002c55d184311mr4537306wrw.21.1676991656918;
        Tue, 21 Feb 2023 07:00:56 -0800 (PST)
Received: from debian ([63.135.72.41])
        by smtp.gmail.com with ESMTPSA id d18-20020a5d6452000000b002c54f4d0f71sm6098316wrw.38.2023.02.21.07.00.56
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Feb 2023 07:00:56 -0800 (PST)
Date:   Tue, 21 Feb 2023 15:00:54 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.4 000/156] 5.4.232-rc1 review
Message-ID: <Y/TcpkAHqW4+n++/@debian>
References: <20230220133602.515342638@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
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

On Mon, Feb 20, 2023 at 02:34:04PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.232 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20230210):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2905


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
