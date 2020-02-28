Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 33840173339
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 09:47:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726378AbgB1Irb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 03:47:31 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:36105 "EHLO
        Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726005AbgB1Irb (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Feb 2020 03:47:31 -0500
Received: from p5b06da28.dip0.t-ipconnect.de ([91.6.218.40] helo=kurt)
        by Galois.linutronix.de with esmtpsa (TLS1.2:RSA_AES_256_CBC_SHA1:256)
        (Exim 4.80)
        (envelope-from <kurt@linutronix.de>)
        id 1j7bIt-0003sR-EZ; Fri, 28 Feb 2020 09:47:27 +0100
From:   Kurt Kanzenbach <kurt@linutronix.de>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, lirongqing@baidu.com,
        stable@vger.kernel.org, vikram.pandita@ti.com
Subject: Re: FAILED: patch "[PATCH] serial: 8250: Check UPF_IRQ_SHARED in advance" failed to apply to 4.14-stable tree
In-Reply-To: <20200227095908.GC1224808@smile.fi.intel.com>
References: <158271336456142@kroah.com> <20200226233949.GC22178@sasha-vm> <20200227095908.GC1224808@smile.fi.intel.com>
Date:   Fri, 28 Feb 2020 09:47:16 +0100
Message-ID: <87r1yf2j57.fsf@kurt>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha512; protocol="application/pgp-signature"
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Hi,

On Thu Feb 27 2020, Andy Shevchenko wrote:
> On Wed, Feb 26, 2020 at 06:39:49PM -0500, Sasha Levin wrote:
>> On Wed, Feb 26, 2020 at 11:36:04AM +0100, gregkh@linuxfoundation.org wro=
te:
>
> ...
>
>> > Since this change we don't need to have custom solutions in 8250_aspee=
d_vuart
>> > and 8250_of drivers, thus, drop them.
>> >=20
>> > Fixes: 1c2f04937b3e ("serial: 8250: add IRQ trigger support")
>> > Reported-by: Li RongQing <lirongqing@baidu.com>
>> > Cc: Kurt Kanzenbach <kurt@linutronix.de>
>> > Cc: Vikram Pandita <vikram.pandita@ti.com>
>> > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> > Cc: stable <stable@vger.kernel.org>
>> > Acked-by: Kurt Kanzenbach <kurt@linutronix.de>
>> > Link: https://lore.kernel.org/r/20200211135559.85960-1-andriy.shevchen=
ko@linux.intel.com
>> > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>>=20
>> For 4.14, I've worked around these missing commits:
>>=20
>> 5909c0bf9c7a ("serial/aspeed-vuart: Implement quick throttle mechanism")
>> 989983ea849d ("serial/aspeed-vuart: Implement rx throttling")
>> 54e53b2e8081 ("tty: serial: 8250: pass IRQ shared flag to UART ports")
>
> Thanks!
>
>> And queued up a backport. Older kernels are a bit trickier than that.

Thanks for backporting. Why is it trickier?

>
> Since it's quite old bug and not many reports so far I guess we are not in
> hurry to fix that old kernels.

It would be quite nice to have that in v4.9 as well. My original patch
was made against that tree and tested.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCgAdFiEEooWgvezyxHPhdEojeSpbgcuY8KYFAl5Y05QACgkQeSpbgcuY
8Kapzw/9HdjYJfUyxclUHQSFQDN8AifUZH87pbf2hwGAd/DlWYtmdwyim039E8S0
RpQx9TKTEobf57dT26m5cJV6FrjfTM81jNX8MMANcghYqKiVgZIDFXkO0kt6FHqb
YBBKUDh17lsh8N/NduQjb7js4y50h307JzsrghRGCJEkbhjyycYafnvrHEGDIdAD
XqRS3MAXKECYZhQBq0g+HYclHA+1tdcJjHtJ/YyvVIrr1K48HzV8/tSUVUYTIzod
TwF2SM8BTobJLS4uyBmFc87EwLXuRXDCJibi+ozQ8qJf7PRtNj0FNLDYOeueIE3k
XjEFp0oxipb/B3260moT5qxi+pmoXw+fDk9+/gL2NAYVx3zRlsqz9zB+0MENT0Pb
UXSiELXa6o/GoyEqJ0WWXcJQC3NXeMrpoZLGPICqHJy+2e2qtNHoNlGwJ0GclgCK
27lgGDa0drW6kXa8qQmtNLK3NzZDuhxcDWig/WeofAHv+OCxR0Sks0of9mEuXBY3
FxOaywCF0Bu3BnvgBmVp8MW9wsCZw30FFcn9KNr0DP6kckH+8xpDZlBxaFkCUavk
JgLqfeihDd03vQTAvqqBEwlBKkUZGkKIdzuWSLWJrgcO5fzvKbRi/HegVsp6sL0m
AvvbeiKqR73E5RR7sbXrTxRahgUvfNbjR59qY1Kj9azxD9YLi9w=
=SVA4
-----END PGP SIGNATURE-----
--=-=-=--
