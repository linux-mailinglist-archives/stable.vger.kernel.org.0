Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F2435B2280
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 16:49:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388401AbfIMOtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 10:49:09 -0400
Received: from mail-vs1-f68.google.com ([209.85.217.68]:36190 "EHLO
        mail-vs1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388244AbfIMOtJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 Sep 2019 10:49:09 -0400
Received: by mail-vs1-f68.google.com with SMTP id v19so13637543vsv.3;
        Fri, 13 Sep 2019 07:49:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nw7T83KKQvMYoShbp1YlvamGMfFATFsgELkQvR1PLxc=;
        b=oPCQ7TuDbfbWKUTXZRjQSiNvEdfc+x9Akuu33BeMd/Xxwdvydwqwy7deG2WZPRGCJu
         57/ujwsftQsJaHx755eotMVAWlyiQpkRFKBzqdGblga0XVUuSFoeUwWcKMj5ks45CBbD
         HC5t+PYQN/O1FyqmymkCcTAGagybwCjyi5PD3XvHo2/+od2nKSeqBkLyQdvUEeSwGkW+
         09NjcydGvq/1e+gMgUOxvmeAaQTVbUqEJmPiuMy8iVUUhYzUMi0jGX1XumLa+pXFNz+W
         E+W9cITgHAWVW7uOJ1z/9Tn4eqxCrXULQ6LL0ikdLt8bW6WDW2ZIfuUYblidTU3OiSz0
         8pdA==
X-Gm-Message-State: APjAAAWN0MyXlUMqBT5ZXFTxTfP8uHuww3Iv20zszLcdCabv/sQK0ma2
        GiSP7PUAEM78JAxvzcmZO6o2wMjSgnipXPKKO/9T4A==
X-Google-Smtp-Source: APXvYqybdR2BZuJUvlriiROjoC+yPYWDVTolJxZjwIstMw1q2QyxRZT/OZXpWARLJ1Hw7JnHFDzCdQ3wbE4RoUSYhcw=
X-Received: by 2002:a67:d410:: with SMTP id c16mr26690546vsj.37.1568386148550;
 Fri, 13 Sep 2019 07:49:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190913130559.669563815@linuxfoundation.org> <20190913130606.981926197@linuxfoundation.org>
 <CAKb7UviY0sjFUc6QqjU4eKxm2b-osKoJNO2CSP9HmQ5AdORgkw@mail.gmail.com> <20190913144627.GH1546@sasha-vm>
In-Reply-To: <20190913144627.GH1546@sasha-vm>
From:   Ilia Mirkin <imirkin@alum.mit.edu>
Date:   Fri, 13 Sep 2019 10:48:57 -0400
Message-ID: <CAKb7UvgS5uGRP55Z7mcD=PTcPHmHMXB23gpP83kjn-vFcverJQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 092/190] drm/nouveau: Dont WARN_ON VCPI allocation failures
To:     Sasha Levin <sashal@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        Ben Skeggs <bskeggs@redhat.com>,
        nouveau <nouveau@lists.freedesktop.org>,
        "# 3.9+" <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Sep 13, 2019 at 10:46 AM Sasha Levin <sashal@kernel.org> wrote:
>
> On Fri, Sep 13, 2019 at 09:33:36AM -0400, Ilia Mirkin wrote:
> >Hi Greg,
> >
> >This feels like it's missing a From: line.
> >
> >commit b513a18cf1d705bd04efd91c417e79e4938be093
> >Author: Lyude Paul <lyude@redhat.com>
> >Date:   Mon Jan 28 16:03:50 2019 -0500
> >
> >    drm/nouveau: Don't WARN_ON VCPI allocation failures
> >
> >Is this an artifact of your notification-of-patches process and I
> >never noticed before, or was the patch ingested incorrectly?
>
> It was always like this for patches that came through me. Greg's script
> generates an explicit "From:" line in the patch, but I never saw the
> value in that since git does the right thing by looking at the "From:"
> line in the mail header.

That's right -- the email's From header gets used in the case of no
explicit From in the email body. But Greg is sending the emails From:
Greg, so if I were to ingest that email, I would end up with a patch
From: Greg, not From: Lyude as it ought to be.

Cheers,

  -ilia
