Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72216456389
	for <lists+stable@lfdr.de>; Thu, 18 Nov 2021 20:30:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231777AbhKRTdv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 14:33:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230193AbhKRTdv (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 14:33:51 -0500
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29129C061574
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 11:30:51 -0800 (PST)
Received: by mail-oi1-x236.google.com with SMTP id r26so16548944oiw.5
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 11:30:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=8CrwHIK8wfOmvoIoGDOpTxU7ZdZXn3dqhNI1vCmBWtQ=;
        b=VNogfUsBxJMZt+MBcf7TkUbXhjbkBnqWKq7v+eZDfRdLjFlVf9hR5YWIlatNu6nu97
         YAGPrafRepT22RIK9R+xDwbqR2DV79wve3nAhCNJKPAr3ilGykZP5KOA9ewkmc/unOWN
         cKQrluiJ3l+VrPNaQ9a5ba/yW6iEiPttrnw+l3iH0LLljrMDrQxR5inOEIk+3I9Q4l++
         X/T8k+AlpEyI9yO/hjy6aJ3nh+wssbtLyexaz16gU4Bbmvldybl0nXTuznnrG46j7Bn2
         ESkZp/rQix92E2o72jvn5/GvQ8v21PR+kCVZgCp9CvBPsNkdUgrj+62pshAZiJGjucSJ
         5Vhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=8CrwHIK8wfOmvoIoGDOpTxU7ZdZXn3dqhNI1vCmBWtQ=;
        b=5JUzZEkNuGKd/XTFtGeGnJYf7TKoQ/jdvrNO22t5uK9glCEerEKG7+cfTP/jPqB8D7
         RrvvfDBIuaHLibHDL1lGWOD/yqnpqummeOgT7myvDvNrKhtwam6x0W+s8Ovkqb5iiAd+
         yqkZSuVS874q2c6Lccnz+0BczWIa5M8nuQM8iKFe5F+1GRTLWfke1xF4FIPt+phSXim1
         EwMln8JzQPEJeQ/B3HMw7hjz422uGmWqwlOSQewCNLCc7L3SgnXd/MAKlRsL4Lc7EPey
         4D0Q75b7JMyIlTpOQynGM25ZO+ot9yC2ePtZfiN0TlNvztgxvaiAzqfIGVoLV9X4OAmd
         haCQ==
X-Gm-Message-State: AOAM530WCvw+PkGaeiapJVBIa21Whq5TMxsfRUyHSln7VDBUn57aPu7x
        rR+R2TNTpCo4KAPhM5baAslzGT/Le1qYRCrPp1KD9g==
X-Google-Smtp-Source: ABdhPJxW7RmI7G1H3Hzd4Sk7xeimJ9d7Magr2eW9+UrDYJuHqWdYVzQ2MKqlziUKMjQZYGF2xz96vzTldJIt1gl0pxs=
X-Received: by 2002:a05:6808:cf:: with SMTP id t15mr9469217oic.43.1637263850366;
 Thu, 18 Nov 2021 11:30:50 -0800 (PST)
MIME-Version: 1.0
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 18 Nov 2021 11:30:38 -0800
Message-ID: <CAKwvOdmaGrk80s5T9uDMd-XEVTOUupaCxiU1mbtkk9K276KS5w@mail.gmail.com>
Subject: backport of 14831fad73f5 for 5.10 and 5.4
To:     Sasha Levin <sashal@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        Lucas Henneman <henneman@google.com>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Will Deacon <will@kernel.org>, llvm@lists.linux.dev
Content-Type: multipart/mixed; boundary="00000000000034d98905d115324f"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--00000000000034d98905d115324f
Content-Type: text/plain; charset="UTF-8"

Dear stable kernel maintainers,
Please consider applying the attached backport of 14831fad73f5 to
linux-5.10.y and linux-5.4.y.

14831fad73f5 first landed in v5.16-rc1.

There was a minor conflict due to missing e35123d83ee3 ("arm64: lto:
Strengthen READ_ONCE() to acquire when CONFIG_LTO=y") which first
landed in v5.11-rc1.

It fixes a minor warning observed during `make mrproper` for Android
kernel builds.
-- 
Thanks,
~Nick Desaulniers

--00000000000034d98905d115324f
Content-Type: application/octet-stream; 
	name="14831fad73f5.5.10.and.5.4.patch"
Content-Disposition: attachment; filename="14831fad73f5.5.10.and.5.4.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kw5clzut0>
X-Attachment-Id: f_kw5clzut0

RnJvbSA2ZjE4YmI5MjcxNmFkOGM3MGU0NzM4ZTc3ZmY4MmU5OGYwMjM4NmUxIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOaWNrIERlc2F1bG5pZXJzIDxuZGVzYXVsbmllcnNAZ29vZ2xl
LmNvbT4KRGF0ZTogVHVlLCAxOSBPY3QgMjAyMSAxNTozNjo0NSAtMDcwMApTdWJqZWN0OiBbUEFU
Q0hdIGFybTY0OiB2ZHNvMzI6IHN1cHByZXNzIGVycm9yIG1lc3NhZ2UgZm9yICdtYWtlIG1ycHJv
cGVyJwoKY29tbWl0IDE0ODMxZmFkNzNmNWFjMzBhYzYxNzYwNDg3ZDk1YTUzOGU2YWIzY2IgdXBz
dHJlYW0uCgpXaGVuIHJ1bm5pbmcgdGhlIGZvbGxvd2luZyBjb21tYW5kIHdpdGhvdXQgYXJtLWxp
bnV4LWdudWVhYmktZ2NjIGluCm9uZSdzICRQQVRILCB0aGUgZm9sbG93aW5nIHdhcm5pbmcgaXMg
b2JzZXJ2ZWQ6CgokIEFSQ0g9YXJtNjQgQ1JPU1NfQ09NUElMRV9DT01QQVQ9YXJtLWxpbnV4LWdu
dWVhYmktIG1ha2UgLWo3MiBMTFZNPTEgbXJwcm9wZXIKbWFrZVsxXTogYXJtLWxpbnV4LWdudWVh
YmktZ2NjOiBObyBzdWNoIGZpbGUgb3IgZGlyZWN0b3J5CgpUaGlzIGlzIGJlY2F1c2UgS0NPTkZJ
RyBpcyBub3QgcnVuIGZvciBtcnByb3Blciwgc28gQ09ORklHX0NDX0lTX0NMQU5HCmlzIG5vdCBz
ZXQsIGFuZCB3ZSBlbmQgdXAgZWFnZXJseSBldmFsdWF0aW5nIHZhcmlvdXMgdmFyaWFibGVzIHRo
YXQgdHJ5CnRvIGludm9rZSBDQ19DT01QQVQuCgpUaGlzIGlzIGEgc2ltaWxhciBwcm9ibGVtIHRv
IHdoYXQgd2FzIG9ic2VydmVkIGluCmNvbW1pdCBkYzk2MGJmZWVkYjAgKCJoODMwMDogc3VwcHJl
c3MgZXJyb3IgbWVzc2FnZXMgZm9yICdtYWtlIGNsZWFuJyIpCgpSZXBvcnRlZC1ieTogTHVjYXMg
SGVubmVtYW4gPGhlbm5lbWFuQGdvb2dsZS5jb20+ClN1Z2dlc3RlZC1ieTogTWFzYWhpcm8gWWFt
YWRhIDxtYXNhaGlyb3lAa2VybmVsLm9yZz4KW25kOiBhZGp1c3RlZCBjb250ZXh0IGR1ZSB0byBt
aXNzaW5nIGUzNTEyM2Q4M2VlM10KU2lnbmVkLW9mZi1ieTogTmljayBEZXNhdWxuaWVycyA8bmRl
c2F1bG5pZXJzQGdvb2dsZS5jb20+ClJldmlld2VkLWJ5OiBWaW5jZW56byBGcmFzY2lubyA8dmlu
Y2Vuem8uZnJhc2Npbm9AYXJtLmNvbT4KUmV2aWV3ZWQtYnk6IE5hdGhhbiBDaGFuY2VsbG9yIDxu
YXRoYW5Aa2VybmVsLm9yZz4KVGVzdGVkLWJ5OiBOYXRoYW4gQ2hhbmNlbGxvciA8bmF0aGFuQGtl
cm5lbC5vcmc+Ckxpbms6IGh0dHBzOi8vbG9yZS5rZXJuZWwub3JnL3IvMjAyMTEwMTkyMjM2NDYu
MTE0Njk0NS00LW5kZXNhdWxuaWVyc0Bnb29nbGUuY29tClNpZ25lZC1vZmYtYnk6IFdpbGwgRGVh
Y29uIDx3aWxsQGtlcm5lbC5vcmc+Ci0tLQogYXJjaC9hcm02NC9rZXJuZWwvdmRzbzMyL01ha2Vm
aWxlIHwgMyArKy0KIDEgZmlsZSBjaGFuZ2VkLCAyIGluc2VydGlvbnMoKyksIDEgZGVsZXRpb24o
LSkKCmRpZmYgLS1naXQgYS9hcmNoL2FybTY0L2tlcm5lbC92ZHNvMzIvTWFrZWZpbGUgYi9hcmNo
L2FybTY0L2tlcm5lbC92ZHNvMzIvTWFrZWZpbGUKaW5kZXggNDBkZmZlNjBiODQ1Li41MTk1N2E1
ODVlNjYgMTAwNjQ0Ci0tLSBhL2FyY2gvYXJtNjQva2VybmVsL3Zkc28zMi9NYWtlZmlsZQorKysg
Yi9hcmNoL2FybTY0L2tlcm5lbC92ZHNvMzIvTWFrZWZpbGUKQEAgLTMyLDcgKzMyLDggQEAgY2Mz
Mi1hcy1pbnN0ciA9ICQoY2FsbCB0cnktcnVuLFwKICMgQXMgYSByZXN1bHQgd2Ugc2V0IG91ciBv
d24gZmxhZ3MgaGVyZS4KIAogIyBLQlVJTERfQ1BQRkxBR1MgYW5kIE5PU1RESU5DX0ZMQUdTIGZy
b20gdG9wLWxldmVsIE1ha2VmaWxlCi1WRFNPX0NQUEZMQUdTIDo9IC1EX19LRVJORUxfXyAtbm9z
dGRpbmMgLWlzeXN0ZW0gJChzaGVsbCAkKENDX0NPTVBBVCkgLXByaW50LWZpbGUtbmFtZT1pbmNs
dWRlKQorVkRTT19DUFBGTEFHUyA6PSAtRF9fS0VSTkVMX18gLW5vc3RkaW5jCitWRFNPX0NQUEZM
QUdTICs9IC1pc3lzdGVtICQoc2hlbGwgJChDQ19DT01QQVQpIC1wcmludC1maWxlLW5hbWU9aW5j
bHVkZSkKIFZEU09fQ1BQRkxBR1MgKz0gJChMSU5VWElOQ0xVREUpCiAKICMgQ29tbW9uIEMgYW5k
IGFzc2VtYmx5IGZsYWdzCi0tIAoyLjM0LjAucmMyLjM5My5nZjhjOTY2Njg4MC1nb29nCgo=
--00000000000034d98905d115324f--
