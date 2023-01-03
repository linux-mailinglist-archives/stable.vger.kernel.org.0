Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BC5D65C0B4
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 14:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230431AbjACNWs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 08:22:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230052AbjACNWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 08:22:46 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAF732D3;
        Tue,  3 Jan 2023 05:22:45 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id y19so13542313plb.2;
        Tue, 03 Jan 2023 05:22:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7iVDgE/YQ2ino+0gOp3GV30JgvXSTXSZzuw+o9mRVD4=;
        b=FXWzZlBpHcgN7iKM09lzW0XReiYVSPfCIYsNB7x5Uak9wls544eP6fBlNx43RYCwbx
         CwAipIHm135XV4i2uVjpQXW5SR6Yn5ubYB9sc6gtU3CGD7RQV4AIbMdu6CAQm9hrEbdG
         YuzD1n9AtIl+GZRKluyy/WoojawXcR4TTjZ9fgZhL2n6lnMY0sCQW7OzhraBAtDNxgPV
         VAE2OKgSLDPlVqgMDGq3+uyXcKg+b73Jxnzw8IrGrgabn0o/Th9sF55qQvg1MKHib0oh
         TQNdRzFPnHjvX28jsEiYiyDs2ZoRjXlTl8T0gCdZH7J0ru6KXQMzQmOexpG69tC0RYMq
         JJrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7iVDgE/YQ2ino+0gOp3GV30JgvXSTXSZzuw+o9mRVD4=;
        b=UHn0fIU5eSQj/4C3sqt4nk7Sq3vGLQwQs8mt3CmzkSbrJQE7k0JbM6GhGQP7o5aoJR
         Mtr3UNWKlkU4X2CRpNI1RhKnCM/pxuTn//Fp6wO7kDfmv0UV01nPkO6Iopczd1+VINwo
         nVHCk6VSUxjaECOcQV3uqN6q8yspLry1G+ojunB0e318Zu6YofcDBkhSCENS832VRYwi
         z3h8j39WvquN1fw1L4DmHPuahg60o9UvNzW0Pu0kBxWg/DWKYXUAAbCf0JbVWTJTfEUf
         BsZKUG0x1w2nO8+1oMFQC2MlRzBKTUSuZZsDh2qfMCLCINBlzNSyvO0L5ffc0q45HMJ3
         TcVg==
X-Gm-Message-State: AFqh2kqGGSIV0Q47hT/SFggE+eXNF0exsOBMsWhKTw2l6FqYOI9xlTXP
        7nTklfDOmg4/dq1PGGeKAeDEsv+7q7fp6qiqeRU=
X-Google-Smtp-Source: AMrXdXtLeKUZvtssltrdLCeVhKdmnsHT2zudStN2bzq1aKk1Cfo6VvhNMELg+SbgKY4XpwwNzgGA7alOtJFFDpXERks=
X-Received: by 2002:a17:902:ef95:b0:192:97d1:a4d8 with SMTP id
 iz21-20020a170902ef9500b0019297d1a4d8mr1505180plb.74.1672752165460; Tue, 03
 Jan 2023 05:22:45 -0800 (PST)
MIME-Version: 1.0
References: <20230102110551.509937186@linuxfoundation.org>
In-Reply-To: <20230102110551.509937186@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 3 Jan 2023 05:22:34 -0800
Message-ID: <CAJq+SaD_H7ZmYxokc2AuOkPwfteUqovn_hYdYQPvp8BEFZsCAA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/71] 6.1.3-rc1 review
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

> This is the start of the stable review cycle for the 6.1.3 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
