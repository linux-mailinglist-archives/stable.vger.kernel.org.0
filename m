Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E26E45D573
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 08:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235623AbhKYHcM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 02:32:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233409AbhKYHaL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Nov 2021 02:30:11 -0500
Received: from mail-ed1-x529.google.com (mail-ed1-x529.google.com [IPv6:2a00:1450:4864:20::529])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3E8CC06175A
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 23:27:00 -0800 (PST)
Received: by mail-ed1-x529.google.com with SMTP id g14so21472589edb.8
        for <stable@vger.kernel.org>; Wed, 24 Nov 2021 23:27:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8ErAPLPUu+Zcbpgrl+R0IgUe7alERBIpvIUmrIUHrj0=;
        b=NwQ6lN6ULe0j69KhRom5J4jfwR6GW9zFSpIZO6Jr/yXE4sK3bCg/s0f1GQiEXp1YY6
         o0X8OjKds09MfMtQAU9nWRmbSBi2sF+19vNQTLBrLaxVXIGUp4A5JjCeGWhOquM5F+79
         UggskDS4fzfnQCWIDlJTTYkYfoHSu+W6oOJNhv7B7b4djGQ4HgkryjojjPDuas6b5dwh
         x3orJt4vUmAjmUtfDA0Vjfc2fzl/Vd0z+l3oBbAepyedZfcHiPv14d6FcfGy0YjovJwR
         Qjz6nMIpWYXUN0aAcgDnVPjloaK0oQpmT1wvL8ywVr8/GG0dTdcxF5xJ5jH3LWVK5GMk
         Zpfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8ErAPLPUu+Zcbpgrl+R0IgUe7alERBIpvIUmrIUHrj0=;
        b=CeGxcTEzVjTJ1B3eKmE2ZEjcYpOwSWRdUzNU2NlxSMFIp+YnfpnSiol2tiCNXkfzEa
         a42wsEFm14E5hThUuNSUBFMqDmfv4YxExXDzRADS72Ui90zzThfWiVoL6YDYqWw8//k5
         4DisWGzkTPfSCmlSGO9TjuocpISAndF+D19t7WuEh8USK+BL5hi2/aTMiMToIlH5uqme
         RvUJAOSNylSo9HWr5VztuPXh6MfyJhsOtcUE2J3QTAFNyJQrPbjXc299/UGe8onJYWnN
         tSBje9dcJthbabD73C7X/S7ok6iCdsgIUlbJq1hbOJmNw24P3EbO+ExO43zEjgVRzaUm
         FUmg==
X-Gm-Message-State: AOAM5337JWlULwU26VjjQ3+aNXaYOjOpsSXDK8SqAbmZ5jBdCWIT2LW0
        RBiTkpx4taWvQOBHwUQNPUyror8AOAR4eMf8fET5aQ==
X-Google-Smtp-Source: ABdhPJw8+/a1NBiAYJ+y2plHA98NeqVaJ2heCjqTMVaiGwiHRNOkN6MsoghuqpXf6UnYqbiibrNP+Gh2Py6PMyEmsMg=
X-Received: by 2002:a05:6402:90c:: with SMTP id g12mr35216895edz.217.1637825219306;
 Wed, 24 Nov 2021 23:26:59 -0800 (PST)
MIME-Version: 1.0
References: <CA+G9fYskrxZvmrjhO32Q9r7mb1AtKdLBm4OvDNvt5v4PTgm4pA@mail.gmail.com>
 <CA+G9fYvroifx_0xx-DxRRdDqsR79HV4KTC+a8+3zTL57Cu2TnQ@mail.gmail.com> <YZ5ksupzeLkkmH0H@kroah.com>
In-Reply-To: <YZ5ksupzeLkkmH0H@kroah.com>
From:   Naresh Kamboju <naresh.kamboju@linaro.org>
Date:   Thu, 25 Nov 2021 12:56:47 +0530
Message-ID: <CA+G9fYtD3d+HpfdRpy5+xjiNDafK2eLRzF1_ssR=Q8fp6JrbCA@mail.gmail.com>
Subject: Re: cpuidle-tegra.c:349:38: error: 'TEGRA_SUSPEND_NOT_READY' undeclared
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-stable <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Dmitry Osipenko <digetx@gmail.com>,
        Thierry Reding <treding@nvidia.com>,
        lkft-triage@lists.linaro.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 24 Nov 2021 at 21:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Nov 24, 2021 at 06:10:16PM +0530, Naresh Kamboju wrote:
> > On Wed, 24 Nov 2021 at 17:35, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> > >
> > > Regression found on arm gcc-11 builds
> > > Following build warnings / errors reported on stable-rc queue/5.10.
> >
> >  Following build warnings / errors reported on stable-rc 5.10 also.
>
> I think you mean 5.15, right?

i mean
stable-rc 5.10
stable-rc queue/5.10

- Naresh
