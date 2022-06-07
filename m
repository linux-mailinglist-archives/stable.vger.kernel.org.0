Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 177A953FE44
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 14:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232955AbiFGMFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 08:05:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240340AbiFGMFl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 08:05:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF6AF5D04
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 05:05:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 2B76021B8D;
        Tue,  7 Jun 2022 12:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654603539; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8V6DyNj0Hs0LlWQm1kM8MrgPb7+hJ/glR0KX7ktOnrU=;
        b=sWj2RWEeNgaR3+6NuLLyG8xZlR03dt8J6QGDsjc8NTWmn6EmwuZmw13DGp0RY/81fTQueS
        fBKkakiUVOLTax9N9iqrHrOU+aOS9puq05ke2ZYuX2nKyvzEgWp+TFc/WDYdASQuF6OS6+
        BD6+Gy3BSarHj2mECT5a+HGCq8SRa0k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654603539;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8V6DyNj0Hs0LlWQm1kM8MrgPb7+hJ/glR0KX7ktOnrU=;
        b=KHyxoFk1a31ZTvtlplnu/dq0ttpqzAuiRC3nsnyJ6K+2seOIEp+PI1cW2gVZx0Jn4Y1g2i
        OBNj3qlKY9YajACQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EE56513638;
        Tue,  7 Jun 2022 12:05:38 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7GNGORI/n2LHfQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 07 Jun 2022 12:05:38 +0000
Message-ID: <2311e0f5-4dd7-ce48-a6e4-0a8b20d58f89@suse.de>
Date:   Tue, 7 Jun 2022 14:05:38 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [REGRESSION] VGA output with AST 2600 graphics.
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Jocelyn Falempe <jfalempe@redhat.com>,
        dri-devel@lists.freedesktop.org, kuohsiang_chou@aspeedtech.com,
        David Airlie <airlied@redhat.com>
Cc:     regressions@lists.linux.dev, stable@vger.kernel.org
References: <d84ba981-d907-f942-6b05-67c836580542@redhat.com>
 <6e9f84f9-dc97-9ff4-57c8-97fbffd3a996@suse.de>
 <66419e2f-8a68-0e0c-334b-96b211a96e50@redhat.com>
 <789eb485-067c-88fa-e687-4201b37b5dc3@leemhuis.info>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <789eb485-067c-88fa-e687-4201b37b5dc3@leemhuis.info>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------Xe0W0o45xKAm4u8o6uPqUzeA"
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------Xe0W0o45xKAm4u8o6uPqUzeA
Content-Type: multipart/mixed; boundary="------------dXwSunqFwIAax7wETGV2sNEx";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Thorsten Leemhuis <regressions@leemhuis.info>,
 Jocelyn Falempe <jfalempe@redhat.com>, dri-devel@lists.freedesktop.org,
 kuohsiang_chou@aspeedtech.com, David Airlie <airlied@redhat.com>
Cc: regressions@lists.linux.dev, stable@vger.kernel.org
Message-ID: <2311e0f5-4dd7-ce48-a6e4-0a8b20d58f89@suse.de>
Subject: Re: [REGRESSION] VGA output with AST 2600 graphics.
References: <d84ba981-d907-f942-6b05-67c836580542@redhat.com>
 <6e9f84f9-dc97-9ff4-57c8-97fbffd3a996@suse.de>
 <66419e2f-8a68-0e0c-334b-96b211a96e50@redhat.com>
 <789eb485-067c-88fa-e687-4201b37b5dc3@leemhuis.info>
In-Reply-To: <789eb485-067c-88fa-e687-4201b37b5dc3@leemhuis.info>

--------------dXwSunqFwIAax7wETGV2sNEx
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMDcuMDYuMjIgdW0gMTM6MDIgc2NocmllYiBUaG9yc3RlbiBMZWVtaHVpczoN
Cj4gSGksIHRoaXMgaXMgeW91ciBMaW51eCBrZXJuZWwgcmVncmVzc2lvbiB0cmFja2VyLg0K
PiANCj4gT24gMDEuMDYuMjIgMTQ6MjksIEpvY2VseW4gRmFsZW1wZSB3cm90ZToNCj4+IE9u
IDAxLzA2LzIwMjIgMTI6MzMsIFRob21hcyBaaW1tZXJtYW5uIHdyb3RlOg0KPj4+IEFtIDAx
LjA2LjIyIHVtIDExOjMzIHNjaHJpZWIgSm9jZWx5biBGYWxlbXBlOg0KPj4+Pg0KPj4+PiBJ
J3ZlIGZvdW5kIGEgcmVncmVzc2lvbiBpbiB0aGUgYXN0IGRyaXZlciwgZm9yIEFTVDI2MDAg
aGFyZHdhcmUuDQo+Pj4+DQo+Pj4+IGJlZm9yZSB0aGUgdXBzdHJlYW0gY29tbWl0IGY5YmQw
MGUwZWE5ZA0KPj4+PiBodHRwczovL2dpdC5rZXJuZWwub3JnL3B1Yi9zY20vbGludXgva2Vy
bmVsL2dpdC9zdGFibGUvbGludXguZ2l0L2NvbW1pdC8/aWQ9ZjliZDAwZTBlYTlkOWIwNDE0
MGFhOTY5YTlhMTNhZDM1OTdhMWU0ZQ0KPj4+Pg0KPj4+Pg0KPj4+PiBUaGUgYXN0IGRyaXZl
ciBoYW5kbGVkIEFTVCAyNjAwIGNoaXAgbGlrZSBhbiBBU1QgMjUwMC4NCj4+Pj4NCj4+Pj4g
QWZ0ZXIgdGhpcyBjb21taXQsIGl0IHVzZXMgc29tZSBkZWZhdWx0IHZhbHVlcywgbW9yZSBs
aWtlIHRoZSBvbGRlcg0KPj4+PiBBU1QgY2hpcC4NCj4+Pj4NCj4+Pj4gVGhlcmUgYXJlIGEg
bG90IG9mIHBsYWNlcyBpbiB0aGUgZHJpdmVyIGxpa2UgdGhpczoNCj4+Pj4gaHR0cHM6Ly9l
bGl4aXIuYm9vdGxpbi5jb20vbGludXgvdjUuMTguMS9zb3VyY2UvZHJpdmVycy9ncHUvZHJt
L2FzdC9hc3RfcG9zdC5jI0w4Mg0KPj4+Pg0KPj4+PiB3aGVyZSBpdCBjaGVja3MgZm9yIChB
U1QyMzAwIHx8IEFTVDI0MDAgfHwgQVNUMjUwMCkgYnV0IG5vdCBmb3IgQVNUMjYwMC4NCj4+
Pj4NCj4+Pj4gVGhpcyBtYWtlcyB0aGUgVkdBIG91dHB1dCwgdG8gYmUgYmx1cnJlZCBhbmQg
ZmxpY2tlcmVkIHdpdGggd2hpdGVzDQo+Pj4+IGxpbmVzIG9uIEFTVDI2MDAuDQo+Pj4+DQo+
Pj4+IFRoZSBpc3N1ZSBpcyBwcmVzZW50IHNpbmNlIHY1LjExDQo+Pj4+DQo+Pj4+IEZvciB2
NS4xMX52NS4xNyBJIHByb3Bvc2UgYSBzaW1wbGUgd29ya2Fyb3VuZCAoYXMgdGhlcmUgYXJl
IG5vIG90aGVyDQo+Pj4+IHJlZmVyZW5jZSB0byBBU1QyNjAwIGluIHRoZSBkcml2ZXIpOg0K
Pj4+PiAtLS0gYS9kcml2ZXJzL2dwdS9kcm0vYXN0L2FzdF9tYWluLmMNCj4+Pj4gKysrIGIv
ZHJpdmVycy9ncHUvZHJtL2FzdC9hc3RfbWFpbi5jDQo+Pj4+IEBAIC0xNDYsNyArMTQ2LDgg
QEAgc3RhdGljIGludCBhc3RfZGV0ZWN0X2NoaXAoc3RydWN0IGRybV9kZXZpY2UNCj4+Pj4g
KmRldiwgYm9vbCAqbmVlZF9wb3N0KQ0KPj4+Pg0KPj4+PiAgwqDCoMKgwqDCoCAvKiBJZGVu
dGlmeSBjaGlwc2V0ICovDQo+Pj4+ICDCoMKgwqDCoMKgIGlmIChwZGV2LT5yZXZpc2lvbiA+
PSAweDUwKSB7DQo+Pj4+IC3CoMKgwqDCoMKgwqDCoCBhc3QtPmNoaXAgPSBBU1QyNjAwOw0K
Pj4+PiArwqDCoMKgwqDCoMKgwqAgLyogV29ya2Fyb3VuZCB0byB1c2UgdGhlIHNhbWUgY29k
ZXBhdGggZm9yIEFTVDI2MDAgKi8NCj4+Pj4gK8KgwqDCoMKgwqDCoMKgIGFzdC0+Y2hpcCA9
IEFTVDI1MDA7DQo+Pj4NCj4+PiBUaGUgd2hvbGUgaGFuZGxpbmcgb2YgZGlmZmVyZW50IG1v
ZGVscyBpbiB0aGlzIGRyaXZlciBpcyBicm9rZW4gYnkNCj4+PiBkZXNpZ24gYW5kIG5lZWRz
IHRvIGJlIHJlcGxhY2VkLsKgIEkgZG9uJ3QgaGF2ZSBtdWNoIG9mIHRoZSBhZmZlY3RlZA0K
Pj4+IGhhcmR3YXJlLCBzbyBzdWNoIHRoaW5ncyBhcmUgZ29pbmcgc2xvd2x5LiA6KA0KPj4+
DQo+Pj4gRm9yIGFuIGludGVybWVkaWF0ZSBmaXgsIGl0IHdvdWxkIGJlIGJldHRlciB0byBj
aGFuZ2UgYWxsIHRlc3RzIGZvcg0KPj4+IEFTVDI1MDAgdG8gaW5jbHVkZSBBU1QyNjAwIGFz
IHdlbGwuIFRoZXJlIGFyZW4ndCB0b28gbWFueSBJSVJDLg0KPj4NCj4+IEkgZmVlbCBhIGJp
dCB1bmNvbWZvcnRhYmxlIGRvaW5nIHRoaXMsIGJlY2F1c2UgSSBkb24ndCBrbm93IGlmIHRo
aXMNCj4+IHNldHRpbmdzIGFyZSBnb29kIGZvciBBU1QyNjAwIG9yIG5vdC4gSSBqdXN0IGtu
b3cgdGhhdCBBU1QyNTAwIHNldHRpbmdzDQo+PiBhcmUgYmV0dGVyIHRoYW4gdGhlICJkZWZh
dWx0Ii4NCj4gDQo+IEt1b0hzaWFuZyBDaG91LCB5b3Ugd3JvdGUgdGhlIGNvbW1pdCBjYXVz
aW5nIHRoaXMgcmVncmVzc2lvbi4gQ291bGQgeW91DQo+IG1heWJlIHRha2UgY2FyZSBvZiB0
aGUgaWRlYSBUaG9tYXMgb3V0bGluZWQgdG8gZ2V0IHRoaXMgZml4ZWQgcmVsYXRpdmUNCj4g
cXVpY2tseT8gT3IgZG8geW91IGhhdmUgYSBiZXR0ZXIgaWRlYT8NCg0KVGhhbmtzIGZvciB0
aGUgcmVtaW5kZXIuIEkndmUgc2VudCBvdXQgYSBwYXRjaCBmb3IgdGhpcyBwcm9ibGVtLiBb
MV0NCg0KQmVzdCByZWdhcmRzDQpUaG9tYXMNCg0KWzFdIA0KaHR0cHM6Ly9sb3JlLmtlcm5l
bC5vcmcvZHJpLWRldmVsLzIwMjIwNjA3MTIwMjQ4LjMxNzE2LTEtdHppbW1lcm1hbm5Ac3Vz
ZS5kZS9ULyN1DQoNCj4gDQo+PiBBbHNvIGl0IG1heSBub3QgYXBwbHkgY2xlYW5seSB1cCB0
byB2NS4xMQ0KPiANCj4gRldJVywgNS4xMSBpcyBFT0wgYW55d2F5Lg0KPiANCj4+IEkgd2ls
bCBkbyBhIHRlc3QgcGF0Y2ggYW5kIHNlZSB3aGF0IGl0IGdpdmVzLg0KPj4NCj4+IEFub3Ro
ZXIgc29sdXRpb24gd291bGQgYmUgdG8ganVzdCByZXZlcnQgZjliZDAwZTBlYTlkIGZvciB2
NS4xMSB0byB2NS4xNyA/DQo+IA0KPiBUaGF0IG1pZ2h0IGNhdXNlIGEgcmVncmVzc2lvbiBm
b3IgdXNlcnMgdGhhdCBkZXBlbmQgb24gc29tZXRoaW5nDQo+IHN1cHBvcnRlZCB0aHggdG8g
dGhpcyBjaGFuZ2UuIDotLw0KPiANCj4gQ2lhbywgVGhvcnN0ZW4NCg0KLS0gDQpUaG9tYXMg
WmltbWVybWFubg0KR3JhcGhpY3MgRHJpdmVyIERldmVsb3Blcg0KU1VTRSBTb2Z0d2FyZSBT
b2x1dGlvbnMgR2VybWFueSBHbWJIDQpNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcs
IEdlcm1hbnkNCihIUkIgMzY4MDksIEFHIE7DvHJuYmVyZykNCkdlc2Now6RmdHNmw7xocmVy
OiBJdm8gVG90ZXYNCg==

--------------dXwSunqFwIAax7wETGV2sNEx--

--------------Xe0W0o45xKAm4u8o6uPqUzeA
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmKfPxIFAwAAAAAACgkQlh/E3EQov+D8
Hw//dvP9QQs6IC5VXIa91Xphu1jQWWFe5acaZnFSyg6wG5eTpnAVY8kua81cBAYUTXB8IO2cW7Lh
bhmRz0WkaKybsmU88erKrI1vGOOX9uR5XJzpgShkGgDacEzSaWp2vaYseNuwSusmXFgD9nPubH5N
6VP2qkqsxpZ4HNgf6L7C3FL/n9T9KN1aAHeVuAMByufWTh20AzfvsqMnFx34An3zv88OY8s6EAqc
Be+rBc6InWR8nc6oyjeSCLGIWJ+hSb7oa1qymd7rr5VqV4RegpO7wS25T/vekChoN7+yVVSXEDTF
2MJzbf28/8/0NtTn3L2zIauT4u7/1tJOTSXTTk75iO2Zvx+kRtvNOSCSqLMswjWuHQ22hZydvl6l
38Pu/CBdmiiFQv15B15hkHBhqqMnr/PJ4CAhXaFmhSWnQxGLP+C916bu759jmUxWedVuPkL5HC5C
H4sQxi1/qWFCrGDib2vLOs5CyXiubheO7bsCKe0Ucr646jHr6Y7lzovxZPTk+xa3HjdwZyECmliv
viNAb1+88vFXwjQPyimUI3yc8qD1/cP6GUhOMtDkjYJ8yLEVIJrLkhQF1fgiTWzm8GBHNomdsyMC
Cm9jYWilnOANRPDDx789naHCr7nhdt/VmnrU2/bEjkyL8jt9tq3+BLiWUjiX30xuAUkWgJ5rf0VL
8Ng=
=MBJb
-----END PGP SIGNATURE-----

--------------Xe0W0o45xKAm4u8o6uPqUzeA--
