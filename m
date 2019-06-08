Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A896B3A1F3
	for <lists+stable@lfdr.de>; Sat,  8 Jun 2019 22:25:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727458AbfFHUZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Jun 2019 16:25:51 -0400
Received: from outils.crapouillou.net ([89.234.176.41]:36838 "EHLO
        crapouillou.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727441AbfFHUZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 8 Jun 2019 16:25:51 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=crapouillou.net;
        s=mail; t=1560025547; h=from:from:sender:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=sVuie0i+O6QumI4fxz1lwMyw0K1NW33v7RQ/G9+QcOY=;
        b=eZktlGB4bEv2OsIKeJ8zCnEi9ZX0dUuDWdsU6HAu7vXNIN/yMSrLw43iWQkKf4dW2D6k4f
        JO6kyD/XvzPfy1J8yYqHxmjHQye5ZVxoPsR+FBxjR7b4QyFXIrXmSEYpXasc05N0gUSza8
        CbZfceKLYnDPyAct/edV4qqoMlEiuNU=
Date:   Sat, 08 Jun 2019 22:25:41 +0200
From:   Paul Cercueil <paul@crapouillou.net>
Subject: Re: [PATCH] MIPS: lb60: Fix pin mappings
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paul.burton@mips.com>,
        James Hogan <jhogan@kernel.org>, od@zcrc.me,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Message-Id: <1560025541.1815.11@crapouillou.net>
In-Reply-To: <CACRpkdbKWC7ULFjN1c5axg5FBeeWWXCsbbQi2ks4+5tg07Br-g@mail.gmail.com>
References: <20190604163311.19059-1-paul@crapouillou.net>
        <CACRpkdbKg22OyViYhXS=Vyps=2zQ_dmm23Xr8+dBp+uwwjheuQ@mail.gmail.com>
        <1559988846.1815.1@crapouillou.net>
        <CACRpkdbKWC7ULFjN1c5axg5FBeeWWXCsbbQi2ks4+5tg07Br-g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Le sam. 8 juin 2019 =E0 15:39, Linus Walleij <linus.walleij@linaro.org>=20
a =E9crit :
> On Sat, Jun 8, 2019 at 12:14 PM Paul Cercueil <paul@crapouillou.net>=20
> wrote:
>>  Le sam. 8 juin 2019 =E0 0:10, Linus Walleij=20
>> <linus.walleij@linaro.org> a
>>  =E9crit :
>>  > On Tue, Jun 4, 2019 at 6:34 PM Paul Cercueil=20
>> <paul@crapouillou.net>
>>  > wrote:
>>  >
>>  >>  The pin mappings introduced in commit 636f8ba67fb6
>>  >>  ("MIPS: JZ4740: Qi LB60: Add pinctrl configuration for several
>>  >> drivers")
>>  >>  are completely wrong. The pinctrl driver name is incorrect, and=20
>> the
>>  >>  function and group fields are swapped.
>>  >>
>>  >>  Fixes: 636f8ba67fb6 ("MIPS: JZ4740: Qi LB60: Add pinctrl
>>  >> configuration for several drivers")
>>  >>  Cc: <stable@vger.kernel.org>
>>  >>  Signed-off-by: Paul Cercueil <paul@crapouillou.net>
>>  >
>>  > Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
>>  >
>>  > Such things happen. Are you planning to phase all the board files=20
>> over
>>  > to use devicetree eventually?
>>=20
>>  Yes, that's definitely what's planned; right now the blockers are
>>  patchsets [1] and [2]. [1] is ignored by everybody because there's=20
>> no
>>  maintainer for drivers/memory/. [2] is a year-long effort that still
>>  doesn't show me the light at the end of the tunnel.
>>=20
>>  [1] https://lkml.org/lkml/2019/6/4/743
>>  [2] https://lkml.org/lkml/2019/5/21/679
>=20
> What? That's unacceptable, the last resort is usually to send the
> patches to Andrew Morton (whether fair or not) when nothing gets
> applied.
>=20
> In this case I would however encourage the MIPS maintainer to
> simply queue this stuff in the MIPS tree as blocking his arch work
> if not merged, Ralf would you consider just queueing this?
> I do not think the other Linus would mind.

It's not that critical - it's not blocking until [2] gets merged too.
But yes, it's been sitting idle for a while.

> Yours,
> Linus Walleij

=

