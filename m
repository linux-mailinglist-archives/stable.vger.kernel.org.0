Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F04A812EA4F
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 20:25:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728285AbgABTZw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 14:25:52 -0500
Received: from mout.kundenserver.de ([217.72.192.75]:49243 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727951AbgABTZv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Jan 2020 14:25:51 -0500
Received: from mail-qt1-f174.google.com ([209.85.160.174]) by
 mrelayeu.kundenserver.de (mreue107 [212.227.15.145]) with ESMTPSA (Nemesis)
 id 1Mo7eX-1jXDHB0gfb-00pbmX; Thu, 02 Jan 2020 20:25:50 +0100
Received: by mail-qt1-f174.google.com with SMTP id t3so35345745qtr.11;
        Thu, 02 Jan 2020 11:25:49 -0800 (PST)
X-Gm-Message-State: APjAAAVO9w1i2ylXUgZFUyIU4lmjrb2RQCORC3fA88ekW/YCh70h4JAA
        89b48pg8DGrKtn2T+QmB9HdpYCpihJuxMV0Z3+E=
X-Google-Smtp-Source: APXvYqzNOUcAjBgOm/nzWYpzz4pDGlCxDb5jInGBEYDjpXkYEXeZpOmcxv95mHE+PF1z0cHjwhWvI+pXUUl/cP5++xQ=
X-Received: by 2002:ac8:3a27:: with SMTP id w36mr60002412qte.204.1577993148979;
 Thu, 02 Jan 2020 11:25:48 -0800 (PST)
MIME-Version: 1.0
References: <20200102172413.654385-1-amanieu@gmail.com> <20200102172413.654385-2-amanieu@gmail.com>
 <20200102175011.q7afo45nc2togtfh@wittgenstein>
In-Reply-To: <20200102175011.q7afo45nc2togtfh@wittgenstein>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 2 Jan 2020 20:25:32 +0100
X-Gmail-Original-Message-ID: <CAK8P3a3a88e=hkzYG5mj=NuVQWMtyougkKzBznnn2y9ZoZfEGg@mail.gmail.com>
Message-ID: <CAK8P3a3a88e=hkzYG5mj=NuVQWMtyougkKzBznnn2y9ZoZfEGg@mail.gmail.com>
Subject: Re: [PATCH 1/7] arm64: Move __ARCH_WANT_SYS_CLONE3 definition to uapi headers
To:     Christian Brauner <christian.brauner@ubuntu.com>
Cc:     "Amanieu d'Antras" <amanieu@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Christian Brauner <christian@brauner.io>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:uikzFKKOz5sh1PuuLdZ0BYZtO7xoi7M+CglaD7a7dwgHy6df+Bg
 qlj/WiO1r4ddKGMkGhzQHo7IWadHxuA7YGVrvxgcERLH9cDW0Gnw3puGsUnn4HqKbMW5/nk
 h8V64aOFGoSYVTokbVCj2KzXtra7Y+JiaU8RG2hQXbpnbRezts34O5D23d22A4G+pg96ATG
 bXvTFU3nZtUnQoVhMU8Sg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:DQG0maNFftM=:+ICCGXpV5oD9XLji2cGSa+
 jBYlQR/vkGy20epc/v18K1ol0shcoGtWmAteiaGv1RS9Ci7cQ2x7hhkS8ZqyWz9bfEoZDThf+
 wdNlUfeqmXB9ecFpIbv5bNSjL5Fc57wWvPIfBwxrDhvsvs60HNosUHpXPLbYOSPWWhecN9r+0
 E3JeCUeyibixHzZxTlg3idVBVTmI6urd9TTT36QGibdvViqbiaPW1OZ3+TS5+25bRMpgo/mi5
 LV91m1ERNyu9wr8/a/VcdtWrPJHHma8sMemfZ1AK0TXYUhhDpOkW9clKMgg5JJuUK4o5WTSub
 D7Naae0PxK/Jk2oVM3NKjyyb4ATvjOcx4Wt1Gj3sN2uMW81v9PqMDazamb66HTHuJ5895xy8d
 DD8eWst9HuaH52ysHTOns9gwk2DVNsvYJDtrlfG3GE5zy5ID1feZGaiOiB3VocnK/V//2Sb15
 /5lJuepP3x650RLZoEN5f3XedEeQUHULWtPyVBl7bXbQQnX9/n7Dt5lsel8z4dARdkGzArqYh
 1+eRkOjBYyw7AKp9LChm5tGyqjt7xTE4eovPQlpIDW58+HdyRkheyVEr0MdXH9kqhoHiB5UqE
 zoSSedimS6mpk1yFMyshviq965pFZ/gXu2l8W+dsLw8HOgZvSOZEAvGlskKBKB3ozqu5M1S3i
 uX3JJh5XbMeuvK4Kns9lO74Gzvgx6sJpWucdesyUcOxmGNXGz6YnuslaGL9ohJtCf2rwM5PSE
 5OkTb6M5l4xqF14UUx0nJEBQOhocEosu6Lww7q5GUsNaSJ6LoRT1Ysgk65K/ATpm9oA964/Dk
 litVE1VuqWXSCzEBsxSOzaPXl1W/USdaL44adu0Gt2O99Be0t5XNG9v1uVNmy3HcLGnlw7Ilq
 qSGbyg/LOUzL3lNmqQZA==
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 2, 2020 at 6:50 PM Christian Brauner
<christian.brauner@ubuntu.com> wrote:
> On Thu, Jan 02, 2020 at 06:24:07PM +0100, Amanieu d'Antras wrote:
> > Previously this was only defined in the internal headers which
> > resulted in __NR_clone3 not being defined in the user headers.
> >
> > Signed-off-by: Amanieu d'Antras <amanieu@gmail.com>
> > Cc: linux-arm-kernel@lists.infradead.org
> > Cc: <stable@vger.kernel.org> # 5.3.x
> > ---
> >  arch/arm64/include/asm/unistd.h      | 1 -
> >  arch/arm64/include/uapi/asm/unistd.h | 1 +
> >  2 files changed, 1 insertion(+), 1 deletion(-)

Good catch, this is clearly needed, but please make the patch change
every copy of asm/unistd.h that defines this, not just the arm64 one.

       Arnd
