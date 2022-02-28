Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 332BB4C787D
	for <lists+stable@lfdr.de>; Mon, 28 Feb 2022 20:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229676AbiB1TIj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 14:08:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229582AbiB1TIi (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 14:08:38 -0500
X-Greylist: delayed 1210 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 28 Feb 2022 11:07:58 PST
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7809F1AD83
        for <stable@vger.kernel.org>; Mon, 28 Feb 2022 11:07:57 -0800 (PST)
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nOl3h-0002Xl-Fz; Mon, 28 Feb 2022 19:47:45 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nOl3h-000LdT-96;
        Mon, 28 Feb 2022 19:47:45 +0100
Message-ID: <a4e0a5446a231fd67d1881d68047920918f1be65.camel@decadent.org.uk>
Subject: [stable] usb: gadget: Fix potential use-after-free
From:   Ben Hutchings <ben@decadent.org.uk>
To:     stable <stable@vger.kernel.org>
Cc:     Hangyu Hua <hbh25y@gmail.com>,
        Alan Stern <stern@rowland.harvard.edu>
Date:   Mon, 28 Feb 2022 19:47:31 +0100
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-APYLhG2FwCyErOHKaNkE"
User-Agent: Evolution 3.43.2-2 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-APYLhG2FwCyErOHKaNkE
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please pick these two commits for all stable branches:

commit 89f3594d0de58e8a57d92d497dea9fee3d4b9cda
Author: Hangyu Hua <hbh25y@gmail.com>
Date:   Sat Jan 1 01:21:37 2022 +0800
=20
    usb: gadget: don't release an existing dev->buf
=20
commit 501e38a5531efbd77d5c73c0ba838a889bfc1d74
Author: Hangyu Hua <hbh25y@gmail.com>
Date:   Sat Jan 1 01:21:38 2022 +0800
=20
    usb: gadget: clear related members when goto fail

Ben.

--=20
Ben Hutchings
The first rule of tautology club is the first rule of tautology club.

--=-APYLhG2FwCyErOHKaNkE
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmIdGMMACgkQ57/I7JWG
EQlPug//fZY91Lf1xK204c0gulV+houYOiindIzM34vN19EfHQKz9mz3OS2ZV8ZE
w6EboBHCUnwys1SCaw7E85/98c52ep0lUsVdKNSivHXS4fA0kns+35tUIPJ6oA7D
ipnta3AHfdOSoQfgYCJIh/UUAg2m0MYHSv7rS37CEecvEs/+W+JNPVMOUy6QgBu5
/QnWAPcaJolZgu57vNNM+vGLzUbOkzZH2C9uPOFCAu59b443/6nVcxN3clYVltAY
595R9BnK716/DQm0ifzCU00jUj0r14u+gr8B0sgcY4I0c2k8pWTJXldviMDsOXMP
E5F01B/ehWxyqy6JmFY91IexSfRn8xI2zT4BWegChZZzFMq10st+wuyat+tuSNBD
0GFHvmTbhIHpxMTdwDwuj6HrAPmXw6UilxjXhxip4tDY8n8ielmg27joNn+V6hQK
DrrsXKhpmnVeLW5Cu4BvnML18BlYJcC6qxlIo5ww+OEWIELh1RQxpRnpA/RIzFXW
ATTc+BF7sB9qjPLyAsSQ7lcXlQTwIrkXvyG4/+BZYVrb9laDxFNJIMfXXxO3ptyU
73Qkkv75efenkCJUWZDW3o0Qu5ndHlIiru0w02JtNOP/WJdjD+BjFqL3Sa1bBkqv
sMkP7NdCzqLgL6kdrBVYVW6SCFy81ooKfI0oUuTrMo1oomu71sI=
=bbw3
-----END PGP SIGNATURE-----

--=-APYLhG2FwCyErOHKaNkE--
