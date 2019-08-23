Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4EE19A460
	for <lists+stable@lfdr.de>; Fri, 23 Aug 2019 02:45:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731676AbfHWAmy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 20:42:54 -0400
Received: from mout.gmx.net ([212.227.17.22]:59639 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731209AbfHWAmy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 20:42:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1566520970;
        bh=VJWwbkuUeadllybh69tcaC2r8rjGFadHpNq2wx3bMnw=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=W4g6wta9zh19HxFFnSHVKBkUf3MwP9Fs1OJjp2yTsdHMYZfDy0lJiOmog7abcZuTV
         i05PSVjTYev3dArnaHpKekkLA6U8tK0mGqa9BYEpyn5T5uU13K0tQy830qI8Vp4p/p
         ktQPWGLm5AjpUq3c2RV+apwJm7mEwG57Vk9zD3hU=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mir ([217.249.121.199]) by mail.gmx.com (mrgmx104
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MAfUe-1i7XFJ48bo-00B0PY; Fri, 23
 Aug 2019 02:42:50 +0200
Date:   Fri, 23 Aug 2019 02:42:48 +0200
From:   Stefan Lippers-Hollmann <s.l-h@gmx.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 5.2 000/135] 5.2.10-stable review
Message-ID: <20190823024248.11e2dac3@mir>
In-Reply-To: <20190822233847.GB24034@kroah.com>
References: <20190822170811.13303-1-sashal@kernel.org>
        <20190822172619.GA22458@kroah.com>
        <20190823000527.0ea91c6b@mir>
        <20190822233847.GB24034@kroah.com>
X-Mailer: Claws Mail 3.17.4 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:NgYm4zfQZN/NFd5JKzKX90KTfKNIfrU+VyPQd5vZvm3N9SUn6ei
 Zqmfddu22QNfcW134UXPhckvxrsHv04HAXGEMlux0cHx+FsfKiBP91XbIh7CcO/LZq6Ywwd
 l0YK89wNgPvdHpdfuXHP3UGg5X7bUj0QDprvIuG7PXEROaHKtTKkCQCW9aL4Rk3ICsYu/0F
 0G2TuPVH3BvGWAkW+tc2w==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:imq1p7lE/E8=:TrimsCHEcSXheZOow+zUEw
 ddfFP2PEZI5PJWvh18aJ8M38jC/xU+HSia2escjDHDYFppcHxaQ76vEKlT1r3hksH+NeTbCPi
 noDYlOXUxVFzu3x8G5yeZswKRMwKmBAXx4ebiJdCjRJOXF/2q3bRZpm5QTEd6QLE+3ef43Yj/
 oS5YAcTx3FjRivGVdV5T6brYMAcSyvY7P8JblcC7NrzjzdJqHPXqkCWmisUtBe5/LzONNj+F0
 6z/6l1bveFR7NgnQg8JkpnA0NhUCq+9+UuUzqK4Y2Lc3MqcfXmE9vuhcxsfoWl221CoLxN5cD
 ouutKrisL0gO1mxVcPiTtyhJaOndZgCdnSAntJFlBqXnuIy9eC219BKZLl9ii6HfbepnXM+du
 +Jfx1iFxzncev5+yw9WUi0Ep+PH/wZHYzt/6gUMks4qd3k9vISzmQKkiNC9XSZ7c7eQWBiR8O
 5ZVynky3GwNxYGSMMSO3ayNpdwrhD2gnkHOxsFH6LYKTrj34ejHOXrf+ru+nDVJ2Fo7pnMypI
 82pluWvaBo8hGlI4bAa6muAK1vHfc0ZQyZPHbtLYurHa9tJ6O3FuAitKHr9Q3RLGUXDaoI9wg
 hKlezUFvF5FId8RhrMsdJdpm4v7rQEOXH0G35/xJnABh8Dvnls1q365TLQYUtYfMiwmnFsCig
 osDeGijGe629RbHXP3pqL7yYgnaAO3uUGFY4h9TkEBA7iE6cJ3W01ZxeR2gWtuoUMwwoDcoki
 7RcjiAh20anXjgUM5LOegy+Cat5ByOQ7yUspZ7sM0A8TlJ0Wm6Dx+wiE5H7TV8uyUVOqrRbA8
 0+f+wYuwFp6y634WXpEe3oP0FsZ0ArYOu8HWzM/TBVC3BedZclhAhBiE9lbgBjSG+E/3m2krY
 C89AbLSqwxPC3fmpHHLtXodKvyBXtbZFZQLVChaibmuO2LO3zZjuU0CgtDIcSyCXaJJ09zY+S
 t+ZiM69JagFMWrAx2EJh0r+OciTuAVJarNH20TZGfaHvvw3S130J3s0YPaorAzYPxkITGuQEm
 hntY5xFd+h76LIBIYK43+4+khXznVj1I9DWuU8DPFPIuPcDk91jkFL33EzfxUACLEvG6RYkGM
 7hS0ys+tWKPviMNP4q7v/kO59pNJ439xSnqPzfiO8OwqQ/sw+9HiHOGpjbtmh3cQCT9DYEA8f
 Hq9jo=
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

On 2019-08-22, Greg KH wrote:
> On Fri, Aug 23, 2019 at 12:05:27AM +0200, Stefan Lippers-Hollmann wrote:
> > On 2019-08-22, Greg KH wrote:
> > > On Thu, Aug 22, 2019 at 01:05:56PM -0400, Sasha Levin wrote:
[...]
> > It might be down to kernel.org mirroring, but the patch file doesn't
> > seem to be available yet (404), both in the wrong location listed
> > above - and the expected one under
> >
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.2.=
10-rc1.gz
[...]
> Ah, no, it's not a mirroring problem, Sasha and I didn't know if anyone
> was actually using the patch files anymore, so it was simpler to do a
> release without them to see what happens. :)
>
> Do you rely on these, or can you use the -rc git tree or the quilt
> series?  If you do rely on them, we will work to fix this, it just
> involves some scripting that we didn't get done this morning.

"Rely" is a strong word, I can adapt if they're going away, but
I've been using them so far, as in (slightly simplified):

$ cd patches/upstream/
$ wget https://cdn.kernel.org/pub/linux/kernel/v5.x/patch-5.2.9.xz
$ xz -d patch-5.2.9.xz
$ wget https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.=
2.10-rc1.gz
$ gunzip patch-5.2.10-rc1.gz
$ vim ../series
$ quilt ...

I can switch to importing the quilt queue with some sed magic (and I
already do that, if interesting or just a larger amounts of patches are
queuing up for more than a day or two), but using the -rc patches has
been convenient in that semi-manual workflow, also to make sure to really
get and test the formal -rc patch, rather than something inbetween.

( When testing -rc patches under e.g. OpenWrt (ipq806x (ARMv7), ath79
  (mips 74Kc), lantiq (mips 24Kc)), importing larger numbers of patches
  (which will go away two or three days later anyways) also easily gets
  a little unwieldy (adding sequence numbers, as the quilt series only
  gets assembled later, on the fly in alphabetical order), so I'd
  probably have to squash them together for those purposes myself - not
  a problem, just less convenient for quick ad-hoc testing. )

But again, none of these procedures are set in stone and I can adapt as
needed - there've been bigger changes in the past and this is mostly
about retraining muscle memory (and writing some simple new scripts to
partially automate things).

Thanks a lot for your efforts, the whole -stable maintenance has really
improved kernel quality compared to the status quo ante. I'm testing
basically each -rc kernel for the current -stable release (so only v5.2
at the moment) on x86_64 and x86, a bit less regularly on ipq8064/ ath79/
lantiq (v4.19 at the moment), but only reply if I actually notice an
issue.

Regards
	Stefan Lippers-Hollmann
