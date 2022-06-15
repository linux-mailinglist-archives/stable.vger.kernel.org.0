Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9FCE54C8D7
	for <lists+stable@lfdr.de>; Wed, 15 Jun 2022 14:46:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348905AbiFOMqE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Jun 2022 08:46:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348894AbiFOMqD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Jun 2022 08:46:03 -0400
Received: from mail-vs1-xe29.google.com (mail-vs1-xe29.google.com [IPv6:2607:f8b0:4864:20::e29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6A394617F;
        Wed, 15 Jun 2022 05:46:02 -0700 (PDT)
Received: by mail-vs1-xe29.google.com with SMTP id i186so11702217vsc.9;
        Wed, 15 Jun 2022 05:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g/6ADv8uBMw3tYXXr8BpAhjyxrjAv8DDj12L//6c3pA=;
        b=J7Xg59BQ+HbpUll8w2rPc7iWZ/9gUxP23SizgRU8i/2ZTjELwGMhh0LhXQ4WQKXNh4
         ydtAxlXuq+At3/4KaSIIknsP5fJuextlyX5np+xK0BesKhqjX1J6lDG5s6s9Gf04LS7I
         OWD5q85jhDmNuMiaIQ7Idprz20oGA5JWUJfe2RqoPgLkR+ti9DX2YOQYqj6qNO07Anle
         hhh1hiWIe7PyUGSQzo5Ku4S1iOn83OV88euWeHXb+qgkFYjr26m0JxfN9V2xK3jYjOPk
         cjvYOosDhQXlAWtUz3apb/+8V2jIHrh45Q2Z9KI+7lzyJxpFSsqOhCqhSic1ZqTqjvEV
         5c0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g/6ADv8uBMw3tYXXr8BpAhjyxrjAv8DDj12L//6c3pA=;
        b=WmYVGTPRmO/TCo/8HkToXxgann+NjVoV9ShsrN8rm8Fh7joz9Vi/Z62fQzP76nmMCA
         dwskgOJwyBZvZo6EevO++q5WQyUbD62y1lZSxnDqAg+ZFwNpMrElaVLaOBQ5aNo52cfm
         CcoFXMfKqCipdDENi0I56gbteJvUd8SCjN3uMv1OeK4m+G+IhZBsnp7EphCGz20NZyiu
         TSM1ccqlzIciAdYymJ4O8cPy9TgYhvDQhW6vkJqKC4raIUKwG3v9MqsN/t827XVTNu/Q
         XVReL7Gk7aq9p6WxF6dzZHDlEVvlqiQ3y/f8sMtcuD/yuQHPX1CseIajTwm/eHb0d60e
         4BeA==
X-Gm-Message-State: AJIora/X7DkSP4PUn04ZHLBtDBJn9MLxhrlsgnypMIJ3ErClTdM3NCHZ
        f0Ee0kiVbrwjjKAl9vd6VLnR0Om9yb0D/AkfvH8=
X-Google-Smtp-Source: AGRyM1t9iDAoI6VdXvWqxQ8DPB0bnk7AHH8zSFsZGXHGm7FDKD4J58RwY6M556wiZaNsbSQ73uhcYUVUsvtfp3YUCcI=
X-Received: by 2002:a67:d19c:0:b0:349:9ed:e5b0 with SMTP id
 w28-20020a67d19c000000b0034909ede5b0mr4738728vsi.62.1655297161944; Wed, 15
 Jun 2022 05:46:01 -0700 (PDT)
MIME-Version: 1.0
References: <20220614183720.512073672@linuxfoundation.org> <Yqmj7kkdooFqIv+V@debian>
In-Reply-To: <Yqmj7kkdooFqIv+V@debian>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Wed, 15 Jun 2022 05:45:51 -0700
Message-ID: <CAJq+SaAbbFZ3a5bEafCB=9KA2eTzc6n4sQxD8cvAx2h4f=C6-w@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/11] 5.15.48-rc1 review
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, slade@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> > This is the start of the stable review cycle for the 5.15.48 release.
> > There are 11 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Thu, 16 Jun 2022 18:37:02 +0000.
> > Anything received after that time might be too late.
>

Compiled and booted on x86 & arm64 test systems. No dmesg regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
