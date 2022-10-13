Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC02F5FD696
	for <lists+stable@lfdr.de>; Thu, 13 Oct 2022 11:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229590AbiJMJF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Oct 2022 05:05:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229506AbiJMJF0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Oct 2022 05:05:26 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833C9BE516
        for <stable@vger.kernel.org>; Thu, 13 Oct 2022 02:05:22 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id EECB61F385;
        Thu, 13 Oct 2022 09:05:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1665651921; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WOnGgq9IUw7xGTBr51NrUAkoYYRVaIREesWzrM/IKTA=;
        b=1W1i+3A4COH3c7GiQYSZFPdVF/uFEs5VM2anfP6J3Fuemd87l5bSAKLf0y/M3KBb9f+xtS
        3IBfoAORwrwgb08sH5Fm9GdCVc3NX7b8l/mHt1x+9toxRh8K6gtj9v4fBiMtoMNV/mIyLR
        /pC/NyMFhRjQsq3VxJIi5EmJMA1iuis=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1665651921;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WOnGgq9IUw7xGTBr51NrUAkoYYRVaIREesWzrM/IKTA=;
        b=mZLPES2SVmm9mzSvBjf6T1uHef/ys9qNl3PUV4Hc8Vdc6YVJ1lZxNqNNP9xAK5SLImSenC
        gprCNJb7tVN4CgBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C020213AAA;
        Thu, 13 Oct 2022 09:05:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OofeLdDUR2PfAQAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Thu, 13 Oct 2022 09:05:20 +0000
Message-ID: <db634341-da68-e8a6-1143-445f17262c63@suse.de>
Date:   Thu, 13 Oct 2022 11:05:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH] drm/mgag200: Fix PLL setup for G200_SE_A rev >=4
To:     Jocelyn Falempe <jfalempe@redhat.com>,
        dri-devel@lists.freedesktop.org, airlied@redhat.com
Cc:     lyude@redhat.com, michel@daenzer.net, stable@vger.kernel.org
References: <20221013082901.471417-1-jfalempe@redhat.com>
Content-Language: en-US
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <20221013082901.471417-1-jfalempe@redhat.com>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------GpuivNAmFfuBmweK0LBdPmEP"
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------GpuivNAmFfuBmweK0LBdPmEP
Content-Type: multipart/mixed; boundary="------------WiH907b0Dg84Bth0iAwE05Yl";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: Jocelyn Falempe <jfalempe@redhat.com>, dri-devel@lists.freedesktop.org,
 airlied@redhat.com
Cc: lyude@redhat.com, michel@daenzer.net, stable@vger.kernel.org
Message-ID: <db634341-da68-e8a6-1143-445f17262c63@suse.de>
Subject: Re: [PATCH] drm/mgag200: Fix PLL setup for G200_SE_A rev >=4
References: <20221013082901.471417-1-jfalempe@redhat.com>
In-Reply-To: <20221013082901.471417-1-jfalempe@redhat.com>

--------------WiH907b0Dg84Bth0iAwE05Yl
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

SGkNCg0KQW0gMTMuMTAuMjIgdW0gMTA6Mjkgc2NocmllYiBKb2NlbHluIEZhbGVtcGU6DQo+
IEZvciBHMjAwX1NFX0EsIFBMTCBNIHNldHRpbmcgaXMgd3JvbmcsIHdoaWNoIGxlYWRzIHRv
IGJsYW5rIHNjcmVlbiwNCj4gb3IgInNpZ25hbCBvdXQgb2YgcmFuZ2UiIG9uIFZHQSBkaXNw
bGF5Lg0KPiBwcmV2aW91cyBjb2RlIGhhZCAibSB8PSAweDgwIiB3aGljaCB3YXMgY2hhbmdl
ZCB0bw0KPiBtIHw9ICgocGl4cGxsY24gJiBCSVQoOCkpID4+IDEpOw0KPiANCj4gVGVzdGVk
IG9uIEcyMDBfU0VfQSByZXYgNDINCj4gDQo+IFRoaXMgbGluZSBvZiBjb2RlIHdhcyBtb3Zl
ZCB0byBhbm90aGVyIGZpbGUgd2l0aA0KPiBjb21taXQgODUzOTdmNmJjNGZmICgiZHJtL21n
YWcyMDA6IEluaXRpYWxpemUgZWFjaCBtb2RlbCBpbiBzZXBhcmF0ZQ0KPiBmdW5jdGlvbiIp
IGJ1dCBjYW4gYmUgZWFzaWx5IGJhY2twb3J0ZWQgYmVmb3JlIHRoaXMgY29tbWl0Lg0KPiAN
Cj4gRml4ZXM6IDJkZDA0MDk0NmVjZiAoImRybS9tZ2FnMjAwOiBTdG9yZSB2YWx1ZXMgKG5v
dCBiaXRzKSBpbiBzdHJ1Y3QgbWdhZzIwMF9wbGxfdmFsdWVzIikNCj4gQ2M6IHN0YWJsZUB2
Z2VyLmtlcm5lbC5vcmcNCj4gU2lnbmVkLW9mZi1ieTogSm9jZWx5biBGYWxlbXBlIDxqZmFs
ZW1wZUByZWRoYXQuY29tPg0KPiAtLS0NCj4gICBkcml2ZXJzL2dwdS9kcm0vbWdhZzIwMC9t
Z2FnMjAwX2cyMDBzZS5jIHwgMiArLQ0KPiAgIDEgZmlsZSBjaGFuZ2VkLCAxIGluc2VydGlv
bigrKSwgMSBkZWxldGlvbigtKQ0KPiANCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvZ3B1L2Ry
bS9tZ2FnMjAwL21nYWcyMDBfZzIwMHNlLmMgYi9kcml2ZXJzL2dwdS9kcm0vbWdhZzIwMC9t
Z2FnMjAwX2cyMDBzZS5jDQo+IGluZGV4IGJlMzg5ZWQ5MWNiZC4uNGVjMDM1MDI5YjhiIDEw
MDY0NA0KPiAtLS0gYS9kcml2ZXJzL2dwdS9kcm0vbWdhZzIwMC9tZ2FnMjAwX2cyMDBzZS5j
DQo+ICsrKyBiL2RyaXZlcnMvZ3B1L2RybS9tZ2FnMjAwL21nYWcyMDBfZzIwMHNlLmMNCj4g
QEAgLTI4NCw3ICsyODQsNyBAQCBzdGF0aWMgdm9pZCBtZ2FnMjAwX2cyMDBzZV8wNF9waXhw
bGxjX2F0b21pY191cGRhdGUoc3RydWN0IGRybV9jcnRjICpjcnRjLA0KPiAgIAlwaXhwbGxj
cCA9IHBpeHBsbGMtPnAgLSAxOw0KPiAgIAlwaXhwbGxjcyA9IHBpeHBsbGMtPnM7DQo+ICAg
DQo+IC0JeHBpeHBsbGNtID0gcGl4cGxsY20gfCAoKHBpeHBsbGNuICYgQklUKDgpKSA+PiAx
KTsNCj4gKwl4cGl4cGxsY20gPSBwaXhwbGxjbSB8IEJJVCg3KTsNCg0KVGhhbmtzIGZvciBm
aWd1cmluZyB0aGlzIG91dC4gRzIwMFNFIGFwcGFyZW50bHkgaXMgc3BlY2lhbCBjb21wYXJl
ZCB0byANCnRoZSBvdGhlciBtb2RlbHMuIFRoZSBvbGQgTUdBIGRvY3Mgb25seSBsaXN0IHRo
aXMgYml0IGFzIDxyZXNlcnZlZD4uIA0KUmVhbGx5IG1ha2VzIG1lIHdvbmRlciB3aHkgdGhp
cyBpcyBkaWZmZXJlbnQuDQoNClBsZWFzZSB3cml0ZSBpdCBhcw0KDQogICBCSVQoNykgfCBw
aXhwbGxjbQ0KDQpzbyB0aGF0IGJpdCBzZXR0aW5ncyBhcmUgb3JkZXJlZCBNU0ItdG8tTFNC
IGFuZCBpbmNsdWRlIGEgb25lLWxpbmUgDQpjb21tZW50IHRoYXQgc2F5cyB0aGF0IEcyMDBT
RSBuZWVkcyB0byBzZXQgdGhpcyBiaXQgdW5jb25kaXRpb25hbGx5Lg0KDQpCZXN0IHJlZ2Fy
ZHMNClRob21hcw0KDQoNCg0KPiAgIAl4cGl4cGxsY24gPSBwaXhwbGxjbjsNCj4gICAJeHBp
eHBsbGNwID0gKHBpeHBsbGNzIDw8IDMpIHwgcGl4cGxsY3A7DQo+ICAgDQoNCi0tIA0KVGhv
bWFzIFppbW1lcm1hbm4NCkdyYXBoaWNzIERyaXZlciBEZXZlbG9wZXINClNVU0UgU29mdHdh
cmUgU29sdXRpb25zIEdlcm1hbnkgR21iSA0KTWF4ZmVsZHN0ci4gNSwgOTA0MDkgTsO8cm5i
ZXJnLCBHZXJtYW55DQooSFJCIDM2ODA5LCBBRyBOw7xybmJlcmcpDQpHZXNjaMOkZnRzZsO8
aHJlcjogSXZvIFRvdGV2DQo=

--------------WiH907b0Dg84Bth0iAwE05Yl--

--------------GpuivNAmFfuBmweK0LBdPmEP
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmNH1NAFAwAAAAAACgkQlh/E3EQov+A9
0A/+JHeQjKYaMaeDmvTSyopfg9Ty3Xa2AKUJp9WuTKv9IODlSYsML120j+B2Sn/JNYKrn7XXv1nQ
5MYDXAvqqjY04kzG4yd1N/sieQm128+2nVa8ZSxmdzTY3WTeWNOrYrJXd4KKiwxA2rRxNkcmtVH/
eAP2ExwlayPuEHP2MH6TOq73C3lky/DH3YlDuB5/xHVCMHcCPqs5vVaA29sZ/9s4ZckICjTcSabE
IwgrP9qZ1i4xuwzuXvNRopkRhMhbk9fC3XOk9Hc9+2QNeOEsA81CbE/u9A392hiiI9Uy8Cw/g8O+
sfZ/P+oEZEjcG0n6xfoqCipCbeSGrtuhI0qp7+1eQ6DrK87Ihxt7WWYHBtE791Zp4V734PU38SWv
pD1i1FUi+HoAcVKWkJO+t1DVbUZ2wbfy29RJsLV+wM/B5bUCmVeFAAaJZgEre1M+baSbYavDlw36
8at0K1t3vsK86o2+Oh+rVBcwlbBWNG4HB3JnTDO7WB4K1wpT1uW+d8P8/MVnvVoe8XLDJivvqkij
z0A3JQZ+2xc6uP1F4vxH4WHgJupWp8+ksKQ22WrzviB+fE23XSKawXffLdis0jG9vyX+tJ8sGVFV
j4uWO2IC2bcOZ4cn08ktu3KPMe6Ht0ovm77RvJACUgJNdQyPYWkPaT7aDzRAT6Obe0TJgsEBLmCu
qyI=
=/znq
-----END PGP SIGNATURE-----

--------------GpuivNAmFfuBmweK0LBdPmEP--
