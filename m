Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9A22328E9C5
	for <lists+stable@lfdr.de>; Thu, 15 Oct 2020 03:18:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732087AbgJOBSA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Oct 2020 21:18:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729250AbgJOBR7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Oct 2020 21:17:59 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3EBEC045708
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 18:17:58 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id h9so887812ybm.4
        for <stable@vger.kernel.org>; Wed, 14 Oct 2020 18:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=+j8uoFEWllXPeORf0RiURPbL+y5clmU4W4DGg56XlZg=;
        b=TmKxEJAPESBUMLCz7374faqEk94WdWhKhklOhYBlQRtclGMC0KfoS8rFndyB989CPu
         Xk5H3HPgQM5UkKvkWwpSOp41+WW6Qc+S1qvXdPsnBY0WU1Ww6CreZwGkjgm+U9F6yURo
         rcYMG2ZvB4FsRLKRA3rzuUSRm7CUYeJMKqL0zgR0Q+uIIQnPrv5HIP0qq5tQGuoNFzjO
         MHHb5bjkVZCmbzwOeOXhDtMIa+NorT7Xu1EQv3MUeyqnBy7EGVEIAySdveg+NbcM7LTi
         q7UVBSN+ZHSsDLJi2dXC5JsFD/9l6sbFh8x38n5nx+tpRCCMza/R5ndEWBDzjoy7UgH0
         dTBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=+j8uoFEWllXPeORf0RiURPbL+y5clmU4W4DGg56XlZg=;
        b=CMDWYKE13syr1RZwDTBwrbIm9GWQKcGr8VMliF83BnGD+k0NV0O9oUebasP6wxpozH
         SczgoL68uXS/2EdvSb5FMSQJh1SF5YkY7CC/qUO20YIqCSA/f2upjwxQKokDFRzl3T+s
         R0Ia770Q/NB+dHdrt0ZaPvdITuFoLpMXgRU+ZSblRO7G702Ke/8cCK2PvAYwqXg6tZr6
         6xTg23KbSs9sVjd/isMPDI/6O7i+BjDxotalDkLoR0WEYuaBBkwc25daLJdiFWdfNNKB
         X/TkDCCkz1EQitxBMH8Ge2EaufAHbcB4gqK1dvRqZCktnM5jUIj3ERCQPDzOUNOUi8Y/
         qktQ==
X-Gm-Message-State: AOAM5317PnqAQ43Z3CCJNa5pn40KQp7eSYSNJsLftuR1kegCUrqKufsz
        6u0T7wRszQ8J+uvaa/3GjnISUsLgQv7W/6MMw4Y=
X-Google-Smtp-Source: ABdhPJxjScjh8UfoiBRZDFgqNgcux977IjNlRw/GXx3Mi5d7kusPlCahB+Pw7auxu0CjbLM0syzpyqZWC4KpPCaHVsQ=
X-Received: by 2002:a25:d105:: with SMTP id i5mr2182713ybg.6.1602724678209;
 Wed, 14 Oct 2020 18:17:58 -0700 (PDT)
MIME-Version: 1.0
References: <20201013074600.9784-1-benchuanggli@gmail.com> <20201013080105.GA1681211@kroah.com>
 <CACT4zj8xjeRFnXekojFseHUTqouRwCwmXsCFVMWA+jhnW-DaDQ@mail.gmail.com>
 <20201013085806.GB1681211@kroah.com> <CACT4zj-ShpspM0PNA_Q4fkEAubiTfp_rxcZ6FkQgcKoYx7WaNA@mail.gmail.com>
 <20201013134849.GA1968052@kroah.com> <CACT4zj8GW57Ugaaade5BnAeHgo15uf=zbmYNJhxwBygevXLW3g@mail.gmail.com>
 <20201014081119.GA3009479@kroah.com> <CACT4zj_uS+Ziip0EZa32+PGVLC0ZP7+=MbovrUR+rCwe6r5_4Q@mail.gmail.com>
 <20201014113749.GA3679515@kroah.com>
In-Reply-To: <20201014113749.GA3679515@kroah.com>
From:   Ben Chuang <benchuanggli@gmail.com>
Date:   Thu, 15 Oct 2020 09:17:46 +0800
Message-ID: <CACT4zj_fOGjUjj0+BKTZoi+jzy2=wUq4woqbRXMrpOQ+8yWNKg@mail.gmail.com>
Subject: Re: [PATCH] mmc: sdhci-pci-gli: Set SDR104's clock to 205MHz and
 enable SSC for GL975x
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     sashal@kernel.org, stable@vger.kernel.org,
        Ben Chuang <ben.chuang@genesyslogic.com.tw>,
        greg.tu@genesyslogic.com.tw, seanhy.chen@genesyslogic.com.tw,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, Greg,

On Wed, Oct 14, 2020 at 7:37 PM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Oct 14, 2020 at 06:42:06PM +0800, Ben Chuang wrote:
> > Hi Greg,
> >
> > On Wed, Oct 14, 2020 at 4:10 PM Greg KH <gregkh@linuxfoundation.org> wr=
ote:
> > >
> > > On Wed, Oct 14, 2020 at 04:00:49PM +0800, Ben Chuang wrote:
> > > > Hi Greg,
> > > >
> > > > On Tue, Oct 13, 2020 at 9:48 PM Greg KH <gregkh@linuxfoundation.org=
> wrote:
> > > > >
> > > > > On Tue, Oct 13, 2020 at 07:11:13PM +0800, Ben Chuang wrote:
> > > > > > On Tue, Oct 13, 2020 at 4:57 PM Greg KH <gregkh@linuxfoundation=
.org> wrote:
> > > > > > >
> > > > > > > On Tue, Oct 13, 2020 at 04:33:38PM +0800, Ben Chuang wrote:
> > > > > > > > On Tue, Oct 13, 2020 at 4:00 PM Greg KH <gregkh@linuxfounda=
tion.org> wrote:
> > > > > > > > >
> > > > > > > > > On Tue, Oct 13, 2020 at 03:46:00PM +0800, Ben Chuang wrot=
e:
> > > > > > > > > > From: Ben Chuang <ben.chuang@genesyslogic.com.tw>
> > > > > > > > > >
> > > > > > > > > > commit 786d33c887e15061ff95942db68fe5c6ca98e5fc upstrea=
m.
> > > > > > > > > >
> > > > > > > > > > Set SDR104's clock to 205MHz and enable SSC for GL9750 =
and GL9755
> > > > > > > > > >
> > > > > > > > > > Signed-off-by: Ben Chuang <ben.chuang@genesyslogic.com.=
tw>
> > > > > > > > > > Link: https://lore.kernel.org/r/20200717033350.13006-1-=
benchuanggli@gmail.com
> > > > > > > > > > Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> > > > > > > > > > Cc: <stable@vger.kernel.org> # 5.4.x
> > > > > > > > > > ---
> > > > > > > > > > Hi Greg and Sasha,
> > > > > > > > > >
> > > > > > > > > > The patch is to improve the EMI of the hardware.
> > > > > > > > > > So it should be also required for some hardware devices=
 using the v5.4.
> > > > > > > > > > Please tell me if have other questions.
> > > > > > > > >
> > > > > > > > > This looks like a "add support for new hardware" type of =
patch, right?
> > > > > > > >
> > > > > > > > No, this is for a mass production hardware.
> > > > > > >
> > > > > > > That does not make sense, sorry.
> > > > > > >
> > > > > > > Is this a bug that is being fixed, did the hardware work prop=
erly before
> > > > > > > 5.4 and now it does not?  Or has it never worked properly and=
 5.9 is the
> > > > > > > first kernel that it now works on?
> > > > > >
> > > > > > It seems there is misunderstanding regarding =E2=80=9Chardware=
=E2=80=9D means.
> > > > > > I originally thought that the "hardware" refers to GL975x chips=
.
> > > > > >
> > > > > > This Genesys patch is to fix the EMI problem for GL975x control=
ler on a system.
> > > > >
> > > > > Did it work on the 4.19 kernel?  Another older kernel?  Or is 5.9=
 the
> > > > > first kernel release where it works?
> > > >
> > > > The patch works on after v5.4.
> > >
> > > You are not answering the question I am trying to ask.
> > >
> > > My question is:
> > >         Did this hardware ever work properly before the 5.9 kernel
> > >         release.
> >
> > Yes.
>
> It did?  What kernel release from kernel.org did it work, and what
> kernel release did it break on?

Sorry, I don't know if  "this Hardware" refers to a single GL975x
controller or the whole system.
"Yes", for those existing systems built in GL975x controller. These
systems are no EMI issue on v5.4~v5.9.

"No", for some systems with developing stage build in GL975x
controller because there may be an EMI issue.
For those systems, they need the v5.9 to pass the EMI test.

>
> > > > > In other words, is this fixing a regression, or just enabling har=
dware
> > > > > support for something that has never worked before for this hardw=
are?
> > > >
> > > > This patch is to reduce the EMI at SDR104 mode for GL975x.
> > > > It changes the preset frequency of SDR104 to 205Mhz and sets the SS=
C value.
> > > > So I think it is fixing a regression.
> > >
> > > A regression is when an older kernel works fine, but a newer kernel d=
oes
> > > not.  When that happens, you can point to a specific commit and say,
> > > "this commit here broke this previously working hardware".
> > >
> > > Is that the case here?  If not, this is not a regression.
> >
> > With this definition, no.
>
> Wait, I do not understand, this is the exact oposite of what you said
> above.
>
> Which is true?

These existing systems built with GL975x have no EMI problems.
The patch can reduce the impact of EMI, so these existing systems are still=
 ok.

For these existing systems, on an older kernel (v5.4) they work fine
(no EMI issue), on a newer kernel (v5.9) they work fine (no EMI
issue).
For those developing systems, on an older kernel (v5.4) they don't
work fine (EMI issue), on a newer kernel (v5.9) they work fine(no EMI
issue).

>
> totally confused,

If you are still confused, please let me know. :).

Best regards,
Ben

>
> greg k-h
