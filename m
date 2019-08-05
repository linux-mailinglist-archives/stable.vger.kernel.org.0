Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6A5F818A7
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 14:00:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbfHEMAd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 08:00:33 -0400
Received: from mout.gmx.net ([212.227.15.18]:53083 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727349AbfHEMAd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Aug 2019 08:00:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1565006431;
        bh=+SEcsacXGngFRkwZyyIPdyTaT0xrgG+iTarq/0msyEY=;
        h=X-UI-Sender-Class:From:To:Cc:Subject:Date:In-Reply-To:References;
        b=OkxMFFc54bRCnzpNJi0aF6bFw0dvcz+NaP5Enp4E8YVBK5LYFBXSKAsohZOA+qE05
         dQd4Jt6gj9kMPFTAUquzlIST7DfFW/2+x/HbutOU3UFrfwykMn7APIdcApFrYKZ/QB
         TmVb1Fkudaj7nCrYBZxoFPorlUuHEtBvuv+bM1I8=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [193.16.224.11] ([193.16.224.11]) by web-mail.gmx.net
 (3c-app-gmx-bs20.server.lan [172.19.170.72]) (via HTTP); Mon, 5 Aug 2019
 14:00:31 +0200
MIME-Version: 1.0
Message-ID: <trinity-7b912746-02d0-4a32-8e6a-95f3e3d07f93-1565006431207@3c-app-gmx-bs20>
From:   "Helge Deller" <deller@gmx.de>
To:     "Sven Schnelle" <svens@stackframe.org>
Cc:     "Greg KH" <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Subject: Aw: Re: FAILED: patch "[PATCH] parisc: fix race condition in
 patching code" failed to apply to 5.2-stable tree
Content-Type: text/plain; charset=UTF-8
Date:   Mon, 5 Aug 2019 14:00:31 +0200
Importance: normal
Sensitivity: Normal
In-Reply-To: <20190805111233.GB10502@t470p.stackframe.org>
References: <1564983055189121@kroah.com>
 <20190805074524.GA10502@t470p.stackframe.org>
 <20190805105701.GA1157@kroah.com>
 <20190805111233.GB10502@t470p.stackframe.org>
X-UI-Message-Type: mail
X-Priority: 3
X-Provags-ID: V03:K1:qhAHG/qsPJ5MW5q8KJux1xH4v5lWTBXHo7Ki3Yo3ATKYKM/gaIPOTfQI/nN0p0WyQy0e2
 tJZauMvba9zvqo70yUOEMtMmGZYrs6Sj9VS+Xe+G6t55dgN4NPRfyRjqAmUvYyjqx20UwKUxC4W5
 axW+OnTX/WBzRlIoeduP5tzbtfc20hfhv1nxw632W2T59lqbddGxMrxckc49jyAazN75fQac4LVo
 xSh1guM/QlAnx9zy4sgETIZmLkSrxmkGA0FCTZpt1xqjMp7bRLv0rG43KSbmhMNrdfpr7JD6wqJu
 Vc=
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:xo0C/8x5w3I=:H18DVi/MxzQYzGSp/srGRw
 //37SB3fg0R68F2OsYO/DUBpWevPjeWoJNFRHP59DTPLriaMMuIcRMPZpVlXYQKYZVf9dIf1x
 XuNSz4BiE4c7nTeJMqkgP4597H3OO1hxsrA2wIB7srgcsEnYRQ+QbJk2egF/pWgzVIT1cl3P0
 1dhgazJHTsTvW5q0APa2qaWrh2DLIrvfXzkRuLyBkvfNGU4ttku4/7beKiGjiTMwNH6D2Naym
 WtrEpOwvJ4TtQVElNeSQAOdvPAGGWyBo4+ba3yKstI7CtV0IFpv3VRA2ywoFdz2xTgLZxohW3
 r7FKCC4Yew4RsnTqgV+AunOj8yHL949Tg56xrJMG6zd/IsyF4RNVcperf+TJI4BK4P8VU2zQn
 9KinEC1LwXp7OjwSZVnmroA2gUbC7yGV29+VFtul2AnSQnb9hvDg+HMKgX/kBQ59EB9985hkw
 t8QTh3+TWdL4K/TnXKXHe2NQlBNoc/OfjGbiKdmBhHxldr8IMui5zjpJ0fn1R0neUxG/UGMC3
 a7ozCfV84NVwAlXUvQ+T/AYMTqIxpCaVNRkNJ+KTFBIF/3xHAYtg8wtBxLTXxoMtw85cmklje
 6EsUTW3JN1SnUOhCADGrY4Qxe0dy9WVeGpsGg2oLyr7F0C/k1+sfqlmmaApxqaHlUVGjVyxST
 dMFM0KPWj80K7woa2deMAVnIQ
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> On Mon, Aug 05, 2019 at 12:57:01PM +0200, Greg KH wrote:
> > On Mon, Aug 05, 2019 at 09:45:24AM +0200, Sven Schnelle wrote:
> > > On Mon, Aug 05, 2019 at 07:30:55AM +0200, gregkh@linuxfoundation.org=
 wrote:
> > > >
> > > > The patch below does not apply to the 5.2-stable tree.
> > > > If someone wants it applied there, or to any other stable or longt=
erm
> > > > tree, then please email the backport, including the original git c=
ommit
> > > > id to <stable@vger.kernel.org>.
> > >
> > > The reason is that 5.2 doesn't have DYNAMIC_FTRACE suport, so this c=
an be
> > > ignored.
> >
> > Then why did the patch have:
> > 	    Cc: <stable@vger.kernel.org> # 5.2+
> > in it?
>
> My Fault. Helge asked me whether this patch should be added to 5.2 stabl=
e,
> and i said "yes", assuming that DYNAMIC_FTRACE for PA-RISC is already in
> Linux-5.2, which isn't the case. It got merged in 5.3.

Greg, It's actually my fault.
I did asked Sven, but usually I do test if the patches apply cleanly too.
So either I did missed that testing for this patch, or something else must=
 have
been wrong on my side.
Sorry for that.
Helge
