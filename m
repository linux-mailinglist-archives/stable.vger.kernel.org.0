Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 154DDBDE3A
	for <lists+stable@lfdr.de>; Wed, 25 Sep 2019 14:45:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732470AbfIYMpR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 Sep 2019 08:45:17 -0400
Received: from mail1.protonmail.ch ([185.70.40.18]:25195 "EHLO
        mail1.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726369AbfIYMpR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 Sep 2019 08:45:17 -0400
Date:   Wed, 25 Sep 2019 12:45:06 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=harmenstoppels.nl;
        s=protonmail; t=1569415512;
        bh=s0dkSqKPl00TQROsjdWs18AylmDuaRW3gePyOunZ3oo=;
        h=Date:To:From:Reply-To:Subject:Feedback-ID:From;
        b=O0uCvnfNH7cEAUB6kY7dCF4GonVY2DhSHdKxChANBGg7yoUWTt0Hb/pmn2Lbk0cGY
         8qpZYPJeJcpbwMcDZonculfiV/gneutdbzdeUe8uTWK0400/ZeF6dhTHdRzZkklazw
         pU81Wh9/NhkeWMSNf8Sh4qXYbNpZq208n59D3AKE=
To:     "stable@vger.kernel.org" <stable@vger.kernel.org>
From:   Harmen Stoppels <me@harmenstoppels.nl>
Reply-To: Harmen Stoppels <me@harmenstoppels.nl>
Subject: Revert "Bluetooth: validate BLE connection interval updates"
Message-ID: <vGzt5wshxYXxE0RkVBTLwAKuxpSX7Ik55SyACyeWo7B65PkEParWOuOFwOurc3KMTUcG4lmrGIsR35YBZlqFqQcMi9WuAYuZeuBoArlygRs=@harmenstoppels.nl>
Feedback-ID: rdWrTHRoF_MHe1IVW0u8ihXn9c5rqtFcF9eCRubjTwp6JwB4q5jHhTfcJinDcVo8JNCHMqJlYdrJl20zDNyG_w==:Ext:ProtonMail
MIME-Version: 1.0
Content-Type: multipart/signed; protocol="application/pgp-signature"; micalg=pgp-sha256; boundary="---------------------0ca449983f99785b10f6508a3abe5cc3"; charset=UTF-8
X-Spam-Status: No, score=-1.2 required=7.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF autolearn=ham
        autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on mail.protonmail.ch
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
-----------------------0ca449983f99785b10f6508a3abe5cc3
Content-Type: multipart/mixed;boundary=---------------------041aa1da58a1391277549bc81ac6d99d

-----------------------041aa1da58a1391277549bc81ac6d99d
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;charset=utf-8

Hi,

It would be great when 'Revert "Bluetooth: validate BLE connection interva=
l updates"' was backported to Linux 4.14 (and above). The original patch '=
Bluetooth: validate BLE connection interval updates' has caused BLE device=
s to automatically disconnect after a few attempts negotiating connection =
parameters with 'unacceptable' intervals as the defaults in the kernel cha=
nged.

subject: Revert "Bluetooth: validate BLE connection interval updates"
commit id: 68d19d7d995759b96169da5aac313363f92a9075

Best regards,

Harmen Stoppels
-----------------------041aa1da58a1391277549bc81ac6d99d
Content-Type: application/pgp-keys; filename="publickey - me@harmenstoppels.nl - 0xFD537C88.asc"; name="publickey - me@harmenstoppels.nl - 0xFD537C88.asc"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="publickey - me@harmenstoppels.nl - 0xFD537C88.asc"; name="publickey - me@harmenstoppels.nl - 0xFD537C88.asc"

LS0tLS1CRUdJTiBQR1AgUFVCTElDIEtFWSBCTE9DSy0tLS0tDQpWZXJzaW9uOiBPcGVuUEdQLmpz
IHY0LjYuMg0KQ29tbWVudDogaHR0cHM6Ly9vcGVucGdwanMub3JnDQoNCnhzQk5CRm5SYTFJQkNB
RE9yWkVyVVRjQ2pKYW0zZHpHK1MwYXRjZEthRnAydHJvRzV0aEt0WmlLdW9HRA0KVGZZaU9VRURE
dXd1RlkvMWJBdmYvWHlmMXFYZTVyNmRTNFZNUGJYb2lqbTVMWmZjZnUzZVdLcysrZ1czDQp2N0g0
MU5VbDRFa2pjalc2ejVEWXlKRkJ0amhFVmM4d3ZNY1dGQ3JwNWY0cnlxbWhpNTJVWTJxb0tEclUN
CkpkNmw3OHNuemtHYlJsNVczSVRuRUx3TTdXU1dUeTRuOGVpdGRENkNsRFZPeGpEeGVIQXdXV296
TW90eg0KR2dDd2ViWmgxV2htVXI0NVJDNEQvQ0pNMmRwa3NxM29uNXBwSEU0eFZORVJpL1pPVXZs
Q01Gby8wOFg1DQpET2pmTmh3NTlkZFJyUHNsU2xMUU0vdWxaTVdBSnJHMGgyU0I3d3Y5ODgxQ252
dTFXVDNvMUk1dEFCRUINCkFBSE5LMjFsUUdoaGNtMWxibk4wYjNCd1pXeHpMbTVzSUR4dFpVQm9Z
WEp0Wlc1emRHOXdjR1ZzY3k1dQ0KYkQ3Q3dIOEVFQUVJQUNrRkFsblJhMVFHQ3drSENBTUNDUkNO
SE9GdlpmbUVnZ1FWQ0FvQ0F4WUNBUUlaDQpBUUliQXdJZUFRQUtDUkNOSE9GdlpmbUVnbmU2Q0FD
M3YwczVHYkpoWERSZkFia1dWTElDUm9oRWJWUm8NCjI2QWVBKy9YTHlKZmFNZThhWkFMRlBXaW5L
VVNwdEY1N2JYQnQrVGJ2dEJmcjh3Wk1EZE5HMnI0U0E3dw0KTnFadC9Edks2Q2xlN0dybmZlRFl2
NjlqT1QreXJ4aDhEc1IzV3p6QXZZV1FXVU1MRFVENjlDSEJIMjVkDQozbEFVYlFOWjgwQ09XYVJi
ODFrVW1TUmN3ejNub1dPLyt0OS9JdU5MR3RvT25wamgrYWVtZzVBbVo5WDUNCnROeFBmcTc4Qzd6
bUNXNGJ6dUV2QXM3N0tPZXdnZE9FWmFrOUJXTDFpQUlyS1pOS1NzVzd2V0kxUjF2NQ0KbU1Gbkk2
NThVWnVtYUY1SWk4SzZsU00rTUQ2a1QreGhBZEQzaE5iRm03dnA3bWdaRjB6WnZkdXNBTGFKDQov
RmpvRlB6QWtwZEN6c0JOQkZuUmExSUJDQURYRENEZmNhV053RkZwNytNSzRMVVlTOUZMVDRuK2pK
RXcNCjNKNnNlVWNiQzNuTDIycEN5Vy9MZDdUVzl5bEw5aXM4M2xMVThsMG1Sb3NZZ2hvWktZMWpE
RFJNQ2tZLw0Kaysrekt4dUJKZkh3QmZLY2ZvZzVmQnU4L2hjUm1ZQVFIK2dmZytGdU9yTXhwVTk0
NmxsQVp1QkJ5SXh1DQpDNFpwK0lSTjlMbloxcFRPU0VqNmZYWXNsVzZsRnJqRW13MVFsMUxYME1C
OXdpR1hrN2h4UkxCaVM5bmkNCkRrUTBRbVNGMjhPNkd1dGQrelZSYXJhSXkyUHhaL1Y0NHI1ejVS
NDVNMFB5UXVUMVUzdUFXejYralBDMw0KT2NBa05QUy9MQ1hkdk16TmtxQXhSQmJ1cXZUd0JiTWhO
YTZkdC9FeWUrY0F6WEFLNmJBTnhZai9rNk1mDQp3bkpodVllakFCRUJBQUhDd0drRUdBRUlBQk1G
QWxuUmExVUpFSTBjNFc5bCtZU0NBaHNNQUFvSkVJMGMNCjRXOWwrWVNDT3dJSUFKUGE3QjdubDda
RmNMYkV1WjlNWXhjaWgrYVNFOUJLdkt1WWhRWGo3ZHZZRFBBWg0KejFCOGxCTUVGbDcvT0t4TDlK
c0NEMHJ4L2VhUWpXQU1IRUExSVJYQ0s0a2FKaVZOeElPb0FUc3laS1VyDQpxOEtrOWd6cGVrTFl5
eU9PM1JUWFJMWFFtRDB6dWI0bEtNRnZqb0cwU2xrTDVBbm1QbWF2YlV4anJ6KzINClFIcGRQdUE2
elZ3VzBOcjF2dldUVXZraWJIVFJLcFE5c3RLbFdyUzlqWWk1NDA1SWl0dnNjdDBEOWNmcA0KaWVX
SXJJNGh3dzY2UEJidjhNTEFjSmYvaWplT1lEUGNBcWMwMzE2TlZIQUk3aWJuTFVjZ2FIRTRwMVVO
DQpmRFcxM3dvb0VkdW5LZG5BOXNUbkx4bWZsMFpySXNBR3p0U2tEQ09zZVg4NWR1YlRwb3NTNjBZ
PQ0KPU9MdWUNCi0tLS0tRU5EIFBHUCBQVUJMSUMgS0VZIEJMT0NLLS0tLS0NCg==
-----------------------041aa1da58a1391277549bc81ac6d99d--

-----------------------0ca449983f99785b10f6508a3abe5cc3
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: ProtonMail

wsBcBAEBCAAGBQJdi2FRAAoJEI0c4W9l+YSCnQ8H/1tM1HdYhHlQT8H4uPnV
BYRWWGwhdMgMBTk/lH6vBopXnGAdCVbR6N25TB1do3ENWK5lxytWKlFC6luN
94rmpLr1dDtfseorEuxDLYmLtm7xali6T8ot0V7Un2tXHfhrkCVj2hcT/BRq
73GxgCC8xLJo5F10H58YzcJOoctmr8WIhEM0/HZVts1rxMVsld6XEgBWXQyT
5H9EHB0ZglN6jUx43iqB+13ArSn3DWPba/Pe/ZAioJ94XdViV9y8uyZeVa45
mSj4YESY7OASwbcCizSAdEMYYEE8jL3UEu56OBgvuqVrVMiQzMakXYi3+2Xg
qwx+GvM8mym0XStS0EGnSDw=
=RGYd
-----END PGP SIGNATURE-----


-----------------------0ca449983f99785b10f6508a3abe5cc3--

