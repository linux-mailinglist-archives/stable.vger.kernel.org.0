Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384D24E8C0C
	for <lists+stable@lfdr.de>; Mon, 28 Mar 2022 04:24:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233306AbiC1CZ7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Mar 2022 22:25:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231679AbiC1CZ6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 27 Mar 2022 22:25:58 -0400
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BD5FDFD6;
        Sun, 27 Mar 2022 19:24:19 -0700 (PDT)
Received: from imladris.surriel.com ([96.67.55.152])
        by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_ECDSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <riel@shelob.surriel.com>)
        id 1nYf3B-00083X-7B; Sun, 27 Mar 2022 22:24:09 -0400
Message-ID: <1d4dc5f732e8da263c2a2e783e4550419cfb0c7b.camel@surriel.com>
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
Date:   Sun, 27 Mar 2022 22:24:08 -0400
In-Reply-To: <e3e3ae0f-50f6-6b13-c520-26aac353e0cb@huawei.com>
References: <20220325161428.5068d97e@imladris.surriel.com>
         <e6aa40b9-1cd8-b13f-555b-5f8ad863f196@huawei.com>
         <5b734809fef4d76944490d5ac3ea816f0756b90a.camel@surriel.com>
         <e3e3ae0f-50f6-6b13-c520-26aac353e0cb@huawei.com>
Content-Type: multipart/signed; micalg="pgp-sha256";
        protocol="application/pgp-signature"; boundary="=-gw9OjvNiSuMBA33y3aoL"
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


--=-gw9OjvNiSuMBA33y3aoL
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64

T24gTW9uLCAyMDIyLTAzLTI4IGF0IDEwOjE0ICswODAwLCBNaWFvaGUgTGluIHdyb3RlOgo+IE9u
IDIwMjIvMy8yNyA0OjE0LCBSaWsgdmFuIFJpZWwgd3JvdGU6Cj4gCj4gCj4gPiAKPiA+ID4gPiDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqAvKiBSZXRyeSBp
ZiBhIGNsZWFuIHBhZ2Ugd2FzIHJlbW92ZWQKPiA+ID4gPiBmcm9tCj4gPiA+ID4gdGhlIGNhY2hl
LiAqLwo+ID4gPiA+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgaWYgKGludmFsaWRhdGVfaW5vZGVfcGFnZSh2bWYtPnBhZ2UpKQo+ID4gPiA+IC3CoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoHBv
aXNvbnJldCA9IDA7Cj4gPiA+ID4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqB1bmxvY2tfcGFnZSh2bWYtPnBhZ2UpOwo+ID4gPiA+ICvCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgaWYgKGludmFsaWRhdGVfaW5vZGVfcGFn
ZShwYWdlKSkKPiA+ID4gPiArwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqBwb2lzb25yZXQgPSBWTV9GQVVMVF9OT1BBR0U7Cj4gPiA+
ID4gK8KgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB1bmxvY2tf
cGFnZShwYWdlKTsKPiA+IAo+IAo+IFN1cmUsIGJ1dCB3aGVuIEkgdGhpbmsgbW9yZSBhYm91dCB0
aGlzLCBpdCBzZWVtcyB0aGlzIGZpeCBpc24ndAo+IGlkZWFsOgo+IElmIFZNX0ZBVUxUX05PUEFH
RSBpcyByZXR1cm5lZCB3aXRoIHBhZ2UgdGFibGUgdW5zZXQsIHRoZSBwcm9jZXNzCj4gd2lsbAo+
IHJlLXRyaWdnZXIgcGFnZSBmYXVsdCBhZ2FpbiBhbmQgYWdhaW4gdW50aWwgaW52YWxpZGF0ZV9p
bm9kZV9wYWdlCj4gc3VjY2VlZHMKPiB0byBldmljdCB0aGUgaW5vZGUgcGFnZS4gVGhpcyBtaWdo
dCBoYW5nIHRoZSBwcm9jZXNzIGEgcmVhbGx5IGxvbmcKPiB0aW1lLgo+IE9yIGFtIEkgbWlzcyBz
b21ldGhpbmc/Cj4gCklmIGludmFsaWRhdGVfaW5vZGVfcGFnZSBmYWlscywgd2Ugd2lsbCByZXR1
cm4KVk1fRkFVTFRfSFdQT0lTT04sIGFuZCBraWxsIHRoZSB0YXNrLCBpbnN0ZWFkCm9mIGxvb3Bp
bmcgaW5kZWZpbml0ZWx5LgoKLS0gCkFsbCBSaWdodHMgUmV2ZXJzZWQuCg==


--=-gw9OjvNiSuMBA33y3aoL
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEKR73pCCtJ5Xj3yADznnekoTE3oMFAmJBHEgACgkQznnekoTE
3oNcpAf7B7Uo3qImByKvNkKrLOo3TC12TjfsY/K4fZu0nUa0pGp3hxl2o+QFQuv7
jLirEcL92c7wOCcIZquB4pwGJa9+wTtvjqiB0VK5Gf7kertT7LE5DxXC/aWjt0ze
FIitaRbmRroEctSivbapWHYQxHomxQg9z4qNr9WJAgy+ySZokM/F+cG/Q3SWZKN3
dUUA7jOa8LvtGgf33Y29l+eAdUn1CsFyinASlwyTnVhp6R6Wx+yoqGU5e69sAAdn
HmpXv6GTdPeeWjd7VJ1lpn0PzIuOitD6c+Hz7ce/q1F+meHq+7waJmacw/jNLHY6
SCamQtrspIDd+BmzoqpY+RaUsEA/9w==
=sROm
-----END PGP SIGNATURE-----

--=-gw9OjvNiSuMBA33y3aoL--
