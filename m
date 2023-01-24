Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6A7267A264
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 20:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230464AbjAXTIA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 14:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233135AbjAXTH6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 14:07:58 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 379A44A1E8;
        Tue, 24 Jan 2023 11:07:25 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id i1so11897376pfk.3;
        Tue, 24 Jan 2023 11:07:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+/a3DRuX86fFzYSKcRnyqY4BjHdMD3vD0y6fP26UHyc=;
        b=BMcXRguM7BT1nuXNEPIe0VYSadw9apPpMkeXepdjn7PIThqA83olJrRlbmtb8FkZNN
         bqgIykvbBi09dkvLONVtvPErD1YsHZDxy6PXtholnSTwB9YPsu+1hwqhfLqCaIRXIWCU
         P5o1tUU39OUs4Q6jfg+zjFyrHoV64l8s4SBGdFlE9Fms15U1yz4w7uC+L+QP2BnxIgV9
         OX+lFvh91H16bD9Ws4/0Hxwpt7XzNnFHOaU6PK1g9zeRuS2CWLDC3ZhwPgRf5V/2y5Yt
         yqUYtH7LGJsdXeqhKs95HNyX7qOzT6w8O9Gp34npuHukAZs+n5q5CdD+1nuaHviHdXJM
         jUlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+/a3DRuX86fFzYSKcRnyqY4BjHdMD3vD0y6fP26UHyc=;
        b=YABLHnR1+6QR3ke8Lvf1HHj1NXTPCuApzRYxy3tcZFLJJyNlAOo6SuiGvLt+bBTBRE
         7sgTRZn1u524br8OGstSrMSjqR+fkCyU48JXVOewcVUft7erF2r3sBSvByVpYy42rxcW
         3JokUly8u1dM+XWNmS2bk+Be35HuHc9EAU7rNGMq8Mlg5r304xJ5EeHMPQx6VoxVMH80
         iaa9Hu7jdPzE5IDj/7a+mMeTAJf5o8d6whj8b2E2NmlhTLBdiHRDN75dHqdT7xdrTPGH
         FUu0yXJSpHDs6ZoJMZEtI49n/oD4JG1h57PsGkV4dnfxVPS45/RWQ8HcKxmxH11xM9F0
         Vd9A==
X-Gm-Message-State: AFqh2kooE1m5hv+IJMVPkApeGQVpvLpEz4QAYFSapja/wgofIQA1Spqo
        MuNETznJFhH+JkjZtEPJZwwgtEelPahDihlNbs8=
X-Google-Smtp-Source: AMrXdXvgbRX66Y7F1/fxwnvThj+LWkQ/sM7WOaEK69le38ZLrKLu+I8+beokSOiwuqs72oLzPCauJwM49GM5lapGco0=
X-Received: by 2002:aa7:9f06:0:b0:577:16ac:8447 with SMTP id
 g6-20020aa79f06000000b0057716ac8447mr3070187pfr.56.1674587244698; Tue, 24 Jan
 2023 11:07:24 -0800 (PST)
MIME-Version: 1.0
References: <20230123094918.977276664@linuxfoundation.org>
In-Reply-To: <20230123094918.977276664@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 24 Jan 2023 11:07:13 -0800
Message-ID: <CAJq+SaB1rcEJafKybZNRn3Fp4EYuYVC4FOYV6vqzAmqPqJbnkw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/117] 5.15.90-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> This is the start of the stable review cycle for the 5.15.90 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.90-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
