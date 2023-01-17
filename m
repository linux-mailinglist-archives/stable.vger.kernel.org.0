Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DD3966DD87
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 13:27:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236019AbjAQM1S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 07:27:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235245AbjAQM1R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 07:27:17 -0500
Received: from mail-wm1-x32d.google.com (mail-wm1-x32d.google.com [IPv6:2a00:1450:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DF6635247;
        Tue, 17 Jan 2023 04:27:15 -0800 (PST)
Received: by mail-wm1-x32d.google.com with SMTP id g10so22095419wmo.1;
        Tue, 17 Jan 2023 04:27:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=FU6WkRe9hFxrq6Tsp3Ga9E9BKQlPB/TCyToG9zfxCJ0=;
        b=b4kpqDx2WsKMvlHqzDeSu6ChAc0tfgEWDAp437Bh67E7HOkGw0ynbhjkuEs0vxKYrD
         yGKWmmQVeC+n/6ueSyCe/Fkt+SLkQn1kAVC4iYbp4RnEquilY9dVJQTyaBwYE+q88esN
         +DrRK0FZmodXetCtOeJCkWOJYyIa/imjIbrl8TY+l8B5ALvDxd+/MaJwfvgDYrkCUokU
         fSGZW1I/98mwRiPCVycsDA7PRn0ILxdzFjx+N0sUr1xX5eh90Dfj7D/cmZ9dVT1HMEZY
         3aFSvp72Xk/8YWBarU6soeVESKC15lSCq9zjaPVcQ5riVxcrsCusc7hewPwlw8vj9U8Q
         uriQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FU6WkRe9hFxrq6Tsp3Ga9E9BKQlPB/TCyToG9zfxCJ0=;
        b=nb4XMMqKkKJroJGf2iNVD6vOqPpZhm093zSzPHOMy7NS085K/Kn8MiJATz4FFLi9Lt
         6dBnGFx9DxgRd/8bG6yCiRJ2SrzHzywtoZOT4iVpuOE308ZOBAnQC06ZF/ZCGBGWIxHh
         supiXcbvTijH+1e5SAk5bCVlv1+X6xVwsydiwYzeNYMjWPs27AnrAu9sb16emf5f2FaM
         Dib1rY+PbhSRbAZwlvgYSXi6XbyiCP2eg+eD4G6r7BT7w+uOSoOBExgfTS5T4get0q5F
         89/Ct7sjETVQE+DXugBuFGz9j+a2D4FDtBhb2F6q3s9YYlcFC1ddbq+sg7eMQArGAvc7
         fwpw==
X-Gm-Message-State: AFqh2kodDtOBj1bzXeN9EU05N4drUbcPOY3KiP/xzOjdy11KDMF8geS2
        I6vVp3lUJKNCEEhkk8hxNEg+vYZhgjE=
X-Google-Smtp-Source: AMrXdXujlnw4ci9b9SeAJHZulwAMVjpFlu82KQ4ygtwCl3APlFIiWWhyC32b+ajc0TPIt9ptRZzFaw==
X-Received: by 2002:a7b:cb88:0:b0:3d9:f801:73bf with SMTP id m8-20020a7bcb88000000b003d9f80173bfmr3001591wmi.12.1673958433866;
        Tue, 17 Jan 2023 04:27:13 -0800 (PST)
Received: from debian ([67.208.52.125])
        by smtp.gmail.com with ESMTPSA id k30-20020a05600c1c9e00b003d9b89a39b2sm40832747wms.10.2023.01.17.04.27.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Jan 2023 04:27:13 -0800 (PST)
Date:   Tue, 17 Jan 2023 12:27:06 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net,
        rwarsow@gmx.de
Subject: Re: [PATCH 4.19 000/521] 4.19.270-rc1 review
Message-ID: <Y8aUGsZWCLGSp4iN@debian>
References: <20230116154847.246743274@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
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

On Mon, Jan 16, 2023 at 04:44:22PM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.270 release.
> There are 521 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221127):
mips: 63 configs -> no  failure
arm: 115 configs -> no failure
arm64: 2 configs -> no failure
x86_64: 4 configs -> no failure
alpha allmodconfig -> no failure
powerpc allmodconfig -> no failure
riscv allmodconfig -> fails
s390 allmodconfig -> no failure
xtensa allmodconfig -> no failure

Note:
riscv build fails with the error:
arch/riscv/kernel/stacktrace.c: In function 'walk_stackframe':
arch/riscv/kernel/stacktrace.c:66:36: error: 'struct pt_regs' has no member named 'epc'; did you mean 'sepc'?
   66 |                 if (regs && (regs->epc == pc) && (frame->fp & 0x7)) {
      |                                    ^~~


Boot test:
x86_64: Booted on my test laptop. No regression.
x86_64: Booted on qemu. No regression. [1]

[1]. https://openqa.qa.codethink.co.uk/tests/2659


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
