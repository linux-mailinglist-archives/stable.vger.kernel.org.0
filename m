Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EDA0F2D6984
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 22:17:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393977AbgLJVQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 16:16:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2393972AbgLJVQW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 16:16:22 -0500
Received: from mail-pg1-x52c.google.com (mail-pg1-x52c.google.com [IPv6:2607:f8b0:4864:20::52c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA716C0613D3
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:15:41 -0800 (PST)
Received: by mail-pg1-x52c.google.com with SMTP id f17so5419075pge.6
        for <stable@vger.kernel.org>; Thu, 10 Dec 2020 13:15:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c/Z+W5gJnx4o8Cy+7lP4E9JoVV/hTursPoZHURQt0Ms=;
        b=JRsgCJVVOUG9EQJiGSfC7dnvr1hHS4TD8G4DmrbmK3PvZ7PIJ5d6Dyvt9PUDOuuirl
         5dUGAMxEL6Yg6vTt7AJEBVp2hparfkLoYARKbn4S4JDhQpj0VmGAKBzSoa/JsFtjOUFY
         13FOUpkWfVAMzLUv6P/TCze/AGMcMDb7UOfrpxdQ3+3HmhXJgSSfVFy4eFigiNFTOb+O
         8Q0B0GWVDN37LvmA+2j1R77JGQFIAmMRQFRY16Ez64+G+5cnu7lMxGm/gVoKGpDQ2S15
         SY/Sngp+o+nrjr9pZM2Bk6YLnAKT2BZCQYXVtbcwDaaGFiVVC6LOxGZfjXIKwuOlveoJ
         Pc4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c/Z+W5gJnx4o8Cy+7lP4E9JoVV/hTursPoZHURQt0Ms=;
        b=DaVxzw/q4pf8Pjem1hueIDxIQPI6dfuYsrMxmzFj0FH5qI7+XXRU0HplfwKtJTE1bq
         jyjU9pf2TSOQkSqoGfM85bI0FGcqt0sRep2duop/NjR31nYM3fLzGS1vw+0ZAVhy2n4D
         Y9KW+E5SgacgR5df8sSoNfrxggrgarBC2wbnRgp2on81sxTr5kiXBIHxZ5AKdSKys81S
         4xkYHaSlwWzOVIujLtFCMvHBkFdCY4UmXp44+e1OZQCFxWibAtXFmGGKtzLBDkQpQH0F
         /iGPrGFRtW8qThziVtf1aOwPmUm1Ygo2989GjY2HmD1MhK6NMEUdV4SkAXl+0nN+oruf
         nDNQ==
X-Gm-Message-State: AOAM531/2hh+PQk/5lbdCtY/eZwElQAJ2oDJiHm3j7L+bpAKjZOJ0Pii
        XZIWYo3WIetDVV0hB+9M2SNBFtSdtAkclepCHBkIvg==
X-Google-Smtp-Source: ABdhPJyqeKVvSVQ0gu0+PJqSFf0OvUol3fzLQwUnmVdDIKCgeRclJHVSii0fSmp4zH4g0M6ohGHp4ccmLWb2WmIWlgg=
X-Received: by 2002:a63:3247:: with SMTP id y68mr8430697pgy.10.1607634941169;
 Thu, 10 Dec 2020 13:15:41 -0800 (PST)
MIME-Version: 1.0
References: <CAKwvOdkK1LgLC4ChptzUTC45WvE9-Sn0OqtgF7-odNSw8xLTYA@mail.gmail.com>
 <a3b89f95-2635-ff9d-4248-4e5e3065ff85@kernel.org> <e9695da9-8b83-39a5-8781-47ae4c7d2e51@kernel.org>
In-Reply-To: <e9695da9-8b83-39a5-8781-47ae4c7d2e51@kernel.org>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Thu, 10 Dec 2020 13:15:29 -0800
Message-ID: <CAKwvOdnUe3_fVCoxx2=bF=E8vsuOJMoZHzCfB0ES1dPU7q_PDw@mail.gmail.com>
Subject: Re: 5.4 and 4.19 fix for LLVM_IAS/clang-12
To:     Jiri Slaby <jirislaby@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>, stable <stable@vger.kernel.org>,
        Jian Cai <jiancai@google.com>,
        Fangrui Song <maskray@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Borislav Petkov <bp@suse.de>,
        Nathan Chancellor <natechancellor@gmail.com>,
        clang-built-linux <clang-built-linux@googlegroups.com>
Content-Type: multipart/mixed; boundary="0000000000009afbda05b622ad27"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000009afbda05b622ad27
Content-Type: text/plain; charset="UTF-8"

On Tue, Dec 8, 2020 at 11:21 PM Jiri Slaby <jirislaby@kernel.org> wrote:
>
> On 09. 12. 20, 8:20, Jiri Slaby wrote:
> > On 09. 12. 20, 1:12, Nick Desaulniers wrote:
> >> Dear stable kernel maintainers,
> >> Please consider accepting the following backport to 5.4 and 4.19 of
> >> commit 4d6ffa27b8e5 ("x86/lib: Change .weak to SYM_FUNC_START_WEAK for
> >> arch/x86/lib/mem*_64.S"), attached.

Also, first landed in v5.10-rc3. Exists in v5.9.7 as
305da744c138487864a46b2fb0bd7cf54e1e03b4.

> >>
> >> The patch to 5.4 had a conflict due to 5.4 missing upstream commit
> >> e9b9d020c487 ("x86/asm: Annotate aliases") which first landed in
> >> v5.5-rc1.
> >>
> >> The patch to 4.19 had a conflict due to 4.19 missing the above commit
> >> and ffedeeb780dc ("linkage: Introduce new macros for assembler
> >> symbols") which also first landed in v5.5-rc1 but was backported to
> >> linux-5.4.y as commit 840d8c9b3e5f ("linkage: Introduce new macros for
> >> assembler symbols") which shipped in v5.4.76.
> >>
> >> This patch fixes a build error from clang's assembler when building
> >> with Clang-12, which now errors when symbols are redeclared with
> >> different bindings.  We're using clang's assembler in Android and
> >> ChromeOS for 4.19+.
> >>
> >> Jiri, would you mind reviewing the 4.19 patch (or both)?  It simply
> >> open codes what the upstream macros would expand to; this can be and
> >> was observed from running:
> >
> > You don't have to touch (expand) __memcpy, __memmove, and __memset, right?

Sure, attached a v2.  It's actually a little cleaner (smaller
diffstat) that way.

>
> Also, no need for doubled p2align.

eh, maybe, but
1. it's what SYM_FUNC_START expands to precisely; removing it would be
(too) different from what upstream is doing IMO.
2. it's obviously doubled when in v1 I was expanding the __ prefixed
symbols as well; not so obvious in v2.
3. the order of __ prefixed symbols differs between these three; I'd
rather not rely on the order or have to reorder them to get the
initial symbol realigned; specifying the alignment for both seems
safer to me.

So I haven't included that suggestion in v2, but please feel free to
convince me otherwise if you feel strongly.

Thanks for taking the time to review.  I appreciate it.
-- 
Thanks,
~Nick Desaulniers

--0000000000009afbda05b622ad27
Content-Type: text/plain; charset="US-ASCII"; name="4d6ffa27b8e5.4.19.v2.patch.txt"
Content-Disposition: attachment; filename="4d6ffa27b8e5.4.19.v2.patch.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_kijbxmod0>
X-Attachment-Id: f_kijbxmod0

RnJvbSA1NzA3YmVhMGZjZWY2MjYzZDNiMjNjNWYwYjYxZTZhMjg5ZDU0YzIyIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBGYW5ncnVpIFNvbmcgPG1hc2tyYXlAZ29vZ2xlLmNvbT4KRGF0
ZTogTW9uLCAyIE5vdiAyMDIwIDE3OjIzOjU4IC0wODAwClN1YmplY3Q6IFtQQVRDSF0geDg2L2xp
YjogQ2hhbmdlIC53ZWFrIHRvIFNZTV9GVU5DX1NUQVJUX1dFQUsgZm9yCiBhcmNoL3g4Ni9saWIv
bWVtKl82NC5TCgpjb21taXQgNGQ2ZmZhMjdiOGU1MTE2YzBhYmIzMTg3OTBmZDAxZDRlMTJkNzVl
NiB1cHN0cmVhbS4KCkNvbW1pdAoKICAzOTNmMjAzZjVmZDUgKCJ4ODZfNjQ6IGthc2FuOiBhZGQg
aW50ZXJjZXB0b3JzIGZvciBtZW1zZXQvbWVtbW92ZS9tZW1jcHkgZnVuY3Rpb25zIikKCmFkZGVk
IC53ZWFrIGRpcmVjdGl2ZXMgdG8gYXJjaC94ODYvbGliL21lbSpfNjQuUyBpbnN0ZWFkIG9mIGNo
YW5naW5nIHRoZQpleGlzdGluZyBFTlRSWSBtYWNyb3MgdG8gV0VBSy4gVGhpcyBjYW4gbGVhZCB0
byB0aGUgYXNzZW1ibHkgc25pcHBldAoKICAud2VhayBtZW1jcHkKICAuLi4KICAuZ2xvYmwgbWVt
Y3B5Cgp3aGljaCB3aWxsIHByb2R1Y2UgYSBTVEJfV0VBSyBtZW1jcHkgd2l0aCBHTlUgYXMgYnV0
IFNUQl9HTE9CQUwgbWVtY3B5CndpdGggTExWTSdzIGludGVncmF0ZWQgYXNzZW1ibGVyIGJlZm9y
ZSBMTFZNIDEyLiBMTFZNIDEyIChzaW5jZQpodHRwczovL3Jldmlld3MubGx2bS5vcmcvRDkwMTA4
KSB3aWxsIGVycm9yIG9uIHN1Y2ggYW4gb3ZlcnJpZGRlbiBzeW1ib2wKYmluZGluZy4KCkNvbW1p
dAoKICBlZjFlMDMxNTJjYjAgKCJ4ODYvYXNtOiBNYWtlIHNvbWUgZnVuY3Rpb25zIGxvY2FsIikK
CmNoYW5nZWQgRU5UUlkgaW4gYXJjaC94ODYvbGliL21lbWNweV82NC5TIHRvIFNZTV9GVU5DX1NU
QVJUX0xPQ0FMLCB3aGljaAp3YXMgaW5lZmZlY3RpdmUgZHVlIHRvIHRoZSBwcmVjZWRpbmcgLndl
YWsgZGlyZWN0aXZlLgoKVXNlIHRoZSBhcHByb3ByaWF0ZSBTWU1fRlVOQ19TVEFSVF9XRUFLIGlu
c3RlYWQuCgpGaXhlczogMzkzZjIwM2Y1ZmQ1ICgieDg2XzY0OiBrYXNhbjogYWRkIGludGVyY2Vw
dG9ycyBmb3IgbWVtc2V0L21lbW1vdmUvbWVtY3B5IGZ1bmN0aW9ucyIpCkZpeGVzOiBlZjFlMDMx
NTJjYjAgKCJ4ODYvYXNtOiBNYWtlIHNvbWUgZnVuY3Rpb25zIGxvY2FsIikKUmVwb3J0ZWQtYnk6
IFNhbWkgVG9sdmFuZW4gPHNhbWl0b2x2YW5lbkBnb29nbGUuY29tPgpTaWduZWQtb2ZmLWJ5OiBG
YW5ncnVpIFNvbmcgPG1hc2tyYXlAZ29vZ2xlLmNvbT4KU2lnbmVkLW9mZi1ieTogQm9yaXNsYXYg
UGV0a292IDxicEBzdXNlLmRlPgpSZXZpZXdlZC1ieTogTmljayBEZXNhdWxuaWVycyA8bmRlc2F1
bG5pZXJzQGdvb2dsZS5jb20+ClRlc3RlZC1ieTogTmF0aGFuIENoYW5jZWxsb3IgPG5hdGVjaGFu
Y2VsbG9yQGdtYWlsLmNvbT4KVGVzdGVkLWJ5OiBOaWNrIERlc2F1bG5pZXJzIDxuZGVzYXVsbmll
cnNAZ29vZ2xlLmNvbT4KQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgpMaW5rOiBodHRwczov
L2xrbWwua2VybmVsLm9yZy9yLzIwMjAxMTAzMDEyMzU4LjE2ODY4Mi0xLW1hc2tyYXlAZ29vZ2xl
LmNvbQpbbmQ6IGJhY2twb3J0IGR1ZSB0byBtaXNzaW5nCiAgY29tbWl0IGU5YjlkMDIwYzQ4NyAo
Ing4Ni9hc206IEFubm90YXRlIGFsaWFzZXMiKQogIGNvbW1pdCBmZmVkZWViNzgwZGMgKCJsaW5r
YWdlOiBJbnRyb2R1Y2UgbmV3IG1hY3JvcyBmb3IgYXNzZW1ibGVyIHN5bWJvbHMiKV0KU2lnbmVk
LW9mZi1ieTogTmljayBEZXNhdWxuaWVycyA8bmRlc2F1bG5pZXJzQGdvb2dsZS5jb20+Ci0tLQog
YXJjaC94ODYvbGliL21lbWNweV82NC5TICB8IDYgKysrLS0tCiBhcmNoL3g4Ni9saWIvbWVtbW92
ZV82NC5TIHwgNCArKy0tCiBhcmNoL3g4Ni9saWIvbWVtc2V0XzY0LlMgIHwgNiArKystLS0KIDMg
ZmlsZXMgY2hhbmdlZCwgOCBpbnNlcnRpb25zKCspLCA4IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2xpYi9tZW1jcHlfNjQuUyBiL2FyY2gveDg2L2xpYi9tZW1jcHlfNjQuUwpp
bmRleCA5ZDA1NTcyMzcwZWQuLjg0YjAwNzgyNzJkMSAxMDA2NDQKLS0tIGEvYXJjaC94ODYvbGli
L21lbWNweV82NC5TCisrKyBiL2FyY2gveDg2L2xpYi9tZW1jcHlfNjQuUwpAQCAtMTQsOCArMTQs
NiBAQAogICogdG8gYSBqbXAgdG8gbWVtY3B5X2VybXMgd2hpY2ggZG9lcyB0aGUgUkVQOyBNT1ZT
QiBtZW0gY29weS4KICAqLwogCi0ud2VhayBtZW1jcHkKLQogLyoKICAqIG1lbWNweSAtIENvcHkg
YSBtZW1vcnkgYmxvY2suCiAgKgpAQCAtMjgsNyArMjYsOSBAQAogICogcmF4IG9yaWdpbmFsIGRl
c3RpbmF0aW9uCiAgKi8KIEVOVFJZKF9fbWVtY3B5KQotRU5UUlkobWVtY3B5KQorLndlYWsgbWVt
Y3B5CisucDJhbGlnbiA0LCAweDkwCittZW1jcHk6CiAJQUxURVJOQVRJVkVfMiAiam1wIG1lbWNw
eV9vcmlnIiwgIiIsIFg4Nl9GRUFUVVJFX1JFUF9HT09ELCBcCiAJCSAgICAgICJqbXAgbWVtY3B5
X2VybXMiLCBYODZfRkVBVFVSRV9FUk1TCiAKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2xpYi9tZW1t
b3ZlXzY0LlMgYi9hcmNoL3g4Ni9saWIvbWVtbW92ZV82NC5TCmluZGV4IGJiZWM2OWQ4MjIzYi4u
ZTFjZmM4ODBmNDJkIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9saWIvbWVtbW92ZV82NC5TCisrKyBi
L2FyY2gveDg2L2xpYi9tZW1tb3ZlXzY0LlMKQEAgLTI1LDggKzI1LDggQEAKICAqIHJheDogZGVz
dAogICovCiAud2VhayBtZW1tb3ZlCi0KLUVOVFJZKG1lbW1vdmUpCisucDJhbGlnbiA0LCAweDkw
CittZW1tb3ZlOgogRU5UUlkoX19tZW1tb3ZlKQogCiAJLyogSGFuZGxlIG1vcmUgMzIgYnl0ZXMg
aW4gbG9vcCAqLwpkaWZmIC0tZ2l0IGEvYXJjaC94ODYvbGliL21lbXNldF82NC5TIGIvYXJjaC94
ODYvbGliL21lbXNldF82NC5TCmluZGV4IDliYzg2MWM3MWU3NS4uMDg0MTg5YWNkY2QwIDEwMDY0
NAotLS0gYS9hcmNoL3g4Ni9saWIvbWVtc2V0XzY0LlMKKysrIGIvYXJjaC94ODYvbGliL21lbXNl
dF82NC5TCkBAIC02LDggKzYsNiBAQAogI2luY2x1ZGUgPGFzbS9hbHRlcm5hdGl2ZS1hc20uaD4K
ICNpbmNsdWRlIDxhc20vZXhwb3J0Lmg+CiAKLS53ZWFrIG1lbXNldAotCiAvKgogICogSVNPIEMg
bWVtc2V0IC0gc2V0IGEgbWVtb3J5IGJsb2NrIHRvIGEgYnl0ZSB2YWx1ZS4gVGhpcyBmdW5jdGlv
biB1c2VzIGZhc3QKICAqIHN0cmluZyB0byBnZXQgYmV0dGVyIHBlcmZvcm1hbmNlIHRoYW4gdGhl
IG9yaWdpbmFsIGZ1bmN0aW9uLiBUaGUgY29kZSBpcwpAQCAtMTksNyArMTcsOSBAQAogICoKICAq
IHJheCAgIG9yaWdpbmFsIGRlc3RpbmF0aW9uCiAgKi8KLUVOVFJZKG1lbXNldCkKKy53ZWFrIG1l
bXNldAorLnAyYWxpZ24gNCwgMHg5MAorbWVtc2V0OgogRU5UUlkoX19tZW1zZXQpCiAJLyoKIAkg
KiBTb21lIENQVXMgc3VwcG9ydCBlbmhhbmNlZCBSRVAgTU9WU0IvU1RPU0IgZmVhdHVyZS4gSXQg
aXMgcmVjb21tZW5kZWQKLS0gCjIuMjkuMi41NzYuZ2EzZmM0NDZkODQtZ29vZwoK
--0000000000009afbda05b622ad27
Content-Type: text/plain; charset="US-ASCII"; name="4d6ffa27b8e5.5.4.v2.patch.txt"
Content-Disposition: attachment; filename="4d6ffa27b8e5.5.4.v2.patch.txt"
Content-Transfer-Encoding: base64
Content-ID: <f_kijcb7292>
X-Attachment-Id: f_kijcb7292

RnJvbSA0OTg1ZTVkMDcwMTM1YzU2Y2UwOTFiZDE2MDE5OTZlYzQ3NDE5ZDA3IE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBGYW5ncnVpIFNvbmcgPG1hc2tyYXlAZ29vZ2xlLmNvbT4KRGF0
ZTogTW9uLCAyIE5vdiAyMDIwIDE3OjIzOjU4IC0wODAwClN1YmplY3Q6IFtQQVRDSF0geDg2L2xp
YjogQ2hhbmdlIC53ZWFrIHRvIFNZTV9GVU5DX1NUQVJUX1dFQUsgZm9yCiBhcmNoL3g4Ni9saWIv
bWVtKl82NC5TCgpjb21taXQgNGQ2ZmZhMjdiOGU1MTE2YzBhYmIzMTg3OTBmZDAxZDRlMTJkNzVl
NiB1cHN0cmVhbS4KCkNvbW1pdAoKICAzOTNmMjAzZjVmZDUgKCJ4ODZfNjQ6IGthc2FuOiBhZGQg
aW50ZXJjZXB0b3JzIGZvciBtZW1zZXQvbWVtbW92ZS9tZW1jcHkgZnVuY3Rpb25zIikKCmFkZGVk
IC53ZWFrIGRpcmVjdGl2ZXMgdG8gYXJjaC94ODYvbGliL21lbSpfNjQuUyBpbnN0ZWFkIG9mIGNo
YW5naW5nIHRoZQpleGlzdGluZyBFTlRSWSBtYWNyb3MgdG8gV0VBSy4gVGhpcyBjYW4gbGVhZCB0
byB0aGUgYXNzZW1ibHkgc25pcHBldAoKICAud2VhayBtZW1jcHkKICAuLi4KICAuZ2xvYmwgbWVt
Y3B5Cgp3aGljaCB3aWxsIHByb2R1Y2UgYSBTVEJfV0VBSyBtZW1jcHkgd2l0aCBHTlUgYXMgYnV0
IFNUQl9HTE9CQUwgbWVtY3B5CndpdGggTExWTSdzIGludGVncmF0ZWQgYXNzZW1ibGVyIGJlZm9y
ZSBMTFZNIDEyLiBMTFZNIDEyIChzaW5jZQpodHRwczovL3Jldmlld3MubGx2bS5vcmcvRDkwMTA4
KSB3aWxsIGVycm9yIG9uIHN1Y2ggYW4gb3ZlcnJpZGRlbiBzeW1ib2wKYmluZGluZy4KCkNvbW1p
dAoKICBlZjFlMDMxNTJjYjAgKCJ4ODYvYXNtOiBNYWtlIHNvbWUgZnVuY3Rpb25zIGxvY2FsIikK
CmNoYW5nZWQgRU5UUlkgaW4gYXJjaC94ODYvbGliL21lbWNweV82NC5TIHRvIFNZTV9GVU5DX1NU
QVJUX0xPQ0FMLCB3aGljaAp3YXMgaW5lZmZlY3RpdmUgZHVlIHRvIHRoZSBwcmVjZWRpbmcgLndl
YWsgZGlyZWN0aXZlLgoKVXNlIHRoZSBhcHByb3ByaWF0ZSBTWU1fRlVOQ19TVEFSVF9XRUFLIGlu
c3RlYWQuCgpGaXhlczogMzkzZjIwM2Y1ZmQ1ICgieDg2XzY0OiBrYXNhbjogYWRkIGludGVyY2Vw
dG9ycyBmb3IgbWVtc2V0L21lbW1vdmUvbWVtY3B5IGZ1bmN0aW9ucyIpCkZpeGVzOiBlZjFlMDMx
NTJjYjAgKCJ4ODYvYXNtOiBNYWtlIHNvbWUgZnVuY3Rpb25zIGxvY2FsIikKUmVwb3J0ZWQtYnk6
IFNhbWkgVG9sdmFuZW4gPHNhbWl0b2x2YW5lbkBnb29nbGUuY29tPgpTaWduZWQtb2ZmLWJ5OiBG
YW5ncnVpIFNvbmcgPG1hc2tyYXlAZ29vZ2xlLmNvbT4KU2lnbmVkLW9mZi1ieTogQm9yaXNsYXYg
UGV0a292IDxicEBzdXNlLmRlPgpSZXZpZXdlZC1ieTogTmljayBEZXNhdWxuaWVycyA8bmRlc2F1
bG5pZXJzQGdvb2dsZS5jb20+ClRlc3RlZC1ieTogTmF0aGFuIENoYW5jZWxsb3IgPG5hdGVjaGFu
Y2VsbG9yQGdtYWlsLmNvbT4KVGVzdGVkLWJ5OiBOaWNrIERlc2F1bG5pZXJzIDxuZGVzYXVsbmll
cnNAZ29vZ2xlLmNvbT4KQ2M6IDxzdGFibGVAdmdlci5rZXJuZWwub3JnPgpMaW5rOiBodHRwczov
L2xrbWwua2VybmVsLm9yZy9yLzIwMjAxMTAzMDEyMzU4LjE2ODY4Mi0xLW1hc2tyYXlAZ29vZ2xl
LmNvbQpbbmQ6IGJhY2twb3J0IGR1ZSB0byBtaXNzaW5nIGNvbW1pdCBlOWI5ZDAyMGM0ODcgKCJ4
ODYvYXNtOiBBbm5vdGF0ZSBhbGlhc2VzIildClNpZ25lZC1vZmYtYnk6IE5pY2sgRGVzYXVsbmll
cnMgPG5kZXNhdWxuaWVyc0Bnb29nbGUuY29tPgotLS0KIGFyY2gveDg2L2xpYi9tZW1jcHlfNjQu
UyAgfCA0ICstLS0KIGFyY2gveDg2L2xpYi9tZW1tb3ZlXzY0LlMgfCA0ICstLS0KIGFyY2gveDg2
L2xpYi9tZW1zZXRfNjQuUyAgfCA0ICstLS0KIDMgZmlsZXMgY2hhbmdlZCwgMyBpbnNlcnRpb25z
KCspLCA5IGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2xpYi9tZW1jcHlfNjQu
UyBiL2FyY2gveDg2L2xpYi9tZW1jcHlfNjQuUwppbmRleCA5Mjc0ODY2MGJhNTEuLmRjMmZiODg2
ZGIyYiAxMDA2NDQKLS0tIGEvYXJjaC94ODYvbGliL21lbWNweV82NC5TCisrKyBiL2FyY2gveDg2
L2xpYi9tZW1jcHlfNjQuUwpAQCAtMTUsOCArMTUsNiBAQAogICogdG8gYSBqbXAgdG8gbWVtY3B5
X2VybXMgd2hpY2ggZG9lcyB0aGUgUkVQOyBNT1ZTQiBtZW0gY29weS4KICAqLwogCi0ud2VhayBt
ZW1jcHkKLQogLyoKICAqIG1lbWNweSAtIENvcHkgYSBtZW1vcnkgYmxvY2suCiAgKgpAQCAtMjks
NyArMjcsNyBAQAogICogcmF4IG9yaWdpbmFsIGRlc3RpbmF0aW9uCiAgKi8KIEVOVFJZKF9fbWVt
Y3B5KQotRU5UUlkobWVtY3B5KQorU1lNX0ZVTkNfU1RBUlRfV0VBSyhtZW1jcHkpCiAJQUxURVJO
QVRJVkVfMiAiam1wIG1lbWNweV9vcmlnIiwgIiIsIFg4Nl9GRUFUVVJFX1JFUF9HT09ELCBcCiAJ
CSAgICAgICJqbXAgbWVtY3B5X2VybXMiLCBYODZfRkVBVFVSRV9FUk1TCiAKZGlmZiAtLWdpdCBh
L2FyY2gveDg2L2xpYi9tZW1tb3ZlXzY0LlMgYi9hcmNoL3g4Ni9saWIvbWVtbW92ZV82NC5TCmlu
ZGV4IGJiZWM2OWQ4MjIzYi4uYjI5MjQ0NTQ2N2I2IDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9saWIv
bWVtbW92ZV82NC5TCisrKyBiL2FyY2gveDg2L2xpYi9tZW1tb3ZlXzY0LlMKQEAgLTI0LDkgKzI0
LDcgQEAKICAqIE91dHB1dDoKICAqIHJheDogZGVzdAogICovCi0ud2VhayBtZW1tb3ZlCi0KLUVO
VFJZKG1lbW1vdmUpCitTWU1fRlVOQ19TVEFSVF9XRUFLKG1lbW1vdmUpCiBFTlRSWShfX21lbW1v
dmUpCiAKIAkvKiBIYW5kbGUgbW9yZSAzMiBieXRlcyBpbiBsb29wICovCmRpZmYgLS1naXQgYS9h
cmNoL3g4Ni9saWIvbWVtc2V0XzY0LlMgYi9hcmNoL3g4Ni9saWIvbWVtc2V0XzY0LlMKaW5kZXgg
OWJjODYxYzcxZTc1Li5lMzM3NmM3ZDRjOTcgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2xpYi9tZW1z
ZXRfNjQuUworKysgYi9hcmNoL3g4Ni9saWIvbWVtc2V0XzY0LlMKQEAgLTYsOCArNiw2IEBACiAj
aW5jbHVkZSA8YXNtL2FsdGVybmF0aXZlLWFzbS5oPgogI2luY2x1ZGUgPGFzbS9leHBvcnQuaD4K
IAotLndlYWsgbWVtc2V0Ci0KIC8qCiAgKiBJU08gQyBtZW1zZXQgLSBzZXQgYSBtZW1vcnkgYmxv
Y2sgdG8gYSBieXRlIHZhbHVlLiBUaGlzIGZ1bmN0aW9uIHVzZXMgZmFzdAogICogc3RyaW5nIHRv
IGdldCBiZXR0ZXIgcGVyZm9ybWFuY2UgdGhhbiB0aGUgb3JpZ2luYWwgZnVuY3Rpb24uIFRoZSBj
b2RlIGlzCkBAIC0xOSw3ICsxNyw3IEBACiAgKgogICogcmF4ICAgb3JpZ2luYWwgZGVzdGluYXRp
b24KICAqLwotRU5UUlkobWVtc2V0KQorU1lNX0ZVTkNfU1RBUlRfV0VBSyhtZW1zZXQpCiBFTlRS
WShfX21lbXNldCkKIAkvKgogCSAqIFNvbWUgQ1BVcyBzdXBwb3J0IGVuaGFuY2VkIFJFUCBNT1ZT
Qi9TVE9TQiBmZWF0dXJlLiBJdCBpcyByZWNvbW1lbmRlZAotLSAKMi4yOS4yLjU3Ni5nYTNmYzQ0
NmQ4NC1nb29nCgo=
--0000000000009afbda05b622ad27--
