Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 343F621AE9E
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 07:29:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727031AbgGJFZd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 01:25:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726955AbgGJFWm (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jul 2020 01:22:42 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E4234C08C5DC
        for <stable@vger.kernel.org>; Thu,  9 Jul 2020 22:22:41 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id g139so2480308lfd.10
        for <stable@vger.kernel.org>; Thu, 09 Jul 2020 22:22:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nxOx3elG9/c5GA8S+Etec1D6qLcN4yJxKYND0gsSGKA=;
        b=D6crEs+HKaT9Uq4/qL9HJVUv8iB612zNzspsqrt/RJishuEnyOE/8Zv3gnDLMYL4rs
         Q+0dTi5rDIzIg9WQ/zJMrN9fBwRwMuXqwAiyku1TJ5VfzG3LIrw+xPrEo4L2loRTUTTX
         ACGnpK+uiVLnxcFrMT7F6sIL7X4KMEB33Yf1I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nxOx3elG9/c5GA8S+Etec1D6qLcN4yJxKYND0gsSGKA=;
        b=sP1Y+o28rWo9HssUd/7wYUiG9CLpLEY/RqWYZr9dg+wco1Mze77HfyGHJLAiLYraic
         xViWwwLuMOLWlceUC6kFGAthaectUoaYriT9Onf7Z+eanKGR9IebryjQ1V3ulcMZ8L48
         P5zBO4YwS4rhznDtrFrnLotFgyh4XFv9KchFD7jYzWqu7Lv/v4xvXj7xFFnwIQXZHTpu
         bx5nwZiyF3IJnkStZ5CWPNM+c7hKRc+FGKpVDuNWjZKGItZpEriyrpPTkja2UDw7yI9K
         CcKY+E4XULx2k0jz9UyuyVbCEhHvbZ58FFKWKKMfuE21XP8FZSDKOYQaauycrnIJfU/L
         8vpA==
X-Gm-Message-State: AOAM532rEKdakAhMiiAJh+v3FqwWGuv2SSAB5tWyF8YWQ3osiKMZOa7Q
        xxlQWjQl7quWhQI8xYO/Rv1U11HQVgY=
X-Google-Smtp-Source: ABdhPJzk8eI5HqXvVRckWPIgqoKJjsDTcLaVfKoIAZJW8UwneQ6exUkMSWoYgpRky/0xKMxMhVmcFA==
X-Received: by 2002:a19:f20a:: with SMTP id q10mr42752791lfh.89.1594358559981;
        Thu, 09 Jul 2020 22:22:39 -0700 (PDT)
Received: from mail-lf1-f52.google.com (mail-lf1-f52.google.com. [209.85.167.52])
        by smtp.gmail.com with ESMTPSA id f18sm1515837ljn.73.2020.07.09.22.22.37
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 22:22:38 -0700 (PDT)
Received: by mail-lf1-f52.google.com with SMTP id o4so2482977lfi.7
        for <stable@vger.kernel.org>; Thu, 09 Jul 2020 22:22:37 -0700 (PDT)
X-Received: by 2002:ac2:5a5e:: with SMTP id r30mr42576925lfn.30.1594358557529;
 Thu, 09 Jul 2020 22:22:37 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
 <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com> <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
In-Reply-To: <CA+G9fYuL=xJPLbQJVzDfXB8uNiCWdXpL=joDsnATEFCzyFh_1g@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Jul 2020 22:22:21 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
Message-ID: <CAHk-=wgB6Ds6yqbZZmscKNuAiNR2J0Pf3a8UrbdfewYxHE7SbA@mail.gmail.com>
Subject: Re: WARNING: at mm/mremap.c:211 move_page_tables in i386
To:     Naresh Kamboju <naresh.kamboju@linaro.org>
Cc:     linux- stable <stable@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        linux-mm <linux-mm@kvack.org>, Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Roman Gushchin <guro@fb.com>, Michal Hocko <mhocko@kernel.org>,
        lkft-triage@lists.linaro.org, Chris Down <chris@chrisdown.name>,
        Michel Lespinasse <walken@google.com>,
        Fan Yang <Fan_Yang@sjtu.edu.cn>,
        Brian Geffon <bgeffon@google.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, pugaowei@gmail.com,
        Jerome Glisse <jglisse@redhat.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: multipart/mixed; boundary="000000000000777e4805aa0f87f7"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000777e4805aa0f87f7
Content-Type: text/plain; charset="UTF-8"

On Thu, Jul 9, 2020 at 9:29 PM Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> Your patch applied and re-tested.
> warning triggered 10 times.
>
> old: bfe00000-c0000000 new: bfa00000 (val: 7d530067)

Hmm.. It's not even the overlapping case, it's literally just "move
exactly 2MB of page tables exactly one pmd down". Which should be the
nice efficient case where we can do it without modifying the lower
page tables at all, we just move the PMD entry.

There shouldn't be anything in the new address space from bfa00000-bfdfffff.

That PMD value obviously says differently, but it looks like a nice
normal PMD value, nothing bad there.

I'm starting to think that the issue might be that this is because the
stack segment is special. Not only does it have the growsdown flag,
but that whole thing has the magic guard page logic.

So I wonder if we have installed a guard page _just_ below the old
stack, so that we have populated that pmd because of that.

We used to have an _actual_ guard page and then play nasty games with
vm_start logic. We've gotten rid of that, though, and now we have that
"stack_guard_gap" logic that _should_ mean that vm_start is always
exact and proper (and that pgtbales_free() should have emptied it, but
maybe we have some case we forgot about.

> [  741.511684] WARNING: CPU: 1 PID: 15173 at mm/mremap.c:211 move_page_tables.cold+0x0/0x2b
> [  741.598159] Call Trace:
> [  741.600694]  setup_arg_pages+0x22b/0x310
> [  741.621687]  load_elf_binary+0x31e/0x10f0
> [  741.633839]  __do_execve_file+0x5a8/0xbf0
> [  741.637893]  __ia32_sys_execve+0x2a/0x40
> [  741.641875]  do_syscall_32_irqs_on+0x3d/0x2c0
> [  741.657660]  do_fast_syscall_32+0x60/0xf0
> [  741.661691]  do_SYSENTER_32+0x15/0x20
> [  741.665373]  entry_SYSENTER_32+0x9f/0xf2
> [  741.734151]  old: bfe00000-c0000000 new: bfa00000 (val: 7d530067)

Nothing looks bad, and the ELF loading phase memory map should be
really quite simple.

The only half-way unusual thing is that you have basically exactly 2MB
of stack at execve time (easy enough to tune by just setting argv/env
right), and it's moved down by exactly 2MB.

And that latter thing is just due to randomization, see
arch_align_stack() in arch/x86/kernel/process.c.

So that would explain why it doesn't happen every time.

What happens if you apply the attached patch to *always* force the 2MB
shift (rather than moving the stack by a random amount), and then run
the other program (t.c -> compiled to "a.out").

The comment should be obvious. But it's untested, I might have gotten
the math wrong. I don't run in a 32-bit environment.

                Linus

--000000000000777e4805aa0f87f7
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
Content-ID: <f_kcfrw33u0>
X-Attachment-Id: f_kcfrw33u0

IGFyY2gveDg2L2tlcm5lbC9wcm9jZXNzLmMgfCAzICstLQogMSBmaWxlIGNoYW5nZWQsIDEgaW5z
ZXJ0aW9uKCspLCAyIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC9w
cm9jZXNzLmMgYi9hcmNoL3g4Ni9rZXJuZWwvcHJvY2Vzcy5jCmluZGV4IGYzNjJjZTBkNWFjMC4u
OWIwMjdlYzYzMWExIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9rZXJuZWwvcHJvY2Vzcy5jCisrKyBi
L2FyY2gveDg2L2tlcm5lbC9wcm9jZXNzLmMKQEAgLTkxMSw4ICs5MTEsNyBAQCBlYXJseV9wYXJh
bSgiaWRsZSIsIGlkbGVfc2V0dXApOwogCiB1bnNpZ25lZCBsb25nIGFyY2hfYWxpZ25fc3RhY2so
dW5zaWduZWQgbG9uZyBzcCkKIHsKLQlpZiAoIShjdXJyZW50LT5wZXJzb25hbGl0eSAmIEFERFJf
Tk9fUkFORE9NSVpFKSAmJiByYW5kb21pemVfdmFfc3BhY2UpCi0JCXNwIC09IGdldF9yYW5kb21f
aW50KCkgJSA4MTkyOworCXNwIC09IDIqMTAyNCoxMDI0OwogCXJldHVybiBzcCAmIH4weGY7CiB9
CiAK
--000000000000777e4805aa0f87f7
Content-Type: text/x-csrc; charset="US-ASCII"; name="t.c"
Content-Disposition: attachment; filename="t.c"
Content-Transfer-Encoding: base64
Content-ID: <f_kcfrw6vm1>
X-Attachment-Id: f_kcfrw6vm1

I2RlZmluZSBfR05VX1NPVVJDRQojaW5jbHVkZSA8dW5pc3RkLmg+CgpzdGF0aWMgY2hhciBvbmVf
a2JbMTAyNF0gPSB7CglbMCAuLi4gMTAyMl0gPSAnYScsCgkwCn07CgovKgogKiBFYWNoIHN0cmlu
ZyBpcyAxa0IsIHNvIHdlIHdvdWxkIG5lZWQgMjA0OCBzdHJpbmdzIHRvIGZpbGwgYSAyTUIgc3Rh
Y2suCiAqCiAqIEJ1dCB3ZSBoYXZlIHRoZSBzdHJpbmcgcG9pbnRlcnMgdGhlbXNlbHZlczogNCBi
eXRlcyBwZXIgc3RyaW5nLCBzbwogKiB0aGF0IHdvdWxkIGJlIGFuIGFkZGl0aW9uYWwgOGtCIG9u
IHRvcCBvZiB0aGUgMk1CIG9mIHN0cmluZ3MuIFBsdXMKICogd2UgaGF2ZSB0aGUgdHdvIE5VTEwg
dGVybWluYXRvcnMgKDggYnl0ZXMpIGZvciBhcmd2L2VudnAuCiAqCiAqIEFuZCB0aGVuIHdlIGhh
dmUgdGhlIEVMRiBBVVggZmllbGRzLCB3aGljaCBpcyBhIGZldyBodW5kcmVkIGJ5dGVzIHRvby4K
ICoKICogQW5kIHRoZW4gd2UgbmVlZCB0aGUgY2FsbCBzdGFjayBmcmFtZSBldGMsIGFuZCBvbmx5
IG5lZWQgdG8gY29tZSB3aXRoaW4KICogNGtCIG9mIHRoZSAyTUIgc3RhY2sgdGFyZ2V0LgogKgog
KiBTbyBpbnN0ZWFkIG9mIHVzaW5nIDIwNDggc3RyaW5ncyB0byBmaWxsIHVwIDJNQiBleGFjdGx5
LCB3ZSB3YW50IHRvIGZpbGwgdXAKICogYmFzaWNhbGx5IDJNQi0xMmtCLCBhbmQgbGV0IHRoZSBB
VVggaW5mbyBldGMgZ28gaW50byB0aGUgbGFzdCBwYWdlLgogKgogKiBTbyAyMDM2IDFrQiBzdHJp
bmdzLCBwbHVzIG5vaXNlLgogKi8KCnN0YXRpYyBjaGFyICphcmd2W10gPSB7CglbMF0gPSAiL2Jp
bi9lY2hvIiwKCVsxIC4uLiAyMDM2XSA9IG9uZV9rYiwKCU5VTEwKfTsKCnN0YXRpYyBjaGFyICpl
bnZwW10gPSB7CglOVUxMCn07CgppbnQgbWFpbihpbnQgYXJnYywgY2hhciAqKmVudnApCnsKCS8q
CgkgKiBEb24ndCBkbyB0aGlzIHJlY3Vyc2l2ZWx5LCBhbmQgc2xlZXAgc28gcGVvcGxlIGNhbiBs
b29rIGF0IC9wcm9jLzxwaWQ+L21hcHMKCSAqLwoJaWYgKGFyZ2MgPiAxMDAwKSB7CgkJc2xlZXAo
MTAwKTsKCQlyZXR1cm4gMDsKCX0KCXJldHVybiBleGVjdnBlKCIuL2Eub3V0IiwgYXJndiwgZW52
cCk7Cn0K
--000000000000777e4805aa0f87f7--
