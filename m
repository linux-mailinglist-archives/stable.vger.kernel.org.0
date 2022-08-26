Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ADEE85A2471
	for <lists+stable@lfdr.de>; Fri, 26 Aug 2022 11:31:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245712AbiHZJ3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Aug 2022 05:29:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237130AbiHZJ3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 26 Aug 2022 05:29:08 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F38BB5A44;
        Fri, 26 Aug 2022 02:29:07 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 30ED21F899;
        Fri, 26 Aug 2022 09:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661506146; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FfcCFtkfDcYPIDq2ZP7yv9qy/D1i2BMmbbUfbOxhjCA=;
        b=JmLvkBsUASdHRrnDtIkr0CfZfwONubrN2KcXaFtugqIcqdIRqrn7bdi3FTvkyTHEoZCmpd
        BTzCdCmk+SAhkl48KjbOYUW585jrj1sby3lQhc5m2g97/ZlZfGkuCqjDCDQd02uSEvqzQa
        HOuBRc9eRE4pDw6bmvf7Xxp88N3ZLm8=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D45DA13421;
        Fri, 26 Aug 2022 09:29:05 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id pIayMGGSCGMZQQAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 26 Aug 2022 09:29:05 +0000
Message-ID: <df018a26-d81b-7785-6deb-1721cf7f4530@suse.com>
Date:   Fri, 26 Aug 2022 11:29:05 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v4] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
Content-Language: en-US
To:     Oleksandr Tyshchenko <Oleksandr_Tyshchenko@epam.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Rustam Subkhankulov <subkhankulov@ispras.ru>
References: <20220825141918.3581-1-jgross@suse.com>
 <5e749d5e-08d9-81c9-0f46-a06be2d752ce@epam.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <5e749d5e-08d9-81c9-0f46-a06be2d752ce@epam.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------3ZehxU7Kxog0RUTYx1upyhdH"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------3ZehxU7Kxog0RUTYx1upyhdH
Content-Type: multipart/mixed; boundary="------------LXd8SIJhQ6wEjyb0DFez00ic";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Oleksandr Tyshchenko <Oleksandr_Tyshchenko@epam.com>,
 "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Cc: Stefano Stabellini <sstabellini@kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>,
 Rustam Subkhankulov <subkhankulov@ispras.ru>
Message-ID: <df018a26-d81b-7785-6deb-1721cf7f4530@suse.com>
Subject: Re: [PATCH v4] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
References: <20220825141918.3581-1-jgross@suse.com>
 <5e749d5e-08d9-81c9-0f46-a06be2d752ce@epam.com>
In-Reply-To: <5e749d5e-08d9-81c9-0f46-a06be2d752ce@epam.com>

--------------LXd8SIJhQ6wEjyb0DFez00ic
Content-Type: multipart/mixed; boundary="------------0g0dy3cM1Rn8cvW5XvCx2EFw"

--------------0g0dy3cM1Rn8cvW5XvCx2EFw
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjYuMDguMjIgMTE6MDgsIE9sZWtzYW5kciBUeXNoY2hlbmtvIHdyb3RlOg0KPiANCj4g
T24gMjUuMDguMjIgMTc6MTksIEp1ZXJnZW4gR3Jvc3Mgd3JvdGU6DQo+IA0KPiBIZWxsbyBK
dWVyZ2VuDQo+IA0KPj4gVGhlIGVycm9yIGV4aXQgb2YgcHJpdmNtZF9pb2N0bF9kbV9vcCgp
IGlzIGNhbGxpbmcgdW5sb2NrX3BhZ2VzKCkNCj4+IHBvdGVudGlhbGx5IHdpdGggcGFnZXMg
YmVpbmcgTlVMTCwgbGVhZGluZyB0byBhIE5VTEwgZGVyZWZlcmVuY2UuDQo+Pg0KPj4gQWRk
aXRpb25hbGx5IGxvY2tfcGFnZXMoKSBkb2Vzbid0IGNoZWNrIGZvciBwaW5fdXNlcl9wYWdl
c19mYXN0KCkNCj4+IGhhdmluZyBiZWVuIGNvbXBsZXRlbHkgc3VjY2Vzc2Z1bCwgcmVzdWx0
aW5nIGluIHBvdGVudGlhbGx5IG5vdA0KPj4gbG9ja2luZyBhbGwgcGFnZXMgaW50byBtZW1v
cnkuIFRoaXMgY291bGQgcmVzdWx0IGluIHNwb3JhZGljIGZhaWx1cmVzDQo+PiB3aGVuIHVz
aW5nIHRoZSByZWxhdGVkIG1lbW9yeSBpbiB1c2VyIG1vZGUuDQo+Pg0KPj4gRml4IGFsbCBv
ZiB0aGF0IGJ5IGNhbGxpbmcgdW5sb2NrX3BhZ2VzKCkgYWx3YXlzIHdpdGggdGhlIHJlYWwg
bnVtYmVyDQo+PiBvZiBwaW5uZWQgcGFnZXMsIHdoaWNoIHdpbGwgYmUgemVybyBpbiBjYXNl
IHBhZ2VzIGJlaW5nIE5VTEwsIGFuZCBieQ0KPj4gY2hlY2tpbmcgdGhlIG51bWJlciBvZiBw
YWdlcyBwaW5uZWQgYnkgcGluX3VzZXJfcGFnZXNfZmFzdCgpIG1hdGNoaW5nDQo+PiB0aGUg
ZXhwZWN0ZWQgbnVtYmVyIG9mIHBhZ2VzLg0KPj4NCj4+IENjOiA8c3RhYmxlQHZnZXIua2Vy
bmVsLm9yZz4NCj4+IEZpeGVzOiBhYjUyMGJlOGNkNWQgKCJ4ZW4vcHJpdmNtZDogQWRkIElP
Q1RMX1BSSVZDTURfRE1fT1AiKQ0KPj4gUmVwb3J0ZWQtYnk6IFJ1c3RhbSBTdWJraGFua3Vs
b3YgPHN1YmtoYW5rdWxvdkBpc3ByYXMucnU+DQo+PiBTaWduZWQtb2ZmLWJ5OiBKdWVyZ2Vu
IEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+DQo+IA0KPiANCj4gSSBoYXZlbid0IHNwb3R0ZWQg
YW55IGlzc3VlczoNCj4gDQo+IFJldmlld2VkLWJ5OiBPbGVrc2FuZHIgVHlzaGNoZW5rbyA8
b2xla3NhbmRyX3R5c2hjaGVua29AZXBhbS5jb20+DQo+IA0KPiANCj4+IC0tLQ0KPj4gVjI6
DQo+PiAtIHVzZSAicGlubmVkIiBhcyBwYXJhbWV0ZXIgZm9yIHVubG9ja19wYWdlcygpIChK
YW4gQmV1bGljaCkNCj4+IC0gZHJvcCBsYWJlbCAidW5sb2NrIiBhZ2FpbiAoSmFuIEJldWxp
Y2gpDQo+PiAtIGFkZCBjaGVjayBmb3IgY29tcGxldGUgc3VjY2VzcyBvZiBwaW5fdXNlcl9w
YWdlc19mYXN0KCkNCj4+IFYzOg0KPj4gLSBjb250aW51ZSBhZnRlciBwYXJ0aWFsIHN1Y2Nl
c3Mgb2YgcGluX3VzZXJfcGFnZXNfZmFzdCgpIChKYW4gQmV1bGljaCkNCj4+IFY0Og0KPj4g
LSBmaXggY2FzZSBvZiBtdWx0aXBsZSBwYXJ0aWFsIHN1Y2Nlc3NlcyBmb3Igb25lIGJ1ZmZl
ciAoSmFuIEJldWxpY2gpDQo+PiAtLS0NCj4+ICAgIGRyaXZlcnMveGVuL3ByaXZjbWQuYyB8
IDIxICsrKysrKysrKysrLS0tLS0tLS0tLQ0KPj4gICAgMSBmaWxlIGNoYW5nZWQsIDExIGlu
c2VydGlvbnMoKyksIDEwIGRlbGV0aW9ucygtKQ0KPj4NCj4+IGRpZmYgLS1naXQgYS9kcml2
ZXJzL3hlbi9wcml2Y21kLmMgYi9kcml2ZXJzL3hlbi9wcml2Y21kLmMNCj4+IGluZGV4IDMz
Njk3MzQxMDhhZi4uZTg4ZThmNmYwYTMzIDEwMDY0NA0KPj4gLS0tIGEvZHJpdmVycy94ZW4v
cHJpdmNtZC5jDQo+PiArKysgYi9kcml2ZXJzL3hlbi9wcml2Y21kLmMNCj4+IEBAIC01ODEs
MjcgKzU4MSwzMCBAQCBzdGF0aWMgaW50IGxvY2tfcGFnZXMoDQo+PiAgICAJc3RydWN0IHBy
aXZjbWRfZG1fb3BfYnVmIGtidWZzW10sIHVuc2lnbmVkIGludCBudW0sDQo+PiAgICAJc3Ry
dWN0IHBhZ2UgKnBhZ2VzW10sIHVuc2lnbmVkIGludCBucl9wYWdlcywgdW5zaWduZWQgaW50
ICpwaW5uZWQpDQo+PiAgICB7DQo+PiAtCXVuc2lnbmVkIGludCBpOw0KPj4gKwl1bnNpZ25l
ZCBpbnQgaSwgb2ZmID0gMDsNCj4+ICAgIA0KPj4gLQlmb3IgKGkgPSAwOyBpIDwgbnVtOyBp
KyspIHsNCj4+ICsJZm9yIChpID0gMDsgaSA8IG51bTsgKSB7DQo+PiAgICAJCXVuc2lnbmVk
IGludCByZXF1ZXN0ZWQ7DQo+PiAgICAJCWludCBwYWdlX2NvdW50Ow0KPj4gICAgDQo+PiAg
ICAJCXJlcXVlc3RlZCA9IERJVl9ST1VORF9VUCgNCj4+ICAgIAkJCW9mZnNldF9pbl9wYWdl
KGtidWZzW2ldLnVwdHIpICsga2J1ZnNbaV0uc2l6ZSwNCj4+IC0JCQlQQUdFX1NJWkUpOw0K
Pj4gKwkJCVBBR0VfU0laRSkgLSBvZmY7DQo+PiAgICAJCWlmIChyZXF1ZXN0ZWQgPiBucl9w
YWdlcykNCj4+ICAgIAkJCXJldHVybiAtRU5PU1BDOw0KPj4gICAgDQo+PiAgICAJCXBhZ2Vf
Y291bnQgPSBwaW5fdXNlcl9wYWdlc19mYXN0KA0KPj4gLQkJCSh1bnNpZ25lZCBsb25nKSBr
YnVmc1tpXS51cHRyLA0KPj4gKwkJCSh1bnNpZ25lZCBsb25nKWtidWZzW2ldLnVwdHIgKyBv
ZmYgKiBQQUdFX1NJWkUsDQo+PiAgICAJCQlyZXF1ZXN0ZWQsIEZPTExfV1JJVEUsIHBhZ2Vz
KTsNCj4+IC0JCWlmIChwYWdlX2NvdW50IDwgMCkNCj4+IC0JCQlyZXR1cm4gcGFnZV9jb3Vu
dDsNCj4+ICsJCWlmIChwYWdlX2NvdW50IDw9IDApDQo+PiArCQkJcmV0dXJuIHBhZ2VfY291
bnQgPyA6IC1FRkFVTFQ7DQo+IA0KPiANCj4gW25vdCByZWxhdGVkIHRvIHRoZSBjdXJyZW50
IHBhdGNoXQ0KPiANCj4gSSBqdXN0IHdvbmRlciwgd2hldGhlciBkcml2ZXJzL3hlbi9nbnRk
ZXYuYzpnbnRkZXZfZ2V0X3BhZ2UoKSByZWFsbHkNCj4gd2FudHMgdG8gZ2FpbiB0aGUgc2Ft
ZSBjaGVjaz8NCj4gDQo+IGluZGV4IDU5ZmZlYTgwMDA3OS4uNDVlMTYwMzEyMDRkIDEwMDY0
NA0KPiAtLS0gYS9kcml2ZXJzL3hlbi9nbnRkZXYuYw0KPiArKysgYi9kcml2ZXJzL3hlbi9n
bnRkZXYuYw0KPiBAQCAtNzQwLDggKzc0MCw4IEBAIHN0YXRpYyBpbnQgZ250ZGV2X2dldF9w
YWdlKHN0cnVjdCBnbnRkZXZfY29weV9iYXRjaA0KPiAqYmF0Y2gsIHZvaWQgX191c2VyICp2
aXJ0LA0KPiAgIMKgwqDCoMKgwqDCoMKgIGludCByZXQ7DQo+IA0KPiAgIMKgwqDCoMKgwqDC
oMKgIHJldCA9IHBpbl91c2VyX3BhZ2VzX2Zhc3QoYWRkciwgMSwgYmF0Y2gtPndyaXRlYWJs
ZSA/DQo+IEZPTExfV1JJVEUgOiAwLCAmcGFnZSk7DQo+IC3CoMKgwqDCoMKgwqAgaWYgKHJl
dCA8IDApDQo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHJldHVybiByZXQ7DQo+
ICvCoMKgwqDCoMKgwqAgaWYgKHJldCA8PSAwKQ0KPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoCByZXR1cm4gcmV0ID8gOiAtRUZBVUxUOw0KPiANCj4gICDCoMKgwqDCoMKgwqDC
oCBiYXRjaC0+cGFnZXNbYmF0Y2gtPm5yX3BhZ2VzKytdID0gcGFnZTsNCg0KSSBkb24ndCB0
aGluayB0aGlzIGlzIG5lZWRlZCBoZXJlLCBhcyBwaW5fdXNlcl9wYWdlc19mYXN0KCkgY2Fu
J3QNCnJldHVybiAwIHdoZW4gY2FsbGVkIGZvciBhIHNpbmdsZSBwYWdlLg0KDQoNCkp1ZXJn
ZW4NCg==
--------------0g0dy3cM1Rn8cvW5XvCx2EFw
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------0g0dy3cM1Rn8cvW5XvCx2EFw--

--------------LXd8SIJhQ6wEjyb0DFez00ic--

--------------3ZehxU7Kxog0RUTYx1upyhdH
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmMIkmEFAwAAAAAACgkQsN6d1ii/Ey9F
vQgAgpiT4qJaY9fkhEvt04XcDlwwR0APCP+KFd7oXoHTRCu1mer7oiWcnpNHKbtDeSFouaMaulBC
3hfNAxj0QSmXK9CEeI5PgfjqPW8QkZlNXaHOKPJr6Lvzmb9Gilvs3k6XcdQYS6VSYfuOACpn6NlZ
Yp3x8dIM6yPBT/ERzM86tzxAD3lxPx7BGoK/8xo8hAMpjrA8gPpINxfuc7ofWpIMy96FSwmm41SB
99eFVhF04M7WPk620po00+G8oXhT8ozPXumNTQvD028btNVMkssiy9ciTwZy+nZ92V/Q+EvSAA5g
+9kMSeHC4ORVjhGphn4U+Q/cEuA7VDBFMzSxf1Re+w==
=weEA
-----END PGP SIGNATURE-----

--------------3ZehxU7Kxog0RUTYx1upyhdH--
