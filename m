Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7F0E26A15A1
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 04:47:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229672AbjBXDrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Feb 2023 22:47:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbjBXDrX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Feb 2023 22:47:23 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17BAD1516F
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 19:47:22 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id p5so6776289pgh.11
        for <stable@vger.kernel.org>; Thu, 23 Feb 2023 19:47:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gfsHFDoztEyExDTE48mR9wprB/0JEP2Okh27zvb0V6E=;
        b=OlUtEtHxCIaQ4JZceCw9Lsdoek6syFHGo3vXbYfI1iZrP4vhDJhbeOjnVwCbL33acw
         wahhYKacgQhZoB26GRDJ4dAAyc6ZbQe6T7NdG6xMNISv0Xw8vHBHVAHBKTrVwwx4pAtp
         sBG8nqTLvjaRSwnBacb2zyZjw9uS5EdRqIXePlU87truWlTNs0vFwImkkSnuD4+c7YcR
         1gg6gSOWqTAphbQmgmVKAB1Iv8XC6vX4HErEREdxbxme9xx0f59hs7rodni3lCSqK4nW
         /6aUFmOhaVZ/7agcl0WNGo569atl1XIApd6O+yOXHj4PpmYWaLf8N86C35sufH4Mhlnp
         vuLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gfsHFDoztEyExDTE48mR9wprB/0JEP2Okh27zvb0V6E=;
        b=fHOQF+J921rIVcCynNFwh1c21QUwqKRnEwCvbBVl6z8CKq4sp/x2gT+RQBcoPuQJwm
         QnXaq/ZqavFi3qRBh1l51eFLrdsTjHoU6qrNmMIP5AN7oS9sctYDUZxK2yQOF9iZsGRw
         R9PviU9Rr0DjSfSIfw2+ZgYycgDztI4r0hktbl4lk6QcXvAY0p9DqeSN7ovsmXwZCYKx
         WUxh4f43Qo5GNBM6XbrFjW22ECb5Q5NpDkPJ725NrSss8hvJ74C3BCUgpInsY0BiRhII
         08c5tula24IcPb2a7osD1mIRA940I7iBzYxSw8g5LIvYZtBv2LA7F9rgmPK1i0X16Evj
         r7CA==
X-Gm-Message-State: AO0yUKWLt6oMwYhXZxqM7eqEB7s665Y5Db/o9ZF1mE77GrprxlKytANi
        ncu85Ub2n+jJmVEaQPET3vr/QVvBQfMtd2/viXCxCg==
X-Google-Smtp-Source: AK7set+00AVk9Ivh33Fzuydqi8cRJP76bKdTzhvJyh1xGFOyYTm1XhcTBF50FrrM0C1yyUj278zWkrxNIzR+Mdr7VV8=
X-Received: by 2002:a63:8c18:0:b0:502:f46f:c7c6 with SMTP id
 m24-20020a638c18000000b00502f46fc7c6mr1088379pgd.1.1677210441417; Thu, 23 Feb
 2023 19:47:21 -0800 (PST)
MIME-Version: 1.0
References: <20230223141539.591151658@linuxfoundation.org>
In-Reply-To: <20230223141539.591151658@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Thu, 23 Feb 2023 22:47:10 -0500
Message-ID: <CA+pv=HP81iuw4RNUMrrK0UH7jtcq40GunHseKFRH7h0U=ePYBw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/19] 5.4.233-rc2 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 23, 2023 at 9:16 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.233 release.
> There are 19 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.

5.4.233-rc2 compiled and booted on my x86_64 test system. No errors
or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-- Slade
