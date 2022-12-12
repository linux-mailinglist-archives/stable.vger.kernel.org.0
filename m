Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF1764A8AD
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 21:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbiLLUWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 15:22:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233586AbiLLUWG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 15:22:06 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C011210FE6
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 12:22:04 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id 4so7321407plj.3
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 12:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uvYrIVeVNpM030K546j+nbRNvrv3/oDjBsrNjhndems=;
        b=F3gbA2hsFQB768KZc2z1w0vQpRjsUaRMhxS7wEJab6ha6UTzWL3dsTL9Q2tFyOiKwe
         xBJVe1KzfJuTn6AfQhD/gFqjPFusopeUv+Dddeh3N9z3BNEGUskIs+Y8C1s3FqSoXyIA
         DTPtRA6htZohXuhTMW+vQM9VcL5CtXZCeaauyDfxwL0C2jNGZxuAFkbbmcp7gn+keGHd
         Mkm2a1hzJhAvPc0XtwMERO3mW1RK14ZRjmVX9XDeFlCf+JbNAxspUZh+c5bZKILMSOn9
         9m66RqnakYRWwD6lIrAXWCrockQjBNvCHmoONJlcJT/7xIBNY+qQgwiXeiyUlexs9MkC
         TBfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uvYrIVeVNpM030K546j+nbRNvrv3/oDjBsrNjhndems=;
        b=zV9NrKBM19jIrxUmcjcM/vy4Khf1qShaLz9WL02NsSfJPoCzMznDB2/GpuuRVY5p2T
         Ib2Ca4InX1pmKfcWRi3rNWBcD8r/NWBdrlc6LtRIAyimODXeULq9t4IRW/LdAkVANyqp
         WRdiJSEnUQ3UyTlvtYDZZ5nwtnASxcaspBf5if6xWjLeIJkS7P0PSQnXAMwSZ5nMQyJV
         MNZmT3dskzbSJwXSCjODBYEejV7ajJyVtPl45PRRVpx9fdyA2hO5EWdv+zYF5RjX+cad
         VrIlC84j5aGODZq0QoBUAlJ+FOUJrwUzgeR9FBAnDrB8gJZku0mKsqAYTkTbtTDKcoFX
         HxYA==
X-Gm-Message-State: ANoB5pniDNU2Wr7l9gAZpITh4aJx+h+7g1QQPn5hkgb7m98UdIN+FGks
        WcTC2EQAEaWXgXghFdV7M8kYb6z9v8Qckh0aIzqH9w==
X-Google-Smtp-Source: AA0mqf5mkuYpxcDVcjWkwYHSIH5Ctk6uaDTb6OpUNz5t+yVD+2RSn4iSvbSZQaBkwJymSCNUknN5zCTTnPT91RbXg08=
X-Received: by 2002:a17:90a:740f:b0:218:fb5c:a762 with SMTP id
 a15-20020a17090a740f00b00218fb5ca762mr32141pjg.241.1670876524292; Mon, 12 Dec
 2022 12:22:04 -0800 (PST)
MIME-Version: 1.0
References: <20221212130912.069170932@linuxfoundation.org>
In-Reply-To: <20221212130912.069170932@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Mon, 12 Dec 2022 15:21:53 -0500
Message-ID: <CA+pv=HPEcrt9Ju7xYyQtJ_2AX7-aeZ46+4voN9_Xs4iTJgk17g@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/38] 4.14.302-rc1 review
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

On Mon, Dec 12, 2022 at 8:53 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.302 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.

4.14.302-rc1 compiled and booted on x86_64 test systems, no errors or
regressions.

Yours,
-- Slade
