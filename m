Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E18FD3CFFC9
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 18:55:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhGTQNd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Jul 2021 12:13:33 -0400
Received: from shelob.surriel.com ([96.67.55.147]:59302 "EHLO
        shelob.surriel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbhGTQNY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Jul 2021 12:13:24 -0400
X-Greylist: delayed 597 seconds by postgrey-1.27 at vger.kernel.org; Tue, 20 Jul 2021 12:13:08 EDT
Received: from imladris.surriel.com ([96.67.55.152])
        by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <riel@shelob.surriel.com>)
        id 1m5sqC-0001wX-Mu; Tue, 20 Jul 2021 12:43:32 -0400
Message-ID: <db2f01ee70c6436364e0efd7c65a11bdb14be73c.camel@surriel.com>
Subject: Re: [PATCH v2] xhci: add quirk for host controllers that don't
 update endpoint DCS
From:   Rik van Riel <riel@surriel.com>
To:     =?ISO-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        Mathias Nyman <mathias.nyman@intel.com>
Cc:     linux-usb@vger.kernel.org,
        Jonathan Bell <jonathan@raspberrypi.org>,
        stable@vger.kernel.org
Date:   Tue, 20 Jul 2021 12:43:32 -0400
In-Reply-To: <20210720150937.325469-1-bjorn@mork.no>
References: <87h7hdf5dy.fsf@miraculix.mork.no>
         <20210720150937.325469-1-bjorn@mork.no>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-QA1xLfceTjX4dEdy9vIv"
User-Agent: Evolution 3.40.2 (3.40.2-1.fc34) 
MIME-Version: 1.0
Sender: riel@shelob.surriel.com
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-QA1xLfceTjX4dEdy9vIv
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64

T24gVHVlLCAyMDIxLTA3LTIwIGF0IDE3OjA5ICswMjAwLCBCasO4cm4gTW9yayB3cm90ZToKPiBG
cm9tOiBKb25hdGhhbiBCZWxsIDxqb25hdGhhbkByYXNwYmVycnlwaS5vcmc+Cj4gCj4gU2VlbiBv
biBhIFZMSSBWTDgwNSBQQ0llIHRvIFVTQiBjb250cm9sbGVyLiBGb3Igbm9uLXN0cmVhbSBlbmRw
b2ludHMKPiBhdCBsZWFzdCwgaWYgdGhlIHhIQyBoYWx0cyBvbiBhIHBhcnRpY3VsYXIgVFJCIGR1
ZSB0byBhbiBlcnJvciB0aGVuCj4gdGhlIERDUyBmaWVsZCBpbiB0aGUgT3V0IEVuZHBvaW50IENv
bnRleHQgbWFpbnRhaW5lZCBieSB0aGUgaGFyZHdhcmUKPiBpcyBub3QgdXBkYXRlZCB3aXRoIHRo
ZSBjdXJyZW50IGN5Y2xlIHN0YXRlLgoKSSB3b25kZXIgaWYgInNvbWUgdGhpbmdzIGdldHRpbmcg
b3V0IG9mIHN5bmMiIChwcm9iYWJseSBub3QgdGhlCnNhbWUgdGhpbmdzKSBhcmUgdGhlIGNhdXNl
IG9mIHRoZSBVU0IgaXNzdWVzIEkgc2VlIGhlcmUgd2l0aCBhCm5vaXN5IGJ1cyBhbmQgdGhlIFBD
TTIzMDlCIGNoaXAuLi4KCj4gQEAgLTU5OCw3ICs2MDEsMjcgQEAgc3RhdGljIGludCB4aGNpX21v
dmVfZGVxdWV1ZV9wYXN0X3RkKHN0cnVjdAo+IHhoY2lfaGNkICp4aGNpLAo+IMKgwqDCoMKgwqDC
oMKgwqBod19kZXF1ZXVlID0geGhjaV9nZXRfaHdfZGVxKHhoY2ksIGRldiwgZXBfaW5kZXgsIHN0
cmVhbV9pZCk7Cj4gwqDCoMKgwqDCoMKgwqDCoG5ld19zZWcgPSBlcF9yaW5nLT5kZXFfc2VnOwo+
IMKgwqDCoMKgwqDCoMKgwqBuZXdfZGVxID0gZXBfcmluZy0+ZGVxdWV1ZTsKPiAtwqDCoMKgwqDC
oMKgwqBuZXdfY3ljbGUgPSBod19kZXF1ZXVlICYgMHgxOwo+ICsKPiArwqDCoMKgwqDCoMKgwqAv
Kgo+ICvCoMKgwqDCoMKgwqDCoCAqIFF1aXJrOiB4SEMgd3JpdGUtYmFjayBvZiB0aGUgRENTIGZp
ZWxkIGluIHRoZSBoYXJkd2FyZQo+IGRlcXVldWUKPiArwqDCoMKgwqDCoMKgwqAgKiBwb2ludGVy
IGlzIHdyb25nIC0gdXNlIHRoZSBjeWNsZSBzdGF0ZSBvZiB0aGUgVFJCIHBvaW50ZWQKPiB0byBi
eQo+ICvCoMKgwqDCoMKgwqDCoCAqIHRoZSBkZXF1ZXVlIHBvaW50ZXIuCj4gK8KgwqDCoMKgwqDC
oMKgICovCj4gK8KgwqDCoMKgwqDCoMKgaWYgKHhoY2ktPnF1aXJrcyAmIFhIQ0lfRVBfQ1RYX0JS
T0tFTl9EQ1MgJiYKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqAgIShlcC0+ZXBfc3RhdGUgJiBFUF9I
QVNfU1RSRUFNUykpCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGhhbHRlZF9zZWcg
PSB0cmJfaW5fdGQoeGhjaSwgdGQtPnN0YXJ0X3NlZywKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAgdGQt
PmZpcnN0X3RyYiwgdGQtPmxhc3RfdHJiLAo+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBod19kZXF1ZXVl
ICYgfjB4ZiwgZmFsc2UpOwo+ICvCoMKgwqDCoMKgwqDCoGlmIChoYWx0ZWRfc2VnKSB7Cj4gK8Kg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGluZGV4ID0gKChkbWFfYWRkcl90KShod19kZXF1
ZXVlICYgfjB4ZikgLQo+IGhhbHRlZF9zZWctPmRtYSkgLwo+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgIHNpemVvZigqaGFsdGVkX3RyYik7Cj4gK8KgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoGhhbHRlZF90cmIgPSAmaGFsdGVkX3NlZy0+dHJic1tp
bmRleF07Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoG5ld19jeWNsZSA9IGhhbHRl
ZF90cmItPmdlbmVyaWMuZmllbGRbM10gJiAweDE7Cj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoHhoY2lfZGJnKHhoY2ksICJFbmRwb2ludCBEQ1MgPSAlZCBUUkIgaW5kZXggPSAlZAo+
IGN5Y2xlID0gJWRcbiIsCj4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqAgKHU4KShod19kZXF1ZXVlICYgMHgxKSwgaW5kZXgsIG5ld19jeWNsZSk7Cj4gK8Kg
wqDCoMKgwqDCoMKgfSBlbHNlIHsKPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgbmV3
X2N5Y2xlID0gaHdfZGVxdWV1ZSAmIDB4MTsKPiArwqDCoMKgwqDCoMKgwqB9CgpJcyB0aGVyZSBl
dmVyIGEgY2FzZSB3aGVyZSB0aGUgY3ljbGUgc3RhdGUgaXMgaW5jb3JyZWN0LAphbmQgd2Ugc2hv
dWxkIGJlIHVzaW5nIHRoZSBEQ1MgZmllbGQsIGluc3RlYWQ/CgpJIHdvbmRlciBpZiB0aGlzIGlz
IGEgcXVpcmsgdGhhdCBzaG91bGQganVzdCBiZSB1c2VkCmV2ZXJ5d2hlcmUsIGluc3RlYWQgb2Yg
b25seSBvbiBhIGZldyBzeXN0ZW1zIHdoZXJlIHdlIGtub3cKdGhlIGhhcmR3YXJlIGRvZXNuJ3Qg
YWx3YXlzIGJlaGF2ZSByaWdodD8KCkFyZSB0aGVyZSBvdGhlciBwbGFjZXMgd2hlcmUgdGhlIGhh
cmR3YXJlIGlzIHN1cHBvc2VkIHRvCnRyYWNrIHRoZSBzYW1lIGluZm9ybWF0aW9uIGluIG11bHRp
cGxlIHBsYWNlcywgYnV0IG1pZ2h0CnNvbWV0aW1lcyBnZXQgdGhlbSBvdXQgb2Ygc3luYz8KCklm
IHNvLCBkb2VzIHRoZSBjb2RlIGhhdmUgYW55IGRldGVjdGlvbiBvZiBzdWNoIGlzc3Vlcz8KCi0t
IApBbGwgUmlnaHRzIFJldmVyc2VkLgo=


--=-QA1xLfceTjX4dEdy9vIv
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAmD2/TQACgkQznnekoTE
3oND/AgAgHd0ArGlY+UfYaihMh+X4ddsa6s6/mWA2qnR3ph5QTVBCgWXaekfE3gm
LpEdMmN0sa5jjJqZjDPohd22xjQwHBOJqffoGyNAdbRoRmojbytkuEGdYHhTpXlZ
YZW9GHyoA3Z+jbW47WEm0XDv35AT6aDbkbAY7otFUFY+HmfyJ79Jx0qYZ9tEaAsG
3WPPOlodjgi7ADbfKIMc06mgzHfYPoy0OxyiZ53+xhNKBzE2te5EtOBfurN0HCKv
g9HKdv0gTl+konVESeV8zdbMcGgsWtbGjEwYmcso1GRdS9JnKpMGfAPM7n/5O4nq
JfFIdgG2VPdPP5I5bsa6jIxX9beaZg==
=U55k
-----END PGP SIGNATURE-----

--=-QA1xLfceTjX4dEdy9vIv--

