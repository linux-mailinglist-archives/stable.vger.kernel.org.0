Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1FB4366DEA4
	for <lists+stable@lfdr.de>; Tue, 17 Jan 2023 14:19:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235653AbjAQNTw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Jan 2023 08:19:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236789AbjAQNTv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 17 Jan 2023 08:19:51 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60E0839B8E;
        Tue, 17 Jan 2023 05:19:47 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id s67so21925571pgs.3;
        Tue, 17 Jan 2023 05:19:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=U+mHMoqOxjmqlEKrrvnWJRDjZ0/NgeDWv0+LnS3FTis=;
        b=HDNHDgJaLjQvC4ODh63qdBSKzGq8Ri77vm3rywY8ZkY39iyX+tsnS/bQloA5fydjJA
         Gr8D/UE39tbGqpj4brtX91M2fYNY3NjPiYuwFEMwxSC6trAJmW5H8yfAQo6fWbUbwL+I
         G4mWWoF3R0XRiSypyGAjJNkNeYwXgYWJ3X23P0l+LRkqKyy0cW68g8kd+t5wDfbnZ9ip
         +5CPG9NL+dq6Rbgrzhf3dVNZccLmsdmfyfRKmGszQIcb2O3jiWCQWwD/JTjLEefApiBh
         xKTIOiBKegbSIXkaYeXmc/gZDbdX+UNPNgqkNj/BWf9MfpSvcQVqI7v4CCtgA/pIBNgc
         Ts3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U+mHMoqOxjmqlEKrrvnWJRDjZ0/NgeDWv0+LnS3FTis=;
        b=FM729lY0TD/3j5Ok4aP2WhJvn3zabeBsBj42g1Xdc6DxhSHK07JoszVyVBq87zCyh7
         h3wGh6Fvahm/nDpUH333Ao6Gr5MArt3MZFwXrAOSR95XoYHlTaG6yBRnqFV59iY3CgWt
         I/c1PUVgOARID5s+vIZG/VAfv36ij/Fcq1SzcR9rHPFz6cgLauxkv7GzgHU/UGajg+Uz
         4+BfBp1Wmx7vu6Fezz+5ZxfKaJVMWr6630hPars6e343pLaT3iRNV+zT00McT2/4Nx9I
         Q+U5NloA+zvFSHvKkA20mZ8/+1VH0PWYHFsWN/XtPkYXgLGQrs6lm7EFQ0b0kAZqULg1
         ha/A==
X-Gm-Message-State: AFqh2konDmNvE78+I4EFCLbB+yP452n/ABTjSK9aZw3uq+G5v8PmUbhU
        HHw1MeERKr92OZUcEkMImC525wHsjFhxXPjxt9c=
X-Google-Smtp-Source: AMrXdXtJ+wI0o3LZ3iVb7QJNPU+v5VCjfsfJIvOOAXonGRm2rTJbG86U9Yk5+BouX0OFe4amGOJTBmIsmbTHH3RBW5o=
X-Received: by 2002:a62:e40a:0:b0:580:8b92:ecff with SMTP id
 r10-20020a62e40a000000b005808b92ecffmr302635pfh.4.1673961586875; Tue, 17 Jan
 2023 05:19:46 -0800 (PST)
MIME-Version: 1.0
References: <20230116154747.036911298@linuxfoundation.org>
In-Reply-To: <20230116154747.036911298@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 17 Jan 2023 05:19:35 -0800
Message-ID: <CAJq+SaC9Vrp5R0Mt78tBCDiT30tW1o6KyFvYooosq_Wt18-fqQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/86] 5.15.89-rc1 review
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

> This is the start of the stable review cycle for the 5.15.89 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.89-rc1.gz
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
