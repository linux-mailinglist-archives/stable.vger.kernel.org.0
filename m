Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8AE9652ACB
	for <lists+stable@lfdr.de>; Wed, 21 Dec 2022 02:13:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229943AbiLUBN2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Dec 2022 20:13:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229720AbiLUBN0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Dec 2022 20:13:26 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0B7CDFDC
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 17:13:23 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id 7so4418201pga.1
        for <stable@vger.kernel.org>; Tue, 20 Dec 2022 17:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=I8j9TRWymc2LoH0eKyaoIs9UEkksGnz4z4IEp1BW3rc=;
        b=hjDV0Ac4ho85L/SATVrnhwahrjMc+yi+EKel2PCOPLb84/eYkQkvYkigo2zCbuCBQr
         Qr3V0E1rdjOesLtEzyZ9O9UtmFbS4Z1MAy7zFVaVlsF78dkA7VkiHfhLUpDbxEY8icw3
         fitJKcWFIEyv9KTvAQwacpFOw0IchY3fZxpgYpCEt7+pvTkX34waMaj1TwlU6JO6F9rU
         hGU81NqMke+yzZomf7phHpH11VobXjQOQwYIWLzA95FlnJg/aqz+r4Imr9sD3RJAGrkZ
         pe2qWc4XiEbz7HTG1n5ylkkCrnOu0S5G+9nOwk9ViYzzi39kCfb0LLXErc9rL/MG0Xqh
         3Tlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I8j9TRWymc2LoH0eKyaoIs9UEkksGnz4z4IEp1BW3rc=;
        b=4xZ6WJv1CWD6esFrdmVYOC8y+UbfmXV+HGOzBM/wLl0u/SWyQ6U3JA2mDBTKEYDE1V
         uPaG5DVmtpHbrknr2bNZkdL6ADM8anaM+Ad2QIcApumdW22bnsG7htIdhfnmlKODF9IM
         8mZ+wRjQ9QepYllCr0vNgRJ4VUaGF6i7f8QO43aapAt/gyPRsOSVfQGZ7dVLJ2NYJ8o5
         Y50pcE8fwZkHtVXPKLlKWVL/KO3rNB2jil7WYJU1sbGjIJF7O2SQX5L13sShauGOU2+b
         Vc7CYkoYFxwALXeBBosfTwc0E5Ipj2241LAwZ1yo/ECg2QEgknKFwdIP6nqEZqBrMm29
         E8qQ==
X-Gm-Message-State: ANoB5pmRTZaxb8+iQ5o1dzYAyCg/GTVIyqUTVG2IZlxvmYYpDs8iE7d3
        TcMLPKMm7A30lT0bNRCOvumilHMcV40ZRRVbbFEoCfvj3C50N9ur0Mk=
X-Google-Smtp-Source: AA0mqf5Dq4rrq3kxKwTPoA0dfgN01W9r5o0Qnonh1YEBT9OKXCCJjiIlbU87kRlWm2kl8ZHTpnXYHINwH88Hx+j92K4=
X-Received: by 2002:a63:110d:0:b0:46f:6225:c2f9 with SMTP id
 g13-20020a63110d000000b0046f6225c2f9mr87648713pgl.225.1671585203356; Tue, 20
 Dec 2022 17:13:23 -0800 (PST)
MIME-Version: 1.0
References: <20221219182943.395169070@linuxfoundation.org>
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Tue, 20 Dec 2022 20:13:12 -0500
Message-ID: <CA+pv=HOHmXyiiLPJkcHChGMRnxsCiQV3rY6B0uzRsAe0bwb0Fw@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
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

On Mon, Dec 19, 2022 at 2:23 PM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.

Hi,
Compiled and tested on my x86_64 test systems, no errors or
regressions to report.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Yours,
-- Slade
