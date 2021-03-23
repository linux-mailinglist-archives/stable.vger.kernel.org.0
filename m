Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C1F4D346823
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 19:53:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231553AbhCWSwo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 14:52:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232327AbhCWSwj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 14:52:39 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F35DAC061763
        for <stable@vger.kernel.org>; Tue, 23 Mar 2021 11:52:38 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id 184so26999668ljf.9
        for <stable@vger.kernel.org>; Tue, 23 Mar 2021 11:52:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XdjW5KEjoRCXCPW8zm041OQzl9EtHj2xizq7KLEzF3w=;
        b=o3ghx8Ujdsf4QFI3oOZ+imPBXyxUjdzXajK38lbfGzH+fv2w30WIOAGeNUuFOPlbKz
         Ozv9T6De8DIjJGBg7ip+t0VWLawpv+UyFA9CH2xgEluXZ8uNt2SAZUA+6mHqXg0b3sX7
         R7vIifBRQ9v3V/db27mI8nr50hGYr4H14OpSylSq3YfHfb7LbGhflO4lnlU4sppR77Lu
         j6hvJbVl5lW8UiC7gL8HOqTGdq5/CDwE5n2KzhQ+t1dWSbcHU9cMtiKrMyk6SnUUqbee
         h+aLuvqvCZV26ykxr7rMBgVKXa1XDtr1Vs9PxLV3kB/RJul95wJh40HUzdYtmBs2BI1t
         9ohw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XdjW5KEjoRCXCPW8zm041OQzl9EtHj2xizq7KLEzF3w=;
        b=VrBxOVX0bJF2rYlGOhER5Qf8scmHvdc/IUCeJ+lDj89XpwEacXbJr4wyGwAGim5wM3
         FHyChi8RPnP2hH06Nyk69U0vRRw59W1SX4fLd1YB3S+tYa3ba+5WiWMD/SLWU0u/p7I1
         ReQwVDnU10xThUx6q3Y/dfovEdDnfi+2zwOk9glT6Gs8m8RuwJz9DkEEsaGeMU0um7f6
         nXaEf2WHDwXiE0eHjz1v3/QDS77PPeE5K1/CDfR9tVYKZAt5TgNCgGab+t8+g5hGgIvq
         722kL5TL8i1Z/XCZHiaoVLPFoCtrwl1ploQ7NvCactCGiGl8oeAK07ppGqdC/8A56+1s
         +5uA==
X-Gm-Message-State: AOAM531c+G5xJn3kZvxIQZYul5Ar1QQ/vstDVMijJMoRHZX0sWjUCW6H
        uDvfmzIjroMulvaAGOKiXgOUUmRMOrh7wqbwXKpy+Q==
X-Google-Smtp-Source: ABdhPJyTtD6DsiSMt+RC9bi3c92/twXZ2TtZQEnGOtVQgq9RKPFrElHh6KFwl0q79mGFHRodmsp+XrLd6TF4q50MrVA=
X-Received: by 2002:a2e:9a4e:: with SMTP id k14mr4027762ljj.116.1616525557135;
 Tue, 23 Mar 2021 11:52:37 -0700 (PDT)
MIME-Version: 1.0
References: <20210316213136.1866983-1-ndesaulniers@google.com> <YFnyHaVyvgYl/qWg@kroah.com>
In-Reply-To: <YFnyHaVyvgYl/qWg@kroah.com>
From:   Nick Desaulniers <ndesaulniers@google.com>
Date:   Tue, 23 Mar 2021 11:52:26 -0700
Message-ID: <CAKwvOd=9HwLcTD8GaMsbEWiTPfZ+fj=vgFOefqBxDYkFiv_6YQ@mail.gmail.com>
Subject: Re: [PATCH] scripts: stable: add script to validate backports
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        clang-built-linux <clang-built-linux@googlegroups.com>,
        LKML <linux-kernel@vger.kernel.org>,
        "# 3.4.x" <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000009ade5b05be38af80"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000009ade5b05be38af80
Content-Type: text/plain; charset="UTF-8"

On Tue, Mar 23, 2021 at 6:56 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Tue, Mar 16, 2021 at 02:31:33PM -0700, Nick Desaulniers wrote:
> > A common recurring mistake made when backporting patches to stable is
> > forgetting to check for additional commits tagged with `Fixes:`. This
> > script validates that local commits have a `commit <sha40> upstream.`
> > line in their commit message, and whether any additional `Fixes:` shas
> > exist in the `master` branch but were not included. It can not know
> > about fixes yet to be discovered, or fixes sent to the mailing list but
> > not yet in mainline.
> >
> > To save time, it avoids checking all of `master`, stopping early once
> > we've reached the commit time of the earliest backport. It takes 0.5s to
> > validate 2 patches to linux-5.4.y when master is v5.12-rc3 and 5s to
> > validate 27 patches to linux-4.19.y. It does not recheck dependencies of
> > found fixes; the user is expected to run this script to a fixed point.
> > It depnds on pygit2 python library for working with git, which can be
> > installed via:
> > $ pip3 install pygit2
> >
> > It's expected to be run from a stable tree with commits applied.  For
> > example, consider 3cce9d44321e which is a fix for f77ac2e378be. Let's
> > say I cherry picked f77ac2e378be into linux-5.4.y but forgot
> > 3cce9d44321e (true story). If I ran:
> >
> > $ ./scripts/stable/check_backports.py
> > Checking 1 local commits for additional Fixes: in master
> > Please consider backporting 3cce9d44321e as a fix for f77ac2e378be
>
> While interesting, I don't use a git tree for the stable queue, so this
> doesn't really fit into my workflow, sorry.

Well, what is your workflow?

> And we do have other "stable tree helper" scripts in the
> stable-queue.git repo, perhaps that's a better place for this than the
> main kernel repo?

Sure, here it is moved over to there. Let me know if there's a
preferred way to send it.
-- 
Thanks,
~Nick Desaulniers

--0000000000009ade5b05be38af80
Content-Type: application/octet-stream; 
	name="0001-scripts-add-script-to-validate-backports.patch"
Content-Disposition: attachment; 
	filename="0001-scripts-add-script-to-validate-backports.patch"
Content-Transfer-Encoding: base64
Content-ID: <f_kmmdf4sb0>
X-Attachment-Id: f_kmmdf4sb0

RnJvbSBlOTc4YTNiNTFmNmZhMjgwMTk0OGY0MjIzNGQ0YmYxMjFiYjFhMGVhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBOaWNrIERlc2F1bG5pZXJzIDxuZGVzYXVsbmllcnNAZ29vZ2xl
LmNvbT4KRGF0ZTogVHVlLCAyMyBNYXIgMjAyMSAxMTo0MzoyOSAtMDcwMApTdWJqZWN0OiBbUEFU
Q0hdIHNjcmlwdHM6IGFkZCBzY3JpcHQgdG8gdmFsaWRhdGUgYmFja3BvcnRzCgpBIGNvbW1vbiBy
ZWN1cnJpbmcgbWlzdGFrZSBtYWRlIHdoZW4gYmFja3BvcnRpbmcgcGF0Y2hlcyB0byBzdGFibGUg
aXMKZm9yZ2V0dGluZyB0byBjaGVjayBmb3IgYWRkaXRpb25hbCBjb21taXRzIHRhZ2dlZCB3aXRo
IGBGaXhlczpgLiBUaGlzCnNjcmlwdCB2YWxpZGF0ZXMgdGhhdCBsb2NhbCBjb21taXRzIGhhdmUg
YSBgY29tbWl0IDxzaGE0MD4gdXBzdHJlYW0uYApsaW5lIGluIHRoZWlyIGNvbW1pdCBtZXNzYWdl
LCBhbmQgd2hldGhlciBhbnkgYWRkaXRpb25hbCBgRml4ZXM6YCBzaGFzCmV4aXN0IGluIHRoZSBg
bWFzdGVyYCBicmFuY2ggYnV0IHdlcmUgbm90IGluY2x1ZGVkLiBJdCBjYW4gbm90IGtub3cKYWJv
dXQgZml4ZXMgeWV0IHRvIGJlIGRpc2NvdmVyZWQsIG9yIGZpeGVzIHNlbnQgdG8gdGhlIG1haWxp
bmcgbGlzdCBidXQKbm90IHlldCBpbiBtYWlubGluZS4KClRvIHNhdmUgdGltZSwgaXQgYXZvaWRz
IGNoZWNraW5nIGFsbCBvZiBgbWFzdGVyYCwgc3RvcHBpbmcgZWFybHkgb25jZQp3ZSd2ZSByZWFj
aGVkIHRoZSBjb21taXQgdGltZSBvZiB0aGUgZWFybGllc3QgYmFja3BvcnQuIEl0IHRha2VzIDAu
NXMgdG8KdmFsaWRhdGUgMiBwYXRjaGVzIHRvIGxpbnV4LTUuNC55IHdoZW4gbWFzdGVyIGlzIHY1
LjEyLXJjMyBhbmQgNXMgdG8KdmFsaWRhdGUgMjcgcGF0Y2hlcyB0byBsaW51eC00LjE5LnkuIEl0
IGRvZXMgbm90IHJlY2hlY2sgZGVwZW5kZW5jaWVzIG9mCmZvdW5kIGZpeGVzOyB0aGUgdXNlciBp
cyBleHBlY3RlZCB0byBydW4gdGhpcyBzY3JpcHQgdG8gYSBmaXhlZCBwb2ludC4KSXQgZGVwbmRz
IG9uIHB5Z2l0MiBweXRob24gbGlicmFyeSBmb3Igd29ya2luZyB3aXRoIGdpdCwgd2hpY2ggY2Fu
IGJlCmluc3RhbGxlZCB2aWE6CiQgcGlwMyBpbnN0YWxsIHB5Z2l0MgoKSXQncyBleHBlY3RlZCB0
byBiZSBydW4gZnJvbSBhIHN0YWJsZSB0cmVlIHdpdGggY29tbWl0cyBhcHBsaWVkLiAgRm9yCmV4
YW1wbGUsIGNvbnNpZGVyIDNjY2U5ZDQ0MzIxZSB3aGljaCBpcyBhIGZpeCBmb3IgZjc3YWMyZTM3
OGJlLiBMZXQncwpzYXkgSSBjaGVycnkgcGlja2VkIGY3N2FjMmUzNzhiZSBpbnRvIGxpbnV4LTUu
NC55IGJ1dCBmb3Jnb3QKM2NjZTlkNDQzMjFlICh0cnVlIHN0b3J5KS4gSWYgSSByYW46CgokIC4v
c2NyaXB0cy9zdGFibGUvY2hlY2tfYmFja3BvcnRzLnB5CkNoZWNraW5nIDEgbG9jYWwgY29tbWl0
cyBmb3IgYWRkaXRpb25hbCBGaXhlczogaW4gbWFzdGVyClBsZWFzZSBjb25zaWRlciBiYWNrcG9y
dGluZyAzY2NlOWQ0NDMyMWUgYXMgYSBmaXggZm9yIGY3N2FjMmUzNzhiZQoKU28gdGhlbiBJIGNv
dWxkIGNoZXJyeSBwaWNrIDNjY2U5ZDQ0MzIxZSBhcyB3ZWxsOgokIGdpdCBjaGVycnktcGljayAt
c3ggM2NjZTlkNDQzMjFlCiQgLi9zY3JpcHRzL3N0YWJsZS9jaGVja19iYWNrcG9ydHMucHkKLi4u
CkV4Y2VwdGlvbjogTWlzc2luZyAnY29tbWl0IDxzaGE0MD4gdXBzdHJlYW0uJyBsaW5lCgpPb3Bz
LCBsZXQgbWUgZml4dXAgdGhlIGNvbW1pdCBtZXNzYWdlIGFuZCByZXRyeS4KJCBnaXQgY29tbWl0
IC0tYW1lbmQKPGZpeCBjb21taXQgbWVzc2FnZT4KJCAuL3NjcmlwdHMvc3RhYmxlL2NoZWNrX2Jh
Y2twb3J0cy5weQpDaGVja2luZyAyIGxvY2FsIGNvbW1pdHMgZm9yIGFkZGl0aW9uYWwgRml4ZXM6
IGluIG1hc3RlcgokIGVjaG8gJD8KMAoKVGhpcyBhbGxvd3MgZm9yIGNsaWVudCBzaWRlIHZhbGlk
YXRpb24gYnkgdGhlIGJhY2twb3J0cyBhdXRob3IsIGFuZApzZXJ2ZXIgc2lkZSB2YWxpZGF0aW9u
IGJ5IHRoZSBzdGFibGUga2VybmVsIG1haW50YWluZXJzLgoKU2lnbmVkLW9mZi1ieTogTmljayBE
ZXNhdWxuaWVycyA8bmRlc2F1bG5pZXJzQGdvb2dsZS5jb20+Ci0tLQogc2NyaXB0cy9jaGVja19i
YWNrcG9ydHMucHkgfCA5MiArKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKwog
MSBmaWxlIGNoYW5nZWQsIDkyIGluc2VydGlvbnMoKykKIGNyZWF0ZSBtb2RlIDEwMDc1NSBzY3Jp
cHRzL2NoZWNrX2JhY2twb3J0cy5weQoKZGlmZiAtLWdpdCBhL3NjcmlwdHMvY2hlY2tfYmFja3Bv
cnRzLnB5IGIvc2NyaXB0cy9jaGVja19iYWNrcG9ydHMucHkKbmV3IGZpbGUgbW9kZSAxMDA3NTUK
aW5kZXggMDAwMDAwMDAwMDAwLi41MjkyOTRlMjQ3Y2EKLS0tIC9kZXYvbnVsbAorKysgYi9zY3Jp
cHRzL2NoZWNrX2JhY2twb3J0cy5weQpAQCAtMCwwICsxLDkyIEBACisjIS91c3IvYmluL2VudiBw
eXRob24zCisjIFNQRFgtTGljZW5zZS1JZGVudGlmaWVyOiBHUEwtMi4wCisjIENvcHlyaWdodCAo
QykgMjAyMSBHb29nbGUsIEluYy4KKworaW1wb3J0IG9zCitpbXBvcnQgcmUKK2ltcG9ydCBzeXMK
KworaW1wb3J0IHB5Z2l0MiBhcyBwZworCisKK2RlZiBnZXRfaGVhZF9icmFuY2gocmVwbyk6Cisg
ICAgIyBXYWxrIHRoZSBicmFuY2hlcyB0byBmaW5kIHdoaWNoIGlzIEhFQUQuCisgICAgZm9yIGJy
YW5jaF9uYW1lIGluIHJlcG8uYnJhbmNoZXM6CisgICAgICAgIGJyYW5jaCA9IHJlcG8uYnJhbmNo
ZXNbYnJhbmNoX25hbWVdCisgICAgICAgIGlmIGJyYW5jaC5pc19oZWFkKCk6CisgICAgICAgICAg
ICByZXR1cm4gYnJhbmNoCisKKworZGVmIGdldF9sb2NhbF9jb21taXRzKHJlcG8pOgorICAgIGhl
YWRfYnJhbmNoID0gZ2V0X2hlYWRfYnJhbmNoKHJlcG8pCisgICAgIyBXYWxrIHRoZSBIRUFEIHJl
ZiB1bnRpbCB3ZSBoaXQgdGhlIGZpcnN0IGNvbW1pdCBmcm9tIHRoZSB1cHN0cmVhbS4KKyAgICB3
YWxrZXIgPSByZXBvLndhbGsocmVwby5oZWFkLnRhcmdldCkKKyAgICB1cHN0cmVhbV9icmFuY2gg
PSBoZWFkX2JyYW5jaC51cHN0cmVhbQorICAgIHVwc3RyZWFtX2NvbW1pdCwgXyA9IHJlcG8ucmVz
b2x2ZV9yZWZpc2godXBzdHJlYW1fYnJhbmNoLm5hbWUpCisgICAgd2Fsa2VyLmhpZGUodXBzdHJl
YW1fY29tbWl0LmlkKQorICAgIGNvbW1pdHMgPSBbY29tbWl0IGZvciBjb21taXQgaW4gd2Fsa2Vy
XQorICAgIGlmIG5vdCBsZW4oY29tbWl0cyk6CisgICAgICAgIHJhaXNlIEV4Y2VwdGlvbigiTm8g
bG9jYWwgY29tbWl0cyIpCisgICAgcmV0dXJuIGNvbW1pdHMKKworCitkZWYgZ2V0X3Vwc3RyZWFt
X3NoYXMoY29tbWl0cyk6CisgICAgdXBzdHJlYW1fc2hhcyA9IFtdCisgICAgcHJvZyA9IHJlLmNv
bXBpbGUoJ2NvbW1pdCAoWzAtOWEtZl17NDB9KSB1cHN0cmVhbS4nKQorICAgICMgRm9yIGVhY2gg
bGluZSBvZiBlYWNoIGNvbW1pdCBtZXNzYWdlLCByZWNvcmQgdGhlCisgICAgIyAiY29tbWl0IDxz
aGE0MD4gdXBzdHJlYW0uIiBsaW5lLgorICAgIGZvciBjb21taXQgaW4gY29tbWl0czoKKyAgICAg
ICAgZm91bmRfdXBzdHJlYW1fbGluZSA9IEZhbHNlCisgICAgICAgIGZvciBsaW5lIGluIGNvbW1p
dC5tZXNzYWdlLnNwbGl0bGluZXMoKToKKyAgICAgICAgICAgIHJlc3VsdCA9IHByb2cuc2VhcmNo
KGxpbmUpCisgICAgICAgICAgICBpZiByZXN1bHQ6CisgICAgICAgICAgICAgICAgdXBzdHJlYW1f
c2hhcy5hcHBlbmQocmVzdWx0Lmdyb3VwKDEpWzoxMl0pCisgICAgICAgICAgICAgICAgZm91bmRf
dXBzdHJlYW1fbGluZSA9IFRydWUKKyAgICAgICAgICAgICAgICBicmVhaworICAgICAgICBpZiBu
b3QgZm91bmRfdXBzdHJlYW1fbGluZToKKyAgICAgICAgICAgIHJhaXNlIEV4Y2VwdGlvbigiTWlz
c2luZyAnY29tbWl0IDxzaGE0MD4gdXBzdHJlYW0uJyBsaW5lIikKKyAgICByZXR1cm4gdXBzdHJl
YW1fc2hhcworCisKK2RlZiBnZXRfb2xkZXN0X2NvbW1pdF90aW1lKHJlcG8sIHNoYXMpOgorICAg
IGNvbW1pdF90aW1lcyA9IFtyZXBvLnJlc29sdmVfcmVmaXNoKHNoYSlbMF0uY29tbWl0X3RpbWUg
Zm9yIHNoYSBpbiBzaGFzXQorICAgIHJldHVybiBzb3J0ZWQoY29tbWl0X3RpbWVzKVswXQorCisK
K2RlZiBnZXRfZml4ZXNfZm9yKHNoYXMpOgorICAgIHNoYXMgPSBzZXQoc2hhcykKKyAgICBwcm9n
ID0gcmUuY29tcGlsZSgiRml4ZXM6IChbMC05YS1mXXsxMiw0MH0pIikKKyAgICAjIFdhbGsgY29t
bWl0cyBpbiB0aGUgbWFzdGVyIGJyYW5jaC4KKyAgICBtYXN0ZXJfY29tbWl0LCBtYXN0ZXJfcmVm
ID0gcmVwby5yZXNvbHZlX3JlZmlzaCgibWFzdGVyIikKKyAgICB3YWxrZXIgPSByZXBvLndhbGso
bWFzdGVyX3JlZi50YXJnZXQpCisgICAgb2xkZXN0X2NvbW1pdF90aW1lID0gZ2V0X29sZGVzdF9j
b21taXRfdGltZShyZXBvLCBzaGFzKQorICAgIGZpeGVzID0gW10KKyAgICBmb3IgY29tbWl0IGlu
IHdhbGtlcjoKKyAgICAgICAgIyBJdCdzIG5vdCBwb3NzaWJsZSBmb3IgYSBGaXhlczogdG8gYmUg
Y29tbWl0dGVkIGJlZm9yZSBhIGZpeGVkIHRhZywgc28KKyAgICAgICAgIyBkb24ndCBpdGVyYXRl
IGFsbCBvZiBnaXQgaGlzdG9yeS4KKyAgICAgICAgaWYgY29tbWl0LmNvbW1pdF90aW1lIDwgb2xk
ZXN0X2NvbW1pdF90aW1lOgorICAgICAgICAgICAgYnJlYWsKKyAgICAgICAgZm9yIGxpbmUgaW4g
cmV2ZXJzZWQoY29tbWl0Lm1lc3NhZ2Uuc3BsaXRsaW5lcygpKToKKyAgICAgICAgICAgIHJlc3Vs
dCA9IHByb2cuc2VhcmNoKGxpbmUpCisgICAgICAgICAgICBpZiBub3QgcmVzdWx0OgorICAgICAg
ICAgICAgICAgIGNvbnRpbnVlCisgICAgICAgICAgICBmaXhlc19zaGEgPSByZXN1bHQuZ3JvdXAo
MSlbOjEyXQorICAgICAgICAgICAgaWYgZml4ZXNfc2hhIGluIHNoYXMgYW5kIGNvbW1pdC5pZC5o
ZXhbOjEyXSBub3QgaW4gc2hhczoKKyAgICAgICAgICAgICAgICBmaXhlcy5hcHBlbmQoKGNvbW1p
dC5pZC5oZXhbOjEyXSwgZml4ZXNfc2hhKSkKKyAgICByZXR1cm4gZml4ZXMKKworCitkZWYgcmVw
b3J0KGZpeGVzKToKKyAgICBpZiBsZW4oZml4ZXMpOgorICAgICAgICBmb3IgZml4LCBicm9rZSBp
biBmaXhlczoKKyAgICAgICAgICAgIHByaW50KCJQbGVhc2UgY29uc2lkZXIgYmFja3BvcnRpbmcg
JXMgYXMgYSBmaXggZm9yICVzIiAlIChmaXgsIGJyb2tlKSkKKyAgICAgICAgc3lzLmV4aXQoMSkK
KworCitpZiBfX25hbWVfXyA9PSAiX19tYWluX18iOgorICAgIHJlcG8gPSBwZy5SZXBvc2l0b3J5
KG9zLmdldGN3ZCgpKQorICAgIGNvbW1pdHMgPSBnZXRfbG9jYWxfY29tbWl0cyhyZXBvKQorICAg
IHByaW50KCJDaGVja2luZyAlZCBsb2NhbCBjb21taXRzIGZvciBhZGRpdGlvbmFsIEZpeGVzOiBp
biBtYXN0ZXIiICUgKGxlbihjb21taXRzKSkpCisgICAgdXBzdHJlYW1fc2hhcyA9IGdldF91cHN0
cmVhbV9zaGFzKGNvbW1pdHMpCisgICAgZml4ZXMgPSBnZXRfZml4ZXNfZm9yKHVwc3RyZWFtX3No
YXMpCisgICAgcmVwb3J0KGZpeGVzKQotLSAKMi4zMS4wLjI5MS5nNTc2YmE5ZGNkYWYtZ29vZwoK
--0000000000009ade5b05be38af80--
