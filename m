Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3BADE5C25F
	for <lists+stable@lfdr.de>; Mon,  1 Jul 2019 19:54:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728756AbfGARy1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jul 2019 13:54:27 -0400
Received: from mail-oi1-f196.google.com ([209.85.167.196]:33950 "EHLO
        mail-oi1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727700AbfGARy1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Jul 2019 13:54:27 -0400
Received: by mail-oi1-f196.google.com with SMTP id l12so10680851oil.1;
        Mon, 01 Jul 2019 10:54:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cz+aP0Ec5W7R8dkKPE9rRkbojDWe1GP+xoyo98aB624=;
        b=aXdwDTzLcSPbI2Lrr8dU7FM1m4VFK1T1c/k30ysqQbij/rr8UirpNLFPsmhhefWVww
         EU2HLTeyyt0MxCJpyBAkP0jV7numoiQaVKUDKwMwaFn4ty/pkBbHzGiAWa+TVpZXRTiu
         yyqFRaYaDA/IMLAkMq7GFIYr9ahiqb9X6ejDchJS1S7z87p8fTf6rNOO0Ry7zZtHGWGf
         8xrWjfXPfSioLgNokSRXnJTaSW6hed2PDPOjs6Qf0NVIdFTGxzx5EV2YPV5Ec6Fvdrvr
         PLA3TCqKau+kGLlfAY6Tsnjs3JLSFxnHq7bK/1L7Yu6vX0k/urwLFBceyeOOMUwTej/U
         BfBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cz+aP0Ec5W7R8dkKPE9rRkbojDWe1GP+xoyo98aB624=;
        b=eEyWmUA01zVqcS4i7SnpIsJuHzxepLENBv59JOjU1XTGYlg8akt/VLL6PBCNChRzmC
         jN2AGceynwNl6WqqCJpNE5Vz57TJl8de/bsbJW+2WX2hFBqVvpgpR+x2of5Ae2LUXkeg
         nUKBEYQsIqKaqQnzjj0Fze0AcmPm0ZTalMK2U6z4f2dIQZluE9XGI0wAneAFMfVWnQU0
         JnUogYE+A3duXgNkDceR1aChKm7Pgrt8FSqnNZ4SHgrAsvak9qo+w5b2dvNXmqolyf6s
         QaTGpni6cpBkoP0CLcb3ItcXQ3nfKrg3N76U8UolhkmJFScp2MGZEtJPt2VowpliTCbv
         As5w==
X-Gm-Message-State: APjAAAXAoORLfG0Fl/RWl4+g6Phv4yq4KG2NNEespOPiXEyL8HgV6eTY
        5l2PVMt/ZUGAYVQBzH5JjPckauiBRFa6xJwGqqdX1w==
X-Google-Smtp-Source: APXvYqyEauAoV4qo/po0ya18tTktkLvsFYl7paAkp55icsJikdBjZ8AIiKm0nhrTKHEu0ccb1YyGdzYFFMLFrU/XgLQ=
X-Received: by 2002:a05:6808:3d6:: with SMTP id o22mr330425oie.140.1562003666003;
 Mon, 01 Jul 2019 10:54:26 -0700 (PDT)
MIME-Version: 1.0
References: <20190620175022.29348-1-martin.blumenstingl@googlemail.com> <a7647aea-b3e6-b785-8476-1851f50beff1@synopsys.com>
In-Reply-To: <a7647aea-b3e6-b785-8476-1851f50beff1@synopsys.com>
From:   Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Date:   Mon, 1 Jul 2019 19:54:15 +0200
Message-ID: <CAFBinCDDyG_CxW+PB_OrUXfy-aDKSoewC2OyCfGh18N=omSgcQ@mail.gmail.com>
Subject: Re: [PATCH] usb: dwc2: use a longer AHB idle timeout in dwc2_core_reset()
To:     "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "felipe.balbi@linux.intel.com" <felipe.balbi@linux.intel.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
Cc:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 24, 2019 at 7:41 AM Minas Harutyunyan
<Minas.Harutyunyan@synopsys.com> wrote:
>
> On 6/20/2019 9:51 PM, Martin Blumenstingl wrote:
> > Use a 10000us AHB idle timeout in dwc2_core_reset() and make it
> > consistent with the other "wait for AHB master IDLE state" ocurrences.
> >
> > This fixes a problem for me where dwc2 would not want to initialize when
> > updating to 4.19 on a MIPS Lantiq VRX200 SoC. dwc2 worked fine with
> > 4.14.
> > Testing on my board shows that it takes 180us until AHB master IDLE
> > state is signalled. The very old vendor driver for this SoC (ifxhcd)
> > used a 1 second timeout.
> > Use the same timeout that is used everywhere when polling for
> > GRSTCTL_AHBIDLE instead of using a timeout that "works for one board"
> > (180us in my case) to have consistent behavior across the dwc2 driver.
> >
> > Cc: linux-stable <stable@vger.kernel.org> # 4.19+
> > Signed-off-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
> > ---
>
> Acked-by: Minas Harutyunyan <hminas@synopsys.com>
thank you for reviewing this!

is there any chance we can get this fix into Linux 5.3? I know that
it's too late for 5.2 so I'm fine with skipping that.


Martin
