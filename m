Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB526A20E1
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 18:51:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjBXRvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 12:51:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBXRvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 12:51:09 -0500
Received: from mail-pj1-x102a.google.com (mail-pj1-x102a.google.com [IPv6:2607:f8b0:4864:20::102a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1274D12850
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 09:51:08 -0800 (PST)
Received: by mail-pj1-x102a.google.com with SMTP id y2so12965343pjg.3
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 09:51:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=G41QfMy0gPOdytQyepHXV2zo+vejMnYEhBKv7ZyIXik=;
        b=OW++KfGrEpGn8vfPq5A8i5xDwR1wegEp10vqA2beJ0n38XGSdpdZcqGu0X2rVQAwwY
         3IKYYXXZLOQEm5t0q4hhnw6F0ultTbpUgxpQ9l5HJ3ZgyM3aDsLjs7/Sxg7Ptq8iND3u
         +gQ3aaJc0gYc/o8GIj3EwijUYwxHy51GyJi64mBMnB+Uc2X/2wOxhuRtzoer6ApXVymW
         ql0VLO7ksuxxCQKCkdRpoark2JDbFogCsTNYlgubSlNcKK+6u5JMbIA99Ydtx9VfMCWZ
         POD1mEQC3mqCLnlsyYjTvidu1kw6jYWPKoPSyxOkwiYdQcj1GXNSfcBMPQWMvj9KlpaA
         Z2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=G41QfMy0gPOdytQyepHXV2zo+vejMnYEhBKv7ZyIXik=;
        b=i1Fl4Ur4f5jAPIVoCS1iwaHeL2LxNJ+me6aorkV/rs0MzbnSc3fEk0KCJOQHw1t5/h
         USDXNQPHBs+Wf6W16t4j7fonc27eEI0WdS9fs/y5L+QEwxBILBsLXu34WFoo5WRSkWQK
         cHqTjydC4EiFHhFnj05uZmmeXcDackFO1bmiJG1G4AD0fLJV4jpbfQgN6jaQWxjiH3LD
         oGVJCHSLt4zqbVz6cIHO0k3XcuhlbKzcLRdZInat36WUi3tQwHLeAj9IL4ZbSjy5DH4L
         VF2azJpIibXQ5jrH8505gLh7mIDZm8oOzYdydPa5GLuvS+KKCqr710JdcetOv1uXr4tT
         QPSg==
X-Gm-Message-State: AO0yUKW8sC8RKRlYgWplhjb/rd9JLYYTz6e6fYPL4R4FGyoGf150EM0D
        7wxKE+i3j7+G0JI76ZYOr7DLFyBCEp2rET+jcB5Ykg==
X-Google-Smtp-Source: AK7set8nd4ezLLCXVyqp2V+Mk/zCMObyIQmnH2HaXse63lHEHcKMPICs7gsTVmOJQoO1EkC22Z46WSTvGy/21ivZfVk=
X-Received: by 2002:a17:90b:3e8b:b0:237:ae7c:1595 with SMTP id
 rj11-20020a17090b3e8b00b00237ae7c1595mr270796pjb.2.1677261067487; Fri, 24 Feb
 2023 09:51:07 -0800 (PST)
MIME-Version: 1.0
References: <20230223130423.369876969@linuxfoundation.org>
In-Reply-To: <20230223130423.369876969@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Fri, 24 Feb 2023 12:50:55 -0500
Message-ID: <CA+pv=HPhxmBG37wsjeem80bAK9W9wATO4DbXx09JHHLYHSVnwA@mail.gmail.com>
Subject: Re: [PATCH 4.14 0/7] 4.14.307-rc1 review
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

On Thu, Feb 23, 2023 at 8:04 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.307 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 13:04:16 +0000.
> Anything received after that time might be too late.

4.14.307-rc1 compiled and booted on my x86_64 test system. No errors
or regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-- Slade
