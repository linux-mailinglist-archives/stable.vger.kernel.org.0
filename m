Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5DEF14164F
	for <lists+stable@lfdr.de>; Tue, 11 Jun 2019 22:46:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436533AbfFKUpu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Jun 2019 16:45:50 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:44330 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2436506AbfFKUpu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Jun 2019 16:45:50 -0400
Received: by mail-lj1-f195.google.com with SMTP id k18so13005502ljc.11;
        Tue, 11 Jun 2019 13:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=LkmSasgHwTPN0Ndf6fcKCs6fzhFXy2zXdlzLA0q+asI=;
        b=ObDxppmSMLhG+fkz3drnQ/FoBZpV2ZoLwtqESZ3p2mu0qPMeoIM0cIqbsgiGrR9IzS
         5PRRikeRlvruWNrRxdOOtG9KL4TISAr28OjerS2g/i2wbtgaVfTvxlKcBaU8R9p17QKr
         iWkXtyBv0cG8FSqPkSw/8ihREmKmCcP9Ubz0x7dubjnFoq3unp+Ep+yrHpZJrAWViXva
         2P/9LQduWqQxRlpMdIiQpFEdj8FNZ5OXXW6pOtSM+MDDyaXFAXDP6Fd6b/ifnwrE1yMa
         saGVTnL9QspMarepbK8n5MuhQByw4mcQRHIbkQ0lnCWMbQRYLY+hl3cbUEgtkFcfIiY2
         ojmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=LkmSasgHwTPN0Ndf6fcKCs6fzhFXy2zXdlzLA0q+asI=;
        b=MEcIIuagMC+ZZS/iv/F0/uGm1z3dwfNzwjFqSDgO4FC4RlwLROkK9BDa/6HjBAX/jo
         lyZk+332WqWre/v24Q1hlO6yYKZlQA8qd9JuEY2o5beTlVvVo/IY7asf/ePHuC6+9Dr2
         ZXcI06DP3veHgl2nSh6BWp6RT+rjW0Mmnku6ZyFQ0hYfyk47089wrJwu0Ul3MfWvd4tp
         RXvrUt1PuIz+OEXewWFak6ft7dKlQUHqY34eD+efF9VrAMtiFVkVBgeszvEdpvf4QSC4
         mUi+GX+48wxws2+c9e4CIe0tIvC+b8HMbqoygLFn59L7SAtvryF7pHc/JJ+nWyv7HKPn
         9YgA==
X-Gm-Message-State: APjAAAW8rQQ+7jjLQ+sEx+Jd0KFhZwRyGoX6Ik7IlsaQpdLqGTvSmam5
        Zkfmp2nYv9Tg6wjqZCUfGsuivNe5V/nEMreJIyE=
X-Google-Smtp-Source: APXvYqy9Ow4dAwkDDSKNdXE6tNxT6mUpFq+8F2EnxMsCx8NMjK0S9ltkbLmEAfERr7KU10pSDxK3nkIfW2WWI7e18gY=
X-Received: by 2002:a2e:3013:: with SMTP id w19mr29172328ljw.73.1560285947692;
 Tue, 11 Jun 2019 13:45:47 -0700 (PDT)
MIME-Version: 1.0
References: <CANRwn3Ru+7FGtsY=GaDa7pAJkuagdb6nFtvrFq1qhTWJR0rF9A@mail.gmail.com>
 <20190426163531.9782-1-jason.gerecke@wacom.com> <CANRwn3RBK41mRJKUPDDptoq_So6_7UxR0toaauZvjT5U=OaHWw@mail.gmail.com>
 <20190611192248.GB19775@kroah.com>
In-Reply-To: <20190611192248.GB19775@kroah.com>
From:   Jason Gerecke <killertofu@gmail.com>
Date:   Tue, 11 Jun 2019 13:45:36 -0700
Message-ID: <CANRwn3SNAQccFQEaw7Qg=hNojbFVkFRHLT3tzq_BtxpUNRiMUw@mail.gmail.com>
Subject: Re: [PATCH 2/2] HID: wacom: Don't report anything prior to the tool
 entering range
To:     Greg KH <greg@kroah.com>
Cc:     "# v3.17+" <stable@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        Linux Input <linux-input@vger.kernel.org>,
        Ping Cheng <pinglinux@gmail.com>,
        Aaron Armstrong Skomra <skomra@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        Aaron Armstrong Skomra <aaron.skomra@wacom.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 11, 2019 at 12:22 PM Greg KH <greg@kroah.com> wrote:
>
> On Tue, Jun 11, 2019 at 12:02:47PM -0700, Jason Gerecke wrote:
> > I haven't been keeping a close eye on this and just noticed that this
> > patch set doesn't seem to have been merged into stable. There's also a
> > second patch series (beginning with "[PATCH 1/3] HID: wacom: Send
> > BTN_TOUCH in response to INTUOSP2_BT eraser contact") that hasn't seen
> > any stable activity either.
> >
> > Any idea what's up?
>
> I don't see these in my queue at all.
>
> What is the git commit id of these patches in Linus's tree?
>
> thanks,
>
> greg k-h

Ah, looks like the HID tree's "for-5.2/fixes" branch hasn't been
pulled yet. That could explain things.

69dbdfffef20c715df9f381b2cee4e9e0a4efd93 HID: wacom: Sync INTUOSP2_BT
touch state after each frame if necessary
6441fc781c344df61402be1fde582c4491fa35fa HID: wacom: Correct button
numbering 2nd-gen Intuos Pro over Bluetooth
fe7f8d73d1af19b678171170e4e5384deb57833d HID: wacom: Send BTN_TOUCH in
response to INTUOSP2_BT eraser contact
e92a7be7fe5b2510fa60965eaf25f9e3dc08b8cc HID: wacom: Don't report
anything prior to the tool entering range
2cc08800a6b9fcda7c7afbcf2da1a6e8808da725 HID: wacom: Don't set tool
type until we're in range

Jason
---
Now instead of four in the eights place /
you=E2=80=99ve got three, =E2=80=98Cause you added one  /
(That is to say, eight) to the two,     /
But you can=E2=80=99t take seven from three,    /
So you look at the sixty-fours....
