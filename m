Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 469333A2D7E
	for <lists+stable@lfdr.de>; Thu, 10 Jun 2021 15:53:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231277AbhFJNzO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 09:55:14 -0400
Received: from relais.etsmtl.ca ([142.137.1.25]:54158 "EHLO relais.etsmtl.ca"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230329AbhFJNzN (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 09:55:13 -0400
Content-Type: text/plain; charset="UTF-8"
DKIM-Signature: v=1; a=rsa-sha256; d=etsmtl.ca; s=bbb; c=relaxed/relaxed;
        t=1623333196; h=from:subject:to:date:ad-hoc;
        bh=j3oCbljVfV3a5vZ7w621ARkBBGcGHNysssfAUWTOSB8=;
        b=Ac12XPsIJ9B3G3Otax9h+AYRd+yfUEwK/EpqYL8GmoMtWkU++OAvdtlXoMQLVYLw3UYDNa2RiNx
        Z14pzLePCaHzqKnTPMz2WBQj2QGVCuBJlkw6HqcvPQ2Dar53oVT2k6NGxKXFQB8YDckm0TRdNY0lv
        +La8cUAXVuHb7W9oRoc=
X-Gm-Message-State: AOAM532kQkpUghnIxewNTJOhNB9h6Xpt7wPsJrFwbowrELl1rqxg8X5z
        WUsodlSm1cuEZXiR/mT2FG2CwM3bwB5U9l/G83s=
X-Google-Smtp-Source: ABdhPJzal31zP8KEgxyDpJyVOOU/6Ae9/Vny59ZdLcQpjpXZV2H9rt6ezM6+/iqFE0LlNEnlsJ8o9vX+51/M2ujY/QI=
X-Received: by 2002:aca:3bc5:: with SMTP id i188mr3573052oia.72.1623333196029;
 Thu, 10 Jun 2021 06:53:16 -0700 (PDT)
MIME-Version: 1.0
References: <20210604161023.1498582-1-pascal.giard@etsmtl.ca>
 <YLsdEtbAWJxLB+GF@kroah.com> <CAJNNDmk7z=aJtx00C+8kpBOk0j_XVOk2fDMG9Xf9Na_ChXM2OA@mail.gmail.com>
 <YMGhotmI1kHFe3gL@kroah.com>
In-Reply-To: <YMGhotmI1kHFe3gL@kroah.com>
From:   Pascal Giard <pascal.giard@etsmtl.ca>
Date:   Thu, 10 Jun 2021 09:53:04 -0400
X-Gmail-Original-Message-ID: <CAJNNDmmz60qn+AXWD7423T62DoO-gC8KjrtLmfyR0o4vWzhZfw@mail.gmail.com>
Message-ID: <CAJNNDmmz60qn+AXWD7423T62DoO-gC8KjrtLmfyR0o4vWzhZfw@mail.gmail.com>
Subject: Re: [PATCH] HID: sony: fix freeze when inserting ghlive ps3/wii dongles
To:     Greg KH <gregkh@linuxfoundation.org>
CC:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        <linux-input@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>,
        Daniel Nguyen <daniel.nguyen.1@ens.etsmtl.ca>
X-Originating-IP: [142.137.250.50]
X-ClientProxiedBy: FacteurA.ad.etsmtl.ca (10.162.28.14) To
 FacteurB.ad.etsmtl.ca (10.162.28.15)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 10, 2021 at 1:25 AM Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jun 09, 2021 at 08:25:47PM -0400, Pascal Giard wrote:
>
> > I apologize for failing to follow the procedure. I had already read
> > these guidelines, and I actually thought I was following Option 1 :-/
>
> Is this commit already in Linus's tree?  If so then we just need a git
> commit id and we can queue it up.

No, it isn't yet. My patch has not been reviewed yet.

> > I thought that I had to get my patch merged into next first (patch
> > against dtor's git) and that by adding stable@ as CC, it would
> > automatically get considered for inclusion into stable once merged
> > into Linus' tree. Based on your email, I got that wrong...
>
> It will, but you need to add that to the signed-off-by: area, as the
> document says.

Oh dear, that's the bit I missed.

At this point I assume that I should not resubmit a patch (to avoid
unnecessary noise) and patiently wait for a review, e.g., by Jiri, for
it to be included in next.
From there, I'll try to do the right thing (CC stable in the
signed-off area) shall a new version be necessary or follow option 2
with the commit id when it gets merged to Linus' tree.

Once again, my apologies for failing to follow the procedure and thank
you for your patience.

-Pascal
