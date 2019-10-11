Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BD73CD4768
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 20:19:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728863AbfJKSTV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 14:19:21 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:35691 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728724AbfJKSTU (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 11 Oct 2019 14:19:20 -0400
Received: by mail-lj1-f195.google.com with SMTP id m7so10755186lji.2;
        Fri, 11 Oct 2019 11:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xHWcMVkKfQW5YQem89Ki4hx7rEYLgwMaVLaDcNFHxy8=;
        b=ZitRdHD87CyRQIneWCmXl1JH8KlL+SIIhXhoiLpXORD5GW6dQ4yO2WiIerdf0bJ2rC
         wUIs05umiInQpgYVYSzaGowJCrR7h+xoRI0/md0VCmx7q7eKzF6mZwS+5Lb3JW/H3xf4
         9KhLNzHwWvlwsaFiR6P/HvbZVmE0tUMjqQ7ojKFWGdOmPaej7UMMQ353sPS8eqOCMgqB
         U5IynYXDJEu6rYq9MdQCI+JDrjB2VH6Bj6RfAem9zODV5MnIwlyVSkrmXxXjlBbbaQEL
         09XKfbNsUh+ZW58fuyg8XISKtFursl1Qa70MyffXE1zHJpVgcMu+gN0zPH1pllLmSRV+
         YS/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xHWcMVkKfQW5YQem89Ki4hx7rEYLgwMaVLaDcNFHxy8=;
        b=QUUc+CiNj/3TKB/xIxD/8BPlHNkMvOWj15EOsMuaPw8wXoSiqqtDa4x+oCjBFt3Pv8
         hnrpCM5se4rMGGoYW6BC0F7YOnIEBgsW58OglckfP7alAsYWcaFtdwBFhOXLL7VoADeV
         txow6eE0Ew25zZwKNVfATrdZU0FTKmMNiBuutxTD1krWs3GhecJoDVz/oiNB3B/TS9zO
         R+i0joV6CTgVS5HYIGZWB4VwYLzeloWb/HeyrxrTajZh59rH/LLVbmGBPytNYRyMX7wb
         ss0KTjm/K/xLoHO+OPe5NJJHaoqsUVdQTKfE6RP2u0Yw/+YOhUph0+cOWithhF5qX1mH
         OH2w==
X-Gm-Message-State: APjAAAWGN5J3di+KatpZ4c5mhsYGDGNcMZXQrv0UPDc5jPeHrH3PxK+F
        VHG0Bol/wz5LSd+PZ4zaoJ6VvKZsJU1CBsL6UYo=
X-Google-Smtp-Source: APXvYqwO4XnX5MCioj8PA5AMXbwa8nrtJcTry+BdWADG12SbJ5G62YDioP1sbk25PGgCsqOv1NdDCRa73Z+MNvJJ2fQ=
X-Received: by 2002:a2e:865a:: with SMTP id i26mr9866394ljj.107.1570817958321;
 Fri, 11 Oct 2019 11:19:18 -0700 (PDT)
MIME-Version: 1.0
References: <20191007051240.4410-1-andrew.smirnov@gmail.com> <CAO-hwJ+=pDmvPbLVO8mViygJof7O1YeX3KO951nqN4dNaKz83g@mail.gmail.com>
In-Reply-To: <CAO-hwJ+=pDmvPbLVO8mViygJof7O1YeX3KO951nqN4dNaKz83g@mail.gmail.com>
From:   Andrey Smirnov <andrew.smirnov@gmail.com>
Date:   Fri, 11 Oct 2019 11:19:07 -0700
Message-ID: <CAHQ1cqHU2DmKzAtcDCPLtUXwkzhyCynki3GKOwgULnN0ya6POg@mail.gmail.com>
Subject: Re: [PATCH 0/3] Logitech G920 fixes
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Jiri Kosina <jikos@kernel.org>,
        Henrik Rydberg <rydberg@bitmath.org>,
        Sam Bazely <sambazley@fastmail.com>,
        "Pierre-Loup A . Griffais" <pgriffais@valvesoftware.com>,
        Austin Palmer <austinp@valvesoftware.com>,
        lkml <linux-kernel@vger.kernel.org>,
        "3.8+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 7:53 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> Hi,
>
> Finally, someone who takes care of the G920!
> Note that when I sent my first initial version that Hans reused, I
> surely broke it (looking at your patch 3/3), but no one cared to test
> it :(
>
> On Mon, Oct 7, 2019 at 7:13 AM Andrey Smirnov <andrew.smirnov@gmail.com> wrote:
> >
> > Everyone:
> >
> > This series contains patches to fix a couple of regressions in G920
> > wheel support by hid-logitech-hidpp driver. Without the patches the
> > wheel remains stuck in autocentering mode ("resisting" any attempt to
> > trun) as well as missing support for any FF action.
>
> So, you are talking about regressions, and for that I would like to be
> able to push the patches to stable.
>
> However, I would need more information:
> - patch 3/3 seems simple enough to go in stable, and is clearly a
> regression from the recent series. Can you put it in first and add
> stable@vger.kernel.org in a CC field (and possibly with a Fixes tag as
> well)?

It patch 3/3 on purpose because applying it by itself, without fix in
2/3 in place would lead to a segfault and a non working wheel. Maybe
that FF for-next fix you pointed out can prevent that from happening,
but as is the series is pretty atomic and can't be divided.

Patch 3/3 already has stable in CC and Fixes tag.

> - I am not sure which patch fixes the wheel remains stuck in
> autocentering mode. Is it patch 2/3?

There's no specific patch that does that. There were two G920
regressions in the driver and both need to be fixed for wheel to be
configured properly. The specific code that releases the wheel is in
g920_ff_set_autocenter().

> - was the "wheel remains stuck in autocentering mode" bug present from
> on of the recent patch or was it always there since we introduced
> support in hid-logitech-hidpp, but the game would need to unlock the
> wheel first?

The wheel worked as expected prior to

fe3ee1ec007b ("HID: logitech-hidpp: allow non HID++ devices to be
handled by this module")
91cf9a98ae41 ("HID: logitech-hidpp: make .probe usbhid capable")

It's not the game that needs to unlock the wheel, but the driver itself.

Thanks,
Andrey Smirnov
