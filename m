Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DA584336BB
	for <lists+stable@lfdr.de>; Tue, 19 Oct 2021 15:13:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235628AbhJSNPv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Oct 2021 09:15:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbhJSNPv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Oct 2021 09:15:51 -0400
X-Greylist: delayed 332 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 19 Oct 2021 06:13:38 PDT
Received: from mail.sgstbr.de (mail.sgstbr.de [IPv6:2a01:4f8:a1:1223::10])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 25DC8C06161C
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 06:13:38 -0700 (PDT)
Received: from [IPV6:2a02:810d:9880:6700:1fd1:4b8:692c:b70e] (unknown [IPv6:2a02:810d:9880:6700:1fd1:4b8:692c:b70e])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: fabian@blaese.de)
        by mail.sgstbr.de (Postfix) with ESMTPSA id B57AD204B75
        for <stable@vger.kernel.org>; Tue, 19 Oct 2021 15:08:03 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=blaese.de; s=201803;
        t=1634648883; bh=YeMG788q1Mr3jzvdV3otDflWelxCOg8d1NBbHvaZ5ok=;
        h=Date:To:From:Subject:From;
        b=wwl+RJEuwjMZFB1RQqkW9QtMNmmMYRWrwwwG3p9j7mNpiQNs+zpzahScdssWfqNk0
         Iq03teCiibZXon22Oj8s6Bx/be5gxStMivqdRJRwF1L/rAYatuWHxQCty53OWo6DDv
         LsCLN5rmH+jiYjcCtsEVT1L0wFeInUTOW/8qihVG4zQst0WcOk8OOOoPZ29N0hSsIN
         hgClmkbNKGKTy6s1jf78oz4zZW55+e6Epm7hJFzqboF6QI3CvNvlSFrrUeMR5JMylI
         ya/drBVEMKOLctgTA01BK24m0xcx6mrjcatDQoD+/1gVzW0A/NZgCTiH0tL+7LwkvZ
         9ePpv2oyfcOrw==
Message-ID: <4be2f5fb-9694-2244-9d5f-a85edff0199f@blaese.de>
Date:   Tue, 19 Oct 2021 15:08:00 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.0
Content-Language: en-US
To:     stable@vger.kernel.org
From:   =?UTF-8?Q?Fabian_Bl=c3=a4se?= <fabian@blaese.de>
Subject: Backport switchdev fix for bridge-in-bridge configurations to
 linux-5.4
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------ZgWlD8B5xihFLhkYUsTny7Hy"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------ZgWlD8B5xihFLhkYUsTny7Hy
Content-Type: multipart/mixed; boundary="------------htT0ZYLiflFoQon0dlETSw76";
 protected-headers="v1"
From: =?UTF-8?Q?Fabian_Bl=c3=a4se?= <fabian@blaese.de>
To: stable@vger.kernel.org
Message-ID: <4be2f5fb-9694-2244-9d5f-a85edff0199f@blaese.de>
Subject: Backport switchdev fix for bridge-in-bridge configurations to
 linux-5.4

--------------htT0ZYLiflFoQon0dlETSw76
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

DQpIaSwNCg0KSXMgaXQgcG9zc2libGUgdG8gYmFja3BvcnQgdGhlIGNvbW1pdCAibmV0OiBz
d2l0Y2hkZXY6IGRvIG5vdCBwcm9wYWdhdGUgYnJpZGdlIHVwZGF0ZXMgYWNyb3NzIGJyaWRn
ZXMiIFsxXSB0byBsaW51eC01LjQ/DQoNClRoaXMgcGF0Y2ggZml4ZXMgZmF1bHR5IGhhcmR3
YXJlIGNvbmZpZ3VyYXRpb24gd2hlbiBuZXN0aW5nIERTQS1vZmZsb2FkZWQgYnJpZGdlcyBp
bnRvIHNvZnR3YXJlIGJyaWRnZXMsIHdoaWNoIGNhbiBjYXVzZSB2bGFuX2ZpbHRlcmluZyB0
byBiZSBkaXNhYmxlZCBpbiBoYXJkd2FyZSwgZXZlbiB0aG91Z2ggaXQgc2hvdWxkIGJlIGVu
YWJsZWQuIFRoZXJlZm9yZSwgcG9ydHMvdmxhbnMgZ2V0IGNvbm5lY3RlZCwgZXZlbiB0aG91
Z2ggdGhleSBzaG91bGQgYmUgaXNvbGF0ZWQuDQoNCkEgYmFja3BvcnQgb2YgdGhpcyBwYXRj
aCBmb3IgbGludXgtNS40IGhhcyByZWNlbnRseSBiZWVuIGFjY2VwdGVkIGluIE9wZW5XcnQg
WzJdDQoNCkJlc3QgcmVnYXJkcywNCkZhYmlhbiBCbMOkc2UNCg0KWzFdIDA3YzZmOTgwNWYx
MmYxYmI1MzhlZjE2NWEwOTJiMzAwMzUwMzg0YWENClsyXSBodHRwczovL2dpdGh1Yi5jb20v
b3BlbndydC9vcGVud3J0L3B1bGwvNDQ5Mw0K

--------------htT0ZYLiflFoQon0dlETSw76--

--------------ZgWlD8B5xihFLhkYUsTny7Hy
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

iQIzBAEBCAAdFiEEJ7vc7QVhZ31uPwNHRNkkPenpIZUFAmFuwzAACgkQRNkkPenp
IZUZiQ/+IkE8RQCdbThzTMT1Xw6nWUzVX1L7ZJJRiqz7WXMjRKnoPQRfwO0RByDT
KuhULchy1b8/mZWZMBSy33L/ldwqRnXsYCMQtx3J3f9zB8w05CkjgRrmxN2mV6ri
0/pJRn2zPYNwDCEytiD7rctjRbIFgNToRYxkdRs8J75vj+HfSWHHOEt8obQiMCCa
xL5OGp6p+LJTNNvsfPSBUvLvz2Y4Y+2fwLH/U5vKAIyVRCEJ3KuXGn2Rbik0Cmxo
LWaVeAhY3zpOFjAlnRA0A4lSlaQ3SXKEqWBhI5HroLTY1HcDPo13IEyf6vvlAz90
6o0PLv39ETVNq5LnFFZ2gmOVVilbV9ikDE3pZzlCRWFzHJqIqps4kmJ/Y3Wx1hC2
i+h+07PrFdOGYH4aCuQ6lUIWQMlxlzUo11b0EONHABd/LUeZSeatvJFKcYVYSkes
OtTvemQ+BlfhFvzC76B1cSuhKqZ9kHk/VDt3WivSlrqvybYHyW/uM5aknbGUFNLc
0FMmg22j9ccPTgggrMR3XOdTIlfHd3uVcGZIlIcT6SL0UEs10al5nYgAglnvWtXf
oPO0kDLUX3nN8ByaXy3ElbrQWC2hjBXKQQxAsJg/4iAKMyNYaIsNAbzBZm1+MsBH
s9AH1k2OXSm5aL1oYcVUeS7v+eL+2nFgl93hAfG+YqfZkQA9B3Q=
=sq0t
-----END PGP SIGNATURE-----

--------------ZgWlD8B5xihFLhkYUsTny7Hy--
