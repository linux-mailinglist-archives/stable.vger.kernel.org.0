Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64004493C43
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 15:55:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355275AbiASOzQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 09:55:16 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:49410 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241974AbiASOzP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 09:55:15 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 56CD0210E3;
        Wed, 19 Jan 2022 14:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1642604114; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=faY5wPvMlduhGgbjXRtqrMZoITfaUnRaB+KiT7muBU0=;
        b=aKB6GuKTdx09dpALcJRA7J9AzuV3yo9LsVbyVZDdZlljXFY8b+GlVGc/d7ty0fjtxlV3QO
        PGFQvYSv2/ZGAQ1MVh83mnLXW2MksdVclmHI7kwazMavB/Zyuamg7EsNTsu4lH8IRXk/Qk
        Hu/y2KvSQHSgu75QRop4/L/r2y/HQGA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1642604114;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=faY5wPvMlduhGgbjXRtqrMZoITfaUnRaB+KiT7muBU0=;
        b=DDNhCM3zla2Fk7/gC622nEcFfhVycwRxUZRwBXMdMVsQPWsTF0bI+1kUA449m0qH9KPHnz
        AKMkxQmI3UTmrlAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 2E38313E15;
        Wed, 19 Jan 2022 14:55:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 59IzClIm6GE3cgAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Wed, 19 Jan 2022 14:55:14 +0000
Message-ID: <f368442d-fedc-2fdf-5618-ed323060df9c@suse.de>
Date:   Wed, 19 Jan 2022 15:55:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2] mgag200 fix memmapsl configuration in GCTL6 register
Content-Language: en-US
From:   Thomas Zimmermann <tzimmermann@suse.de>
To:     Jocelyn Falempe <jfalempe@redhat.com>,
        dri-devel@lists.freedesktop.org
Cc:     michel@daenzer.net, lyude@redhat.com, javierm@redhat.com,
        stable@vger.kernel.org
References: <20220114094754.522401-1-jfalempe@redhat.com>
 <20220119102905.1194787-1-jfalempe@redhat.com>
 <967fd413-1b55-7b94-a164-70f2942772f6@suse.de>
In-Reply-To: <967fd413-1b55-7b94-a164-70f2942772f6@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------otLTaieKI00tq5nbjHDCPJgM"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------otLTaieKI00tq5nbjHDCPJgM
Content-Type: multipart/mixed; boundary="------------Q074PA7NMRqeqgbwBckGvtV0";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Jocelyn Falempe <jfalempe@redhat.com>, dri-devel@lists.freedesktop.org
Cc: michel@daenzer.net, lyude@redhat.com, javierm@redhat.com,
 stable@vger.kernel.org
Message-ID: <f368442d-fedc-2fdf-5618-ed323060df9c@suse.de>
Subject: Re: [PATCH v2] mgag200 fix memmapsl configuration in GCTL6 register
References: <20220114094754.522401-1-jfalempe@redhat.com>
 <20220119102905.1194787-1-jfalempe@redhat.com>
 <967fd413-1b55-7b94-a164-70f2942772f6@suse.de>
In-Reply-To: <967fd413-1b55-7b94-a164-70f2942772f6@suse.de>

--------------Q074PA7NMRqeqgbwBckGvtV0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMTkuMDEuMjIgdW0gMTM6MjEgc2NocmllYiBUaG9tYXMgWmltbWVybWFubjoN
Cj4gDQo+IEFwcGVhcnMgdG8gYmUgd29ya2luZyBvbiBteSB0ZXN0IG1hY2hpbmUuDQo+IA0K
PiBCdXQgcGxlYXNlIHJ1bmUgc2NyaXB0cy9jaGVja3BhdGNoLnBsIG9uIHRoZSBwYXRjaCBi
ZWZvcmUgc2VuZGluZyBpdC4gSSANCj4gZ2V0IHNldmVyYWwgZXJyb3JzDQo+IA0KPiBXQVJO
SU5HOiBQb3NzaWJsZSB1bndyYXBwZWQgY29tbWl0IGRlc2NyaXB0aW9uIChwcmVmZXIgYSBt
YXhpbXVtIDc1IA0KPiBjaGFycyBwZXIgbGluZSkNCj4gDQo+ICM5ODoNCj4gDQo+ICDCoMKg
wqAgMDogRW5hYmxlcyBhbHBoYSBtb2RlLCBhbmQgdGhlIGNoYXJhY3RlciBnZW5lcmF0b3Ig
YWRkcmVzc2luZyANCj4gc3lzdGVtIGlzDQo+IA0KPiANCj4gDQo+IEVSUk9SOiB0cmFpbGlu
ZyB3aGl0ZXNwYWNlDQo+IA0KPiAjMTQ5OiBGSUxFOiBkcml2ZXJzL2dwdS9kcm0vbWdhZzIw
MC9tZ2FnMjAwX21vZGUuYzo1MzI6DQo+IA0KPiArXkkvKiBHQ1RMNiBzaG91bGQgYmUgMHgw
NSwgYnV0IHdlIGNvbmZpZ3VyZSBtZW1tYXBzbCB0byAweGI4MDAwICh0ZXh0IA0KPiBtb2Rl
KSxeTSQNCj4gDQo+IA0KPiANCj4gRVJST1I6IHRyYWlsaW5nIHdoaXRlc3BhY2UNCj4gDQo+
ICMxNTA6IEZJTEU6IGRyaXZlcnMvZ3B1L2RybS9tZ2FnMjAwL21nYWcyMDBfbW9kZS5jOjUz
MzoNCj4gDQo+ICteSSAqIHNvIHRoYXQgaXQgZG9lc24ndCBoYW5nIHdoZW4gcnVubmluZyBr
ZXhlYy9rZHVtcCBvbiBHMjAwX1NFIHJldjQyLl5NJA0KPiANCg0KVGhhbmtzIGEgbG90LCB0
aGUgcGF0Y2ggaGFzIGJlZW4gbWVyZ2Ugbm93LiBUaGVzZSBwcm9ibGVtcyBtaWdodCBoYXZl
IA0KYmVlbiBjYXVzZWQgYnkgbXkgZW1haWwgY2xpZW50Lg0KDQpCZXN0IHJlZ2FyZHMNClRo
b21hcw0KDQo+IA0KPiANCj4gDQo+IEJlc3QgcmVnYXJkcw0KPiBUaG9tYXMNCj4gDQo+IA0K
Pj4gwqDCoMKgwqDCoCBXUkVHX0dGWCg3LCAweDBmKTsNCj4+IMKgwqDCoMKgwqAgV1JFR19H
RlgoOCwgMHgwZik7DQo+IA0KDQotLSANClRob21hcyBaaW1tZXJtYW5uDQpHcmFwaGljcyBE
cml2ZXIgRGV2ZWxvcGVyDQpTVVNFIFNvZnR3YXJlIFNvbHV0aW9ucyBHZXJtYW55IEdtYkgN
Ck1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZywgR2VybWFueQ0KKEhSQiAzNjgwOSwg
QUcgTsO8cm5iZXJnKQ0KR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBUb3Rldg0K

--------------Q074PA7NMRqeqgbwBckGvtV0--

--------------otLTaieKI00tq5nbjHDCPJgM
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmHoJlEFAwAAAAAACgkQlh/E3EQov+C3
hRAAtHjqRHFFkCmMYQeKCAt2OxkXq1dIZkb/ab6hj5DOD2yUAOZ9VbRvzZUorbAttEGwbf8nayLx
Fh5/V7vYfvinpiPeKn/ZbS9J/xvbzNlxWeMgfmzhNDPLfj9Mw7A1q/DqiparPlJ7S+qhvqkb4daL
Pz3zMCT0vgD3wAi3ZUkbiRhKPKpbnoHhgU1epodKNZmH6MHQIKMd0ssH0NalPZyF2dB8GehwNWo1
Wr8AT0NJQhO2TrwpMAWRmgCwaH6RVC9IqDJzSGfWlWeaZ4x8Z2ccdAeZc4B9a8S7ROl4KEISC9EY
K8p1GeV1B7btFTYQyfzStVavOnjbsv7Vfdebde7Rcqi26LZO4xNyvoo7SA0vACwyVwGdnR6Pie7o
EiagNyffPsDHTEpvesGX1KvvmJr9L4v8O/xk7GJZGTpFVzM90CZhwkrTREg5s1KKToCJdIw98LMq
Tlwqes2ahhq+8N1Myd7sCEREok77SGCI0bQ8MdsI1ppfyVJBzHBsSN12QBqnAaJsBCUKEt7hnlN8
p4eq/mm0EosOgi98GYHAy0V0kLTpec9R9i4ti4sddVx3XJzpj9FqkKvARsmHVwRi+VEcUYnLjG/s
uyZ5eWID3O1XCYdj51VM5dPEHqBlE0TEvX5k4lwaGg5VC2gx3Cu0Kti88K0vXY+t2fMF5uN0ZpU6
sxc=
=qAQH
-----END PGP SIGNATURE-----

--------------otLTaieKI00tq5nbjHDCPJgM--
