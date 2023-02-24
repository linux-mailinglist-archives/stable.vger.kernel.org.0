Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC40D6A20E3
	for <lists+stable@lfdr.de>; Fri, 24 Feb 2023 18:52:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjBXRw4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Feb 2023 12:52:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48638 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229445AbjBXRwz (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Feb 2023 12:52:55 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38D40F951
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 09:52:53 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id u20so5619701pfm.7
        for <stable@vger.kernel.org>; Fri, 24 Feb 2023 09:52:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=SCackxgxqPZz1OiILJ7kCheCg0pnGW/YdL0a2rTkB9k=;
        b=XRcCKELQH3Eo8zQ6OvBMT0+5rBLdXMrP0ymDtbLGilAJXOy+w0H6VIlTb3rE/Uv7kn
         CFmJ2AP0cyhSJPq6dcxRfveh9LXHBmg3QBFIBNo/oupr/khGN3VcALoOAuBNZtqWMRyW
         cOGll7LKLG2mdz+sfyB82hokbgitmYlJ1JoWy2jf8Lieb9FewUXL+WPIm85yY2ZIKhQJ
         CFeREGf02W6mZiG9DkJt/QS1qEv+9+V/hQXwGpZ3McEqxMyLfGWYr+ey84KFNRGi5UCD
         p/NGQTv8JbKShnrvEsXeLAZnjrAWGNefZ4E9sSjYxoIbqJ/Qi3yw071+LOMF6Jz4D3sc
         BgCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SCackxgxqPZz1OiILJ7kCheCg0pnGW/YdL0a2rTkB9k=;
        b=DhuGs2nHwKUfNFVI65MrI8eckFLePVG3F8/B0tgeNN3kFNA2x+qLpgqTfS6WYoWCg2
         rhppcZxQEbFDjRjKeuTGEtUXvTuFgF/TEEEOsc/2ZR2lMtFrEHxw1XdyX1MhdeEgGJWR
         tDHUdtawVT1dXnFuPjcw+dtQ0tRy8yFJYu6ff4O3895HnweP16JwI8i7iNIKxKAe0wXv
         g+pbcvfEtCNf0G0USkY3bspPFaomE1gOKwG5537+8TE94i4ZXQiJA1wfOTEBwz8iAgtB
         /QDYgJcVn/4cjmTwqY3lSyPX2nVdGzF7f+8KZK1Q1A0J1VY+iIniyAUv7nBizT6wwvEk
         LGyQ==
X-Gm-Message-State: AO0yUKVYjyLbx4b5hdg7pCKAim/T0zyDJ4xxhcX2eNd/pK1wscC4JpO4
        uZoKTBDBD8uPSUSzHvDwYUGyRNQguSU8mHSGsHBqRg==
X-Google-Smtp-Source: AK7set8SGDB1zD5kMker4QuUup1RIlK/YZsel7dljbjx2fj8/qpmnbaOvZqH2vWLc5NzROAlldWOXeHidwcAyfe7llk=
X-Received: by 2002:a63:9251:0:b0:503:20c2:1752 with SMTP id
 s17-20020a639251000000b0050320c21752mr219087pgn.1.1677261172625; Fri, 24 Feb
 2023 09:52:52 -0800 (PST)
MIME-Version: 1.0
References: <20230224102235.663354088@linuxfoundation.org> <Y/iRLeEsyiYHjeh5@kroah.com>
In-Reply-To: <Y/iRLeEsyiYHjeh5@kroah.com>
From:   Slade Watkins <srw@sladewatkins.net>
Date:   Fri, 24 Feb 2023 12:52:40 -0500
Message-ID: <CA+pv=HPDzTjHokT3Os=0aEEsR-NEHskjGRRXhuHPPO=wOyqxZA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/37] 5.15.96-rc3 review
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

On Fri, Feb 24, 2023 at 5:28 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Fri, Feb 24, 2023 at 11:23:55AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.96 release.
> > There are 37 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Sun, 26 Feb 2023 10:22:23 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >       https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.96-rc3.gz
> > or in the git tree and branch at:
> >       git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
>
> Only change here is that the permission issue on
> scripts/pahole-version.sh _should_ now be resolved.

Hi Greg,
This is fixed now, as far as I can tell.

With that:
5.15.96-rc3 compiled and booted on my x86_64 test system. No errors or
regressions.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Thanks,
-- Slade
