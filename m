Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 588456A7A88
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 05:34:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229668AbjCBEeY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 23:34:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229686AbjCBEeX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 23:34:23 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AECA498AD
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 20:34:07 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id l1so15625269pjt.2
        for <stable@vger.kernel.org>; Wed, 01 Mar 2023 20:34:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677731646;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xLUiEeoTT12dzQP/i8Efq93BCDlzp8f3xp9VYDHkpaI=;
        b=KgpZ2ok2NjMtHquwGjxGO5gcVa4gcAYgvbwWOdfYETwVeaUXPw16jUfFKL4nbb86fc
         eRjuwKQP3aj+FlWwMGUr6sUMbCqaP7MkyzNXUp0LOxxx3h5yKfaCfvYl7kWVNfpmIMg5
         mohn28RONz0kZdO5Bf04/vlkF7RNqSW2o3xtWanTxEox6KVvm2vuJ7oFfRROaAY3BfjH
         DMxuc2Idsq2PpuOLtEh1SpCB5hzECLZ5QMu1IGds9Eo/mYomNTY2GNM62Mcp/Xncttps
         RxbT2kWjJFHhXgnqroLMRKpsjxZaD8ahMLkg1CttI4E+tCZEanHM08ZBONx3hXYI9o/8
         RPBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677731646;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xLUiEeoTT12dzQP/i8Efq93BCDlzp8f3xp9VYDHkpaI=;
        b=VvLdPb28MpkHpJmQHhUwm39n2bbhE/xdy7xhDYybIYdnf/wjMTSktiftAfjSc4UGCd
         EhWkhYpTaCjzUfrMwx64LB1MGN8J/TUcnyY29l6ElcRVRU/eYX4zm0KWG8/kvsDwrAMY
         9BstZrSWer4fEsHhgzlVvMjBnJT06EiUSJ0M1ZSCGWFW1Er0R9/XyhoP+Wmt69IpdyP/
         EtZkwWp0VbStmAgAjDpbhjgk+LraLFShxYW+B9c65xZEfKVHf7E5cvbKhvz4uzvDez2y
         /mACj6IGhUAuFJpCz9TKTr7yTFz4YjRmyQ5c43iRFkm89U9fGnvS5M9k7muKCMmfq7sv
         Y77Q==
X-Gm-Message-State: AO0yUKXVOBculySQ9NbsI1G8n6VPiwRtx1fXjVSQ1bGED9o9gEY23Nd7
        BExcaZiHMSYPUMNFrjQPdi7YsY5E/Y5h9vxBDK/IBA==
X-Google-Smtp-Source: AK7set9UqOe/2HgJiZ84ZP7xR0O1IWY+n4XvN45SdylhyOpz/LQx2MfulVwmgW2ynhV0j2XFHkku+Jm0jTL7Zzv/Qdk=
X-Received: by 2002:a17:903:2490:b0:19b:8cbb:30fe with SMTP id
 p16-20020a170903249000b0019b8cbb30femr3206324plw.13.1677731646434; Wed, 01
 Mar 2023 20:34:06 -0800 (PST)
MIME-Version: 1.0
References: <CAEUSe784QOG=iSoSNBRsTyp7QFqGCnzZzY2KwVaAWYJJmgQDxQ@mail.gmail.com>
In-Reply-To: <CAEUSe784QOG=iSoSNBRsTyp7QFqGCnzZzY2KwVaAWYJJmgQDxQ@mail.gmail.com>
From:   =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Date:   Wed, 1 Mar 2023 22:33:55 -0600
Message-ID: <CAEUSe78zcj5AHbubraAK-00N073Uij66hCd7Uqn6_KEXQasZgQ@mail.gmail.com>
Subject: Re: Stable backport request: powerpc/mm radix_tlb warnings
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Anders Roxell <anders.roxell@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, nathan@kernel.org,
        christophe.leroy@csgroup.eu, mpe@ellerman.id.au,
        linux- stable <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary="000000000000d0fec005f5e356dd"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000d0fec005f5e356dd
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Mar 2023 at 22:31, Daniel D=C3=ADaz <daniel.diaz@linaro.org> wrot=
e:
> Hello!
>
> Would the stable maintainers please consider backporting the following
> commit to the 5.15, 6.1, and 6.2 stable branches? It's been
> build-tested and verified it fixes the problem described therein.
>
> commit d78c8e32890ef7eca79ffd67c96022c7f9d8cce4
> Author: Anders Roxell <anders.roxell@linaro.org>
> Date:   Wed Aug 10 13:43:18 2022 +0200
>
>     powerpc/mm: Rearrange if-else block to avoid clang warning
>
> Clang (13, 14, 15, 16, nightly) warns as follows:
> -----8<----------8<----------8<-----
> arch/powerpc/mm/book3s64/radix_tlb.c:1191:23: error: variable 'hstart'
> is uninitialized when used here
>   __tlbiel_va_range(hstart, hend, pid,
>                     ^~~~~~
> arch/powerpc/mm/book3s64/radix_tlb.c:1191:31: error: variable 'hend'
> is uninitialized when used here
>   __tlbiel_va_range(hstart, hend, pid,
>                             ^~~~
> ----->8---------->8---------->8-----
>
> Those warnings make the builds fail.
>
> The same patch applies to 5.10 with fuzz 2 (offset -243 lines).
> Attached is that updated patch.
>
> The code for 5.4 (and below) is different, so this patch would not apply =
there.
>
> Thanks and greetings!
>
> Daniel D=C3=ADaz
> daniel.diaz@linaro.org

+ stable mailing list

--=20
ddiaz

--000000000000d0fec005f5e356dd
Content-Type: text/x-patch; charset="UTF-8"; 
	name="0001-powerpc-mm-Rearrange-if-else-block-to-avoid-clang-wa-5.10.patch"
Content-Disposition: attachment; 
	filename="0001-powerpc-mm-Rearrange-if-else-block-to-avoid-clang-wa-5.10.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_leqm3d9p0>
X-Attachment-Id: f_leqm3d9p0

RnJvbSBjMTJjZjFkMjA3ODM1MGE5MWZjZGFhYzlkMDk3OGVmMDZlZmVhM2VkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBBbmRlcnMgUm94ZWxsIDxhbmRlcnMucm94ZWxsQGxpbmFyby5v
cmc+CkRhdGU6IFdlZCwgMTAgQXVnIDIwMjIgMTM6NDM6MTggKzAyMDAKU3ViamVjdDogW1BBVENI
XSBwb3dlcnBjL21tOiBSZWFycmFuZ2UgaWYtZWxzZSBibG9jayB0byBhdm9pZCBjbGFuZyB3YXJu
aW5nCk1JTUUtVmVyc2lvbjogMS4wCkNvbnRlbnQtVHlwZTogdGV4dC9wbGFpbjsgY2hhcnNldD1V
VEYtOApDb250ZW50LVRyYW5zZmVyLUVuY29kaW5nOiA4Yml0Cgpjb21taXQgZDc4YzhlMzI4OTBl
ZjdlY2E3OWZmZDY3Yzk2MDIyYzdmOWQ4Y2NlNCB1cHN0cmVhbS4KCkNsYW5nIHdhcm5zOgoKICBh
cmNoL3Bvd2VycGMvbW0vYm9vazNzNjQvcmFkaXhfdGxiLmM6MTE5MToyMzogZXJyb3I6IHZhcmlh
YmxlICdoc3RhcnQnIGlzIHVuaW5pdGlhbGl6ZWQgd2hlbiB1c2VkIGhlcmUKICAgIF9fdGxiaWVs
X3ZhX3JhbmdlKGhzdGFydCwgaGVuZCwgcGlkLAogICAgICAgICAgICAgICAgICAgICAgXn5+fn5+
CiAgYXJjaC9wb3dlcnBjL21tL2Jvb2szczY0L3JhZGl4X3RsYi5jOjExOTE6MzE6IGVycm9yOiB2
YXJpYWJsZSAnaGVuZCcgaXMgdW5pbml0aWFsaXplZCB3aGVuIHVzZWQgaGVyZQogICAgX190bGJp
ZWxfdmFfcmFuZ2UoaHN0YXJ0LCBoZW5kLCBwaWQsCiAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgIF5+fn4KClJld29yayB0aGUgJ2lmIChJU19FTkFCTEUoQ09ORklHX1RSQU5TUEFSRU5UX0hV
R0VQQUdFKSknIHNvIGhzdGFydC9oZW5kCmlzIGFsd2F5cyBpbml0aWFsaXplZCB0byBzaWxlbmNl
IHRoZSB3YXJuaW5ncy4gVGhhdCB3aWxsIGFsc28gc2ltcGxpZnkKdGhlICdlbHNlJyBwYXRoLiBD
bGFuZyBpcyBnZXR0aW5nIGNvbmZ1c2VkIHdpdGggdGhlc2Ugd2FybmluZ3MsIGJ1dCB0aGUKd2Fy
bmluZ3MgaXMgYSBmYWxzZS1wb3NpdGl2ZS4KClN1Z2dlc3RlZC1ieTogQXJuZCBCZXJnbWFubiA8
YXJuZEBhcm5kYi5kZT4KU3VnZ2VzdGVkLWJ5OiBOYXRoYW4gQ2hhbmNlbGxvciA8bmF0aGFuQGtl
cm5lbC5vcmc+ClJldmlld2VkLWJ5OiBDaHJpc3RvcGhlIExlcm95IDxjaHJpc3RvcGhlLmxlcm95
QGNzZ3JvdXAuZXU+ClJldmlld2VkLWJ5OiBOYXRoYW4gQ2hhbmNlbGxvciA8bmF0aGFuQGtlcm5l
bC5vcmc+ClNpZ25lZC1vZmYtYnk6IEFuZGVycyBSb3hlbGwgPGFuZGVycy5yb3hlbGxAbGluYXJv
Lm9yZz4KU2lnbmVkLW9mZi1ieTogTWljaGFlbCBFbGxlcm1hbiA8bXBlQGVsbGVybWFuLmlkLmF1
PgpTaWduZWQtb2ZmLWJ5OiBEYW5pZWwgRMOtYXogPGRhbmllbC5kaWF6QGxpbmFyby5vcmc+Ckxp
bms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMjA4MTAxMTQzMTguMzIyMDYzMC0xLWFu
ZGVycy5yb3hlbGxAbGluYXJvLm9yZwotLS0KIGFyY2gvcG93ZXJwYy9tbS9ib29rM3M2NC9yYWRp
eF90bGIuYyB8IDExICsrKystLS0tLS0tCiAxIGZpbGUgY2hhbmdlZCwgNCBpbnNlcnRpb25zKCsp
LCA3IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gvcG93ZXJwYy9tbS9ib29rM3M2NC9y
YWRpeF90bGIuYyBiL2FyY2gvcG93ZXJwYy9tbS9ib29rM3M2NC9yYWRpeF90bGIuYwppbmRleCA0
YzJmNzU5MTZhN2UuLmFiYmZkNWNjNDBjOSAxMDA2NDQKLS0tIGEvYXJjaC9wb3dlcnBjL21tL2Jv
b2szczY0L3JhZGl4X3RsYi5jCisrKyBiL2FyY2gvcG93ZXJwYy9tbS9ib29rM3M2NC9yYWRpeF90
bGIuYwpAQCAtOTQxLDE1ICs5NDEsMTIgQEAgc3RhdGljIGlubGluZSB2b2lkIF9fcmFkaXhfX2Zs
dXNoX3RsYl9yYW5nZShzdHJ1Y3QgbW1fc3RydWN0ICptbSwKIAkJCX0KIAkJfQogCX0gZWxzZSB7
Ci0JCWJvb2wgaGZsdXNoID0gZmFsc2U7CisJCWJvb2wgaGZsdXNoOwogCQl1bnNpZ25lZCBsb25n
IGhzdGFydCwgaGVuZDsKIAotCQlpZiAoSVNfRU5BQkxFRChDT05GSUdfVFJBTlNQQVJFTlRfSFVH
RVBBR0UpKSB7Ci0JCQloc3RhcnQgPSAoc3RhcnQgKyBQTURfU0laRSAtIDEpICYgUE1EX01BU0s7
Ci0JCQloZW5kID0gZW5kICYgUE1EX01BU0s7Ci0JCQlpZiAoaHN0YXJ0IDwgaGVuZCkKLQkJCQlo
Zmx1c2ggPSB0cnVlOwotCQl9CisJCWhzdGFydCA9IChzdGFydCArIFBNRF9TSVpFIC0gMSkgJiBQ
TURfTUFTSzsKKwkJaGVuZCA9IGVuZCAmIFBNRF9NQVNLOworCQloZmx1c2ggPSBJU19FTkFCTEVE
KENPTkZJR19UUkFOU1BBUkVOVF9IVUdFUEFHRSkgJiYgaHN0YXJ0IDwgaGVuZDsKIAogCQlpZiAo
bG9jYWwpIHsKIAkJCWFzbSB2b2xhdGlsZSgicHRlc3luYyI6IDogOiJtZW1vcnkiKTsKLS0gCjIu
MzQuMQoK
--000000000000d0fec005f5e356dd--
