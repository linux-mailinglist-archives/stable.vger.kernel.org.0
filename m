Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D0964D3AAE
	for <lists+stable@lfdr.de>; Wed,  9 Mar 2022 20:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236702AbiCIT7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Mar 2022 14:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238012AbiCIT7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Mar 2022 14:59:20 -0500
Received: from maynard.decadent.org.uk (maynard.decadent.org.uk [95.217.213.242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70663FD0A;
        Wed,  9 Mar 2022 11:58:20 -0800 (PST)
Received: from 168.7-181-91.adsl-dyn.isp.belgacom.be ([91.181.7.168] helo=deadeye)
        by maynard with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <ben@decadent.org.uk>)
        id 1nS2Rr-0004SP-Qh; Wed, 09 Mar 2022 20:58:15 +0100
Received: from ben by deadeye with local (Exim 4.95)
        (envelope-from <ben@decadent.org.uk>)
        id 1nS2Rr-001v80-5Z;
        Wed, 09 Mar 2022 20:58:15 +0100
Message-ID: <ab991a7ac7215fa18ba83698df2450c1c2ded334.camel@decadent.org.uk>
Subject: Re: [PATCH 4.9 02/24] x86/retpoline: Make CONFIG_RETPOLINE depend
 on compiler support
From:   Ben Hutchings <ben@decadent.org.uk>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Zhenzhong Duan <zhenzhong.duan@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        David Woodhouse <dwmw@amazon.co.uk>,
        Borislav Petkov <bp@suse.de>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andy Lutomirski <luto@kernel.org>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Michal Marek <michal.lkml@markovi.net>,
        srinivas.eeda@oracle.com
Date:   Wed, 09 Mar 2022 20:58:06 +0100
In-Reply-To: <20220309155856.369868546@linuxfoundation.org>
References: <20220309155856.295480966@linuxfoundation.org>
         <20220309155856.369868546@linuxfoundation.org>
Content-Type: multipart/signed; micalg="pgp-sha512";
        protocol="application/pgp-signature"; boundary="=-CCz8BWjCcEYeZ76+WFxi"
User-Agent: Evolution 3.43.2-2 
MIME-Version: 1.0
X-SA-Exim-Connect-IP: 91.181.7.168
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on maynard); SAEximRunCond expanded to false
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


--=-CCz8BWjCcEYeZ76+WFxi
Content-Type: multipart/mixed; boundary="=-LoQ5FDBrWs6+RundTfOg"

--=-LoQ5FDBrWs6+RundTfOg
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2022-03-09 at 16:59 +0100, Greg Kroah-Hartman wrote:
> From: Zhenzhong Duan <zhenzhong.duan@oracle.com>
>=20
> commit 4cd24de3a0980bf3100c9dcb08ef65ca7c31af48 upstream.
[...]

Sorry, there are a couple of fixes needed on top of this:

commit 25896d073d8a0403b07e6dec56f58e6c33678207
Author: Masahiro Yamada <yamada.masahiro@socionext.com>
Date:   Wed Dec 5 15:27:19 2018 +0900
=20
    x86/build: Fix compiler support check for CONFIG_RETPOLINE

commit e4f358916d528d479c3c12bd2fd03f2d5a576380
Author: WANG Chao <chao.wang@ucloud.cn>
Date:   Tue Dec 11 00:37:25 2018 +0800
=20
    x86, modpost: Replace last remnants of RETPOLINE with CONFIG_RETPOLINE

I've attached my backports of those.

Ben.

--=20
Ben Hutchings
73.46% of all statistics are made up.

--=-LoQ5FDBrWs6+RundTfOg
Content-Disposition: attachment;
	filename*0=0001-x86-build-Fix-compiler-support-check-for-CONFIG_RETP.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0001-x86-build-Fix-compiler-support-check-for-CONFIG_RETP.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSAzN2NkMTliMGUxZTcwNTkyZDNkNTQ3MzYwYmY5NzlmNjk1MTRmM2MxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBNYXNhaGlybyBZYW1hZGEgPHlhbWFkYS5tYXNhaGlyb0Bzb2Np
b25leHQuY29tPgpEYXRlOiBXZWQsIDUgRGVjIDIwMTggMTU6Mjc6MTkgKzA5MDAKU3ViamVjdDog
W1BBVENIIDEvMl0geDg2L2J1aWxkOiBGaXggY29tcGlsZXIgc3VwcG9ydCBjaGVjayBmb3IKIENP
TkZJR19SRVRQT0xJTkUKCmNvbW1pdCAyNTg5NmQwNzNkOGEwNDAzYjA3ZTZkZWM1NmY1OGU2YzMz
Njc4MjA3IHVwc3RyZWFtLgoKSXQgaXMgdHJvdWJsZXNvbWUgdG8gYWRkIGEgZGlhZ25vc3RpYyBs
aWtlIHRoaXMgdG8gdGhlIE1ha2VmaWxlCnBhcnNlIHN0YWdlIGJlY2F1c2UgdGhlIHRvcC1sZXZl
bCBNYWtlZmlsZSBjb3VsZCBiZSBwYXJzZWQgd2l0aAphIHN0YWxlIGluY2x1ZGUvY29uZmlnL2F1
dG8uY29uZi4KCk9uY2UgeW91IGFyZSBoaXQgYnkgdGhlIGVycm9yIGFib3V0IG5vbi1yZXRwb2xp
bmUgY29tcGlsZXIsIHRoZQpjb21waWxhdGlvbiBzdGlsbCBicmVha3MgZXZlbiBhZnRlciBkaXNh
YmxpbmcgQ09ORklHX1JFVFBPTElORS4KClRoZSBlYXNpZXN0IGZpeCBpcyB0byBtb3ZlIHRoaXMg
Y2hlY2sgdG8gdGhlICJhcmNocHJlcGFyZSIgbGlrZQp0aGlzIGNvbW1pdCBkaWQ6CgogIDgyOWZl
NGFhOWFjMSAoIng4NjogQWxsb3cgZ2VuZXJhdGluZyB1c2VyLXNwYWNlIGhlYWRlcnMgd2l0aG91
dCBhIGNvbXBpbGVyIikKClJlcG9ydGVkLWJ5OiBNZWVsaXMgUm9vcyA8bXJvb3NAbGludXguZWU+
ClRlc3RlZC1ieTogTWVlbGlzIFJvb3MgPG1yb29zQGxpbnV4LmVlPgpTaWduZWQtb2ZmLWJ5OiBN
YXNhaGlybyBZYW1hZGEgPHlhbWFkYS5tYXNhaGlyb0Bzb2Npb25leHQuY29tPgpBY2tlZC1ieTog
Wmhlbnpob25nIER1YW4gPHpoZW56aG9uZy5kdWFuQG9yYWNsZS5jb20+CkNjOiBCb3Jpc2xhdiBQ
ZXRrb3YgPGJwQGFsaWVuOC5kZT4KQ2M6IExpbnVzIFRvcnZhbGRzIDx0b3J2YWxkc0BsaW51eC1m
b3VuZGF0aW9uLm9yZz4KQ2M6IFBldGVyIFppamxzdHJhIDxwZXRlcnpAaW5mcmFkZWFkLm9yZz4K
Q2M6IFRob21hcyBHbGVpeG5lciA8dGdseEBsaW51dHJvbml4LmRlPgpDYzogWmhlbnpob25nIER1
YW4gPHpoZW56aG9uZy5kdWFuQG9yYWNsZS5jb20+CkZpeGVzOiA0Y2QyNGRlM2EwOTggKCJ4ODYv
cmV0cG9saW5lOiBNYWtlIENPTkZJR19SRVRQT0xJTkUgZGVwZW5kIG9uIGNvbXBpbGVyIHN1cHBv
cnQiKQpMaW5rOiBodHRwOi8vbGttbC5rZXJuZWwub3JnL3IvMTU0Mzk5MTIzOS0xODQ3Ni0xLWdp
dC1zZW5kLWVtYWlsLXlhbWFkYS5tYXNhaGlyb0Bzb2Npb25leHQuY29tCkxpbms6IGh0dHBzOi8v
bGttbC5vcmcvbGttbC8yMDE4LzEyLzQvMjA2ClNpZ25lZC1vZmYtYnk6IEluZ28gTW9sbmFyIDxt
aW5nb0BrZXJuZWwub3JnPgpbYndoOiBCYWNrcG9ydGVkIHRvIDQuOTogYWRqdXN0IGNvbnRleHRd
ClNpZ25lZC1vZmYtYnk6IEJlbiBIdXRjaGluZ3MgPGJlbkBkZWNhZGVudC5vcmcudWs+Ci0tLQog
YXJjaC94ODYvTWFrZWZpbGUgfCAxMCArKysrKysrLS0tCiAxIGZpbGUgY2hhbmdlZCwgNyBpbnNl
cnRpb25zKCspLCAzIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L01ha2VmaWxl
IGIvYXJjaC94ODYvTWFrZWZpbGUKaW5kZXggYTY5Y2ZhMzNmOTg2Li5hNzc3MzdhOTc5YzggMTAw
NjQ0Ci0tLSBhL2FyY2gveDg2L01ha2VmaWxlCisrKyBiL2FyY2gveDg2L01ha2VmaWxlCkBAIC0y
MjEsOSArMjIxLDYgQEAgaWZkZWYgQ09ORklHX1JFVFBPTElORQogICAgIFJFVFBPTElORV9DRkxB
R1NfQ0xBTkcgOj0gLW1yZXRwb2xpbmUtZXh0ZXJuYWwtdGh1bmsKIAogICAgIFJFVFBPTElORV9D
RkxBR1MgKz0gJChjYWxsIGNjLW9wdGlvbiwkKFJFVFBPTElORV9DRkxBR1NfR0NDKSwkKGNhbGwg
Y2Mtb3B0aW9uLCQoUkVUUE9MSU5FX0NGTEFHU19DTEFORykpKQotICAgIGlmZXEgKCQoUkVUUE9M
SU5FX0NGTEFHUyksKQotICAgICAgJChlcnJvciBZb3UgYXJlIGJ1aWxkaW5nIGtlcm5lbCB3aXRo
IG5vbi1yZXRwb2xpbmUgY29tcGlsZXIsIHBsZWFzZSB1cGRhdGUgeW91ciBjb21waWxlci4pCi0g
ICAgZW5kaWYKICAgICBLQlVJTERfQ0ZMQUdTICs9ICQoUkVUUE9MSU5FX0NGTEFHUykKIGVuZGlm
CiAKQEAgLTI0MCw2ICsyMzcsMTMgQEAgYXJjaHNjcmlwdHM6IHNjcmlwdHNfYmFzaWMKIGlmZXEg
KCQoQ09ORklHX0tFWEVDX0ZJTEUpLHkpCiAJJChRKSQoTUFLRSkgJChidWlsZCk9YXJjaC94ODYv
cHVyZ2F0b3J5IGFyY2gveDg2L3B1cmdhdG9yeS9rZXhlYy1wdXJnYXRvcnkuYwogZW5kaWYKK2lm
ZGVmIENPTkZJR19SRVRQT0xJTkUKK2lmZXEgKCQoUkVUUE9MSU5FX0NGTEFHUyksKQorCUBlY2hv
ICJZb3UgYXJlIGJ1aWxkaW5nIGtlcm5lbCB3aXRoIG5vbi1yZXRwb2xpbmUgY29tcGlsZXIuIiA+
JjIKKwlAZWNobyAiUGxlYXNlIHVwZGF0ZSB5b3VyIGNvbXBpbGVyLiIgPiYyCisJQGZhbHNlCitl
bmRpZgorZW5kaWYKIAogIyMjCiAjIEtlcm5lbCBvYmplY3RzCg==


--=-LoQ5FDBrWs6+RundTfOg
Content-Disposition: attachment;
	filename*0=0002-x86-modpost-Replace-last-remnants-of-RETPOLINE-with-.pat;
	filename*1=ch
Content-Type: text/x-patch;
	name="0002-x86-modpost-Replace-last-remnants-of-RETPOLINE-with-.patch";
	charset="UTF-8"
Content-Transfer-Encoding: base64

RnJvbSA3ZTk1ZTI5ZWI1NDFhNjJkNTBkZjAxYzhjNTJmM2Q3NWQxM2E2YmVjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBXQU5HIENoYW8gPGNoYW8ud2FuZ0B1Y2xvdWQuY24+CkRhdGU6
IFR1ZSwgMTEgRGVjIDIwMTggMDA6Mzc6MjUgKzA4MDAKU3ViamVjdDogW1BBVENIIDIvMl0geDg2
LCBtb2Rwb3N0OiBSZXBsYWNlIGxhc3QgcmVtbmFudHMgb2YgUkVUUE9MSU5FIHdpdGgKIENPTkZJ
R19SRVRQT0xJTkUKCmNvbW1pdCBlNGYzNTg5MTZkNTI4ZDQ3OWMzYzEyYmQyZmQwM2YyZDVhNTc2
MzgwIHVwc3RyZWFtLgoKQ29tbWl0CgogIDRjZDI0ZGUzYTA5OCAoIng4Ni9yZXRwb2xpbmU6IE1h
a2UgQ09ORklHX1JFVFBPTElORSBkZXBlbmQgb24gY29tcGlsZXIgc3VwcG9ydCIpCgpyZXBsYWNl
ZCB0aGUgUkVUUE9MSU5FIGRlZmluZSB3aXRoIENPTkZJR19SRVRQT0xJTkUgY2hlY2tzLiBSZW1v
dmUgdGhlCnJlbWFpbmluZyBwaWVjZXMuCgogWyBicDogTWFzc2FnZSBjb21taXQgbWVzc2FnZS4g
XQoKRml4ZXM6IDRjZDI0ZGUzYTA5OCAoIng4Ni9yZXRwb2xpbmU6IE1ha2UgQ09ORklHX1JFVFBP
TElORSBkZXBlbmQgb24gY29tcGlsZXIgc3VwcG9ydCIpClNpZ25lZC1vZmYtYnk6IFdBTkcgQ2hh
byA8Y2hhby53YW5nQHVjbG91ZC5jbj4KU2lnbmVkLW9mZi1ieTogQm9yaXNsYXYgUGV0a292IDxi
cEBzdXNlLmRlPgpSZXZpZXdlZC1ieTogWmhlbnpob25nIER1YW4gPHpoZW56aG9uZy5kdWFuQG9y
YWNsZS5jb20+ClJldmlld2VkLWJ5OiBNYXNhaGlybyBZYW1hZGEgPHlhbWFkYS5tYXNhaGlyb0Bz
b2Npb25leHQuY29tPgpDYzogIkguIFBldGVyIEFudmluIiA8aHBhQHp5dG9yLmNvbT4KQ2M6IEFu
ZGkgS2xlZW4gPGFrQGxpbnV4LmludGVsLmNvbT4KQ2M6IEFuZHJldyBNb3J0b24gPGFrcG1AbGlu
dXgtZm91bmRhdGlvbi5vcmc+CkNjOiBBbmR5IEx1dG9taXJza2kgPGx1dG9Aa2VybmVsLm9yZz4K
Q2M6IEFybmQgQmVyZ21hbm4gPGFybmRAYXJuZGIuZGU+CkNjOiBEYW5pZWwgQm9ya21hbm4gPGRh
bmllbEBpb2dlYXJib3gubmV0PgpDYzogRGF2aWQgV29vZGhvdXNlIDxkd213QGFtYXpvbi5jby51
az4KQ2M6IEdlZXJ0IFV5dHRlcmhvZXZlbiA8Z2VlcnRAbGludXgtbTY4ay5vcmc+CkNjOiBKZXNz
aWNhIFl1IDxqZXl1QGtlcm5lbC5vcmc+CkNjOiBKaXJpIEtvc2luYSA8amtvc2luYUBzdXNlLmN6
PgpDYzogS2VlcyBDb29rIDxrZWVzY29va0BjaHJvbWl1bS5vcmc+CkNjOiBLb25yYWQgUnplc3p1
dGVrIFdpbGsgPGtvbnJhZC53aWxrQG9yYWNsZS5jb20+CkNjOiBMdWMgVmFuIE9vc3RlbnJ5Y2sg
PGx1Yy52YW5vb3N0ZW5yeWNrQGdtYWlsLmNvbT4KQ2M6IE1pY2hhbCBNYXJlayA8bWljaGFsLmxr
bWxAbWFya292aS5uZXQ+CkNjOiBNaWd1ZWwgT2plZGEgPG1pZ3VlbC5vamVkYS5zYW5kb25pc0Bn
bWFpbC5jb20+CkNjOiBQZXRlciBaaWpsc3RyYSA8cGV0ZXJ6QGluZnJhZGVhZC5vcmc+CkNjOiBU
aW0gQ2hlbiA8dGltLmMuY2hlbkBsaW51eC5pbnRlbC5jb20+CkNjOiBWYXNpbHkgR29yYmlrIDxn
b3JAbGludXguaWJtLmNvbT4KQ2M6IGxpbnV4LWtidWlsZEB2Z2VyLmtlcm5lbC5vcmcKQ2M6IHNy
aW5pdmFzLmVlZGFAb3JhY2xlLmNvbQpDYzogc3RhYmxlIDxzdGFibGVAdmdlci5rZXJuZWwub3Jn
PgpDYzogeDg2LW1sIDx4ODZAa2VybmVsLm9yZz4KTGluazogaHR0cHM6Ly9sa21sLmtlcm5lbC5v
cmcvci8yMDE4MTIxMDE2MzcyNS45NTk3Ny0xLWNoYW8ud2FuZ0B1Y2xvdWQuY24KW2J3aDogQmFj
a3BvcnRlZCB0byA0Ljk6IGFkanVzdCBjb250ZXh0XQpTaWduZWQtb2ZmLWJ5OiBCZW4gSHV0Y2hp
bmdzIDxiZW5AZGVjYWRlbnQub3JnLnVrPgotLS0KIGFyY2gveDg2L2tlcm5lbC9jcHUvYnVncy5j
ICAgfCAyICstCiBpbmNsdWRlL2xpbnV4L2NvbXBpbGVyLWdjYy5oIHwgMiArLQogaW5jbHVkZS9s
aW51eC9tb2R1bGUuaCAgICAgICB8IDIgKy0KIHNjcmlwdHMvbW9kL21vZHBvc3QuYyAgICAgICAg
fCAyICstCiA0IGZpbGVzIGNoYW5nZWQsIDQgaW5zZXJ0aW9ucygrKSwgNCBkZWxldGlvbnMoLSkK
CmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2J1Z3MuYyBiL2FyY2gveDg2L2tlcm5l
bC9jcHUvYnVncy5jCmluZGV4IDIwYjMzMDkwMmU1NC4uOTRhYTAyMDZiMWY5IDEwMDY0NAotLS0g
YS9hcmNoL3g4Ni9rZXJuZWwvY3B1L2J1Z3MuYworKysgYi9hcmNoL3g4Ni9rZXJuZWwvY3B1L2J1
Z3MuYwpAQCAtNTg2LDcgKzU4Niw3IEBAIHN0YXRpYyBlbnVtIHNwZWN0cmVfdjJfdXNlcl9taXRp
Z2F0aW9uIHNwZWN0cmVfdjJfdXNlcl9zdGlicCBfX3JvX2FmdGVyX2luaXQgPQogc3RhdGljIGVu
dW0gc3BlY3RyZV92Ml91c2VyX21pdGlnYXRpb24gc3BlY3RyZV92Ml91c2VyX2licGIgX19yb19h
ZnRlcl9pbml0ID0KIAlTUEVDVFJFX1YyX1VTRVJfTk9ORTsKIAotI2lmZGVmIFJFVFBPTElORQor
I2lmZGVmIENPTkZJR19SRVRQT0xJTkUKIHN0YXRpYyBib29sIHNwZWN0cmVfdjJfYmFkX21vZHVs
ZTsKIAogYm9vbCByZXRwb2xpbmVfbW9kdWxlX29rKGJvb2wgaGFzX3JldHBvbGluZSkKZGlmZiAt
LWdpdCBhL2luY2x1ZGUvbGludXgvY29tcGlsZXItZ2NjLmggYi9pbmNsdWRlL2xpbnV4L2NvbXBp
bGVyLWdjYy5oCmluZGV4IGQ4MzBlZGRhY2RjNi4uMWMxY2E0MTY4NTE2IDEwMDY0NAotLS0gYS9p
bmNsdWRlL2xpbnV4L2NvbXBpbGVyLWdjYy5oCisrKyBiL2luY2x1ZGUvbGludXgvY29tcGlsZXIt
Z2NjLmgKQEAgLTEwNyw3ICsxMDcsNyBAQAogI2RlZmluZSBfX3dlYWsJCV9fYXR0cmlidXRlX18o
KHdlYWspKQogI2RlZmluZSBfX2FsaWFzKHN5bWJvbCkJX19hdHRyaWJ1dGVfXygoYWxpYXMoI3N5
bWJvbCkpKQogCi0jaWZkZWYgUkVUUE9MSU5FCisjaWZkZWYgQ09ORklHX1JFVFBPTElORQogI2Rl
ZmluZSBfX25vcmV0cG9saW5lIF9fYXR0cmlidXRlX18oKGluZGlyZWN0X2JyYW5jaCgia2VlcCIp
KSkKICNlbmRpZgogCmRpZmYgLS1naXQgYS9pbmNsdWRlL2xpbnV4L21vZHVsZS5oIGIvaW5jbHVk
ZS9saW51eC9tb2R1bGUuaAppbmRleCA5OWYzMzBhZTEzZGEuLmJlNGEzYTlmZDg5YyAxMDA2NDQK
LS0tIGEvaW5jbHVkZS9saW51eC9tb2R1bGUuaAorKysgYi9pbmNsdWRlL2xpbnV4L21vZHVsZS5o
CkBAIC03OTEsNyArNzkxLDcgQEAgc3RhdGljIGlubGluZSB2b2lkIG1vZHVsZV9idWdfZmluYWxp
emUoY29uc3QgRWxmX0VoZHIgKmhkciwKIHN0YXRpYyBpbmxpbmUgdm9pZCBtb2R1bGVfYnVnX2Ns
ZWFudXAoc3RydWN0IG1vZHVsZSAqbW9kKSB7fQogI2VuZGlmCS8qIENPTkZJR19HRU5FUklDX0JV
RyAqLwogCi0jaWZkZWYgUkVUUE9MSU5FCisjaWZkZWYgQ09ORklHX1JFVFBPTElORQogZXh0ZXJu
IGJvb2wgcmV0cG9saW5lX21vZHVsZV9vayhib29sIGhhc19yZXRwb2xpbmUpOwogI2Vsc2UKIHN0
YXRpYyBpbmxpbmUgYm9vbCByZXRwb2xpbmVfbW9kdWxlX29rKGJvb2wgaGFzX3JldHBvbGluZSkK
ZGlmZiAtLWdpdCBhL3NjcmlwdHMvbW9kL21vZHBvc3QuYyBiL3NjcmlwdHMvbW9kL21vZHBvc3Qu
YwppbmRleCA5YWJjZGYyZThkZmUuLjYyYjA1NTJiN2I3MSAxMDA2NDQKLS0tIGEvc2NyaXB0cy9t
b2QvbW9kcG9zdC5jCisrKyBiL3NjcmlwdHMvbW9kL21vZHBvc3QuYwpAQCAtMjE0Nyw3ICsyMTQ3
LDcgQEAgc3RhdGljIHZvaWQgYWRkX2ludHJlZV9mbGFnKHN0cnVjdCBidWZmZXIgKmIsIGludCBp
c19pbnRyZWUpCiAvKiBDYW5ub3QgY2hlY2sgZm9yIGFzc2VtYmxlciAqLwogc3RhdGljIHZvaWQg
YWRkX3JldHBvbGluZShzdHJ1Y3QgYnVmZmVyICpiKQogewotCWJ1Zl9wcmludGYoYiwgIlxuI2lm
ZGVmIFJFVFBPTElORVxuIik7CisJYnVmX3ByaW50ZihiLCAiXG4jaWZkZWYgQ09ORklHX1JFVFBP
TElORVxuIik7CiAJYnVmX3ByaW50ZihiLCAiTU9EVUxFX0lORk8ocmV0cG9saW5lLCBcIllcIik7
XG4iKTsKIAlidWZfcHJpbnRmKGIsICIjZW5kaWZcbiIpOwogfQo=


--=-LoQ5FDBrWs6+RundTfOg--

--=-CCz8BWjCcEYeZ76+WFxi
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEErCspvTSmr92z9o8157/I7JWGEQkFAmIpBs4ACgkQ57/I7JWG
EQm9SA/+IG+hmC/QJq16uQ6IZh79trbQWYQi7qc/akpYtlVVxasf6gCmzBYWXFqF
pR+YuADFY7DbaUVJnryO83cpDqYRN+JTpZuey67xnhv+gBeJJunY9OeGVmWUAc6r
Y/4qjSa4WSC6qRC6X/e+bvNWyOXDrtS5f4bpOl5Tp2G/vGn3RGgcDh0dO9k9UM/6
D7KPw7MK6cAyi0cN/sSQRNc1FOkG3t+awmP1y1UEY7QQ8FCwB/xmVtpM1Y/sHIHy
z/kW+cCyCfsp4w6261TcugOAMJOP6FQriRXFsqQuhIprocY+8xQLLZK3JFzmRTjV
jcn3y/pKQXxwgFaE0nLkJR0PgwnBDKHjqgYK2Xwzesz8PRixmakPM7bQcIzqZzas
POREAUAYmE6VSFMZi8AgdVud13HujC1FL8jc9SgPNalx/8V7rJFHU8NHAECziZlV
5M6MHJjx2YPvi4dtcXNpzykEIDprwWh0zZjOMBp+7yqDCL1wSauGADhEvrEjrOhc
LOK+lgVDTRg+n4pJv+9U63F9OBkUJequ4CRkevdfhGze9LZhhDPwiPRsF3fNbAXU
1EHdl8jcOn6IeDxYgszlwjdFqoeIwNRd6Hosfo/FdMi7SA/4Tu1lVRGP4o9N/nfF
7liCOwi+V1d2EEYatqGWGWMmetIKqu2RPNeIyGXWjrO18X6Trjg=
=mbk2
-----END PGP SIGNATURE-----

--=-CCz8BWjCcEYeZ76+WFxi--
