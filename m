Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63180493682
	for <lists+stable@lfdr.de>; Wed, 19 Jan 2022 09:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237155AbiASIpZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Jan 2022 03:45:25 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:53780 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235519AbiASIpY (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Jan 2022 03:45:24 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 6F62B2114D;
        Wed, 19 Jan 2022 08:45:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1642581923; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sbFeRO04i5HicC85tc8H7/BATdtI/nL6umLV4UIjyVc=;
        b=x4sgiWewpPWrSIbt1N3tbh4aWlkO9OATOJo9yb5YumMuayJO7bAqh9+G/WRXu4XMv2wz5j
        VBtMBgQnJHF4c2drAOsmj7THhpMzX2Uc8hVkKzUCO/W2i6wUswmh6ZbxS220JjnwwRN3mW
        8qM2wzL/vcqe2shx4jdE7pAP0K5hpXQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1642581923;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=sbFeRO04i5HicC85tc8H7/BATdtI/nL6umLV4UIjyVc=;
        b=Z0jM/KsBHpLyObToMr/EA7T1T7Fdm10LJj+Fj57BjKdB6C7oOJFJ9a9RwW+SjSbCHAye3F
        TBvIG/X6Lx2kF1Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 508D613B32;
        Wed, 19 Jan 2022 08:45:23 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OmyqEqPP52ErDgAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Wed, 19 Jan 2022 08:45:23 +0000
Message-ID: <899e2aae-f850-2b3b-f449-fa550dfbdf04@suse.de>
Date:   Wed, 19 Jan 2022 09:45:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
Content-Language: en-US
To:     Zack Rusin <zackr@vmware.com>, dri-devel@lists.freedesktop.org
Cc:     krastevm@vmware.com, stable@vger.kernel.org,
        mombasawalam@vmware.com
References: <20220117180359.18114-1-zack@kde.org>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <20220117180359.18114-1-zack@kde.org>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------jRxW9H7reAG78JF7eVvvI0M0"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------jRxW9H7reAG78JF7eVvvI0M0
Content-Type: multipart/mixed; boundary="------------zK5lCqNdTCi8UyNjvHWRetCJ";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Zack Rusin <zackr@vmware.com>, dri-devel@lists.freedesktop.org
Cc: krastevm@vmware.com, stable@vger.kernel.org, mombasawalam@vmware.com
Message-ID: <899e2aae-f850-2b3b-f449-fa550dfbdf04@suse.de>
Subject: Re: [PATCH] drm/vmwgfx: Stop requesting the pci regions
References: <20220117180359.18114-1-zack@kde.org>
In-Reply-To: <20220117180359.18114-1-zack@kde.org>

--------------zK5lCqNdTCi8UyNjvHWRetCJ
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkgWmFjaw0KDQpBbSAxNy4wMS4yMiB1bSAxOTowMyBzY2hyaWViIFphY2sgUnVzaW46DQo+
IEZyb206IFphY2sgUnVzaW4gPHphY2tyQHZtd2FyZS5jb20+DQo+IA0KPiBXaGVuIHN5c2Zi
X3NpbXBsZSBpcyBlbmFibGVkIGxvYWRpbmcgdm13Z2Z4IGZhaWxzIGJlY2F1c2UgdGhlIHJl
Z2lvbnMNCj4gYXJlIGhlbGQgYnkgdGhlIHBsYXRmb3JtLiBJbiB0aGF0IGNhc2UgcmVtb3Zl
X2NvbmZsaWN0aW5nKl9mcmFtZWJ1ZmZlcnMNCj4gb25seSByZW1vdmVzIHRoZSBzaW1wbGVm
YiBidXQgbm90IHRoZSByZWdpb25zIGhlbGQgYnkgc3lzZmIuDQoNCkkgZG9uJ3QgdW5kZXJz
dGFuZCB0aGlzIHNlbnRlbmNlLiBUaGVyZSdzIG9ubHkgb25lIG1lbW9yeSByZXNvdXJjZSAN
CmNsYWltZWQgYnkgdGhlIHN5c2ZiIGNvZGUuIFdoYXQgZWxzZSB3b3VsZCBibG9jayB2bXdn
Zng/DQoNCkkgYXBwZWFycyB0byBtZSBhcyBpZiBzaW1wbGVmYiBzaG91bGQgcmVsZWFzZSB0
aGUgcmVnaW9uIChvciB0aGUgDQpzaW1wbGUtZnJhbWVidWZmZXIgZGV2aWNlKS4NCg0Kc2lt
cGxlZHJtIGRvZXMgYSBob3QtdW5wbHVnIG9mIHRoZSBzaW1wbGUtZnJhbWVidWZmZXIsIHNv
IHRoZSByZWdpb24gDQpzaG91bGQgYmUgcmVsZWFzZWQgYWZ0ZXJ3YXJkcy4NCg0KQmVzdCBy
ZWdhcmQNClRob21hcw0KDQo+IA0KPiBMaWtlIHRoZSBvdGhlciBkcm0gZHJpdmVycyB3ZSBu
ZWVkIHRvIHN0b3AgcmVxdWVzdGluZyBhbGwgdGhlIHBjaSByZWdpb25zDQo+IHRvIGxldCB0
aGUgZHJpdmVyIGxvYWQgd2l0aCBwbGF0Zm9ybSBjb2RlIGVuYWJsZWQuDQo+IFRoaXMgYWxs
b3dzIHZtd2dmeCB0byBsb2FkIGNvcnJlY3RseSBvbiBzeXN0ZW1zIHdpdGggc3lzZmJfc2lt
cGxlIGVuYWJsZWQuDQo+IA0KPiBTaWduZWQtb2ZmLWJ5OiBaYWNrIFJ1c2luIDx6YWNrckB2
bXdhcmUuY29tPg0KPiBGaXhlczogNTIzMzc1Yzk0M2U1ICgiZHJtL3Ztd2dmeDogUG9ydCB2
bXdnZnggdG8gYXJtNjQiKQ0KPiBDYzogZHJpLWRldmVsQGxpc3RzLmZyZWVkZXNrdG9wLm9y
Zw0KPiBDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+DQo+IFJldmlld2VkLWJ5OiBNYXJ0
aW4gS3Jhc3RldiA8a3Jhc3Rldm1Adm13YXJlLmNvbT4NCj4gLS0tDQo+ICAgZHJpdmVycy9n
cHUvZHJtL3Ztd2dmeC92bXdnZnhfZHJ2LmMgfCA0IC0tLS0NCj4gICAxIGZpbGUgY2hhbmdl
ZCwgNCBkZWxldGlvbnMoLSkNCj4gDQo+IGRpZmYgLS1naXQgYS9kcml2ZXJzL2dwdS9kcm0v
dm13Z2Z4L3Ztd2dmeF9kcnYuYyBiL2RyaXZlcnMvZ3B1L2RybS92bXdnZngvdm13Z2Z4X2Ry
di5jDQo+IGluZGV4IGZlMzZlZmRiN2ZmNS4uMjdmZWIxOWYzMzI0IDEwMDY0NA0KPiAtLS0g
YS9kcml2ZXJzL2dwdS9kcm0vdm13Z2Z4L3Ztd2dmeF9kcnYuYw0KPiArKysgYi9kcml2ZXJz
L2dwdS9kcm0vdm13Z2Z4L3Ztd2dmeF9kcnYuYw0KPiBAQCAtNzI0LDEwICs3MjQsNiBAQCBz
dGF0aWMgaW50IHZtd19zZXR1cF9wY2lfcmVzb3VyY2VzKHN0cnVjdCB2bXdfcHJpdmF0ZSAq
ZGV2LA0KPiAgIA0KPiAgIAlwY2lfc2V0X21hc3RlcihwZGV2KTsNCj4gICANCj4gLQlyZXQg
PSBwY2lfcmVxdWVzdF9yZWdpb25zKHBkZXYsICJ2bXdnZnggcHJvYmUiKTsNCj4gLQlpZiAo
cmV0KQ0KPiAtCQlyZXR1cm4gcmV0Ow0KPiAtDQo+ICAgCWRldi0+cGNpX2lkID0gcGNpX2lk
Ow0KPiAgIAlpZiAocGNpX2lkID09IFZNV0dGWF9QQ0lfSURfU1ZHQTMpIHsNCj4gICAJCXJt
bWlvX3N0YXJ0ID0gcGNpX3Jlc291cmNlX3N0YXJ0KHBkZXYsIDApOw0KDQotLSANClRob21h
cyBaaW1tZXJtYW5uDQpHcmFwaGljcyBEcml2ZXIgRGV2ZWxvcGVyDQpTVVNFIFNvZnR3YXJl
IFNvbHV0aW9ucyBHZXJtYW55IEdtYkgNCk1heGZlbGRzdHIuIDUsIDkwNDA5IE7DvHJuYmVy
ZywgR2VybWFueQ0KKEhSQiAzNjgwOSwgQUcgTsO8cm5iZXJnKQ0KR2VzY2jDpGZ0c2bDvGhy
ZXI6IEl2byBUb3Rldg0K

--------------zK5lCqNdTCi8UyNjvHWRetCJ--

--------------jRxW9H7reAG78JF7eVvvI0M0
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmHnz6IFAwAAAAAACgkQlh/E3EQov+Cd
Ng//YpdeqjJ98Qbjax/rPAEbfGS2hZYLGsvlQmdL1yGomzMpDeDGJCIimU4tMVOnDKAqJddnA2oR
RnKU99BduZbWz85LgKRxx3TYgcXKp0ym+C0t4eyRLUCh1U4x4CNhg+IN67HLLZCtDhIURZNKCOyJ
MjOz4UHOnoxIoMsv8Wkca3oCrFk79OlwIQJArg9e8v7D6usRi6e2uoxFKfEQQoG+Cn13HFxHaWpY
xugE1l80aqQzvimXdZTA+07AEVCzhJ0kU5Pu46bFKMqj0zHV3gaRhgjINFhqsWDqnEnBlEvho1gk
Np+CiIZqYhza5GtnbjBlktSGM2Gk6Wzx6mBrrMC+nIvv3U8LL3KCDp5wvU4yNzKm4IrU4VVqUqxg
oAG000Q9taygnfjkkIGXVqvOrouheULkNhKZ9wPVVZV50WseCR+evQzlgvOAmvNmn+TDyNWLnxWX
rD7nsDwUyTqSEobmZgoycr3aEx2+UbHN7Qf4qdrH+HHOAVitxWHHWXHJEhlcoUEGgXpZW5SVaBnd
0RkpE6dWs6d4v4VH3/hX4X9WHBjB/Qkbfx4a+Lbqsbd2f0GIgvsQUdFrRTgknWklvnPLDnpnH/31
zCNVRqsjDPUsHVstH0SS/ERMyuT4+LPyAyfRXZFArGulPcP1Hc9cV92qsz5cLTbBCxfaNMsD07Bd
YsA=
=W3NP
-----END PGP SIGNATURE-----

--------------jRxW9H7reAG78JF7eVvvI0M0--
