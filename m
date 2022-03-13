Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6DAC4D7800
	for <lists+stable@lfdr.de>; Sun, 13 Mar 2022 20:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235393AbiCMTkm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Mar 2022 15:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233197AbiCMTkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 13 Mar 2022 15:40:41 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAED3201B4
        for <stable@vger.kernel.org>; Sun, 13 Mar 2022 12:39:32 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 7458721102;
        Sun, 13 Mar 2022 19:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647200371; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BWLSHvP+d7/kXMgllficUSa89KHzCsAeZvIpwsAJ+G0=;
        b=bosR4FvqHwTHEolOMuOv090JjsYcV9/LhfXT7o6kw84TT9iAg0Mw00zXncOdlfHE/yrCbM
        qVbX4E9YJxXesOEWBqTVXGDNccTuV2FD8tFJ7Gyar6XBb8fintvf1UGM4jYMs0FmLgjnR+
        k+MWMdGVsdjMoDQlOOSrAMmt22J+pnc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647200371;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BWLSHvP+d7/kXMgllficUSa89KHzCsAeZvIpwsAJ+G0=;
        b=yx8VQOGrQHimZcw5zA12JpYCovNma2wHvfEi1rDsl88jsd+7CJBMyXcedrKOCZ5U4x/k92
        8FBhu1TsAyYfMJBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 56DE713B0C;
        Sun, 13 Mar 2022 19:39:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VvwwFHNILmJRFwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Sun, 13 Mar 2022 19:39:31 +0000
Message-ID: <50a09e18-34f6-2f74-66eb-f632591f5ff6@suse.de>
Date:   Sun, 13 Mar 2022 20:39:30 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH v2] drm/mgag200: Fix PLL setup for g200wb and g200ew
Content-Language: en-US
To:     Jocelyn Falempe <jfalempe@redhat.com>,
        dri-devel@lists.freedesktop.org
Cc:     stable@vger.kernel.org, michel@daenzer.net
References: <20220308171111.220557-1-jfalempe@redhat.com>
 <20220308174321.225606-1-jfalempe@redhat.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <20220308174321.225606-1-jfalempe@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------UvFwc5VT08mj31tNp80gSf34"
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
--------------UvFwc5VT08mj31tNp80gSf34
Content-Type: multipart/mixed; boundary="------------G0Mrm0yQ3ya8tMYz6vsv0cwd";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Jocelyn Falempe <jfalempe@redhat.com>, dri-devel@lists.freedesktop.org
Cc: stable@vger.kernel.org, michel@daenzer.net
Message-ID: <50a09e18-34f6-2f74-66eb-f632591f5ff6@suse.de>
Subject: Re: [PATCH v2] drm/mgag200: Fix PLL setup for g200wb and g200ew
References: <20220308171111.220557-1-jfalempe@redhat.com>
 <20220308174321.225606-1-jfalempe@redhat.com>
In-Reply-To: <20220308174321.225606-1-jfalempe@redhat.com>

--------------G0Mrm0yQ3ya8tMYz6vsv0cwd
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMDguMDMuMjIgdW0gMTg6NDMgc2NocmllYiBKb2NlbHluIEZhbGVtcGU6DQo+
IGNvbW1pdCBmODZjM2VkNTU5MjAgKCJkcm0vbWdhZzIwMDogU3BsaXQgUExMIHNldHVwIGlu
dG8gY29tcHV0ZSBhbmQNCj4gICB1cGRhdGUgZnVuY3Rpb25zIikgaW50cm9kdWNlZCBhIHJl
Z3Jlc3Npb24gZm9yIGcyMDB3YiBhbmQgZzIwMGV3Lg0KPiBUaGUgUExMcyBhcmUgbm90IHNl
dCB1cCBwcm9wZXJseSwgYW5kIFZHQSBzY3JlZW4gc3RheXMNCj4gYmxhY2ssIG9yIGRpc3Bs
YXlzICJvdXQgb2YgcmFuZ2UiIG1lc3NhZ2UuDQo+IA0KPiBNR0ExMDY0X1dCX1BJWF9QTExD
X04vTS9QIHdhcyBtaXN0YWtlbmx5IHJlcGxhY2VkIHdpdGgNCj4gTUdBMTA2NF9QSVhfUExM
Q19OL00vUCB3aGljaCBoYXZlIGRpZmZlcmVudCBhZGRyZXNzZXMuDQo+IA0KPiBQYXRjaCB0
ZXN0ZWQgb24gYSBEZWxsIFQzMTAgd2l0aCBnMjAwd2INCj4gDQo+IEZpeGVzOiBmODZjM2Vk
NTU5MjAgKCJkcm0vbWdhZzIwMDogU3BsaXQgUExMIHNldHVwIGludG8gY29tcHV0ZSBhbmQg
dXBkYXRlIGZ1bmN0aW9ucyIpDQo+IENjOiBzdGFibGVAdmdlci5rZXJuZWwub3JnDQo+IFNp
Z25lZC1vZmYtYnk6IEpvY2VseW4gRmFsZW1wZSA8amZhbGVtcGVAcmVkaGF0LmNvbT4NCg0K
VGhhbmsgeW91IHNvIG11Y2guIEkndmUgYWRkZWQgdGhlIHBhdGNoIHRvIGRybS1taXNjLWZp
eGVzLiBPbmUgc21hbGwgDQpuaXQ6IG5leHQgdGltZSwgcGxlYXNlIGluY2x1ZGUgYSBsaXR0
bGUgY2hhbmdlIGxvZyB0aGF0IHNheXMgd2hhdCBlYWNoIA0KdmVyc2lvbiBvZiB0aGUgcGF0
Y2ggY2hhbmdlczsgZXZlbiBpZiBpdCdzIG9ubHkgdGhlIHN0eWxlIG9mIHRoZSBjb21taXQg
DQptZXNzYWdlLg0KDQpCZXN0IHJlZ2FyZHMNClRob21hcw0KDQo+IC0tLQ0KPiAgIGRyaXZl
cnMvZ3B1L2RybS9tZ2FnMjAwL21nYWcyMDBfcGxsLmMgfCA2ICsrKy0tLQ0KPiAgIDEgZmls
ZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDMgZGVsZXRpb25zKC0pDQo+IA0KPiBkaWZm
IC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL21nYWcyMDAvbWdhZzIwMF9wbGwuYyBiL2RyaXZl
cnMvZ3B1L2RybS9tZ2FnMjAwL21nYWcyMDBfcGxsLmMNCj4gaW5kZXggZTlhZTIyYjRmODEz
Li41MmJlMDhiNzQ0YWQgMTAwNjQ0DQo+IC0tLSBhL2RyaXZlcnMvZ3B1L2RybS9tZ2FnMjAw
L21nYWcyMDBfcGxsLmMNCj4gKysrIGIvZHJpdmVycy9ncHUvZHJtL21nYWcyMDAvbWdhZzIw
MF9wbGwuYw0KPiBAQCAtNDA0LDkgKzQwNCw5IEBAIG1nYWcyMDBfcGl4cGxsX3VwZGF0ZV9n
MjAwd2Ioc3RydWN0IG1nYWcyMDBfcGxsICpwaXhwbGwsIGNvbnN0IHN0cnVjdCBtZ2FnMjAw
X3BsDQo+ICAgCQl1ZGVsYXkoNTApOw0KPiAgIA0KPiAgIAkJLyogcHJvZ3JhbSBwaXhlbCBw
bGwgcmVnaXN0ZXIgKi8NCj4gLQkJV1JFR19EQUMoTUdBMTA2NF9QSVhfUExMQ19OLCB4cGl4
cGxsY24pOw0KPiAtCQlXUkVHX0RBQyhNR0ExMDY0X1BJWF9QTExDX00sIHhwaXhwbGxjbSk7
DQo+IC0JCVdSRUdfREFDKE1HQTEwNjRfUElYX1BMTENfUCwgeHBpeHBsbGNwKTsNCj4gKwkJ
V1JFR19EQUMoTUdBMTA2NF9XQl9QSVhfUExMQ19OLCB4cGl4cGxsY24pOw0KPiArCQlXUkVH
X0RBQyhNR0ExMDY0X1dCX1BJWF9QTExDX00sIHhwaXhwbGxjbSk7DQo+ICsJCVdSRUdfREFD
KE1HQTEwNjRfV0JfUElYX1BMTENfUCwgeHBpeHBsbGNwKTsNCj4gICANCj4gICAJCXVkZWxh
eSg1MCk7DQo+ICAgDQoNCi0tIA0KVGhvbWFzIFppbW1lcm1hbm4NCkdyYXBoaWNzIERyaXZl
ciBEZXZlbG9wZXINClNVU0UgU29mdHdhcmUgU29sdXRpb25zIEdlcm1hbnkgR21iSA0KTWF4
ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5iZXJnLCBHZXJtYW55DQooSFJCIDM2ODA5LCBBRyBO
w7xybmJlcmcpDQpHZXNjaMOkZnRzZsO8aHJlcjogSXZvIFRvdGV2DQo=

--------------G0Mrm0yQ3ya8tMYz6vsv0cwd--

--------------UvFwc5VT08mj31tNp80gSf34
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmIuSHIFAwAAAAAACgkQlh/E3EQov+Bw
qQ//WN6uMbSJKxSHpxNSH0k19PcjZtD6LF8tDyc2PbttE+8wwsihxtQdGI29V8wNXj8qQsC2Gpr8
QgqDJ+ZD/M/zpq6KHHkThVMT8ugn+BRNDDvO8zAgpaMVYeiz+ZyBF646wMyISEK6aR/7W1PjYUTF
sPdSvRKVONeNnVVzZEWQktjOz2S3UsZMP9r7WnNkkD7wflrfdwGaIsT6hQ/SP/KJ57W3EKLFhUc6
Z+DeWwtzWqfOZMVYIh1BoW5/eI7HpCRMORX1KUFp97rNXflWFM1Nb9hPnkWDissCn1kPOCExkzeV
muT4LtST4xRe+RPKN3PhFWGxFD+DYAi487rIKvr+tQTnN4tMP14rm0y8N/WA+d6P0+prX+jMmJEm
FfenAysktl/vHU4AMUfaB+e3ftpSuafGsdYVMqfPHIM1PXic1npioylGS2u/rIlrWxdjVBDbMFh1
I6mjyWDOEbfaFAFmBFTmunnMX7ijdAy0vvp4BwGfNBRBPhfaifLl2sNDybFA2eZLzoJlh2vmEpyl
YiO6Ga84cIEHaEYER9lGdFdbcQBvaUYLAqLHlaciPVrd3uL2GUoGJXgm9gMp/MLACahjQnuz5wMn
n8dvK1yv8AhLBKoslf95ewVqoMfIMHmor7YCRNb6jJTvocyy8d/N8T6P5sDh7k282wUAttSbzCJU
MFA=
=6g6E
-----END PGP SIGNATURE-----

--------------UvFwc5VT08mj31tNp80gSf34--
