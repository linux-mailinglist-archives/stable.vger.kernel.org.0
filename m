Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B994A53A2A7
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 12:34:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351902AbiFAKd4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 06:33:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345504AbiFAKdy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 06:33:54 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2455F6C546
        for <stable@vger.kernel.org>; Wed,  1 Jun 2022 03:33:48 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B7DC61F8C6;
        Wed,  1 Jun 2022 10:33:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654079626; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LTh5ATYU++zqMeYunecFwsJt3zReEUPuinehpFDM0oo=;
        b=OF1CIKIJp4DkGEKxLE4TTgZbY1vj4qT0nuTyLeAlFhp15dXCVRXzBaOnJQwUPFwCbQRB8m
        2jo0IwxxS8F7dg8TZFHF/oRImkaHGnlbsrYPNt+bhR1oG0hVCZmqI0IjW9RjOjH/zQUbAb
        pcFC5KUc2wG6wr1E5dDML04N5lVjTOE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654079626;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LTh5ATYU++zqMeYunecFwsJt3zReEUPuinehpFDM0oo=;
        b=LlxosNjzGW+ZB8mymHFZIGQM4LMGQeVqPmOA7BcvIbkn25MHd6HKHK+qxdjiH3N3b2ewB/
        Wp+E56wzjZSsxQDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 95B881330F;
        Wed,  1 Jun 2022 10:33:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id GVh5I4pAl2L7EwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Wed, 01 Jun 2022 10:33:46 +0000
Message-ID: <6e9f84f9-dc97-9ff4-57c8-97fbffd3a996@suse.de>
Date:   Wed, 1 Jun 2022 12:33:46 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [REGRESSION] VGA output with AST 2600 graphics.
Content-Language: en-US
To:     Jocelyn Falempe <jfalempe@redhat.com>,
        dri-devel@lists.freedesktop.org, kuohsiang_chou@aspeedtech.com,
        David Airlie <airlied@redhat.com>
Cc:     regressions@lists.linux.dev, stable@vger.kernel.org
References: <d84ba981-d907-f942-6b05-67c836580542@redhat.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <d84ba981-d907-f942-6b05-67c836580542@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------rs0qKD0lZDFSRDxuai27ujQX"
X-Spam-Status: No, score=-5.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------rs0qKD0lZDFSRDxuai27ujQX
Content-Type: multipart/mixed; boundary="------------OBMFmimlMR3yrMffjWCIcytN";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Jocelyn Falempe <jfalempe@redhat.com>, dri-devel@lists.freedesktop.org,
 kuohsiang_chou@aspeedtech.com, David Airlie <airlied@redhat.com>
Cc: regressions@lists.linux.dev, stable@vger.kernel.org
Message-ID: <6e9f84f9-dc97-9ff4-57c8-97fbffd3a996@suse.de>
Subject: Re: [REGRESSION] VGA output with AST 2600 graphics.
References: <d84ba981-d907-f942-6b05-67c836580542@redhat.com>
In-Reply-To: <d84ba981-d907-f942-6b05-67c836580542@redhat.com>

--------------OBMFmimlMR3yrMffjWCIcytN
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgSm9jZWx5biwNCg0KdGhhbmtzIGZvciByZXBvcnRpbmcgdGhpcyBidWcuDQoNCkFtIDAx
LjA2LjIyIHVtIDExOjMzIHNjaHJpZWIgSm9jZWx5biBGYWxlbXBlOg0KPiBIaSwNCj4gDQo+
IEkndmUgZm91bmQgYSByZWdyZXNzaW9uIGluIHRoZSBhc3QgZHJpdmVyLCBmb3IgQVNUMjYw
MCBoYXJkd2FyZS4NCj4gDQo+IGJlZm9yZSB0aGUgdXBzdHJlYW0gY29tbWl0IGY5YmQwMGUw
ZWE5ZA0KPiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2VybmVsL2dp
dC9zdGFibGUvbGludXguZ2l0L2NvbW1pdC8/aWQ9ZjliZDAwZTBlYTlkOWIwNDE0MGFhOTY5
YTlhMTNhZDM1OTdhMWU0ZSANCj4gDQo+IA0KPiBUaGUgYXN0IGRyaXZlciBoYW5kbGVkIEFT
VCAyNjAwIGNoaXAgbGlrZSBhbiBBU1QgMjUwMC4NCj4gDQo+IEFmdGVyIHRoaXMgY29tbWl0
LCBpdCB1c2VzIHNvbWUgZGVmYXVsdCB2YWx1ZXMsIG1vcmUgbGlrZSB0aGUgb2xkZXIgQVNU
IA0KPiBjaGlwLg0KPiANCj4gVGhlcmUgYXJlIGEgbG90IG9mIHBsYWNlcyBpbiB0aGUgZHJp
dmVyIGxpa2UgdGhpczoNCj4gaHR0cHM6Ly9lbGl4aXIuYm9vdGxpbi5jb20vbGludXgvdjUu
MTguMS9zb3VyY2UvZHJpdmVycy9ncHUvZHJtL2FzdC9hc3RfcG9zdC5jI0w4MiANCj4gDQo+
IHdoZXJlIGl0IGNoZWNrcyBmb3IgKEFTVDIzMDAgfHwgQVNUMjQwMCB8fCBBU1QyNTAwKSBi
dXQgbm90IGZvciBBU1QyNjAwLg0KPiANCj4gVGhpcyBtYWtlcyB0aGUgVkdBIG91dHB1dCwg
dG8gYmUgYmx1cnJlZCBhbmQgZmxpY2tlcmVkIHdpdGggd2hpdGVzIGxpbmVzIA0KPiBvbiBB
U1QyNjAwLg0KPiANCj4gVGhlIGlzc3VlIGlzIHByZXNlbnQgc2luY2UgdjUuMTENCj4gDQo+
IEZvciB2NS4xMX52NS4xNyBJIHByb3Bvc2UgYSBzaW1wbGUgd29ya2Fyb3VuZCAoYXMgdGhl
cmUgYXJlIG5vIG90aGVyIA0KPiByZWZlcmVuY2UgdG8gQVNUMjYwMCBpbiB0aGUgZHJpdmVy
KToNCj4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL2FzdC9hc3RfbWFpbi5jDQo+ICsrKyBiL2Ry
aXZlcnMvZ3B1L2RybS9hc3QvYXN0X21haW4uYw0KPiBAQCAtMTQ2LDcgKzE0Niw4IEBAIHN0
YXRpYyBpbnQgYXN0X2RldGVjdF9jaGlwKHN0cnVjdCBkcm1fZGV2aWNlICpkZXYsIA0KPiBi
b29sICpuZWVkX3Bvc3QpDQo+IA0KPiAgwqDCoMKgwqAgLyogSWRlbnRpZnkgY2hpcHNldCAq
Lw0KPiAgwqDCoMKgwqAgaWYgKHBkZXYtPnJldmlzaW9uID49IDB4NTApIHsNCj4gLcKgwqDC
oMKgwqDCoMKgIGFzdC0+Y2hpcCA9IEFTVDI2MDA7DQo+ICvCoMKgwqDCoMKgwqDCoCAvKiBX
b3JrYXJvdW5kIHRvIHVzZSB0aGUgc2FtZSBjb2RlcGF0aCBmb3IgQVNUMjYwMCAqLw0KPiAr
wqDCoMKgwqDCoMKgwqAgYXN0LT5jaGlwID0gQVNUMjUwMDsNCg0KVGhlIHdob2xlIGhhbmRs
aW5nIG9mIGRpZmZlcmVudCBtb2RlbHMgaW4gdGhpcyBkcml2ZXIgaXMgYnJva2VuIGJ5IA0K
ZGVzaWduIGFuZCBuZWVkcyB0byBiZSByZXBsYWNlZC4gIEkgZG9uJ3QgaGF2ZSBtdWNoIG9m
IHRoZSBhZmZlY3RlZCANCmhhcmR3YXJlLCBzbyBzdWNoIHRoaW5ncyBhcmUgZ29pbmcgc2xv
d2x5LiA6KA0KDQpGb3IgYW4gaW50ZXJtZWRpYXRlIGZpeCwgaXQgd291bGQgYmUgYmV0dGVy
IHRvIGNoYW5nZSBhbGwgdGVzdHMgZm9yIA0KQVNUMjUwMCB0byBpbmNsdWRlIEFTVDI2MDAg
YXMgd2VsbC4gVGhlcmUgYXJlbid0IHRvbyBtYW55IElJUkMuDQoNCkJlc3QgcmVnYXJkcw0K
VGhvbWFzDQoNCj4gIMKgwqDCoMKgwqDCoMKgwqAgZHJtX2luZm8oZGV2LCAiQVNUIDI2MDAg
ZGV0ZWN0ZWRcbiIpOw0KPiAgwqDCoMKgwqAgfSBlbHNlIGlmIChwZGV2LT5yZXZpc2lvbiA+
PSAweDQwKSB7DQo+ICDCoMKgwqDCoMKgwqDCoMKgIGFzdC0+Y2hpcCA9IEFTVDI1MDA7DQo+
IA0KPiBzdGFydGluZyBmcm9tIHY1LjE4LCB0aGVyZSBpcyBhbm90aGVyIHJlZmVyZW5jZSB0
byBBU1QyNjAwIGluIHRoZSBjb2RlDQo+IGh0dHBzOi8vZWxpeGlyLmJvb3RsaW4uY29tL2xp
bnV4L3Y1LjE4L3NvdXJjZS9kcml2ZXJzL2dwdS9kcm0vYXN0L2FzdF9tYWluLmMjTDIxMiAN
Cj4gDQo+IA0KPiBTbyBJIHRoaW5rIHNvbWVvbmUgd2l0aCBnb29kIGFzcGVlZCBrbm93bGVk
Z2Ugc2hvdWxkIHJldmlldyBhbGwgDQo+IGxvY2F0aW9ucyB3aGVyZSB0aGVyZSBpcyBhIHRl
c3QgZm9yIEFTVDI1MDAsIGFuZCBmaWd1cmUgb3V0IHdoYXQgc2hvdWxkIA0KPiBiZSBkb25l
IGZvciBBU1QyNjAwDQo+IA0KPiBUaGFua3MsDQo+IA0KDQotLSANClRob21hcyBaaW1tZXJt
YW5uDQpHcmFwaGljcyBEcml2ZXIgRGV2ZWxvcGVyDQpTVVNFIFNvZnR3YXJlIFNvbHV0aW9u
cyBHZXJtYW55IEdtYkgNCk1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZywgR2VybWFu
eQ0KKEhSQiAzNjgwOSwgQUcgTsO8cm5iZXJnKQ0KR2VzY2jDpGZ0c2bDvGhyZXI6IEl2byBU
b3Rldg0K

--------------OBMFmimlMR3yrMffjWCIcytN--

--------------rs0qKD0lZDFSRDxuai27ujQX
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmKXQIoFAwAAAAAACgkQlh/E3EQov+BV
Zg//bEkLNw9E9Tz8bxTCi29rWi9JLUdjtY7nuxLM3D64T7WEwOdFpslQYe0YQ/7H+q4j4wwR/Pk1
ImF834b5/MJ8CVosP7wRtQPWRUoPE+wOO/tBL949FZbTSzp0fGfSl+rGllBHkMLS9w9QPMr11rSV
fDldbNAPC7L1voO7xWvhlA2TtC9h33lGo31PozA1A3Czn611/WGsqeVzC4EuTTUuBguRXO10ZfWL
dSc9yZZEU5BC/PvV2cAbIhc1S0VLQZcWFsScWVKSRXBipCZ+RgJx96WYR/Q8XHX/iNnuWvq/8DiK
rYQIpM5hvKTwBHmxCQviKWaze7qG/GhG0BjpsYhLIDN7Sq22tJkp/8rPOodiEwFYCyNi/2vSnimL
P+aSN6mK1WjO6DZLpH0xkYbnfOsOHsJTl0d0Hb+QZA7vGxu3MKKlaGnYhKOEzd751JCdqAGDWMsw
dpwjqmS5bI3uzzvYX5DfPiNXNAmt8lJBmJ8XdDFlUNmPBPX1J7UA/X71e4m9Fx94YV7ymGyrIv7A
wfgn9tkRc+UuuIIFBhIu4ikB86VlDNLvBZqDyxIjVAlKucd1oU7vlJob1UT4992S5/0X0kmTxB7q
Sm3i9zHjFovvb8LsPxlVRUZdm/bjsNjQ+n0GUDfSmflIS2+hdE5bcqpIEQIRUekoBGJxxDrDFnt1
6GE=
=q6Sa
-----END PGP SIGNATURE-----

--------------rs0qKD0lZDFSRDxuai27ujQX--
