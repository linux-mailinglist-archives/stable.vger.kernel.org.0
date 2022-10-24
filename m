Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE69560BDC1
	for <lists+stable@lfdr.de>; Tue, 25 Oct 2022 00:47:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiJXWr1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 18:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232014AbiJXWrC (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 18:47:02 -0400
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EAC42CCA2F
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 14:09:17 -0700 (PDT)
Received: by mail-pg1-f169.google.com with SMTP id q71so9693768pgq.8
        for <stable@vger.kernel.org>; Mon, 24 Oct 2022 14:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=42ug0/vYQIfBEpEn+FKGbBh5pBTNUVILgIL0FVFJ6qY=;
        b=jI987+1F9EoNETDgmCwByt7YDctoouteV3t2KA+aaEAdLNwivMeqEfGKinM/HBt37R
         Zz3gui+6p7V80U+qgpQRiyKrDXAtn+IvU5K3sv6X4naOlwB+6wcvQJhCezuiB6gJC3QS
         NyhiZVpLoNR7FaeeplkU5jeFh2w6x5ytNgnD3dtl1ai9Qj5o7/Ndz529fPEf71AraIUA
         G+Pm556onz2vZ2JxBCzsIkB3xuJx1PSG3Vhw4rITQdfpapnXa79HogZjDwDpz4lHSXze
         UX/Uzoh3ikBThnFcK1ALEo9KHIl3Hp8Nk6a/WKHgf/efUrRI3n/5Z/dV8Bv3QzpfG+qw
         3LeA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=42ug0/vYQIfBEpEn+FKGbBh5pBTNUVILgIL0FVFJ6qY=;
        b=c3EnJ46MiWEi66Ao1uZBmCqxGfhipMkZzEJBsgpg6xap7vr6AFZNsSMDtnb6A5hqxZ
         kBVaoYc1Kw3lhcWHL4EKQ2s+9Hr1h2tqou703/zAB8e6yVxsRF11gkkmNGecIhTOGM7J
         o3rWLMpqCgzwE7gWrFs2Myg9iUWAWhZjTXnlaJtsQpT/nc9u89yV0hctcHpAOo8Rj4Jh
         CpbrMg5Dj++BR4Q3SNzYZrqOEX50/n9JCWbN14u8o7hkRHkuRzLU4echhU2XJhl2cQLO
         GRdikeL+X6O10HLai+B45xZfpKHuxIsrsLG+sAhdssXbc9M8dMu9zaMyW/VaK785Q7UG
         XNpQ==
X-Gm-Message-State: ACrzQf3pGZ6cgc6l+Ctk77UPja3GnyKgJVbRnAkQu1IzGmkYEKNOqPno
        XbQGBBuNdkSuRGKYoNoe6cE4jnlUO4WXFXp/vCdoQ/RjG/+8KA==
X-Google-Smtp-Source: AMsMyM5hlDs5d79HvPNNZl39Fz8Ah22AbMoksCmyV+KfJJT0iuqd8N5UIcs5d3H2e0aUVg8B/X2rNOSGDoNYqVhGAwE=
X-Received: by 2002:a63:1f5c:0:b0:469:d0e6:dac0 with SMTP id
 q28-20020a631f5c000000b00469d0e6dac0mr28993232pgm.427.1666645623829; Mon, 24
 Oct 2022 14:07:03 -0700 (PDT)
MIME-Version: 1.0
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 24 Oct 2022 14:06:52 -0700
Message-ID: <CAKwvOdneUW4e9==CABAk68uePCGNt7Sq6P-84tR41HRB23zFTA@mail.gmail.com>
Subject: backports of 32ef9e5054ec ("Makefile.debug: re-enable debug info for
 .S files")
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Masahiro Yamada <masahiroy@kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        clang-built-linux <llvm@lists.linux.dev>,
        Alexey Alexandrov <aalexand@google.com>,
        Bill Wendling <morbo@google.com>,
        Greg Thelen <gthelen@google.com>
Content-Type: multipart/mixed; boundary="00000000000060a9aa05ebce2cde"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--00000000000060a9aa05ebce2cde
Content-Type: text/plain; charset="UTF-8"

Dear stable kernel maintainers,
Our production kernel team and ChromeOS kernel teams are reporting
that they are unable to symbolize addresses of symbols defined in
assembly sources due to a regression I caused with
    commit a66049e2cf0e ("Kbuild: make DWARF version a choice")
I fixed this upstream with
    commit 32ef9e5054ec ("Makefile.debug: re-enable debug info for .S files")
but I think this is infeasible to backport through to 4.19.y.

Do the attached branch-specific variants look acceptable?
-- 
Thanks,
~Nick Desaulniers

--00000000000060a9aa05ebce2cde
Content-Type: application/octet-stream; name="61f2b7c7497b.5.4.patch"
Content-Disposition: attachment; filename="61f2b7c7497b.5.4.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l9n9ppij0>
X-Attachment-Id: f_l9n9ppij0

RnJvbSBiOWI5MTBlYzYzMzU1NTIxZWI4MWY5MmQwMWI3MzYyNjQwZDI3ZGNlIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOaWNrIERlc2F1bG5pZXJzIDxuZGVzYXVsbmllcnNAZ29vZ2xl
LmNvbT4KRGF0ZTogTW9uLCAyNCBPY3QgMjAyMiAxMzozNDoxNCAtMDcwMApTdWJqZWN0OiBbUEFU
Q0ggNS40Lnkgc3RhYmxlIG9ubHldIE1ha2VmaWxlLmRlYnVnOiByZS1lbmFibGUgZGVidWcgaW5m
byBmb3IgLlMKIGZpbGVzCgpUaGlzIGlzIF9ub3RfIGFuIHVwc3RyZWFtIGNvbW1pdCBhbmQganVz
dCBmb3IgNS40Lnkgb25seS4gSXQgaXMgYmFzZWQKb24KY29tbWl0IDMyZWY5ZTUwNTRlYzAzMjFi
OTMzNjA1OGM1OGVjNzQ5ZTljNmIwZmUgdXBzdHJlYW0uCgpBbGV4ZXkgcmVwb3J0ZWQgdGhhdCB0
aGUgZnJhY3Rpb24gb2YgdW5rbm93biBmaWxlbmFtZSBpbnN0YW5jZXMgaW4Ka2FsbHN5bXMgZ3Jl
dyBmcm9tIH4wLjMlIHRvIH4xMCUgcmVjZW50bHk7IEJpbGwgYW5kIEdyZWcgdHJhY2tlZCBpdCBk
b3duCnRvIGFzc2VtYmxlciBkZWZpbmVkIHN5bWJvbHMsIHdoaWNoIHJlZ3Jlc3NlZCBhcyBhIHJl
c3VsdCBvZjoKCmNvbW1pdCBiOGE5MDkyMzMwZGEgKCJLYnVpbGQ6IGRvIG5vdCBlbWl0IGRlYnVn
IGluZm8gZm9yIGFzc2VtYmx5IHdpdGggTExWTV9JQVM9MSIpCgpJbiB0aGF0IGNvbW1pdCwgSSBh
bGx1ZGUgdG8gcmVzdG9yaW5nIGRlYnVnIGluZm8gZm9yIGFzc2VtYmxlciBkZWZpbmVkCnN5bWJv
bHMgaW4gYSBmb2xsb3cgdXAgcGF0Y2gsIGJ1dCBpdCBzZWVtcyBJIGZvcmdvdCB0byBkbyBzbyBp
bgoKY29tbWl0IGE2NjA0OWUyY2YwZSAoIktidWlsZDogbWFrZSBEV0FSRiB2ZXJzaW9uIGEgY2hv
aWNlIikKCkZpeGVzOiBiOGE5MDkyMzMwZGEgKCJLYnVpbGQ6IGRvIG5vdCBlbWl0IGRlYnVnIGlu
Zm8gZm9yIGFzc2VtYmx5IHdpdGggTExWTV9JQVM9MSIpClNpZ25lZC1vZmYtYnk6IE5pY2sgRGVz
YXVsbmllcnMgPG5kZXNhdWxuaWVyc0Bnb29nbGUuY29tPgotLS0KIE1ha2VmaWxlIHwgNCArKyst
CiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAxIGRlbGV0aW9uKC0pCgpkaWZmIC0t
Z2l0IGEvTWFrZWZpbGUgYi9NYWtlZmlsZQppbmRleCA1ODMyNWMzM2VmMGMuLmVlN2Y4MThiY2Q5
OSAxMDA2NDQKLS0tIGEvTWFrZWZpbGUKKysrIGIvTWFrZWZpbGUKQEAgLTgwMiw3ICs4MDIsOSBA
QCBERUJVR19DRkxBR1MJKz0gLWdzcGxpdC1kd2FyZgogZWxzZQogREVCVUdfQ0ZMQUdTCSs9IC1n
CiBlbmRpZgotaWZuZXEgKCQoTExWTV9JQVMpLDEpCitpZmVxICgkKExMVk1fSUFTKSwxKQorS0JV
SUxEX0FGTEFHUwkrPSAtZworZWxzZQogS0JVSUxEX0FGTEFHUwkrPSAtV2EsLWdkd2FyZi0yCiBl
bmRpZgogZW5kaWYKCmJhc2UtY29tbWl0OiBmZDkyY2ZlZDhiYzY2NjhkMzE0YWNkMWU2ZGE3MDhh
ODA4MjZmNzY4Ci0tIAoyLjM4LjAuMTM1Lmc5MDg1MGEyMjExLWdvb2cKCg==
--00000000000060a9aa05ebce2cde
Content-Type: application/octet-stream; name="61f2b7c7497b.5.10.patch"
Content-Disposition: attachment; filename="61f2b7c7497b.5.10.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l9n9ppje2>
X-Attachment-Id: f_l9n9ppje2

RnJvbSBhZTEzMjg4OGMwYmIzYzE2ZTViNmE2NzcwOWE3ODFiYTQwNDc4YWMzIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOaWNrIERlc2F1bG5pZXJzIDxuZGVzYXVsbmllcnNAZ29vZ2xl
LmNvbT4KRGF0ZTogTW9uLCAyNCBPY3QgMjAyMiAxMzozNDoxNCAtMDcwMApTdWJqZWN0OiBbUEFU
Q0ggNS4xMC55IHN0YWJsZSBvbmx5XSBNYWtlZmlsZS5kZWJ1ZzogcmUtZW5hYmxlIGRlYnVnIGlu
Zm8gZm9yCiAuUyBmaWxlcwoKVGhpcyBpcyBfbm90XyBhbiB1cHN0cmVhbSBjb21taXQgYW5kIGp1
c3QgZm9yIDUuMTAueSBvbmx5LiBJdCBpcyBiYXNlZApvbgpjb21taXQgMzJlZjllNTA1NGVjMDMy
MWI5MzM2MDU4YzU4ZWM3NDllOWM2YjBmZSB1cHN0cmVhbS4KCkFsZXhleSByZXBvcnRlZCB0aGF0
IHRoZSBmcmFjdGlvbiBvZiB1bmtub3duIGZpbGVuYW1lIGluc3RhbmNlcyBpbgprYWxsc3ltcyBn
cmV3IGZyb20gfjAuMyUgdG8gfjEwJSByZWNlbnRseTsgQmlsbCBhbmQgR3JlZyB0cmFja2VkIGl0
IGRvd24KdG8gYXNzZW1ibGVyIGRlZmluZWQgc3ltYm9scywgd2hpY2ggcmVncmVzc2VkIGFzIGEg
cmVzdWx0IG9mOgoKY29tbWl0IGI4YTkwOTIzMzBkYSAoIktidWlsZDogZG8gbm90IGVtaXQgZGVi
dWcgaW5mbyBmb3IgYXNzZW1ibHkgd2l0aCBMTFZNX0lBUz0xIikKCkluIHRoYXQgY29tbWl0LCBJ
IGFsbHVkZSB0byByZXN0b3JpbmcgZGVidWcgaW5mbyBmb3IgYXNzZW1ibGVyIGRlZmluZWQKc3lt
Ym9scyBpbiBhIGZvbGxvdyB1cCBwYXRjaCwgYnV0IGl0IHNlZW1zIEkgZm9yZ290IHRvIGRvIHNv
IGluCgpjb21taXQgYTY2MDQ5ZTJjZjBlICgiS2J1aWxkOiBtYWtlIERXQVJGIHZlcnNpb24gYSBj
aG9pY2UiKQoKRml4ZXM6IGI4YTkwOTIzMzBkYSAoIktidWlsZDogZG8gbm90IGVtaXQgZGVidWcg
aW5mbyBmb3IgYXNzZW1ibHkgd2l0aCBMTFZNX0lBUz0xIikKU2lnbmVkLW9mZi1ieTogTmljayBE
ZXNhdWxuaWVycyA8bmRlc2F1bG5pZXJzQGdvb2dsZS5jb20+Ci0tLQogTWFrZWZpbGUgfCA0ICsr
Ky0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYg
LS1naXQgYS9NYWtlZmlsZSBiL01ha2VmaWxlCmluZGV4IGI4MjRiZGIwNDU3Yy4uODJhN2I2NjFj
MWZlIDEwMDY0NAotLS0gYS9NYWtlZmlsZQorKysgYi9NYWtlZmlsZQpAQCAtODM5LDcgKzgzOSw5
IEBAIGVsc2UKIERFQlVHX0NGTEFHUwkrPSAtZwogZW5kaWYKIAotaWZuZXEgKCQoTExWTV9JQVMp
LDEpCitpZmVxICgkKExMVk1fSUFTKSwxKQorS0JVSUxEX0FGTEFHUwkrPSAtZworZWxzZQogS0JV
SUxEX0FGTEFHUwkrPSAtV2EsLWdkd2FyZi0yCiBlbmRpZgogCgpiYXNlLWNvbW1pdDogMDliZTEz
MmJmZTNhMzA3NWRkZjE2MGNjNzU4NjUzNzBlYTM1YTBhYQotLSAKMi4zOC4wLjEzNS5nOTA4NTBh
MjIxMS1nb29nCgo=
--00000000000060a9aa05ebce2cde
Content-Type: application/octet-stream; name="61f2b7c7497b.5.15.patch"
Content-Disposition: attachment; filename="61f2b7c7497b.5.15.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l9n9ppj51>
X-Attachment-Id: f_l9n9ppj51

RnJvbSA4YjRlNmUwMjhlY2ZhYjA2MzliNmZlMzhkOGExMDhmNTEwNzQ0MzA4IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOaWNrIERlc2F1bG5pZXJzIDxuZGVzYXVsbmllcnNAZ29vZ2xl
LmNvbT4KRGF0ZTogTW9uLCAyNCBPY3QgMjAyMiAxMzozNDoxNCAtMDcwMApTdWJqZWN0OiBbUEFU
Q0ggNS4xNS55IHN0YWJsZSBvbmx5XSBNYWtlZmlsZS5kZWJ1ZzogcmUtZW5hYmxlIGRlYnVnIGlu
Zm8gZm9yCiAuUyBmaWxlcwoKVGhpcyBpcyBfbm90XyBhbiB1cHN0cmVhbSBjb21taXQgYW5kIGp1
c3QgZm9yIDUuMTUueSBvbmx5LiBJdCBpcyBiYXNlZApvbgpjb21taXQgMzJlZjllNTA1NGVjMDMy
MWI5MzM2MDU4YzU4ZWM3NDllOWM2YjBmZSB1cHN0cmVhbS4KCkFsZXhleSByZXBvcnRlZCB0aGF0
IHRoZSBmcmFjdGlvbiBvZiB1bmtub3duIGZpbGVuYW1lIGluc3RhbmNlcyBpbgprYWxsc3ltcyBn
cmV3IGZyb20gfjAuMyUgdG8gfjEwJSByZWNlbnRseTsgQmlsbCBhbmQgR3JlZyB0cmFja2VkIGl0
IGRvd24KdG8gYXNzZW1ibGVyIGRlZmluZWQgc3ltYm9scywgd2hpY2ggcmVncmVzc2VkIGFzIGEg
cmVzdWx0IG9mOgoKY29tbWl0IGI4YTkwOTIzMzBkYSAoIktidWlsZDogZG8gbm90IGVtaXQgZGVi
dWcgaW5mbyBmb3IgYXNzZW1ibHkgd2l0aCBMTFZNX0lBUz0xIikKCkluIHRoYXQgY29tbWl0LCBJ
IGFsbHVkZSB0byByZXN0b3JpbmcgZGVidWcgaW5mbyBmb3IgYXNzZW1ibGVyIGRlZmluZWQKc3lt
Ym9scyBpbiBhIGZvbGxvdyB1cCBwYXRjaCwgYnV0IGl0IHNlZW1zIEkgZm9yZ290IHRvIGRvIHNv
IGluCgpjb21taXQgYTY2MDQ5ZTJjZjBlICgiS2J1aWxkOiBtYWtlIERXQVJGIHZlcnNpb24gYSBj
aG9pY2UiKQoKRml4ZXM6IGI4YTkwOTIzMzBkYSAoIktidWlsZDogZG8gbm90IGVtaXQgZGVidWcg
aW5mbyBmb3IgYXNzZW1ibHkgd2l0aCBMTFZNX0lBUz0xIikKU2lnbmVkLW9mZi1ieTogTmljayBE
ZXNhdWxuaWVycyA8bmRlc2F1bG5pZXJzQGdvb2dsZS5jb20+Ci0tLQogTWFrZWZpbGUgfCA0ICsr
Ky0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYg
LS1naXQgYS9NYWtlZmlsZSBiL01ha2VmaWxlCmluZGV4IDg2YjZjYTg2MmUzOS4uOWY2ZWI1NTgx
NTc2IDEwMDY0NAotLS0gYS9NYWtlZmlsZQorKysgYi9NYWtlZmlsZQpAQCAtODcwLDcgKzg3MCw5
IEBAIGVsc2UKIERFQlVHX0NGTEFHUwkrPSAtZwogZW5kaWYKIAotaWZuZGVmIENPTkZJR19BU19J
U19MTFZNCitpZmRlZiBDT05GSUdfQVNfSVNfTExWTQorS0JVSUxEX0FGTEFHUwkrPSAtZworZWxz
ZQogS0JVSUxEX0FGTEFHUwkrPSAtV2EsLWdkd2FyZi0yCiBlbmRpZgogCgpiYXNlLWNvbW1pdDog
YTNmMmY1YWM5ZDYxZTk3M2UzODNmMTdhOTVjZjJhYTM4NGUyZDBjNAotLSAKMi4zOC4wLjEzNS5n
OTA4NTBhMjIxMS1nb29nCgo=
--00000000000060a9aa05ebce2cde
Content-Type: application/octet-stream; name="61f2b7c7497b.4.19.patch"
Content-Disposition: attachment; filename="61f2b7c7497b.4.19.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_l9n9ppjn3>
X-Attachment-Id: f_l9n9ppjn3

RnJvbSAwZDE2ODVjMmU4ZGUxYjhhM2E4ZWEzMTg0YjAyNDU0NGMzZTJkYzA5IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOaWNrIERlc2F1bG5pZXJzIDxuZGVzYXVsbmllcnNAZ29vZ2xl
LmNvbT4KRGF0ZTogTW9uLCAyNCBPY3QgMjAyMiAxMzozNDoxNCAtMDcwMApTdWJqZWN0OiBbUEFU
Q0ggNC4xOS55IHN0YWJsZSBvbmx5XSBNYWtlZmlsZS5kZWJ1ZzogcmUtZW5hYmxlIGRlYnVnIGlu
Zm8gZm9yCiAuUyBmaWxlcwoKVGhpcyBpcyBfbm90XyBhbiB1cHN0cmVhbSBjb21taXQgYW5kIGp1
c3QgZm9yIDQuMTkueSBvbmx5LiBJdCBpcyBiYXNlZApvbgpjb21taXQgMzJlZjllNTA1NGVjMDMy
MWI5MzM2MDU4YzU4ZWM3NDllOWM2YjBmZSB1cHN0cmVhbS4KCkFsZXhleSByZXBvcnRlZCB0aGF0
IHRoZSBmcmFjdGlvbiBvZiB1bmtub3duIGZpbGVuYW1lIGluc3RhbmNlcyBpbgprYWxsc3ltcyBn
cmV3IGZyb20gfjAuMyUgdG8gfjEwJSByZWNlbnRseTsgQmlsbCBhbmQgR3JlZyB0cmFja2VkIGl0
IGRvd24KdG8gYXNzZW1ibGVyIGRlZmluZWQgc3ltYm9scywgd2hpY2ggcmVncmVzc2VkIGFzIGEg
cmVzdWx0IG9mOgoKY29tbWl0IGI4YTkwOTIzMzBkYSAoIktidWlsZDogZG8gbm90IGVtaXQgZGVi
dWcgaW5mbyBmb3IgYXNzZW1ibHkgd2l0aCBMTFZNX0lBUz0xIikKCkluIHRoYXQgY29tbWl0LCBJ
IGFsbHVkZSB0byByZXN0b3JpbmcgZGVidWcgaW5mbyBmb3IgYXNzZW1ibGVyIGRlZmluZWQKc3lt
Ym9scyBpbiBhIGZvbGxvdyB1cCBwYXRjaCwgYnV0IGl0IHNlZW1zIEkgZm9yZ290IHRvIGRvIHNv
IGluCgpjb21taXQgYTY2MDQ5ZTJjZjBlICgiS2J1aWxkOiBtYWtlIERXQVJGIHZlcnNpb24gYSBj
aG9pY2UiKQoKRml4ZXM6IGI4YTkwOTIzMzBkYSAoIktidWlsZDogZG8gbm90IGVtaXQgZGVidWcg
aW5mbyBmb3IgYXNzZW1ibHkgd2l0aCBMTFZNX0lBUz0xIikKU2lnbmVkLW9mZi1ieTogTmljayBE
ZXNhdWxuaWVycyA8bmRlc2F1bG5pZXJzQGdvb2dsZS5jb20+Ci0tLQogTWFrZWZpbGUgfCA0ICsr
Ky0KIDEgZmlsZSBjaGFuZ2VkLCAzIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24oLSkKCmRpZmYg
LS1naXQgYS9NYWtlZmlsZSBiL01ha2VmaWxlCmluZGV4IDE2NTgxMmQyZjc4Ni4uMTQ3MTYxOWY1
MGNhIDEwMDY0NAotLS0gYS9NYWtlZmlsZQorKysgYi9NYWtlZmlsZQpAQCAtNzQ0LDcgKzc0NCw5
IEBAIEtCVUlMRF9DRkxBR1MgICArPSAkKGNhbGwgY2Mtb3B0aW9uLCAtZ3NwbGl0LWR3YXJmLCAt
ZykKIGVsc2UKIEtCVUlMRF9DRkxBR1MJKz0gLWcKIGVuZGlmCi1pZm5lcSAoJChMTFZNX0lBUyks
MSkKK2lmZXEgKCQoTExWTV9JQVMpLDEpCitLQlVJTERfQUZMQUdTCSs9IC1nCitlbHNlCiBLQlVJ
TERfQUZMQUdTCSs9IC1XYSwtZ2R3YXJmLTIKIGVuZGlmCiBlbmRpZgoKYmFzZS1jb21taXQ6IGNm
NDZlZTgwYzZkMmYyNGMyY2FlMmI0MGM3ZDQ1YjZlODE0NTdiOGIKLS0gCjIuMzguMC4xMzUuZzkw
ODUwYTIyMTEtZ29vZwoK
--00000000000060a9aa05ebce2cde--
