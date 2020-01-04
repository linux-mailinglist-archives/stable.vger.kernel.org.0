Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 877F013050C
	for <lists+stable@lfdr.de>; Sun,  5 Jan 2020 00:28:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726205AbgADX2v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 Jan 2020 18:28:51 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:44764 "EHLO
        shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726191AbgADX2v (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 Jan 2020 18:28:51 -0500
Received: from [192.168.4.242] (helo=deadeye)
        by shadbolt.decadent.org.uk with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.89)
        (envelope-from <ben@decadent.org.uk>)
        id 1insqd-00087D-MC; Sat, 04 Jan 2020 23:28:47 +0000
Received: from ben by deadeye with local (Exim 4.93)
        (envelope-from <ben@decadent.org.uk>)
        id 1insqd-001suy-7u; Sat, 04 Jan 2020 23:28:47 +0000
Message-ID: <8e0a66fdcb3ad12bc8987ee92a041a38c8ff708a.camel@decadent.org.uk>
Subject: Re: [PATCH v3.16] sched/fair: Scale bandwidth quota and period
 without losing quota/period ratio precision
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Xuewei Zhang <xueweiz@google.com>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, Phil Auld <pauld@redhat.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Anton Blanchard <anton@ozlabs.org>,
        Ben Segall <bsegall@google.com>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>,
        Juri Lelli <juri.lelli@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>
Date:   Sat, 04 Jan 2020 23:28:41 +0000
In-Reply-To: <20191207011321.123774-1-xueweiz@google.com>
References: <20191207011321.123774-1-xueweiz@google.com>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-DWAqPBvmCsZleW3o64A6"
User-Agent: Evolution 3.34.1-2+b1 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 192.168.4.242
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-DWAqPBvmCsZleW3o64A6
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 2019-12-06 at 17:13 -0800, Xuewei Zhang wrote:
> commit 4929a4e6faa0f13289a67cae98139e727f0d4a97 upstream.
[...]

I included this in 3.16.80, thanks.

Ben.

--=20
Ben Hutchings
For every complex problem
there is a solution that is simple, neat, and wrong.



--=-DWAqPBvmCsZleW3o64A6
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAl4RH6kACgkQ57/I7JWG
EQnmsBAAxBXZiwGn2ck2bKKD6MhJ6rpW4dWS6PBAQ428BwN8/h3ro6OFCb0avOE1
LQJwu1c+/UBC4XsgkuiwK/Ayhfkj2KVwFy0WEc9iBiNaG8Tt8Dcm8faqQQSh4p+K
FQxNYHtnUfROME0hPV0E4FXmFPudpIhl7KYOCzg9+FEHSirzjkK37Ev21GqGr51Y
meBRBaGKoyZrSPp59DvgXDByQ8C2OBkQ6UV0U/miz17CzI0kdF8kcjHN2rRB5H4m
k7MMepaI8l7hzNhDBuaOGRQUJMZZkY41mfylypVFubRPGmdMRhAy1owyDqB4qFFh
paDuwFbwK47zmqUhJoCp5gdMNb4A4t7jmfwWYMri28mCV/OroTYufi4qlLvEy0tq
d8GU0RhNpaFV3okijtvuH3vvp/lmZXjBUuWdCIqf9rFfyVAzc2u1Yyr/styNLa4i
xF1Cgs3Qhne20QhF4Ju0S+SMRqeqOavjqFvKefJzlLHApUe63iq3UaRqUTpUuMad
m6NpCZYNjEyuoU8u3ncyq8Ly5kz5LGhwUa0hDTgOp4t3ZFmC8fBE4Igcw/MTpIFF
hyG+5YIaoZ9hHoAe0I+woxq7EmuU8AziI+xsnb6Hjw2Y+BLe8SVgW8RxGCmgUplt
CGyGPsV0mrKPYfokU+GHE9l/VJgcEchb9h3ugd5CgoYD7xl08HE=
=Wo9w
-----END PGP SIGNATURE-----

--=-DWAqPBvmCsZleW3o64A6--
