Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01B265A0ECB
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 13:14:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235500AbiHYLOY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Aug 2022 07:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiHYLOX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 25 Aug 2022 07:14:23 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C38FFAED8B;
        Thu, 25 Aug 2022 04:14:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 7919B1FCEA;
        Thu, 25 Aug 2022 11:14:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1661426061; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z35KMlerkRAb1QPM9B9Nt7oMwL4KBkeeO16KJo1wur8=;
        b=jJmfRG3qhJrnsML4CmH5TaLWPejI9IiWbDK63yaFfO1jRjILr4dqRwJpgVNYCb+0r4iTw8
        SCTNeRCzd/mWvV3hiy4+DUlhnON3dyIKLh+ApGR812+oZTX3IZQzxw77CiorK9IgqEAeJC
        x840pCqI1T5RMa9yXjHIQZtSMZ1K8/I=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 3F6FD13517;
        Thu, 25 Aug 2022 11:14:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id HrgpDo1ZB2MbdAAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 25 Aug 2022 11:14:21 +0000
Message-ID: <1f460b58-2cf7-306f-60a5-14badf53ca70@suse.com>
Date:   Thu, 25 Aug 2022 13:14:20 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH v2] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
Content-Language: en-US
To:     Jan Beulich <jbeulich@suse.com>
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
        stable@vger.kernel.org,
        Rustam Subkhankulov <subkhankulov@ispras.ru>,
        xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
References: <20220825092600.7188-1-jgross@suse.com>
 <2c762b15-fd7e-f14e-fcc9-a083af683e4f@suse.com>
 <a69d7917-daae-c8d9-5f4b-2300c99168b8@suse.com>
 <d0ef9b45-9730-c9d5-a57e-9b7860d84a13@suse.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <d0ef9b45-9730-c9d5-a57e-9b7860d84a13@suse.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------W6dlOTs8h0LU1RtKHyq845NT"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------W6dlOTs8h0LU1RtKHyq845NT
Content-Type: multipart/mixed; boundary="------------nXAny4FCzKzm0QAZid0dKaJH";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Jan Beulich <jbeulich@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>,
 stable@vger.kernel.org, Rustam Subkhankulov <subkhankulov@ispras.ru>,
 xen-devel@lists.xenproject.org, linux-kernel@vger.kernel.org
Message-ID: <1f460b58-2cf7-306f-60a5-14badf53ca70@suse.com>
Subject: Re: [PATCH v2] xen/privcmd: fix error exit of privcmd_ioctl_dm_op()
References: <20220825092600.7188-1-jgross@suse.com>
 <2c762b15-fd7e-f14e-fcc9-a083af683e4f@suse.com>
 <a69d7917-daae-c8d9-5f4b-2300c99168b8@suse.com>
 <d0ef9b45-9730-c9d5-a57e-9b7860d84a13@suse.com>
In-Reply-To: <d0ef9b45-9730-c9d5-a57e-9b7860d84a13@suse.com>

--------------nXAny4FCzKzm0QAZid0dKaJH
Content-Type: multipart/mixed; boundary="------------C00gpXn6jKI00aJcMFNIFEth"

--------------C00gpXn6jKI00aJcMFNIFEth
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMjUuMDguMjIgMTI6MjIsIEphbiBCZXVsaWNoIHdyb3RlOg0KPiBPbiAyNS4wOC4yMDIy
IDEyOjEzLCBKdWVyZ2VuIEdyb3NzIHdyb3RlOg0KPj4gT24gMjUuMDguMjIgMTE6NTAsIEph
biBCZXVsaWNoIHdyb3RlOg0KPj4+IE9uIDI1LjA4LjIwMjIgMTE6MjYsIEp1ZXJnZW4gR3Jv
c3Mgd3JvdGU6DQo+Pj4+IC0tLSBhL2RyaXZlcnMveGVuL3ByaXZjbWQuYw0KPj4+PiArKysg
Yi9kcml2ZXJzL3hlbi9wcml2Y21kLmMNCj4+Pj4gQEAgLTYwMiw2ICs2MDIsMTAgQEAgc3Rh
dGljIGludCBsb2NrX3BhZ2VzKA0KPj4+PiAgICAJCSpwaW5uZWQgKz0gcGFnZV9jb3VudDsN
Cj4+Pj4gICAgCQlucl9wYWdlcyAtPSBwYWdlX2NvdW50Ow0KPj4+PiAgICAJCXBhZ2VzICs9
IHBhZ2VfY291bnQ7DQo+Pj4+ICsNCj4+Pj4gKwkJLyogRXhhY3QgcmVhc29uIGlzbid0IGtu
b3duLCBFRkFVTFQgaXMgb25lIHBvc3NpYmlsaXR5LiAqLw0KPj4+PiArCQlpZiAocGFnZV9j
b3VudCA8IHJlcXVlc3RlZCkNCj4+Pj4gKwkJCXJldHVybiAtRUZBVUxUOw0KPj4+PiAgICAJ
fQ0KPj4+DQo+Pj4gSSBkb24ndCByZWFsbHkga25vdyB0aGUgaW5uZXIgd29ya2luZ3Mgb2Yg
cGluX3VzZXJfcGFnZXNfZmFzdCgpDQo+Pj4gbm9yIHdoYXQgZnV0dXJlIHBsYW5zIHRoZXJl
IGFyZSB3aXRoIGl0LiBUbyBiZSBhcyBpbmRlcGVuZGVudCBvZg0KPj4+IGl0cyBiZWhhdmlv
ciBhcyBwb3NzaWJsZSwgaG93IGFib3V0IGJhaWxpbmcgaGVyZSBvbmx5IHdoZW4NCj4+PiBw
YWdlX2NvdW50IGFjdHVhbGx5IGlzIHplcm8gKGkuZS4gbm8gZm9yd2FyZCBwcm9ncmVzcyk/
DQo+Pg0KPj4gVGhpcyB3b3VsZCByZXF1aXJlIHRvIHJld29yayB0aGUgbG9vcCBpbiBsb2Nr
X3BhZ2VzKCkgdG8gYmUgYWJsZSB0bw0KPj4gaGFuZGxlIG9ubHkgYSBwYXJ0aWFsIGJ1ZmZl
ci4NCj4gDQo+IE9oLCBJIHNlZSAtIEkndmUgbWlzcmVhZCB0aGUgY29kZSBhcyBpZiB0aGUg
bG9vcCB3YXMgY2FwcGluZyBlYWNoDQo+IGl0ZXJhdGlvbidzIGNvdW50IHRvIHRoZSBjYXBh
Y2l0eSBvZiBzb21lIGludGVybmFsIGJ1ZmZlciAoYXMgaWlyYw0KPiBpcyBiZWluZyBkb25l
IGVsc2V3aGVyZSkuIFNvIC4uLg0KPiANCj4+IFRoaXMgd291bGQgYWRkIHNvbWUgY29tcGxl
eGl0eSwgYnV0IE9UT0ggSSdkIGdldCBhbiBleGFjdCBlcnJvciBjb2RlDQo+PiBiYWNrIGlu
IGNhc2Ugb2YgZmFpbHVyZS4NCj4gDQo+IC4uLiBwZXJoYXBzIG5vdCB3b3J0aCBpdCB0aGVu
LCAuLi4NCj4gDQo+PiBJJ2xsIGhhdmUgYSB0cnkgYW5kIHNlZSBob3cgdGhlIHJlc3VsdCB3
b3VsZCBsb29rIGxpa2UuDQo+IA0KPiAuLi4gdW5sZXNzIHlvdSB0aGluayB0aGlzIG1pZ2h0
IGJlIHJlbGV2YW50IGluIGNlcnRhaW4gY2FzZXMuDQoNCk5vdCBzdXJlLCBidXQgdGhlIHJl
c3VsdGluZyBjb2RlIGlzIGxvb2tpbmcgZmluZSBJTU8uDQoNCg0KSnVlcmdlbg0K
--------------C00gpXn6jKI00aJcMFNIFEth
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------C00gpXn6jKI00aJcMFNIFEth--

--------------nXAny4FCzKzm0QAZid0dKaJH--

--------------W6dlOTs8h0LU1RtKHyq845NT
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmMHWYwFAwAAAAAACgkQsN6d1ii/Ey8D
xgf+In2o2qkHGeqAJuA7sthy6tQ3U+J4yEynEukvFx8Cuua4he7i53JZztPMf1mWmc3uOJbdgiJT
8BO61dzqphxvhugyqWwl1Sfq9TU2C4WRCZ9lfpY3gJQKs8puIJyyhNA6Y7Ektj61NJpHWLNnNPga
IWz4lrKm0koCZammZmonXJZ4aeqqTa28Zry0hzqegTJE+YHXE7PFSeXtrLR+qFegVT3kQzAZwFGl
kpTwptbXqiGhMsSDWeGGt+D0/IrdIBklNuWSbmstm18iQtaSbMHQxaujAcn4Ph7l3gPT0i77wKrr
34rdxiDxjkZIh7K/Wsl34ejFRBiZq1ryxCMoKNuIWw==
=hDRi
-----END PGP SIGNATURE-----

--------------W6dlOTs8h0LU1RtKHyq845NT--
