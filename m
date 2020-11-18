Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 670932B838B
	for <lists+stable@lfdr.de>; Wed, 18 Nov 2020 19:03:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726392AbgKRSC2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Nov 2020 13:02:28 -0500
Received: from mout.gmx.net ([212.227.17.21]:53653 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726304AbgKRSC2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 18 Nov 2020 13:02:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1605722541;
        bh=LyRhEQVedkvIGAQvW7hQnEopjq0o5ZQLyqMwf6FTgGg=;
        h=X-UI-Sender-Class:Subject:From:To:Cc:Date:In-Reply-To:References;
        b=jtbYzmMLHFuCF7R0vV3JYskp+NwaHkApk+0QbX72X+sT/HwlVl6rHYxIgLs1CatDA
         mLHEybzxfucxqlm9A8bykKgeaZJY4ZXK3u/MY2rfP/fuzqKL6E4TMcpaZdZk451kNT
         AxPGH81ZgkOov55YDt0cgYMr3mpCK/G96/7gmQAY=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.1.100] ([185.6.148.133]) by mail.gmx.com (mrgmx105
 [212.227.17.174]) with ESMTPSA (Nemesis) id 1Mdvqg-1k5qJf0z6U-00b0Fy; Wed, 18
 Nov 2020 19:02:21 +0100
Message-ID: <b50f0ee318cbedcd9bca95a1af00b520c4b3126b.camel@gmx.com>
Subject: Re: Suggestion: Lengthen the review period for stable releases from
 48 hours to 7 days.
From:   Hussam Al-Tayeb <ht990332@gmx.com>
To:     Sasha Levin <sashal@kernel.org>,
        Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc:     stable@vger.kernel.org
Date:   Wed, 18 Nov 2020 20:02:16 +0200
In-Reply-To: <20201118140953.GC629656@sasha-vm>
References: <17c526d0c5f8ed8584f7bee9afe1b73753d1c70b.camel@gmx.com>
         <20201117080141.GA6275@amd>
         <f4cb8d3de515e97d409fa5accca4e9965036bdb5.camel@gmx.com>
         <1605651898@msgid.manchmal.in-ulm.de> <20201118140953.GC629656@sasha-vm>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:yo3jUzkyFMSyo1lFbh2wfKFezPTK128RMznICPrEe/NN6lbBDnr
 6T8zlnvg5rfqvP9Eu6W9gAvIu4WdSkA0680yZVSO/gDFfLyrETI1uEmioHaNcORLftVqEkd
 N8w3BWCUPfJ83/3L+0wuRlM7C8qm4edRmqBkRJ+3efpPMbldHbHkJS+yx5tSFdY0AP+Pgpb
 NqWzVrxdalbe78NaqxpXA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:H7yznUboWdg=:8tZCCQf1zRHWReE+lrovKf
 e2rZlr//2lGy8zVGs1De5Yd5PdxY6Dvzv/QqZK9QpKewTa6r4yJBCeRhuVOXIq8a4Hlz1/2nn
 fZUtWywm9o6TFF7sjaJQdWAwKlouHcshjx9Eanlw2jpAospcl1pvus5wgJjmfWjfMt/1qI26G
 B6d6rR2Ar5roo9XvxXoUQNlB9W8kbidGwDiEHK41aEQ7YgSEH1q0iCEx2qnxUGXabsxCzNI0U
 BY90txb3M+rCxln6mPs51wcQtJQFA6sGEpo1XdWSiJqykFABkpQo/7Nn6P4MT8OvRKxrZy9de
 DAVaYwjwEjD8bLpK7cXMEuZVmLJuAoJajUIk3h924oRgCDbQWVldlQocMLIYuxwCn7G1WBrY9
 6g2lnP1E7LQwAAijBh6YcPFfco2F2SC1YdNrisW1yW66dOQFXWDNOHsXc5jUQhQVyLTt0syYt
 RPCEjiPZxyA5rBjMGEXPSGVSp9QsjF5xpurCaO4qOejYhtjwOTNGf4rZbFh3xl23DFnp62bYN
 fJHRwGI9yjsq0eT60KsDfrGv2AjlHpNj9eCc5da+UYmJH3wJ1mQk+RcGa0JpLCUTuCqFCJMT9
 7W22kSpXU+eWERIIHJWsm2UgELXqHeLmMjpsLTEjgByjBCoZvMA23V0O+dZmWdsjhF0u/vljy
 mzQfQqozsqzt7WasT32Fq/4K3LTvSYtSOgotZZz5+uJlgQg/PxnChYouah9LPS6pNeL836Gny
 5WGnGu0w43DjCkdiLYxupCLTTXQenX7l23N/ct8fiBwFSA5ybC5EEGcPo1mVEN9hWf6rCBrbH
 AZjEAYiGMMAUpwEvctt904kJsQKPci9rGfKP6R5hiy2b95Ncv5SB+BQ/i3bL3SnXb0LvBWxVX
 F1TogZfOC01of0xrKv9fTnzCLHRE0zBWvyVhGY6ls=
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-11-18 at 09:09 -0500, Sasha Levin wrote:
> On Tue, Nov 17, 2020 at 11:29:16PM +0100, Christoph Biedl wrote:
> > On the other hand the pace of the stable patches became fairly
> > high=C2=B9, so
> > during a week of -rc review a *lot* of them will queue up and I
> > predict
> > we'll see requests for fast-laning some of them. Also, a release
> > would
> > immediately be followed by the next -rc review period, a procedure
> > that
> > gives me a bad feeling.
>
> Keep in mind that the stable tree derives itself from Linus's tree -
> it's not a development tree on it's own and we don't control how many
> fixes flow into Linus's tree (and as a result into the stable tree).
>
> This means that it doesn't matter how long the review window is open
> for, you'll be getting the same time to review a single patch -
> whether
> we do 200 patches twice a week or 400 patches once a week. We can't
> create time by moving review windows around.
>

How long does it take for patches reaching Linux's tree to propagate
down to the stable trees and is there is mechanism for identifying
followup patches?
For instance, patch A fixes bug X but we eventually find out that this
patch did not fix all occurrences of the bug or caused a regression and
hence the author immediately sent patch B for inclusion in mainline
(Linux's tree).
Is patch B automatically identified for inclusion in stable as well?

In short, is there a guarantee that stable trees are as stable or
better than mainline through the current SOP?

Regards,
Hussam.

