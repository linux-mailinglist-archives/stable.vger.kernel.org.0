Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 939D953FE4C
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 14:07:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240101AbiFGMHN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 08:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49410 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243364AbiFGMHN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 08:07:13 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CD02F5535
        for <stable@vger.kernel.org>; Tue,  7 Jun 2022 05:07:09 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 1540121B8D;
        Tue,  7 Jun 2022 12:07:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654603628; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c1bQnBhWdL+lbYa+9FjPGKaInr9kyAD5IicdEqPXFY4=;
        b=07IuWSPkfyNAvxoUbUwK5aMa9sHohl5/KWIO80tJ8Q4zfG3qi4wuNM6jNayFmCkB8mvkoB
        ctbma0haVSmfSIYk5vWEaSPuwODnboeqZrwJRaumBSEXr7vTP67x6rpZrvfJtoJeQhFfsE
        kM2I8WnIXLwxVj5ZD4mmuidqdaXGzs4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654603628;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=c1bQnBhWdL+lbYa+9FjPGKaInr9kyAD5IicdEqPXFY4=;
        b=KnSaON9HYbAFT10hbPzF1byxKLHRpiFOW4ui7GjG89SQI7e/Ozo++CaV03OxijWuFPazi1
        cmUBOOC2mlXDfcDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D875813638;
        Tue,  7 Jun 2022 12:07:07 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9/XoM2s/n2J9fgAAMHmgww
        (envelope-from <tzimmermann@suse.de>); Tue, 07 Jun 2022 12:07:07 +0000
Message-ID: <3528fa40-987f-2467-35a5-93397d968ee8@suse.de>
Date:   Tue, 7 Jun 2022 14:07:07 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH] drm/ast: Treat AST2600 like AST2500 in most places
Content-Language: en-US
To:     airlied@redhat.com, airlied@linux.ie, daniel@ffwll.ch,
        jfalempe@redhat.com, regressions@leemhuis.info,
        kuohsiang_chou@aspeedtech.com
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org
References: <20220607120248.31716-1-tzimmermann@suse.de>
From:   Thomas Zimmermann <tzimmermann@suse.de>
In-Reply-To: <20220607120248.31716-1-tzimmermann@suse.de>
Content-Type: multipart/signed; micalg=pgp-sha256;
 protocol="application/pgp-signature";
 boundary="------------jJOCF26mT16WvmHLNOab4GS5"
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--------------jJOCF26mT16WvmHLNOab4GS5
Content-Type: multipart/mixed; boundary="------------RCs0LEH3pGmmJaR9RdmS63Nc";
 protected-headers="v1"
From: Thomas Zimmermann <tzimmermann@suse.de>
To: airlied@redhat.com, airlied@linux.ie, daniel@ffwll.ch,
 jfalempe@redhat.com, regressions@leemhuis.info, kuohsiang_chou@aspeedtech.com
Cc: dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Message-ID: <3528fa40-987f-2467-35a5-93397d968ee8@suse.de>
Subject: Re: [PATCH] drm/ast: Treat AST2600 like AST2500 in most places
References: <20220607120248.31716-1-tzimmermann@suse.de>
In-Reply-To: <20220607120248.31716-1-tzimmermann@suse.de>

--------------RCs0LEH3pGmmJaR9RdmS63Nc
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: base64

Sm9jZWx5biwgZG8geW91IGhhdmUgYSB3YXkgb2YgZ2V0dGluZyB0aGlzIHBhdGNoIHRlc3Rl
ZD8NCg0KQW0gMDcuMDYuMjIgdW0gMTQ6MDIgc2NocmllYiBUaG9tYXMgWmltbWVybWFubjoN
Cj4gSW5jbHVkZSBBU1QyNjAwIGluIG1vc3Qgb2YgdGhlIGJyYW5jaGVzIGZvciBBU1QyNTAw
LiBUaGVyZWJ5IHJldmVydA0KPiBtb3N0IGVmZmVjdHMgb2YgY29tbWl0IGY5YmQwMGUwZWE5
ZCAoImRybS9hc3Q6IENyZWF0ZSBjaGlwIEFTVDI2MDAiKS4NCj4gDQo+IFRoZSBBU1QyNjAw
IHVzZWQgdG8gYmUgdHJlYXRlZCBsaWtlIGFuIEFTVDI1MDAsIHdoaWNoIGF0IGxlYXN0IGdh
dmUNCj4gdXNhYmxlIGRpc3BsYXkgb3V0cHV0LiBBZnRlciBpbnRyb2R1Y2luZyBBU1QyNjAw
IGluIHRoZSBkcml2ZXIgd2l0aG91dA0KPiBmdXJ0aGVyIHVwZGF0ZXMsIGxvdHMgb2YgZnVu
Y3Rpb25zIHRha2UgdGhlIHdyb25nIGJyYW5jaGVzLg0KPiANCj4gSGFuZGxpbmcgQVNUMjYw
MCBpbiB0aGUgQVNUMjUwMCBicmFuY2hlcyByZXZlcnRzIGJhY2sgdG8gdGhlIG9yaWdpbmFs
DQo+IHNldHRpbmdzLiBUaGUgZXhjZXB0aW9uIGFyZSBjYXNlcyB3aGVyZSBBU1QyNjAwIG1l
YW53aGlsZSBnb3QgaXRzIG93bg0KPiBicmFuY2guDQo+IA0KPiBSZXBvcnRlZC1ieTogSm9j
ZWx5biBGYWxlbXBlIDxqZmFsZW1wZUByZWRoYXQuY29tPg0KPiBTaWduZWQtb2ZmLWJ5OiBU
aG9tYXMgWmltbWVybWFubiA8dHppbW1lcm1hbm5Ac3VzZS5kZT4NCj4gU3VnZ2VzdGVkLWJ5
OiBKb2NlbHluIEZhbGVtcGUgPGpmYWxlbXBlQHJlZGhhdC5jb20+DQo+IEZpeGVzOiBmOWJk
MDBlMGVhOWQgKCJkcm0vYXN0OiBDcmVhdGUgY2hpcCBBU1QyNjAwIikNCj4gQ2M6IEt1b0hz
aWFuZyBDaG91IDxrdW9oc2lhbmdfY2hvdUBhc3BlZWR0ZWNoLmNvbT4NCj4gQ2M6IERhdmUg
QWlybGllIDxhaXJsaWVkQHJlZGhhdC5jb20+DQo+IENjOiBkcmktZGV2ZWxAbGlzdHMuZnJl
ZWRlc2t0b3Aub3JnDQo+IENjOiA8c3RhYmxlQHZnZXIua2VybmVsLm9yZz4gIyB2NS4xMSsN
Cj4gLS0tDQo+ICAgZHJpdmVycy9ncHUvZHJtL2FzdC9hc3RfbWFpbi5jIHwgNCArKy0tDQo+
ICAgZHJpdmVycy9ncHUvZHJtL2FzdC9hc3RfbW9kZS5jIHwgNiArKystLS0NCj4gICBkcml2
ZXJzL2dwdS9kcm0vYXN0L2FzdF9wb3N0LmMgfCA2ICsrKy0tLQ0KPiAgIDMgZmlsZXMgY2hh
bmdlZCwgOCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQ0KPiANCj4gZGlmZiAtLWdp
dCBhL2RyaXZlcnMvZ3B1L2RybS9hc3QvYXN0X21haW4uYyBiL2RyaXZlcnMvZ3B1L2RybS9h
c3QvYXN0X21haW4uYw0KPiBpbmRleCBkNzcwZDVhMjNjMWEuLjU2YjJhYzEzODM3NSAxMDA2
NDQNCj4gLS0tIGEvZHJpdmVycy9ncHUvZHJtL2FzdC9hc3RfbWFpbi5jDQo+ICsrKyBiL2Ry
aXZlcnMvZ3B1L2RybS9hc3QvYXN0X21haW4uYw0KPiBAQCAtMzA3LDcgKzMwNyw3IEBAIHN0
YXRpYyBpbnQgYXN0X2dldF9kcmFtX2luZm8oc3RydWN0IGRybV9kZXZpY2UgKmRldikNCj4g
ICAJZGVmYXVsdDoNCj4gICAJCWFzdC0+ZHJhbV9idXNfd2lkdGggPSAxNjsNCj4gICAJCWFz
dC0+ZHJhbV90eXBlID0gQVNUX0RSQU1fMUd4MTY7DQo+IC0JCWlmIChhc3QtPmNoaXAgPT0g
QVNUMjUwMCkNCj4gKwkJaWYgKChhc3QtPmNoaXAgPT0gQVNUMjUwMCkgfHwgKGFzdC0+Y2hp
cCA9PSBBU1QyNjAwKSkNCj4gICAJCQlhc3QtPm1jbGsgPSA4MDA7DQo+ICAgCQllbHNlDQo+
ICAgCQkJYXN0LT5tY2xrID0gMzk2Ow0KPiBAQCAtMzE5LDcgKzMxOSw3IEBAIHN0YXRpYyBp
bnQgYXN0X2dldF9kcmFtX2luZm8oc3RydWN0IGRybV9kZXZpY2UgKmRldikNCj4gICAJZWxz
ZQ0KPiAgIAkJYXN0LT5kcmFtX2J1c193aWR0aCA9IDMyOw0KPiAgIA0KPiAtCWlmIChhc3Qt
PmNoaXAgPT0gQVNUMjUwMCkgew0KPiArCWlmICgoYXN0LT5jaGlwID09IEFTVDI2MDApIHx8
IChhc3QtPmNoaXAgPT0gQVNUMjUwMCkpIHsNCj4gICAJCXN3aXRjaCAobWNyX2NmZyAmIDB4
MDMpIHsNCj4gICAJCWNhc2UgMDoNCj4gICAJCQlhc3QtPmRyYW1fdHlwZSA9IEFTVF9EUkFN
XzFHeDE2Ow0KPiBkaWZmIC0tZ2l0IGEvZHJpdmVycy9ncHUvZHJtL2FzdC9hc3RfbW9kZS5j
IGIvZHJpdmVycy9ncHUvZHJtL2FzdC9hc3RfbW9kZS5jDQo+IGluZGV4IDMyM2FmMjc0NmFh
OS4uMWRkZTMwYjk4MzE3IDEwMDY0NA0KPiAtLS0gYS9kcml2ZXJzL2dwdS9kcm0vYXN0L2Fz
dF9tb2RlLmMNCj4gKysrIGIvZHJpdmVycy9ncHUvZHJtL2FzdC9hc3RfbW9kZS5jDQo+IEBA
IC0zMTAsNyArMzEwLDcgQEAgc3RhdGljIHZvaWQgYXN0X3NldF9jcnRjX3JlZyhzdHJ1Y3Qg
YXN0X3ByaXZhdGUgKmFzdCwNCj4gICAJdTgganJlZzA1ID0gMCwganJlZzA3ID0gMCwganJl
ZzA5ID0gMCwganJlZ0FDID0gMCwganJlZ0FEID0gMCwganJlZ0FFID0gMDsNCj4gICAJdTE2
IHRlbXAsIHByZWNhY2hlID0gMDsNCj4gICANCj4gLQlpZiAoKGFzdC0+Y2hpcCA9PSBBU1Qy
NTAwKSAmJg0KPiArCWlmICgoKGFzdC0+Y2hpcCA9PSBBU1QyNjAwKSB8fCAoYXN0LT5jaGlw
ID09IEFTVDI1MDApKSAmJg0KPiAgIAkgICAgKHZiaW9zX21vZGUtPmVuaF90YWJsZS0+Zmxh
Z3MgJiBBU1QyNTAwUHJlQ2F0Y2hDUlQpKQ0KPiAgIAkJcHJlY2FjaGUgPSA0MDsNCj4gICAN
Cj4gQEAgLTQyOCw3ICs0MjgsNyBAQCBzdGF0aWMgdm9pZCBhc3Rfc2V0X2RjbGtfcmVnKHN0
cnVjdCBhc3RfcHJpdmF0ZSAqYXN0LA0KPiAgIHsNCj4gICAJY29uc3Qgc3RydWN0IGFzdF92
Ymlvc19kY2xrX2luZm8gKmNsa19pbmZvOw0KPiAgIA0KPiAtCWlmIChhc3QtPmNoaXAgPT0g
QVNUMjUwMCkNCj4gKwlpZiAoKGFzdC0+Y2hpcCA9PSBBU1QyNjAwKSB8fCAoYXN0LT5jaGlw
ID09IEFTVDI1MDApKQ0KPiAgIAkJY2xrX2luZm8gPSAmZGNsa190YWJsZV9hc3QyNTAwW3Zi
aW9zX21vZGUtPmVuaF90YWJsZS0+ZGNsa19pbmRleF07DQo+ICAgCWVsc2UNCj4gICAJCWNs
a19pbmZvID0gJmRjbGtfdGFibGVbdmJpb3NfbW9kZS0+ZW5oX3RhYmxlLT5kY2xrX2luZGV4
XTsNCj4gQEAgLTQ3Niw3ICs0NzYsNyBAQCBzdGF0aWMgdm9pZCBhc3Rfc2V0X2NydHRoZF9y
ZWcoc3RydWN0IGFzdF9wcml2YXRlICphc3QpDQo+ICAgCQlhc3Rfc2V0X2luZGV4X3JlZyhh
c3QsIEFTVF9JT19DUlRDX1BPUlQsIDB4YTcsIDB4ZTApOw0KPiAgIAkJYXN0X3NldF9pbmRl
eF9yZWcoYXN0LCBBU1RfSU9fQ1JUQ19QT1JULCAweGE2LCAweGEwKTsNCj4gICAJfSBlbHNl
IGlmIChhc3QtPmNoaXAgPT0gQVNUMjMwMCB8fCBhc3QtPmNoaXAgPT0gQVNUMjQwMCB8fA0K
PiAtCSAgICBhc3QtPmNoaXAgPT0gQVNUMjUwMCkgew0KPiArCQkgICBhc3QtPmNoaXAgPT0g
QVNUMjUwMCB8fCBhc3QtPmNoaXAgPT0gQVNUMjYwMCkgew0KPiAgIAkJYXN0X3NldF9pbmRl
eF9yZWcoYXN0LCBBU1RfSU9fQ1JUQ19QT1JULCAweGE3LCAweDc4KTsNCj4gICAJCWFzdF9z
ZXRfaW5kZXhfcmVnKGFzdCwgQVNUX0lPX0NSVENfUE9SVCwgMHhhNiwgMHg2MCk7DQo+ICAg
CX0gZWxzZSBpZiAoYXN0LT5jaGlwID09IEFTVDIxMDAgfHwNCj4gZGlmZiAtLWdpdCBhL2Ry
aXZlcnMvZ3B1L2RybS9hc3QvYXN0X3Bvc3QuYyBiL2RyaXZlcnMvZ3B1L2RybS9hc3QvYXN0
X3Bvc3QuYw0KPiBpbmRleCAwYWE5Y2YwZmI1YzMuLmViMWZmOTA4NDAzNCAxMDA2NDQNCj4g
LS0tIGEvZHJpdmVycy9ncHUvZHJtL2FzdC9hc3RfcG9zdC5jDQo+ICsrKyBiL2RyaXZlcnMv
Z3B1L2RybS9hc3QvYXN0X3Bvc3QuYw0KPiBAQCAtODAsNyArODAsNyBAQCBhc3Rfc2V0X2Rl
Zl9leHRfcmVnKHN0cnVjdCBkcm1fZGV2aWNlICpkZXYpDQo+ICAgCQlhc3Rfc2V0X2luZGV4
X3JlZyhhc3QsIEFTVF9JT19DUlRDX1BPUlQsIGksIDB4MDApOw0KPiAgIA0KPiAgIAlpZiAo
YXN0LT5jaGlwID09IEFTVDIzMDAgfHwgYXN0LT5jaGlwID09IEFTVDI0MDAgfHwNCj4gLQkg
ICAgYXN0LT5jaGlwID09IEFTVDI1MDApIHsNCj4gKwkgICAgYXN0LT5jaGlwID09IEFTVDI1
MDAgfHwgYXN0LT5jaGlwID09IEFTVDI2MDApIHsNCj4gICAJCWlmIChwZGV2LT5yZXZpc2lv
biA+PSAweDIwKQ0KPiAgIAkJCWV4dF9yZWdfaW5mbyA9IGV4dHJlZ2luZm9fYXN0MjMwMDsN
Cj4gICAJCWVsc2UNCj4gQEAgLTEwNSw3ICsxMDUsNyBAQCBhc3Rfc2V0X2RlZl9leHRfcmVn
KHN0cnVjdCBkcm1fZGV2aWNlICpkZXYpDQo+ICAgCS8qIEVuYWJsZSBSQU1EQUMgZm9yIEEx
ICovDQo+ICAgCXJlZyA9IDB4MDQ7DQo+ICAgCWlmIChhc3QtPmNoaXAgPT0gQVNUMjMwMCB8
fCBhc3QtPmNoaXAgPT0gQVNUMjQwMCB8fA0KPiAtCSAgICBhc3QtPmNoaXAgPT0gQVNUMjUw
MCkNCj4gKwkgICAgYXN0LT5jaGlwID09IEFTVDI1MDAgfHwgYXN0LT5jaGlwID09IEFTVDI2
MDApDQo+ICAgCQlyZWcgfD0gMHgyMDsNCj4gICAJYXN0X3NldF9pbmRleF9yZWdfbWFzayhh
c3QsIEFTVF9JT19DUlRDX1BPUlQsIDB4YjYsIDB4ZmYsIHJlZyk7DQo+ICAgfQ0KPiBAQCAt
MzgyLDcgKzM4Miw3IEBAIHZvaWQgYXN0X3Bvc3RfZ3B1KHN0cnVjdCBkcm1fZGV2aWNlICpk
ZXYpDQo+ICAgCWlmIChhc3QtPmNoaXAgPT0gQVNUMjYwMCkgew0KPiAgIAkJYXN0X2RwX2xh
dW5jaChkZXYsIDEpOw0KPiAgIAl9IGVsc2UgaWYgKGFzdC0+Y29uZmlnX21vZGUgPT0gYXN0
X3VzZV9wMmEpIHsNCj4gLQkJaWYgKGFzdC0+Y2hpcCA9PSBBU1QyNTAwKQ0KPiArCQlpZiAo
YXN0LT5jaGlwID09IEFTVDI1MDAgfHwgYXN0LT5jaGlwID09IEFTVDI2MDApDQo+ICAgCQkJ
YXN0X3Bvc3RfY2hpcF8yNTAwKGRldik7DQo+ICAgCQllbHNlIGlmIChhc3QtPmNoaXAgPT0g
QVNUMjMwMCB8fCBhc3QtPmNoaXAgPT0gQVNUMjQwMCkNCj4gICAJCQlhc3RfcG9zdF9jaGlw
XzIzMDAoZGV2KTsNCg0KLS0gDQpUaG9tYXMgWmltbWVybWFubg0KR3JhcGhpY3MgRHJpdmVy
IERldmVsb3Blcg0KU1VTRSBTb2Z0d2FyZSBTb2x1dGlvbnMgR2VybWFueSBHbWJIDQpNYXhm
ZWxkc3RyLiA1LCA5MDQwOSBOw7xybmJlcmcsIEdlcm1hbnkNCihIUkIgMzY4MDksIEFHIE7D
vHJuYmVyZykNCkdlc2Now6RmdHNmw7xocmVyOiBJdm8gVG90ZXYNCg==

--------------RCs0LEH3pGmmJaR9RdmS63Nc--

--------------jJOCF26mT16WvmHLNOab4GS5
Content-Type: application/pgp-signature; name="OpenPGP_signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="OpenPGP_signature"

-----BEGIN PGP SIGNATURE-----

wsF5BAABCAAjFiEExndm/fpuMUdwYFFolh/E3EQov+AFAmKfP2sFAwAAAAAACgkQlh/E3EQov+AM
HBAAx28qGUKcxRmeqvjKsYT1FSN9TqD0uq5O+ijahCxzwOkI5T+GM8VZwDrN/od+iHxaFYNA23hX
YzlpwrfF89+EccJYltYL/VDikUWFz6T7HKQ7aJyCKYpfquoumGOqYQ8kzN76YcEoHQk1q7JVgRc2
3sFZJYKlDXcQQosZy9vBygVE0pGF/tosWx4usCToHwxKqzwvUO8GVkk3qyCP7FHIeUt7dyequAR7
ISzRWjl4DkVaKltaB6YWUej7XsAz+6uaL5WuAF3fhsc2lCKrhpJuQM9oJhlad39AWwGnnHUH6Ntk
hLH3Rm6wdMJyJ9IIBIjfVc9gQIE6ksByZucPQwOJ6uTuHr/0R6M4T2N9mk/NpRzHIOmA2LsMxA5Q
2l4rQiY3RMdQZyo5im6zYn3J0N56IPr6+Noear9sUCWJvpchy4UAOrUjjUMlQWPL5HGSSIQILqwP
0hBj0kxem/Ose4gxTCnkEg5Lq8WAxs2kDJ5+T8lvA74kiDae50XUI6ZDIthAzQcATxfXcgBUWW1o
498N9dOeIpLpklYO/KVfBQSMEjf7hQ4Y3Kj6FO6rQF5JoWoAwaGqXJAQYnbScNmsTC9jQnxd5fEK
wnPZ3E9w4C2b+ZqYT/w1FtF//3dLl6qrvdh5dRY1uw8CxIzaiV3kaIwj+/HMuDU/EmEC2mhbh4Z0
zH8=
=8WAC
-----END PGP SIGNATURE-----

--------------jJOCF26mT16WvmHLNOab4GS5--
