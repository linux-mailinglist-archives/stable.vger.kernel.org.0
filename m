Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D0962162E86
	for <lists+stable@lfdr.de>; Tue, 18 Feb 2020 19:28:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726439AbgBRS2o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Feb 2020 13:28:44 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:33906 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726225AbgBRS2o (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Feb 2020 13:28:44 -0500
Received: by mail-lj1-f196.google.com with SMTP id x7so24131056ljc.1
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 10:28:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+QhJ1rq4OwV2iGSlB588wtXJvujKNK9tlxfzQJwyHS8=;
        b=ejxkrareXzY6YTUjQpMNQmMbBAVxAeHZpnsjqRJOfVCFhXRJpBgATWPZbLfOiAxW/a
         th7vIR385GnvQUqIU39rpkayyQ2QV5OZ329vYyqfpQ0PO3TGv7Tsc77viMB/prpd/EN7
         mxfaTk+8rftAr7S1xcTb0hs67cWZ0/zooHpA0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+QhJ1rq4OwV2iGSlB588wtXJvujKNK9tlxfzQJwyHS8=;
        b=Uf8ytzZlg8xx37cD7nHvXpmESyok7whfU9t24BoSloc7ECjpj+Gh2LAsIls7luHd2J
         hrKovWPX/2viIj6OIf+qLo4fRG5k3Hh8Y1T+G7O6Yn2FaO+wwtRETMBL2sxYSDiZ1JnC
         VThFRM8zQxEyOlzAiuDjJAijfuU33lRw1PdnNkbMmR05GhMl4BKQTwlohUwB7ll2Kguq
         GEWWeDC5RSIOCxqqCbWRXAdxwthxalfdCFPraP3dF3FcL9N/c22JNkP73vbdLGZJHEgD
         yJlShlKQMrdImlVhBfYFvrnCCTrxrxS4aFyHMXD5M1HCAE71EL1jQXtMo0i1LFZc1xB6
         HUaw==
X-Gm-Message-State: APjAAAWwTs2ywBTAOV/FVyodpyTf2WvjyrV09cv7IWoGopF/4Nbl49EV
        46lo9M/T7WMrsA4BLMm9DHGv6iCY4bA=
X-Google-Smtp-Source: APXvYqwroLmxhdfIrA3qS4jH3UMK2N3B1h1UWrA/jcMHNqdjNossfzk/NNqMgNGaorzyFf/T+7J3YA==
X-Received: by 2002:a2e:9143:: with SMTP id q3mr12951898ljg.199.1582050521630;
        Tue, 18 Feb 2020 10:28:41 -0800 (PST)
Received: from mail-lf1-f42.google.com (mail-lf1-f42.google.com. [209.85.167.42])
        by smtp.gmail.com with ESMTPSA id p26sm2719663lfh.64.2020.02.18.10.28.39
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 Feb 2020 10:28:40 -0800 (PST)
Received: by mail-lf1-f42.google.com with SMTP id v201so15203253lfa.11
        for <stable@vger.kernel.org>; Tue, 18 Feb 2020 10:28:39 -0800 (PST)
X-Received: by 2002:a19:f514:: with SMTP id j20mr11229869lfb.31.1582050519448;
 Tue, 18 Feb 2020 10:28:39 -0800 (PST)
MIME-Version: 1.0
References: <20200214154854.6746-1-sashal@kernel.org> <20200214154854.6746-542-sashal@kernel.org>
 <CANaxB-zjYecWpjMoX6dXY3B5HtVu8+G9npRnaX2FnTvp9XucTw@mail.gmail.com>
 <CAHk-=wjd6BKXEpU0MfEaHuOEK-StRToEcYuu6NpVfR0tR5d6xw@mail.gmail.com>
 <CAHk-=wgs8E4JYVJHaRV2hMn3dxUnM8i0Kn2mA1SjzJdsbB9tXw@mail.gmail.com>
 <CAHk-=wiaDvYHBt8oyZGOp2XwJW4wNXVAchqTFuVBvASTFx_KfA@mail.gmail.com> <20200218182041.GB24185@bombadil.infradead.org>
In-Reply-To: <20200218182041.GB24185@bombadil.infradead.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue, 18 Feb 2020 10:28:23 -0800
X-Gmail-Original-Message-ID: <CAHk-=wi8Q8xtZt1iKcqSaV1demDnyixXT+GyDZi-Lk61K3+9rw@mail.gmail.com>
Message-ID: <CAHk-=wi8Q8xtZt1iKcqSaV1demDnyixXT+GyDZi-Lk61K3+9rw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.5 542/542] pipe: use exclusive waits when
 reading or writing
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Andrei Vagin <avagin@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Sasha Levin <sashal@kernel.org>,
        stable <stable@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: multipart/mixed; boundary="0000000000003aa18b059eddd731"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--0000000000003aa18b059eddd731
Content-Type: text/plain; charset="UTF-8"

On Tue, Feb 18, 2020 at 10:20 AM Matthew Wilcox <willy@infradead.org> wrote:
>
> You don't want to move wake_up_partner() up and call it from pipe_release()?

I was actually thinking of going the other way - two of three users of
wake_up_partner() are redundantly waking up the wrong side, and the
third user is pointlessly written too.

So I was _thinking_ of a patch like the appended (which is on top of
the previous patch), but ended up not doing it. Until you brought it
up.

But I won't bother committing this, since it shouldn't really matter.

                 Linus

--0000000000003aa18b059eddd731
Content-Type: text/x-patch; charset="US-ASCII"; name="patch.diff"
Content-Disposition: attachment; filename="patch.diff"
Content-Transfer-Encoding: base64
Content-ID: <f_k6s80fwq0>
X-Attachment-Id: f_k6s80fwq0

IGZzL3BpcGUuYyB8IDE4ICsrKysrKy0tLS0tLS0tLS0tLQogMSBmaWxlIGNoYW5nZWQsIDYgaW5z
ZXJ0aW9ucygrKSwgMTIgZGVsZXRpb25zKC0pCgpkaWZmIC0tZ2l0IGEvZnMvcGlwZS5jIGIvZnMv
cGlwZS5jCmluZGV4IDIxNDQ1MDc0NDdjNS4uNzliYTYxNDMwZjljIDEwMDY0NAotLS0gYS9mcy9w
aXBlLmMKKysrIGIvZnMvcGlwZS5jCkBAIC0xMDI1LDEyICsxMDI1LDYgQEAgc3RhdGljIGludCB3
YWl0X2Zvcl9wYXJ0bmVyKHN0cnVjdCBwaXBlX2lub2RlX2luZm8gKnBpcGUsIHVuc2lnbmVkIGlu
dCAqY250KQogCXJldHVybiBjdXIgPT0gKmNudCA/IC1FUkVTVEFSVFNZUyA6IDA7CiB9CiAKLXN0
YXRpYyB2b2lkIHdha2VfdXBfcGFydG5lcihzdHJ1Y3QgcGlwZV9pbm9kZV9pbmZvICpwaXBlKQot
ewotCXdha2VfdXBfaW50ZXJydXB0aWJsZV9hbGwoJnBpcGUtPnJkX3dhaXQpOwotCXdha2VfdXBf
aW50ZXJydXB0aWJsZV9hbGwoJnBpcGUtPndyX3dhaXQpOwotfQotCiBzdGF0aWMgaW50IGZpZm9f
b3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlscCkKIHsKIAlzdHJ1Y3Qg
cGlwZV9pbm9kZV9pbmZvICpwaXBlOwpAQCAtMTA3OCw3ICsxMDcyLDcgQEAgc3RhdGljIGludCBm
aWZvX29wZW4oc3RydWN0IGlub2RlICppbm9kZSwgc3RydWN0IGZpbGUgKmZpbHApCiAJICovCiAJ
CXBpcGUtPnJfY291bnRlcisrOwogCQlpZiAocGlwZS0+cmVhZGVycysrID09IDApCi0JCQl3YWtl
X3VwX3BhcnRuZXIocGlwZSk7CisJCQl3YWtlX3VwX2ludGVycnVwdGlibGVfYWxsKCZwaXBlLT53
cl93YWl0KTsKIAogCQlpZiAoIWlzX3BpcGUgJiYgIXBpcGUtPndyaXRlcnMpIHsKIAkJCWlmICgo
ZmlscC0+Zl9mbGFncyAmIE9fTk9OQkxPQ0spKSB7CkBAIC0xMTA0LDcgKzEwOTgsNyBAQCBzdGF0
aWMgaW50IGZpZm9fb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3QgZmlsZSAqZmlscCkK
IAogCQlwaXBlLT53X2NvdW50ZXIrKzsKIAkJaWYgKCFwaXBlLT53cml0ZXJzKyspCi0JCQl3YWtl
X3VwX3BhcnRuZXIocGlwZSk7CisJCQl3YWtlX3VwX2ludGVycnVwdGlibGVfYWxsKCZwaXBlLT5y
ZF93YWl0KTsKIAogCQlpZiAoIWlzX3BpcGUgJiYgIXBpcGUtPnJlYWRlcnMpIHsKIAkJCWlmICh3
YWl0X2Zvcl9wYXJ0bmVyKHBpcGUsICZwaXBlLT5yX2NvdW50ZXIpKQpAQCAtMTEyMCwxMiArMTEx
NCwxMiBAQCBzdGF0aWMgaW50IGZpZm9fb3BlbihzdHJ1Y3QgaW5vZGUgKmlub2RlLCBzdHJ1Y3Qg
ZmlsZSAqZmlscCkKIAkgKiAgdGhlIHByb2Nlc3MgY2FuIGF0IGxlYXN0IHRhbGsgdG8gaXRzZWxm
LgogCSAqLwogCi0JCXBpcGUtPnJlYWRlcnMrKzsKLQkJcGlwZS0+d3JpdGVycysrOworCQlpZiAo
cGlwZS0+cmVhZGVycysrID09IDApCisJCQl3YWtlX3VwX2ludGVycnVwdGlibGVfYWxsKCZwaXBl
LT53cl93YWl0KTsKKwkJaWYgKHBpcGUtPndyaXRlcnMrKyA9PSAwKQorCQkJd2FrZV91cF9pbnRl
cnJ1cHRpYmxlX2FsbCgmcGlwZS0+cmRfd2FpdCk7CiAJCXBpcGUtPnJfY291bnRlcisrOwogCQlw
aXBlLT53X2NvdW50ZXIrKzsKLQkJaWYgKHBpcGUtPnJlYWRlcnMgPT0gMSB8fCBwaXBlLT53cml0
ZXJzID09IDEpCi0JCQl3YWtlX3VwX3BhcnRuZXIocGlwZSk7CiAJCWJyZWFrOwogCiAJZGVmYXVs
dDoK
--0000000000003aa18b059eddd731--
