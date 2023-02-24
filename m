Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CB086A2205
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 20:04:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229630AbjBXTEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 14:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjBXTEo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 14:04:44 -0500
Received: from mail-pl1-x636.google.com (mail-pl1-x636.google.com [IPv6:2607:f8b0:4864:20::636])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD151B2F5;
        Fri, 24 Feb 2023 11:04:42 -0800 (PST)
Received: by mail-pl1-x636.google.com with SMTP id ky4so495822plb.3;
        Fri, 24 Feb 2023 11:04:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=/QMQOnCmMUtMo8h5zie42yxlNpj/X2TsJVs5Y9H49Y8=;
        b=NAQWYLUZrCqL6SDknIVS56N9wu3Ca9ML+Fz5DncJ8Cjeer6C1AI9lSgpWJyVDudYdD
         +o4WRlH0iO6elISadNe1q1VdHOmVHPw5zhB362PaVSfryaLN5fRlmz9pRSVFSTLzy+lS
         dLEBNKMFnBBBxeENmbTPY+jnExglJsQ/v5/lWTLLQTAPIqlQm6MWB0fEfZIbZvNikQRk
         w+VRqN0lSGo3J46fi1PBXPB548obZtvgatULX9F57XtKnxc3dumEWDcA1gnvjl50Gsvg
         M5GL2KY4rX3k8zA6a4MddJdzqYicjfk0jAx1Zsc5DWaPFD4sfu4Pb1Fvbm4mlRtvJTkV
         AeyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/QMQOnCmMUtMo8h5zie42yxlNpj/X2TsJVs5Y9H49Y8=;
        b=jlwLDiyFGLc79jQ5SLf4hRsIQXLQxt/u5c5QvJdZXBhV7Tcd5Bxp9DTHEkTaMVM6+h
         iCXtw2j+MGF23KSDTfzZjTOI5bropwhsiOP2YWnFcDoSvoBbVD7L/oYgiA47ixRT4TZX
         YxK82pbozrL8MugnOfCc91KR9dke8j6tTnWzptjnQ5x41RYwQBPa6ECmfTDXDl4vq5PQ
         VK9E77f4gHLItZ3CMxjFoxulj2L0mNHtyKeYjCSnumYrPZ3Qsvf6+ULpxT7EZ51Wy89m
         /Wlg3iIQbOMz3i4elnHRYsnIOW4KNc4Py06zcJMHHvnOk0/oqQnczvjEjYCdw+F8xau2
         B2oQ==
X-Gm-Message-State: AO0yUKWoetRU5TFym+D1bdrF5oviRHyZ/zp3Ob8K1AdP47Y+KbN8KdSk
        ZUdS20geA+/gOvLXScFvlLrxKGII2+diS/nf/Lo=
X-Google-Smtp-Source: AK7set9jAvUbiEqDsthOhEMH3ysvnzTdpIDq0VzNx6GUYNiR6tWA2k464mhSqXvD1AJymY/p2iookEYxY7j7mMpN9YU=
X-Received: by 2002:a17:90b:a49:b0:234:258f:e2a8 with SMTP id
 gw9-20020a17090b0a4900b00234258fe2a8mr2114725pjb.6.1677265482407; Fri, 24 Feb
 2023 11:04:42 -0800 (PST)
MIME-Version: 1.0
References: <20230224102235.663354088@linuxfoundation.org>
In-Reply-To: <20230224102235.663354088@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Fri, 24 Feb 2023 11:04:31 -0800
Message-ID: <CAJq+SaCiFAwgN57chu0o9ut65MdgCSLN6PJ-VKTq7S-oefcY4w@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc3 review
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

> This is the start of the stable review cycle for the 5.15.96 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 26 Feb 2023 10:22:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.96-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
