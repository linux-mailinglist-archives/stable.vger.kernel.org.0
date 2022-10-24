Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1529360A19E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 13:31:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiJXLbc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 07:31:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiJXLbb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 07:31:31 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2313254CB5
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 04:31:30 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id CF6CE1FD59;
        Mon, 24 Oct 2022 11:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1666611088; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0N6FIHXxZbDyYLgkltrdtbtierXGgR5PxMky4M+roWw=;
        b=W6jY81UY+MAsftsC3/5ty+0KfFyRA/Hq3N8QLPCKvhOSoqTOb9Ov4QUzAWviOf4H+627ad
        Jg0xN0sVsi4fnJ2w62LIQJjhRvcp0nv2wb1zWCAGy+3f05XgCp5HlVrZkBbcSFEMhWXDE1
        M4CHH0qAneoFBECikt1tJz9jrZpBObQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1666611088;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0N6FIHXxZbDyYLgkltrdtbtierXGgR5PxMky4M+roWw=;
        b=AwtqEwQJDmhk4an17AItnvtmmxegh9nBup7L2j/oOfhlkILVhkMZXlLRNEgOpdcSkgOtEK
        cQ4pqBgdcqXZRCDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9D4A613357;
        Mon, 24 Oct 2022 11:31:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id iTN0JZB3VmPyOAAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Mon, 24 Oct 2022 11:31:28 +0000
Message-ID: <51651c2e-3706-37d7-01e7-5d473a412850@suse.de>
Date:   Mon, 24 Oct 2022 13:31:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.3
Subject: Re: [Regression] CPU stalls and eventually causes a complete system
 freeze with 6.0.3 due to "video/aperture: Disable and unregister sysfb
 devices via aperture helpers"
Content-Language: en-US
To:     Greg KH <gregkh@linuxfoundation.org>,
        Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Sasha Levin <sashal@kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        Andreas <andreas.thalhammer@linux.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        ML dri-devel <dri-devel@lists.freedesktop.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <bbf7afe7-6ed2-6708-d302-4ba657444c45@leemhuis.info>
 <668a8ffd-ffc7-e1cc-28b4-1caca1bcc3d6@suse.de>
 <958fd763-01b6-0167-ba6b-97cbd3bddcb6@leemhuis.info>
 <Y1Z2sq9RyEnIdixD@kroah.com>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <Y1Z2sq9RyEnIdixD@kroah.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------rtaZHMnjD3MuMliGMu0elKKa"
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------rtaZHMnjD3MuMliGMu0elKKa
Content-Type: multipart/mixed; boundary="------------M2kfEEtPSKiqJ13zS6YuRsmN";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Greg KH <gregkh@linuxfoundation.org>,
 Thorsten Leemhuis <regressions@leemhuis.info>
Cc: Sasha Levin <sashal@kernel.org>,
 "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
 Andreas <andreas.thalhammer@linux.com>,
 Javier Martinez Canillas <javierm@redhat.com>,
 ML dri-devel <dri-devel@lists.freedesktop.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
Message-ID: <51651c2e-3706-37d7-01e7-5d473a412850@suse.de>
Subject: Re: [Regression] CPU stalls and eventually causes a complete system
 freeze with 6.0.3 due to "video/aperture: Disable and unregister sysfb
 devices via aperture helpers"
References: <bbf7afe7-6ed2-6708-d302-4ba657444c45@leemhuis.info>
 <668a8ffd-ffc7-e1cc-28b4-1caca1bcc3d6@suse.de>
 <958fd763-01b6-0167-ba6b-97cbd3bddcb6@leemhuis.info>
 <Y1Z2sq9RyEnIdixD@kroah.com>
In-Reply-To: <Y1Z2sq9RyEnIdixD@kroah.com>

--------------M2kfEEtPSKiqJ13zS6YuRsmN
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMjQuMTAuMjIgdW0gMTM6Mjcgc2NocmllYiBHcmVnIEtIOg0KPiBPbiBNb24s
IE9jdCAyNCwgMjAyMiBhdCAxMjo0MTo0M1BNICswMjAwLCBUaG9yc3RlbiBMZWVtaHVpcyB3
cm90ZToNCj4+IEhpISBUaHggZm9yIHRoZSByZXBseS4NCj4+DQo+PiBPbiAyNC4xMC4yMiAx
MjoyNiwgVGhvbWFzIFppbW1lcm1hbm4gd3JvdGU6DQo+Pj4gQW0gMjMuMTAuMjIgdW0gMTA6
MDQgc2NocmllYiBUaG9yc3RlbiBMZWVtaHVpczoNCj4+Pj4NCj4+Pj4gSSBub3RpY2VkIGEg
cmVncmVzc2lvbiByZXBvcnQgaW4gYnVnemlsbGEua2VybmVsLm9yZy4gQXMgbWFueSAobW9z
dD8pDQo+Pj4+IGtlcm5lbCBkZXZlbG9wZXIgZG9uJ3Qga2VlcCBhbiBleWUgb24gaXQsIEkg
ZGVjaWRlZCB0byBmb3J3YXJkIGl0IGJ5DQo+Pj4+IG1haWwuIFF1b3RpbmcgZnJvbSBodHRw
czovL2J1Z3ppbGxhLmtlcm5lbC5vcmcvc2hvd19idWcuY2dpP2lkPTIxNjYxNsKgIDoNCj4+
Pj4NCj4+Pj4+ICDCoCBBbmRyZWFzIDIwMjItMTAtMjIgMTQ6MjU6MzIgVVRDDQo+Pj4+Pg0K
Pj4+Pj4gQ3JlYXRlZCBhdHRhY2htZW50IDMwMzA3NCBbZGV0YWlsc10NCj4+Pj4+IGRtZXNn
DQo+Pj4NCj4+PiBJJ3ZlIGxvb2tlZCBhdCB0aGUga2VybmVsIGxvZyBhbmQgZm91bmQgdGhh
dCBzaW1wbGVkcm0gaGFzIGJlZW4gbG9hZGVkDQo+Pj4gKmFmdGVyKiBhbWRncHUsIHdoaWNo
IHNob3VsZCBuZXZlciBoYXBwZW4uIFRoZSBwcm9ibGVtYXRpYyBwYXRjaCBoYXMNCj4+PiBi
ZWVuIHRha2VuIGZyb20gYSBsb25nIGxpc3Qgb2YgcmVmYWN0b3Jpbmcgd29yayBvbiB0aGlz
IGNvZGUuIE5vIHdvbmRlcg0KPj4+IHRoYXQgaXQgZG9lc24ndCB3b3JrIGFzIGV4cGVjdGVk
Lg0KPj4+DQo+Pj4gUGxlYXNlIGNoZXJyeS1waWNrIGNvbW1pdCA5ZDY5ZWYxODM4MTUgKCJm
YmRldi9jb3JlOiBSZW1vdmUNCj4+PiByZW1vdmVfY29uZmxpY3RpbmdfcGNpX2ZyYW1lYnVm
ZmVycygpIikgaW50byB0aGUgNi4wIHN0YWJsZSBicmFuY2ggYW5kDQo+Pj4gcmVwb3J0IG9u
IHRoZSByZXN1bHRzLiBJdCBzaG91bGQgZml4IHRoZSBwcm9ibGVtLg0KPj4NCj4+IEdyZWcs
IGlzIHRoYXQgZW5vdWdoIGZvciB5b3UgdG8gcGljayB0aGlzIHVwPyBPciBkbyB5b3Ugd2Fu
dCBBbmRyZWFzIHRvDQo+PiB0ZXN0IGZpcnN0IGlmIGl0IHJlYWxseSBmaXhlcyB0aGUgcmVw
b3J0ZWQgcHJvYmxlbT8NCj4gDQo+IFRoaXMgc2hvdWxkIGJlIGdvb2QgZW5vdWdoLiAgSWYg
dGhpcyBkb2VzIE5PVCBmaXggdGhlIGlzc3VlLCBwbGVhc2UgbGV0DQo+IG1lIGtub3cuDQoN
ClRoYW5rcyBhIGxvdC4gSSB0aGluayBJIGNhbiBwcm92aWRlZCBhIGRlZGljYXRlZCBmaXgg
aWYgdGhlIHByb3Bvc2VkIA0KY29tbWl0IGRvZXNuJ3Qgd29yay4NCg0KQmVzdCByZWdhcmRz
DQpUaG9tYXMNCg0KPiANCj4gdGhhbmtzLA0KPiANCj4gZ3JlZyBrLWgNCg0KLS0gDQpUaG9t
YXMgWmltbWVybWFubg0KR3JhcGhpY3MgRHJpdmVyIERldmVsb3Blcg0KU1VTRSBTb2Z0d2Fy
ZSBTb2x1dGlvbnMgR2VybWFueSBHbWJIDQpNYXhmZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJl
cmcsIEdlcm1hbnkNCihIUkIgMzY4MDksIEFHIE7DvHJuYmVyZykNCkdlc2Now6RmdHNmw7xo
cmVyOiBJdm8gVG90ZXYNCg==

--------------M2kfEEtPSKiqJ13zS6YuRsmN--

--------------rtaZHMnjD3MuMliGMu0elKKa
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmNWd5AFAwAAAAAACgkQlh/E3EQov+DM
WBAAvxxtyjFGHsppmrWWtZI8JW9eBdUpq8PKvWJlv/mkz/9a52riD6mL8lw1UOSmBrfqO4xnj2we
3HdmsrO4N+5KSLSUhfkB1Flnl/SxADPvH0uSDNPsYlGwcSuVAfpaSKmGp3oe+Ntym8Kwr8NCRWtP
yFUS6s//VjxMCyg16C3JNiBIPh/ZlPMHjxTPMbSDmqyq4yBjsXeDtLyBYlUtTSzLXqKzEMqCe3Ti
tQAQJBIlepaVVxu+zdGCDAGHkayMVhyOvhqQJkuv7GVu097CZxalHLQ37bB0DkkZZm2AHUJZ2qeC
gb6eeM7iMobh68Lxmf+kclIniQb7+LtEtERDyiK91/kSVR9s9FT70DRKWend+dwW86V6rUKy+mqo
1/hUO9wn6ADgBr738ilZ07n2eagipY2ObAeiCu4Y62IZmQjHTJCoRY4o8B4UFIHb+OQIHsZ3vIb1
BkLRAqX9SdViYvzmgCef7HmzK8Tpn2qmuqTUtbbWHExiLzANM/VFvbA1LiWaeY4oQB2eN/JQfZ5A
FBkmK72OHyk2NGmnjZvoLk5xbl5fknBCC3C+Ydob+oP+xgFwPxo58wg5rp4i7onwFstkvFS+MmdJ
HxkK3q6vqT7N5YXbHbUSLCNZZn9F4oERn2zVHUMpUWnh6bGTh7TsYBy/xV2gCjCNDC28ACFJNzxz
PQ8=
=SP4K
-----END PGP SIGNATURE-----

--------------rtaZHMnjD3MuMliGMu0elKKa--
