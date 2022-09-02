Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 415695AAD1A
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 13:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbiIBLIr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 07:08:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235336AbiIBLIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 07:08:40 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437C5CE336;
        Fri,  2 Sep 2022 04:08:39 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id DE20A1FED8;
        Fri,  2 Sep 2022 11:08:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1662116917; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OQKJWPbSeknFS2p5TaTKESaFO12O3cb0gTn/SCCCZgI=;
        b=fjZyqd9a55+CLVKcRTqepnjA5qUXp9YyHKS7d1A9dfUHlilYReQjKKVj5vyZzoUlhgphKo
        tcLJpb/eF1U9ovxuoz14yfslmcVSIDes9V4i3sAONSP3C/hRH5Eq52Q4xa9Oj3kQX/ruC8
        moeqU1C4rnMRhcDi4+RUIkJR2+02lM0=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 94B7E1330E;
        Fri,  2 Sep 2022 11:08:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id WgnSIjXkEWPpQQAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 02 Sep 2022 11:08:37 +0000
Message-ID: <84def263-c061-605f-44da-580c745bf5b6@suse.com>
Date:   Fri, 2 Sep 2022 13:08:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.12.0
Subject: Re: [PATCH v2 1/3] xen-blkback: Advertise feature-persistent as user
 requested
Content-Language: en-US
To:     Pratyush Yadav <ptyadav@amazon.de>, SeongJae Park <sj@kernel.org>
Cc:     roger.pau@citrix.com, marmarek@invisiblethingslab.com,
        mheyne@amazon.de, xen-devel@lists.xenproject.org, axboe@kernel.dk,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
References: <20220831165824.94815-1-sj@kernel.org>
 <20220831165824.94815-2-sj@kernel.org>
 <20220902095207.y3whbc5mw4hyqphg@yadavpratyush.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <20220902095207.y3whbc5mw4hyqphg@yadavpratyush.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------E4qBrFxb9XXKM8THkweeh7RA"
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
--------------E4qBrFxb9XXKM8THkweeh7RA
Content-Type: multipart/mixed; boundary="------------9bwtfbNIVhXfCZqDnn9IDv5I";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Pratyush Yadav <ptyadav@amazon.de>, SeongJae Park <sj@kernel.org>
Cc: roger.pau@citrix.com, marmarek@invisiblethingslab.com, mheyne@amazon.de,
 xen-devel@lists.xenproject.org, axboe@kernel.dk,
 linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Message-ID: <84def263-c061-605f-44da-580c745bf5b6@suse.com>
Subject: Re: [PATCH v2 1/3] xen-blkback: Advertise feature-persistent as user
 requested
References: <20220831165824.94815-1-sj@kernel.org>
 <20220831165824.94815-2-sj@kernel.org>
 <20220902095207.y3whbc5mw4hyqphg@yadavpratyush.com>
In-Reply-To: <20220902095207.y3whbc5mw4hyqphg@yadavpratyush.com>

--------------9bwtfbNIVhXfCZqDnn9IDv5I
Content-Type: multipart/mixed; boundary="------------LJRNnXWoagRkFyFEGiQdSuww"

--------------LJRNnXWoagRkFyFEGiQdSuww
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDIuMDkuMjIgMTE6NTMsIFByYXR5dXNoIFlhZGF2IHdyb3RlOg0KPiBPbiAzMS8wOC8y
MiAwNDo1OFBNLCBTZW9uZ0phZSBQYXJrIHdyb3RlOg0KPj4gVGhlIGFkdmVydGlzZW1lbnQg
b2YgdGhlIHBlcnNpc3RlbnQgZ3JhbnRzIGZlYXR1cmUgKHdyaXRpbmcNCj4+ICdmZWF0dXJl
LXBlcnNpc3RlbnQnIHRvIHhlbmJ1cykgc2hvdWxkIG1lYW4gbm90IHRoZSBkZWNpc2lvbiBm
b3IgdXNpbmcNCj4+IHRoZSBmZWF0dXJlIGJ1dCBvbmx5IHRoZSBhdmFpbGFiaWxpdHkgb2Yg
dGhlIGZlYXR1cmUuICBIb3dldmVyLCBjb21taXQNCj4+IGFhYzhhNzBkYjI0YiAoInhlbi1i
bGtiYWNrOiBhZGQgYSBwYXJhbWV0ZXIgZm9yIGRpc2FibGluZyBvZiBwZXJzaXN0ZW50DQo+
PiBncmFudHMiKSBtYWRlIGEgZmllbGQgb2YgYmxrYmFjaywgd2hpY2ggd2FzIGEgcGxhY2Ug
Zm9yIHNhdmluZyBvbmx5IHRoZQ0KPj4gbmVnb3RpYXRpb24gcmVzdWx0LCB0byBiZSB1c2Vk
IGZvciB5ZXQgYW5vdGhlciBwdXJwb3NlOiBjYWNoaW5nIG9mIHRoZQ0KPj4gJ2ZlYXR1cmVf
cGVyc2lzdGVudCcgcGFyYW1ldGVyIHZhbHVlLiAgQXMgYSByZXN1bHQsIHRoZSBhZHZlcnRp
c2VtZW50LA0KPj4gd2hpY2ggc2hvdWxkIGZvbGxvdyBvbmx5IHRoZSBwYXJhbWV0ZXIgdmFs
dWUsIGJlY29tZXMgaW5jb25zaXN0ZW50Lg0KPj4NCj4+IFRoaXMgY29tbWl0IGZpeGVzIHRo
ZSBtaXN1c2Ugb2YgdGhlIHNlbWFudGljIGJ5IG1ha2luZyBibGtiYWNrIHNhdmVzIHRoZQ0K
Pj4gcGFyYW1ldGVyIHZhbHVlIGluIGEgc2VwYXJhdGUgcGxhY2UgYW5kIGFkdmVydGlzZXMg
dGhlIHN1cHBvcnQgYmFzZWQgb24NCj4+IG9ubHkgdGhlIHNhdmVkIHZhbHVlLg0KPj4NCj4+
IEZpeGVzOiBhYWM4YTcwZGIyNGIgKCJ4ZW4tYmxrYmFjazogYWRkIGEgcGFyYW1ldGVyIGZv
ciBkaXNhYmxpbmcgb2YgcGVyc2lzdGVudCBncmFudHMiKQ0KPj4gQ2M6IDxzdGFibGVAdmdl
ci5rZXJuZWwub3JnPiAjIDUuMTAueA0KPj4gU3VnZ2VzdGVkLWJ5OiBKdWVyZ2VuIEdyb3Nz
IDxqZ3Jvc3NAc3VzZS5jb20+DQo+PiBTaWduZWQtb2ZmLWJ5OiBTZW9uZ0phZSBQYXJrIDxz
akBrZXJuZWwub3JnPg0KPj4gLS0tDQo+PiAgIGRyaXZlcnMvYmxvY2sveGVuLWJsa2JhY2sv
Y29tbW9uLmggfCAzICsrKw0KPj4gICBkcml2ZXJzL2Jsb2NrL3hlbi1ibGtiYWNrL3hlbmJ1
cy5jIHwgNiArKysrLS0NCj4+ICAgMiBmaWxlcyBjaGFuZ2VkLCA3IGluc2VydGlvbnMoKyks
IDIgZGVsZXRpb25zKC0pDQo+Pg0KPj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvYmxvY2sveGVu
LWJsa2JhY2svY29tbW9uLmggYi9kcml2ZXJzL2Jsb2NrL3hlbi1ibGtiYWNrL2NvbW1vbi5o
DQo+PiBpbmRleCBiZGE1YzgxNWU0NDEuLmEyODQ3MzQ3MGU2NiAxMDA2NDQNCj4+IC0tLSBh
L2RyaXZlcnMvYmxvY2sveGVuLWJsa2JhY2svY29tbW9uLmgNCj4+ICsrKyBiL2RyaXZlcnMv
YmxvY2sveGVuLWJsa2JhY2svY29tbW9uLmgNCj4+IEBAIC0yMjYsNiArMjI2LDkgQEAgc3Ry
dWN0IHhlbl92YmQgew0KPj4gICAgICAgICAgc2VjdG9yX3QgICAgICAgICAgICAgICAgc2l6
ZTsNCj4+ICAgICAgICAgIHVuc2lnbmVkIGludCAgICAgICAgICAgIGZsdXNoX3N1cHBvcnQ6
MTsNCj4+ICAgICAgICAgIHVuc2lnbmVkIGludCAgICAgICAgICAgIGRpc2NhcmRfc2VjdXJl
OjE7DQo+PiArICAgICAgIC8qIENvbm5lY3QtdGltZSBjYWNoZWQgZmVhdHVyZV9wZXJzaXN0
ZW50IHBhcmFtZXRlciB2YWx1ZSAqLw0KPj4gKyAgICAgICB1bnNpZ25lZCBpbnQgICAgICAg
ICAgICBmZWF0dXJlX2dudF9wZXJzaXN0ZW50X3Bhcm06MTsNCj4gDQo+IENvbnRpbnVpbmcg
b3ZlciBmcm9tIHRoZSBwcmV2aW91cyB2ZXJzaW9uOg0KPiANCj4+PiBJZiBmZWF0dXJlX2du
dF9wZXJzaXN0ZW50X3Bhcm0gaXMgYWx3YXlzIGdvaW5nIHRvIGJlIGVxdWFsIHRvDQo+Pj4g
ZmVhdHVyZV9wZXJzaXN0ZW50LCB0aGVuIHdoeSBpbnRyb2R1Y2UgaXQgYXQgYWxsPyBXaHkg
bm90IGp1c3QgdXNlDQo+Pj4gZmVhdHVyZV9wZXJzaXN0ZW50IGRpcmVjdGx5PyBUaGlzIHdh
eSB5b3UgYXZvaWQgYWRkaW5nIGFuIGV4dHJhIGZsYWcNCj4+PiB3aG9zZSBwdXJwb3NlIGlz
IG5vdCBpbW1lZGlhdGVseSBjbGVhciwgYW5kIHlvdSBhbHNvIGF2b2lkIGFsbCB0aGUNCj4+
PiBtZXNzIHdpdGggc2V0dGluZyB0aGlzIGZsYWcgYXQgdGhlIHJpZ2h0IHRpbWUuDQo+Pg0K
Pj4gTWFpbmx5IGJlY2F1c2UgdGhlIHBhcmFtZXRlciBzaG91bGQgcmVhZCB0d2ljZSAob25j
ZSBmb3INCj4+IGFkdmVydGlzZW1lbnQsIGFuZCBvbmNlIGxhdGVyIGp1c3QgYmVmb3JlIHRo
ZSBuZWdvdGl0YXRpb24sIGZvcg0KPj4gY2hlY2tpbmcgaWYgd2UgYWR2ZXJ0aXNlZCBvciBu
b3QpLCBhbmQgdGhlIHVzZXIgbWlnaHQgY2hhbmdlIHRoZQ0KPj4gcGFyYW1ldGVyIHZhbHVl
IGJldHdlZW4gdGhlIHR3byByZWFkcy4NCj4+DQo+PiBGb3IgdGhlIGRldGFpbGVkIGF2YWls
YWJsZSBzZXF1ZW5jZSBvZiB0aGUgcmFjZSwgeW91IGNvdWxkIHJlZmVyIHRvIHRoZQ0KPj4g
cHJpb3IgY29udmVyc2F0aW9uWzFdLg0KPj4NCj4+IFsxXSBodHRwczovL2xvcmUua2VybmVs
Lm9yZy9saW51eC1ibG9jay8yMDIwMDkyMjExMTI1OS5HSjE5MjU0QEFpci1kZS1Sb2dlci8N
Cj4gDQo+IE9rYXksIEkgc2VlLiBUaGFua3MgZm9yIHRoZSBwb2ludGVyLiBCdXQgc3RpbGws
IEkgdGhpbmsgaXQgd291bGQgYmUNCj4gYmV0dGVyIHRvIG5vdCBtYWludGFpbiB0d28gY29w
aWVzIG9mIHRoZSB2YWx1ZS4gSG93IGFib3V0IGRvaW5nOg0KPiANCj4gCWJsa2lmLT52YmQu
ZmVhdHVyZV9nbnRfcGVyc2lzdGVudCA9DQo+IAkJeGVuYnVzX3JlYWRfdW5zaWduZWQoZGV2
LT5ub2RlbmFtZSwgImZlYXR1cmUtcGVyc2lzdGVudCIsIDApICYmDQo+IAkJeGVuYnVzX3Jl
YWRfdW5zaWduZWQoZGV2LT5vdGhlcmVuZCwgImZlYXR1cmUtcGVyc2lzdGVudCIsIDApOw0K
PiANCj4gVGhpcyBtYWtlcyBpdCBxdWl0ZSBjbGVhciB0aGF0IHdlIG9ubHkgZW5hYmxlIHBl
cnNpc3RlbnQgZ3JhbnRzIGlmDQo+IF9ib3RoXyBlbmRzIHN1cHBvcnQgaXQuIFdlIGNhbiBk
byB0aGUgc2FtZSBmb3IgYmxrZnJvbnQuDQoNCkkgcHJlZmVyIGl0IGFzIGlzLCBhcyBpdCB3
aWxsIG5vdCByZWx5IG9uIG5vYm9keSBoYXZpbmcgbW9kaWZpZWQgdGhlDQpYZW5zdG9yZSBu
b2RlICh3aGljaCB3b3VsZCBpbiB0aGVvcnkgYmUgcG9zc2libGUpLg0KDQoNCkp1ZXJnZW4N
Cg==
--------------LJRNnXWoagRkFyFEGiQdSuww
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------LJRNnXWoagRkFyFEGiQdSuww--

--------------9bwtfbNIVhXfCZqDnn9IDv5I--

--------------E4qBrFxb9XXKM8THkweeh7RA
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmMR5DUFAwAAAAAACgkQsN6d1ii/Ey+4
ewf+IiYMMF37ivTMfTbYz675zUQOOHQOMZCqMgWRm0DZjx5gCLyj1k+D8gfdlWKA/kvm+IYHXccG
2LvpwNBuKbYdv87DHfeac54/2pkC1bl1RlqvgYFFlj8gCUsbFzmt2Ryq7W+OcmT5yDYFSyI/SnNx
gmOBXG7i/9KIGyIkd0erGzCDEEnH18y+wia0KFNAKOCBVE1Rw4qXqbps3zs4cQYsyYdDXgCLVnad
7xcNfy+vuoZfdZAyZ2e2DSdqaYcg4jiq8MzJh7QZNpj3fup63mo+uLHz6exyDjrmllGKWLMHaRJz
8OqWFRyJ62texSA1IOU0Xx1bj3Xv+uLUg3g/zGPwdw==
=QkJK
-----END PGP SIGNATURE-----

--------------E4qBrFxb9XXKM8THkweeh7RA--
