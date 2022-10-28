Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1891610F6D
	for <lists+stable@lfdr.de>; Fri, 28 Oct 2022 13:11:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229635AbiJ1LLn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Oct 2022 07:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229553AbiJ1LLi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 28 Oct 2022 07:11:38 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66B531D1008;
        Fri, 28 Oct 2022 04:11:36 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id E359221A7C;
        Fri, 28 Oct 2022 11:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666955494; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q3Gyf9yh6Z7gf5UxheFhxyn9ZPpF3XaNGcf35QjzmTo=;
        b=N/JsWVC5UOrRwtHtEZlI83GXTJfHHtSLSeEgPZSl2VQQjffotCYbxz/ZyoZpq3uepws1hq
        16z4TRq4X9OQVOt7dHfisakoP5/ESnEeD+qWAJtCQ4lwdySslwIjxTM1S4FXPX0lvQ8D2g
        kdwaFAGM30//A6bDKWABybmLuL7LuOg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666955494;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=q3Gyf9yh6Z7gf5UxheFhxyn9ZPpF3XaNGcf35QjzmTo=;
        b=TW7ovC3DwFRRbWHgBYnU5YNLs9XN4NU0oG2Ho1YXlicUqnhHMUjuRmr1Qwq3HVEU3Xpy7p
        v2IL46t68MoypGAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id BCFC213A6E;
        Fri, 28 Oct 2022 11:11:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 4bBpLea4W2N6TwAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Fri, 28 Oct 2022 11:11:34 +0000
Message-ID: <18b98740-6730-3c3a-c95b-c377cb355e77@suse.de>
Date:   Fri, 28 Oct 2022 13:11:34 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [PATCH] drm/simpledrm: Only advertise formats that are supported
Content-Language: en-US
To:     =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc:     Pekka Paalanen <pekka.paalanen@collabora.com>,
        dri-devel@lists.freedesktop.org, Hector Martin <marcan@marcan.st>,
        Javier Martinez Canillas <javierm@redhat.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        asahi@lists.linux.dev
References: <20221027101327.16678-1-marcan@marcan.st>
 <fa4efcfd-91b6-dc76-2e5c-eed538bccff3@suse.de> <Y1upGwtjWgtLUZ1k@intel.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <Y1upGwtjWgtLUZ1k@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------rf1QNd9bcU8kcnpGuzuxLiIp"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------rf1QNd9bcU8kcnpGuzuxLiIp
Content-Type: multipart/mixed; boundary="------------8u5PvsoHb7Q4dMWuHVKTaKSk";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>
Cc: Pekka Paalanen <pekka.paalanen@collabora.com>,
 dri-devel@lists.freedesktop.org, Hector Martin <marcan@marcan.st>,
 Javier Martinez Canillas <javierm@redhat.com>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, asahi@lists.linux.dev
Message-ID: <18b98740-6730-3c3a-c95b-c377cb355e77@suse.de>
Subject: Re: [PATCH] drm/simpledrm: Only advertise formats that are supported
References: <20221027101327.16678-1-marcan@marcan.st>
 <fa4efcfd-91b6-dc76-2e5c-eed538bccff3@suse.de> <Y1upGwtjWgtLUZ1k@intel.com>
In-Reply-To: <Y1upGwtjWgtLUZ1k@intel.com>

--------------8u5PvsoHb7Q4dMWuHVKTaKSk
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMjguMTAuMjIgdW0gMTI6MDQgc2NocmllYiBWaWxsZSBTeXJqw6Rsw6Q6DQo+
IE9uIFRodSwgT2N0IDI3LCAyMDIyIGF0IDAxOjA4OjI0UE0gKzAyMDAsIFRob21hcyBaaW1t
ZXJtYW5uIHdyb3RlOg0KPj4gSSB0cnVzdCB5b3Ugd2hlbiB5b3Ugc2F5IHRoYXQgPG5hdGl2
ZT4tPlhSR0I4ODg4IGlzIG5vdCBlbm91Z2guIEJ1dA0KPj4gYWx0aG91Z2ggSSd2ZSByZWFk
IHlvdXIgcmVwbGllcywgSSBzdGlsbCBkb24ndCB1bmRlcnN0YW5kIHdoeSB0aGlzDQo+PiBz
d2l0Y2ggaXMgbmVjZXNzYXJ5Lg0KPj4NCj4+IFdoeSBkb24ndCB3ZSBjYWxsIGRybV9mYl9i
dWlsZF9mb3VyY2NfbGlzdCgpIHdpdGggdGhlIG5hdGl2ZQ0KPj4gZm9ybWF0L2Zvcm1hdHMg
YW5kIGxldCBpdCBhcHBlbmQgYSBudW1iZXIgb2YgZm9ybWF0cywgc3VjaCBhcyBhZGRpbmcN
Cj4+IFhSR0I4ODgsIGFkZGluZyBBUkdCODg4OCBpZiBuZWNlc3NhcnksIGFkZGluZyBBUkdC
MjEwMTAxMCBpZiBuZWNlc3NhcnkuDQo+PiBFYWNoIHdpdGggYSBlbGFib3JhdGUgY29tbWVu
dCB3aHkgYW5kIHdoaWNoIHVzZXJzcGFjZSBuZWVkcyB0aGUgZm9ybWF0LiAoPykNCj4gDQo+
IEFyZSB5b3Ugc2F5aW5nIHRoZXJlIGlzIHNvbWUgcmVhbCB1c2Vyc3BhY2UgdGhhdCBicmVh
a3Mgd2l0aG91dA0KPiB0aGUgYWxwaGEgZm9ybWF0cz8gVGhhdCB3b3VsZCBhbHJlYWR5IGJl
IGJyb2tlbiBvbiBtYW55IGRldmljZXMuDQoNCldlIHNob3VsZCBzY3JhcCB0aGVtIGFsbCBJ
TUhPLCB1bmxlc3MgdGhlIGhhcmR3YXJlIHJlYWxseSBzdXBwb3J0cyB0aGVtLiANClNlZSB0
aGUgb3RoZXIgZGlzY3Vzc2lvbiBvbiB0aGlzIHBhdGNoJ3MgdjIgYXMgd2VsbC4NCg0KQmVz
dCByZWdhcmRzDQpUaG9tYXMNCg0KPiANCg0KLS0gDQpUaG9tYXMgWmltbWVybWFubg0KR3Jh
cGhpY3MgRHJpdmVyIERldmVsb3Blcg0KU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR2VybWFu
eSBHbWJIDQpNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcsIEdlcm1hbnkNCihIUkIg
MzY4MDksIEFHIE7DvHJuYmVyZykNCkdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYNCg==


--------------8u5PvsoHb7Q4dMWuHVKTaKSk--

--------------rf1QNd9bcU8kcnpGuzuxLiIp
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmNbuOYFAwAAAAAACgkQlh/E3EQov+BI
bg/9H02ohq4l9vzXaPTIrYpZyOs24OfTZcFqW0qU93wR5tsG1iYQg+FOspomlfBBFlTJjLvOG2Gp
nrr6rQ0iUDhzuJX7MSzmU+UlBE3hM45yiMzw6z5GUXEUjzIaNWBmVQ3jpSmREAM5og6tCvAwhvXL
pOpLy9FqyAleLN7D2ERoSzZw6iWhpDRHDOnuwB2srpbVxQ9gKDoOj0bZckVFUb/EiAXt3ZoNz2+Y
NDBRkv5xkgrYc7R8wR/PIEVLgzE774oF2nSacxUYP3appqP+Os8sYprlpvIS8i2H9fr4bFtKjBJV
yedvafU4aZv2kGNB9u3nO6i3KibxTMur0mlh+npcgg2EfsEI77x3l4rTZsPmpS+W+dfE535qKKtc
xJOIOfMx+6yX4TNIHolSugTI9akMfToyH1MINCLWLTy+zu67XzqR+EZbqraDtsneQpvXZh0BPsZ6
n8GT8nLS+SbPlb1VKj/eHAlZu6CBREGD1Z7SDRJj6mJ0aYPPaejyAu24XFqwxFc4lQcPbcZyMAiy
8wAEcMsWFtmHN16g3UI4pv05q43KaqWhS8EuiSfI+jycI8nlYRXWTfH0OpcQPXtEVE71v79sUwE0
blGbgsBxCCJA5QB5LxrKFPTL0itEuilgaspv62YqrP4pa0Q7+ZzTJGAMjR5mM7QqTrmWhJKjO7d1
5sI=
=AH5T
-----END PGP SIGNATURE-----

--------------rf1QNd9bcU8kcnpGuzuxLiIp--
