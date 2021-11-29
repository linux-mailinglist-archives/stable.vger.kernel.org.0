Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E431A462228
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 21:26:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231343AbhK2U31 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 15:29:27 -0500
Received: from relay.sw.ru ([185.231.240.75]:57884 "EHLO relay.sw.ru"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236511AbhK2UZj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Nov 2021 15:25:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=virtuozzo.com; s=relay; h=Content-Type:Mime-Version:Message-Id:Subject:From
        :Date; bh=B/wGc5XOMK4itRPF+xHZt+JUcNIIDxw6lCuLl6I0l1I=; b=JoSW0XuWaIq3wkK5L6K
        VA6Di02vM+iUsuCDBrOsLG4WqitOFMFXkuTqXhrsP7M/48K0ZrqRpLYRRxb1KJ2HWPBzFjAnsNJtY
        kdzoRZGnXSUudMTabXZaQPztWdMtS2D4PZp9b38NARVqQYROCdbajvvtxVZOqVkCvfPMBk2YfYs=;
Received: from [192.168.15.157] (helo=mikhalitsyn-laptop)
        by relay.sw.ru with esmtps  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <alexander.mikhalitsyn@virtuozzo.com>)
        id 1mrnAJ-001owe-1a; Mon, 29 Nov 2021 23:22:19 +0300
Date:   Mon, 29 Nov 2021 23:22:18 +0300
From:   Alexander Mikhalitsyn <alexander.mikhalitsyn@virtuozzo.com>
To:     Manfred Spraul <manfred@colorfullife.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Davidlohr Bueso <dave@stgolabs.net>,
        Andrei Vagin <avagin@gmail.com>,
        Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
        Vasily Averin <vvs@virtuozzo.com>
Subject: Re: [PATCH] shm: extend forced shm destroy to support objects from
 several IPC nses
Message-Id: <20211129232218.216a2dc322685f4516ac980b@virtuozzo.com>
In-Reply-To: <2b9bf5cd-7e65-a532-afbf-9f94c3ebb45c@colorfullife.com>
References: <163758370064179@kroah.com>
        <20211129164300.789517-1-alexander.mikhalitsyn@virtuozzo.com>
        <YaUNb9NyKVio+bQ6@kroah.com>
        <2b9bf5cd-7e65-a532-afbf-9f94c3ebb45c@colorfullife.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Nov 2021 21:12:01 +0100
Manfred Spraul <manfred@colorfullife.com> wrote:

> Hello together,

Hello!

>=20
> On 11/29/21 18:27, Greg KH wrote:
> > On Mon, Nov 29, 2021 at 07:43:00PM +0300, Alexander Mikhalitsyn wrote:
> >> For 4.4.y:
> >>
> >> Upstream commit 85b6d24646e4 ("shm: extend forced shm destroy to suppo=
rt objects from several IPC nses")
> > We need versions of this for 4.9.y, 4.14.y, and 4.19.y before I can take
> > this for 4.4.y.
>=20
> We have tried to be too clever: I had start top down, Alexander bottom=20
> up, ...
>=20
>=20
> @Alexander: I've sent 4.19.y around an hour ago. Could you create the=20
> change for 4.9. and 4.14?

Yeah. I've sent changes for 4.14 and 4.9 about 20 minutes ago ;)

>=20
>=20
> For the 4.4.y:
>=20
> Tested: With the patch applied the crash is resolved, no observed=20
> regressions.

Fantastic. Huge thanks!

>=20
> --
>=20
>  =A0=A0=A0 Manfred
>=20

Alex.
