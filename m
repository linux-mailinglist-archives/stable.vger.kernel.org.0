Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704C93F4CBB
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 16:54:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbhHWOzW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 10:55:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230506AbhHWOzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 10:55:15 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D5EC061575;
        Mon, 23 Aug 2021 07:54:32 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id s3so31974442ljp.11;
        Mon, 23 Aug 2021 07:54:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=qF4/nz8GIrXzAyIJoNZKO7UtlDKmjc+9xeOndqWrLxY=;
        b=rG0INA7uDDS6Zl5bzg7W+WIiKdPo6xKX1cCbeoyGCUofQ9KyTJDrDmS0GCrhSthi8s
         BVDwbzN+Ni57Qsw870s3rFqK0WE37DQiTOVfe7Q8RNSgDlxtai9uegAq/OLm50bUyBDS
         Ee1XdEa0RHv3QsnaIoq+LUUtp3Us0djYmVHdHS3KMwBRWG20ThsL+31EP1vnfwQP9muO
         5n1JdwvDYw8lDQlJlJWGx5Y7rbeWVCdAkWG3JnJJAlrLi/bLt1NAxM4vuOaO7Bctmh+J
         Y/ULsa35IAiLlBANhJ+MGS3xrdB9NOZCMq6Ak9FZMPo1q1FBJ0M5lajO0/QCf9/TJt35
         xUgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=qF4/nz8GIrXzAyIJoNZKO7UtlDKmjc+9xeOndqWrLxY=;
        b=B7U8vyIHE/dS/wrG10t7cbSJ8kb3yhJYW2/CV88ETlYmudop6Dl2+in9IpxnHUDLBP
         MnHZGRnIz4D9E71L1KrYJtO2L4ZuZ2PpAi/M62eooVpDGRPtMDs341IZw/r3acO18MZZ
         7X21+08lU2Bz/8ZBhDM/sTmcbyOgBvR1LlTlM1hm/A83hUjGflqbwa7j0wRjDajUicG5
         DCYqnqGrz2jSsOZ7OHqX6+AVaNVkOOr/5e657bhKayPiYxcoQKSYF0yPwUNxehCrrEW8
         Rw7YTAFPbueA4Ekm/Tl6vS5lsoue3HhWolO19a3DlHfHPQUdyiiY4QaEh4EANzEppdQz
         /nvQ==
X-Gm-Message-State: AOAM532zA5+T++T0LqVPHDAVPE8cd5GG2R25+QXZoiCAEvndu9R7XDej
        DvIEzXp2GmAIZQ10BbG3HmYaFX4LMydhFfK1TU8=
X-Google-Smtp-Source: ABdhPJwPLxxS5dxbt5SFn02vNj7fTqAu6y2V4GxzgDnqgocAKlPmCQDEm+Fc1H89nbCm9WtQWZ0xTvL82jYHte9yReI=
X-Received: by 2002:a2e:bd85:: with SMTP id o5mr17218398ljq.439.1629730470819;
 Mon, 23 Aug 2021 07:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <20210823140844.q3kx6ruedho7jen5@pali> <18c5a8be-66d7-0dd8-b158-0931335f7ac5@candelatech.com>
In-Reply-To: <18c5a8be-66d7-0dd8-b158-0931335f7ac5@candelatech.com>
From:   Julian Calaby <julian.calaby@gmail.com>
Date:   Tue, 24 Aug 2021 00:54:18 +1000
Message-ID: <CAGRGNgUMioB8NRrJQjFYRPdEt4OzF50kU6_CJ4nDvqsuq+U6nw@mail.gmail.com>
Subject: Re: Drivers for Qualcomm wifi chips (ath*k) and security issues
To:     Ben Greear <greearb@candelatech.com>
Cc:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Ben,

On Tue, Aug 24, 2021 at 12:37 AM Ben Greear <greearb@candelatech.com> wrote=
:
>
> On 8/23/21 7:08 AM, Pali Roh=C3=A1r wrote:
> > Hello Sasha and Greg!
> >
> > Last week I sent request for backporting ath9k wifi fixes for security
> > issue CVE-2020-3702 into stable LTS kernels because Qualcomm/maintainer=
s
> > did not it for more months... details are in email:
> > https://lore.kernel.org/stable/20210818084859.vcs4vs3yd6zetmyt@pali/t/#=
u
>
> For one thing, almost everyone using these radios is using openwrt or
> similar which has its own patch sets.

For reference, according to Debian's own security tracker, only
CVE-2020-26139 is patched on all but the most ancient tracked release:

https://security-tracker.debian.org/tracker/CVE-2020-26139 (fixed in
all but the most ancient release)
https://security-tracker.debian.org/tracker/CVE-2020-3702 (all tracked
kernels are vulnerable)
https://security-tracker.debian.org/tracker/CVE-2020-26145 (only
testing/unstable is fixed)
https://security-tracker.debian.org/tracker/CVE-2020-26141 (only
testing/unstable is fixed)

Debian Buster has a 4.19 kernel and they only released Bullseye, it's
successor, a couple of weeks ago, so there's probably a
not-insignificant number of PCs out there still running kernels that
old, and I understand that they'll be supporting Buster with security
fixes for approximately another year:
https://www.debian.org/security/faq#lifespan

Thanks,

--=20
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
