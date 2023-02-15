Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C0B5697977
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 11:03:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbjBOKDZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 05:03:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234163AbjBOKCq (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 05:02:46 -0500
Received: from mail-wr1-x434.google.com (mail-wr1-x434.google.com [IPv6:2a00:1450:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE56936FFA;
        Wed, 15 Feb 2023 02:01:37 -0800 (PST)
Received: by mail-wr1-x434.google.com with SMTP id r2so18466830wrv.7;
        Wed, 15 Feb 2023 02:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=0O5OE1pYPf4Bdxg8Thv2IJmSFslR0r4iXq6hhQFPsQo=;
        b=KzdJLQ9yPDlXF96+31EwfJ15d7GWeppPU2bcWbiye8OU1ANGa/s5JxHn+oYTd3j/Yd
         9gmPURkg0vkYa83IjBoBKQBZnPWguVscDRUj1vOpqktIzY78UPqTTi+pZnPCR85uxjoK
         Bh9rlMg/lzyMCy41s/85kS3a37kFDH6eaE5xvOCwMH+CO0gA/fy0ZptoeUi7LyjIaldZ
         fMERgJYu/7xMUCVwQo0cwDD6qK9atVSdWvruNj7rlW2w99oPt8KGZjbyng5Hpkq2fkpO
         BX3Ldx71gk1axXGm36btQcFoDQGuWhcx6yu0OA7xNUZbJ9XzS7y8ysZSAWgXAaD0P2zg
         94lQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0O5OE1pYPf4Bdxg8Thv2IJmSFslR0r4iXq6hhQFPsQo=;
        b=TEx56V6P2eBs3tYHzvUSEYOFBVRgehplZdKhGu/vBRLOw/pDoushXSzfezxh08RolY
         Ji8l183U3BkJRF0vStX/kQY9bJlTCVwYtCiLIt6RJzP1gPUGts0z3ct6Rz4XCG7LG++O
         RvEJkrEGXaXKpNdyW0VeElSd1bTcPg3mo4QZ4mP3goeMWSCBro9u9O8vc/sO0xb/nUnh
         Ja4287d4eyLvNBVn+IuOlT1yV+b3mXz7bppccNx+oNFtVzLGbe8aN6OfB9AMpufnC13p
         +HhvYEWIHJntRLToCWistx75DaQ/RWAdT+LiwugOWEHOoR4GxD6VZK2m7ArfY9BupFfZ
         eRjQ==
X-Gm-Message-State: AO0yUKVjnA9yhTfhU2VtCcW5LHVKjxYQ36LNILvBD0Yux2kEIiUa878H
        s2f1KVH8mhybFvseGCjuR2x5b6rJsCs=
X-Google-Smtp-Source: AK7set/syKP1KgtfZs0bsclPc0Y/kqWZICD77fWgN6l+GOibI6M9i43aofOjR0wF6puzx4glJuFFUw==
X-Received: by 2002:adf:fc10:0:b0:2c5:465d:c1ab with SMTP id i16-20020adffc10000000b002c5465dc1abmr971373wrr.51.1676455292352;
        Wed, 15 Feb 2023 02:01:32 -0800 (PST)
Received: from debian ([167.98.27.226])
        by smtp.gmail.com with ESMTPSA id h12-20020adff4cc000000b002be505ab59asm15344981wrp.97.2023.02.15.02.01.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 15 Feb 2023 02:01:32 -0800 (PST)
Date:   Wed, 15 Feb 2023 10:01:30 +0000
From:   "Sudip Mukherjee (Codethink)" <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 5.10 000/134] 5.10.168-rc2 review
Message-ID: <Y+ytehE6Kv5moEou@debian>
References: <20230214172549.450713187@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230214172549.450713187@linuxfoundation.org>
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

On Tue, Feb 14, 2023 at 06:41:06PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.168 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 16 Feb 2023 17:25:19 +0000.
> Anything received after that time might be too late.

My builds have tested f90240a238a9 v5.10.168-rc3 but I am not seeing
any mail for that, bit confused now.

The result is for v5.10.168-rc3.

Build test (gcc version 11.3.1 20230210):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2868
[2]. https://openqa.qa.codethink.co.uk/tests/2869


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
