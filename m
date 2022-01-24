Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1263497FB8
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 13:40:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239489AbiAXMkO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 07:40:14 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:39402 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239490AbiAXMkN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 07:40:13 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 896221F38F;
        Mon, 24 Jan 2022 12:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1643028012; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XajGxulaaLXGP0VFFS+7GdZyUSXEZGH8K4cDVafMWO8=;
        b=zC7PK5iUzKqnSvFynuKZ7pVs0MDp9cGS+neMNXswgrZeOp2X5p5h70ntQ1NYqquIbSu/xP
        CFxnzgnVF8bcH5vZ/JiNAPsulAtSlF9oz++WDrED9SC3OdnHb1NRTz0srhq+4oexLpeYp4
        HmvBo+WV4a9VbDoLSSL+p92m8Pr76+Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1643028012;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XajGxulaaLXGP0VFFS+7GdZyUSXEZGH8K4cDVafMWO8=;
        b=K4utfoiwRrEXtS54eouyXj4GTKWvRbWtm6yGJwebPzIEskdGYlV5FAKXCHqjtzfjAgh4XI
        YNeonKHHv8MpOYBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 47D8313B97;
        Mon, 24 Jan 2022 12:40:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9pxzECye7mFANwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Mon, 24 Jan 2022 12:40:12 +0000
Message-ID: <b0f6ddd2-c648-6ddd-0226-d48d333273cc@suse.de>
Date:   Mon, 24 Jan 2022 13:40:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3] drm/ast: Don't check new mode if CRTC is being
 disabled
Content-Language: en-US
To:     dann frazier <dann.frazier@canonical.com>
Cc:     airlied@redhat.com, daniel@ffwll.ch, kraxel@redhat.com,
        sam@ravnborg.org, emil.velikov@collabora.com, cogarre@gmail.com,
        dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>, stable@vger.kernel.org
References: <20200507090640.21561-1-tzimmermann@suse.de>
 <YerQWPxMNYV+zOSG@xps13.dannf>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <YerQWPxMNYV+zOSG@xps13.dannf>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------BWr0dKxr4s3Q0JyO9WEuR6mx"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------BWr0dKxr4s3Q0JyO9WEuR6mx
Content-Type: multipart/mixed; boundary="------------fPDdQBLBdYaQoqbpyoRdf53D";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: dann frazier <dann.frazier@canonical.com>
Cc: airlied@redhat.com, daniel@ffwll.ch, kraxel@redhat.com, sam@ravnborg.org,
 emil.velikov@collabora.com, cogarre@gmail.com,
 dri-devel@lists.freedesktop.org, Daniel Vetter <daniel.vetter@ffwll.ch>,
 stable@vger.kernel.org
Message-ID: <b0f6ddd2-c648-6ddd-0226-d48d333273cc@suse.de>
Subject: Re: [PATCH v3] drm/ast: Don't check new mode if CRTC is being
 disabled
References: <20200507090640.21561-1-tzimmermann@suse.de>
 <YerQWPxMNYV+zOSG@xps13.dannf>
In-Reply-To: <YerQWPxMNYV+zOSG@xps13.dannf>

--------------fPDdQBLBdYaQoqbpyoRdf53D
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMjEuMDEuMjIgdW0gMTY6MjUgc2NocmllYiBkYW5uIGZyYXppZXI6DQpbLi4u
XQ0KPiANCj4gaGV5LA0KPiAgICBJJ20gc2VlaW5nIGEgcmVncmVzc2lvbiB0aGF0IEkgYmlz
ZWN0ZWQgZG93biB0byB0aGlzIGNoYW5nZS4gSQ0KPiBpbnN0YWxsZWQgR05PTUUgb24gYSBj
b3VwbGUgb2YgZGlmZmVyZW50IHNlcnZlciBtb2RlbHMgdGhhdCBoYXZlDQo+IEFNSS1iYXNl
ZCBCTUNzLCB3aGljaCBwcm92aWRlIGEgd2ViLWJhc2VkIGdyYXBoaWNzIGRpc3BsYXkgKHZp
cnR1YWwNCj4gS1ZNKS4gV2hlbiBJIGVudGVyIHRoZSBsb2NrIHNjcmVlbiBvbiBjdXJyZW50
IHVwc3RyZWFtIGtlcm5lbHMsIHRoZQ0KPiBkaXNwbGF5IGZyZWV6ZXMsIGFuZCBJIHNlZSB0
aGUgZm9sbG93aW5nIG1lc3NhZ2VzIGFwcGVhciBpbiBzeXNsb2cNCj4gd2hlbmV2ZXIgSSBn
ZW5lcmF0ZSBrZXlib2FyZC9tb3VzZSBldmVudHMgb24gdGhhdCBkaXNwbGF5Og0KPiANCj4g
SmFuIDE5IDIwOjM0OjUzIHN0YXJidWNrIGdub21lLXNoZWxsWzUwMDJdOiBGYWlsZWQgdG8g
cG9zdCBLTVMgdXBkYXRlOiBkcm1Nb2RlQXRvbWljQ29tbWl0OiBJbnZhbGlkIGFyZ3VtZW50
DQo+IEphbiAxOSAyMDozNDo1MyBzdGFyYnVjayBnbm9tZS1zaGVsbFs1MDAyXTogUGFnZSBm
bGlwIGRpc2NhcmRlZDogZHJtTW9kZUF0b21pY0NvbW1pdDogSW52YWxpZCBhcmd1bWVudA0K
PiBKYW4gMTkgMjA6MzQ6NTMgc3RhcmJ1Y2sgZ25vbWUtc2hlbGxbNTAwMl06IEZhaWxlZCB0
byBwb3N0IEtNUyB1cGRhdGU6IGRybU1vZGVBdG9taWNDb21taXQ6IEludmFsaWQgYXJndW1l
bnQNCj4gSmFuIDE5IDIwOjM0OjUzIHN0YXJidWNrIGdub21lLXNoZWxsWzUwMDJdOiBQYWdl
IGZsaXAgZGlzY2FyZGVkOiBkcm1Nb2RlQXRvbWljQ29tbWl0OiBJbnZhbGlkIGFyZ3VtZW50
DQo+IEphbiAxOSAyMDozNDo1MyBzdGFyYnVjayBnbm9tZS1zaGVsbFs1MDAyXTogRmFpbGVk
IHRvIHBvc3QgS01TIHVwZGF0ZTogZHJtTW9kZUF0b21pY0NvbW1pdDogSW52YWxpZCBhcmd1
bWVudA0KPiBKYW4gMTkgMjA6MzQ6NTMgc3RhcmJ1Y2sgZ25vbWUtc2hlbGxbNTAwMl06IFBh
Z2UgZmxpcCBkaXNjYXJkZWQ6IGRybU1vZGVBdG9taWNDb21taXQ6IEludmFsaWQgYXJndW1l
bnQNCj4gSmFuIDE5IDIwOjM0OjUzIHN0YXJidWNrIGdub21lLXNoZWxsWzUwMDJdOiBGYWls
ZWQgdG8gcG9zdCBLTVMgdXBkYXRlOiBkcm1Nb2RlQXRvbWljQ29tbWl0OiBJbnZhbGlkIGFy
Z3VtZW50DQoNClRoYW5rcyBmb3IgcmVwb3J0aW5nLiBJJ2xsIGludmVzdGlnYXRlIHNvb24u
DQoNCkJlc3QgcmVnYXJkcw0KVGhvbWFzDQoNCj4gDQo+IElmIEkgYmFjayBvdXQgdGhpcyBj
aGFuZ2Ugdy8gdGhlIGZvbGxvd2luZyBwYXRjaCAoY29kZSBoYXMgZXZvbHZlZA0KPiBzbGln
aHRseSBwcmV2ZW50aW5nIGEgY2xlYW4gcmV2ZXJ0KSwgdGhlbiB0aGUgbG9jayBzY3JlZW4g
b25jZSBhZ2Fpbg0KPiBiZWhhdmVzIG5vcm1hbGx5Og0KPiANCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvZ3B1L2RybS9hc3QvYXN0X21vZGUuYyBiL2RyaXZlcnMvZ3B1L2RybS9hc3QvYXN0
X21vZGUuYw0KPiBpbmRleCA5NTZjODk4MjE5MmIuLjMzNmM1NDVjNDZmNSAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9ncHUvZHJtL2FzdC9hc3RfbW9kZS5jDQo+ICsrKyBiL2RyaXZlcnMv
Z3B1L2RybS9hc3QvYXN0X21vZGUuYw0KPiBAQCAtMTAxMiw5ICsxMDEyLDYgQEAgc3RhdGlj
IGludCBhc3RfY3J0Y19oZWxwZXJfYXRvbWljX2NoZWNrKHN0cnVjdCBkcm1fY3J0YyAqY3J0
YywNCj4gICAJY29uc3Qgc3RydWN0IGRybV9mb3JtYXRfaW5mbyAqZm9ybWF0Ow0KPiAgIAli
b29sIHN1Y2M7DQo+ICAgDQo+IC0JaWYgKCFjcnRjX3N0YXRlLT5lbmFibGUpDQo+IC0JCXJl
dHVybiAwOyAvKiBubyBtb2RlIGNoZWNrcyBpZiBDUlRDIGlzIGJlaW5nIGRpc2FibGVkICov
DQo+IC0NCj4gICAJYXN0X3N0YXRlID0gdG9fYXN0X2NydGNfc3RhdGUoY3J0Y19zdGF0ZSk7
DQo+ICAgDQo+ICAgCWZvcm1hdCA9IGFzdF9zdGF0ZS0+Zm9ybWF0Ow0KPiANCj4gDQo+IEFw
b2xvZ2llcyBmb3Igbm90aWNpbmcgc28gbG9uZyBhZnRlciB0aGUgZmFjdC4gSSBkb24ndCBu
b3JtYWxseSBydW4gYQ0KPiBkZXNrdG9wIGVudmlyb25tZW50IG9uIHRoZXNlIHNlcnZlcnMs
IEkganVzdCBoYXBwZW5lZCB0byBiZSBkZWJ1Z2dpbmcNCj4gc29tZXRoaW5nIHJlY2VudGx5
IHRoYXQgcmVxdWlyZWQgaXQuDQo+IA0KPiAgICAtZGFubg0KDQotLSANClRob21hcyBaaW1t
ZXJtYW5uDQpHcmFwaGljcyBEcml2ZXIgRGV2ZWxvcGVyDQpTVVNFIFNvZnR3YXJlIFNvbHV0
aW9ucyBHZXJtYW55IEdtYkgNCk1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVyZywgR2Vy
bWFueQ0KKEhSQiAzNjgwOSwgQUcgTsO8cm5iZXJnKQ0KR2VzY2jDpGZ0c2bDvGhyZXI6IEl2
byBUb3Rldg0K

--------------fPDdQBLBdYaQoqbpyoRdf53D--

--------------BWr0dKxr4s3Q0JyO9WEuR6mx
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmHunisFAwAAAAAACgkQlh/E3EQov+AC
dxAAihx3QruRjOaipuErW8mCYi+iTWBqdaiMGtHjDX/Cgv4vZLL51O40cD1wPzhgcviJFM3YLygJ
2X5uX7mhrs9k2OHcm5x1zYK8f3z84LYpGEF9rV3+OLLtAkQZn8PgXoTWnV88/ZDA4jektDutpPTD
KeCY8rier9MgLJ+OxWnM9GLILBXeWrxpMtyOeewbn3Y5SNRD5DU6LHA7ociDA59SIcy7Swz2Xss/
jfwtZgFF7BQuiL4DdFerh3XxanvTrjbRj+vAnBu+Z5w7k4HimEnnwIPcyp3DvV5VlDR3cG8qTfkX
V345CAr07npV1OeiuEC1oNR1dnAtpFgakiMbGr5zeZgDYMD8j6NrutOVW/CVh7aS5b20XkVN9vCa
ortuKZgDFnBrBspuwz8U4VP9HJ5UTcllb/IdIPo5UQn2oVDhhOIxZi4wzIl4PIl2m0fT6tdLDWmr
+Vki610QjJBKG60Kz9X++Md9Xxh6WHpNrK7+P1hol1iQFV5zK01egiKV7dRpK5cRt59aKoBvEyvX
PZck5kGCE31kJyyp2wkFCpEoxRG9piELG5inwGQtQPzyPxPb5hQ3loLdyB80SyeC81DSXAIapngo
uvU+6Znzo+jiydHtuypUpmBUhmCcYNJzs0D+Fqe+3opItBNoFJ582JY1zLMimvrwhYARMnHkhlHn
ihM=
=K9JQ
-----END PGP SIGNATURE-----

--------------BWr0dKxr4s3Q0JyO9WEuR6mx--
