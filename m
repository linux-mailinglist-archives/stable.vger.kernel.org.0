Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14EBA71592
	for <lists+stable@lfdr.de>; Tue, 23 Jul 2019 11:59:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfGWJ73 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jul 2019 05:59:29 -0400
Received: from mail-lf1-f49.google.com ([209.85.167.49]:46728 "EHLO
        mail-lf1-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbfGWJ73 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Jul 2019 05:59:29 -0400
Received: by mail-lf1-f49.google.com with SMTP id z15so24622117lfh.13
        for <stable@vger.kernel.org>; Tue, 23 Jul 2019 02:59:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=ETFW6Fmjh+yKsfkXMz8hHoIGGXFJIjay9nWq20ZxFRc=;
        b=Lkk08MqCFX83Hok1COdpBqsdxNZQMTBd0iPajmr61+oRmINV3kEn7yir63sHCZfJ0p
         Fz741Z7/uQYhTX5xh+HaaWr9QH3P44+LhnYbsYoMPGXTgWcnPem2/Ip6LtUs50nvtXaB
         tmHyPO6GbbBNiIYjGTs/AJ9TUreBe7PeHukV2BlVz933SUj/WJL5MYnQwhMZKsxw5WRJ
         TUky45j082KIiRZ6K2ybSr5H3LDwKRnvqwyVLF+YZMzVMOkZhJHk5xJznGOPDJrLB73e
         gQv5nTe+YKrNrcBKlLNPGDl/bSep1a/DSlO7r6++1mA0QZIF5DToW4FRfmn3TeC1H+sH
         858g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=ETFW6Fmjh+yKsfkXMz8hHoIGGXFJIjay9nWq20ZxFRc=;
        b=AXHiX2voYDkevjm07WHgDPr29Km6Ybp29ZvaMvosALGkrQ0YObJW1IViHc2BDk72R0
         hgxg2S8szfhuF0pDqxShIVkJtR355mOUGGJzbmJWz8A0Ho7SeXEtnKc0TEMwaDFOhMoi
         LdwnAeZYUpt6XpwiToxrj1CW3Aa7PHpbAjY+qzt5VY1mrl3TtfBu7A63dm7qJ6U4eoZY
         DJ0WppXd8jq6jx9RxUfQ1XchHyrO0ecK8liOsdW31MjnhrWkrLGa8y1w07yAayIaoBV3
         /Vcr0I/OAsdVimMmW5XFTYyuHSDfCGwMAUSUrVrPJbrwQQylLRKuQ9QUKb2MIFRz9Zla
         PsMA==
X-Gm-Message-State: APjAAAU8NnW2V8MFX8qzofh1wL4CC+lMv+F8/de2ObVQh9y7FMmb5WaA
        syMN2O7Z7I/4MsV4tG9R3fZFXIXTwODRJ6hO7YE=
X-Google-Smtp-Source: APXvYqzD1Vmn0POlFbvLTJhXPkaawAolYho/B4Mz/1CQA9OKg1ypldBoFR8zdktEEPnjqu9pG7/1sZhiQjfuGz280io=
X-Received: by 2002:ac2:4644:: with SMTP id s4mr34233863lfo.158.1563875967221;
 Tue, 23 Jul 2019 02:59:27 -0700 (PDT)
MIME-Version: 1.0
References: <20190722130313.18562-1-jinpuwang@gmail.com> <20190722154239.GH1607@sasha-vm>
In-Reply-To: <20190722154239.GH1607@sasha-vm>
From:   Jinpu Wang <jinpuwang@gmail.com>
Date:   Tue, 23 Jul 2019 11:59:16 +0200
Message-ID: <CAD9gYJ+xhujXEHVNAEB5EUO7vwkXuZeU-xf0+g049uk8ucP_tA@mail.gmail.com>
Subject: Re: [stable-4.19 0/4] CVE-2019-3900 fixes
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "v3.14+, only the raid10 part" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Sasha Levin <sashal@kernel.org> =E4=BA=8E2019=E5=B9=B47=E6=9C=8822=E6=97=A5=
=E5=91=A8=E4=B8=80 =E4=B8=8B=E5=8D=885:42=E5=86=99=E9=81=93=EF=BC=9A
>
> On Mon, Jul 22, 2019 at 03:03:09PM +0200, Jack Wang wrote:
> >Hi, Greg, hi Sasha,
> >
> >I noticed the fixes for CVE-2019-3900 are only backported to 4.14.133+,
> >but not to 4.19, also 5.1, fixes have been included in 5.2.
> >
> >So I backported to 4.19, only compiles fine, no functional tests.
> >
> >Please review, and consider to include in next release.
>
> Thanks Jack. It'll be great if someone can test it and confirm it fixes
> the issue (and nothing else breaks).
>
Agree, thanks
> --
> Thanks,
> Sasha
