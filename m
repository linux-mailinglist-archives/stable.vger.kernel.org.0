Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22BAD16627
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 17:02:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726452AbfEGPCZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 11:02:25 -0400
Received: from mail-lf1-f66.google.com ([209.85.167.66]:43681 "EHLO
        mail-lf1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725843AbfEGPCY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 11:02:24 -0400
Received: by mail-lf1-f66.google.com with SMTP id u27so11846075lfg.10
        for <stable@vger.kernel.org>; Tue, 07 May 2019 08:02:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HEUButXGYFVvFjpkXgb4/5PcKUQjhj5t+A6A255naXM=;
        b=SPvalmn1mJUtfVy8JtgZzBBvp3YDobRGwTxABByzT0PwuHwBEFzDpFBXlRo2/Adgd2
         xD8bpdM9pB1NchIVVO9koZvHZYxclmqDdyWhQiim3xKQmS+Os1JAkWejbhQY8GpDqfsv
         Z8yC04mBtT7l9cfk29WDwsg9QinXmoRqg5hC0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HEUButXGYFVvFjpkXgb4/5PcKUQjhj5t+A6A255naXM=;
        b=aRWVVjFxWv+FLcx31pu0O7cHtKMvbaqdAXLGG8fQSs333ej1vWX6GUW790DCh9s2Si
         QQZl2EJw5RiVjo+20BeV3vYNdx9ylFbSnIylLztjdkoUDmB3p9dfHAJvn3EKqPbd4yPQ
         8ndAKPdAU5ReyPVJ2skyx1XWahT5mORNEbRi8YYTlIHror88O5bSnITcsMoemp3YFDWG
         DHGU1l+aIjrkzK38gxWCJ/wNWgV/aZbx8FDAnwFhXQjvunDwmqDwI/qBRNyB/IPuGOKX
         g84p/8q8mPHvVIaXGWERwv2EAuBg74Sqh/UqI/5WbjAyv14FB5NsVGA2Jfy+bNoM3T32
         DQbA==
X-Gm-Message-State: APjAAAUOgmJJxI3WUvc//XipLpuQRVrvEFuu55kP7REIP3jTeIKWxeLL
        +rhnxynVCsJn9pecCQmt4XAFuD3ewrY=
X-Google-Smtp-Source: APXvYqwtaQVmXyADzUaboxGTlkB7K/3tfBXboOd+t5enXbuLZ4P8T/WopWrBeqo2U2N9WsMYnvE6Aw==
X-Received: by 2002:a19:385e:: with SMTP id d30mr14896446lfj.119.1557241341566;
        Tue, 07 May 2019 08:02:21 -0700 (PDT)
Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com. [209.85.208.177])
        by smtp.gmail.com with ESMTPSA id n1sm3183852ljg.84.2019.05.07.08.02.21
        for <stable@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 07 May 2019 08:02:21 -0700 (PDT)
Received: by mail-lj1-f177.google.com with SMTP id e13so65987ljl.11
        for <stable@vger.kernel.org>; Tue, 07 May 2019 08:02:21 -0700 (PDT)
X-Received: by 2002:a05:651c:8f:: with SMTP id 15mr16818756ljq.118.1557240910069;
 Tue, 07 May 2019 07:55:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190502181811.GY2623@hirez.programming.kicks-ass.net>
 <20190506095631.6f71ad7c@gandalf.local.home> <CAHk-=wgw_Jmn1iJWanoSFb1QZn3mbTD_JEoMsWcWj5QPeyHZHA@mail.gmail.com>
 <20190506130643.62c35eeb@gandalf.local.home> <CAHk-=whesas+GDtHZks62wqXWXe4d_g3XJ359GX81qj=Fgs6qQ@mail.gmail.com>
 <20190506145745.17c59596@gandalf.local.home> <CAHk-=witfFBW2O5v6g--FmqnAFsMkKNLosTFfWyaoJ7euQF8kQ@mail.gmail.com>
 <20190506162915.380993f9@gandalf.local.home> <CAHk-=wi5KBWUOvM94aTOPnoJ5L_aQG=vgLQ4SxxZDeQD0pF2tQ@mail.gmail.com>
 <20190506174511.2f8b696b@gandalf.local.home> <CAHk-=wj3R_s0RTJOmTBNaUPhu4fz2shNBUr4M6Ej65UYSNCs-g@mail.gmail.com>
 <20190506210416.2489a659@oasis.local.home> <CAHk-=whZwqzbu-=1r_j_cXfd=ta1q7RFCuneqBZfQQhS_P-BmQ@mail.gmail.com>
 <20190506215353.14a8ef78@oasis.local.home> <CAHk-=wjLXmOn=Cp=uOfO4gE01eN_-UcOUyrMTTw5-f_OfPO48Q@mail.gmail.com>
 <20190506225819.11756974@oasis.local.home> <CAHk-=wh4FCNBLe8OyDZt2Tr+k9JhhTsg3H8R4b55peKcf0b6eQ@mail.gmail.com>
 <20190506232158.13c9123b@oasis.local.home> <CAHk-=wi4vPg4pu6RvxQrUuBL4Vgwd2G2iaEJVVumny+cBOWMZw@mail.gmail.com>
In-Reply-To: <CAHk-=wi4vPg4pu6RvxQrUuBL4Vgwd2G2iaEJVVumny+cBOWMZw@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 7 May 2019 07:54:53 -0700
X-Gmail-Original-Message-ID: <CAHk-=wg2_okyU8mpkGCUrudgfg8YmNetSD8=scNbOkN+imqZdQ@mail.gmail.com>
Message-ID: <CAHk-=wg2_okyU8mpkGCUrudgfg8YmNetSD8=scNbOkN+imqZdQ@mail.gmail.com>
Subject: Re: [RFC][PATCH 1/2] x86: Allow breakpoints to emulate call functions
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Andy Lutomirski <luto@amacapital.net>,
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
        <linux-kselftest@vger.kernel.org>, stable <stable@vger.kernel.org>,
        Masami Hiramatsu <mhiramat@kernel.org>
Content-Type: multipart/mixed; boundary="000000000000467f4205884d67ea"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000467f4205884d67ea
Content-Type: text/plain; charset="UTF-8"

Duh.

I woke up this morning, realizing what was wrong with my patch.



On Mon, May 6, 2019 at 8:28 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> Yes. But I was looking at the ftrace parts because I didn't see the
> bug in the low-level x86 side, so...

There was nothing wrong in the *low-level* parts. There was one thing
wrong with the "in3_emulate_push()" code:

        memmove(new, regs, SAVED_KERNEL_REGS_SIZE);

which ends up calling an out-of-line function. One that is traced. One
that will recursively result in 'int3'. Which will fill up the stack
until you get a triple fault and reboot.

Stupid stupid.

Anyway, changing that to just copying things one word at a time makes
everything work. The attached patch boots with the whole ftrace test
thing.The only change is literally changing that memmove()  into

        /* Inlined "memmove()" of the pt_regs */
        unsigned long *p = (unsigned long *) new;
        int i = SAVED_KERNEL_REGS_SIZE / sizeof(unsigned long);
        do { *p = p[1]; p++; } while (--i);

which I'm not entirely proud of, but it sure is still simple.

And honestly, I absolutely despise PeterZ's patch. The notion that we
should suddenly say that "oh, the i386 kernel stack is odd" after 28
years of having that standard i386 stack is just crazy. And this:

 arch/x86/entry/entry_32.S            | 136 ++++++++++++++++++++++++++++-------
...
 12 files changed, 323 insertions(+), 140 deletions(-)


vs this:

 arch/x86/entry/entry_32.S            |  7 +++-
...
 6 files changed, 120 insertions(+), 13 deletions(-)

is still pretty damn conclusive. Not to mention that the simple
approach had a truly mindbogglingly simple solution with no actual
subtle changes anywhere else.

So I still claim that we should do my patch. Because it is SIMPLE.
It's straightforward, and I can explain every single line in it. Even
if I spent *way* too long until I realized that the "trivial"
memmove() wasn't so trivial.

                     Linus

--000000000000467f4205884d67ea
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_jvdx0q7d0>
X-Attachment-Id: f_jvdx0q7d0

IGFyY2gveDg2L2VudHJ5L2VudHJ5XzMyLlMgICAgICAgICAgICB8ICA3ICsrKy0KIGFyY2gveDg2
L2VudHJ5L2VudHJ5XzY0LlMgICAgICAgICAgICB8IDE0ICsrKysrKy0tCiBhcmNoL3g4Ni9pbmNs
dWRlL2FzbS9mdHJhY2UuaCAgICAgICAgfCAgMiArLQogYXJjaC94ODYvaW5jbHVkZS9hc20vdGV4
dC1wYXRjaGluZy5oIHwgNjYgKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrKysrCiBh
cmNoL3g4Ni9rZXJuZWwvZnRyYWNlLmMgICAgICAgICAgICAgfCAyOSArKysrKysrKysrKysrLS0t
CiBhcmNoL3g4Ni9rZXJuZWwvdHJhcHMuYyAgICAgICAgICAgICAgfCAxNSArKysrKy0tLQogNiBm
aWxlcyBjaGFuZ2VkLCAxMjAgaW5zZXJ0aW9ucygrKSwgMTMgZGVsZXRpb25zKC0pCgpkaWZmIC0t
Z2l0IGEvYXJjaC94ODYvZW50cnkvZW50cnlfMzIuUyBiL2FyY2gveDg2L2VudHJ5L2VudHJ5XzMy
LlMKaW5kZXggZDMwOWYzMGNmN2FmLi4xMzhhYzQzMjIyMWIgMTAwNjQ0Ci0tLSBhL2FyY2gveDg2
L2VudHJ5L2VudHJ5XzMyLlMKKysrIGIvYXJjaC94ODYvZW50cnkvZW50cnlfMzIuUwpAQCAtMTQ4
Myw3ICsxNDgzLDEyIEBAIEVOVFJZKGludDMpCiAJVFJBQ0VfSVJRU19PRkYKIAl4b3JsCSVlZHgs
ICVlZHgJCQkjIHplcm8gZXJyb3IgY29kZQogCW1vdmwJJWVzcCwgJWVheAkJCSMgcHRfcmVncyBw
b2ludGVyCi0JY2FsbAlkb19pbnQzCisKKwkjIG1ha2Ugcm9vbSBvbiBrZXJuZWwgc3RhY2sgZm9y
IHB1c2ggZW11bGF0aW9uCisJIyBkb19rZXJuZWxfaW50MyByZXR1cm5zIHBvc3NpYmx5IHVwZGF0
ZWQgcHRfcmVncworCXN1YmwJJDgsICVlc3AKKwljYWxsCWRvX2tlcm5lbF9pbnQzCisJbW92bAkl
ZWF4LCAlZXNwCiAJam1wCXJldF9mcm9tX2V4Y2VwdGlvbgogRU5EKGludDMpCiAKZGlmZiAtLWdp
dCBhL2FyY2gveDg2L2VudHJ5L2VudHJ5XzY0LlMgYi9hcmNoL3g4Ni9lbnRyeS9lbnRyeV82NC5T
CmluZGV4IDFmMGVmZGI3YjYyOS4uODM0ZWMxMzk3ZGFiIDEwMDY0NAotLS0gYS9hcmNoL3g4Ni9l
bnRyeS9lbnRyeV82NC5TCisrKyBiL2FyY2gveDg2L2VudHJ5L2VudHJ5XzY0LlMKQEAgLTg3OSw3
ICs4NzksNyBAQCBhcGljaW50ZXJydXB0IElSUV9XT1JLX1ZFQ1RPUgkJCWlycV93b3JrX2ludGVy
cnVwdAkJc21wX2lycV93b3JrX2ludGVycnVwdAogICogQHBhcmFub2lkID09IDIgaXMgc3BlY2lh
bDogdGhlIHN0dWIgd2lsbCBuZXZlciBzd2l0Y2ggc3RhY2tzLiAgVGhpcyBpcyBmb3IKICAqICNE
RjogaWYgdGhlIHRocmVhZCBzdGFjayBpcyBzb21laG93IHVudXNhYmxlLCB3ZSdsbCBzdGlsbCBn
ZXQgYSB1c2VmdWwgT09QUy4KICAqLwotLm1hY3JvIGlkdGVudHJ5IHN5bSBkb19zeW0gaGFzX2Vy
cm9yX2NvZGU6cmVxIHBhcmFub2lkPTAgc2hpZnRfaXN0PS0xCisubWFjcm8gaWR0ZW50cnkgc3lt
IGRvX3N5bSBoYXNfZXJyb3JfY29kZTpyZXEgcGFyYW5vaWQ9MCBzaGlmdF9pc3Q9LTEgY3JlYXRl
X2dhcD0wCiBFTlRSWShcc3ltKQogCVVOV0lORF9ISU5UX0lSRVRfUkVHUyBvZmZzZXQ9XGhhc19l
cnJvcl9jb2RlKjgKIApAQCAtODk5LDYgKzg5OSwxNiBAQCBFTlRSWShcc3ltKQogCWpuegkuTGZy
b21fdXNlcm1vZGVfc3dpdGNoX3N0YWNrX1xACiAJLmVuZGlmCiAKKwkuaWYgXGNyZWF0ZV9nYXAg
PT0gMQorCXRlc3RiCSQzLCBDUy1PUklHX1JBWCglcnNwKQorCWpuegkuTGZyb21fdXNlcm1vZGVf
bm9fZ2FwX1xACisJLnJlcHQgNgorCXB1c2hxCTUqOCglcnNwKQorCS5lbmRyCisJVU5XSU5EX0hJ
TlRfSVJFVF9SRUdTIG9mZnNldD04CisuTGZyb21fdXNlcm1vZGVfbm9fZ2FwX1xAOgorCS5lbmRp
ZgorCiAJLmlmIFxwYXJhbm9pZAogCWNhbGwJcGFyYW5vaWRfZW50cnkKIAkuZWxzZQpAQCAtMTEz
MCw3ICsxMTQwLDcgQEAgYXBpY2ludGVycnVwdDMgSFlQRVJWX1NUSU1FUjBfVkVDVE9SIFwKICNl
bmRpZiAvKiBDT05GSUdfSFlQRVJWICovCiAKIGlkdGVudHJ5IGRlYnVnCQkJZG9fZGVidWcJCWhh
c19lcnJvcl9jb2RlPTAJcGFyYW5vaWQ9MSBzaGlmdF9pc3Q9REVCVUdfU1RBQ0sKLWlkdGVudHJ5
IGludDMJCQlkb19pbnQzCQkJaGFzX2Vycm9yX2NvZGU9MAoraWR0ZW50cnkgaW50MwkJCWRvX2lu
dDMJCQloYXNfZXJyb3JfY29kZT0wCWNyZWF0ZV9nYXA9MQogaWR0ZW50cnkgc3RhY2tfc2VnbWVu
dAkJZG9fc3RhY2tfc2VnbWVudAloYXNfZXJyb3JfY29kZT0xCiAKICNpZmRlZiBDT05GSUdfWEVO
X1BWCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9mdHJhY2UuaCBiL2FyY2gveDg2
L2luY2x1ZGUvYXNtL2Z0cmFjZS5oCmluZGV4IGNmMzUwNjM5ZTc2ZC4uNGIzMzVhYzVhZmNjIDEw
MDY0NAotLS0gYS9hcmNoL3g4Ni9pbmNsdWRlL2FzbS9mdHJhY2UuaAorKysgYi9hcmNoL3g4Ni9p
bmNsdWRlL2FzbS9mdHJhY2UuaApAQCAtMzcsNyArMzcsNyBAQCBzdHJ1Y3QgZHluX2FyY2hfZnRy
YWNlIHsKIAkvKiBObyBleHRyYSBkYXRhIG5lZWRlZCBmb3IgeDg2ICovCiB9OwogCi1pbnQgZnRy
YWNlX2ludDNfaGFuZGxlcihzdHJ1Y3QgcHRfcmVncyAqcmVncyk7CitpbnQgZnRyYWNlX2ludDNf
aGFuZGxlcihzdHJ1Y3QgcHRfcmVncyAqKnJlZ3MpOwogCiAjZGVmaW5lIEZUUkFDRV9HUkFQSF9U
UkFNUF9BRERSIEZUUkFDRV9HUkFQSF9BRERSCiAKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2luY2x1
ZGUvYXNtL3RleHQtcGF0Y2hpbmcuaCBiL2FyY2gveDg2L2luY2x1ZGUvYXNtL3RleHQtcGF0Y2hp
bmcuaAppbmRleCBlODVmZjY1YzQzYzMuLmM5MWZkZWNhYjljMiAxMDA2NDQKLS0tIGEvYXJjaC94
ODYvaW5jbHVkZS9hc20vdGV4dC1wYXRjaGluZy5oCisrKyBiL2FyY2gveDg2L2luY2x1ZGUvYXNt
L3RleHQtcGF0Y2hpbmcuaApAQCAtMzksNCArMzksNzAgQEAgZXh0ZXJuIGludCBwb2tlX2ludDNf
aGFuZGxlcihzdHJ1Y3QgcHRfcmVncyAqcmVncyk7CiBleHRlcm4gdm9pZCAqdGV4dF9wb2tlX2Jw
KHZvaWQgKmFkZHIsIGNvbnN0IHZvaWQgKm9wY29kZSwgc2l6ZV90IGxlbiwgdm9pZCAqaGFuZGxl
cik7CiBleHRlcm4gaW50IGFmdGVyX2Jvb3RtZW07CiAKK3N0YXRpYyBpbmxpbmUgdm9pZCBpbnQz
X2VtdWxhdGVfam1wKHN0cnVjdCBwdF9yZWdzICpyZWdzLCB1bnNpZ25lZCBsb25nIGlwKQorewor
CXJlZ3MtPmlwID0gaXA7Cit9CisKKyNkZWZpbmUgSU5UM19JTlNOX1NJWkUgMQorI2RlZmluZSBD
QUxMX0lOU05fU0laRSA1CisKKy8qCisgKiBUaGUgMzItYml0IGtlcm5lbCBlbnRyeSBleGNlcHRp
b24gc3RhY2sgZG9lcyBub3QgY29udGFpbiB0aGUgd2hvbGUKKyAqICdzdHJ1Y3QgcHRfcmVncycs
IGJlY2F1c2UgdGhlIGhhcmR3YXJlIHdpbGwgbm90IHB1c2ggc3Avc3Mgd2hlbiB0aGUKKyAqIHBy
b3RlY3Rpb24gbGV2ZWwgZG9lc24ndCBjaGFuZ2UuCisgKgorICogU28gcHVzaGluZyBhIHZhbHVl
IG9udG8gdGhlIHN0YWNrIHJlcXVpcmVzIHVzIHRvIG1ha2Ugcm9vbSBmb3IgaXQgYnkKKyAqIG1v
dmluZyB0aGUgd2hvbGUgdHJ1bmNhdGVkICdwdF9yZWdzJyBkb3duIGJ5IGZvdXIgYnl0ZXMsIGFu
ZCB0aGUKKyAqIHN0YWNrIHdlIHJldHVybiB0byB3aWxsIGJlIGRpcmVjdGx5IGFmdGVyIGl0LiBU
aGUgbG93bGV2ZWwgeDg2LTMyCisgKiBlbnRyeSBjb2RlIHdpbGwgaGF2ZSBtYWRlIHJvb20gb24g
dGhlIHN0YWNrIGZvciB0aGlzLCBzbyB3ZSdyZSBub3QKKyAqIG92ZXJ3cml0aW5nIGFueXRoaW5n
IGVsc2UgdGhlcmUuCisgKgorICogT24geDg2LTY0LCB0aGUgZXhjZXB0aW9uIHN0YWNrIGlzIG11
Y2ggc2ltcGxlciwgYW5kIGFsd2F5cyBjb250YWlucworICogc3Avc3MsIHNvIHdlIGNhbiBqdXN0
IHVwZGF0ZSB0aGUgdmFsdWVzIGRpcmVjdGx5LiBBZ2FpbiwgdGhlIGVudHJ5CisgKiBjb2RlIGhh
cyBtYWRlIHN1cmUgdGhlcmUgaXMgYSBnYXAgKG5vdyBhYm92ZSBwdF9yZWdzISkgdGhhdCB0aGlz
IGlzIG9rLgorICovCitzdGF0aWMgaW5saW5lIHN0cnVjdCBwdF9yZWdzICppbnQzX2VtdWxhdGVf
cHVzaChzdHJ1Y3QgcHRfcmVncyAqcmVncywgdW5zaWduZWQgbG9uZyB2YWx1ZSkKK3sKKyNpZmRl
ZiBDT05GSUdfWDg2XzMyCisjZGVmaW5lIFNBVkVEX0tFUk5FTF9SRUdTX1NJWkUgKG9mZnNldG9m
KHN0cnVjdCBwdF9yZWdzLCBzcCkpCisJc3RydWN0IHB0X3JlZ3MgKm5ldyA9ICh2b2lkICopcmVn
cyAtIHNpemVvZihsb25nKTsKKworCS8qIElubGluZWQgIm1lbW1vdmUoKSIgb2YgdGhlIHB0X3Jl
Z3MgKi8KKwl1bnNpZ25lZCBsb25nICpwID0gKHVuc2lnbmVkIGxvbmcgKikgbmV3OworCWludCBp
ID0gU0FWRURfS0VSTkVMX1JFR1NfU0laRSAvIHNpemVvZih1bnNpZ25lZCBsb25nKTsKKwlkbyB7
ICpwID0gcFsxXTsgcCsrOyB9IHdoaWxlICgtLWkpOworCisJLyoKKwkgKiBOT1RFISAnJm5ldy0+
c3AnIGlzIGFjdHVhbGx5IHRoZSB0b3Agb2Ygc3RhY2sgdGhhdCB0aGF0ICdpbnQzJworCSAqIHdp
bGwgcmV0dXJuIHRvISBTbyBkZXNwaXRlIHdoYXQgdGhpcyBsb29rcyBsaWtlLCB0aGlzIGRvZXNu
J3QKKwkgKiB1cGRhdGUgdGhlIHN0YWNrIHBvaW50ZXIsIGJ1dCB3cml0aW5nIHRoZSB2YWx1ZSB0
byAnbmV3LT5zcCcKKwkgKiBpcyBhY3R1YWxseSB3cml0aW5nIHRoZSB2YWx1ZSAqdG8qIHRoZSB0
b3Agb2YgdGhlIHN0YWNrIGluCisJICogdGhlIHJldHVybmluZyBjb250ZXh0IQorCSAqCisJICog
VGhlIHRoaW5nIHRoYXQgdXBkYXRlcyB0aGUgc3RhY2sgcG9pbnRlciBpbiB0aGUgY29udGV4dCB3
ZQorCSAqIHJldHVybiB0byBpcyB0aGUgZmFjdCB0aGF0IHdlIG1vdmVkICdzdHJ1Y3QgcHRfcmVn
cycgaXRzZWxmLAorCSAqIGFuZCB3aWxsIGJlIHJldHVybmluZyB1c2luZyB0aGF0IG1vdmVkIHN0
YWNrIGZyYW1lLgorCSAqLworCW5ldy0+c3AgPSB2YWx1ZTsKKwlyZXR1cm4gbmV3OworI2Vsc2UK
Kwl1bnNpZ25lZCBsb25nICpzcDsKKworCXJlZ3MtPnNwIC09IHNpemVvZihsb25nKTsKKwlzcCA9
ICh1bnNpZ25lZCBsb25nICopcmVncy0+c3A7CisJKnNwID0gdmFsdWU7CisJcmV0dXJuIHJlZ3M7
CisjZW5kaWYKK30KKworc3RhdGljIGlubGluZSBzdHJ1Y3QgcHRfcmVncyAqaW50M19lbXVsYXRl
X2NhbGwoc3RydWN0IHB0X3JlZ3MgKnJlZ3MsIHVuc2lnbmVkIGxvbmcgZnVuYykKK3sKKwl1bnNp
Z25lZCBsb25nIG5leHRfaXAgPSByZWdzLT5pcCAtIElOVDNfSU5TTl9TSVpFICsgQ0FMTF9JTlNO
X1NJWkU7CisKKwlyZWdzID0gaW50M19lbXVsYXRlX3B1c2gocmVncywgbmV4dF9pcCk7CisJcmVn
cy0+aXAgPSBmdW5jOworCXJldHVybiByZWdzOworfQorCiAjZW5kaWYgLyogX0FTTV9YODZfVEVY
VF9QQVRDSElOR19IICovCmRpZmYgLS1naXQgYS9hcmNoL3g4Ni9rZXJuZWwvZnRyYWNlLmMgYi9h
cmNoL3g4Ni9rZXJuZWwvZnRyYWNlLmMKaW5kZXggZWY0OTUxN2Y2YmIyLi42YzIzOWZjYTk5ZDAg
MTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC9mdHJhY2UuYworKysgYi9hcmNoL3g4Ni9rZXJu
ZWwvZnRyYWNlLmMKQEAgLTI5LDYgKzI5LDcgQEAKICNpbmNsdWRlIDxhc20va3Byb2Jlcy5oPgog
I2luY2x1ZGUgPGFzbS9mdHJhY2UuaD4KICNpbmNsdWRlIDxhc20vbm9wcy5oPgorI2luY2x1ZGUg
PGFzbS90ZXh0LXBhdGNoaW5nLmg+CiAKICNpZmRlZiBDT05GSUdfRFlOQU1JQ19GVFJBQ0UKIApA
QCAtMjMxLDYgKzIzMiw3IEBAIGludCBmdHJhY2VfbW9kaWZ5X2NhbGwoc3RydWN0IGR5bl9mdHJh
Y2UgKnJlYywgdW5zaWduZWQgbG9uZyBvbGRfYWRkciwKIH0KIAogc3RhdGljIHVuc2lnbmVkIGxv
bmcgZnRyYWNlX3VwZGF0ZV9mdW5jOworc3RhdGljIHVuc2lnbmVkIGxvbmcgZnRyYWNlX3VwZGF0
ZV9mdW5jX2NhbGw7CiAKIHN0YXRpYyBpbnQgdXBkYXRlX2Z0cmFjZV9mdW5jKHVuc2lnbmVkIGxv
bmcgaXAsIHZvaWQgKm5ldykKIHsKQEAgLTI1OSw2ICsyNjEsOCBAQCBpbnQgZnRyYWNlX3VwZGF0
ZV9mdHJhY2VfZnVuYyhmdHJhY2VfZnVuY190IGZ1bmMpCiAJdW5zaWduZWQgY2hhciAqbmV3Owog
CWludCByZXQ7CiAKKwlmdHJhY2VfdXBkYXRlX2Z1bmNfY2FsbCA9ICh1bnNpZ25lZCBsb25nKWZ1
bmM7CisKIAluZXcgPSBmdHJhY2VfY2FsbF9yZXBsYWNlKGlwLCAodW5zaWduZWQgbG9uZylmdW5j
KTsKIAlyZXQgPSB1cGRhdGVfZnRyYWNlX2Z1bmMoaXAsIG5ldyk7CiAKQEAgLTI4NywyMCArMjkx
LDMyIEBAIHN0YXRpYyBub2twcm9iZV9pbmxpbmUgaW50IGlzX2Z0cmFjZV9jYWxsZXIodW5zaWdu
ZWQgbG9uZyBpcCkKICAqIGNhbGwgdG8gYSBub3AuIFdoaWxlIHRoZSBjaGFuZ2UgaXMgdGFraW5n
IHBsYWNlLCB3ZSB0cmVhdAogICogaXQganVzdCBsaWtlIGl0IHdhcyBhIG5vcC4KICAqLwotaW50
IGZ0cmFjZV9pbnQzX2hhbmRsZXIoc3RydWN0IHB0X3JlZ3MgKnJlZ3MpCitpbnQgZnRyYWNlX2lu
dDNfaGFuZGxlcihzdHJ1Y3QgcHRfcmVncyAqKnByZWdzKQogeworCXN0cnVjdCBwdF9yZWdzICpy
ZWdzID0gKnByZWdzOwogCXVuc2lnbmVkIGxvbmcgaXA7CiAKIAlpZiAoV0FSTl9PTl9PTkNFKCFy
ZWdzKSkKIAkJcmV0dXJuIDA7CiAKLQlpcCA9IHJlZ3MtPmlwIC0gMTsKLQlpZiAoIWZ0cmFjZV9s
b2NhdGlvbihpcCkgJiYgIWlzX2Z0cmFjZV9jYWxsZXIoaXApKQorCWlmICh1c2VyX21vZGUocmVn
cykpCiAJCXJldHVybiAwOwogCi0JcmVncy0+aXAgKz0gTUNPVU5UX0lOU05fU0laRSAtIDE7CisJ
aXAgPSByZWdzLT5pcCAtIElOVDNfSU5TTl9TSVpFOwogCi0JcmV0dXJuIDE7CisJaWYgKGZ0cmFj
ZV9sb2NhdGlvbihpcCkpIHsKKwkJKnByZWdzID0gaW50M19lbXVsYXRlX2NhbGwocmVncywgKHVu
c2lnbmVkIGxvbmcpZnRyYWNlX3JlZ3NfY2FsbGVyKTsKKwkJcmV0dXJuIDE7CisJfSBlbHNlIGlm
IChpc19mdHJhY2VfY2FsbGVyKGlwKSkgeworCQlpZiAoIWZ0cmFjZV91cGRhdGVfZnVuY19jYWxs
KSB7CisJCQlpbnQzX2VtdWxhdGVfam1wKHJlZ3MsIGlwICsgQ0FMTF9JTlNOX1NJWkUpOworCQkJ
cmV0dXJuIDE7CisJCX0KKwkJKnByZWdzID0gaW50M19lbXVsYXRlX2NhbGwocmVncywgZnRyYWNl
X3VwZGF0ZV9mdW5jX2NhbGwpOworCQlyZXR1cm4gMTsKKwl9CisKKwlyZXR1cm4gMDsKIH0KIE5P
S1BST0JFX1NZTUJPTChmdHJhY2VfaW50M19oYW5kbGVyKTsKIApAQCAtODU5LDYgKzg3NSw4IEBA
IHZvaWQgYXJjaF9mdHJhY2VfdXBkYXRlX3RyYW1wb2xpbmUoc3RydWN0IGZ0cmFjZV9vcHMgKm9w
cykKIAogCWZ1bmMgPSBmdHJhY2Vfb3BzX2dldF9mdW5jKG9wcyk7CiAKKwlmdHJhY2VfdXBkYXRl
X2Z1bmNfY2FsbCA9ICh1bnNpZ25lZCBsb25nKWZ1bmM7CisKIAkvKiBEbyBhIHNhZmUgbW9kaWZ5
IGluIGNhc2UgdGhlIHRyYW1wb2xpbmUgaXMgZXhlY3V0aW5nICovCiAJbmV3ID0gZnRyYWNlX2Nh
bGxfcmVwbGFjZShpcCwgKHVuc2lnbmVkIGxvbmcpZnVuYyk7CiAJcmV0ID0gdXBkYXRlX2Z0cmFj
ZV9mdW5jKGlwLCBuZXcpOwpAQCAtOTYwLDYgKzk3OCw3IEBAIHN0YXRpYyBpbnQgZnRyYWNlX21v
ZF9qbXAodW5zaWduZWQgbG9uZyBpcCwgdm9pZCAqZnVuYykKIHsKIAl1bnNpZ25lZCBjaGFyICpu
ZXc7CiAKKwlmdHJhY2VfdXBkYXRlX2Z1bmNfY2FsbCA9IDBVTDsKIAluZXcgPSBmdHJhY2Vfam1w
X3JlcGxhY2UoaXAsICh1bnNpZ25lZCBsb25nKWZ1bmMpOwogCiAJcmV0dXJuIHVwZGF0ZV9mdHJh
Y2VfZnVuYyhpcCwgbmV3KTsKZGlmZiAtLWdpdCBhL2FyY2gveDg2L2tlcm5lbC90cmFwcy5jIGIv
YXJjaC94ODYva2VybmVsL3RyYXBzLmMKaW5kZXggZDI2ZjllOWMzZDgzLi5lODExZTU1YWIwMzAg
MTAwNjQ0Ci0tLSBhL2FyY2gveDg2L2tlcm5lbC90cmFwcy5jCisrKyBiL2FyY2gveDg2L2tlcm5l
bC90cmFwcy5jCkBAIC01NzAsNyArNTcwLDcgQEAgZG9fZ2VuZXJhbF9wcm90ZWN0aW9uKHN0cnVj
dCBwdF9yZWdzICpyZWdzLCBsb25nIGVycm9yX2NvZGUpCiB9CiBOT0tQUk9CRV9TWU1CT0woZG9f
Z2VuZXJhbF9wcm90ZWN0aW9uKTsKIAotZG90cmFwbGlua2FnZSB2b2lkIG5vdHJhY2UgZG9faW50
MyhzdHJ1Y3QgcHRfcmVncyAqcmVncywgbG9uZyBlcnJvcl9jb2RlKQorZG90cmFwbGlua2FnZSBz
dHJ1Y3QgcHRfcmVncyAqIG5vdHJhY2UgZG9fa2VybmVsX2ludDMoc3RydWN0IHB0X3JlZ3MgKnJl
Z3MsIGxvbmcgZXJyb3JfY29kZSkKIHsKICNpZmRlZiBDT05GSUdfRFlOQU1JQ19GVFJBQ0UKIAkv
KgpAQCAtNTc4LDExICs1NzgsMTEgQEAgZG90cmFwbGlua2FnZSB2b2lkIG5vdHJhY2UgZG9faW50
MyhzdHJ1Y3QgcHRfcmVncyAqcmVncywgbG9uZyBlcnJvcl9jb2RlKQogCSAqIFNlZSBub3RlIGJ5
IGRlY2xhcmF0aW9uIG9mIG1vZGlmeWluZ19mdHJhY2VfY29kZSBpbiBmdHJhY2UuYwogCSAqLwog
CWlmICh1bmxpa2VseShhdG9taWNfcmVhZCgmbW9kaWZ5aW5nX2Z0cmFjZV9jb2RlKSkgJiYKLQkg
ICAgZnRyYWNlX2ludDNfaGFuZGxlcihyZWdzKSkKLQkJcmV0dXJuOworCSAgICBmdHJhY2VfaW50
M19oYW5kbGVyKCZyZWdzKSkKKwkJcmV0dXJuIHJlZ3M7CiAjZW5kaWYKIAlpZiAocG9rZV9pbnQz
X2hhbmRsZXIocmVncykpCi0JCXJldHVybjsKKwkJcmV0dXJuIHJlZ3M7CiAKIAkvKgogCSAqIFVz
ZSBpc3RfZW50ZXIgZGVzcGl0ZSB0aGUgZmFjdCB0aGF0IHdlIGRvbid0IHVzZSBhbiBJU1Qgc3Rh
Y2suCkBAIC02MTQsNiArNjE0LDEzIEBAIGRvdHJhcGxpbmthZ2Ugdm9pZCBub3RyYWNlIGRvX2lu
dDMoc3RydWN0IHB0X3JlZ3MgKnJlZ3MsIGxvbmcgZXJyb3JfY29kZSkKIAogZXhpdDoKIAlpc3Rf
ZXhpdChyZWdzKTsKKwlyZXR1cm4gcmVnczsKK30KK05PS1BST0JFX1NZTUJPTChkb19rZXJuZWxf
aW50Myk7CisKK2RvdHJhcGxpbmthZ2Ugdm9pZCBub3RyYWNlIGRvX2ludDMoc3RydWN0IHB0X3Jl
Z3MgKnJlZ3MsIGxvbmcgZXJyb3JfY29kZSkKK3sKKwlXQVJOX09OX09OQ0UoZG9fa2VybmVsX2lu
dDMocmVncywgZXJyb3JfY29kZSkgIT0gcmVncyk7CiB9CiBOT0tQUk9CRV9TWU1CT0woZG9faW50
Myk7CiAK
--000000000000467f4205884d67ea--
