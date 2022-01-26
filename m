Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0733C49C9D4
	for <lists+stable@lfdr.de>; Wed, 26 Jan 2022 13:37:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241389AbiAZMhD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Jan 2022 07:37:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241367AbiAZMhD (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Jan 2022 07:37:03 -0500
Received: from mail-vk1-xa2a.google.com (mail-vk1-xa2a.google.com [IPv6:2607:f8b0:4864:20::a2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 484CDC061747
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 04:37:03 -0800 (PST)
Received: by mail-vk1-xa2a.google.com with SMTP id w206so14355271vkd.10
        for <stable@vger.kernel.org>; Wed, 26 Jan 2022 04:37:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rajagiritech-edu-in.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HEe8by3s9ksq7H7R+2e/eg/hw79b4EJ6GjQAEsOoplw=;
        b=UO3r5mlKyFdM5epZpIBys/99FFCpAEOA9LirCzoh21numfIZX+I8SholCplQhdrTua
         l3omy2IHIcnp4FPHs19LWko6r/vM+VcQ9BisSZD2Ttwv1qrVSVV4hNU6i/E9sPbQUvVG
         GtjM0JoKOjWXnyF4qtDFNM3CBuiFc3meEanv896iXeQQ+dvsZiTVb7vF3Twv/r9rcB/H
         TH0S2cEzV+ZY6lkiUDvA10sk47PsyF5KiU83xjv4YixE1LOsCiDDBjL13kmGRGuMh7iY
         PsU0Ob6xKvRBxvZ2xJ2k5Ye6ukEIVsTQ3yG3D0Er8ReFQlPxkZ2Fh8kVlrPg/7EJKgsi
         dsuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HEe8by3s9ksq7H7R+2e/eg/hw79b4EJ6GjQAEsOoplw=;
        b=Cbl6+77lNoQ/nVJBgXI1tn4Ie5XWhWbwM5JZ2aovsmVtSVlGoOUSMFSBlW0Koi28xm
         vdXhVgcYMoMrKrNUAmQcF04fhTRFP4j042biBGG2Cs4knrMS+SUpnt7roxJyycJXNigM
         1mjYACAghr9j+az+OZQa5tkKvBMvAez/V6lp1ByM7ojnTkbhg0DUFpBPjd75eIB3FuQo
         kOiJwGU+Pl/XD3qy3algLTtFo2Z8DgOb/y6kxlUvU+o2uQx4X6GZ+a3l26jYBDLaUgof
         hETIDsSjJylQtr4nXqfkMh46o6cbgRHoBONw/bi0H9s/ZUkR5B2jtMX3Bqr8ezs5vX1E
         aqMg==
X-Gm-Message-State: AOAM5330perWnTUt4DpDBy0zH5y9+upyDEtVMHrjwCJ2lW1hzbjxScZi
        dP4jxyiOIaJ8571zBiMajftOOr8s034fkQ7ovQMsdH2+paO7ndDI
X-Google-Smtp-Source: ABdhPJz9aQkROn1er0usTHlWN5dkzzcqwlsfWUkI31C5eh3tRJoVWgnRM/2VfrRYbdHEGZO02+uriBp13Xs1fjmj8iQ=
X-Received: by 2002:a05:6102:11f4:: with SMTP id e20mr4200674vsg.21.1643200622423;
 Wed, 26 Jan 2022 04:37:02 -0800 (PST)
MIME-Version: 1.0
References: <0af17d6952b3677dcd413fefa74b086d5ffb474b.camel@rajagiritech.edu.in>
 <YfAKYWOMdGJ0NxjE@kroah.com> <CAG=yYwksvQmEsfRyFiQTbSxUL39WGf7ryHaywtAxgdL1Nt67OQ@mail.gmail.com>
 <YfAk90OPjlpjruV5@kroah.com> <CAG=yYw=BK1gU0UV8g5_ZT5gOe5P2W2rKHWdFyPi4ZHSy4CGMFw@mail.gmail.com>
 <YfEmZiwkdZlQ3DVb@eldamar.lan>
In-Reply-To: <YfEmZiwkdZlQ3DVb@eldamar.lan>
From:   Jeffrin Thalakkottoor <jeffrin@rajagiritech.edu.in>
Date:   Wed, 26 Jan 2022 18:06:26 +0530
Message-ID: <CAG=yYw==-5tugkdgaA3XeWAOi5ni7waAJ=+qsAecTN=kR8HSnw@mail.gmail.com>
Subject: Re: review for 5.16.3-rc2
To:     Salvatore Bonaccorso <carnil@debian.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> What version of pahole are you using? Are you using Debian
> downstream's 1.22-2? If so please check if it's just the same issue as
> reported in https://bugs.debian.org/1004311
>
> Regards,
> Salvatore
i was using 1.22-2.
i think it is the  debian  issue as you pointed.anyway thanks

-- 
software engineer
rajagiri school of engineering and technology
