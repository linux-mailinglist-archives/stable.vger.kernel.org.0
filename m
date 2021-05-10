Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 47A86378F0C
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 15:52:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232463AbhEJN1r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 09:27:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:56208 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233864AbhEJMQW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 08:16:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2238261400;
        Mon, 10 May 2021 12:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620648918;
        bh=OBCMH2gcLZFjPPaEZDZmxxA+rCGW/962pSkO5GoIyQI=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=oc1CyaCt7sXCmwG298GGY2FnbRGcaFQh9JZWKboHatgf+XuEg2F8Bo+SwPrGWOfRb
         SDCuP/ofAEFvd5wfxh5vV+7/qyVXZPEkxfd2bTwNlrJapnA5bP8kybnhjWUts038J7
         Nj48WuK73z8LWQeQR3sHaRneqN5fITSjdioAFr72ir4CKOvdgPRVVdDqw0w9xtXNvP
         UYEd5Sq5/re/3lifi5HltSu+TtXA/kR8BAb9AUnrDl6aNvpYd9zAaWNqZ5K6ROZ7Vc
         q1MqIxFdH+R0AXrs/6RO5UTNwJeeWwW8JgjPaDoNTVIbesPwWRJwuOjZy647lziVHf
         X2rl1NEly/MXQ==
From:   Felipe Balbi <balbi@kernel.org>
To:     Wesley Cheng <wcheng@codeaurora.org>, gregkh@linuxfoundation.org
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Thinh.Nguyen@synopsys.com, jackp@codeaurora.org,
        Wesley Cheng <wcheng@codeaurora.org>, stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: dwc3: gadget: Return success always for kick
 transfer in ep queue
In-Reply-To: <1620410119-24971-1-git-send-email-wcheng@codeaurora.org>
References: <1620410119-24971-1-git-send-email-wcheng@codeaurora.org>
Date:   Mon, 10 May 2021 15:15:08 +0300
Message-ID: <8735uuhjjn.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Wesley Cheng <wcheng@codeaurora.org> writes:

> If an error is received when issuing a start or update transfer
> command, the error handler will stop all active requests (including
> the current USB request), and call dwc3_gadget_giveback() to notify
> function drivers of the requests which have been stopped.  Avoid
> returning an error for kick transfer during EP queue, to remove
> duplicate cleanup operations on the request being queued.
>
> Fixes: 8d99087c2db8 ("usb: dwc3: gadget: Properly handle failed kick_tran=
sfer")
> cc: stable@vger.kernel.org

Wrong format here, should be:

Cc: <stable@vger.kernel.org>

Other than that:

Acked-by: Felipe Balbi <balbi@kernel.org>

=2D-=20
balbi

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQFFBAEBCAAvFiEE9DumQ60WEZ09LIErzlfNM9wDzUgFAmCZI8wRHGJhbGJpQGtl
cm5lbC5vcmcACgkQzlfNM9wDzUg8QAf+MvA/NY33hQlXDIQjnnR8fWFWI3ATCYWE
P+qUXO679ytbX5ftkSgJs2E9YCnoA4GzEIGue2fmBVhfr5TXDitPj4+tKeZtYjr8
wfNxpcVhxB7Phq4jKK+pGMPSzfXvPlQNTGpY4LdrOwIvIT94ry+DI8w1qF31RkYk
UC+1rpYqp83zHMurJRQEQd2kbMIBm6wkylUQmAlNH888bYQQP77VIIXe+DjEsBLb
JlolHK8A+/iz0JLiYY1Qf0MoPdExS96xZJLNJ2fOT2IbHy9Yo1Op3whVByZdthX8
LqH7sSOviFG9349Mn/N6tR9HcEH8dih6t6XzKzz78tzaCK2Kr/zKuA==
=jEvl
-----END PGP SIGNATURE-----
--=-=-=--
