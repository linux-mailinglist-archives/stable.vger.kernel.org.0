Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 53535143992
	for <lists+stable@lfdr.de>; Tue, 21 Jan 2020 10:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728682AbgAUJfd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Jan 2020 04:35:33 -0500
Received: from mail-ua1-f66.google.com ([209.85.222.66]:46357 "EHLO
        mail-ua1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727962AbgAUJfd (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Jan 2020 04:35:33 -0500
Received: by mail-ua1-f66.google.com with SMTP id l6so695062uap.13
        for <stable@vger.kernel.org>; Tue, 21 Jan 2020 01:35:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=benyossef-com.20150623.gappssmtp.com; s=20150623;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=5xSr/xWhBdXs7RNFC7Li5lQIHOdj4syccfkV3xZnEyo=;
        b=tjfByNT9DB22fcS1Z2EsFr90KKjb8XoxQFziAySgcR8PON7907/MPiZBD/dWRgaa+Z
         GqeKogByNjUu1PgWMoUo5q7V6mZcePbJM5JsvAMpflk3nz9bnjw6VVD4hjnQg3d4H6p2
         sgnJM2PWtcWGkt6HDJsoP5IYjk/Glr9SDi4sywpX43iWciyEzsGonz+39bBTqOk7jx1G
         w3n541D5hQilTxQX5Hpq6b22omlQho+lArJrcfhup8bSFWXF1HB21uJDuDmSLTuOJWey
         VhjLm2uyvKFxMjnE09LCe/05eIY7fRvp4fx3IoA3qyeGJiJJmei3sVxO5D/Exvw9qzNL
         K+Gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=5xSr/xWhBdXs7RNFC7Li5lQIHOdj4syccfkV3xZnEyo=;
        b=hzuxJHLRoMls6PvYE1dtfaPwLOB9BvoENUwjIuH5F73MBzUkktrUqP0LGs3v52vDMu
         yr7IaJ2y5kjdAvE8lAHvO2ukoZipnR6NrzThpWhiYaPqsovDoXbF/+TxKpO1izp1yDeV
         GPUtYT6mTYp9PuhCpMyPyItCQ7Rdh7ZamkBCehUNxzebZAWN+DLp5VTC9iycKse6sJkX
         VlESdrA39tzmIYsWePkwuQWPeDomvrEnWNcqEuk4Nk7zg0QZAwqjb3QE+npD9CVLquR3
         migUDaxD74WbfsRxOtFpA4SkGeidSaaOPiHvLlRMyJvBpYnpka7bD6aYh2UNFHPrxE5B
         3otQ==
X-Gm-Message-State: APjAAAVZto/T2DjU+cGFg2jJy3NcieooeG5qx8CFZcvIUDemiNPl4a71
        JTTTP3Yb3EPyRELrgLohfGRp6+ZIFY5f8UdGR8ou5w==
X-Google-Smtp-Source: APXvYqzWoNnY7whvMjOB189pVR/o+F7LCysg8eFana7vFsSEpP1KXHwDk2CsMfB29UYjvfjd2l5e+90P2Z3UIdKF0JY=
X-Received: by 2002:ab0:77d7:: with SMTP id y23mr2228235uar.4.1579599332214;
 Tue, 21 Jan 2020 01:35:32 -0800 (PST)
MIME-Version: 1.0
References: <20200116101447.20374-8-gilad@benyossef.com> <20200119152653.6E37B20678@mail.kernel.org>
 <CAOtvUMeJLUhPWP00h6h+LcGSvu+=CsHcbZ7OXzXHwWJd2R0agg@mail.gmail.com>
In-Reply-To: <CAOtvUMeJLUhPWP00h6h+LcGSvu+=CsHcbZ7OXzXHwWJd2R0agg@mail.gmail.com>
From:   Gilad Ben-Yossef <gilad@benyossef.com>
Date:   Tue, 21 Jan 2020 11:35:17 +0200
Message-ID: <CAOtvUMffK_ZJtT3mNtqeceTrYtN0on7pcxJuwacr=RyPBnU8xA@mail.gmail.com>
Subject: Re: [PATCH 07/11] crypto: ccree - fix FDE descriptor sequence
To:     Sasha Levin <sashal@kernel.org>
Cc:     Ofir Drang <ofir.drang@arm.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Hadar Gat <hadar.gat@arm.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Mon, Jan 20, 2020 at 4:27 PM Gilad Ben-Yossef <gilad@benyossef.com> wrot=
e:
>
> Hi Sasha,
>
> On Sun, Jan 19, 2020 at 5:26 PM Sasha Levin <sashal@kernel.org> wrote:
> >
> > Hi,
> >
> > [This is an automated email]
> >
> > This commit has been processed because it contains a -stable tag.
> > The stable tag indicates that it's relevant for the following trees: al=
l
> >
> > The bot has tested the following trees: v5.4.13, v4.19.97, v4.14.166, v=
4.9.210, v4.4.210.
> >
> > v5.4.13: Build OK!
> > v4.19.97: Failed to apply! Possible dependencies:
>
>
> 'm looking into making a patch for v4.19.y. The rest are not relevant
>

After further investigation, this fix is only relevant for 5.4.y
stable releases as the earlier versions did not include the change
that originally caused the problem.

Many thanks,
Gilad



--=20
Gilad Ben-Yossef
Chief Coffee Drinker

values of =CE=B2 will give rise to dom!
