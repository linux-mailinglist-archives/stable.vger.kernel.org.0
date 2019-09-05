Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75094A9DFA
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 11:15:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733138AbfIEJPf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 05:15:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:34306 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733117AbfIEJPf (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 5 Sep 2019 05:15:35 -0400
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86FAD22DBF;
        Thu,  5 Sep 2019 09:15:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567674934;
        bh=Lf4GVa307w1VgMvnePJnb120Zs7h4v86EeKJR07t8iQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=iZiB+uvyG4Pk5Kak4VmB5+DuYxHY3wOZtQBqm3PpLJyXmbm+J7C8rEgS8aygWWfZT
         R2Vvacg+VzEfwczaOdVYsN2YWcPRAyHx7KWzkfjqOssvZg7urX1x7umzKZ5jQzpuQ9
         GvFxJ6eoNLKzM5swv4SfZ7elFLzeo9CBHTQHAvSg=
Received: by mail-qt1-f176.google.com with SMTP id u40so1903767qth.11;
        Thu, 05 Sep 2019 02:15:34 -0700 (PDT)
X-Gm-Message-State: APjAAAVIYu7CxjfPuh0l0nTj/Yax2nN6gCoQfZNd7IhbGP+ouMM6//UQ
        1lTNoB9M4Ef19i6tBlR0C6GsqHANyxsKmWRhvQ==
X-Google-Smtp-Source: APXvYqyNwGylNaWmJdbp0hwtvhbRvYKWfKT2epWyENciBWUw2i2+7fCPtHnQEiLZeksoFBqLyL9cCiJhvQ6vopV1LgA=
X-Received: by 2002:ac8:44c4:: with SMTP id b4mr2438638qto.224.1567674933700;
 Thu, 05 Sep 2019 02:15:33 -0700 (PDT)
MIME-Version: 1.0
References: <20190903162519.7136-1-sashal@kernel.org> <20190903162519.7136-147-sashal@kernel.org>
 <CAL_JsqJrwwsp1wjCBnNmx45ZiLTXVY_nCfN6OrJ5o9dLbc+_2w@mail.gmail.com> <20190905090336.GA29020@kroah.com>
In-Reply-To: <20190905090336.GA29020@kroah.com>
From:   Rob Herring <robh@kernel.org>
Date:   Thu, 5 Sep 2019 10:15:22 +0100
X-Gmail-Original-Message-ID: <CAL_JsqL_MeD_pqZ1Ye2202tKhnqa-tfRhfoprUinh0MGrDr4hA@mail.gmail.com>
Message-ID: <CAL_JsqL_MeD_pqZ1Ye2202tKhnqa-tfRhfoprUinh0MGrDr4hA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.19 147/167] drm/panel: Add support for Armadeus
 ST0700 Adapt
To:     Greg KH <greg@kroah.com>
Cc:     Sasha Levin <sashal@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?Q?S=C3=A9bastien_Szymanski?= 
        <sebastien.szymanski@armadeus.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        devicetree@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 5, 2019 at 10:03 AM Greg KH <greg@kroah.com> wrote:
>
> On Thu, Sep 05, 2019 at 09:55:58AM +0100, Rob Herring wrote:
> > On Tue, Sep 3, 2019 at 5:31 PM Sasha Levin <sashal@kernel.org> wrote:
> > >
> > > From: S=C3=A9bastien Szymanski <sebastien.szymanski@armadeus.com>
> > >
> > > [ Upstream commit c479450f61c7f1f248c9a54aedacd2a6ca521ff8 ]
> > >
> > > This patch adds support for the Armadeus ST0700 Adapt. It comes with =
a
> > > Santek ST0700I5Y-RBSLW 7.0" WVGA (800x480) TFT and an adapter board s=
o
> > > that it can be connected on the TFT header of Armadeus Dev boards.
> > >
> > > Cc: stable@vger.kernel.org # v4.19
> > > Reviewed-by: Rob Herring <robh@kernel.org>
> > > Signed-off-by: S=C3=A9bastien Szymanski <sebastien.szymanski@armadeus=
.com>
> > > Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> > > Link: https://patchwork.freedesktop.org/patch/msgid/20190507152713.27=
494-1-sebastien.szymanski@armadeus.com
> > > Signed-off-by: Sasha Levin <sashal@kernel.org>
> > > ---
> > >  .../display/panel/armadeus,st0700-adapt.txt   |  9 ++++++
> > >  drivers/gpu/drm/panel/panel-simple.c          | 29 +++++++++++++++++=
++
> > >  2 files changed, 38 insertions(+)
> > >  create mode 100644 Documentation/devicetree/bindings/display/panel/a=
rmadeus,st0700-adapt.txt
> >
> > Looks like a new feature, not stable material. Not sure why it got
> > tagged for stable.
>
> New device ids/tables are able to be added to stable kernels, since,
> well, forever :)

Yes I know, but I wouldn't put new panels in that category though I
guess it's just data. If we are, then you should be picking up just
about every single commit to panel-simple.c for stable.

Rob
