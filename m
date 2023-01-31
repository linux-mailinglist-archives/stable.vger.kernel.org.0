Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0688968335F
	for <lists+stable@lfdr.de>; Tue, 31 Jan 2023 18:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjAaRKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Jan 2023 12:10:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjAaRKR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 31 Jan 2023 12:10:17 -0500
Received: from mail-pf1-x433.google.com (mail-pf1-x433.google.com [IPv6:2607:f8b0:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0F21196;
        Tue, 31 Jan 2023 09:10:16 -0800 (PST)
Received: by mail-pf1-x433.google.com with SMTP id u5so10365868pfm.10;
        Tue, 31 Jan 2023 09:10:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2YsoUtxMdDPQ8yDUi29M+HZJqOyAdBFa0EqB6bM6pNk=;
        b=VjV6kl1sLRaQzDBF+fH0BO/N1BNv7OXBoZjC5MEakqVRd+TIIlQY5Yt8azEy38PMuy
         /0IGbMqVNmfoGxwpzMavJnkdizKYi0lA4Gn543bRbJErtN+Lao4N3RB89hCWbrqMQ9hD
         PMQ9q69Bmjk/3lumPpmE8gmWryKeD/Pk21xyta1bN4RCrYKFbrHBFsnav10O1yfc/TIO
         D54JaLV8+fFT+6NVXnGpNibih0xld/LAYnySQXvz5cUrWo4vsouCovAlmv/VFaWU6xIR
         z6CJQJf0+s96c4XGGdLA8lVFpdJaM2sENbfLDgXVik9s7oPD0ZvRjFWkSZ5GatpHkS6t
         uzcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2YsoUtxMdDPQ8yDUi29M+HZJqOyAdBFa0EqB6bM6pNk=;
        b=5oSo1Tc/uEJLN+84uQNVaUKVursOsAYvgs6+n41lQ55x3FQHHMJrWd3QBH+mlBQpED
         jKbfEI19lKJAsYLpYPx2yoKvVeZE9KrmrnM4ORwSrJFMpxr0jFIjep9PSCMHaeYxkqoh
         EyDDRNj8L87GrCjk1w1eztVbQPwS+7fPFb338BDN6KcgXlpXZHS0rTe3mOQ3G9xN/yNA
         QSSOJFvkxSaCMP9HEDDTBaN3vxH+xQlT6Q+nIJAZf2QIo2NXpZRvS8XI8/y8KN/x/MzZ
         ebcOQFo0XWGPP29nR0jrvLdhCYwfz3vGXp64yLMOHm+YzPmzOlhSz9k/NfbTtd8jmz9N
         SdWA==
X-Gm-Message-State: AFqh2kq0Zj1rgp/95+27YoiODTlSOM9O8Vycs/KznwQRzHRiWpAYhK4Y
        0esu7t7X097tJJ8OLtuISFtHxUmyAVR7GE/k7xo=
X-Google-Smtp-Source: AMrXdXsp01qQCgakWsr2TSZoaxv7mAj1Q+q0neqvSSh54o2EVsGbaMY7XQ3CXBFnh+N5OEINVqThhtQh+7jGWdnD9ts=
X-Received: by 2002:aa7:91ce:0:b0:581:c732:2b60 with SMTP id
 z14-20020aa791ce000000b00581c7322b60mr6857105pfa.25.1675185016458; Tue, 31
 Jan 2023 09:10:16 -0800 (PST)
MIME-Version: 1.0
References: <20230131072621.746783417@linuxfoundation.org>
In-Reply-To: <20230131072621.746783417@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 31 Jan 2023 09:10:05 -0800
Message-ID: <CAJq+SaCGpH0dGyahEdmv2-2HxPwGU52LbSjtroqZJ2w9uMWmOw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/306] 6.1.9-rc3 review
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

> This is the start of the stable review cycle for the 6.1.9 release.
> There are 306 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Feb 2023 07:25:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.9-rc3.gz
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
