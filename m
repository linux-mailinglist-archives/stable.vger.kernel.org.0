Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 27B14177977
	for <lists+stable@lfdr.de>; Tue,  3 Mar 2020 15:48:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729177AbgCCOq5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Mar 2020 09:46:57 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:35105 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726766AbgCCOq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Mar 2020 09:46:57 -0500
Received: by mail-pl1-f195.google.com with SMTP id g6so1419706plt.2;
        Tue, 03 Mar 2020 06:46:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Et89TxHZScvO802wz3pDsSgOvJzj9+91sYA5VuFURiw=;
        b=tWhdtCG741dhRqjuW+c6VfXQvDMGNHvLlaYTeZ5kKxqNsmFlqua32o3rfCsfu4sdXC
         yyH+lQGMK/StHh+5lxBCiiteaX262eaGD+hxlHZWZ8LSsYmBdG68LqbwmNLZW0u+wrJ1
         BTICzlfSIVmr5ZCgNGbZ+mh31rWk7WuIcd2y3rfVkcBRJ1iXSaccn0eQYgRN8tKgpG11
         kRJZllMreM8YbU2ntneFXbjLHWJgAjrVCP4YM1LamQk1WZs+oECDkRO6xheAEb2FEHTd
         skRVtEBJ3UZ4GiOxxbKiOC5BAJ/OQLbwZ4s2OacnEgdHieIH6RUjgAW02s0fYJqdBtLI
         cRcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Et89TxHZScvO802wz3pDsSgOvJzj9+91sYA5VuFURiw=;
        b=YXQyiG50I54U60J7OlJnNFKLIlBQ7ujJy97BlNgN5ix+yYynIgJ3QtpNbps4PyTKI6
         PmQj5lzV5ISF1ZF/3bjEERacjiou7sY651fRyuNVnLb0VrDbFBHgy+/xUEM8TbyVDh5J
         3AzeFEcT9cd8OUK3gPf7QsQR2EWySBZHe0YjbTcp9/+qMRhs40Fsn+32owqdY5OojZ6o
         thn+NHQbi8BSi6nl8DbtKfOJ1Txph5Sw6dg/DNvFgkiNYh/yhzcFuvvUrnjexgTHcXU9
         eREd2g4k13xB2Nm6iKq79hslSQ1BoZedGgKwnkednaXTnHLBLS5IvS9OTN5FjZC6ijZC
         84DQ==
X-Gm-Message-State: ANhLgQ1+hyljOIeRBm/yg0V4XpHtDpENSBwY+ctaFaisNmCpyuPXVl0Z
        lXgrqT2e3unxNa2NC8QkLXmXKBbxU2za0U7JPfc=
X-Google-Smtp-Source: ADFU+vs1wFUx1BaLtWJA8bZiA2qcgCbwk5ExKmiq8IxWfE/vhWOSserEnaasfEq9I4Y0YdhUf1TFqkLKDQJEDcftfZw=
X-Received: by 2002:a17:902:b103:: with SMTP id q3mr4524519plr.262.1583246816591;
 Tue, 03 Mar 2020 06:46:56 -0800 (PST)
MIME-Version: 1.0
References: <20200223181832.17131-1-kristian@klausen.dk> <20200224011017.C5207208C4@mail.kernel.org>
 <e700ebdc-3dce-c151-3ea5-f7ab1e4cb07f@klausen.dk> <CAHp75VcAZZ-d1BQON0ciLoCGt5=1qh4s1jLGhDdApicT+7BEGg@mail.gmail.com>
 <af54a82e-0b9f-1e88-8741-bd4a3658d8e7@klausen.dk> <CAHp75VfGkn_oGCNyP=RWo9fHvh8YzEy6e7cDCczJefsq2HMRFw@mail.gmail.com>
In-Reply-To: <CAHp75VfGkn_oGCNyP=RWo9fHvh8YzEy6e7cDCczJefsq2HMRFw@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Tue, 3 Mar 2020 16:46:49 +0200
Message-ID: <CAHp75VeG0CgORmpsH8q72MAXhgQs29QAXs1w4B4FxReQ01S7dA@mail.gmail.com>
Subject: Re: [PATCH v2] platform/x86: asus-wmi: Support laptops where the
 first battery is named BATT
To:     Kristian Klausen <kristian@klausen.dk>
Cc:     Sasha Levin <sashal@kernel.org>,
        Platform Driver <platform-driver-x86@vger.kernel.org>,
        Stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 25, 2020 at 11:55 AM Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Tue, Feb 25, 2020 at 11:51 AM Kristian Klausen <kristian@klausen.dk> wrote:

...

> > Sorry about that, my response does not make any sense.
> > The change isn't upstream yet, and should be applied upstream first and
> > the 5.4 and 5.6 tree tree if possible.
>
> The usual pattern is to add Fixes tag and Cc: stable@.
>
> > Was I wrong CC'ing stable@vger.kernel.org? (suggested by git send-email
> > due to "Cc: stable@vger.kernel.org")

Kristian, to be clear, I'm waiting for v3 with appropriate tag and Cc
list applied.

-- 
With Best Regards,
Andy Shevchenko
