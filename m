Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 444471D6D7F
	for <lists+stable@lfdr.de>; Sun, 17 May 2020 23:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726458AbgEQVjN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 17 May 2020 17:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726444AbgEQVjM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 17 May 2020 17:39:12 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6B74C061A0C;
        Sun, 17 May 2020 14:39:12 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id r3so3840061qve.1;
        Sun, 17 May 2020 14:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AM7Zd0MxslnqLot1MzBGMFBYbuX//qg2mFKMsl+GXdA=;
        b=QjJqxMSOxa+7rNqpVlN4ka8WO8uz2g8FKzSZ+7XQfrl4ZnMxnOCCWdP1dFasAdmuAj
         awGpC25Wv5I1Q3I3HRkRt5VCkCiNqKnbhdHWV/nqs/lUWXjrir9BS7bTixIzCdbfMdXU
         dO6rAkUj+l84sTt77Y/YQB1BOnpuM+2z5oNYUqplwQ3rHy3q6YWXHUaFCIO78+8mvAHd
         FieT0fHdqcH40CPzghUmrpHkGeRjx0dQ7f6KmtYBZEO5Ks9gmRDbrLFQ/r84WW7HyrFA
         +r3kXoq6aGe7po0s9z5ywqq8Eh81N+aKXSr9bP9PtBzsjkIA7qmXYvXgMaK3nF/Vogtw
         vOQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AM7Zd0MxslnqLot1MzBGMFBYbuX//qg2mFKMsl+GXdA=;
        b=aXc2qLlKgFKaXZLQGU8t01uDViEcDOH0WGCGyC6ym4PUkDPOLra0le+lQcaIBKyJqy
         TKxINhKfwSNUjdixSo2kMXwXHA6YvbHF/jcDMFlKDHAdFSwq7n0glsY0RcjrRV8iTiqb
         buoDrZNukMdDlj4qZicUCCW3YAaf8PWPZAg+EM4g//SLYIQIWJpr85RakocAxcyFvWot
         VPeqFF4zhq6rKHa2NbFWsvunsL43ZlAUwqJr9xHq0BFqP10pZmzr76+T+8yWA4tbz6V6
         MEm4dBjkF4d0ktHS6JidH/s2cUWdHDEnsXsDm5sSFZbN8uJ2ogNLFHGvIPJ+oRpyxYIi
         Up/w==
X-Gm-Message-State: AOAM5320wAWwDo+ZZi/+sgpEnREMsyv4W8vVMLiD3JGJD97H+7/xGz80
        cfKi0CfRxnI7FZDL/HZLV29OrVkqvtL9fyr0IYI=
X-Google-Smtp-Source: ABdhPJwXU3h/f9ui36v++p/oav/xwWq3PX9W7HxRFV2aCFQvbfAIK+zN/BwaFzJKPXEcoif4EM3Cv2MplC67ZDb1eP8=
X-Received: by 2002:a05:6214:7cd:: with SMTP id bb13mr13270302qvb.17.1589751551767;
 Sun, 17 May 2020 14:39:11 -0700 (PDT)
MIME-Version: 1.0
References: <20200502055945.1008194-1-ebiggers@kernel.org> <20200504071644.GS5877@pengutronix.de>
 <20200515191704.GE1009@sol.localdomain> <568077266.223149.1589575814867.JavaMail.zimbra@nod.at>
In-Reply-To: <568077266.223149.1589575814867.JavaMail.zimbra@nod.at>
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Sun, 17 May 2020 23:39:00 +0200
Message-ID: <CAFLxGvx3-QvXnjhdfrqvv3a46opdcN6fyQ2Yc2QJ57TetBwfiA@mail.gmail.com>
Subject: Re: [PATCH] ubifs: fix wrong use of crypto_shash_descsize()
To:     Richard Weinberger <richard@nod.at>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        linux-mtd <linux-mtd@lists.infradead.org>,
        Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 15, 2020 at 10:50 PM Richard Weinberger <richard@nod.at> wrote:
>
> ----- Urspr=C3=BCngliche Mail -----
> > Von: "Eric Biggers" <ebiggers@kernel.org>
> > An: "Sascha Hauer" <s.hauer@pengutronix.de>, "richard" <richard@nod.at>
> > CC: "linux-mtd" <linux-mtd@lists.infradead.org>, "Linux Crypto Mailing =
List" <linux-crypto@vger.kernel.org>, "stable"
> > <stable@vger.kernel.org>
> > Gesendet: Freitag, 15. Mai 2020 21:17:04
> > Betreff: Re: [PATCH] ubifs: fix wrong use of crypto_shash_descsize()
>
> > On Mon, May 04, 2020 at 09:16:44AM +0200, Sascha Hauer wrote:
> >> On Fri, May 01, 2020 at 10:59:45PM -0700, Eric Biggers wrote:
> >> > From: Eric Biggers <ebiggers@google.com>
> >> >
> >> > crypto_shash_descsize() returns the size of the shash_desc context
> >> > needed to compute the hash, not the size of the hash itself.
> >> >
> >> > crypto_shash_digestsize() would be correct, or alternatively using
> >> > c->hash_len and c->hmac_desc_len which already store the correct val=
ues.
> >> > But actually it's simpler to just use stack arrays, so do that inste=
ad.
> >> >
> >> > Fixes: 49525e5eecca ("ubifs: Add helper functions for authentication=
 support")
> >> > Fixes: da8ef65f9573 ("ubifs: Authenticate replayed journal")
> >> > Cc: <stable@vger.kernel.org> # v4.20+
> >> > Cc: Sascha Hauer <s.hauer@pengutronix.de>
> >> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> >>
> >> Looks better that way, thanks.
> >>
> >> Acked-by: Sascha Hauer <s.hauer@pengutronix.de>
> >>
> >
> > Richard, could you take this through the ubifs tree for 5.8?
>
> Sure. I actually will send a PR with various MTD related fixes
> for 5.7.

Applied. Thanks for fixing!

--=20
Thanks,
//richard
