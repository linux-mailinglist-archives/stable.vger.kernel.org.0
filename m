Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED4FC695B14
	for <lists+stable@lfdr.de>; Tue, 14 Feb 2023 08:51:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231269AbjBNHvf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 02:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231406AbjBNHvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 02:51:13 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BB492069C;
        Mon, 13 Feb 2023 23:51:11 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D62FC20E88;
        Tue, 14 Feb 2023 07:51:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1676361069; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=59WLmwk/w22JF9sHJHSS4aoub+CRzVO8W2memNhS3Io=;
        b=ZM1ou+sZmB3tdCvuOCZ7vBoj/LGK7yKg5Z1FAIUR/BtMT50XZUuVtpclEwu14GFTqY0y1C
        GZ8+iM1iut34Cociirzm9i8zLRCR1g1tycKCECTZjVjIKKEvIrnsqJXAJjVE3dPhTQhUHH
        516ikATzwHXHgsUhDbrvL8o9wUd06Gg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9969A13A21;
        Tue, 14 Feb 2023 07:51:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id K3YiJG0962OdGwAAMHmgww
        (envelope-from <jgross@suse.com>); Tue, 14 Feb 2023 07:51:09 +0000
Message-ID: <763838a9-acd5-b330-6165-6c288973d51c@suse.com>
Date:   Tue, 14 Feb 2023 08:51:09 +0100
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
 <5fdc17c1-4222-aea2-c1d1-be8b15b7f523@suse.com> <Y+qlPYi20cP0yXnE@itl-email>
From:   Juergen Gross <jgross@suse.com>
Subject: Re: [PATCH] xen: speed up grant-table reclaim
In-Reply-To: <Y+qlPYi20cP0yXnE@itl-email>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------lY03vSGRGRiVjwOo0Dl8sT1u"
X-Spam-Status: No, score=-4.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------lY03vSGRGRiVjwOo0Dl8sT1u
Content-Type: multipart/mixed; boundary="------------0awnHpg016kUQAzmDWn7XD0W";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: Demi Marie Obenour <demi@invisiblethingslab.com>,
 Stefano Stabellini <sstabellini@kernel.org>,
 Oleksandr Tyshchenko <oleksandr_tyshchenko@epam.com>
Cc: =?UTF-8?Q?Marek_Marczykowski-G=c3=b3recki?=
 <marmarek@invisiblethingslab.com>, xen-devel@lists.xenproject.org,
 linux-kernel@vger.kernel.org, stable@vger.kernel.org
Message-ID: <763838a9-acd5-b330-6165-6c288973d51c@suse.com>
Subject: Re: [PATCH] xen: speed up grant-table reclaim
References: <20230207021033.1797-1-demi@invisiblethingslab.com>
 <5fdc17c1-4222-aea2-c1d1-be8b15b7f523@suse.com> <Y+qlPYi20cP0yXnE@itl-email>
In-Reply-To: <Y+qlPYi20cP0yXnE@itl-email>

--------------0awnHpg016kUQAzmDWn7XD0W
Content-Type: multipart/mixed; boundary="------------wNudRiZ2q9tWgKA01XjPCkif"

--------------wNudRiZ2q9tWgKA01XjPCkif
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTMuMDIuMjMgMjI6MDEsIERlbWkgTWFyaWUgT2Jlbm91ciB3cm90ZToNCj4gT24gTW9u
LCBGZWIgMTMsIDIwMjMgYXQgMTA6MjY6MTFBTSArMDEwMCwgSnVlcmdlbiBHcm9zcyB3cm90
ZToNCj4+IE9uIDA3LjAyLjIzIDAzOjEwLCBEZW1pIE1hcmllIE9iZW5vdXIgd3JvdGU6DQo+
Pj4gV2hlbiBhIGdyYW50IGVudHJ5IGlzIHN0aWxsIGluIHVzZSBieSB0aGUgcmVtb3RlIGRv
bWFpbiwgTGludXggbXVzdCBwdXQNCj4+PiBpdCBvbiBhIGRlZmVycmVkIGxpc3QuICBOb3Jt
YWxseSwgdGhpcyBsaXN0IGlzIHZlcnkgc2hvcnQsIGJlY2F1c2UNCj4+PiB0aGUgUFYgbmV0
d29yayBhbmQgYmxvY2sgcHJvdG9jb2xzIGV4cGVjdCB0aGUgYmFja2VuZCB0byB1bm1hcCB0
aGUgZ3JhbnQNCj4+PiBmaXJzdC4gIEhvd2V2ZXIsIFF1YmVzIE9TJ3MgR1VJIHByb3RvY29s
IGlzIHN1YmplY3QgdG8gdGhlIGNvbnN0cmFpbnRzDQo+Pj4gb2YgdGhlIFggV2luZG93IFN5
c3RlbSwgYW5kIGFzIHN1Y2ggd2luZHMgdXAgd2l0aCB0aGUgZnJvbnRlbmQgdW5tYXBwaW5n
DQo+Pj4gdGhlIHdpbmRvdyBmaXJzdC4gIEFzIGEgcmVzdWx0LCB0aGUgbGlzdCBjYW4gZ3Jv
dyB2ZXJ5IGxhcmdlLCByZXN1bHRpbmcNCj4+PiBpbiBhIG1hc3NpdmUgbWVtb3J5IGxlYWsg
YW5kIGV2ZW50dWFsIFZNIGZyZWV6ZS4NCj4+Pg0KPj4+IEZpeCB0aGlzIHByb2JsZW0gYnkg
YnVtcGluZyB0aGUgbnVtYmVyIG9mIGVudHJpZXMgdGhhdCB0aGUgVk0gd2lsbA0KPj4+IGF0
dGVtcHQgdG8gZnJlZSBhdCBlYWNoIGl0ZXJhdGlvbiB0byAxMDAwMC4gIFRoaXMgaXMgYW4g
dWdseSBoYWNrIHRoYXQNCj4+PiBtYXkgd2VsbCBtYWtlIGEgZGVuaWFsIG9mIHNlcnZpY2Ug
ZWFzaWVyLCBidXQgZm9yIFF1YmVzIE9TIHRoYXQgaXMgbGVzcw0KPj4+IGJhZCB0aGFuIHRo
ZSBwcm9ibGVtIFF1YmVzIE9TIHVzZXJzIGFyZSBmYWNpbmcgdG9kYXkuDQo+Pg0KPj4+IFRo
ZXJlIHJlYWxseQ0KPj4+IG5lZWRzIHRvIGJlIGEgd2F5IGZvciBhIGZyb250ZW5kIHRvIGJl
IG5vdGlmaWVkIHdoZW4gdGhlIGJhY2tlbmQgaGFzDQo+Pj4gdW5tYXBwZWQgdGhlIGdyYW50
cy4NCj4+DQo+PiBQbGVhc2UgcmVtb3ZlIHRoaXMgc2VudGVuY2UgZnJvbSB0aGUgY29tbWl0
IG1lc3NhZ2UsIG9yIG1vdmUgaXQgYmVsb3cgdGhlDQo+PiAiLS0tIiBtYXJrZXIuDQo+IA0K
PiBXaWxsIGZpeCBpbiB2Mi4NCj4gDQo+PiBUaGVyZSBhcmUgc3RpbGwgc29tZSBmbGFnIGJp
dHMgdW5hbGxvY2F0ZWQgaW4gc3RydWN0IGdyYW50X2VudHJ5X3YxIG9yDQo+PiBzdHJ1Y3Qg
Z3JhbnRfZW50cnlfaGVhZGVyLiBZb3UgY291bGQgc3VnZ2VzdCBzb21lIHBhdGNoZXMgZm9y
IFhlbiB0byB1c2UNCj4+IG9uZSBvZiB0aGUgYml0cyBhcyBhIG1hcmtlciB0byBnZXQgYW4g
ZXZlbnQgZnJvbSB0aGUgaHlwZXJ2aXNvciBpZiBhDQo+PiBncmFudCB3aXRoIHN1Y2ggYSBi
aXQgc2V0IGhhcyBiZWVuIHVubWFwcGVkLg0KPiANCj4gVGhhdCBpcyBpbmRlZWQgYSBnb29k
IGlkZWEuICBUaGVyZSBhcmUgb3RoZXIgcHJvYmxlbXMgd2l0aCB0aGUgZ3JhbnQNCj4gaW50
ZXJmYWNlIGFzIHdlbGwsIGJ1dCB0aG9zZSBjYW4gYmUgZGVhbHQgd2l0aCBsYXRlci4NCj4g
DQo+PiBJIGhhdmUgbm8gaWRlYSwgd2hldGhlciBzdWNoIGFuIGludGVyZmFjZSB3b3VsZCBi
ZSBhY2NlcHRlZCBieSB0aGUNCj4+IG1haW50YWluZXJzLCB0aG91Z2guDQo+Pg0KPj4+IEFk
ZGl0aW9uYWxseSwgYSBtb2R1bGUgcGFyYW1ldGVyIGlzIHByb3ZpZGVkIHRvDQo+Pj4gYWxs
b3cgdHVuaW5nIHRoZSByZWNsYWltIHNwZWVkLg0KPj4+DQo+Pj4gVGhlIGNvZGUgcHJldmlv
dXNseSB1c2VkIHByaW50ayhLRVJOX0RFQlVHKSB3aGVuZXZlciBpdCBoYWQgdG8gZGVmZXIN
Cj4+PiByZWNsYWltaW5nIGEgcGFnZSBiZWNhdXNlIHRoZSBncmFudCB3YXMgc3RpbGwgbWFw
cGVkLiAgVGhpcyByZXN1bHRlZCBpbg0KPj4+IGEgbGFyZ2Ugdm9sdW1lIG9mIGxvZyBtZXNz
YWdlcyB0aGF0IGJvdGhlcmVkIHVzZXJzLiAgVXNlIHByX2RlYnVnDQo+Pj4gaW5zdGVhZCwg
d2hpY2ggc3VwcHJlc3NlcyB0aGUgbWVzc2FnZXMgYnkgZGVmYXVsdC4gIERldmVsb3BlcnMg
Y2FuDQo+Pj4gZW5hYmxlIHRoZW0gdXNpbmcgdGhlIGR5bmFtaWMgZGVidWcgbWVjaGFuaXNt
Lg0KPj4+DQo+Pj4gRml4ZXM6IFF1YmVzT1MvcXViZXMtaXNzdWVzIzc0MTAgKG1lbW9yeSBs
ZWFrKQ0KPj4+IEZpeGVzOiBRdWJlc09TL3F1YmVzLWlzc3VlcyM3MzU5IChleGNlc3NpdmUg
bG9nZ2luZykNCj4+PiBGaXhlczogNTY5Y2E1YjNmOTRjICgieGVuL2dudHRhYjogYWRkIGRl
ZmVycmVkIGZyZWVpbmcgbG9naWMiKQ0KPj4+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3Jn
DQo+Pj4gU2lnbmVkLW9mZi1ieTogRGVtaSBNYXJpZSBPYmVub3VyIDxkZW1pQGludmlzaWJs
ZXRoaW5nc2xhYi5jb20+DQo+Pj4gLS0tDQo+Pj4gQW55b25lIGhhdmUgc3VnZ2VzdGlvbnMg
Zm9yIGltcHJvdmluZyB0aGUgZ3JhbnQgbWVjaGFuaXNtPyAgQXJnbyBpc24ndA0KPj4+IGEg
Z29vZCBvcHRpb24sIGFzIGluIHRoZSBHVUkgcHJvdG9jb2wgdGhlcmUgYXJlIHN1YnN0YW50
aWFsIHBlcmZvcm1hbmNlDQo+Pj4gd2lucyB0byBiZSBoYWQgYnkgdXNpbmcgdHJ1ZSBzaGFy
ZWQgbWVtb3J5LiAgUmVzZW5kaW5nIGFzIEkgZm9yZ290IHRoZQ0KPj4+IFNpZ25lZC1vZmYt
Ynkgb24gdGhlIGZpcnN0IHN1Ym1pc3Npb24uICBTb3JyeSBhYm91dCB0aGF0Lg0KPj4+DQo+
Pj4gICAgZHJpdmVycy94ZW4vZ3JhbnQtdGFibGUuYyB8IDIgKy0NCj4+PiAgICAxIGZpbGUg
Y2hhbmdlZCwgMSBpbnNlcnRpb24oKyksIDEgZGVsZXRpb24oLSkNCj4+Pg0KPj4+IGRpZmYg
LS1naXQgYS9kcml2ZXJzL3hlbi9ncmFudC10YWJsZS5jIGIvZHJpdmVycy94ZW4vZ3JhbnQt
dGFibGUuYw0KPj4+IGluZGV4IDVjODNkNDEuLjJjMmZhYTcgMTAwNjQ0DQo+Pj4gLS0tIGEv
ZHJpdmVycy94ZW4vZ3JhbnQtdGFibGUuYw0KPj4+ICsrKyBiL2RyaXZlcnMveGVuL2dyYW50
LXRhYmxlLmMNCj4+PiBAQCAtMzU1LDE0ICszNTUsMjAgQEANCj4+PiAgICBzdGF0aWMgdm9p
ZCBnbnR0YWJfaGFuZGxlX2RlZmVycmVkKHN0cnVjdCB0aW1lcl9saXN0ICopOw0KPj4+ICAg
IHN0YXRpYyBERUZJTkVfVElNRVIoZGVmZXJyZWRfdGltZXIsIGdudHRhYl9oYW5kbGVfZGVm
ZXJyZWQpOw0KPj4+ICtzdGF0aWMgYXRvbWljNjRfdCBkZWZlcnJlZF9jb3VudDsNCj4+PiAr
c3RhdGljIGF0b21pYzY0X3QgbGVha2VkX2NvdW50Ow0KPj4+ICtzdGF0aWMgdW5zaWduZWQg
aW50IGZyZWVfcGVyX2l0ZXJhdGlvbiA9IDEwMDAwOw0KPj4NCj4+IEFzIHlvdSBhcmUgYWRk
aW5nIGEga2VybmVsIHBhcmFtZXRlciB0byBjaGFuZ2UgdGhpcyB2YWx1ZSwgcGxlYXNlIHNl
dCB0aGUNCj4+IGRlZmF1bHQgdG8gYSB2YWx1ZSBub3QgcG90ZW50aWFsbHkgY2F1c2luZyBh
bnkgRG9TIHByb2JsZW1zLiBRdWJlcyBPUyBjYW4NCj4+IHN0aWxsIHVzZSBhIGhpZ2hlciB2
YWx1ZSB0aGVuLg0KPiANCj4gRG8geW91IGhhdmUgYW55IHN1Z2dlc3Rpb25zPyAgSSBkb27i
gJl0IGtub3cgaWYgdGhpcyBpcyBhY3R1YWxseSBhIERvUw0KPiBjb25jZXJuIGFueW1vcmUu
ICBTaHJpbmtpbmcgdGhlIGludGVydmFsIGJldHdlZW4gaXRlcmF0aW9ucyB3b3VsZCBiZS4N
Cg0KV2h5IGRvbid0IHlvdSB1c2UgdG9kYXkncyB2YWx1ZSBvZiAxMCBmb3IgdGhlIGRlZmF1
bHQ/DQoNCj4gDQo+Pj4gKw0KPj4+ICAgIHN0YXRpYyB2b2lkIGdudHRhYl9oYW5kbGVfZGVm
ZXJyZWQoc3RydWN0IHRpbWVyX2xpc3QgKnVudXNlZCkNCj4+PiAgICB7DQo+Pj4gLQl1bnNp
Z25lZCBpbnQgbnIgPSAxMDsNCj4+PiArCXVuc2lnbmVkIGludCBuciA9IFJFQURfT05DRShm
cmVlX3Blcl9pdGVyYXRpb24pOw0KPj4NCj4+IEkgZG9uJ3Qgc2VlIHdoeSB5b3UgYXJlIG5l
ZWRpbmcgUkVBRF9PTkNFKCkgaGVyZS4NCj4gDQo+IGZyZWVfcGVyX2l0ZXJhdGlvbiBjYW4g
YmUgY29uY3VycmVudGx5IG1vZGlmaWVkIHZpYSBzeXNmcy4NCg0KTXkgcmVtYXJrIHdhcyBi
YXNlZCBvbiB0aGUgd3JvbmcgYXNzdW1wdGlvbiB0aGF0IGlnbm9yZV9saW1pdCBjb3VsZCBi
ZQ0KZHJvcHBlZC4NCg0KPiANCj4+PiArCWNvbnN0IGJvb2wgaWdub3JlX2xpbWl0ID0gbnIg
PT0gMDsNCj4+DQo+PiBJIGRvbid0IHRoaW5rIHlvdSBuZWVkIHRoaXMgZXh0cmEgdmFyaWFi
bGUsIGlmIHlvdSB3b3VsZCAuLi4NCj4+DQo+Pj4gICAgCXN0cnVjdCBkZWZlcnJlZF9lbnRy
eSAqZmlyc3QgPSBOVUxMOw0KPj4+ICAgIAl1bnNpZ25lZCBsb25nIGZsYWdzOw0KPj4+ICsJ
c2l6ZV90IGZyZWVkID0gMDsNCj4+PiAgICAJc3Bpbl9sb2NrX2lycXNhdmUoJmdudHRhYl9s
aXN0X2xvY2ssIGZsYWdzKTsNCj4+PiAtCXdoaWxlIChuci0tKSB7DQo+Pj4gKwl3aGlsZSAo
KGlnbm9yZV9saW1pdCB8fCBuci0tKSAmJiAhbGlzdF9lbXB0eSgmZGVmZXJyZWRfbGlzdCkp
IHsNCj4+DQo+PiAuLi4gY2hhbmdlIHRoaXMgdG8gIndoaWxlICgoIW5yIHx8IG5yLS0pIC4u
LiIuDQo+IA0KPiBuci0tIGV2YWx1YXRlcyB0byB0aGUgb2xkIHZhbHVlIG9mIG5yLCBzbyAi
d2hpbGUgKCghbnIgfCBuci0tKSkgLi4uIiBpcw0KPiBhbiBpbmZpbml0ZSBsb29wLg0KDQpB
aCwgcmlnaHQuDQoNCg0KSnVlcmdlbg0K
--------------wNudRiZ2q9tWgKA01XjPCkif
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------wNudRiZ2q9tWgKA01XjPCkif--

--------------0awnHpg016kUQAzmDWn7XD0W--

--------------lY03vSGRGRiVjwOo0Dl8sT1u
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmPrPW0FAwAAAAAACgkQsN6d1ii/Ey/C
TAgAhxZVaExyeIg13ffZ9exlJPa/BeESqo4dgpaot8Oc7w8/cYA2s1CV1qDT48wPqiJpWr7zVOC0
uODWlsHtgYT9xMcG6YbeiSMmJcu8rqqDB5Tzh4CRvkdmXxkrDaTjeQtbvGVIgPvxfNWkXV8zldHG
zq5wxk7o7C8BfGxaDEl0yANphvKTH9AVANxBJZ5HD0PzKxdCWUHPQ6+GYJ1i47Wbyh3cijDD7Ksv
p0j4ZZiAzDgAhe6WxMyVIq1xCVVl3J+mY+DujNwMnK2VuEo/MREP+NTI/OGJJzw4ggNLQvP6KKsm
8WKlU2SYWoXcwH+z50Ic5udp1VztCd4NS6L/t60jWg==
=q9pF
-----END PGP SIGNATURE-----

--------------lY03vSGRGRiVjwOo0Dl8sT1u--
