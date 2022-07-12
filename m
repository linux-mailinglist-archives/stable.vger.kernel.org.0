Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 53E2F571CF5
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 16:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232048AbiGLOkc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 10:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230305AbiGLOkb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 10:40:31 -0400
Received: from mail-wr1-x42c.google.com (mail-wr1-x42c.google.com [IPv6:2a00:1450:4864:20::42c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D9ABA3A7;
        Tue, 12 Jul 2022 07:40:28 -0700 (PDT)
Received: by mail-wr1-x42c.google.com with SMTP id o4so11492146wrh.3;
        Tue, 12 Jul 2022 07:40:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ZvNiAKDIQcW/Wy4B2m62fb0bwKFRVyZdcz+LTYmntTk=;
        b=aNnTKanesMbIhxJCc17TDVXy1iLPUmcZAeRwYKQoBKDSPA03NZAbbo+sFxFZKi+ihg
         KqeS/EcGdOvsVmlS/tdURIizAGY5bLKTgPsefTrRnUj662RxLUHC/L9eAMyZhFOss/O9
         jtv3oNU1k+ryIs8U7sNfas90IrRK19mcgJb9Mn1E3FQgrjiwfunbKtfQgTtrehPyn6m1
         Y/G+4yXtMWiRkatuNH/IcZbGhXcWegTcXzkY0P6Izzea7U2M66JGsPptz17X5e1zK+v8
         3H0eDuN3a2oe5wZIWOiJ7TO4NHCH0xkPZ4fCBALOnii86Z1gJ3QY9QO3qlTPDbY/7OZI
         iwkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ZvNiAKDIQcW/Wy4B2m62fb0bwKFRVyZdcz+LTYmntTk=;
        b=4wyI9woTO0WRf2/OWSubWCSr40NqwcasiLeGm3uGQI4Tl2ocydr+Q8ozyBA6ZLA6qA
         C+nYigHM9hOWt3VC1g58t9INdVTvRIQ2cWSu6rYIA8yY87g3Sal6LmQX8Q5DCXSwTjpx
         44yKKXQVySQXQ+NILb6Y1vvpPL5x80sF7S6bxefAsVph02z6T8/9ZgEy06MwwoBWZr44
         K/6ocR1vh2d1f8eg5fSFJljooAxH8Wx1AqcpP0pvJ3TYvBE5pa4cR4WaewZkCQXnGuQw
         9fFIl1Pd6OBL09VwX5TeDdxnPBL6i3uCPHNO5OSzl4W07PPYIUmtZ+QzSf7StqQ3Bqod
         b2QA==
X-Gm-Message-State: AJIora+VdoASQfE4X2xjKkIqkYNLunbSyuj/FNX59NE+z6G0Z/Jkmwib
        MLzNhdYf5RjHdG4+yLSeJHQ=
X-Google-Smtp-Source: AGRyM1vdJCCZFYk4+FhTJMbat37kbEAJUlU0VhJTCVhWuwoYe23aCJRMosWxSoZgFwe8hqE4S9/jCg==
X-Received: by 2002:a5d:4a0c:0:b0:21d:78c9:c5d3 with SMTP id m12-20020a5d4a0c000000b0021d78c9c5d3mr22238478wrq.42.1657636827074;
        Tue, 12 Jul 2022 07:40:27 -0700 (PDT)
Received: from debian (host-78-150-47-22.as13285.net. [78.150.47.22])
        by smtp.gmail.com with ESMTPSA id j27-20020a05600c1c1b00b0039c4ba160absm3662115wms.2.2022.07.12.07.40.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Jul 2022 07:40:26 -0700 (PDT)
Date:   Tue, 12 Jul 2022 15:40:24 +0100
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/112] 5.18.11-rc1 review
Message-ID: <Ys2H2JzLD7VRtO3k@debian>
References: <20220711090549.543317027@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
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

On Mon, Jul 11, 2022 at 11:06:00AM +0200, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.18.11 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 13 Jul 2022 09:05:28 +0000.
> Anything received after that time might be too late.

Build test (gcc version 12.1.1 20220706):
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

[1]. https://openqa.qa.codethink.co.uk/tests/1492
[2]. https://openqa.qa.codethink.co.uk/tests/1499
[3]. https://openqa.qa.codethink.co.uk/tests/1501

Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

--
Regards
Sudip
