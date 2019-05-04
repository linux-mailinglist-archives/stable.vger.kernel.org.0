Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1869013BE3
	for <lists+stable@lfdr.de>; Sat,  4 May 2019 21:06:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727322AbfEDTGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 4 May 2019 15:06:07 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:34674 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726552AbfEDTGH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 4 May 2019 15:06:07 -0400
Received: by mail-lf1-f66.google.com with SMTP id v18so4345774lfi.1
        for <stable@vger.kernel.org>; Sat, 04 May 2019 12:06:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UPXn/suOTC4KtkcdUL+Y23TPj9fvnn464w7bphB09yc=;
        b=BGm1JgIvnO4XjmvpkE5zlrsXU0oaY9ixUidNFsf4EYolQ1p0zn1hNJrlziX2N0nsOR
         B38UDlHgMyzVeEBsrOKhLaspPY/ucJmctT6kYtDXOsUpvos75jtWaAA3Q6Ybjr217dM8
         0aD7sAeIC+OooQUiWMb7P7Iz3mIs9w+GyypC4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UPXn/suOTC4KtkcdUL+Y23TPj9fvnn464w7bphB09yc=;
        b=kUQW19Why6QnPy22DGZBZUL6KGuvwUIqH0SuBtQrRFfs4a95uGEsMYYPRt29vM1pWx
         XAypi8RY02OumsPXeG4pWeT1692McnipQF+PUkp+3aG95VTIAe10Y89M8QEQDKKZ+x99
         +n0nkQ/BhZF+6gKIiTvSBYybim/UVu333PnROEpcDxhON0TBMhyOMUpSNUCc8xgPsaXH
         ehmxW2DQ5MAssbbglMGx2KkLRC+dxbAwLlkzaiVa5r+x5PKAsX0b3nrbXgzxYHiUqXfl
         ZcDgqIc/AJ4F6Tu58cVngXrAtJf1htDPUJc9KnQ/93C4gKezAWLJo43yMJs+ph9BkEo3
         oSvg==
X-Gm-Message-State: APjAAAXEEtDjr6VgTIviF26ofIKUpMMv3FMkkdNWc4Ubjj1/ECzw+YFb
        mLs4wtJC+fjCxMJPw2Y1KvuvJd2u3EM=
X-Google-Smtp-Source: APXvYqz/8uKzgQ1eRXMNjQifNXfJz9JmVNpZfo3xYBmAEcriepoyyxCmOhxdhEguXMRkUwaUagTvnA==
X-Received: by 2002:a19:751a:: with SMTP id y26mr8784748lfe.47.1556996764003;
        Sat, 04 May 2019 12:06:04 -0700 (PDT)
Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com. [209.85.167.48])
        by smtp.gmail.com with ESMTPSA id f9sm1029657ljf.69.2019.05.04.12.06.03
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 04 May 2019 12:06:03 -0700 (PDT)
Received: by mail-lf1-f48.google.com with SMTP id k18so6524642lfj.13
        for <stable@vger.kernel.org>; Sat, 04 May 2019 12:06:03 -0700 (PDT)
X-Received: by 2002:ac2:547a:: with SMTP id e26mr8464749lfn.148.1556996397689;
 Sat, 04 May 2019 11:59:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190501202830.347656894@goodmis.org> <20190501203152.397154664@goodmis.org>
 <20190501232412.1196ef18@oasis.local.home> <20190502162133.GX2623@hirez.programming.kicks-ass.net>
 <CAHk-=wijZ-MD4g3zMJ9W2r=h8LUWneiu29OWuxZEoSfAF=0bhQ@mail.gmail.com>
 <20190502181811.GY2623@hirez.programming.kicks-ass.net> <CAHk-=wi6A9tgw=kkPh5Ywqt687VvsVEjYXVkAnq0jpt0u0tk6g@mail.gmail.com>
 <20190502202146.GZ2623@hirez.programming.kicks-ass.net> <CAHk-=wh8bi5c_GkyjPtDAiaXaZRqtmhWs30usUvs4qK_F+c9tg@mail.gmail.com>
 <20190503152405.2d741af8@gandalf.local.home> <CAHk-=wiA-WbrFrDs-kOfJZMXy4zMo9-SZfk=7B-GfmBJ866naw@mail.gmail.com>
 <20190503184919.2b7ef242@gandalf.local.home> <CAHk-=wh2vPLvsGBi6JtmEYeqHxB5UpTzHDjY5JsWG=YR0Lypzw@mail.gmail.com>
 <20190504001756.17fad840@oasis.local.home> <CAHk-=wiuSFbv_rELND-BLWcP0GSZ0yF=xOAEcf61GE3bU9d=yg@mail.gmail.com>
In-Reply-To: <CAHk-=wiuSFbv_rELND-BLWcP0GSZ0yF=xOAEcf61GE3bU9d=yg@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sat, 4 May 2019 11:59:41 -0700
X-Gmail-Original-Message-ID: <CAHk-=wjGNx8xcwg=7nE_0-nLQ_d4UALHvJ8O+TurbA25n8MyNg@mail.gmail.com>
Message-ID: <CAHk-=wjGNx8xcwg=7nE_0-nLQ_d4UALHvJ8O+TurbA25n8MyNg@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Linux List Kernel Mailing <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Nicolai Stange <nstange@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>,
        Miroslav Benes <mbenes@suse.cz>,
        Petr Mladek <pmladek@suse.com>,
        Joe Lawrence <joe.lawrence@redhat.com>,
        Shuah Khan <shuah@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Tim Chen <tim.c.chen@linux.intel.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Juergen Gross <jgross@suse.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Nayna Jain <nayna@linux.ibm.com>,
        Masahiro Yamada <yamada.masahiro@socionext.com>,
        Joerg Roedel <jroedel@suse.de>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>
Content-Type: multipart/mixed; boundary="00000000000033a78605881479d1"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--00000000000033a78605881479d1
Content-Type: text/plain; charset="UTF-8"

On Fri, May 3, 2019 at 10:08 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> I'll look at it tomorrow, but I think this actually makes unnecessary changes.
>
> In particular, I think we could keep the existing entry code almost unchanged with this whole approach.

So here's what I *think* should work. Note that I also removed your
test-case code, because it really didn't have a chance in hell of
working. Doing that

        int3_emulate_call(regs, (unsigned long)&int3_magic);

inside of int3_exception_notify() could not possibly be valid, since
int3_emulate_call() returns the new pt_regs that need to be used, and
throwing it away is clearly wrong.

So you can't use a register_die_notifier() to try to intercept the
'int3' error and then do it manually, it needs to be done by the
ftrace_int3_handler() code that actually returns the new regs, and
where do_kernel_int3() will then return it to the low-level handler.

End result: I haven't actually tested this code, but I've looked
through the patch something like ten times without finding any new
errors.

I've also tried *very* hard to make the patch minimal, with the
exception of the comments, which I tried to make extensive for any of
the subtle cases.

But without testing, it's probably still buggy.

I have to say, I finally like the end result here. Maybe it's because
I got to make my mark and pee in the snow, but I will say that

 (a) the actual entry code modifications really are minimal now

 (b) the instruction emulation really is very simple and straightforward

 (c) yes, we play some stack tricks (and yes, we play them differently
on x86-64 and x86-32), but the tricks are again at least
straightforward, and we never really change the layout of any stack.

So on the whole, I think this is about as good as it gets. Did I get
all the details actually right, and it _works_? I guess we'll see.

                 Linus

--00000000000033a78605881479d1
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_jv9vfsff0>
X-Attachment-Id: f_jv9vfsff0

IGFyY2gveDg2L2VudHJ5L2VudHJ5XzMyLlMgICAgICAgICAgICB8ICA3ICsrKy0KIGFyY2gveDg2
L2VudHJ5L2VudHJ5XzY0LlMgICAgICAgICAgICB8IDE0ICsrKysrKy0tCiBhcmNoL3g4Ni9pbmNs
dWRlL2FzbS9mdHJhY2UuaCAgICAgICAgfCAgMiArLQogYXJjaC94ODYvaW5jbHVkZS9hc20vdGV4
dC1wYXRjaGluZy5oIHwgNjIgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCiBh
cmNoL3g4Ni9rZXJuZWwvZnRyYWNlLmMgICAgICAgICAgICAgfCAyOSArKysrKysrKysrKysrKy0t
LQogYXJjaC94ODYva2VybmVsL3RyYXBzLmMgICAgICAgICAgICAgIHwgMTUgKysrKysrLS0tCiA2
IGZpbGVzIGNoYW5nZWQsIDExNiBpbnNlcnRpb25zKCspLCAxMyBkZWxldGlvbnMoLSkKCmRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9lbnRyeS9lbnRyeV8zMi5TIGIvYXJjaC94ODYvZW50cnkvZW50cnlf
MzIuUwppbmRleCBkMzA5ZjMwY2Y3YWYuLjEzOGFjNDMyMjIxYiAxMDA2NDQKLS0tIGEvYXJjaC94
ODYvZW50cnkvZW50cnlfMzIuUworKysgYi9hcmNoL3g4Ni9lbnRyeS9lbnRyeV8zMi5TCkBAIC0x
NDgzLDcgKzE0ODMsMTIgQEAgRU5UUlkoaW50MykKIAlUUkFDRV9JUlFTX09GRgogCXhvcmwJJWVk
eCwgJWVkeAkJCSMgemVybyBlcnJvciBjb2RlCiAJbW92bAklZXNwLCAlZWF4CQkJIyBwdF9yZWdz
IHBvaW50ZXIKLQljYWxsCWRvX2ludDMKKworCSMgbWFrZSByb29tIG9uIGtlcm5lbCBzdGFjayBm
b3IgcHVzaCBlbXVsYXRpb24KKwkjIGRvX2tlcm5lbF9pbnQzIHJldHVybnMgcG9zc2libHkgdXBk
YXRlZCBwdF9yZWdzCisJc3VibAkkOCwgJWVzcAorCWNhbGwJZG9fa2VybmVsX2ludDMKKwltb3Zs
CSVlYXgsICVlc3AKIAlqbXAJcmV0X2Zyb21fZXhjZXB0aW9uCiBFTkQoaW50MykKIApkaWZmIC0t
Z2l0IGEvYXJjaC94ODYvZW50cnkvZW50cnlfNjQuUyBiL2FyY2gveDg2L2VudHJ5L2VudHJ5XzY0
LlMKaW5kZXggMWYwZWZkYjdiNjI5Li44MzRlYzEzOTdkYWIgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2
L2VudHJ5L2VudHJ5XzY0LlMKKysrIGIvYXJjaC94ODYvZW50cnkvZW50cnlfNjQuUwpAQCAtODc5
LDcgKzg3OSw3IEBAIGFwaWNpbnRlcnJ1cHQgSVJRX1dPUktfVkVDVE9SCQkJaXJxX3dvcmtfaW50
ZXJydXB0CQlzbXBfaXJxX3dvcmtfaW50ZXJydXB0CiAgKiBAcGFyYW5vaWQgPT0gMiBpcyBzcGVj
aWFsOiB0aGUgc3R1YiB3aWxsIG5ldmVyIHN3aXRjaCBzdGFja3MuICBUaGlzIGlzIGZvcgogICog
I0RGOiBpZiB0aGUgdGhyZWFkIHN0YWNrIGlzIHNvbWVob3cgdW51c2FibGUsIHdlJ2xsIHN0aWxs
IGdldCBhIHVzZWZ1bCBPT1BTLgogICovCi0ubWFjcm8gaWR0ZW50cnkgc3ltIGRvX3N5bSBoYXNf
ZXJyb3JfY29kZTpyZXEgcGFyYW5vaWQ9MCBzaGlmdF9pc3Q9LTEKKy5tYWNybyBpZHRlbnRyeSBz
eW0gZG9fc3ltIGhhc19lcnJvcl9jb2RlOnJlcSBwYXJhbm9pZD0wIHNoaWZ0X2lzdD0tMSBjcmVh
dGVfZ2FwPTAKIEVOVFJZKFxzeW0pCiAJVU5XSU5EX0hJTlRfSVJFVF9SRUdTIG9mZnNldD1caGFz
X2Vycm9yX2NvZGUqOAogCkBAIC04OTksNiArODk5LDE2IEBAIEVOVFJZKFxzeW0pCiAJam56CS5M
ZnJvbV91c2VybW9kZV9zd2l0Y2hfc3RhY2tfXEAKIAkuZW5kaWYKIAorCS5pZiBcY3JlYXRlX2dh
cCA9PSAxCisJdGVzdGIJJDMsIENTLU9SSUdfUkFYKCVyc3ApCisJam56CS5MZnJvbV91c2VybW9k
ZV9ub19nYXBfXEAKKwkucmVwdCA2CisJcHVzaHEJNSo4KCVyc3ApCisJLmVuZHIKKwlVTldJTkRf
SElOVF9JUkVUX1JFR1Mgb2Zmc2V0PTgKKy5MZnJvbV91c2VybW9kZV9ub19nYXBfXEA6CisJLmVu
ZGlmCisKIAkuaWYgXHBhcmFub2lkCiAJY2FsbAlwYXJhbm9pZF9lbnRyeQogCS5lbHNlCkBAIC0x
MTMwLDcgKzExNDAsNyBAQCBhcGljaW50ZXJydXB0MyBIWVBFUlZfU1RJTUVSMF9WRUNUT1IgXAog
I2VuZGlmIC8qIENPTkZJR19IWVBFUlYgKi8KIAogaWR0ZW50cnkgZGVidWcJCQlkb19kZWJ1ZwkJ
aGFzX2Vycm9yX2NvZGU9MAlwYXJhbm9pZD0xIHNoaWZ0X2lzdD1ERUJVR19TVEFDSwotaWR0ZW50
cnkgaW50MwkJCWRvX2ludDMJCQloYXNfZXJyb3JfY29kZT0wCitpZHRlbnRyeSBpbnQzCQkJZG9f
aW50MwkJCWhhc19lcnJvcl9jb2RlPTAJY3JlYXRlX2dhcD0xCiBpZHRlbnRyeSBzdGFja19zZWdt
ZW50CQlkb19zdGFja19zZWdtZW50CWhhc19lcnJvcl9jb2RlPTEKIAogI2lmZGVmIENPTkZJR19Y
RU5fUFYKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2Z0cmFjZS5oIGIvYXJjaC94
ODYvaW5jbHVkZS9hc20vZnRyYWNlLmgKaW5kZXggY2YzNTA2MzllNzZkLi40YjMzNWFjNWFmY2Mg
MTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2luY2x1ZGUvYXNtL2Z0cmFjZS5oCisrKyBiL2FyY2gveDg2
L2luY2x1ZGUvYXNtL2Z0cmFjZS5oCkBAIC0zNyw3ICszNyw3IEBAIHN0cnVjdCBkeW5fYXJjaF9m
dHJhY2UgewogCS8qIE5vIGV4dHJhIGRhdGEgbmVlZGVkIGZvciB4ODYgKi8KIH07CiAKLWludCBm
dHJhY2VfaW50M19oYW5kbGVyKHN0cnVjdCBwdF9yZWdzICpyZWdzKTsKK2ludCBmdHJhY2VfaW50
M19oYW5kbGVyKHN0cnVjdCBwdF9yZWdzICoqcmVncyk7CiAKICNkZWZpbmUgRlRSQUNFX0dSQVBI
X1RSQU1QX0FERFIgRlRSQUNFX0dSQVBIX0FERFIKIApkaWZmIC0tZ2l0IGEvYXJjaC94ODYvaW5j
bHVkZS9hc20vdGV4dC1wYXRjaGluZy5oIGIvYXJjaC94ODYvaW5jbHVkZS9hc20vdGV4dC1wYXRj
aGluZy5oCmluZGV4IGU4NWZmNjVjNDNjMy4uODdmYWQ5ZjVjMzFiIDEwMDY0NAotLS0gYS9hcmNo
L3g4Ni9pbmNsdWRlL2FzbS90ZXh0LXBhdGNoaW5nLmgKKysrIGIvYXJjaC94ODYvaW5jbHVkZS9h
c20vdGV4dC1wYXRjaGluZy5oCkBAIC0zOSw0ICszOSw2NiBAQCBleHRlcm4gaW50IHBva2VfaW50
M19oYW5kbGVyKHN0cnVjdCBwdF9yZWdzICpyZWdzKTsKIGV4dGVybiB2b2lkICp0ZXh0X3Bva2Vf
YnAodm9pZCAqYWRkciwgY29uc3Qgdm9pZCAqb3Bjb2RlLCBzaXplX3QgbGVuLCB2b2lkICpoYW5k
bGVyKTsKIGV4dGVybiBpbnQgYWZ0ZXJfYm9vdG1lbTsKIAorc3RhdGljIGlubGluZSB2b2lkIGlu
dDNfZW11bGF0ZV9qbXAoc3RydWN0IHB0X3JlZ3MgKnJlZ3MsIHVuc2lnbmVkIGxvbmcgaXApCit7
CisJcmVncy0+aXAgPSBpcDsKK30KKworI2RlZmluZSBJTlQzX0lOU05fU0laRSAxCisjZGVmaW5l
IENBTExfSU5TTl9TSVpFIDUKKworLyoKKyAqIFRoZSAzMi1iaXQga2VybmVsIGVudHJ5IGV4Y2Vw
dGlvbiBzdGFjayBkb2VzIG5vdCBjb250YWluIHRoZSB3aG9sZQorICogJ3N0cnVjdCBwdF9yZWdz
JywgYmVjYXVzZSB0aGUgaGFyZHdhcmUgd2lsbCBub3QgcHVzaCBzcC9zcyB3aGVuIHRoZQorICog
cHJvdGVjdGlvbiBsZXZlbCBkb2Vzbid0IGNoYW5nZS4KKyAqCisgKiBTbyBwdXNoaW5nIGEgdmFs
dWUgb250byB0aGUgc3RhY2sgcmVxdWlyZXMgdXMgdG8gbWFrZSByb29tIGZvciBpdCBieQorICog
bW92aW5nIHRoZSB3aG9sZSB0cnVuY2F0ZWQgJ3B0X3JlZ3MnIGRvd24gYnkgZm91ciBieXRlcywg
YW5kIHRoZQorICogc3RhY2sgd2UgcmV0dXJuIHRvIHdpbGwgYmUgZGlyZWN0bHkgYWZ0ZXIgaXQu
IFRoZSBsb3dsZXZlbCB4ODYtMzIKKyAqIGVudHJ5IGNvZGUgd2lsbCBoYXZlIG1hZGUgcm9vbSBv
biB0aGUgc3RhY2sgZm9yIHRoaXMsIHNvIHdlJ3JlIG5vdAorICogb3ZlcndyaXRpbmcgYW55dGhp
bmcgZWxzZSB0aGVyZS4KKyAqCisgKiBPbiB4ODYtNjQsIHRoZSBleGNlcHRpb24gc3RhY2sgaXMg
bXVjaCBzaW1wbGVyLCBhbmQgYWx3YXlzIGNvbnRhaW5zCisgKiBzcC9zcywgc28gd2UgY2FuIGp1
c3QgdXBkYXRlIHRoZSB2YWx1ZXMgZGlyZWN0bHkuIEFnYWluLCB0aGUgZW50cnkKKyAqIGNvZGUg
aGFzIG1hZGUgc3VyZSB0aGVyZSBpcyBhIGdhcCAobm93IGFib3ZlIHB0X3JlZ3MhKSB0aGF0IHRo
aXMgaXMgb2suCisgKi8KK3N0YXRpYyBpbmxpbmUgc3RydWN0IHB0X3JlZ3MgKmludDNfZW11bGF0
ZV9wdXNoKHN0cnVjdCBwdF9yZWdzICpyZWdzLCB1bnNpZ25lZCBsb25nIHZhbHVlKQoreworI2lm
ZGVmIENPTkZJR19YODZfMzIKKyNkZWZpbmUgU0FWRURfS0VSTkVMX1JFR1NfU0laRSAob2Zmc2V0
b2Yoc3RydWN0IHB0X3JlZ3MsIHNwKSkKKwlzdHJ1Y3QgcHRfcmVncyAqbmV3ID0gKHZvaWQgKily
ZWdzIC0gc2l6ZW9mKGxvbmcpOworCW1lbW1vdmUobmV3LCByZWdzLCBTQVZFRF9LRVJORUxfUkVH
U19TSVpFKTsKKworCS8qCisJICogTk9URSEgJyZuZXctPnNwJyBpcyBhY3R1YWxseSB0aGUgdG9w
IG9mIHN0YWNrIHRoYXQgdGhhdCAnaW50MycKKwkgKiB3aWxsIHJldHVybiB0byEgU28gZGVzcGl0
ZSB3aGF0IHRoaXMgbG9va3MgbGlrZSwgdGhpcyBkb2Vzbid0CisJICogdXBkYXRlIHRoZSBzdGFj
ayBwb2ludGVyLCBidXQgd3JpdGluZyB0aGUgdmFsdWUgdG8gJ25ldy0+c3AnCisJICogaXMgYWN0
dWFsbHkgd3JpdGluZyB0aGUgdmFsdWUgKnRvKiB0aGUgdG9wIG9mIHRoZSBzdGFjayBpbgorCSAq
IHRoZSByZXR1cm5pbmcgY29udGV4dCEKKwkgKgorCSAqIFRoZSB0aGluZyB0aGF0IHVwZGF0ZXMg
dGhlIHN0YWNrIHBvaW50ZXIgaW4gdGhlIGNvbnRleHQgd2UKKwkgKiByZXR1cm4gdG8gaXMgdGhl
IGZhY3QgdGhhdCB3ZSBtb3ZlZCAnc3RydWN0IHB0X3JlZ3MnIGl0c2VsZiwKKwkgKiBhbmQgd2ls
bCBiZSByZXR1cm5pbmcgdXNpbmcgdGhhdCBtb3ZlZCBzdGFjayBmcmFtZS4KKwkgKi8KKwluZXct
PnNwID0gdmFsdWU7CisJcmV0dXJuIG5ldzsKKyNlbHNlCisJdW5zaWduZWQgbG9uZyAqc3A7CisK
KwlyZWdzLT5zcCAtPSBzaXplb2YobG9uZyk7CisJc3AgPSAodW5zaWduZWQgbG9uZyAqKXJlZ3Mt
PnNwOworCSpzcCA9IHZhbHVlOworCXJldHVybiByZWdzOworI2VuZGlmCit9CisKK3N0YXRpYyBp
bmxpbmUgc3RydWN0IHB0X3JlZ3MgKmludDNfZW11bGF0ZV9jYWxsKHN0cnVjdCBwdF9yZWdzICpy
ZWdzLCB1bnNpZ25lZCBsb25nIGZ1bmMpCit7CisJdW5zaWduZWQgbG9uZyBuZXh0X2lwID0gcmVn
cy0+aXAgLSBJTlQzX0lOU05fU0laRSArIENBTExfSU5TTl9TSVpFOworCisJcmVncyA9IGludDNf
ZW11bGF0ZV9wdXNoKHJlZ3MsIG5leHRfaXApOworCXJlZ3MtPmlwID0gZnVuYzsKKwlyZXR1cm4g
cmVnczsKK30KKwogI2VuZGlmIC8qIF9BU01fWDg2X1RFWFRfUEFUQ0hJTkdfSCAqLwpkaWZmIC0t
Z2l0IGEvYXJjaC94ODYva2VybmVsL2Z0cmFjZS5jIGIvYXJjaC94ODYva2VybmVsL2Z0cmFjZS5j
CmluZGV4IGVmNDk1MTdmNmJiMi4uNmMyMzlmY2E5OWQwIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9r
ZXJuZWwvZnRyYWNlLmMKKysrIGIvYXJjaC94ODYva2VybmVsL2Z0cmFjZS5jCkBAIC0yOSw2ICsy
OSw3IEBACiAjaW5jbHVkZSA8YXNtL2twcm9iZXMuaD4KICNpbmNsdWRlIDxhc20vZnRyYWNlLmg+
CiAjaW5jbHVkZSA8YXNtL25vcHMuaD4KKyNpbmNsdWRlIDxhc20vdGV4dC1wYXRjaGluZy5oPgog
CiAjaWZkZWYgQ09ORklHX0RZTkFNSUNfRlRSQUNFCiAKQEAgLTIzMSw2ICsyMzIsNyBAQCBpbnQg
ZnRyYWNlX21vZGlmeV9jYWxsKHN0cnVjdCBkeW5fZnRyYWNlICpyZWMsIHVuc2lnbmVkIGxvbmcg
b2xkX2FkZHIsCiB9CiAKIHN0YXRpYyB1bnNpZ25lZCBsb25nIGZ0cmFjZV91cGRhdGVfZnVuYzsK
K3N0YXRpYyB1bnNpZ25lZCBsb25nIGZ0cmFjZV91cGRhdGVfZnVuY19jYWxsOwogCiBzdGF0aWMg
aW50IHVwZGF0ZV9mdHJhY2VfZnVuYyh1bnNpZ25lZCBsb25nIGlwLCB2b2lkICpuZXcpCiB7CkBA
IC0yNTksNiArMjYxLDggQEAgaW50IGZ0cmFjZV91cGRhdGVfZnRyYWNlX2Z1bmMoZnRyYWNlX2Z1
bmNfdCBmdW5jKQogCXVuc2lnbmVkIGNoYXIgKm5ldzsKIAlpbnQgcmV0OwogCisJZnRyYWNlX3Vw
ZGF0ZV9mdW5jX2NhbGwgPSAodW5zaWduZWQgbG9uZylmdW5jOworCiAJbmV3ID0gZnRyYWNlX2Nh
bGxfcmVwbGFjZShpcCwgKHVuc2lnbmVkIGxvbmcpZnVuYyk7CiAJcmV0ID0gdXBkYXRlX2Z0cmFj
ZV9mdW5jKGlwLCBuZXcpOwogCkBAIC0yODcsMjAgKzI5MSwzMiBAQCBzdGF0aWMgbm9rcHJvYmVf
aW5saW5lIGludCBpc19mdHJhY2VfY2FsbGVyKHVuc2lnbmVkIGxvbmcgaXApCiAgKiBjYWxsIHRv
IGEgbm9wLiBXaGlsZSB0aGUgY2hhbmdlIGlzIHRha2luZyBwbGFjZSwgd2UgdHJlYXQKICAqIGl0
IGp1c3QgbGlrZSBpdCB3YXMgYSBub3AuCiAgKi8KLWludCBmdHJhY2VfaW50M19oYW5kbGVyKHN0
cnVjdCBwdF9yZWdzICpyZWdzKQoraW50IGZ0cmFjZV9pbnQzX2hhbmRsZXIoc3RydWN0IHB0X3Jl
Z3MgKipwcmVncykKIHsKKwlzdHJ1Y3QgcHRfcmVncyAqcmVncyA9ICpwcmVnczsKIAl1bnNpZ25l
ZCBsb25nIGlwOwogCiAJaWYgKFdBUk5fT05fT05DRSghcmVncykpCiAJCXJldHVybiAwOwogCi0J
aXAgPSByZWdzLT5pcCAtIDE7Ci0JaWYgKCFmdHJhY2VfbG9jYXRpb24oaXApICYmICFpc19mdHJh
Y2VfY2FsbGVyKGlwKSkKKwlpZiAodXNlcl9tb2RlKHJlZ3MpKQogCQlyZXR1cm4gMDsKIAotCXJl
Z3MtPmlwICs9IE1DT1VOVF9JTlNOX1NJWkUgLSAxOworCWlwID0gcmVncy0+aXAgLSBJTlQzX0lO
U05fU0laRTsKIAotCXJldHVybiAxOworCWlmIChmdHJhY2VfbG9jYXRpb24oaXApKSB7CisJCSpw
cmVncyA9IGludDNfZW11bGF0ZV9jYWxsKHJlZ3MsICh1bnNpZ25lZCBsb25nKWZ0cmFjZV9yZWdz
X2NhbGxlcik7CisJCXJldHVybiAxOworCX0gZWxzZSBpZiAoaXNfZnRyYWNlX2NhbGxlcihpcCkp
IHsKKwkJaWYgKCFmdHJhY2VfdXBkYXRlX2Z1bmNfY2FsbCkgeworCQkJaW50M19lbXVsYXRlX2pt
cChyZWdzLCBpcCArIENBTExfSU5TTl9TSVpFKTsKKwkJCXJldHVybiAxOworCQl9CisJCSpwcmVn
cyA9IGludDNfZW11bGF0ZV9jYWxsKHJlZ3MsIGZ0cmFjZV91cGRhdGVfZnVuY19jYWxsKTsKKwkJ
cmV0dXJuIDE7CisJfQorCisJcmV0dXJuIDA7CiB9CiBOT0tQUk9CRV9TWU1CT0woZnRyYWNlX2lu
dDNfaGFuZGxlcik7CiAKQEAgLTg1OSw2ICs4NzUsOCBAQCB2b2lkIGFyY2hfZnRyYWNlX3VwZGF0
ZV90cmFtcG9saW5lKHN0cnVjdCBmdHJhY2Vfb3BzICpvcHMpCiAKIAlmdW5jID0gZnRyYWNlX29w
c19nZXRfZnVuYyhvcHMpOwogCisJZnRyYWNlX3VwZGF0ZV9mdW5jX2NhbGwgPSAodW5zaWduZWQg
bG9uZylmdW5jOworCiAJLyogRG8gYSBzYWZlIG1vZGlmeSBpbiBjYXNlIHRoZSB0cmFtcG9saW5l
IGlzIGV4ZWN1dGluZyAqLwogCW5ldyA9IGZ0cmFjZV9jYWxsX3JlcGxhY2UoaXAsICh1bnNpZ25l
ZCBsb25nKWZ1bmMpOwogCXJldCA9IHVwZGF0ZV9mdHJhY2VfZnVuYyhpcCwgbmV3KTsKQEAgLTk2
MCw2ICs5NzgsNyBAQCBzdGF0aWMgaW50IGZ0cmFjZV9tb2Rfam1wKHVuc2lnbmVkIGxvbmcgaXAs
IHZvaWQgKmZ1bmMpCiB7CiAJdW5zaWduZWQgY2hhciAqbmV3OwogCisJZnRyYWNlX3VwZGF0ZV9m
dW5jX2NhbGwgPSAwVUw7CiAJbmV3ID0gZnRyYWNlX2ptcF9yZXBsYWNlKGlwLCAodW5zaWduZWQg
bG9uZylmdW5jKTsKIAogCXJldHVybiB1cGRhdGVfZnRyYWNlX2Z1bmMoaXAsIG5ldyk7CmRpZmYg
LS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvdHJhcHMuYyBiL2FyY2gveDg2L2tlcm5lbC90cmFwcy5j
CmluZGV4IGQyNmY5ZTljM2Q4My4uZTgxMWU1NWFiMDMwIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9r
ZXJuZWwvdHJhcHMuYworKysgYi9hcmNoL3g4Ni9rZXJuZWwvdHJhcHMuYwpAQCAtNTcwLDcgKzU3
MCw3IEBAIGRvX2dlbmVyYWxfcHJvdGVjdGlvbihzdHJ1Y3QgcHRfcmVncyAqcmVncywgbG9uZyBl
cnJvcl9jb2RlKQogfQogTk9LUFJPQkVfU1lNQk9MKGRvX2dlbmVyYWxfcHJvdGVjdGlvbik7CiAK
LWRvdHJhcGxpbmthZ2Ugdm9pZCBub3RyYWNlIGRvX2ludDMoc3RydWN0IHB0X3JlZ3MgKnJlZ3Ms
IGxvbmcgZXJyb3JfY29kZSkKK2RvdHJhcGxpbmthZ2Ugc3RydWN0IHB0X3JlZ3MgKiBub3RyYWNl
IGRvX2tlcm5lbF9pbnQzKHN0cnVjdCBwdF9yZWdzICpyZWdzLCBsb25nIGVycm9yX2NvZGUpCiB7
CiAjaWZkZWYgQ09ORklHX0RZTkFNSUNfRlRSQUNFCiAJLyoKQEAgLTU3OCwxMSArNTc4LDExIEBA
IGRvdHJhcGxpbmthZ2Ugdm9pZCBub3RyYWNlIGRvX2ludDMoc3RydWN0IHB0X3JlZ3MgKnJlZ3Ms
IGxvbmcgZXJyb3JfY29kZSkKIAkgKiBTZWUgbm90ZSBieSBkZWNsYXJhdGlvbiBvZiBtb2RpZnlp
bmdfZnRyYWNlX2NvZGUgaW4gZnRyYWNlLmMKIAkgKi8KIAlpZiAodW5saWtlbHkoYXRvbWljX3Jl
YWQoJm1vZGlmeWluZ19mdHJhY2VfY29kZSkpICYmCi0JICAgIGZ0cmFjZV9pbnQzX2hhbmRsZXIo
cmVncykpCi0JCXJldHVybjsKKwkgICAgZnRyYWNlX2ludDNfaGFuZGxlcigmcmVncykpCisJCXJl
dHVybiByZWdzOwogI2VuZGlmCiAJaWYgKHBva2VfaW50M19oYW5kbGVyKHJlZ3MpKQotCQlyZXR1
cm47CisJCXJldHVybiByZWdzOwogCiAJLyoKIAkgKiBVc2UgaXN0X2VudGVyIGRlc3BpdGUgdGhl
IGZhY3QgdGhhdCB3ZSBkb24ndCB1c2UgYW4gSVNUIHN0YWNrLgpAQCAtNjE0LDYgKzYxNCwxMyBA
QCBkb3RyYXBsaW5rYWdlIHZvaWQgbm90cmFjZSBkb19pbnQzKHN0cnVjdCBwdF9yZWdzICpyZWdz
LCBsb25nIGVycm9yX2NvZGUpCiAKIGV4aXQ6CiAJaXN0X2V4aXQocmVncyk7CisJcmV0dXJuIHJl
Z3M7Cit9CitOT0tQUk9CRV9TWU1CT0woZG9fa2VybmVsX2ludDMpOworCitkb3RyYXBsaW5rYWdl
IHZvaWQgbm90cmFjZSBkb19pbnQzKHN0cnVjdCBwdF9yZWdzICpyZWdzLCBsb25nIGVycm9yX2Nv
ZGUpCit7CisJV0FSTl9PTl9PTkNFKGRvX2tlcm5lbF9pbnQzKHJlZ3MsIGVycm9yX2NvZGUpICE9
IHJlZ3MpOwogfQogTk9LUFJPQkVfU1lNQk9MKGRvX2ludDMpOwogCg==
--00000000000033a78605881479d1--
