Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9F1E8162E3D
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 19:18:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726595AbgBRSRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 13:17:54 -0500
Received: from mail-lj1-f193.google.com ([209.85.208.193]:32795 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726512AbgBRSRv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 13:17:51 -0500
Received: by mail-lj1-f193.google.com with SMTP id y6so24117366lji.0
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 10:17:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vkHg12+pkfjCrH0xKz1xddA4Ce0rSl7Bk5j9kTZ2CsA=;
        b=fDS5n0jSfMLHWoNzdaiy+EuQ+r0xoenmqK7VCFBRv9qa7ktNqUsFocJqITZTf9kPrD
         u/0xfazciVWSUcUdM8USsX8+i24FltjGxxqxDcSBsnyAuExTOqR4i08T3cq8ViuSsKTG
         TXTqJMhWXPfneiNOywCNBAXBYhv2k+DIgKNgI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vkHg12+pkfjCrH0xKz1xddA4Ce0rSl7Bk5j9kTZ2CsA=;
        b=Guc9W1dCka3ZXZFWPGOqLhcp/NvWh3IRB/XZzAl+HaQ6xim/XUQhSudQbmoVAZh7OK
         2KK+a8tpQMu8loAJF8sRkaKQCBV7FIPETCTNCOZNRcWMAZVgWLHhXxenzMdVAF843W/p
         LS9v+E7svgNtr1aZvnwz/VuGj3rbtn0MGMPYhZDen0qnOlCHdZnr1akdf5hn+pM0cio5
         8FavPyEjiiOZxZmPZ7R7Am7P+5JXghRuGzeKVuT8cUFFr0cxN8wuW6/V3V05IOHfJLSL
         PKkP0Zv3o3YHNgOWgu0C66rcp1g/JORXMh682jb9UFpsZJ472/X5xp9fEcC4gpHzqxfb
         izbw==
X-Gm-Message-State: APjAAAW69ebfW8uD1RL6ziijQhjj5h3y9/zamimjZq/frVKZqhOTew74
        MEeX/8Q2EpZJgcURDHzhCf1wCb2zPRA=
X-Google-Smtp-Source: APXvYqwFk0TaBzvp2BIMzAQsblJs6Ueorb94eRgb+xwqpRS7BJsmJaxLbkgXwGYYhqb3icGBNDlijA==
X-Received: by 2002:a2e:b4cf:: with SMTP id r15mr13659614ljm.52.1582049868893;
        Tue, 18 Feb 2020 10:17:48 -0800 (PST)
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com. [209.85.167.41])
        by smtp.gmail.com with ESMTPSA id l3sm2948119lja.78.2020.02.18.10.17.47
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 10:17:47 -0800 (PST)
Received: by mail-lf1-f41.google.com with SMTP id v201so15179850lfa.11
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 10:17:47 -0800 (PST)
X-Received: by 2002:ac2:456f:: with SMTP id k15mr11088292lfm.125.1582049867037;
 Tue, 18 Feb 2020 10:17:47 -0800 (PST)
MIME-Version: 1.0
References: <20200214154854.6746-1-sashal@kernel.org> <20200214154854.6746-542-sashal@kernel.org>
 <CANaxB-zjYecWpjMoX6dXY3B5HtVu8+G9npRnaX2FnTvp9XucTw@mail.gmail.com>
 <CAHk-=wjd6BKXEpU0MfEaHuOEK-StRToEcYuu6NpVfR0tR5d6xw@mail.gmail.com> <CAHk-=wgs8E4JYVJHaRV2hMn3dxUnM8i0Kn2mA1SjzJdsbB9tXw@mail.gmail.com>
In-Reply-To: <CAHk-=wgs8E4JYVJHaRV2hMn3dxUnM8i0Kn2mA1SjzJdsbB9tXw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 18 Feb 2020 10:17:30 -0800
X-Gmail-Original-Message-ID: <CAHk-=wiaDvYHBt8oyZGOp2XwJW4wNXVAchqTFuVBvASTFx_KfA@mail.gmail.com>
Message-ID: <CAHk-=wiaDvYHBt8oyZGOp2XwJW4wNXVAchqTFuVBvASTFx_KfA@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.5 542/542] pipe: use exclusive waits when
 reading or writing
To:     Andrei Vagin <avagin@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000057bf59059eddb0ac"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--00000000000057bf59059eddb0ac
Content-Type: text/plain; charset="UTF-8"

On Tue, Feb 18, 2020 at 9:54 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Anyway, new patch attached. This hasn't been tested either, but I'll
> let you know if it's broken too ;)

That one looks good. Some small cosmetic edits later, and with a
commit log it looks like the appended.

If you're testing this and it works for your full CRIU test case too,
I'll add your tested-by if I get it before I end up pushing things out
later today,

                    Linus

--00000000000057bf59059eddb0ac
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-pipe-make-sure-to-wake-up-everybody-when-the-last-re.patch"
Content-Disposition: attachment; 
	filename="0001-pipe-make-sure-to-wake-up-everybody-when-the-last-re.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_k6s7mo4e0>
X-Attachment-Id: f_k6s7mo4e0

RnJvbSA3ZTJmZTk2ZDFiNzYwZWIzZTdkZWM3NzFkYjdiODk4M2Q1YjZjMjVjIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRh
dGlvbi5vcmc+CkRhdGU6IFR1ZSwgMTggRmViIDIwMjAgMTA6MTI6NTggLTA4MDAKU3ViamVjdDog
W1BBVENIXSBwaXBlOiBtYWtlIHN1cmUgdG8gd2FrZSB1cCBldmVyeWJvZHkgd2hlbiB0aGUgbGFz
dAogcmVhZGVyL3dyaXRlciBjbG9zZXMKCkFuZHJlaSBWYWdpbiByZXBvcnRlZCB0aGF0IGNvbW1p
dCAwZGRhZDIxZDNlOTkgKCJwaXBlOiB1c2UgZXhjbHVzaXZlCndhaXRzIHdoZW4gcmVhZGluZyBv
ciB3cml0aW5nIikgYnJva2Ugb25lIG9mIHRoZSBDUklVIHRlc3RzLiAgSGUgZXZlbgpoYXMgYSB0
cml2aWFsIHJlcHJvZHVjZXI6CgogICAgI2luY2x1ZGUgPHVuaXN0ZC5oPgogICAgI2luY2x1ZGUg
PHN5cy90eXBlcy5oPgogICAgI2luY2x1ZGUgPHN5cy93YWl0Lmg+CgogICAgaW50IG1haW4oKQog
ICAgewogICAgICAgICAgICBpbnQgcFsyXTsKICAgICAgICAgICAgcGlkX3QgcDEsIHAyOwogICAg
ICAgICAgICBpbnQgc3RhdHVzOwoKICAgICAgICAgICAgaWYgKHBpcGUocCkgPT0gLTEpCiAgICAg
ICAgICAgICAgICAgICAgcmV0dXJuIDE7CgogICAgICAgICAgICBwMSA9IGZvcmsoKTsKICAgICAg
ICAgICAgaWYgKHAxID09IDApIHsKICAgICAgICAgICAgICAgICAgICBjbG9zZShwWzFdKTsKICAg
ICAgICAgICAgICAgICAgICByZWFkKHBbMF0sICZzdGF0dXMsIHNpemVvZihzdGF0dXMpKTsKICAg
ICAgICAgICAgICAgICAgICByZXR1cm4gMDsKICAgICAgICAgICAgfQogICAgICAgICAgICBwMiA9
IGZvcmsoKTsKICAgICAgICAgICAgaWYgKHAyID09IDApIHsKICAgICAgICAgICAgICAgICAgICBj
bG9zZShwWzFdKTsKICAgICAgICAgICAgICAgICAgICByZWFkKHBbMF0sICZzdGF0dXMsIHNpemVv
ZihzdGF0dXMpKTsKICAgICAgICAgICAgICAgICAgICByZXR1cm4gMDsKICAgICAgICAgICAgfQog
ICAgICAgICAgICBzbGVlcCgxKTsKICAgICAgICAgICAgY2xvc2UocFsxXSk7CiAgICAgICAgICAg
IHdhaXQoJnN0YXR1cyk7CiAgICAgICAgICAgIHdhaXQoJnN0YXR1cyk7CgogICAgICAgICAgICBy
ZXR1cm4gMDsKICAgIH0KCmFuZCB0aGUgcHJvYmxlbSAtIG9uY2UgaGUgcG9pbnRzIGl0IG91dCAt
IGlzIG9idmlvdXMuICBXZSB1c2UgdGhlc2UgbmljZQpleGNsdXNpdmUgd2FpdHMsIGJ1dCB3aGVu
IHRoZSBsYXN0IHdyaXRlciBnb2VzIGF3YXksIGl0IHRoZW4gbmVlZHMgdG8Kd2FrZSB1cCBfZXZl
cnlfIHJlYWRlciAoYW5kIGNvbnZlcnNlbHksIHRoZSBsYXN0IHJlYWRlciBkaXNhcHBlYXJpbmcK
bmVlZHMgdG8gd2FrZSBldmVyeSB3cml0ZXIsIG9mIGNvdXJzZSkuCgpJbiBmYWN0LCB3aGVuIGdv
aW5nIHRocm91Z2ggdGhpcywgd2UgaGFkIHNldmVyYWwgc21hbGwgb2RkaXRpZXMgYXJvdW5kCmhv
dyB0byB3YWtlIHRoaW5ncy4gIFdlIGRpZCBpbiBmYWN0IHdha2UgZXZlcnkgcmVhZGVyIHdoZW4g
d2UgY2hhbmdlZAp0aGUgc2l6ZSBvZiB0aGUgcGlwZSBidWZmZXJzLiAgQnV0IHRoYXQncyBlbnRp
cmVseSBwb2ludGxlc3MsIHNpbmNlIHRoYXQKanVzdCBhY3RzIGFzIGEgcG9zc2libGUgc291cmNl
IG9mIG5ldyBzcGFjZSAtIG5vIG5ldyBkYXRhIHRvIHJlYWQuCgpBbmQgd2hlbiB3ZSBjaGFuZ2Ug
dGhlIHNpemUgb2YgdGhlIGJ1ZmZlciwgd2UgZG9uJ3QgbmVlZCB0byB3YWtlIGFsbAp3cml0ZXJz
IGV2ZW4gd2hlbiB3ZSBhZGQgc3BhY2UgLSB0aGF0IGNhc2UgYWN0cyBqdXN0IGFzIGlmIHNvbWVi
b2R5IG1hZGUKc3BhY2UgYnkgcmVhZGluZywgYW5kIGFueSB3cml0ZXIgdGhhdCBmaW5kcyBpdHNl
bGYgbm90IGZpbGxpbmcgaXQgdXAKZW50aXJlbHkgd2lsbCB3YWtlIHRoZSBuZXh0IG9uZS4KCk9u
IHRoZSBvdGhlciBoYW5kLCBvbiB0aGUgZXhpdCBwYXRoLCB3ZSB0cmllZCB0byBsaW1pdCB0aGUg
d2FrZXVwcyB3aXRoCnRoZSBwcm9wZXIgcG9sbCBrZXlzIGV0Yywgd2hpY2ggaXMgZW50aXJlbHkg
cG9pbnRsZXNzLCBiZWNhdXNlIGF0IHRoYXQKcG9pbnQgd2Ugb2J2aW91c2x5IG5lZWQgdG8gd2Fr
ZSB1cCBldmVyeWJvZHkuICBTbyBkb24ndCBkbyB0aGF0OiBqdXN0Cndha2UgdXAgZXZlcnlib2R5
IC0gYnV0IG9ubHkgZG8gdGhhdCBpZiB0aGUgY291bnRzIGNoYW5nZWQgdG8gemVyby4KClNvIGZp
eCB0aG9zZSBub24tSU8gd2FrZXVwcyB0byBiZSBtb3JlIHByb3Blcjogc3BhY2UgY2hhbmdlIGRv
ZXNuJ3QgYWRkCmFueSBuZXcgZGF0YSwgYnV0IGl0IG1pZ2h0IG1ha2Ugcm9vbSBmb3Igd3JpdGVy
cywgc28gaXQgd2FrZXMgdXAgYQp3cml0ZXIuICBBbmQgdGhlIGFjdHVhbCBjaGFuZ2VzIHRvIHJl
YWRlci93cml0ZXIgY291bnRzIHNob3VsZCB3YWtlIHVwCmV2ZXJ5Ym9keSwgc2luY2UgZXZlcnli
b2R5IGlzIGFmZmVjdGVkIChpZSByZWFkZXJzIHdpbGwgYWxsIHNlZSBFT0YgaWYKdGhlIHdyaXRl
cnMgaGF2ZSBnb25lIGF3YXksIGFuZCB3cml0ZXJzIHdpbGwgYWxsIGdldCBFUElQRSBpZiBhbGwK
cmVhZGVycyBoYXZlIGdvbmUgYXdheSkuCgpGaXhlczogMGRkYWQyMWQzZTk5ICgicGlwZTogdXNl
IGV4Y2x1c2l2ZSB3YWl0cyB3aGVuIHJlYWRpbmcgb3Igd3JpdGluZyIpClJlcG9ydGVkLWJ5OiBB
bmRyZWkgVmFnaW4gPGF2YWdpbkBnbWFpbC5jb20+CkNjOiBKb3NoIFRyaXBsZXR0IDxqb3NoQGpv
c2h0cmlwbGV0dC5vcmc+ClNpZ25lZC1vZmYtYnk6IExpbnVzIFRvcnZhbGRzIDx0b3J2YWxkc0Bs
aW51eC1mb3VuZGF0aW9uLm9yZz4KLS0tCiBmcy9waXBlLmMgfCAxOCArKysrKysrKysrLS0tLS0t
LS0KIDEgZmlsZSBjaGFuZ2VkLCAxMCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQoKZGlm
ZiAtLWdpdCBhL2ZzL3BpcGUuYyBiL2ZzL3BpcGUuYwppbmRleCA1YTM0ZDZjMjJkNGMuLjIxNDQ1
MDc0NDdjNSAxMDA2NDQKLS0tIGEvZnMvcGlwZS5jCisrKyBiL2ZzL3BpcGUuYwpAQCAtNzIyLDkg
KzcyMiwxMCBAQCBwaXBlX3JlbGVhc2Uoc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUg
KmZpbGUpCiAJaWYgKGZpbGUtPmZfbW9kZSAmIEZNT0RFX1dSSVRFKQogCQlwaXBlLT53cml0ZXJz
LS07CiAKLQlpZiAocGlwZS0+cmVhZGVycyB8fCBwaXBlLT53cml0ZXJzKSB7Ci0JCXdha2VfdXBf
aW50ZXJydXB0aWJsZV9zeW5jX3BvbGwoJnBpcGUtPnJkX3dhaXQsIEVQT0xMSU4gfCBFUE9MTFJE
Tk9STSB8IEVQT0xMRVJSIHwgRVBPTExIVVApOwotCQl3YWtlX3VwX2ludGVycnVwdGlibGVfc3lu
Y19wb2xsKCZwaXBlLT53cl93YWl0LCBFUE9MTE9VVCB8IEVQT0xMV1JOT1JNIHwgRVBPTExFUlIg
fCBFUE9MTEhVUCk7CisJLyogV2FzIHRoYXQgdGhlIGxhc3QgcmVhZGVyIG9yIHdyaXRlciwgYnV0
IG5vdCB0aGUgb3RoZXIgc2lkZT8gKi8KKwlpZiAoIXBpcGUtPnJlYWRlcnMgIT0gIXBpcGUtPndy
aXRlcnMpIHsKKwkJd2FrZV91cF9pbnRlcnJ1cHRpYmxlX2FsbCgmcGlwZS0+cmRfd2FpdCk7CisJ
CXdha2VfdXBfaW50ZXJydXB0aWJsZV9hbGwoJnBpcGUtPndyX3dhaXQpOwogCQlraWxsX2Zhc3lu
YygmcGlwZS0+ZmFzeW5jX3JlYWRlcnMsIFNJR0lPLCBQT0xMX0lOKTsKIAkJa2lsbF9mYXN5bmMo
JnBpcGUtPmZhc3luY193cml0ZXJzLCBTSUdJTywgUE9MTF9PVVQpOwogCX0KQEAgLTEwMjYsOCAr
MTAyNyw4IEBAIHN0YXRpYyBpbnQgd2FpdF9mb3JfcGFydG5lcihzdHJ1Y3QgcGlwZV9pbm9kZV9p
bmZvICpwaXBlLCB1bnNpZ25lZCBpbnQgKmNudCkKIAogc3RhdGljIHZvaWQgd2FrZV91cF9wYXJ0
bmVyKHN0cnVjdCBwaXBlX2lub2RlX2luZm8gKnBpcGUpCiB7Ci0Jd2FrZV91cF9pbnRlcnJ1cHRp
YmxlKCZwaXBlLT5yZF93YWl0KTsKLQl3YWtlX3VwX2ludGVycnVwdGlibGUoJnBpcGUtPndyX3dh
aXQpOworCXdha2VfdXBfaW50ZXJydXB0aWJsZV9hbGwoJnBpcGUtPnJkX3dhaXQpOworCXdha2Vf
dXBfaW50ZXJydXB0aWJsZV9hbGwoJnBpcGUtPndyX3dhaXQpOwogfQogCiBzdGF0aWMgaW50IGZp
Zm9fb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlscCkKQEAgLTExNDQs
NyArMTE0NSw3IEBAIHN0YXRpYyBpbnQgZmlmb19vcGVuKHN0cnVjdCBpbm9kZSAqaW5vZGUsIHN0
cnVjdCBmaWxlICpmaWxwKQogCiBlcnJfd3I6CiAJaWYgKCEtLXBpcGUtPndyaXRlcnMpCi0JCXdh
a2VfdXBfaW50ZXJydXB0aWJsZSgmcGlwZS0+cmRfd2FpdCk7CisJCXdha2VfdXBfaW50ZXJydXB0
aWJsZV9hbGwoJnBpcGUtPnJkX3dhaXQpOwogCXJldCA9IC1FUkVTVEFSVFNZUzsKIAlnb3RvIGVy
cjsKIApAQCAtMTI3MSw4ICsxMjcyLDkgQEAgc3RhdGljIGxvbmcgcGlwZV9zZXRfc2l6ZShzdHJ1
Y3QgcGlwZV9pbm9kZV9pbmZvICpwaXBlLCB1bnNpZ25lZCBsb25nIGFyZykKIAlwaXBlLT5tYXhf
dXNhZ2UgPSBucl9zbG90czsKIAlwaXBlLT50YWlsID0gdGFpbDsKIAlwaXBlLT5oZWFkID0gaGVh
ZDsKLQl3YWtlX3VwX2ludGVycnVwdGlibGVfYWxsKCZwaXBlLT5yZF93YWl0KTsKLQl3YWtlX3Vw
X2ludGVycnVwdGlibGVfYWxsKCZwaXBlLT53cl93YWl0KTsKKworCS8qIFRoaXMgbWlnaHQgaGF2
ZSBtYWRlIG1vcmUgcm9vbSBmb3Igd3JpdGVycyAqLworCXdha2VfdXBfaW50ZXJydXB0aWJsZSgm
cGlwZS0+d3Jfd2FpdCk7CiAJcmV0dXJuIHBpcGUtPm1heF91c2FnZSAqIFBBR0VfU0laRTsKIAog
b3V0X3JldmVydF9hY2N0OgotLSAKMi4yNC4wLjE1OC5nM2ZlZDE1NTI4OQoK
--00000000000057bf59059eddb0ac--
