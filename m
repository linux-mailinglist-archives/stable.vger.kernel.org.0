Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA09622035
	for <lists+stable@lfdr.de>; Wed,  9 Nov 2022 00:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229587AbiKHXQx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 18:16:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229464AbiKHXQw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 18:16:52 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE209193D7;
        Tue,  8 Nov 2022 15:16:49 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id g24so15524604plq.3;
        Tue, 08 Nov 2022 15:16:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ouDJKeV1+9oucOYE87owMq/AqAQ66xsHnB+NY0a4rhg=;
        b=McFPNTHl3XwI5lZ/CSu3uvqILb1MdP91tLngcM2ucgPK/w5gRP8MH2/UvfLz995noH
         vh56vLI9YGWN04Cddx4AVi3pj1Sun3GDlQvKvmtKzVYu0SapBOS4LUXbjZL3i9mrJb2N
         NDbfjgViBLJvFmmZky4sNKBlZm3YBUrkbpF1agWvwEa6/te+OSHLNHG6XcvquKcXz2jd
         eAwyk7YPOmNuNtheM0xHIt64EZyUYOdTLO7A0cwegj2fOozEcnUd9dPOfd4fDXzLwj77
         ffRQNVWSvv7qual7C4oUO3xb7wI6sj+cpE5dd2oTYw69K6bvnW1cqIL/oFKT4jqEFwa2
         Lfzw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ouDJKeV1+9oucOYE87owMq/AqAQ66xsHnB+NY0a4rhg=;
        b=KnI6kUXgsz8l/gWwkJQ7q7QOrivpcmp0QWM7l2eyFi6vbHCNgjgj+gc2LjMC1YzwmH
         0xgJjBUNYEepLUM+50HQ2svq1GFZ+Cz7jZupzXw8s0BFZvY8ArsC6nSUFNYfH45BTKur
         2PbAvE2NjNiOCwxREia6xpvuJv15CrNUAxjT8ga/SmeRTAO6/mnQ0NOtOsrMiRvM2HnL
         KdTR1jrCkjXZOSMBV69ulwiWkOvZ1AtoVTHU9X2ZcMix2PlFPiMof2FFsxGvfu3MyDFC
         7JQD2tEpv/X7oet6AcNFNa7rVscSgUtK4Qj//X+2zY64ja2I/OBtdbCWfQTTQ7LsDJAO
         tYUQ==
X-Gm-Message-State: ACrzQf2DPLUApIO1g3ZxgOV2xyXhwKxI6Qv8r6+ApNitmz0mQ6a+497c
        O1jQOf/DLIM7py0O5mfUexNKrmrKFuJwsxbLX5w=
X-Google-Smtp-Source: AMsMyM6IOqGvBWCaLca/WddQ6k6vG1TcqJwuC2P0xkdBwPMWqIqSrYqmrqC6wfWJAXaWylIUezmBc+hAvRwwoChFVco=
X-Received: by 2002:a17:903:1211:b0:178:a692:b1e3 with SMTP id
 l17-20020a170903121100b00178a692b1e3mr60320340plh.48.1667949409522; Tue, 08
 Nov 2022 15:16:49 -0800 (PST)
MIME-Version: 1.0
References: <20221108133345.346704162@linuxfoundation.org>
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
From:   Allen Pais <stable.kernel.dev@gmail.com>
Date:   Tue, 8 Nov 2022 15:16:38 -0800
Message-ID: <CAJq+SaCw3-_TyGNn_Npf1+rh8gufepK7yVdKMEVehkKoawuwmw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/144] 5.15.78-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net
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

> This is the start of the stable review cycle for the 5.15.78 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.78-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
