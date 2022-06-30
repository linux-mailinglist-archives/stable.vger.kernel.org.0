Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4FD561B1E
	for <lists+stable@lfdr.de>; Thu, 30 Jun 2022 15:16:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229964AbiF3NQo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jun 2022 09:16:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234003AbiF3NQn (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jun 2022 09:16:43 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE20722B2E
        for <stable@vger.kernel.org>; Thu, 30 Jun 2022 06:16:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id A566D21D34;
        Thu, 30 Jun 2022 13:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1656595001; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=pNe559UvQnooprBZ6Fnd5/T/TxJuQKzcXs6v8CV/2no=;
        b=EU2/n1QH/oqY66T4suniblgB7/5IElnc2M1B8thaOhDHO9R6u6aj+eGHmuPdt4ezFIYFCO
        OFIVOeCaTHdJb0Qa0yy0xeq8xduYHwJxws+Fq9THBRdNjtC2R8GrLkvSUkXadrUE9PedNM
        ZMK39dmCMqLqhROfbLzyzk8QXrgTToQ=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 80CF7139E9;
        Thu, 30 Jun 2022 13:16:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lIvwHTmivWL5SQAAMHmgww
        (envelope-from <jgross@suse.com>); Thu, 30 Jun 2022 13:16:41 +0000
Message-ID: <5136812e-e296-4acb-cafd-f189c4013ed3@suse.com>
Date:   Thu, 30 Jun 2022 15:16:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Demi Marie Obenour <demi@invisiblethingslab.com>
Cc:     stable@vger.kernel.org,
        Xen developer discussion <xen-devel@lists.xenproject.org>
References: <20220627181006.1954-1-demi@invisiblethingslab.com>
 <Yr2KKpWSiuzOQr7v@kroah.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH 5.10] xen/gntdev: Avoid blocking in unmap_grant_pages()
In-Reply-To: <Yr2KKpWSiuzOQr7v@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------JsDTrELbzCD9OasTk9RasDaR"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------JsDTrELbzCD9OasTk9RasDaR
Content-Type: multipart/mixed; boundary="------------9pcFxfFI7ecXR7Cq6zP7LG0J";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Greg KH <gregkh@linuxfoundation.org>,
 Demi Marie Obenour <demi@invisiblethingslab.com>
Cc: stable@vger.kernel.org,
 Xen developer discussion <xen-devel@lists.xenproject.org>
Message-ID: <5136812e-e296-4acb-cafd-f189c4013ed3@suse.com>
Subject: Re: [PATCH 5.10] xen/gntdev: Avoid blocking in unmap_grant_pages()
References: <20220627181006.1954-1-demi@invisiblethingslab.com>
 <Yr2KKpWSiuzOQr7v@kroah.com>
In-Reply-To: <Yr2KKpWSiuzOQr7v@kroah.com>

--------------9pcFxfFI7ecXR7Cq6zP7LG0J
Content-Type: multipart/mixed; boundary="------------EALeCf4fgxcjdvskUURL5ywM"

--------------EALeCf4fgxcjdvskUURL5ywM
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMzAuMDYuMjIgMTM6MzQsIEdyZWcgS0ggd3JvdGU6DQo+IE9uIE1vbiwgSnVuIDI3LCAy
MDIyIGF0IDAyOjEwOjAyUE0gLTA0MDAsIERlbWkgTWFyaWUgT2Jlbm91ciB3cm90ZToNCj4+
IGNvbW1pdCBkYmU5N2NmZjdkZDlmMGY3NWM1MjRhZmRkNTVhZDQ2YmUzZDE1Mjk1IHVwc3Ry
ZWFtDQo+Pg0KPj4gdW5tYXBfZ3JhbnRfcGFnZXMoKSBjdXJyZW50bHkgd2FpdHMgZm9yIHRo
ZSBwYWdlcyB0byBubyBsb25nZXIgYmUgdXNlZC4NCj4+IEluIGh0dHBzOi8vZ2l0aHViLmNv
bS9RdWJlc09TL3F1YmVzLWlzc3Vlcy9pc3N1ZXMvNzQ4MSwgdGhpcyBsZWFkIHRvIGENCj4+
IGRlYWRsb2NrIGFnYWluc3QgaTkxNTogaTkxNSB3YXMgd2FpdGluZyBmb3IgZ250ZGV2J3Mg
TU1VIG5vdGlmaWVyIHRvDQo+PiBmaW5pc2gsIHdoaWxlIGdudGRldiB3YXMgd2FpdGluZyBm
b3IgaTkxNSB0byBmcmVlIGl0cyBwYWdlcy4gIEkgYWxzbw0KPj4gYmVsaWV2ZSB0aGlzIGlz
IHJlc3BvbnNpYmxlIGZvciB2YXJpb3VzIGRlYWRsb2NrcyBJIGhhdmUgZXhwZXJpZW5jZWQg
aW4NCj4+IHRoZSBwYXN0Lg0KPj4NCj4+IEF2b2lkIHRoZXNlIHByb2JsZW1zIGJ5IG1ha2lu
ZyB1bm1hcF9ncmFudF9wYWdlcyBhc3luYy4gIFRoaXMgcmVxdWlyZXMNCj4+IG1ha2luZyBp
dCByZXR1cm4gdm9pZCwgYXMgYW55IGVycm9ycyB3aWxsIG5vdCBiZSBhdmFpbGFibGUgd2hl
biB0aGUNCj4+IGZ1bmN0aW9uIHJldHVybnMuICBGb3J0dW5hdGVseSwgdGhlIG9ubHkgdXNl
IG9mIHRoZSByZXR1cm4gdmFsdWUgaXMgYQ0KPj4gV0FSTl9PTigpLCB3aGljaCBjYW4gYmUg
cmVwbGFjZWQgYnkgYSBXQVJOX09OIHdoZW4gdGhlIGVycm9yIGlzDQo+PiBkZXRlY3RlZC4g
IEFkZGl0aW9uYWxseSwgYSBmYWlsZWQgY2FsbCB3aWxsIG5vdCBwcmV2ZW50IGZ1cnRoZXIg
Y2FsbHMNCj4+IGZyb20gYmVpbmcgbWFkZSwgYnV0IHRoaXMgaXMgaGFybWxlc3MuDQo+Pg0K
Pj4gQmVjYXVzZSB1bm1hcF9ncmFudF9wYWdlcyBpcyBub3cgYXN5bmMsIHRoZSBncmFudCBo
YW5kbGUgd2lsbCBiZSBzZW50IHRvDQo+PiBJTlZBTElEX0dSQU5UX0hBTkRMRSB0b28gbGF0
ZSB0byBwcmV2ZW50IG11bHRpcGxlIHVubWFwcyBvZiB0aGUgc2FtZQ0KPj4gaGFuZGxlLiAg
SW5zdGVhZCwgYSBzZXBhcmF0ZSBib29sIGFycmF5IGlzIGFsbG9jYXRlZCBmb3IgdGhpcyBw
dXJwb3NlLg0KPj4gVGhpcyB3YXN0ZXMgbWVtb3J5LCBidXQgc3R1ZmZpbmcgdGhpcyBpbmZv
cm1hdGlvbiBpbiBwYWRkaW5nIGJ5dGVzIGlzDQo+PiB0b28gZnJhZ2lsZS4gIEZ1cnRoZXJt
b3JlLCBpdCBpcyBuZWNlc3NhcnkgdG8gZ3JhYiBhIHJlZmVyZW5jZSB0byB0aGUNCj4+IG1h
cCBiZWZvcmUgbWFraW5nIHRoZSBhc3luY2hyb25vdXMgY2FsbCwgYW5kIHJlbGVhc2UgdGhl
IHJlZmVyZW5jZSB3aGVuDQo+PiB0aGUgY2FsbCByZXR1cm5zLg0KPj4NCj4+IEl0IGlzIGFs
c28gbmVjZXNzYXJ5IHRvIGd1YXJkIGFnYWluc3QgcmVlbnRyYW5jeSBpbiBnbnRkZXZfbWFw
X3B1dCgpLA0KPj4gYW5kIHRvIGhhbmRsZSB0aGUgY2FzZSB3aGVyZSB1c2Vyc3BhY2UgdHJp
ZXMgdG8gbWFwIGEgbWFwcGluZyB3aG9zZQ0KPj4gY29udGVudHMgaGF2ZSBub3QgYWxsIGJl
ZW4gZnJlZWQgeWV0Lg0KPj4NCj4+IEZpeGVzOiA3NDUyODIyNTZjNzUgKCJ4ZW4vZ250ZGV2
OiBzYWZlbHkgdW5tYXAgZ3JhbnRzIGluIGNhc2UgdGhleSBhcmUgc3RpbGwgaW4gdXNlIikN
Cj4+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+PiBTaWduZWQtb2ZmLWJ5OiBEZW1p
IE1hcmllIE9iZW5vdXIgPGRlbWlAaW52aXNpYmxldGhpbmdzbGFiLmNvbT4NCj4+IFJldmll
d2VkLWJ5OiBKdWVyZ2VuIEdyb3NzIDxqZ3Jvc3NAc3VzZS5jb20+DQo+PiBMaW5rOiBodHRw
czovL2xvcmUua2VybmVsLm9yZy9yLzIwMjIwNjIyMDIyNzI2LjI1MzgtMS1kZW1pQGludmlz
aWJsZXRoaW5nc2xhYi5jb20NCj4+IFNpZ25lZC1vZmYtYnk6IEp1ZXJnZW4gR3Jvc3MgPGpn
cm9zc0BzdXNlLmNvbT4NCj4+IC0tLQ0KPj4gICBkcml2ZXJzL3hlbi9nbnRkZXYtY29tbW9u
LmggfCAgIDcgKysNCj4+ICAgZHJpdmVycy94ZW4vZ250ZGV2LmMgICAgICAgIHwgMTQyICsr
KysrKysrKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLQ0KPj4gICAyIGZpbGVzIGNoYW5n
ZWQsIDEwNiBpbnNlcnRpb25zKCspLCA0MyBkZWxldGlvbnMoLSkNCj4gDQo+IEFsbCBub3cg
cXVldWVkIHVwLCB0aGFua3MuDQoNClNvcnJ5LCBidXQgSSB0aGluayBhdCBsZWFzdCB0aGUg
dmVyc2lvbiBmb3IgNS4xMCBpcyBmaXNoeSwgYXMgaXQgcmVtb3Zlcw0KdGhlIHRlc3RzIGZv
ciBzdWNjZXNzZnVsIGFsbG9jYXRpb25zIG9mIGFkZC0+bWFwX29wcyBhbmQgYWRkLT51bm1h
cF9vcHMuDQoNCkkgbmVlZCB0byBkbyBhIHRob3JvdWdoIHJldmlldyBvZiB0aGUgcGF0Y2hl
cyAodGhlICJSZXZpZXdlZC1ieToiIHRhZyBpbg0KdGhlIHBhdGNoZXMgaXMgdGhlIG9uZSBm
b3IgdGhlIHVwc3RyZWFtIHBhdGNoKS4NCg0KR3JlZywgY2FuIHlvdSBwbGVhc2Ugd2FpdCBm
b3IgbXkgZXhwbGljaXQgIm9rYXkiIGZvciB0aGUgYmFja3BvcnRzPw0KDQoNCkp1ZXJnZW4N
Cg==
--------------EALeCf4fgxcjdvskUURL5ywM
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------EALeCf4fgxcjdvskUURL5ywM--

--------------9pcFxfFI7ecXR7Cq6zP7LG0J--

--------------JsDTrELbzCD9OasTk9RasDaR
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmK9ojkFAwAAAAAACgkQsN6d1ii/Ey9r
RAf/fK4KwxbWJNm57k+LFn5HNb01E0xInEBhjUbv8MCde5ew4svEPKceJGv7hkLCxIuAp7uX0nYf
lGOJr3EXoAecxqyP6d7IywEqwjiUaiaiUKPnknphVIwVRqRDuhklNo/ILJJy/yf7zNxsrh/zMzko
JtK27WDMIbW+BT7sM7DjG66gwB+dKsROPTco6xxdUVZynr3roLG1r+oMTTo/m5fcbMmQGuwDCJHt
xCtKKWSMlBLMcwcE3pb89LONbhEmqP09qwx+s/yZOr5CfXaXLA7JZCyP/YZ44wZazegze6F2tGn8
1hUN9N4NtQWwM9kP+GnCL4Bv9GiBI9VmB1Yd4lI0yQ==
=rv91
-----END PGP SIGNATURE-----

--------------JsDTrELbzCD9OasTk9RasDaR--
