Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3CD083F5143
	for <lists+stable@lfdr.de>; Mon, 23 Aug 2021 21:27:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbhHWT15 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Aug 2021 15:27:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231891AbhHWT14 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Aug 2021 15:27:56 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E742C06175F;
        Mon, 23 Aug 2021 12:27:14 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id z128so36160601ybc.10;
        Mon, 23 Aug 2021 12:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fzFh9k1p27YnwdCOGaCKh4AMybb++Mp03L1JFAHVh60=;
        b=aG3IfbyoF+XMUuBhUixaw04X4kzdYVPXGGBI99XXr/MDjVUOX8alKxD1xO06D2+4pX
         z2B06UXKsrJXMshBV0qwrrChJEIXDF5K30xBdOCx2QI2A+og8r8BB3ef22D0RPImV++k
         4W97iRHbWD5et0/oD33mvD2zPuZh4ddenElz0YUeAJ0nQdEsqLk7Ly679kb8euSKhqNK
         hRPivm7qRdiYoHH4/CrLkVYnn6O30z5uUVpVd6koyiatW9QPAD/XB9KZQ0uVHqR6lY58
         Qm2JMkuICvFHDkoBn5TUrgH8bXbF8Onw4ofbEmLcXrx7Irq9Kj+eadYp8V0F8IRYKQhM
         ZFBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fzFh9k1p27YnwdCOGaCKh4AMybb++Mp03L1JFAHVh60=;
        b=F0v2jONiqW95cNKo4KK/ya8EMsbTknzMTqiAXntQbnYQ6c9+qw4+Hds1QjW8EBTMza
         wIATnE7jKUxPbXh2QaiWyXKgR0GUeSv4z+SkPfJ+0YR5MADyYyB+MM5Xyemh54rnP3L7
         o4gd5AAqW22vRZYGFQeygc2T99oeRHh729A6/yz7xsUcn2Vk+pvEpmPg74BeYRGdU2kO
         SICfdOzLaYfIi3Rr3uBl+en6+IZCinCN7vcVJb0/gFBYRtIEI746DyJ/MpjR+Nxl5+4P
         JgmCxoP6mi6NF8joa04n19CqjM6qjdi/pmQQo6vd5joigt7OZR1sKd8My0T6VTwxyF0j
         ppyg==
X-Gm-Message-State: AOAM531sX444iKlkHEJSzmc/mDICUMsJDdx9zag2ezEnNO3G80gLwqJw
        RkR/KXaYskSUHZaKGZ0xgXi87VISd0dFH2XG9Mw=
X-Google-Smtp-Source: ABdhPJzMJs7tn/5beLdQLQapSVqh95o/Xoi8E45wdZM+va5IB6wK2RDSwWtJKUv+Eo0RLfsSKvE7K8uGcu7jVi8DviY=
X-Received: by 2002:a25:c083:: with SMTP id c125mr28409284ybf.331.1629746833297;
 Mon, 23 Aug 2021 12:27:13 -0700 (PDT)
MIME-Version: 1.0
References: <20210823140844.q3kx6ruedho7jen5@pali> <18c5a8be-66d7-0dd8-b158-0931335f7ac5@candelatech.com>
 <20210823145800.4vzdgzjch77ldeku@pali>
In-Reply-To: <20210823145800.4vzdgzjch77ldeku@pali>
From:   Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Date:   Mon, 23 Aug 2021 20:26:37 +0100
Message-ID: <CADVatmPwp9Ngexm+_JgW3vBxFo6FBq9NzLS=POxHoO-COBQ0gA@mail.gmail.com>
Subject: Re: Drivers for Qualcomm wifi chips (ath*k) and security issues
To:     =?UTF-8?Q?Pali_Roh=C3=A1r?= <pali@kernel.org>
Cc:     Ben Greear <greearb@candelatech.com>,
        Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Stable <stable@vger.kernel.org>,
        "open list:TI WILINK WIRELES..." <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pali,

On Mon, Aug 23, 2021 at 3:58 PM Pali Roh=C3=A1r <pali@kernel.org> wrote:
>
> On Monday 23 August 2021 07:32:11 Ben Greear wrote:
> > On 8/23/21 7:08 AM, Pali Roh=C3=A1r wrote:
> > > Hello Sasha and Greg!
> > >
> > > Last week I sent request for backporting ath9k wifi fixes for securit=
y
> > > issue CVE-2020-3702 into stable LTS kernels because Qualcomm/maintain=
ers
> > > did not it for more months... details are in email:
> > > https://lore.kernel.org/stable/20210818084859.vcs4vs3yd6zetmyt@pali/t=
/#u
> >
> > For one thing, almost everyone using these radios is using openwrt or
> > similar which has its own patch sets.
>
> AFAIK, latest stable released openwrt uses ath9k from 4.19 tree and
> AFAIK did not have above patch.

I think you asked for the following patches:

56c5485c9e44 ("ath: Use safer key clearing with key cache entries")
73488cb2fa3b ("ath9k: Clear key cache explicitly on disabling hardware")
d2d3e36498dd ("ath: Export ath_hw_keysetmac()")
144cd24dbc36 ("ath: Modify ath_key_delete() to not need full key entry")
ca2848022c12 ("ath9k: Postpone key cache entry deletion for TXQ frames
reference it")

And I can see they are already in the queue for next v4.19.y release,
so should be part of v4.19.205


--=20
Regards
Sudip
