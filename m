Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEBFB4E8415
	for <lists+stable@lfdr.de>; Sat, 26 Mar 2022 21:15:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234905AbiCZUQm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Mar 2022 16:16:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38472 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233000AbiCZUQm (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 26 Mar 2022 16:16:42 -0400
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC56164FF;
        Sat, 26 Mar 2022 13:15:05 -0700 (PDT)
Received: from imladris.surriel.com ([96.67.55.152])
        by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <riel@shelob.surriel.com>)
        id 1nYCoJ-0006pu-6P; Sat, 26 Mar 2022 16:14:55 -0400
Message-ID: <5b734809fef4d76944490d5ac3ea816f0756b90a.camel@surriel.com>
Subject: Re: [PATCH] mm,hwpoison: unmap poisoned page before invalidation
From:   Rik van Riel <riel@surriel.com>
To:     Miaohe Lin <linmiaohe@huawei.com>
Cc:     linux-mm@kvack.org, kernel-team@fb.com,
        Oscar Salvador <osalvador@suse.de>,
        Naoya Horiguchi <naoya.horiguchi@nec.com>,
        Mel Gorman <mgorman@suse.de>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, linux-kernel <linux-kernel@vger.kernel.org>
Date:   Sat, 26 Mar 2022 16:14:54 -0400
In-Reply-To: <e6aa40b9-1cd8-b13f-555b-5f8ad863f196@huawei.com>
References: <20220325161428.5068d97e@imladris.surriel.com>
         <e6aa40b9-1cd8-b13f-555b-5f8ad863f196@huawei.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-yyEVjlUEaZO5whgwVvNZ"
User-Agent: Evolution 3.42.4 (3.42.4-1.fc35) 
MIME-Version: 1.0
Sender: riel@shelob.surriel.com
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-yyEVjlUEaZO5whgwVvNZ
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64

T24gU2F0LCAyMDIyLTAzLTI2IGF0IDE1OjQ4ICswODAwLCBNaWFvaGUgTGluIHdyb3RlOgo+IE9u
IDIwMjIvMy8yNiA0OjE0LCBSaWsgdmFuIFJpZWwgd3JvdGU6Cj4gPiAKPiA+ICsrKyBiL21tL21l
bW9yeS5jCj4gPiBAQCAtMzkxOCwxNCArMzkxOCwxOCBAQCBzdGF0aWMgdm1fZmF1bHRfdCBfX2Rv
X2ZhdWx0KHN0cnVjdAo+ID4gdm1fZmF1bHQgKnZtZikKPiA+IMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgcmV0dXJuIHJldDsKPiA+IMKgCj4gPiDCoMKgwqDCoMKgwqDCoMKgaWYgKHVu
bGlrZWx5KFBhZ2VIV1BvaXNvbih2bWYtPnBhZ2UpKSkgewo+ID4gK8KgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoHN0cnVjdCBwYWdlICpwYWdlID0gdm1mLT5wYWdlOwo+ID4gwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB2bV9mYXVsdF90IHBvaXNvbnJldCA9IFZNX0ZBVUxUX0hX
UE9JU09OOwo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBpZiAocmV0ICYgVk1f
RkFVTFRfTE9DS0VEKSB7Cj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoGlmIChwYWdlX21hcHBlZChwYWdlKSkKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHVubWFwX21hcHBpbmdf
cGFnZXMocGFnZV9tYXBwaW5nKHBhCj4gPiBnZSksCj4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoCBwYWdlLT5pbmRleCwgMSwKPiA+IGZhbHNlKTsKPiAKPiBJ
dCBzZWVtcyB0aGlzIHVubWFwX21hcHBpbmdfcGFnZXMgYWxzbyBoZWxwcyB0aGUgc3VjY2VzcyBy
YXRlIG9mIHRoZQo+IGJlbG93IGludmFsaWRhdGVfaW5vZGVfcGFnZS4KPiAKClRoYXQgaXMgaW5k
ZWVkIHdoYXQgaXQgaXMgc3VwcG9zZWQgdG8gZG8uCgpJdCBpc24ndCBmb29sIHByb29mLCBzaW5j
ZSB5b3UgY2FuIHN0aWxsIGVuZCB1cAp3aXRoIGRpcnR5IHBhZ2VzIHRoYXQgZG9uJ3QgZ2V0IGNs
ZWFuZWQgaW1tZWRpYXRlbHksCmJ1dCBpdCBzZWVtcyB0byB0dXJuIGluZmluaXRlIGxvb3BzIG9m
IGEgcHJvZ3JhbQpiZWluZyBraWxsZWQgZXZlcnkgdGltZSBpdCdzIHN0YXJ0ZWQgaW50byBhIG1v
cmUKbWFuYWdlYWJsZSBzaXR1YXRpb24gd2hlcmUgdGhlIHRhc2sgc3VjY2VlZHMgYWdhaW4KcHJl
dHR5IHF1aWNrbHkuCgo+ID4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgLyogUmV0cnkgaWYgYSBjbGVhbiBwYWdlIHdhcyByZW1vdmVkIGZyb20KPiA+IHRo
ZSBjYWNoZS4gKi8KPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgaWYgKGludmFsaWRhdGVfaW5vZGVfcGFnZSh2bWYtPnBhZ2UpKQo+ID4gLcKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgcG9p
c29ucmV0ID0gMDsKPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgdW5sb2NrX3BhZ2Uodm1mLT5wYWdlKTsKPiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKGludmFsaWRhdGVfaW5vZGVfcGFnZShwYWdlKSkK
PiA+ICvCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHBvaXNvbnJldCA9IFZNX0ZBVUxUX05PUEFHRTsKPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgdW5sb2NrX3BhZ2UocGFnZSk7Cj4gPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoH0KPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqBwdXRfcGFnZSh2bWYtPnBhZ2UpOwo+ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoHB1dF9wYWdlKHBhZ2UpOwo+IAo+IERvIHdlIHVzZSBwYWdlIGluc3RlYWQgb2Yg
dm1mLT5wYWdlIGp1c3QgZm9yIHNpbXBsaWNpdHk/IE9yIHRoZXJlIGlzCj4gc29tZSBvdGhlciBj
b25jZXJuPwo+IAoKSnVzdCBhIHNpbXBsaWZpY2F0aW9uLCBhbmQgbm90IGRlcmVmZXJlbmNpbmcg
dGhlIHNhbWUgdGhpbmcKNiB0aW1lcy4KCj4gPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoHZtZi0+cGFnZSA9IE5VTEw7Cj4gCj4gV2UgcmV0dXJuIGVpdGhlciBWTV9GQVVMVF9OT1BB
R0Ugb3IgVk1fRkFVTFRfSFdQT0lTT04gd2l0aCB2bWYtPnBhZ2UKPiA9IE5VTEwuIElmIGFueSBj
YXNlLAo+IGZpbmlzaF9mYXVsdCB3b24ndCBiZSBjYWxsZWQgbGF0ZXIuIFNvIEkgdGhpbmsgeW91
ciBmaXggaXMgcmlnaHQuCgpXYW50IHRvIHNlbmQgaW4gYSBSZXZpZXdlZC1ieSBvciBBY2tlZC1i
eT8gOikKCi0tIApBbGwgUmlnaHRzIFJldmVyc2VkLgo=


--=-yyEVjlUEaZO5whgwVvNZ
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAmI/dD4ACgkQznnekoTE
3oPIOQf/YksPhwQYLGaGg3PSw+xwuRhx8LNWH32ckzlyrCGtFpCmiuojp3+S4Kb8
SSIVV+gkEPyageY6Mapntzp1IPLSlEMSmZ2Xg/82oWLPNtaKljDHnzalS/IJjtIK
ENDXyP2IaV0DFcoEgVkLp/64z3YRWjgpKDOPoDusopYBMqNITKy10I1LdaEqwOt9
idBYBC7/YNIZvQPe5QL2CTR0k4Mbggp/3MUdyhZYxeEKp05c3D3VRRotcokGVgQ3
WLuqS+OCoZ18KPpDz9BQOygcmOHcXPMtODkS9F/vjNYDO9gxJMTUFo/zLKwlglrb
rOKQebP5m9IIRcKxLvgFN3WyA+IMTQ==
=xICT
-----END PGP SIGNATURE-----

--=-yyEVjlUEaZO5whgwVvNZ--
