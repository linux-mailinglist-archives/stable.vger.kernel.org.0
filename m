Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 009B32B707D
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 21:54:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727001AbgKQUxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 15:53:49 -0500
Received: from mout.gmx.net ([212.227.15.15]:50327 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726904AbgKQUxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 15:53:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1605646425;
        bh=/w8+XK1f+ns4p7L0r5PQYPFdoyqzXVUeUwEeDctF4+E=;
        h=X-UI-Sender-Class:Subject:From:To:Date:In-Reply-To:References;
        b=dA3ltg3VhKNRA2iSEvgg3yVqZikcx91DTrcJXvGlAhXPUOa7wucng4MrmE7P2Jqil
         NQQ/uIY+JTEb70pfGjFoA47Q1HEmvBbKKDYQoUVqVnkISC5FmTzPax1UZb9DYIJf65
         novbXhkBFaIGZhQj4L9ehSCPyIqiLnrdrWHtmn/I=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.100] ([185.6.149.137]) by mail.gmx.com (mrgmx005
 [212.227.17.184]) with ESMTPSA (Nemesis) id 1MiJZE-1k16jO3XXi-00fSZH; Tue, 17
 Nov 2020 21:53:45 +0100
Message-ID: <f4cb8d3de515e97d409fa5accca4e9965036bdb5.camel@gmx.com>
Subject: Suggestion: Lengthen the review period for stable releases from 48
 hours to 7 days.
From:   Hussam Al-Tayeb <ht990332@gmx.com>
To:     Pavel Machek <pavel@ucw.cz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Date:   Tue, 17 Nov 2020 22:53:41 +0200
In-Reply-To: <20201117080141.GA6275@amd>
References: <17c526d0c5f8ed8584f7bee9afe1b73753d1c70b.camel@gmx.com>
         <20201117080141.GA6275@amd>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:v3Dmkr/D1OYqhQnFDADyB24Jy+TixN5njZcrd41Q0umiCtj+LLH
 Ks7G/XtTBGfSmB2m3zpIf5Se1ULo0Z4JnFqrLzmnmf4aw0uRbra5IZpjfYjed3KYe76idwW
 tzUUkpC7P7SK599ZKWCKn+lXa7EVvUvlbda3SQRBU+84R341UxGm4qa149mzQiHc46QoAZ6
 DnDc1VfzTMu691YgykqaQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:jTdLM88MxnY=:vDiBDpp0nscSvKKT29Ugn/
 DwhJsZAq/tKwD8TdXMfkl87zdX4fwtIdObZixEfL/xholVNt7cs2iSG6F4u2Z3dULlcp3ry5m
 8Ecrmd6yzU5v8M4dtYd0Ib0AVazPB8AO69ZhsGAM2A/TKhzddUuD/6NmhevAnwnl2cZVOHLUY
 Sqci9jwr0tYgg45S60p3Scf8VmUpE1xg/d+9qio4xD5DJLtO1Eykvrg5uJBlRpRAlwyToIMG1
 5F0t/xuLRgRSgHh+Xi84mYFMFBx2gOR5rY05s0i7TS+rawmsYpjL1Yg2sM7WiYt3NQ8AmV8kc
 m2HdLNjAv+Hh0TWpayXVL7YThG0jm18DNTO1VGRY4NLHzEKKSvKF+X00jgx075/p7FE53Nzmi
 hQ7ZyRDPzhigmaUc9ZyObOSsDOSDgERlqk9b1J1GSo3h8hMeGpzXKkNVL21O4RjRv3SFvIj56
 uXJpCJMzBGdiPwvazOPW/u0oCjQs4do6K84xF7h52cBg1CHzFpJHoOnhZnhAGk7+3jslpowAZ
 OfEs9vD94tH0QJai+G9ocqKPbE0GLMnllMu9YkoZlUB4MrBekHLZU8iq4oLu7XNbQ8HYv2nkQ
 jIG8FBcDc9W36i06Enkc06z1FScMS7Ooq3jS4GTkczdS2VglvHLxkdYpl8gXZbxLtq1H3pQEM
 YEshcQqlOXFrbccgG/W4bj/DbFRZDVRI5sTmL8wFK5T4ufAUsOd7gN2Kizmhv0J328pWJfA14
 fWqnuBGeUW0XZVDz0PZuW2Ungu1jUWgx75MCQbsiXteyGA/iv0spo/GKcKrIuHrOtw2QcosGp
 hnu69MCfE2hYYwyxJFht7TZdhSK8gq0o83wkaobMc6dgMziDK94Lq0XXUnIWrbUUPRDcueaaK
 9zptBzsbx9/bz29gc/fstLO6m6bPRYc84LYcP/yd8=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please CC me in any replies as I am not subscribed to the list.
This is a legitimate request as I often need more than two days
especially on busy work days or weekends.
On Tue, 2020-11-17 at 09:01 +0100, Pavel Machek wrote:
> On Sat 2020-11-14 17:40:36, Hussam Al-Tayeb wrote:
> > Hello. I would like to suggest lengthening the review period for
> > stable
> > releases from 48 hours to 7 days.
> > The rationale is that 48 hours is not enough for people to test
> > those
> > stable releases and make sure there are no regressions for
> > particular
> > workflows.
>
> You should probably cc stable list and Greg with this.
>
> And yes, I believe that would be good idea.
>
> Plus the period is very often shorter than advertised, which might be
> also good to fix.
>
> Best regards,
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0pavel
>



