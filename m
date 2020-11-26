Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5A5FD2C5E0A
	for <lists+stable@lfdr.de>; Fri, 27 Nov 2020 00:04:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbgKZXES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 26 Nov 2020 18:04:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726357AbgKZXER (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 26 Nov 2020 18:04:17 -0500
Received: from mout-p-102.mailbox.org (mout-p-102.mailbox.org [IPv6:2001:67c:2050::465:102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE20C0613D4;
        Thu, 26 Nov 2020 15:04:17 -0800 (PST)
Received: from smtp2.mailbox.org (smtp2.mailbox.org [IPv6:2001:67c:2050:105:465:1:2:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-102.mailbox.org (Postfix) with ESMTPS id 4ChtcF3GSnzQlL9;
        Fri, 27 Nov 2020 00:04:13 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hauke-m.de; s=MBO0001;
        t=1606431851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=gdpbIL1RJr7VCVT4Nh17X4Zo+RhqzqfYeFYLgoT5qgI=;
        b=GLNIS5kC1VCvSr9QG+TNTCMHphSexZMEf5djjrwNyW7gcD9oEJaKSiYLnh7NsmnczOgX63
        Ln3Fp72Uk6whWVZj5h3P8oXc9DH4VUN+mg3kUwGtEgVQgW8oe2kKVARtBnqUqOBWfhxgjw
        lko+tp+R4d8NCoP2waXT6PIymg6JW2e+7Y7hO07XKawDn+QGSjqeRe/cmSbykSX9Rp1uaO
        LpeV7fzRkV4y0kLYTIJtHM54bN0+Q7rZrNaX68Sg8v+/fRxP/GxSZ+CNs6CooT7tn/0TVo
        B2BNI1zJ0aDBS8qF8bPpWncRXVY2m6xD1BruNKpXg6y5aUULiKz5hm9266+Hag==
Received: from smtp2.mailbox.org ([80.241.60.241])
        by hefe.heinlein-support.de (hefe.heinlein-support.de [91.198.250.172]) (amavisd-new, port 10030)
        with ESMTP id NU6pobBJgaJe; Fri, 27 Nov 2020 00:04:09 +0100 (CET)
To:     stable <stable@vger.kernel.org>
From:   Hauke Mehrtens <hauke@hauke-m.de>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        linux-wireless@vger.kernel.org
Subject: stable backport of "wireless: Use linux/stddef.h instead of stddef.h"
Message-ID: <f1958cd2-bd9e-5141-8aa2-f8729dd76719@hauke-m.de>
Date:   Fri, 27 Nov 2020 00:04:00 +0100
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="iy406QBycnYcQCM3AJn1Zxp1phFO38g3s"
X-MBO-SPAM-Probability: 
X-Rspamd-Score: -7.82 / 15.00 / 15.00
X-Rspamd-Queue-Id: 347D216FD
X-Rspamd-UID: 250ecd
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--iy406QBycnYcQCM3AJn1Zxp1phFO38g3s
Content-Type: multipart/mixed; boundary="uGmWxNILrWcoxDqgLM5mlGajfbyGuyQPA";
 protected-headers="v1"
From: Hauke Mehrtens <hauke@hauke-m.de>
To: stable <stable@vger.kernel.org>
Cc: Johannes Berg <johannes.berg@intel.com>, linux-wireless@vger.kernel.org
Message-ID: <f1958cd2-bd9e-5141-8aa2-f8729dd76719@hauke-m.de>
Subject: stable backport of "wireless: Use linux/stddef.h instead of stddef.h"

--uGmWxNILrWcoxDqgLM5mlGajfbyGuyQPA
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Hi,

Please backport "wireless: Use linux/stddef.h instead of stddef.h" to=20
kernel 4.14, 4.19 and 5.4.
This is upstream commit id 1b9ae0c92925ac40489be526d67d0010d0724ce0
https://git.kernel.org/linus/1b9ae0c92925ac40489be526d67d0010d0724ce0

commit 1b9ae0c92925ac40489be526d67d0010d0724ce0
Author: Hauke Mehrtens <hauke@hauke-m.de>
Date:   Thu May 21 22:14:22 2020 +0200

     wireless: Use linux/stddef.h instead of stddef.h

This patch fixes a build problem in broken build environments which was=20
introduced with 6989310f5d43 ("wireless: Use offsetof instead of custom=20
macro.") which was backported to the listed kernel versions.

When the include path is fully correct you should not hit this problem,=20
but I got it because of some bug in by build system and also someone=20
else reported a similar problem to me and requested this backport.

Hauke


--uGmWxNILrWcoxDqgLM5mlGajfbyGuyQPA--

--iy406QBycnYcQCM3AJn1Zxp1phFO38g3s
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEyz0/uAcd+JwXmwtD8bdnhZyy68cFAl/ANGAACgkQ8bdnhZyy
68c/xwgA03ETcZSephZocpZbRzdspgN3MlIZ+cK+zgb7SvWjLwT1D/G6Umlm3utt
dO9AJBwJwKfk5HF4t8HIkp0PWMrflWkZQTGxOwtdK+SEfJ0Qhth9huavXOEdm8Q7
SHLAQAkI15eb1Wbmrx91ktjF/YZdPuVHEBidX4sYDyEahx5eFCYq8n21u0SVlPXd
4rRV4a+g/qWyMVpsli6LaZ41ql21f+hxsGMf7XYwS8K2Y8a7hbo+nu8dYSSHeIpd
qznxZHbQGKgYjLkTpyETlXfqy9GsUhZpSsS1Jn9AymOdO5IzifUAEuqGD4b6OXws
HSt1DfkmxM2et5T6bMhQHFJobMnHIQ==
=TCga
-----END PGP SIGNATURE-----

--iy406QBycnYcQCM3AJn1Zxp1phFO38g3s--
