Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D5AAC4DDF6E
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:56:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236575AbiCRQ52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:57:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239430AbiCRQ52 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:57:28 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F2D72BC1C9;
        Fri, 18 Mar 2022 09:56:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E66661F392;
        Fri, 18 Mar 2022 16:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1647622567; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=Mp/9GH7VCVH6yRrvqWVAbBDtVnOlmtIXQvROfo3TzB8=;
        b=d53Ia78bdfyuGJLCOxWXtyZaOvwAqUeXDzSLCF9NmwRRTeyXVsv/yetQY9oesHh69TLTXT
        nYmYcnlYYWph0Tfp4VxXOSxDxc97dLAO2DB8LUsTaE5usZlnNFMnG8sNxtroVxubgDlxzA
        qLuoFT8kgo5FEVMOy0jQ5jR1zOwYhh4=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9FD501351D;
        Fri, 18 Mar 2022 16:56:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id Yy9iJae5NGIgCgAAMHmgww
        (envelope-from <jgross@suse.com>); Fri, 18 Mar 2022 16:56:07 +0000
Message-ID: <2a4573e0-4a8d-52c1-d29b-66b13bfe376f@suse.com>
Date:   Fri, 18 Mar 2022 17:56:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: [PATCH] platform/x86/dell: add buffer allocation/free functions
 for SMI calls
Content-Language: en-US
To:     David Laight <David.Laight@ACULAB.COM>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "platform-driver-x86@vger.kernel.org" 
        <platform-driver-x86@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Dell.Client.Kernel@dell.com" <Dell.Client.Kernel@dell.com>
Cc:     Stuart Hayes <stuart.w.hayes@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Mark Gross <markgross@kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
References: <20220318150950.16843-1-jgross@suse.com>
 <accf95548a8c4374b17c159b9b2d0098@AcuMS.aculab.com>
From:   Juergen Gross <jgross@suse.com>
In-Reply-To: <accf95548a8c4374b17c159b9b2d0098@AcuMS.aculab.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------TM6SaXL8siRcJxQNQGUqgn4j"
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
--------------TM6SaXL8siRcJxQNQGUqgn4j
Content-Type: multipart/mixed; boundary="------------0gPSdPzUPEcNzI04c8WYT5Ll";
 protected-headers="v1"
From: Juergen Gross <jgross@suse.com>
To: David Laight <David.Laight@ACULAB.COM>,
 "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
 "platform-driver-x86@vger.kernel.org" <platform-driver-x86@vger.kernel.org>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
 "Dell.Client.Kernel@dell.com" <Dell.Client.Kernel@dell.com>
Cc: Stuart Hayes <stuart.w.hayes@gmail.com>,
 Hans de Goede <hdegoede@redhat.com>, Mark Gross <markgross@kernel.org>,
 "stable@vger.kernel.org" <stable@vger.kernel.org>
Message-ID: <2a4573e0-4a8d-52c1-d29b-66b13bfe376f@suse.com>
Subject: Re: [PATCH] platform/x86/dell: add buffer allocation/free functions
 for SMI calls
References: <20220318150950.16843-1-jgross@suse.com>
 <accf95548a8c4374b17c159b9b2d0098@AcuMS.aculab.com>
In-Reply-To: <accf95548a8c4374b17c159b9b2d0098@AcuMS.aculab.com>

--------------0gPSdPzUPEcNzI04c8WYT5Ll
Content-Type: multipart/mixed; boundary="------------DDUITxrpMQFqvmeqif0y83vA"

--------------DDUITxrpMQFqvmeqif0y83vA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

T24gMTguMDMuMjIgMTY6MjIsIERhdmlkIExhaWdodCB3cm90ZToNCj4gRnJvbTogSnVlcmdl
biBHcm9zcw0KPj4gU2VudDogMTggTWFyY2ggMjAyMiAxNToxMA0KPj4NCj4+IFRoZSBkY2Ri
YXMgZHJpdmVyIGlzIHVzZWQgdG8gY2FsbCBTTUkgaGFuZGxlcnMgZm9yIGJvdGgsIGRjZGJh
cyBhbmQNCj4+IGRlbGwtc21iaW9zLXNtbS4gQm90aCBkcml2ZXJzIGFsbG9jYXRlIGEgYnVm
ZmVyIGZvciBjb21tdW5pY2F0aW5nDQo+PiB3aXRoIHRoZSBTTUkgaGFuZGxlci4gVGhlIHBo
eXNpY2FsIGJ1ZmZlciBhZGRyZXNzIGlzIHRoZW4gcGFzc2VkIHRvDQo+PiB0aGUgY2FsbGVk
IFNNSSBoYW5kbGVyIHZpYSAlZWJ4Lg0KPj4NCj4+IFVuZm9ydHVuYXRlbHkgdGhpcyBkb2Vz
bid0IHdvcmsgd2hlbiBydW5uaW5nIGluIFhlbiBkb20wLCBhcyB0aGUNCj4+IHBoeXNpY2Fs
IGFkZHJlc3Mgb2J0YWluZWQgdmlhIHZpcnRfdG9fcGh5cygpIGlzIG9ubHkgYSBndWVzdCBw
aHlzaWNhbA0KPj4gYWRkcmVzcywgYW5kIG5vdCBhIG1hY2hpbmUgcGh5c2ljYWwgYWRkcmVz
cyBhcyBuZWVkZWQgYnkgU01JLg0KPiANCj4gVGhlIHBoeXNpY2FsIGFkZHJlc3MgZnJvbSB2
aXJ0X3RvX3BoeSgpIGlzIGFsd2F5cyB3cm9uZy4NCj4gVGhhdCBpcyB0aGUgcGh5c2ljYWwg
YWRkcmVzcyB0aGUgY3B1IGhhcyBmb3IgdGhlIG1lbW9yeS4NCj4gV2hhdCB5b3Ugd2FudCBp
cyB0aGUgYWRkcmVzcyB0aGUgZG1hIG1hc3RlciBpbnRlcmZhY2UgbmVlZHMgdG8gdXNlLg0K
PiBUaGF0IGNhbiBiZSBkaWZmZXJlbnQgZm9yIGEgcGh5c2ljYWwgc3lzdGVtIC0gbm8gbmVl
ZCBmb3IgdmlydHVhbGlzYXRpb24uDQo+IA0KPiBPbiB4ODYgdGhleSBkbyB1c3VhbGx5IG1h
dGNoLCBidXQgYW55dGhpbmcgd2l0aCBhIGZ1bGwgaW9tbXUNCj4gd2lsbCBuZWVkIGNvbXBs
ZXRlbHkgZGlmZmVyZW50IGFkZHJlc3Nlcy4NCg0KWWVzLCB0aGFua3MgZm9yIHJlbWluZGlu
ZyBtZSBvZiB0aGF0Lg0KDQpUaGUgU01JIGhhbmRsZXIgaXMgcnVubmluZyBvbiB0aGUgY3B1
LCByaWdodD8gU28gdXNpbmcgdGhlIERNQQ0KYWRkcmVzcyBpcyB3cm9uZyBpbiBjYXNlIG9m
IGFuIElPTU1VLiBJIHJlYWxseSBuZWVkIHRoZSBtYWNoaW5lDQpwaHlzaWNhbCBhZGRyZXNz
Lg0KDQoNCkp1ZXJnZW4NCg==
--------------DDUITxrpMQFqvmeqif0y83vA
Content-Type: application/pgp-keys; name="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Disposition: attachment; filename="OpenPGP_0xB0DE9DD628BF132F.asc"
Content-Description: OpenPGP public key
Content-Transfer-Encoding: quoted-printable

-----BEGIN PGP PUBLIC KEY BLOCK-----

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
jR/i1DG86lem3iBDXzXsZDn8R38=3D
=3D2wuH
-----END PGP PUBLIC KEY BLOCK-----

--------------DDUITxrpMQFqvmeqif0y83vA--

--------------0gPSdPzUPEcNzI04c8WYT5Ll--

--------------TM6SaXL8siRcJxQNQGUqgn4j
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsB5BAABCAAjFiEEhRJncuj2BJSl0Jf3sN6d1ii/Ey8FAmI0uacFAwAAAAAACgkQsN6d1ii/Ey8Y
2Af9H+sA3gToLVqND0JUAgm34RV3HcBKtmpQrwauUp+n2SxJt7BkiulazKmckqT1f3cwxZCYdmJK
y0z4QGH05zM2M+L8Zkij1zVgL+yT45i0ptVXqAbURrP5GRvPoAcCzdMcQRjFma+QxviH6iY6Tmp/
yRixaeI76WgVtjPGpg50MevpkP1xnYI8a6Rm6g3yXH6D+UA5kooDyRiz8CGTepBffR1jdKBAjLwy
PTbPY/KUMdeqfkOvj/5DAx5UvGFfY4DEkUf2WQ2F50AMQe8ZruD85Pi2SqTDkDin9YEeXOP1MJTj
WFa6WWbs9CwlBtaXRbk9N56f5g2mhfeijLVIrQ7h8g==
=qjJK
-----END PGP SIGNATURE-----

--------------TM6SaXL8siRcJxQNQGUqgn4j--
