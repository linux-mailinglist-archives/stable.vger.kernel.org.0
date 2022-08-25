Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1415A0DA0
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 12:13:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237993AbiHYKNv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 06:13:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241072AbiHYKNf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 06:13:35 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA39EAC253;
        Thu, 25 Aug 2022 03:13:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7D67C20CD3;
        Thu, 25 Aug 2022 10:13:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661422402; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=LJmOV5LiY1KYUXbDC8A5IR7Cc7SbhG/OU/aTO8TfXMY=;
        b=dFttVLtj9rqNQBQbpAsXk6Dj9hHfEWmgB1XDWgTf8xmlp+uRrKRdfW0Le29aUjC1a5p49z
        GK/ZQqjBX5k/mFI3/j0tsZ1t3M1PrJGbr0rAxkCH1Oc/QOoi1IRq8IC2wtGwHKelRphF/e
        B6dXFPqUJyObQGuGduZk2MDhMZY0MNk=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 34C6113A8E;
        Thu, 25 Aug 2022 10:13:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZmMBC0JLB2OPWgAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 25 Aug 2022 10:13:22 +0000
Message-ID: <a69d7917-daae-c8d9-5f4b-2300c99168b8@suse.com>
Date:   Thu, 25 Aug 2022 12:13:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Content-Language: en-US
To:     Jan Beulich <jbeulich@suse.com>
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        stable@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
References: <20220825092600.7188-1-jgross@suse.com>
 <2c762b15-fd7e-f14e-fcc9-a083af683e4f@suse.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH v2] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
In-Reply-To: <2c762b15-fd7e-f14e-fcc9-a083af683e4f@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------AdXZj2y0QB0pOHSuVWpP4yNL"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------AdXZj2y0QB0pOHSuVWpP4yNL
Content-Type: multipart/mixed; boundary="------------xHGVdcwthKYZTnCMqQXGfptV";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 stable@vger.kernel.org, Rustam Subkhankulov <subkhankulov@ispras.ru>,
 xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Message-ID: <a69d7917-daae-c8d9-5f4b-2300c99168b8@suse.com>
Subject: Re: [PATCH v2] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
References: <20220825092600.7188-1-jgross@suse.com>
 <2c762b15-fd7e-f14e-fcc9-a083af683e4f@suse.com>
In-Reply-To: <2c762b15-fd7e-f14e-fcc9-a083af683e4f@suse.com>

--------------xHGVdcwthKYZTnCMqQXGfptV
Content-Type: multipart/mixed; boundary="------------0vWVYWt8rO1HxuGNXWjBbHy9"

--------------0vWVYWt8rO1HxuGNXWjBbHy9
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjUuMDguMjIgMTE6NTAsIEphbiBCZXVsaWNoIHdyb3RlOg0KPiBPbiAyNS4wOC4yMDIy
IDExOjI2LCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4gVGhlIGVycm9yIGV4aXQgb2YgcHJp
dmNtZF9pb2N0bF9kbV9vcCgpIGlzIGNhbGxpbmcgdW5sb2NrX3BhZ2VzKCkNCj4+IHBvdGVu
dGlhbGx5IHdpdGggcGFnZXMgYmVpbmcgTlVMTCwgbGVhZGluZyB0byBhIE5VTEwgZGVyZWZl
cmVuY2UuDQo+Pg0KPj4gQWRkaXRpb25hbGx5IGxvY2tfcGFnZXMoKSBkb2Vzbid0IGNoZWNr
IGZvciBwaW5fdXNlcl9wYWdlc19mYXN0KCkNCj4+IGhhdmluZyBiZWVuIGNvbXBsZXRlbHkg
c3VjY2Vzc2Z1bCwgcmVzdWx0aW5nIGluIHBvdGVudGlhbGx5IG5vdA0KPj4gbG9ja2luZyBh
bGwgcGFnZXMgaW50byBtZW1vcnkuIFRoaXMgY291bGQgcmVzdWx0IGluIHNwb3JhZGljIGZh
aWx1cmVzDQo+PiB3aGVuIHVzaW5nIHRoZSByZWxhdGVkIG1lbW9yeSBpbiB1c2VyIG1vZGUu
DQo+Pg0KPj4gRml4IGFsbCBvZiB0aGF0IGJ5IGNhbGxpbmcgdW5sb2NrX3BhZ2VzKCkgYWx3
YXlzIHdpdGggdGhlIHJlYWwgbnVtYmVyDQo+PiBvZiBwaW5uZWQgcGFnZXMsIHdoaWNoIHdp
bGwgYmUgemVybyBpbiBjYXNlIHBhZ2VzIGJlaW5nIE5VTEwsIGFuZCBieQ0KPj4gY2hlY2tp
bmcgdGhlIG51bWJlciBvZiBwYXRjaGVzIHBpbm5lZCBieSBwaW5fdXNlcl9wYWdlc19mYXN0
KCkNCj4gDQo+IE5pdDogcy9wYXRjaGVzL3BhZ2VzLw0KPiANCj4+IG1hdGNoaW5nIHRoZSBl
eHBlY3RlZCBudW1iZXIgb2YgcGFnZXMuDQo+Pg0KPj4gQ2M6IDxzdGFibGVAdmdlci5rZXJu
ZWwub3JnPg0KPj4gRml4ZXM6IGFiNTIwYmU4Y2Q1ZCAoInhlbi9wcml2Y21kOiBBZGQgSU9D
VExfUFJJVkNNRF9ETV9PUCIpDQo+PiBSZXBvcnRlZC1ieTogUnVzdGFtIFN1YmtoYW5rdWxv
diA8c3Via2hhbmt1bG92QGlzcHJhcy5ydT4NCj4+IFNpZ25lZC1vZmYtYnk6IEp1ZXJnZW4g
R3Jvc3MgPGpncm9zc0BzdXNlLmNvbT4NCj4gDQo+IFJldmlld2VkLWJ5OiBKYW4gQmV1bGlj
aCA8amJldWxpY2hAc3VzZS5jb20+DQo+IA0KPiBJIGhhdmUgYSBxdWVzdGlvbiAvIHN1Z2dl
c3Rpb24sIHRob3VnaDoNCj4gDQo+PiAtLS0gYS9kcml2ZXJzL3hlbi9wcml2Y21kLmMNCj4+
ICsrKyBiL2RyaXZlcnMveGVuL3ByaXZjbWQuYw0KPj4gQEAgLTYwMiw2ICs2MDIsMTAgQEAg
c3RhdGljIGludCBsb2NrX3BhZ2VzKA0KPj4gICAJCSpwaW5uZWQgKz0gcGFnZV9jb3VudDsN
Cj4+ICAgCQlucl9wYWdlcyAtPSBwYWdlX2NvdW50Ow0KPj4gICAJCXBhZ2VzICs9IHBhZ2Vf
Y291bnQ7DQo+PiArDQo+PiArCQkvKiBFeGFjdCByZWFzb24gaXNuJ3Qga25vd24sIEVGQVVM
VCBpcyBvbmUgcG9zc2liaWxpdHkuICovDQo+PiArCQlpZiAocGFnZV9jb3VudCA8IHJlcXVl
c3RlZCkNCj4+ICsJCQlyZXR1cm4gLUVGQVVMVDsNCj4+ICAgCX0NCj4gDQo+IEkgZG9uJ3Qg
cmVhbGx5IGtub3cgdGhlIGlubmVyIHdvcmtpbmdzIG9mIHBpbl91c2VyX3BhZ2VzX2Zhc3Qo
KQ0KPiBub3Igd2hhdCBmdXR1cmUgcGxhbnMgdGhlcmUgYXJlIHdpdGggaXQuIFRvIGJlIGFz
IGluZGVwZW5kZW50IG9mDQo+IGl0cyBiZWhhdmlvciBhcyBwb3NzaWJsZSwgaG93IGFib3V0
IGJhaWxpbmcgaGVyZSBvbmx5IHdoZW4NCj4gcGFnZV9jb3VudCBhY3R1YWxseSBpcyB6ZXJv
IChpLmUuIG5vIGZvcndhcmQgcHJvZ3Jlc3MpPw0KDQpUaGlzIHdvdWxkIHJlcXVpcmUgdG8g
cmV3b3JrIHRoZSBsb29wIGluIGxvY2tfcGFnZXMoKSB0byBiZSBhYmxlIHRvDQpoYW5kbGUg
b25seSBhIHBhcnRpYWwgYnVmZmVyLg0KDQpUaGlzIHdvdWxkIGFkZCBzb21lIGNvbXBsZXhp
dHksIGJ1dCBPVE9IIEknZCBnZXQgYW4gZXhhY3QgZXJyb3IgY29kZQ0KYmFjayBpbiBjYXNl
IG9mIGZhaWx1cmUuDQoNCkknbGwgaGF2ZSBhIHRyeSBhbmQgc2VlIGhvdyB0aGUgcmVzdWx0
IHdvdWxkIGxvb2sgbGlrZS4NCg0KDQpKdWVyZ2VuDQo=
--------------0vWVYWt8rO1HxuGNXWjBbHy9
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------0vWVYWt8rO1HxuGNXWjBbHy9--

--------------xHGVdcwthKYZTnCMqQXGfptV--

--------------AdXZj2y0QB0pOHSuVWpP4yNL
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmMHS0EFAwAAAAAACgkQsN6d1ii/Ey9w
3wf/Wz1Qu1f2S4SqkU5O6dvi4gWS9VayII/dOUzq0eRxnp2ehO5TAdqj++Wb8rI2MiIPNdWCK4y9
WZvU8kOUejVUwkWeFGdnRWxDZgwDLJDQ4LAdf6eFraTwHJwMmHL1zKKEvdTeDz7Un/yNMkyJVKKD
h0JIRfCYZY1yhD6esTTbjrfKRwyTSRFJ69t/44ycRwgV8zCyGCRvHG6UIzpndmF8lzvIQQzxoPQS
hdjCzsjaMepOZRqLBhAx+gKWcZy4x+jsRcgDXp0KGVmUhtCqoNHm7uHRJUR8dcgg7epKJN6YzKC3
NVftYuY7j9iA9B4OKzkDezi+WHRmnKLk0484GNQnTg==
=Vp5U
-----END PGP SIGNATURE-----

--------------AdXZj2y0QB0pOHSuVWpP4yNL--
