Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1CCB40B6F8
	for <lists+stable@lfdr.de>; Tue, 14 Sep 2021 20:30:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231311AbhINSbn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Sep 2021 14:31:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231202AbhINSbm (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Sep 2021 14:31:42 -0400
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEE79C061574
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:30:24 -0700 (PDT)
Received: by mail-lf1-x12d.google.com with SMTP id a4so354974lfg.8
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DMEPb2641qLKswC+CKlATMdJ94cYSqVGjAMmVVHdy5g=;
        b=hcwUmJZ6+FYi8jSBVC4ea7F0juz+F5SDfcpaN7tUNGeYZPAVM54dOmgtwt7CAeN1Qo
         qqfEcPpCE13MJrkP6+79gWSLNEyoKOgA2Z2Epp1VXsDw05vk4RFWkjCs/3u5A0dmmAk8
         uCOTJ69KIdw3rPtR6t3Y0sRxBP+PkT3S/pAo0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DMEPb2641qLKswC+CKlATMdJ94cYSqVGjAMmVVHdy5g=;
        b=hqET3oAjnvs5TlWC+EF+/mzU0lGU51qLsZUpRGPVwMVIBNhoBgJ+ew/sbsaPdryo/Z
         m/IK/wDNuNCLucKyn+zOU0wQiZdekC6cRpxpAlbZ8BkGw1UYp86MaSMWpNANmUbDUiLB
         n0zkIn2N7Yw4Kzafi9DitOMBTVqgcFQEqwy286ZfG1PH1nSCCv+cRPEa9NoREVObN6f9
         mBzLxaS0ArwobSTSrjvGKXJ/CZM9J/8hXUHjDCPrUYXTPa/t1h3Zip2KGwhDwHfbcQ6k
         9sZbzN+kcsBH7tXO4Spf7/WlnAT0jCyzygRcfMucOEyjIVSRhKTqbdJiRyL8QLS2ahWE
         /3SQ==
X-Gm-Message-State: AOAM531J1S+7hj9auTTK5URfzjuX8sFR0KJxfKTF45gpqQCA7Cu21Hbi
        JefPs250efY+jdXtCApXzwwAlsSGr2hQzg9hTOo=
X-Google-Smtp-Source: ABdhPJzAF3Mw4j357T2l842gqEsD/AMEWojoz7td5jEQVmlwSVDoGuAA/UQbJ+A4zhTFsyfUxQixsw==
X-Received: by 2002:a19:c354:: with SMTP id t81mr10311954lff.387.1631644222465;
        Tue, 14 Sep 2021 11:30:22 -0700 (PDT)
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com. [209.85.208.181])
        by smtp.gmail.com with ESMTPSA id o19sm1439226ljj.49.2021.09.14.11.30.20
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Sep 2021 11:30:20 -0700 (PDT)
Received: by mail-lj1-f181.google.com with SMTP id y6so451472lje.2
        for <stable@vger.kernel.org>; Tue, 14 Sep 2021 11:30:20 -0700 (PDT)
X-Received: by 2002:a2e:8185:: with SMTP id e5mr16184714ljg.31.1631644219944;
 Tue, 14 Sep 2021 11:30:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210913203201.1844253-1-ndesaulniers@google.com>
 <195b2f47-b92e-a00b-a2bc-d91bfdbd9d12@rasmusvillemoes.dk> <202109141031.AEFD06F03F@keescook>
 <CAHk-=wjac_3K+NQNO6tjQZU1KLgba==BOvHmHE2sgNSVj3j85g@mail.gmail.com>
In-Reply-To: <CAHk-=wjac_3K+NQNO6tjQZU1KLgba==BOvHmHE2sgNSVj3j85g@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 14 Sep 2021 11:30:03 -0700
X-Gmail-Original-Message-ID: <CAHk-=whiQBofgis_rkniz8GBP9wZtSZdcDEffgSLO62BUGV3gg@mail.gmail.com>
Message-ID: <CAHk-=whiQBofgis_rkniz8GBP9wZtSZdcDEffgSLO62BUGV3gg@mail.gmail.com>
Subject: Re: [PATCH 5.10] overflow.h: use new generic division helpers to
 avoid / operator
To:     Kees Cook <keescook@chromium.org>,
        Josef Bacik <josef@toxicpanda.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, llvm@lists.linux.dev,
        stable <stable@vger.kernel.org>, Arnd Bergmann <arnd@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Pavel Machek <pavel@ucw.cz>
Content-Type: multipart/mixed; boundary="00000000000021a5b305cbf8c607"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--00000000000021a5b305cbf8c607
Content-Type: text/plain; charset="UTF-8"

On Tue, Sep 14, 2021 at 11:14 AM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> All this pain could have been trivially avoided with just people
> writing better code, knowing that multiplies and divides are
> expensive, and that shift counts are small and cheap.

IOW, maybe the fix is just this attached trivial patch.

I didn't bother to change the order of the 'struct ndb_config'
structure. It would pack better if you put the (now 32-bit)
blksize_bits field next to the 'atomic_t' field, I think. But I wanted
to just see how a minimal patch looks.

I did make the debugfs interface reflect the change to blocksize_bits,
so this is visible in user space. But it's debugfs.

If people care, it could be made to use a DEFINE_SHOW_ATTRIBUTE()
function the way it already does for 'flags', so that's not a
fundamental issue, I just didn't bother.

Hmm?

Btw, I really think more of the block layer should perhaps think about
use bit shifts more, not expanded values.  Can things like the queue
'discard_alignment' really be non-powers-of-two?

          Linus

--00000000000021a5b305cbf8c607
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_ktketv320>
X-Attachment-Id: f_ktketv320

IGRyaXZlcnMvYmxvY2svbmJkLmMgfCAzMCArKysrKysrKysrKysrKysrKystLS0tLS0tLS0tLS0K
IDEgZmlsZSBjaGFuZ2VkLCAxOCBpbnNlcnRpb25zKCspLCAxMiBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9kcml2ZXJzL2Jsb2NrL25iZC5jIGIvZHJpdmVycy9ibG9jay9uYmQuYwppbmRleCA1
MTcwYTYzMDc3OGQuLjllMTJlZGY4OTJkNyAxMDA2NDQKLS0tIGEvZHJpdmVycy9ibG9jay9uYmQu
YworKysgYi9kcml2ZXJzL2Jsb2NrL25iZC5jCkBAIC05NywxMyArOTcsMTggQEAgc3RydWN0IG5i
ZF9jb25maWcgewogCiAJYXRvbWljX3QgcmVjdl90aHJlYWRzOwogCXdhaXRfcXVldWVfaGVhZF90
IHJlY3Zfd3E7Ci0JbG9mZl90IGJsa3NpemU7CisJdW5zaWduZWQgYmxrc2l6ZV9iaXRzOwogCWxv
ZmZfdCBieXRlc2l6ZTsKICNpZiBJU19FTkFCTEVEKENPTkZJR19ERUJVR19GUykKIAlzdHJ1Y3Qg
ZGVudHJ5ICpkYmdfZGlyOwogI2VuZGlmCiB9OwogCitzdGF0aWMgaW5saW5lIHVuc2lnbmVkIGlu
dCBuYmRfYmxrc2l6ZShzdHJ1Y3QgbmJkX2NvbmZpZyAqY29uZmlnKQoreworCXJldHVybiAxdSA8
PCBjb25maWctPmJsa3NpemVfYml0czsKK30KKwogc3RydWN0IG5iZF9kZXZpY2UgewogCXN0cnVj
dCBibGtfbXFfdGFnX3NldCB0YWdfc2V0OwogCkBAIC0xNDYsNyArMTUxLDcgQEAgc3RhdGljIHN0
cnVjdCBkZW50cnkgKm5iZF9kYmdfZGlyOwogCiAjZGVmaW5lIE5CRF9NQUdJQyAweDY4Nzk3NTQ4
CiAKLSNkZWZpbmUgTkJEX0RFRl9CTEtTSVpFIDEwMjQKKyNkZWZpbmUgTkJEX0RFRl9CTEtTSVpF
X0JJVFMgMTAKIAogc3RhdGljIHVuc2lnbmVkIGludCBuYmRzX21heCA9IDE2Owogc3RhdGljIGlu
dCBtYXhfcGFydCA9IDE2OwpAQCAtMzE3LDEyICszMjIsMTIgQEAgc3RhdGljIGludCBuYmRfc2V0
X3NpemUoc3RydWN0IG5iZF9kZXZpY2UgKm5iZCwgbG9mZl90IGJ5dGVzaXplLAogCQlsb2ZmX3Qg
Ymxrc2l6ZSkKIHsKIAlpZiAoIWJsa3NpemUpCi0JCWJsa3NpemUgPSBOQkRfREVGX0JMS1NJWkU7
CisJCWJsa3NpemUgPSAxdSA8PCBOQkRfREVGX0JMS1NJWkVfQklUUzsKIAlpZiAoYmxrc2l6ZSA8
IDUxMiB8fCBibGtzaXplID4gUEFHRV9TSVpFIHx8ICFpc19wb3dlcl9vZl8yKGJsa3NpemUpKQog
CQlyZXR1cm4gLUVJTlZBTDsKIAogCW5iZC0+Y29uZmlnLT5ieXRlc2l6ZSA9IGJ5dGVzaXplOwot
CW5iZC0+Y29uZmlnLT5ibGtzaXplID0gYmxrc2l6ZTsKKwluYmQtPmNvbmZpZy0+Ymxrc2l6ZV9i
aXRzID0gX19mZnMoYmxrc2l6ZSk7CiAKIAlpZiAoIW5iZC0+dGFza19yZWN2KQogCQlyZXR1cm4g
MDsKQEAgLTEzMzcsNyArMTM0Miw3IEBAIHN0YXRpYyBpbnQgbmJkX3N0YXJ0X2RldmljZShzdHJ1
Y3QgbmJkX2RldmljZSAqbmJkKQogCQlhcmdzLT5pbmRleCA9IGk7CiAJCXF1ZXVlX3dvcmsobmJk
LT5yZWN2X3dvcmtxLCAmYXJncy0+d29yayk7CiAJfQotCXJldHVybiBuYmRfc2V0X3NpemUobmJk
LCBjb25maWctPmJ5dGVzaXplLCBjb25maWctPmJsa3NpemUpOworCXJldHVybiBuYmRfc2V0X3Np
emUobmJkLCBjb25maWctPmJ5dGVzaXplLCBuYmRfYmxrc2l6ZShjb25maWcpKTsKIH0KIAogc3Rh
dGljIGludCBuYmRfc3RhcnRfZGV2aWNlX2lvY3RsKHN0cnVjdCBuYmRfZGV2aWNlICpuYmQsIHN0
cnVjdCBibG9ja19kZXZpY2UgKmJkZXYpCkBAIC0xNDA2LDExICsxNDExLDEyIEBAIHN0YXRpYyBp
bnQgX19uYmRfaW9jdGwoc3RydWN0IGJsb2NrX2RldmljZSAqYmRldiwgc3RydWN0IG5iZF9kZXZp
Y2UgKm5iZCwKIAljYXNlIE5CRF9TRVRfQkxLU0laRToKIAkJcmV0dXJuIG5iZF9zZXRfc2l6ZShu
YmQsIGNvbmZpZy0+Ynl0ZXNpemUsIGFyZyk7CiAJY2FzZSBOQkRfU0VUX1NJWkU6Ci0JCXJldHVy
biBuYmRfc2V0X3NpemUobmJkLCBhcmcsIGNvbmZpZy0+Ymxrc2l6ZSk7CisJCXJldHVybiBuYmRf
c2V0X3NpemUobmJkLCBhcmcsIG5iZF9ibGtzaXplKGNvbmZpZykpOwogCWNhc2UgTkJEX1NFVF9T
SVpFX0JMT0NLUzoKLQkJaWYgKGNoZWNrX211bF9vdmVyZmxvdygobG9mZl90KWFyZywgY29uZmln
LT5ibGtzaXplLCAmYnl0ZXNpemUpKQorCQlieXRlc2l6ZSA9IGFyZyA8PCBjb25maWctPmJsa3Np
emVfYml0czsKKwkJaWYgKGJ5dGVzaXplID4+IGNvbmZpZy0+Ymxrc2l6ZV9iaXRzICE9IGFyZykK
IAkJCXJldHVybiAtRUlOVkFMOwotCQlyZXR1cm4gbmJkX3NldF9zaXplKG5iZCwgYnl0ZXNpemUs
IGNvbmZpZy0+Ymxrc2l6ZSk7CisJCXJldHVybiBuYmRfc2V0X3NpemUobmJkLCBieXRlc2l6ZSwg
bmJkX2Jsa3NpemUoY29uZmlnKSk7CiAJY2FzZSBOQkRfU0VUX1RJTUVPVVQ6CiAJCW5iZF9zZXRf
Y21kX3RpbWVvdXQobmJkLCBhcmcpOwogCQlyZXR1cm4gMDsKQEAgLTE0NzYsNyArMTQ4Miw3IEBA
IHN0YXRpYyBzdHJ1Y3QgbmJkX2NvbmZpZyAqbmJkX2FsbG9jX2NvbmZpZyh2b2lkKQogCWF0b21p
Y19zZXQoJmNvbmZpZy0+cmVjdl90aHJlYWRzLCAwKTsKIAlpbml0X3dhaXRxdWV1ZV9oZWFkKCZj
b25maWctPnJlY3Zfd3EpOwogCWluaXRfd2FpdHF1ZXVlX2hlYWQoJmNvbmZpZy0+Y29ubl93YWl0
KTsKLQljb25maWctPmJsa3NpemUgPSBOQkRfREVGX0JMS1NJWkU7CisJY29uZmlnLT5ibGtzaXpl
X2JpdHMgPSBOQkRfREVGX0JMS1NJWkVfQklUUzsKIAlhdG9taWNfc2V0KCZjb25maWctPmxpdmVf
Y29ubmVjdGlvbnMsIDApOwogCXRyeV9tb2R1bGVfZ2V0KFRISVNfTU9EVUxFKTsKIAlyZXR1cm4g
Y29uZmlnOwpAQCAtMTYwNCw3ICsxNjEwLDcgQEAgc3RhdGljIGludCBuYmRfZGV2X2RiZ19pbml0
KHN0cnVjdCBuYmRfZGV2aWNlICpuYmQpCiAJZGVidWdmc19jcmVhdGVfZmlsZSgidGFza3MiLCAw
NDQ0LCBkaXIsIG5iZCwgJm5iZF9kYmdfdGFza3NfZm9wcyk7CiAJZGVidWdmc19jcmVhdGVfdTY0
KCJzaXplX2J5dGVzIiwgMDQ0NCwgZGlyLCAmY29uZmlnLT5ieXRlc2l6ZSk7CiAJZGVidWdmc19j
cmVhdGVfdTMyKCJ0aW1lb3V0IiwgMDQ0NCwgZGlyLCAmbmJkLT50YWdfc2V0LnRpbWVvdXQpOwot
CWRlYnVnZnNfY3JlYXRlX3U2NCgiYmxvY2tzaXplIiwgMDQ0NCwgZGlyLCAmY29uZmlnLT5ibGtz
aXplKTsKKwlkZWJ1Z2ZzX2NyZWF0ZV91MzIoImJsb2Nrc2l6ZV9iaXRzIiwgMDQ0NCwgZGlyLCAm
Y29uZmlnLT5ibGtzaXplX2JpdHMpOwogCWRlYnVnZnNfY3JlYXRlX2ZpbGUoImZsYWdzIiwgMDQ0
NCwgZGlyLCBuYmQsICZuYmRfZGJnX2ZsYWdzX2ZvcHMpOwogCiAJcmV0dXJuIDA7CkBAIC0xODI2
LDcgKzE4MzIsNyBAQCBuYmRfZGV2aWNlX3BvbGljeVtOQkRfREVWSUNFX0FUVFJfTUFYICsgMV0g
PSB7CiBzdGF0aWMgaW50IG5iZF9nZW5sX3NpemVfc2V0KHN0cnVjdCBnZW5sX2luZm8gKmluZm8s
IHN0cnVjdCBuYmRfZGV2aWNlICpuYmQpCiB7CiAJc3RydWN0IG5iZF9jb25maWcgKmNvbmZpZyA9
IG5iZC0+Y29uZmlnOwotCXU2NCBic2l6ZSA9IGNvbmZpZy0+Ymxrc2l6ZTsKKwl1NjQgYnNpemUg
PSBuYmRfYmxrc2l6ZShjb25maWcpOwogCXU2NCBieXRlcyA9IGNvbmZpZy0+Ynl0ZXNpemU7CiAK
IAlpZiAoaW5mby0+YXR0cnNbTkJEX0FUVFJfU0laRV9CWVRFU10pCkBAIC0xODM1LDcgKzE4NDEs
NyBAQCBzdGF0aWMgaW50IG5iZF9nZW5sX3NpemVfc2V0KHN0cnVjdCBnZW5sX2luZm8gKmluZm8s
IHN0cnVjdCBuYmRfZGV2aWNlICpuYmQpCiAJaWYgKGluZm8tPmF0dHJzW05CRF9BVFRSX0JMT0NL
X1NJWkVfQllURVNdKQogCQlic2l6ZSA9IG5sYV9nZXRfdTY0KGluZm8tPmF0dHJzW05CRF9BVFRS
X0JMT0NLX1NJWkVfQllURVNdKTsKIAotCWlmIChieXRlcyAhPSBjb25maWctPmJ5dGVzaXplIHx8
IGJzaXplICE9IGNvbmZpZy0+Ymxrc2l6ZSkKKwlpZiAoYnl0ZXMgIT0gY29uZmlnLT5ieXRlc2l6
ZSB8fCBic2l6ZSAhPSBuYmRfYmxrc2l6ZShjb25maWcpKQogCQlyZXR1cm4gbmJkX3NldF9zaXpl
KG5iZCwgYnl0ZXMsIGJzaXplKTsKIAlyZXR1cm4gMDsKIH0K
--00000000000021a5b305cbf8c607--
