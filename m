Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37B322DA40A
	for <lists+stable@lfdr.de>; Tue, 15 Dec 2020 00:19:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728448AbgLNXS3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Dec 2020 18:18:29 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393760AbgLNXR0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Dec 2020 18:17:26 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AAD61C061793
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 15:16:46 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id e2so13852813pgi.5
        for <stable@vger.kernel.org>; Mon, 14 Dec 2020 15:16:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=vX5wPq+7mdBY7hGLsMd2ZNQzLHb2GTIOmX39pX0Pi1g=;
        b=DZVrd+9a6HsJEGiLRiDved6ojmglXW0obhZuwteaLNgi6LC2Iv0OUqfQ8eoGpDXZKH
         MZb2gaZ08Zx6S/jpmfGJSewA0rZ2gQ/Q3BzM/mUZBtc39lfdtSeZ91WmWKIJFz1R06yi
         4P7iZsFepadeDj/n47wCBneKYpMkGAnjWlOaIq6khPVwytQwAlZP8bIJdFKASlRAJB7g
         /0gW2/FD2TCa1CkHhCdGMwyqAi/h/Xck0ti1gE8myFVrOJ14s69uCre6rlA8hKRF6d0w
         p9kCDqBWzNBX0e/zCSDlaq5odl40aGj1zE5o2chb/PDLS478yoTCkUGtwjOQU+0xAMHL
         FPoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=vX5wPq+7mdBY7hGLsMd2ZNQzLHb2GTIOmX39pX0Pi1g=;
        b=rpg4HtEEDpUcmVLfAuWFfTDXl2gUTI1jdl1TRshPWHA4ThLM8NHWwGqIp/d1x0LlkE
         lW93gFvzYG+gkWS/3OQXK9Ty2jYu5OcbJLYfN6zJ1UzKvbzH0fUn/aG+yxNser1tucru
         6b/2xoCygR/AkgqtiE3mXcUKGA6ucIPRIn4f27kSTjzD14kRynckyBl7wjDIQg327NQ2
         V62mH28W/+YkbYDBqezbSmaoKQ8UDp+Bmj+EtyBm92h1GWmJpUmgT5YKz8dfG3/Kg/rh
         FcaknuR+lw36zy2N4LAv3dwR44MdKj2FQpP60Ey6Cz8m8OMUItLlZiQzN5gAo81Dgka3
         LA+Q==
X-Gm-Message-State: AOAM533S9s4Sx333Okdq7yK9I2NrWEuqsHpvdshkDPULed5wMI64KXIg
        BnG2y8bxlqqmuznprq8GZuybMx4UC/tPwX6HfyoLBw==
X-Google-Smtp-Source: ABdhPJxMkTe7nCtjCnLEAfwIVgqUTzFgisv4Wf/0U4512xzjs1spJJIuGoE0eUJI0LeSaI0fBh2l/o2MU32FVtTCGa8=
X-Received: by 2002:a63:184c:: with SMTP id 12mr19395754pgy.381.1607987805946;
 Mon, 14 Dec 2020 15:16:45 -0800 (PST)
MIME-Version: 1.0
References: <1604431094102246@kroah.com>
In-Reply-To: <1604431094102246@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Mon, 14 Dec 2020 15:16:34 -0800
Message-ID: <CAKwvOdkE8_1s4xPYU0Gq9Ld9XhkFn1FowJJt5ZF5ve9zT8uL1w@mail.gmail.com>
Subject: Re: FAILED: patch "[PATCH] arm64: Change .weak to SYM_FUNC_START_WEAK_PI
 for" failed to apply to 4.19-stable tree
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     Fangrui Song <maskray@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        "# 3.4.x" <stable@vger.kernel.org>, Will Deacon <will@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        Mark Brown <broonie@kernel.org>
Content-Type: multipart/mixed; boundary="000000000000fac5a105b674d551"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000fac5a105b674d551
Content-Type: text/plain; charset="UTF-8"

On Tue, Nov 3, 2020 at 11:18 AM <gregkh@linuxfoundation.org> wrote:
>
>
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
>
> thanks,
>
> greg k-h
>
> ------------------ original commit in Linus's tree ------------------
>
> From ec9d78070de986ecf581ea204fd322af4d2477ec Mon Sep 17 00:00:00 2001
> From: Fangrui Song <maskray@google.com>
> Date: Thu, 29 Oct 2020 11:19:51 -0700
> Subject: [PATCH] arm64: Change .weak to SYM_FUNC_START_WEAK_PI for
>  arch/arm64/lib/mem*.S

Dear stable kernel maintainers, please consider applying the attached
patch for 4.19.y.  It is adjusted to avoid conflicts due to:
      commit 3ac0f4526dfb ("arm64: lib: Use modern annotations for
assembly functions")
      commit 35e61c77ef38 ("arm64: asm: Add new-style position
independent function annotations")]
not being backported to 4.19.y.  It helps us enable LLVM_IAS=1 builds
for aarch64 for Android and CrOS.
-- 
Thanks,
~Nick Desaulniers

--000000000000fac5a105b674d551
Content-Type: application/octet-stream; 
	name="0001-arm64-Change-.weak-to-SYM_FUNC_START_WEAK_PI-for-arc.patch"
Content-Disposition: attachment; 
	filename="0001-arm64-Change-.weak-to-SYM_FUNC_START_WEAK_PI-for-arc.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kip6ddlv0>
X-Attachment-Id: f_kip6ddlv0

RnJvbSA2Zjc5MTVjZGYyMzMyZjFmZjkxMDhjZDE2OTM2ZTJkMTE1YzMxMTlkIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBGYW5ncnVpIFNvbmcgPG1hc2tyYXlAZ29vZ2xlLmNvbT4KRGF0
ZTogVGh1LCAyOSBPY3QgMjAyMCAxMToxOTo1MSAtMDcwMApTdWJqZWN0OiBbUEFUQ0hdIGFybTY0
OiBDaGFuZ2UgLndlYWsgdG8gU1lNX0ZVTkNfU1RBUlRfV0VBS19QSSBmb3IKIGFyY2gvYXJtNjQv
bGliL21lbSouUwoKY29tbWl0IGVjOWQ3ODA3MGRlOTg2ZWNmNTgxZWEyMDRmZDMyMmFmNGQyNDc3
ZWMgdXBzdHJlYW0uCgpDb21taXQgMzlkMTE0ZGRjNjgyICgiYXJtNjQ6IGFkZCBLQVNBTiBzdXBw
b3J0IikgYWRkZWQgLndlYWsgZGlyZWN0aXZlcyB0bwphcmNoL2FybTY0L2xpYi9tZW0qLlMgaW5z
dGVhZCBvZiBjaGFuZ2luZyB0aGUgZXhpc3RpbmcgU1lNX0ZVTkNfU1RBUlRfUEkKbWFjcm9zLiBU
aGlzIGNhbiBsZWFkIHRvIHRoZSBhc3NlbWJseSBzbmlwcGV0IGAud2VhayBtZW1jcHkgLi4uIC5n
bG9ibAptZW1jcHlgIHdoaWNoIHdpbGwgcHJvZHVjZSBhIFNUQl9XRUFLIG1lbWNweSB3aXRoIEdO
VSBhcyBidXQgU1RCX0dMT0JBTAptZW1jcHkgd2l0aCBMTFZNJ3MgaW50ZWdyYXRlZCBhc3NlbWJs
ZXIgYmVmb3JlIExMVk0gMTIuIExMVk0gMTIgKHNpbmNlCmh0dHBzOi8vcmV2aWV3cy5sbHZtLm9y
Zy9EOTAxMDgpIHdpbGwgZXJyb3Igb24gc3VjaCBhbiBvdmVycmlkZGVuIHN5bWJvbApiaW5kaW5n
LgoKVXNlIHRoZSBhcHByb3ByaWF0ZSBTWU1fRlVOQ19TVEFSVF9XRUFLX1BJIGluc3RlYWQuCgpG
aXhlczogMzlkMTE0ZGRjNjgyICgiYXJtNjQ6IGFkZCBLQVNBTiBzdXBwb3J0IikKUmVwb3J0ZWQt
Ynk6IFNhbWkgVG9sdmFuZW4gPHNhbWl0b2x2YW5lbkBnb29nbGUuY29tPgpTaWduZWQtb2ZmLWJ5
OiBGYW5ncnVpIFNvbmcgPG1hc2tyYXlAZ29vZ2xlLmNvbT4KVGVzdGVkLWJ5OiBTYW1pIFRvbHZh
bmVuIDxzYW1pdG9sdmFuZW5AZ29vZ2xlLmNvbT4KVGVzdGVkLWJ5OiBOaWNrIERlc2F1bG5pZXJz
IDxuZGVzYXVsbmllcnNAZ29vZ2xlLmNvbT4KUmV2aWV3ZWQtYnk6IE5pY2sgRGVzYXVsbmllcnMg
PG5kZXNhdWxuaWVyc0Bnb29nbGUuY29tPgpDYzogPHN0YWJsZUB2Z2VyLmtlcm5lbC5vcmc+Ckxp
bms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMDEwMjkxODE5NTEuMTg2NjA5My0xLW1h
c2tyYXlAZ29vZ2xlLmNvbQpTaWduZWQtb2ZmLWJ5OiBXaWxsIERlYWNvbiA8d2lsbEBrZXJuZWwu
b3JnPgpbbmQ6IGJhY2twb3J0IHRvIGFkanVzdCBmb3IgbWlzc2luZzoKICBjb21taXQgM2FjMGY0
NTI2ZGZiICgiYXJtNjQ6IGxpYjogVXNlIG1vZGVybiBhbm5vdGF0aW9ucyBmb3IgYXNzZW1ibHkg
ZnVuY3Rpb25zIikKICBjb21taXQgMzVlNjFjNzdlZjM4ICgiYXJtNjQ6IGFzbTogQWRkIG5ldy1z
dHlsZSBwb3NpdGlvbiBpbmRlcGVuZGVudCBmdW5jdGlvbiBhbm5vdGF0aW9ucyIpXQpTaWduZWQt
b2ZmLWJ5OiBOaWNrIERlc2F1bG5pZXJzIDxuZGVzYXVsbmllcnNAZ29vZ2xlLmNvbT4KLS0tCiBh
cmNoL2FybTY0L2xpYi9tZW1jcHkuUyAgfCAzICstLQogYXJjaC9hcm02NC9saWIvbWVtbW92ZS5T
IHwgMyArLS0KIGFyY2gvYXJtNjQvbGliL21lbXNldC5TICB8IDMgKy0tCiAzIGZpbGVzIGNoYW5n
ZWQsIDMgaW5zZXJ0aW9ucygrKSwgNiBkZWxldGlvbnMoLSkKCmRpZmYgLS1naXQgYS9hcmNoL2Fy
bTY0L2xpYi9tZW1jcHkuUyBiL2FyY2gvYXJtNjQvbGliL21lbWNweS5TCmluZGV4IDY3NjEzOTM3
NzExZi4uZGZlZGQ0YWIxYTc2IDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2xpYi9tZW1jcHkuUwor
KysgYi9hcmNoL2FybTY0L2xpYi9tZW1jcHkuUwpAQCAtNjgsOSArNjgsOCBAQAogCXN0cCBccHRy
LCBccmVnQiwgW1xyZWdDXSwgXHZhbAogCS5lbmRtCiAKLQkud2VhayBtZW1jcHkKIEVOVFJZKF9f
bWVtY3B5KQotRU5UUlkobWVtY3B5KQorV0VBSyhtZW1jcHkpCiAjaW5jbHVkZSAiY29weV90ZW1w
bGF0ZS5TIgogCXJldAogRU5EUElQUk9DKG1lbWNweSkKZGlmZiAtLWdpdCBhL2FyY2gvYXJtNjQv
bGliL21lbW1vdmUuUyBiL2FyY2gvYXJtNjQvbGliL21lbW1vdmUuUwppbmRleCBhNWE0NDU5MDEz
YjEuLmUzZGU4ZjA1YzIxYSAxMDA2NDQKLS0tIGEvYXJjaC9hcm02NC9saWIvbWVtbW92ZS5TCisr
KyBiL2FyY2gvYXJtNjQvbGliL21lbW1vdmUuUwpAQCAtNTcsOSArNTcsOCBAQCBDX2gJLnJlcQl4
MTIKIERfbAkucmVxCXgxMwogRF9oCS5yZXEJeDE0CiAKLQkud2VhayBtZW1tb3ZlCiBFTlRSWShf
X21lbW1vdmUpCi1FTlRSWShtZW1tb3ZlKQorV0VBSyhtZW1tb3ZlKQogCWNtcAlkc3Rpbiwgc3Jj
CiAJYi5sbwlfX21lbWNweQogCWFkZAl0bXAxLCBzcmMsIGNvdW50CmRpZmYgLS1naXQgYS9hcmNo
L2FybTY0L2xpYi9tZW1zZXQuUyBiL2FyY2gvYXJtNjQvbGliL21lbXNldC5TCmluZGV4IGYyNjcw
YTlmMjE4Yy4uMzE2MjYzYzQ3YzAwIDEwMDY0NAotLS0gYS9hcmNoL2FybTY0L2xpYi9tZW1zZXQu
UworKysgYi9hcmNoL2FybTY0L2xpYi9tZW1zZXQuUwpAQCAtNTQsOSArNTQsOCBAQCBkc3QJCS5y
ZXEJeDgKIHRtcDN3CQkucmVxCXc5CiB0bXAzCQkucmVxCXg5CiAKLQkud2VhayBtZW1zZXQKIEVO
VFJZKF9fbWVtc2V0KQotRU5UUlkobWVtc2V0KQorV0VBSyhtZW1zZXQpCiAJbW92CWRzdCwgZHN0
aW4JLyogUHJlc2VydmUgcmV0dXJuIHZhbHVlLiAgKi8KIAlhbmQJQV9sdywgdmFsLCAjMjU1CiAJ
b3JyCUFfbHcsIEFfbHcsIEFfbHcsIGxzbCAjOAotLSAKMi4yOS4yLjY4NC5nZmJjNjRjNWFiNS1n
b29nCgo=
--000000000000fac5a105b674d551--
