Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7AF97669CFA
	for <lists+stable@lfdr.de>; Fri, 13 Jan 2023 16:57:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230379AbjAMP5w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Jan 2023 10:57:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230375AbjAMP53 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Jan 2023 10:57:29 -0500
Received: from mail-vk1-xa34.google.com (mail-vk1-xa34.google.com [IPv6:2607:f8b0:4864:20::a34])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AADA490865
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 07:48:51 -0800 (PST)
Received: by mail-vk1-xa34.google.com with SMTP id t2so10382915vkk.9
        for <stable@vger.kernel.org>; Fri, 13 Jan 2023 07:48:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Sjh8dEOOgcZldDsl77ZYrTSvmKIK20XlFulb2zyWnx8=;
        b=AnLIoVgFPahZ0SLfc3kLAeouXizP96+BR8eOix5vANkp8TTN33WkWOA3gIZbeyv8E+
         2eDDPq8HwINGcLp5NgTCew3h2rNGay1NjICE409Gmq8CrJB60opLT6y9mQkoBVRgAFTj
         8Mh/o9YN6QLF/y6Pqz2yWRAFwybSoFBUGLYLjpqYXqx1HBkSQ4vdhLVKqv1JJKiZFspI
         lRfT5zmtvK6pt8Joca7p+DeAS7cOUooio7tlj0YQjxNWsXBD1id4TK3KLKcUOBA9H7u2
         FpG6ncD0QMJ0BJnOvsiEP6FLxe0kQH0L7j4svxeg0T+fHsP03JoRkz02gad4TZ+rURGs
         69WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Sjh8dEOOgcZldDsl77ZYrTSvmKIK20XlFulb2zyWnx8=;
        b=tcupN8g9niUjlm1bWNFIuFhvMcoXE1f6NAzyemhPTcASCidyqZb4+f9TlSm5q+FXkX
         s5HpRq61Nn1GwJ95Uf6d0xGI+FcrRsPIS7gXY2DHW7rluySzn4u/Ko+x1wGhR482OqMD
         5YNTgBIMPjlN8w0jmmoUgsKZ02crjPttZDU8yL+Rhqi0f/+gVncPNgQ9JJ7KhjpdW0NA
         8zJ5QioYVIZiqSz4eOJhtHVIn+9n07IYUe4UhoqjePbWuFcAuYpJTd4NST9fAqBqfxj1
         wCKXyKRNyfL8RBO4/gPsxj0YdIwg6lOySA3vc5lBucb7LCjQvz/Twt40Us8XFdha/Ls4
         gbsw==
X-Gm-Message-State: AFqh2kplffHgI5Vk9+iAzG1Q0oIPQkwboYr3/58aCKho4crz2Su+R1sI
        kKGqvNCPWytnpePukd+lY0CVPHK16tepJrYsgkLggA==
X-Google-Smtp-Source: AMrXdXsI3jUe1ZOmxcBuPFkKStLnmNlMx7lM3Z58HMQDqrP86jptXCPC06qiPeyDnCmvidNT/WWExc8wwMy3H1VFgZI=
X-Received: by 2002:a1f:3215:0:b0:3d5:86ff:6638 with SMTP id
 y21-20020a1f3215000000b003d586ff6638mr8205679vky.30.1673624930613; Fri, 13
 Jan 2023 07:48:50 -0800 (PST)
MIME-Version: 1.0
References: <20230110180017.145591678@linuxfoundation.org> <CA+G9fYtpM7X15rY6g6asDxrjxDSfj5sDiP8P5Yb1TS3VVmjGNw@mail.gmail.com>
 <Y8ElS+jivE5FWvku@amd.ucw.cz>
In-Reply-To: <Y8ElS+jivE5FWvku@amd.ucw.cz>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Fri, 13 Jan 2023 21:18:39 +0530
Message-ID: <CA+G9fYv=ZcY5-hT7-RZmnhwyac3cf1DsG6WSeOSyHqSHSbALgw@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/148] 6.0.19-rc1 review
To:     Pavel Machek <pavel@denx.de>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Arnd Bergmann <arnd@arndb.de>, Mark Brown <broonie@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

On Fri, 13 Jan 2023 at 15:03, Pavel Machek <pavel@denx.de> wrote:
>
> Hi!

> Full log is 11MB. That's rather... big for an email. Please post such
> stuff as a link or at least compress them...

Thanks for the comments,
And i did in the next email with a trimmed version of log files.

[ + attachment failed resending with trim version of log file. ]

In general practice, I do share links to log files, kconfigs and artifacts.

Thank you.
Naresh Kamboju
