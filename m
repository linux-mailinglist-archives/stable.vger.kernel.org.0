Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F37B223B332
	for <lists+stable@lfdr.de>; Tue,  4 Aug 2020 05:13:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728462AbgHDDNO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 23:13:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37976 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726756AbgHDDNN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Aug 2020 23:13:13 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B84FCC06174A
        for <stable@vger.kernel.org>; Mon,  3 Aug 2020 20:13:12 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id i10so7155783ljn.2
        for <stable@vger.kernel.org>; Mon, 03 Aug 2020 20:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=f+gevwwZCsKvg7cj/hADnIIXscryzqk8n4xDUXnk0rk=;
        b=I7f7H61m3bStoIrcC8FPG9CSn6VSp+va+fA7HHZKFSG7EsREXyuI5VznYAonQkFmur
         QcypoH1WFBhwfvFQiNScjysEB7LanrM61bzpsF1euO+kFM48v8OT+0w7hNutG56J90Oc
         PVco/udM2UJntaD7N2BrkjBcyP/uUH5A/ARdg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=f+gevwwZCsKvg7cj/hADnIIXscryzqk8n4xDUXnk0rk=;
        b=nsS8llanydF2sSRDnsIOOKWYe5AGZM/AzMqMG7miPAKpsgyIIogRH7sV6PAI3Vaqtn
         XWHvowzp+PSF1g4MGvLSQbQTpElfdIedZS10tuoIJkFICksKG9D3r2EuIUeod2DhDUO9
         Gg/EbF+qo7GETFwwAabIbTK9nyWrtsyeylfGZ1MgHuMpTUxHao8iF+Y/rDL/TPyPpitt
         K6ntun4TCavCrVIYPP6wpeujtda7mePzn+E8+GZvGbYQZL9+at2AlV3lw1Z581v297wO
         hlpkQJQ3JhzG/Wqc58p1+rU2Fn2Esamy1Hcc4IIFiELLzZ5/jgaVVX3KIprV5kI8EpSr
         Yq5A==
X-Gm-Message-State: AOAM5325d/JnJ9KiDBWEj2lY9tBHc3MgUUaB91IHnm6NZEp/6zqtySW+
        HwBgLuVLCtvt+zy9I2J9owt2p7oFKhs=
X-Google-Smtp-Source: ABdhPJwLnHJXB4tTJaRwFK4C8zvISHa4oDV/3vkU7yc8k+TtvfjXEz8pEOaPkABYV2je+0nneTWYaA==
X-Received: by 2002:a2e:9156:: with SMTP id q22mr9659719ljg.348.1596510790903;
        Mon, 03 Aug 2020 20:13:10 -0700 (PDT)
Received: from mail-lj1-f178.google.com (mail-lj1-f178.google.com. [209.85.208.178])
        by smtp.gmail.com with ESMTPSA id c74sm3591659lfd.61.2020.08.03.20.13.08
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2020 20:13:08 -0700 (PDT)
Received: by mail-lj1-f178.google.com with SMTP id 185so31696469ljj.7
        for <stable@vger.kernel.org>; Mon, 03 Aug 2020 20:13:08 -0700 (PDT)
X-Received: by 2002:a2e:545:: with SMTP id 66mr9545639ljf.285.1596510787768;
 Mon, 03 Aug 2020 20:13:07 -0700 (PDT)
MIME-Version: 1.0
References: <20200803121902.860751811@linuxfoundation.org> <20200803155820.GA160756@roeck-us.net>
 <20200803173330.GA1186998@kroah.com> <CAMuHMdW1Cz_JJsTmssVz_0wjX_1_EEXGOvGjygPxTkcMsbR6Lw@mail.gmail.com>
 <20200804030107.GA220454@roeck-us.net>
In-Reply-To: <20200804030107.GA220454@roeck-us.net>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Mon, 3 Aug 2020 20:12:51 -0700
X-Gmail-Original-Message-ID: <CAHk-=wi-WH0vTEVb=yTuWv=3RrGC2T28dHxqc=QXKkRMz3N3-g@mail.gmail.com>
Message-ID: <CAHk-=wi-WH0vTEVb=yTuWv=3RrGC2T28dHxqc=QXKkRMz3N3-g@mail.gmail.com>
Subject: Re: [PATCH 5.7 000/120] 5.7.13-rc1 review
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Geert Uytterhoeven <geert@linux-m68k.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        lkft-triage@lists.linaro.org, stable <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000062cde605ac04a2a0"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--00000000000062cde605ac04a2a0
Content-Type: text/plain; charset="UTF-8"

On Mon, Aug 3, 2020 at 8:01 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> The bisect log below applies to both the sparc and the powerpc build
> failures.

Does the attached fix it?

                 Linus

--00000000000062cde605ac04a2a0
Content-Type: text/x-patch; charset="US-ASCII"; 
	name="0001-random32-move-the-pseudo-random-32-bit-definitions-t.patch"
Content-Disposition: attachment; 
	filename="0001-random32-move-the-pseudo-random-32-bit-definitions-t.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kdfdafze0>
X-Attachment-Id: f_kdfdafze0

RnJvbSA3ODBjODU5MWJjZTA5YmJkZDI5MDhiN2MwN2IzYmFiYTg4M2ExY2U2IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBMaW51cyBUb3J2YWxkcyA8dG9ydmFsZHNAbGludXgtZm91bmRh
dGlvbi5vcmc+CkRhdGU6IEZyaSwgMzEgSnVsIDIwMjAgMDc6NTE6MTQgKzAyMDAKU3ViamVjdDog
W1BBVENIXSByYW5kb20zMjogbW92ZSB0aGUgcHNldWRvLXJhbmRvbSAzMi1iaXQgZGVmaW5pdGlv
bnMgdG8gcHJhbmRvbS5oCgpUaGUgYWRkaXRpb24gb2YgcGVyY3B1LmggdG8gdGhlIGxpc3Qgb2Yg
aW5jbHVkZXMgaW4gcmFuZG9tLmggcmV2ZWFsZWQKc29tZSBjaXJjdWxhciBkZXBlbmRlbmNpZXMg
b24gYXJtNjQgYW5kIHBvc3NpYmx5IG90aGVyIHBsYXRmb3Jtcy4gIFRoaXMKaW5jbHVkZSB3YXMg
YWRkZWQgc29sZWx5IGZvciB0aGUgcHNldWRvLXJhbmRvbSBkZWZpbml0aW9ucywgd2hpY2ggaGF2
ZQpub3RoaW5nIHRvIGRvIHdpdGggdGhlIHJlc3Qgb2YgdGhlIGRlZmluaXRpb25zIGluIHRoaXMg
ZmlsZSBidXQgYXJlCnN0aWxsIHRoZXJlIGZvciBsZWdhY3kgcmVhc29ucy4KClRoaXMgcGF0Y2gg
bW92ZXMgdGhlIHBzZXVkby1yYW5kb20gcGFydHMgdG8gbGludXgvcHJhbmRvbS5oIGFuZCB0aGUK
cGVyY3B1LmggaW5jbHVkZSB3aXRoIGl0LCB3aGljaCBpcyBub3cgZ3VhcmRlZCBieSBfTElOVVhf
UFJBTkRPTV9IIGFuZApwcm90ZWN0ZWQgYWdhaW5zdCByZWN1cnNpdmUgaW5jbHVzaW9uLgoKQSBm
dXJ0aGVyIGNsZWFudXAgc3RlcCB3b3VsZCBiZSB0byByZW1vdmUgdGhpcyBmcm9tIDxsaW51eC9y
YW5kb20uaD4KZW50aXJlbHksIGFuZCBtYWtlIHBlb3BsZSB3aG8gdXNlIHRoZSBwcmFuZG9tIGlu
ZnJhc3RydWN0dXJlIGluY2x1ZGUKanVzdCB0aGUgbmV3IGhlYWRlciBmaWxlLiAgVGhhdCdzIGEg
Yml0IG9mIGEgY2h1cm4gcGF0Y2gsIGJ1dCBncmVwcGluZwpmb3IgInByYW5kb21fIiBhbmQgIm5l
eHRfcHNldWRvX3JhbmRvbTMyIiBzaG91bGQgY2F0Y2ggbW9zdCB1c2Vycy4KCkFja2VkLWJ5OiBX
aWxseSBUYXJyZWF1IDx3QDF3dC5ldT4KU2lnbmVkLW9mZi1ieTogTGludXMgVG9ydmFsZHMgPHRv
cnZhbGRzQGxpbnV4LWZvdW5kYXRpb24ub3JnPgotLS0KIGluY2x1ZGUvbGludXgvcHJhbmRvbS5o
IHwgNzggKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysKIGluY2x1ZGUv
bGludXgvcmFuZG9tLmggIHwgNjYgKysrLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLS0tLQog
MiBmaWxlcyBjaGFuZ2VkLCA4MiBpbnNlcnRpb25zKCspLCA2MiBkZWxldGlvbnMoLSkKIGNyZWF0
ZSBtb2RlIDEwMDY0NCBpbmNsdWRlL2xpbnV4L3ByYW5kb20uaAoKZGlmZiAtLWdpdCBhL2luY2x1
ZGUvbGludXgvcHJhbmRvbS5oIGIvaW5jbHVkZS9saW51eC9wcmFuZG9tLmgKbmV3IGZpbGUgbW9k
ZSAxMDA2NDQKaW5kZXggMDAwMDAwMDAwMDAwLi45NjhjNDI4N2EyNzcKLS0tIC9kZXYvbnVsbAor
KysgYi9pbmNsdWRlL2xpbnV4L3ByYW5kb20uaApAQCAtMCwwICsxLDc4IEBACisvKiBTUERYLUxp
Y2Vuc2UtSWRlbnRpZmllcjogR1BMLTIuMCAqLworLyoKKyAqIGluY2x1ZGUvbGludXgvcHJhbmRv
bS5oCisgKgorICogSW5jbHVkZSBmaWxlIGZvciB0aGUgZmFzdCBwc2V1ZG8tcmFuZG9tIDMyLWJp
dAorICogZ2VuZXJhdGlvbi4KKyAqLworI2lmbmRlZiBfTElOVVhfUFJBTkRPTV9ICisjZGVmaW5l
IF9MSU5VWF9QUkFORE9NX0gKKworI2luY2x1ZGUgPGxpbnV4L3R5cGVzLmg+CisjaW5jbHVkZSA8
bGludXgvcGVyY3B1Lmg+CisKK3UzMiBwcmFuZG9tX3UzMih2b2lkKTsKK3ZvaWQgcHJhbmRvbV9i
eXRlcyh2b2lkICpidWYsIHNpemVfdCBuYnl0ZXMpOwordm9pZCBwcmFuZG9tX3NlZWQodTMyIHNl
ZWQpOwordm9pZCBwcmFuZG9tX3Jlc2VlZF9sYXRlKHZvaWQpOworCitzdHJ1Y3Qgcm5kX3N0YXRl
IHsKKwlfX3UzMiBzMSwgczIsIHMzLCBzNDsKK307CisKK0RFQ0xBUkVfUEVSX0NQVShzdHJ1Y3Qg
cm5kX3N0YXRlLCBuZXRfcmFuZF9zdGF0ZSk7CisKK3UzMiBwcmFuZG9tX3UzMl9zdGF0ZShzdHJ1
Y3Qgcm5kX3N0YXRlICpzdGF0ZSk7Cit2b2lkIHByYW5kb21fYnl0ZXNfc3RhdGUoc3RydWN0IHJu
ZF9zdGF0ZSAqc3RhdGUsIHZvaWQgKmJ1Ziwgc2l6ZV90IG5ieXRlcyk7Cit2b2lkIHByYW5kb21f
c2VlZF9mdWxsX3N0YXRlKHN0cnVjdCBybmRfc3RhdGUgX19wZXJjcHUgKnBjcHVfc3RhdGUpOwor
CisjZGVmaW5lIHByYW5kb21faW5pdF9vbmNlKHBjcHVfc3RhdGUpCQkJXAorCURPX09OQ0UocHJh
bmRvbV9zZWVkX2Z1bGxfc3RhdGUsIChwY3B1X3N0YXRlKSkKKworLyoqCisgKiBwcmFuZG9tX3Uz
Ml9tYXggLSByZXR1cm5zIGEgcHNldWRvLXJhbmRvbSBudW1iZXIgaW4gaW50ZXJ2YWwgWzAsIGVw
X3JvKQorICogQGVwX3JvOiByaWdodCBvcGVuIGludGVydmFsIGVuZHBvaW50CisgKgorICogUmV0
dXJucyBhIHBzZXVkby1yYW5kb20gbnVtYmVyIHRoYXQgaXMgaW4gaW50ZXJ2YWwgWzAsIGVwX3Jv
KS4gTm90ZQorICogdGhhdCB0aGUgcmVzdWx0IGRlcGVuZHMgb24gUFJORyBiZWluZyB3ZWxsIGRp
c3RyaWJ1dGVkIGluIFswLCB+MFVdCisgKiB1MzIgc3BhY2UuIEhlcmUgd2UgdXNlIG1heGltYWxs
eSBlcXVpZGlzdHJpYnV0ZWQgY29tYmluZWQgVGF1c3dvcnRoZQorICogZ2VuZXJhdG9yLCB0aGF0
IGlzLCBwcmFuZG9tX3UzMigpLiBUaGlzIGlzIHVzZWZ1bCB3aGVuIHJlcXVlc3RpbmcgYQorICog
cmFuZG9tIGluZGV4IG9mIGFuIGFycmF5IGNvbnRhaW5pbmcgZXBfcm8gZWxlbWVudHMsIGZvciBl
eGFtcGxlLgorICoKKyAqIFJldHVybnM6IHBzZXVkby1yYW5kb20gbnVtYmVyIGluIGludGVydmFs
IFswLCBlcF9ybykKKyAqLworc3RhdGljIGlubGluZSB1MzIgcHJhbmRvbV91MzJfbWF4KHUzMiBl
cF9ybykKK3sKKwlyZXR1cm4gKHUzMikoKCh1NjQpIHByYW5kb21fdTMyKCkgKiBlcF9ybykgPj4g
MzIpOworfQorCisvKgorICogSGFuZGxlIG1pbmltdW0gdmFsdWVzIGZvciBzZWVkcworICovCitz
dGF0aWMgaW5saW5lIHUzMiBfX3NlZWQodTMyIHgsIHUzMiBtKQoreworCXJldHVybiAoeCA8IG0p
ID8geCArIG0gOiB4OworfQorCisvKioKKyAqIHByYW5kb21fc2VlZF9zdGF0ZSAtIHNldCBzZWVk
IGZvciBwcmFuZG9tX3UzMl9zdGF0ZSgpLgorICogQHN0YXRlOiBwb2ludGVyIHRvIHN0YXRlIHN0
cnVjdHVyZSB0byByZWNlaXZlIHRoZSBzZWVkLgorICogQHNlZWQ6IGFyYml0cmFyeSA2NC1iaXQg
dmFsdWUgdG8gdXNlIGFzIGEgc2VlZC4KKyAqLworc3RhdGljIGlubGluZSB2b2lkIHByYW5kb21f
c2VlZF9zdGF0ZShzdHJ1Y3Qgcm5kX3N0YXRlICpzdGF0ZSwgdTY0IHNlZWQpCit7CisJdTMyIGkg
PSAoc2VlZCA+PiAzMikgXiAoc2VlZCA8PCAxMCkgXiBzZWVkOworCisJc3RhdGUtPnMxID0gX19z
ZWVkKGksICAgMlUpOworCXN0YXRlLT5zMiA9IF9fc2VlZChpLCAgIDhVKTsKKwlzdGF0ZS0+czMg
PSBfX3NlZWQoaSwgIDE2VSk7CisJc3RhdGUtPnM0ID0gX19zZWVkKGksIDEyOFUpOworfQorCisv
KiBQc2V1ZG8gcmFuZG9tIG51bWJlciBnZW5lcmF0b3IgZnJvbSBudW1lcmljYWwgcmVjaXBlcy4g
Ki8KK3N0YXRpYyBpbmxpbmUgdTMyIG5leHRfcHNldWRvX3JhbmRvbTMyKHUzMiBzZWVkKQorewor
CXJldHVybiBzZWVkICogMTY2NDUyNSArIDEwMTM5MDQyMjM7Cit9CisKKyNlbmRpZgpkaWZmIC0t
Z2l0IGEvaW5jbHVkZS9saW51eC9yYW5kb20uaCBiL2luY2x1ZGUvbGludXgvcmFuZG9tLmgKaW5k
ZXggOWFiNzQ0M2JkOTFiLi5mNDViOGJlM2UzYzQgMTAwNjQ0Ci0tLSBhL2luY2x1ZGUvbGludXgv
cmFuZG9tLmgKKysrIGIvaW5jbHVkZS9saW51eC9yYW5kb20uaApAQCAtMTEsNyArMTEsNiBAQAog
I2luY2x1ZGUgPGxpbnV4L2tlcm5lbC5oPgogI2luY2x1ZGUgPGxpbnV4L2xpc3QuaD4KICNpbmNs
dWRlIDxsaW51eC9vbmNlLmg+Ci0jaW5jbHVkZSA8YXNtL3BlcmNwdS5oPgogCiAjaW5jbHVkZSA8
dWFwaS9saW51eC9yYW5kb20uaD4KIApAQCAtMTExLDYzICsxMTAsMTIgQEAgZGVjbGFyZV9nZXRf
cmFuZG9tX3Zhcl93YWl0KGxvbmcpCiAKIHVuc2lnbmVkIGxvbmcgcmFuZG9taXplX3BhZ2UodW5z
aWduZWQgbG9uZyBzdGFydCwgdW5zaWduZWQgbG9uZyByYW5nZSk7CiAKLXUzMiBwcmFuZG9tX3Uz
Mih2b2lkKTsKLXZvaWQgcHJhbmRvbV9ieXRlcyh2b2lkICpidWYsIHNpemVfdCBuYnl0ZXMpOwot
dm9pZCBwcmFuZG9tX3NlZWQodTMyIHNlZWQpOwotdm9pZCBwcmFuZG9tX3Jlc2VlZF9sYXRlKHZv
aWQpOwotCi1zdHJ1Y3Qgcm5kX3N0YXRlIHsKLQlfX3UzMiBzMSwgczIsIHMzLCBzNDsKLX07Ci0K
LURFQ0xBUkVfUEVSX0NQVShzdHJ1Y3Qgcm5kX3N0YXRlLCBuZXRfcmFuZF9zdGF0ZSk7Ci0KLXUz
MiBwcmFuZG9tX3UzMl9zdGF0ZShzdHJ1Y3Qgcm5kX3N0YXRlICpzdGF0ZSk7Ci12b2lkIHByYW5k
b21fYnl0ZXNfc3RhdGUoc3RydWN0IHJuZF9zdGF0ZSAqc3RhdGUsIHZvaWQgKmJ1Ziwgc2l6ZV90
IG5ieXRlcyk7Ci12b2lkIHByYW5kb21fc2VlZF9mdWxsX3N0YXRlKHN0cnVjdCBybmRfc3RhdGUg
X19wZXJjcHUgKnBjcHVfc3RhdGUpOwotCi0jZGVmaW5lIHByYW5kb21faW5pdF9vbmNlKHBjcHVf
c3RhdGUpCQkJXAotCURPX09OQ0UocHJhbmRvbV9zZWVkX2Z1bGxfc3RhdGUsIChwY3B1X3N0YXRl
KSkKLQotLyoqCi0gKiBwcmFuZG9tX3UzMl9tYXggLSByZXR1cm5zIGEgcHNldWRvLXJhbmRvbSBu
dW1iZXIgaW4gaW50ZXJ2YWwgWzAsIGVwX3JvKQotICogQGVwX3JvOiByaWdodCBvcGVuIGludGVy
dmFsIGVuZHBvaW50Ci0gKgotICogUmV0dXJucyBhIHBzZXVkby1yYW5kb20gbnVtYmVyIHRoYXQg
aXMgaW4gaW50ZXJ2YWwgWzAsIGVwX3JvKS4gTm90ZQotICogdGhhdCB0aGUgcmVzdWx0IGRlcGVu
ZHMgb24gUFJORyBiZWluZyB3ZWxsIGRpc3RyaWJ1dGVkIGluIFswLCB+MFVdCi0gKiB1MzIgc3Bh
Y2UuIEhlcmUgd2UgdXNlIG1heGltYWxseSBlcXVpZGlzdHJpYnV0ZWQgY29tYmluZWQgVGF1c3dv
cnRoZQotICogZ2VuZXJhdG9yLCB0aGF0IGlzLCBwcmFuZG9tX3UzMigpLiBUaGlzIGlzIHVzZWZ1
bCB3aGVuIHJlcXVlc3RpbmcgYQotICogcmFuZG9tIGluZGV4IG9mIGFuIGFycmF5IGNvbnRhaW5p
bmcgZXBfcm8gZWxlbWVudHMsIGZvciBleGFtcGxlLgotICoKLSAqIFJldHVybnM6IHBzZXVkby1y
YW5kb20gbnVtYmVyIGluIGludGVydmFsIFswLCBlcF9ybykKLSAqLwotc3RhdGljIGlubGluZSB1
MzIgcHJhbmRvbV91MzJfbWF4KHUzMiBlcF9ybykKLXsKLQlyZXR1cm4gKHUzMikoKCh1NjQpIHBy
YW5kb21fdTMyKCkgKiBlcF9ybykgPj4gMzIpOwotfQotCiAvKgotICogSGFuZGxlIG1pbmltdW0g
dmFsdWVzIGZvciBzZWVkcwotICovCi1zdGF0aWMgaW5saW5lIHUzMiBfX3NlZWQodTMyIHgsIHUz
MiBtKQotewotCXJldHVybiAoeCA8IG0pID8geCArIG0gOiB4OwotfQotCi0vKioKLSAqIHByYW5k
b21fc2VlZF9zdGF0ZSAtIHNldCBzZWVkIGZvciBwcmFuZG9tX3UzMl9zdGF0ZSgpLgotICogQHN0
YXRlOiBwb2ludGVyIHRvIHN0YXRlIHN0cnVjdHVyZSB0byByZWNlaXZlIHRoZSBzZWVkLgotICog
QHNlZWQ6IGFyYml0cmFyeSA2NC1iaXQgdmFsdWUgdG8gdXNlIGFzIGEgc2VlZC4KKyAqIFRoaXMg
aXMgZGVzaWduZWQgdG8gYmUgc3RhbmRhbG9uZSBmb3IganVzdCBwcmFuZG9tCisgKiB1c2Vycywg
YnV0IGZvciBub3cgd2UgaW5jbHVkZSBpdCBmcm9tIDxsaW51eC9yYW5kb20uaD4KKyAqIGZvciBs
ZWdhY3kgcmVhc29ucy4KICAqLwotc3RhdGljIGlubGluZSB2b2lkIHByYW5kb21fc2VlZF9zdGF0
ZShzdHJ1Y3Qgcm5kX3N0YXRlICpzdGF0ZSwgdTY0IHNlZWQpCi17Ci0JdTMyIGkgPSAoc2VlZCA+
PiAzMikgXiAoc2VlZCA8PCAxMCkgXiBzZWVkOwotCi0Jc3RhdGUtPnMxID0gX19zZWVkKGksICAg
MlUpOwotCXN0YXRlLT5zMiA9IF9fc2VlZChpLCAgIDhVKTsKLQlzdGF0ZS0+czMgPSBfX3NlZWQo
aSwgIDE2VSk7Ci0Jc3RhdGUtPnM0ID0gX19zZWVkKGksIDEyOFUpOwotfQorI2luY2x1ZGUgPGxp
bnV4L3ByYW5kb20uaD4KIAogI2lmZGVmIENPTkZJR19BUkNIX1JBTkRPTQogIyBpbmNsdWRlIDxh
c20vYXJjaHJhbmRvbS5oPgpAQCAtMjEwLDEwICsxNTgsNCBAQCBzdGF0aWMgaW5saW5lIGJvb2wg
X19pbml0IGFyY2hfZ2V0X3JhbmRvbV9sb25nX2Vhcmx5KHVuc2lnbmVkIGxvbmcgKnYpCiB9CiAj
ZW5kaWYKIAotLyogUHNldWRvIHJhbmRvbSBudW1iZXIgZ2VuZXJhdG9yIGZyb20gbnVtZXJpY2Fs
IHJlY2lwZXMuICovCi1zdGF0aWMgaW5saW5lIHUzMiBuZXh0X3BzZXVkb19yYW5kb20zMih1MzIg
c2VlZCkKLXsKLQlyZXR1cm4gc2VlZCAqIDE2NjQ1MjUgKyAxMDEzOTA0MjIzOwotfQotCiAjZW5k
aWYgLyogX0xJTlVYX1JBTkRPTV9IICovCi0tIAoyLjI4LjAuNC5nMWJhYzE3NzBjZAoK
--00000000000062cde605ac04a2a0--
