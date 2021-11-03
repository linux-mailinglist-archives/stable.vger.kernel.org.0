Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6951E4440A9
	for <lists+stable@lfdr.de>; Wed,  3 Nov 2021 12:34:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhKCLhW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 3 Nov 2021 07:37:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230112AbhKCLhV (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 3 Nov 2021 07:37:21 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87570C061714
        for <stable@vger.kernel.org>; Wed,  3 Nov 2021 04:34:45 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id v11so5415675edc.9
        for <stable@vger.kernel.org>; Wed, 03 Nov 2021 04:34:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kryo-se.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qjQlCC54nF7z2Cl2N8yD/OFU21AkJgXB+1kF8th4T0k=;
        b=N0C3ZPUJP0c948ncYEX3xCUdzOIgRyWRVS+sKLqwdOvcvMhwPu1fhnmNu1Lbvy81wP
         7LY8QF8Zmi0edP2KWU3JMGaSrSz34pmuiQX4D4UT9OO1c/N5Pd8IGtbhT6jr2ScL2iMr
         8D3rgctwQRczCYHMtgHbvZqbr5apbU6KBchiGt8efP4ADxE+8LX9a3Lyo5h5hs0yBRj1
         pXesGjWmzjFOjZkz/e7MSzzSsK2LRRDNbb13T/4d7QvVCYnoKNcDkYcVR1FiYxV1tAKl
         +E6pC9Yh4FKdQ1Smk2YVUVBQlHt+MMw5yvzJz2SRSeFAAC3sNIV9mmKuvIKQ1EU9kMSR
         6Z5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qjQlCC54nF7z2Cl2N8yD/OFU21AkJgXB+1kF8th4T0k=;
        b=n7MrV1B20FK98QSrCqVAucdAHDSmjaD6p/zYREu2rHC2ut0SLHFSu+s+w+EN3rlsvp
         TGATQV9ehcYV8J7zWBT4s9kDHJ83QY0TVBWSyTbU1oX1rEKbiOQqib43SQ0qsnaQSLg9
         U/Rr61sYNC8+BNrGErSsPJ4JK/dacaC6rXPtthcPTWR8YyAjer+DVgz8abwp9cbQ3Q2V
         fzHHQFto7u4AU+kXnqfquwiWtq+29z0znJKYz67XO/9xzFCTzNU3ij3uXT6XyEhdG1+l
         KmvPXhZkAT01KNsKZopl8x1gzfmwk+rz8aIqJOVajqghvl91J6CURRzik0EGvcqnfmwd
         5Y5w==
X-Gm-Message-State: AOAM532gSQzl2uPLJ28eYrmZMTD1owyuPhG7Ratw+X5bqztGbbCUyzLC
        H0wKtmdxherlTiaKSp9JK9eueqH4bfybHdg4tWEC8yd93zg=
X-Google-Smtp-Source: ABdhPJx3gox2PE+FRq9MlkMdVwU9cQ/+IzI+Hp1goX7S37aQVlEa5oEEKMuWtpsXaKpc3E1tR2RFFENbxHyUfI3KEAo=
X-Received: by 2002:a17:907:3f95:: with SMTP id hr21mr4181429ejc.427.1635939283898;
 Wed, 03 Nov 2021 04:34:43 -0700 (PDT)
MIME-Version: 1.0
References: <CAGgu=sBsiSVgr=uR95ZXFTtziLUO_LS4CW+6n2p2iBWxf2aq6A@mail.gmail.com>
 <YYJZMuOFNQiJ3rGC@kroah.com>
In-Reply-To: <YYJZMuOFNQiJ3rGC@kroah.com>
From:   Erik Ekman <erik@kryo.se>
Date:   Wed, 3 Nov 2021 12:34:33 +0100
Message-ID: <CAGgu=sDn4Oxx8sehyqVGc8rXFWf3Vf8QWWet8jO-9vUDgBO40w@mail.gmail.com>
Subject: Re: sfc: Fix reading non-legacy supported link modes
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 3 Nov 2021 at 10:41, Greg KH <gregkh@linuxfoundation.org> wrote:
>
> On Tue, Nov 02, 2021 at 09:58:22PM +0100, Erik Ekman wrote:
> > Upstream commit 041c61488236a5a84789083e3d9f0a51139b6edf
> >
> > Initially this just fixed 50G and 100G modes which felt rare enough to
> > not apply this to stable (also it got merged before I really had
> > thought about it).
> >
> > The testing mentioned in the change was actually from my development
> > of c62041c5ba ("sfc: Export fibre-specific supported link modes"). I
> > failed to mention the link between the two changes however and this
> > commit ended up in net-next (just merged) while the second ended up in
> > 5.15 via the net branch. The result is that for 5.15 even 10G cards
> > only show 1G as supported:
> >
> > $ ethtool ext
> >     Settings for ext:
> >     Supported ports: [ FIBRE ]
> >     Supported link modes:   1000baseT/Full
> >     Supported pause frame use: Symmetric Receive-only
> > [..]
> >
> > So this commit is needed at least for 5.15 to fix that.
> >
> > Fixes:  c62041c5ba ("sfc: Export fibre-specific supported link modes")
> >
> > It can also be applied further back if we want to fix the 50/100G
> > modes (from v4.16 I believe):
> >
> > Fixes: 5abb5e7f916 ("sfc: add bits for 25/50/100G supported/advertised speeds")
>
> I have queued this up for 5.10.y, 5.14.y, and 5.15.y now, but I need a
> backported version for 5.4.y and 4.19.y please.

Thank you! I sent the backported patch in another thread. (Plus some
noise, git send-email is hard)

/Erik
