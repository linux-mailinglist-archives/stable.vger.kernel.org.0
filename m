Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFC956A2201
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 20:03:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbjBXTDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 14:03:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBXTDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 14:03:45 -0500
Received: from mail-pl1-x631.google.com (mail-pl1-x631.google.com [IPv6:2607:f8b0:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 506541B2FD;
        Fri, 24 Feb 2023 11:03:41 -0800 (PST)
Received: by mail-pl1-x631.google.com with SMTP id q11so480076plx.5;
        Fri, 24 Feb 2023 11:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w047R3oLOZSFdNh2VFLQBp3EdizSwQ12bg2tndBPkow=;
        b=JIKmvRfQ5uC5/dwlBMFCV67buClKNBWww/Q3KlY87dfsl0+rMiwPwEiMEj3PYyp292
         HSDpF9njfZLGMxTO5WtfQVfiE6NwdjQM05ZaJq/teikwRpIxr7IFH73b+BVP+ZkgF05n
         CxamMeNmJQYBaVNlPqfc3eyfezBtErzEtSpN4MlEYGWUkD6V4aHZYq84L3KeuUCDIxEt
         YTpcSe4z48jWsxsqjrSZ99KCxU6MvW36xbinZ1gIxJALeLNJsykhIJcPek/oN6Lk7AaP
         qsTNmQkYdoo/cf1+Wny80kKlx7wDAnpvC8OPsgGCNmIQ2NQbUwpkCzTc6Iw8d+GcVxZo
         zZoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w047R3oLOZSFdNh2VFLQBp3EdizSwQ12bg2tndBPkow=;
        b=4OWs0HJkh/gCufD6FxWtmAUPe8T2gxlhVstl7mFIiLLACnymhYHovffD3lVX9XxCNS
         WwYY6ovtPt6LnQ5Wlm7V0nEtKfA6KLO8sKsIZV2kon2tqvfGUGuanL2nFGuOpCxS/j97
         wIBIp9nVG5WeNif3iwa2633QJTiorXZBx1wo9tRJIcdtZ1ehS0hvW1MBn5BBRDg2V8CX
         1TaWoV3B0O0UzOvO+jtdvhKpKbXNf9+vnYLABnAovLYLHVz74SspSz3dyQ80lDH5BHUN
         XA82g1mn1sh+SBBvtAcQ4/Ut4o7MVTw4fUaLcMPOIOrmgOPVHnFLgWWOn2r2OZOQW01O
         GNhg==
X-Gm-Message-State: AO0yUKW/Mh5m+w9k+mFjYZ0eH3nHrQL2yy544mSaoht2X98CavaAj28r
        HI7hO0YammU8FpBYwAjcxcp2x4QlmBcL4dIyiLY=
X-Google-Smtp-Source: AK7set+2Q/QjdEZpZO84t6SELi10/Mel41wZ7/+hTLw6k3DUAJh5RUWWTHX3asiwnQnFdxQQh4XBiwHOSHf7hv7LNZo=
X-Received: by 2002:a17:903:26c2:b0:19a:fdca:e3f1 with SMTP id
 jg2-20020a17090326c200b0019afdcae3f1mr3376648plb.3.1677265420822; Fri, 24 Feb
 2023 11:03:40 -0800 (PST)
MIME-Version: 1.0
References: <20230220133600.368809650@linuxfoundation.org>
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Fri, 24 Feb 2023 11:03:29 -0800
Message-ID: <CAJq+SaCQynXLnL50ZFq0PdgjY+kCB+puqTbWs5=dyLKp2Xfh4Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/118] 6.1.13-rc1 review
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

> This is the start of the stable review cycle for the 6.1.13 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.13-rc1.gz
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
