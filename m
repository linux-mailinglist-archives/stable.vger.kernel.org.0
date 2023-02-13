Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0008769411E
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 10:29:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230106AbjBMJ3h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 04:29:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230281AbjBMJ3L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 04:29:11 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DC3A16323;
        Mon, 13 Feb 2023 01:27:16 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B545C1F45A;
        Mon, 13 Feb 2023 09:26:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1676280372; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=r2sjVhfd+q+uojrYtYYnj4aMFGOfssTh5v0PLQIcmB4=;
        b=tTQfAx5sxWPZimQPUVaHfWUwwg2dC0Rxj/R5qx5jFRit+89Exg33Kalc/uVbBB1xlQA2Iw
        1iik1Ri0GTbkck5hpoyJjhzj+8pKTsKO8hU7AkvSaq9EjkkiFhsl4B04EpI3yzdF2wWGMG
        4DnkOHGcZZ5p3AUf8s99mvSC1GgndtA=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 791121391B;
        Mon, 13 Feb 2023 09:26:12 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2WXBGDQC6mPaWQAAMHmgww
        (envelope-from <jgross@suse.com>); Mon, 13 Feb 2023 09:26:12 +0000
Message-ID: <5fdc17c1-4222-aea2-c1d1-be8b15b7f523@suse.com>
Date:   Mon, 13 Feb 2023 10:26:11 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Content-Language: en-US
To:     Demi Marie Obenour <demi@invisiblethingslab.com>,
        Stefano Stabellini <sstabellini@kernel.org>,
        Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc:     =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?= 
        <marmarek@invisiblethingslab.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
References: <20230207021033.1797-1-demi@invisiblethingslab.com>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen: speed up grant-table reclaim
In-Reply-To: <20230207021033.1797-1-demi@invisiblethingslab.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------YR0M9lrsKJ1khWzPs4cz0bCG"
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------YR0M9lrsKJ1khWzPs4cz0bCG
Content-Type: multipart/mixed; boundary="------------WXAnykrIV00daOHG6Z0mg2gk";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
 <marmarek@invisiblethingslab.com>, xen-devel@lists.xenproject.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-ID: <5fdc17c1-4222-aea2-c1d1-be8b15b7f523@suse.com>
Subject: Re: [PATCH] xen: speed up grant-table reclaim
References: <20230207021033.1797-1-demi@invisiblethingslab.com>
In-Reply-To: <20230207021033.1797-1-demi@invisiblethingslab.com>

--------------WXAnykrIV00daOHG6Z0mg2gk
Content-Type: multipart/mixed; boundary="------------iH8yr0Lb8F8zxF095ePwpBum"

--------------iH8yr0Lb8F8zxF095ePwpBum
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMDcuMDIuMjMgMDM6MTAsIERlbWkgTWFyaWUgT2Jlbm91ciB3cm90ZToNCj4gV2hlbiBh
IGdyYW50IGVudHJ5IGlzIHN0aWxsIGluIHVzZSBieSB0aGUgcmVtb3RlIGRvbWFpbiwgTGlu
dXggbXVzdCBwdXQNCj4gaXQgb24gYSBkZWZlcnJlZCBsaXN0LiAgTm9ybWFsbHksIHRoaXMg
bGlzdCBpcyB2ZXJ5IHNob3J0LCBiZWNhdXNlDQo+IHRoZSBQViBuZXR3b3JrIGFuZCBibG9j
ayBwcm90b2NvbHMgZXhwZWN0IHRoZSBiYWNrZW5kIHRvIHVubWFwIHRoZSBncmFudA0KPiBm
aXJzdC4gIEhvd2V2ZXIsIFF1YmVzIE9TJ3MgR1VJIHByb3RvY29sIGlzIHN1YmplY3QgdG8g
dGhlIGNvbnN0cmFpbnRzDQo+IG9mIHRoZSBYIFdpbmRvdyBTeXN0ZW0sIGFuZCBhcyBzdWNo
IHdpbmRzIHVwIHdpdGggdGhlIGZyb250ZW5kIHVubWFwcGluZw0KPiB0aGUgd2luZG93IGZp
cnN0LiAgQXMgYSByZXN1bHQsIHRoZSBsaXN0IGNhbiBncm93IHZlcnkgbGFyZ2UsIHJlc3Vs
dGluZw0KPiBpbiBhIG1hc3NpdmUgbWVtb3J5IGxlYWsgYW5kIGV2ZW50dWFsIFZNIGZyZWV6
ZS4NCj4gDQo+IEZpeCB0aGlzIHByb2JsZW0gYnkgYnVtcGluZyB0aGUgbnVtYmVyIG9mIGVu
dHJpZXMgdGhhdCB0aGUgVk0gd2lsbA0KPiBhdHRlbXB0IHRvIGZyZWUgYXQgZWFjaCBpdGVy
YXRpb24gdG8gMTAwMDAuICBUaGlzIGlzIGFuIHVnbHkgaGFjayB0aGF0DQo+IG1heSB3ZWxs
IG1ha2UgYSBkZW5pYWwgb2Ygc2VydmljZSBlYXNpZXIsIGJ1dCBmb3IgUXViZXMgT1MgdGhh
dCBpcyBsZXNzDQo+IGJhZCB0aGFuIHRoZSBwcm9ibGVtIFF1YmVzIE9TIHVzZXJzIGFyZSBm
YWNpbmcgdG9kYXkuDQoNCj4gVGhlcmUgcmVhbGx5DQo+IG5lZWRzIHRvIGJlIGEgd2F5IGZv
ciBhIGZyb250ZW5kIHRvIGJlIG5vdGlmaWVkIHdoZW4gdGhlIGJhY2tlbmQgaGFzDQo+IHVu
bWFwcGVkIHRoZSBncmFudHMuDQoNClBsZWFzZSByZW1vdmUgdGhpcyBzZW50ZW5jZSBmcm9t
IHRoZSBjb21taXQgbWVzc2FnZSwgb3IgbW92ZSBpdCBiZWxvdyB0aGUNCiItLS0iIG1hcmtl
ci4NCg0KVGhlcmUgYXJlIHN0aWxsIHNvbWUgZmxhZyBiaXRzIHVuYWxsb2NhdGVkIGluIHN0
cnVjdCBncmFudF9lbnRyeV92MSBvcg0Kc3RydWN0IGdyYW50X2VudHJ5X2hlYWRlci4gWW91
IGNvdWxkIHN1Z2dlc3Qgc29tZSBwYXRjaGVzIGZvciBYZW4gdG8gdXNlDQpvbmUgb2YgdGhl
IGJpdHMgYXMgYSBtYXJrZXIgdG8gZ2V0IGFuIGV2ZW50IGZyb20gdGhlIGh5cGVydmlzb3Ig
aWYgYQ0KZ3JhbnQgd2l0aCBzdWNoIGEgYml0IHNldCBoYXMgYmVlbiB1bm1hcHBlZC4NCg0K
SSBoYXZlIG5vIGlkZWEsIHdoZXRoZXIgc3VjaCBhbiBpbnRlcmZhY2Ugd291bGQgYmUgYWNj
ZXB0ZWQgYnkgdGhlDQptYWludGFpbmVycywgdGhvdWdoLg0KDQo+IEFkZGl0aW9uYWxseSwg
YSBtb2R1bGUgcGFyYW1ldGVyIGlzIHByb3ZpZGVkIHRvDQo+IGFsbG93IHR1bmluZyB0aGUg
cmVjbGFpbSBzcGVlZC4NCj4gDQo+IFRoZSBjb2RlIHByZXZpb3VzbHkgdXNlZCBwcmludGso
S0VSTl9ERUJVRykgd2hlbmV2ZXIgaXQgaGFkIHRvIGRlZmVyDQo+IHJlY2xhaW1pbmcgYSBw
YWdlIGJlY2F1c2UgdGhlIGdyYW50IHdhcyBzdGlsbCBtYXBwZWQuICBUaGlzIHJlc3VsdGVk
IGluDQo+IGEgbGFyZ2Ugdm9sdW1lIG9mIGxvZyBtZXNzYWdlcyB0aGF0IGJvdGhlcmVkIHVz
ZXJzLiAgVXNlIHByX2RlYnVnDQo+IGluc3RlYWQsIHdoaWNoIHN1cHByZXNzZXMgdGhlIG1l
c3NhZ2VzIGJ5IGRlZmF1bHQuICBEZXZlbG9wZXJzIGNhbg0KPiBlbmFibGUgdGhlbSB1c2lu
ZyB0aGUgZHluYW1pYyBkZWJ1ZyBtZWNoYW5pc20uDQo+IA0KPiBGaXhlczogUXViZXNPUy9x
dWJlcy1pc3N1ZXMjNzQxMCAobWVtb3J5IGxlYWspDQo+IEZpeGVzOiBRdWJlc09TL3F1YmVz
LWlzc3VlcyM3MzU5IChleGNlc3NpdmUgbG9nZ2luZykNCj4gRml4ZXM6IDU2OWNhNWIzZjk0
YyAoInhlbi9nbnR0YWI6IGFkZCBkZWZlcnJlZCBmcmVlaW5nIGxvZ2ljIikNCj4gQ2M6IHN0
YWJsZUB2Z2VyLmtlcm5lbC5vcmcNCj4gU2lnbmVkLW9mZi1ieTogRGVtaSBNYXJpZSBPYmVu
b3VyIDxkZW1pQGludmlzaWJsZXRoaW5nc2xhYi5jb20+DQo+IC0tLQ0KPiBBbnlvbmUgaGF2
ZSBzdWdnZXN0aW9ucyBmb3IgaW1wcm92aW5nIHRoZSBncmFudCBtZWNoYW5pc20/ICBBcmdv
IGlzbid0DQo+IGEgZ29vZCBvcHRpb24sIGFzIGluIHRoZSBHVUkgcHJvdG9jb2wgdGhlcmUg
YXJlIHN1YnN0YW50aWFsIHBlcmZvcm1hbmNlDQo+IHdpbnMgdG8gYmUgaGFkIGJ5IHVzaW5n
IHRydWUgc2hhcmVkIG1lbW9yeS4gIFJlc2VuZGluZyBhcyBJIGZvcmdvdCB0aGUNCj4gU2ln
bmVkLW9mZi1ieSBvbiB0aGUgZmlyc3Qgc3VibWlzc2lvbi4gIFNvcnJ5IGFib3V0IHRoYXQu
DQo+IA0KPiAgIGRyaXZlcnMveGVuL2dyYW50LXRhYmxlLmMgfCAyICstDQo+ICAgMSBmaWxl
IGNoYW5nZWQsIDEgaW5zZXJ0aW9uKCspLCAxIGRlbGV0aW9uKC0pDQo+IA0KPiBkaWZmIC0t
Z2l0IGEvZHJpdmVycy94ZW4vZ3JhbnQtdGFibGUuYyBiL2RyaXZlcnMveGVuL2dyYW50LXRh
YmxlLmMNCj4gaW5kZXggNWM4M2Q0MS4uMmMyZmFhNyAxMDA2NDQNCj4gLS0tIGEvZHJpdmVy
cy94ZW4vZ3JhbnQtdGFibGUuYw0KPiArKysgYi9kcml2ZXJzL3hlbi9ncmFudC10YWJsZS5j
DQo+IEBAIC0zNTUsMTQgKzM1NSwyMCBAQA0KPiAgIHN0YXRpYyB2b2lkIGdudHRhYl9oYW5k
bGVfZGVmZXJyZWQoc3RydWN0IHRpbWVyX2xpc3QgKik7DQo+ICAgc3RhdGljIERFRklORV9U
SU1FUihkZWZlcnJlZF90aW1lciwgZ250dGFiX2hhbmRsZV9kZWZlcnJlZCk7DQo+ICAgDQo+
ICtzdGF0aWMgYXRvbWljNjRfdCBkZWZlcnJlZF9jb3VudDsNCj4gK3N0YXRpYyBhdG9taWM2
NF90IGxlYWtlZF9jb3VudDsNCj4gK3N0YXRpYyB1bnNpZ25lZCBpbnQgZnJlZV9wZXJfaXRl
cmF0aW9uID0gMTAwMDA7DQoNCkFzIHlvdSBhcmUgYWRkaW5nIGEga2VybmVsIHBhcmFtZXRl
ciB0byBjaGFuZ2UgdGhpcyB2YWx1ZSwgcGxlYXNlIHNldCB0aGUNCmRlZmF1bHQgdG8gYSB2
YWx1ZSBub3QgcG90ZW50aWFsbHkgY2F1c2luZyBhbnkgRG9TIHByb2JsZW1zLiBRdWJlcyBP
UyBjYW4NCnN0aWxsIHVzZSBhIGhpZ2hlciB2YWx1ZSB0aGVuLg0KDQo+ICsNCj4gICBzdGF0
aWMgdm9pZCBnbnR0YWJfaGFuZGxlX2RlZmVycmVkKHN0cnVjdCB0aW1lcl9saXN0ICp1bnVz
ZWQpDQo+ICAgew0KPiAtCXVuc2lnbmVkIGludCBuciA9IDEwOw0KPiArCXVuc2lnbmVkIGlu
dCBuciA9IFJFQURfT05DRShmcmVlX3Blcl9pdGVyYXRpb24pOw0KDQpJIGRvbid0IHNlZSB3
aHkgeW91IGFyZSBuZWVkaW5nIFJFQURfT05DRSgpIGhlcmUuDQoNCj4gKwljb25zdCBib29s
IGlnbm9yZV9saW1pdCA9IG5yID09IDA7DQoNCkkgZG9uJ3QgdGhpbmsgeW91IG5lZWQgdGhp
cyBleHRyYSB2YXJpYWJsZSwgaWYgeW91IHdvdWxkIC4uLg0KDQo+ICAgCXN0cnVjdCBkZWZl
cnJlZF9lbnRyeSAqZmlyc3QgPSBOVUxMOw0KPiAgIAl1bnNpZ25lZCBsb25nIGZsYWdzOw0K
PiArCXNpemVfdCBmcmVlZCA9IDA7DQo+ICAgDQo+ICAgCXNwaW5fbG9ja19pcnFzYXZlKCZn
bnR0YWJfbGlzdF9sb2NrLCBmbGFncyk7DQo+IC0Jd2hpbGUgKG5yLS0pIHsNCj4gKwl3aGls
ZSAoKGlnbm9yZV9saW1pdCB8fCBuci0tKSAmJiAhbGlzdF9lbXB0eSgmZGVmZXJyZWRfbGlz
dCkpIHsNCg0KLi4uIGNoYW5nZSB0aGlzIHRvICJ3aGlsZSAoKCFuciB8fCBuci0tKSAuLi4i
Lg0KDQo+ICAgCQlzdHJ1Y3QgZGVmZXJyZWRfZW50cnkgKmVudHJ5DQo+ICAgCQkJPSBsaXN0
X2ZpcnN0X2VudHJ5KCZkZWZlcnJlZF9saXN0LA0KPiAgIAkJCQkJICAgc3RydWN0IGRlZmVy
cmVkX2VudHJ5LCBsaXN0KTsNCj4gQEAgLTM3MiwxMCArMzc4LDEzIEBADQo+ICAgCQlsaXN0
X2RlbCgmZW50cnktPmxpc3QpOw0KPiAgIAkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZ250
dGFiX2xpc3RfbG9jaywgZmxhZ3MpOw0KPiAgIAkJaWYgKF9nbnR0YWJfZW5kX2ZvcmVpZ25f
YWNjZXNzX3JlZihlbnRyeS0+cmVmKSkgew0KPiArCQkJdWludDY0X3QgcmV0ID0gYXRvbWlj
NjRfc3ViX3JldHVybigxLCAmZGVmZXJyZWRfY291bnQpOw0KDQpVc2UgYXRvbWljNjRfZGVj
X3JldHVybigpPw0KDQo+ICAgCQkJcHV0X2ZyZWVfZW50cnkoZW50cnktPnJlZik7DQo+IC0J
CQlwcl9kZWJ1ZygiZnJlZWluZyBnLmUuICUjeCAocGZuICUjbHgpXG4iLA0KPiAtCQkJCSBl
bnRyeS0+cmVmLCBwYWdlX3RvX3BmbihlbnRyeS0+cGFnZSkpOw0KPiArCQkJcHJfZGVidWco
ImZyZWVpbmcgZy5lLiAlI3ggKHBmbiAlI2x4KSwgJWxsdSByZW1haW5pbmdcbiIsDQo+ICsJ
CQkJIGVudHJ5LT5yZWYsIHBhZ2VfdG9fcGZuKGVudHJ5LT5wYWdlKSwNCj4gKwkJCQkgKHVu
c2lnbmVkIGxvbmcgbG9uZylyZXQpOw0KDQpJcyBlYWNoIHNpbmdsZSBpbnN0YW5jZSBvZiB0
aGlzIG1lc3NhZ2UgcmVhbGx5IG5lZWRlZD8NCg0KSWYgbm90LCBJJ2Qgc3VnZ2VzdCB0byB1
c2UgcHJfZGVidWdfcmF0ZWxpbWl0ZWQoKSBpbnN0ZWFkLg0KDQo+ICAgCQkJcHV0X3BhZ2Uo
ZW50cnktPnBhZ2UpOw0KPiArCQkJZnJlZWQrKzsNCj4gICAJCQlrZnJlZShlbnRyeSk7DQo+
ICAgCQkJZW50cnkgPSBOVUxMOw0KPiAgIAkJfSBlbHNlIHsNCj4gQEAgLTM4NywxNCArMzk2
LDE1IEBADQo+ICAgCQlzcGluX2xvY2tfaXJxc2F2ZSgmZ250dGFiX2xpc3RfbG9jaywgZmxh
Z3MpOw0KPiAgIAkJaWYgKGVudHJ5KQ0KPiAgIAkJCWxpc3RfYWRkX3RhaWwoJmVudHJ5LT5s
aXN0LCAmZGVmZXJyZWRfbGlzdCk7DQo+IC0JCWVsc2UgaWYgKGxpc3RfZW1wdHkoJmRlZmVy
cmVkX2xpc3QpKQ0KPiAtCQkJYnJlYWs7DQo+ICAgCX0NCj4gLQlpZiAoIWxpc3RfZW1wdHko
JmRlZmVycmVkX2xpc3QpICYmICF0aW1lcl9wZW5kaW5nKCZkZWZlcnJlZF90aW1lcikpIHsN
Cj4gKwlpZiAobGlzdF9lbXB0eSgmZGVmZXJyZWRfbGlzdCkpDQo+ICsJCVdBUk5fT04oYXRv
bWljNjRfcmVhZCgmZGVmZXJyZWRfY291bnQpKTsNCj4gKwllbHNlIGlmICghdGltZXJfcGVu
ZGluZygmZGVmZXJyZWRfdGltZXIpKSB7DQo+ICAgCQlkZWZlcnJlZF90aW1lci5leHBpcmVz
ID0gamlmZmllcyArIEhaOw0KPiAgIAkJYWRkX3RpbWVyKCZkZWZlcnJlZF90aW1lcik7DQo+
ICAgCX0NCj4gICAJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZ250dGFiX2xpc3RfbG9jaywg
ZmxhZ3MpOw0KPiArCXByX2RlYnVnKCJGcmVlZCAlenUgcmVmZXJlbmNlcyIsIGZyZWVkKTsN
Cj4gICB9DQo+ICAgDQo+ICAgc3RhdGljIHZvaWQgZ250dGFiX2FkZF9kZWZlcnJlZChncmFu
dF9yZWZfdCByZWYsIHN0cnVjdCBwYWdlICpwYWdlKQ0KPiBAQCAtNDAyLDcgKzQxMiw3IEBA
DQo+ICAgew0KPiAgIAlzdHJ1Y3QgZGVmZXJyZWRfZW50cnkgKmVudHJ5Ow0KPiAgIAlnZnBf
dCBnZnAgPSAoaW5fYXRvbWljKCkgfHwgaXJxc19kaXNhYmxlZCgpKSA/IEdGUF9BVE9NSUMg
OiBHRlBfS0VSTkVMOw0KPiAtCWNvbnN0IGNoYXIgKndoYXQgPSBLRVJOX1dBUk5JTkcgImxl
YWtpbmciOw0KPiArCXVpbnQ2NF90IGxlYWtlZCwgZGVmZXJyZWQ7DQo+ICAgDQo+ICAgCWVu
dHJ5ID0ga21hbGxvYyhzaXplb2YoKmVudHJ5KSwgZ2ZwKTsNCj4gICAJaWYgKCFwYWdlKSB7
DQo+IEBAIC00MjYsMTIgKzQzNiwyMCBAQA0KPiAgIAkJCWFkZF90aW1lcigmZGVmZXJyZWRf
dGltZXIpOw0KPiAgIAkJfQ0KPiAgIAkJc3Bpbl91bmxvY2tfaXJxcmVzdG9yZSgmZ250dGFi
X2xpc3RfbG9jaywgZmxhZ3MpOw0KPiAtCQl3aGF0ID0gS0VSTl9ERUJVRyAiZGVmZXJyaW5n
IjsNCj4gKwkJZGVmZXJyZWQgPSBhdG9taWM2NF9hZGRfcmV0dXJuKDEsICZkZWZlcnJlZF9j
b3VudCk7DQo+ICsJCWxlYWtlZCA9IGF0b21pYzY0X3JlYWQoJmxlYWtlZF9jb3VudCk7DQo+
ICsJCXByX2RlYnVnKCJkZWZlcnJpbmcgZy5lLiAlI3ggKHBmbiAlI2x4KSAodG90YWwgZGVm
ZXJyZWQgJWxsdSwgdG90YWwgbGVha2VkICVsbHUpXG4iLA0KPiArCQkJIHJlZiwgcGFnZSA/
IHBhZ2VfdG9fcGZuKHBhZ2UpIDogLTEsIGRlZmVycmVkLCBsZWFrZWQpOw0KPiArCX0gZWxz
ZSB7DQo+ICsJCWRlZmVycmVkID0gYXRvbWljNjRfcmVhZCgmZGVmZXJyZWRfY291bnQpOw0K
PiArCQlsZWFrZWQgPSBhdG9taWM2NF9hZGRfcmV0dXJuKDEsICZsZWFrZWRfY291bnQpOw0K
PiArCQlwcl93YXJuKCJsZWFraW5nIGcuZS4gJSN4IChwZm4gJSNseCkgKHRvdGFsIGRlZmVy
cmVkICVsbHUsIHRvdGFsIGxlYWtlZCAlbGx1KVxuIiwNCj4gKwkJCXJlZiwgcGFnZSA/IHBh
Z2VfdG9fcGZuKHBhZ2UpIDogLTEsIGRlZmVycmVkLCBsZWFrZWQpOw0KDQpBZ2FpbiwgbWF5
YmUgdXNlIHRoZSByYXRlbGltaXRlZCB2YXJpYW50cyBvZiBwcl9kZWJ1ZygpIGFuZCBwcl93
YXJuKCk/DQoNCj4gICAJfQ0KPiAtCXByaW50aygiJXMgZy5lLiAlI3ggKHBmbiAlI2x4KVxu
IiwNCj4gLQkgICAgICAgd2hhdCwgcmVmLCBwYWdlID8gcGFnZV90b19wZm4ocGFnZSkgOiAt
MSk7DQo+ICAgfQ0KPiAgIA0KPiArbW9kdWxlX3BhcmFtKGZyZWVfcGVyX2l0ZXJhdGlvbiwg
dWludCwgMDYwMCk7DQoNClBsZWFzZSBhZGQgdGhlIHBhcmFtZXRlciB0byBEb2N1bWVudGF0
aW9uL2FkbWluLWd1aWRlL2tlcm5lbC1wYXJhbWV0ZXJzLnR4dA0KDQoNCkp1ZXJnZW4NCg==

--------------iH8yr0Lb8F8zxF095ePwpBum
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------iH8yr0Lb8F8zxF095ePwpBum--

--------------WXAnykrIV00daOHG6Z0mg2gk--

--------------YR0M9lrsKJ1khWzPs4cz0bCG
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmPqAjMFAwAAAAAACgkQsN6d1ii/Ey/x
+gf+LnAvmmMI+yqrUxQkC16OHoy628JB3/HVUeD3B80HS7E9z8QAU5DQbtsaNtpWHjhS4DargVmz
Nl9zsPNobfmZVWUBukbvu7DI57jSlQ1+GNaZ/EbBJo02KSznfFQMCGMp6sMRq3ymFS4zY+d31sC3
UsmZqQITNfyqUX5YI6zVAyRbKzBRhWBo2m/L8iLAdQj5Xpx6+8ue/vAUIkVCgqwBp4M1191rReBx
tOxcL3EJWKlqlHd3cJfOtH3HlcIVsPlSnOQtEd0hMV+ZrCBBQmpKsc+eyhDR41mdoduHj3tHRMCe
7jWlbBcdfFLB3ty/roSEt6jLn3b40ntT5YaLyFoTww==
=tTEw
-----END PGP SIGNATURE-----

--------------YR0M9lrsKJ1khWzPs4cz0bCG--
