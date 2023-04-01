Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA77D6D2DB4
	for <lists+stable@lfdr.de>; Sat,  1 Apr 2023 04:27:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233331AbjDAC1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 22:27:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233272AbjDAC1r (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 22:27:47 -0400
X-Greylist: delayed 600 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 31 Mar 2023 19:27:45 PDT
Received: from mail.valdk.tel (mail.valdk.tel [185.177.150.13])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4197DCA2C
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 19:27:45 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 029EFA06B70;
        Sat,  1 Apr 2023 05:09:02 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=valdikss.org.ru;
        s=msrv; t=1680314949;
        h=from:subject:date:message-id:to:cc:mime-version:content-type:
         content-language:in-reply-to:references;
        bh=kps8MWry5MwGXQOY36Td8YfcSJbDESOL6s6xM+uSojk=;
        b=hiy7/n+cM+XJm0XAnrSPhuAsTgHwC/8FyFh2rSzCCXx/M+JBIv5OTqCFUaUC77mcijwrz7
        GZiDGfbb/GYr34lzpYADvGNGQlKw5iEQd2btcz4E9KHPavUvb/nSQc1Sn411juCHYl/ebq
        +N3VXjjY4c6rtS9LALDWrzBX7PX4S58ls2np8z5sbbRo1o78BgEyQmZUHAnwZ7dRiLy7vG
        iUq/HUrbna789XfCwHcYdNm33DRmfD8rlk6qpBj6iASQIZoMdZJ5L0SDJXkG7NCjp82VIx
        PV98PBl5E1n844KiPA1sDO8esAv1v8vfMmRLynB9G7fC96vL9ab4URgY1q0LGg==
Message-ID: <57d3052f-a38f-c45b-bc3f-aa8ebfd7188e@valdikss.org.ru>
Date:   Sat, 1 Apr 2023 05:08:59 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:78.5.0) Gecko/20100101,
 Thunderbird/78.5.0
Subject: Re: [PATCH 0/2] RTW88 USB bug fixes
Content-Language: en-US, ru-RU
To:     Sascha Hauer <s.hauer@pengutronix.de>,
        linux-wireless <linux-wireless@vger.kernel.org>
Cc:     Hans Ulli Kroll <linux@ulli-kroll.de>,
        Larry Finger <Larry.Finger@lwfinger.net>,
        Pkshih <pkshih@realtek.com>, Tim K <tpkuester@gmail.com>,
        Nick Morrow <morrownr@gmail.com>,
        Viktor Petrenko <g0000ga@gmail.com>,
        Andreas Henriksson <andreas@fatal.se>, kernel@pengutronix.de,
        stable@vger.kernel.org, "Alex G." <mr.nuke.me@gmail.com>
References: <20230331121054.112758-1-s.hauer@pengutronix.de>
 <317782bf-b12a-b6b8-8f08-5e4e19f3b309@gmail.com>
From:   ValdikSS <iam@valdikss.org.ru>
In-Reply-To: <317782bf-b12a-b6b8-8f08-5e4e19f3b309@gmail.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------GM80ZT0493C1GmToVnA9BtnF"
X-Last-TLS-Session-Version: TLSv1.3
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------GM80ZT0493C1GmToVnA9BtnF
Content-Type: multipart/mixed; boundary="------------ATvweMDPt9nm92os43zcNLy8";
 protected-headers="v1"
From: ValdikSS <iam@valdikss.org.ru>
To: Sascha Hauer <s.hauer@pengutronix.de>,
 linux-wireless <linux-wireless@vger.kernel.org>
Cc: Hans Ulli Kroll <linux@ulli-kroll.de>,
 Larry Finger <Larry.Finger@lwfinger.net>, Pkshih <pkshih@realtek.com>,
 Tim K <tpkuester@gmail.com>, Nick Morrow <morrownr@gmail.com>,
 Viktor Petrenko <g0000ga@gmail.com>, Andreas Henriksson <andreas@fatal.se>,
 kernel@pengutronix.de, stable@vger.kernel.org, "Alex G."
 <mr.nuke.me@gmail.com>
Message-ID: <57d3052f-a38f-c45b-bc3f-aa8ebfd7188e@valdikss.org.ru>
Subject: Re: [PATCH 0/2] RTW88 USB bug fixes
References: <20230331121054.112758-1-s.hauer@pengutronix.de>
 <317782bf-b12a-b6b8-8f08-5e4e19f3b309@gmail.com>
In-Reply-To: <317782bf-b12a-b6b8-8f08-5e4e19f3b309@gmail.com>

--------------ATvweMDPt9nm92os43zcNLy8
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMzEuMDMuMjAyMyAyMzozNCwgQWxleCBHLiB3cm90ZToNCj4gT24gMy8zMS8yMyAwNzox
MCwgU2FzY2hhIEhhdWVyIHdyb3RlOg0KPj4gVGhpcyBzZXJpZXMgZml4ZXMgdHdvIGJ1Z3Mg
aW4gdGhlIFJUVzg4IFVTQiBkcml2ZXIgSSB3YXMgcmVwb3J0ZWQgZnJvbQ0KPj4gc2V2ZXJh
bCBwZW9wbGUgYW5kIHRoYXQgSSBhbHNvIGVuY291bnRlcmVkIG15c2VsZi4NCj4+DQo+PiBU
aGUgZmlyc3Qgb25lIHJlc3VsdGVkIGluICJ0aW1lZCBvdXQgdG8gZmx1c2ggcXVldWUgMyIg
bWVzc2FnZXMgZnJvbSB0aGUNCj4+IGRyaXZlciBhbmQgc29tZXRpbWVzIGEgY29tcGxldGUg
c3RhbGwgb2YgdGhlIFRYIHF1ZXVlcy4NCj4+DQo+PiBUaGUgc2Vjb25kIG9uZSBpcyBzcGVj
aWZpYyB0byB0aGUgUlRXODgyMUNVIGNoaXBzZXQuIEhlcmUgMkdIeiBuZXR3b3Jrcw0KPj4g
d2VyZSBoYXJkbHkgc2VlbiBhbmQgaW1wb3NzaWJsZSB0byBjb25uZWN0IHRvLiBUaGlzIGdv
ZXMgZG93biB0bw0KPj4gbWlzaW50ZXJwcmV0aW5nIHRoZSByZmVfb3B0aW9uIGZpZWxkIGlu
IHRoZSBlZnVzZS4NCg0KVGVzdGVkIG9uIFJUTDg4MTFDVSwgdGhlc2UgdHdvIHBhdGNoZXMg
Zml4IGJvdGggaXNzdWVzLiAyLjQgR0h6IG5ldHdvcmtzIA0Kbm93IHdvcmsgcGVyZmVjdGx5
IGZpbmUuDQoNClRlc3RlZC1ieTogVmFsZGlrU1MgPGlhbUB2YWxkaWtzcy5vcmcucnU+DQo=


--------------ATvweMDPt9nm92os43zcNLy8--

--------------GM80ZT0493C1GmToVnA9BtnF
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEEMiogvXcpmS32v71gXNcgLu+I93IFAmQnkjsFAwAAAAAACgkQXNcgLu+I93JW
YhAAyt31UScowu6VmI/qXRaNbSYypjkQHFO06zp2r2wJyDZI50yGRz6VqupTXCQLaFc6W5EAeB9c
CI/CdRDIjtrM56fuerkArpJWoJkNyx/KyetCL4FD1A1Uxfu1ZTbR65+yNlZwKiM+aiWl9buan8Cr
AlIoQ10tztXU3ga3HQ9dsOq+tR+b0l+kccvLCb2BxD/DwjlXvKtm58so07Zz9Fv6golSgonfC31r
K/CvlyFaN+2PP+qPISqW5eF6rGQfspj3qrr5/54n3k1W21oTyEYAD/KPHO1erC9MSubIepa802j1
qBK/V/bnKmXE6ZQPZw5PnTghf6n+agbjnh5sOSdCD/CMf0ydOsQQAAEW9tVwy3DtsCA7akXQKSjn
s3rvH81XVNDWrjM3p28ntDuNHwfjAbd8Mbb74ZXfKz3d7W0xyaDx+T29wlWIfdSbgkoepIGX9t3D
scA2pAV6MwkIv/oeN94CSv2ms/Lavmdbykt4m6byofaOfejLMADPTx0BGtl7MmwBUdIyyGmO4JlL
emWmfN4YPltAd/HPgC+OZbGbC8Y9w8cslWSnyGPNX/STSVm1kykMS385U13V7xNQOYrIxBZHeTFm
4of7xKbVeW3htGezngicFlxK+chrJQzBe3pXZ2rURV76gOG8VOwOd98Mhph9a6D9iY++auxTyx41
oGY=
=6GZ/
-----END PGP SIGNATURE-----

--------------GM80ZT0493C1GmToVnA9BtnF--
