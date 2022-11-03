Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 40D8D617C68
	for <lists+stable@lfdr.de>; Thu,  3 Nov 2022 13:20:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230005AbiKCMU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Nov 2022 08:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230460AbiKCMU1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Nov 2022 08:20:27 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCD381084;
        Thu,  3 Nov 2022 05:20:26 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id l14so2520048wrw.2;
        Thu, 03 Nov 2022 05:20:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=mw4/Yfvrzn2p7M0QFJNU9GmrUVeholUQiOtl00+DcHU=;
        b=DhKquTefpxZY3+yipjtQ1egrvF2ZYXjn2VQXNUVx4SmushbHOBXmli8ZgG9Nz/+jtr
         4Cvs1J+sVFgzt7j/9ti17tMqzdBou/v3NylqQ0sr3CwQpTQgJbGoMVxqRGmpYx1BbvA8
         XwRZ20b0HqmSy3I0p2Uqcx3aXooLzHGZWVyj7dIsyv+BrcyD0wXBTcclHscZw+Dvxwi4
         gpcxcRcXzA2rbYyniECLPbyfUvWjYpp7O/zE9jgAFAe4dc8NJluKaJwMH966pAAkW++B
         Hc8HgZw6fpMi9pgZuXNGDkXJpDP9z8fc5LyGqwwITcGfrXQEDwehM8j0nn5mNsBpViwh
         ikfQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mw4/Yfvrzn2p7M0QFJNU9GmrUVeholUQiOtl00+DcHU=;
        b=PnVmQo6nyR/cd7Cd01499TEHgUqDssPpEqvNycJsmxSB4Av2gAIVnQNafI0yyGBG9Y
         qkzOBiWubesl2PwO9ok/cV+9QXfssOKMfsGw9uAWaJ5iiWwQpNYGHdijHiX9VOvV7oXA
         WG/tfRyc+w9C3kq1iJQO0Lfq+5UHqWSwhNn1F/l63cyeG/Ei7jzgcjW1axE98/JC4ei3
         XhU3obQiXk7qqzHiHrbjC2JRlVZdfeO00k9yLM12+2qZD7cqTW6dQoKhInbuuLFf5yhf
         uLJ4t73sgHLCr6aMTdJpd9+wdSrETw2NhBSUGEwyAmmokMWP2400K23cSrT6CsV36Mw7
         UPJA==
X-Gm-Message-State: ACrzQf17JMrIEi018dflEQc7of50OPU30xrJutaYFPO4Jbj9+8AuOMKs
        0UvtLRG0B4ufY2OWaa61d+o=
X-Google-Smtp-Source: AMsMyM7Ga5AcXFy9woPmxBiXYGjqxPJhkR+yThQ3lHxs6eqnpvgQFVxfUm3r0tbxywFQ4nRj1/kl9w==
X-Received: by 2002:adf:e3cc:0:b0:235:95b1:2124 with SMTP id k12-20020adfe3cc000000b0023595b12124mr18912757wrm.693.1667478025320;
        Thu, 03 Nov 2022 05:20:25 -0700 (PDT)
Received: from debian (host-78-150-37-98.as13285.net. [78.150.37.98])
        by smtp.gmail.com with ESMTPSA id d19-20020adfa353000000b002366553eca7sm697825wrb.83.2022.11.03.05.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Nov 2022 05:20:25 -0700 (PDT)
Date:   Thu, 3 Nov 2022 12:20:23 +0000
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com, srw@sladewatkins.net
Subject: Re: [PATCH 5.10 00/91] 5.10.153-rc1 review
Message-ID: <Y2OyB5m9padrnGr7@debian>
References: <20221102022055.039689234@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
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

On Wed, Nov 02, 2022 at 03:32:43AM +0100, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.153 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.

Build test (gcc version 11.3.1 20221016):
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

[1]. https://openqa.qa.codethink.co.uk/tests/2091
[2]. https://openqa.qa.codethink.co.uk/tests/2094


Tested-by: Sudip Mukherjee <sudip.mukherjee@codethink.co.uk>

-- 
Regards
Sudip
