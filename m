Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0189F319347
	for <lists+stable@lfdr.de>; Thu, 11 Feb 2021 20:43:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231363AbhBKTmm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Feb 2021 14:42:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbhBKTml (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 11 Feb 2021 14:42:41 -0500
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0F9C061574
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 11:42:01 -0800 (PST)
Received: by mail-wr1-x429.google.com with SMTP id v14so5331641wro.7
        for <stable@vger.kernel.org>; Thu, 11 Feb 2021 11:42:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=lmsybsenYLv4IXs9/t3wu7SDRRf7VrEN3GD12+auvHA=;
        b=l/6lw5ITOQ4Lf2ujeSWb130jEoZc19g316nYON89+HjTd8QH2MEi3kS+iK9MGGgB1O
         xm6PH9bdjw6Vy2oQqB6ApHd2bOqmfeXBoxOjsuU0AtMqHWTdR8J0WdU0DZoNPRkVMTCG
         r+vnA4XUJ89pd8c50ahWlb10WOvazfmy9/wXRit84z3y79cOnLgx7WedvUgxLJOoWy21
         mJjuKFz23TDAKiyJ3kHgMSP0Rr6M1TF6a5wX0yTPYRqB7Y2d81622NAVDMMhK+pOwsQT
         60Bx7Oxy/X5fX4BJYtL3/64IYNfsvUwQnPhQM78TT5uHE0QV6Uw4i3Lxh30dgJQdAhyj
         a94A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=lmsybsenYLv4IXs9/t3wu7SDRRf7VrEN3GD12+auvHA=;
        b=au/cL/0gODwtvSiy+1BI7P43c5TpqGEL14D0uv2WNev36P/01+oDuLI01C3prFd7K/
         CyZpEdQywXinrEMdLYY/gnJR/BQXFR7i5SyRCJaZtJWIEEyyviQ6sFOp/ysWnZo51eF/
         F7SeulOMkUz3H6IKmB0pd6sMgx3/yRZvU21ukL8QjZPhChMMegb2+uLrrvmFNAphMfl/
         aS9oFR7jFgVZAwTrfO6mK2zgzYBEzsKIcBEDgRpTi+h6o5RaBW5C7nwrfFDD8DbH/OAK
         T1om1aYtcGqblvuXQXfK1SxEeRZJK3IHzudI39/rzBBbYNX/Sf6nsJ2jIOC51m/1zuBk
         dw+A==
X-Gm-Message-State: AOAM533EJ7k9yp1jaQechtc2J5gx+q9BkY6hpmyMmLWVcBACL378+jve
        m5oLsquPwaS0mIrWKJEM4IznT/n7TBMCFSeU7HI=
X-Google-Smtp-Source: ABdhPJy2jDc5MzHxm8ISEMaZKL7pMze4vW+tsg/kpOkfIDctyV5iu/U4vWqcyDZ1SNLeowuZoVWJcPRgqD08Xyq4CEE=
X-Received: by 2002:a5d:4ecf:: with SMTP id s15mr2312637wrv.132.1613072519839;
 Thu, 11 Feb 2021 11:41:59 -0800 (PST)
MIME-Version: 1.0
References: <CAEvUa7mYi9J6qUbnUJi9=_+AXeXOopYJkZb+Z4CD9enGEQaFBQ@mail.gmail.com>
 <YCI39srMrc8dmL+p@kroah.com> <CAEvUa7nBGwManydNPKFqVXQUugsDzx19nPv4Y2BaxrEqe6jFww@mail.gmail.com>
 <90159c33-4ba7-038d-48d7-2722e5a6513a@csgroup.eu>
In-Reply-To: <90159c33-4ba7-038d-48d7-2722e5a6513a@csgroup.eu>
From:   David Michael <fedora.dm0@gmail.com>
Date:   Thu, 11 Feb 2021 14:41:48 -0500
Message-ID: <CAEvUa7nbRnNXy6vSLybZqe6pr+MAqBCfBMbLuo0EZhbNCAuRvA@mail.gmail.com>
Subject: Re: Reporting stable build failure from commit bca9ca
To:     Christophe Leroy <christophe.leroy@csgroup.eu>
Cc:     Greg KH <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        mpe@ellerman.id.au
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 11, 2021 at 2:28 PM Christophe Leroy
<christophe.leroy@csgroup.eu> wrote:
> Le 11/02/2021 =C3=A0 19:18, David Michael a =C3=A9crit :
> > On Tue, Feb 9, 2021 at 2:21 AM Greg KH <gregkh@linuxfoundation.org> wro=
te:
> >> On Mon, Feb 08, 2021 at 04:14:44PM -0500, David Michael wrote:
> >>> Commit bca9ca[0] causes a build failure while building for a G4 syste=
m
> >>> since 5.10.8:
> >>>
> >>> arch/powerpc/kernel/head_book3s_32.S: Assembler messages:
> >>> arch/powerpc/kernel/head_book3s_32.S:296: Error: attempt to move .org=
 backwards
> >>> make[2]: *** [scripts/Makefile.build:360:
> >>> arch/powerpc/kernel/head_book3s_32.o] Error 1
> >>>
> >>> Reverting the commit allows it to build.  I've uploaded the config[1]=
,
> >>> but let me know if you need other information.
> >>
> >> Do you also have the same build failure in Linus's tree with this comm=
it
> >> in it?  And why not cc: the authors of the offending patch?
> >
> > No, 5.11-rc7 builds correctly with the same
> > https://dpaste.com/7SZMWCU89.txt olddefconfiged.  I've CCed the commit
> > authors.
>
> Should be fixed by following commit:
>
> https://git.kernel.org/pub/scm/linux/kernel/git/powerpc/linux.git/commit/=
?h=3Dnext&id=3D3642eb21256a317ac14e9ed560242c6d20cf06d9

Yes, that fixed the build after editing it to apply to head_32.h in
the 5.10 branch.

Thanks.

David
