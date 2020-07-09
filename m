Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DEB821A795
	for <lists+stable@lfdr.de>; Thu,  9 Jul 2020 21:12:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgGITMj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jul 2020 15:12:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726193AbgGITMj (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jul 2020 15:12:39 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2550C08C5DC
        for <stable@vger.kernel.org>; Thu,  9 Jul 2020 12:12:38 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id c11so1808562lfh.8
        for <stable@vger.kernel.org>; Thu, 09 Jul 2020 12:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=MUXt+VaotMhfJOd6E9mEicpXY5WrC4/+FNcOPjlj6ss=;
        b=S5oSqZW1A4t7CU5Ud+a9tiBkoj4BM6Sb6vMvdJv3Exg0n0rEmbYvLoimbCBwZjSiZf
         ulX3gUvqC5I6VLONpTNqv63W33nX+dqOm728Rx2Ga/A0F2iuJeXZeKYi75E/67UrmbHZ
         sGKbdD7B2JCya4oDSFY2vxM6TwJonF4IFsbKg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=MUXt+VaotMhfJOd6E9mEicpXY5WrC4/+FNcOPjlj6ss=;
        b=YUPDw2Zc3g2d/zMbMb668XKZ4RAd6zTFCv6ZXflQ1gCDqdLt8OA8ObL8EWWRPaD2oI
         oG/WQ4Gn+f9pJJQHFTO/c/5bgoGfGc4fwo8+Bj2F+rjofvU57M78EhVQAszjNetYFiQt
         DeCviY9xKCJCtCYU/Ta9r1Qv0HosML934TXuvxZnI2k7odGF3MB3VG5dziglG5EjP3QM
         B9VZ2qLLThtXawIyGuGCKOk9rCY6mspW1oJqj1dEPG553x9ryaB2A/srHXNLbbmfqb/m
         sbnDecXrCRE76H3Mo7YKZCZN3NrM00APX0lIPemPeK0LBw0d9vqkotA0fxSEiYygeggq
         DHcg==
X-Gm-Message-State: AOAM530CAsm+dYORjPu8qZCwAGQgjW2f/TQa68k1qMWcIuI/c3znCi54
        eazceWjKgbli+hebcFE2PW1v3G32W9Y=
X-Google-Smtp-Source: ABdhPJyPGh3sv6mM4vaZYcoBR6v0nMxNxGA4Cs3JPfQQTTN9tnGIAF00hCXdoBAREebmqW6XvrANhg==
X-Received: by 2002:a19:8a07:: with SMTP id m7mr40618660lfd.31.1594321957294;
        Thu, 09 Jul 2020 12:12:37 -0700 (PDT)
Received: from mail-lj1-f174.google.com (mail-lj1-f174.google.com. [209.85.208.174])
        by smtp.gmail.com with ESMTPSA id a16sm1513586ljj.108.2020.07.09.12.12.36
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 12:12:37 -0700 (PDT)
Received: by mail-lj1-f174.google.com with SMTP id q4so3694134lji.2
        for <stable@vger.kernel.org>; Thu, 09 Jul 2020 12:12:36 -0700 (PDT)
X-Received: by 2002:a2e:991:: with SMTP id 139mr36799176ljj.314.1594321956136;
 Thu, 09 Jul 2020 12:12:36 -0700 (PDT)
MIME-Version: 1.0
References: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
In-Reply-To: <CA+G9fYt+6OeibZMD0fP=O3nqFbcN3O4xcLkjq0mpQbZJ2uxB9w@mail.gmail.com>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Thu, 9 Jul 2020 12:12:19 -0700
X-Gmail-Original-Message-ID: <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
Message-ID: <CAHk-=wgRcFSnQt=T95S+1dPkyvCuVAVGQ37JDvRg41h8hRqO3Q@mail.gmail.com>
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
        Brian Geffon <bgeffon@google.com>, anshuman.khandual@arm.com,
        Will Deacon <will@kernel.org>,
        Catalin Marinas <catalin.marinas@arm.com>, pugaowei@gmail.com,
        Jerome Glisse <jglisse@redhat.com>,
        Joel Fernandes <joel@joelfernandes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mel Gorman <mgorman@techsingularity.net>,
        Hugh Dickins <hughd@google.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Content-Type: multipart/mixed; boundary="000000000000daa8dc05aa070182"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

--000000000000daa8dc05aa070182
Content-Type: text/plain; charset="UTF-8"

On Wed, Jul 8, 2020 at 10:28 PM Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:
>
> While running LTP mm test suite on i386 or qemu_i386 this kernel warning
> has been noticed from stable 5.4 to stable 5.7 branches and mainline 5.8.0-rc4
> and linux next.

Hmm

If this is repeatable, would you mind making the warning also print
out the old range and new addresses and pmd value?

Something like the attached (UNTESTED!) patch.

         Linus

--000000000000daa8dc05aa070182
Content-Type: application/octet-stream; name=patch
Content-Disposition: attachment; filename=patch
Content-Transfer-Encoding: base64
Content-ID: <f_kcf6480o0>
X-Attachment-Id: f_kcf6480o0

IG1tL21yZW1hcC5jIHwgNCArKystCiAxIGZpbGUgY2hhbmdlZCwgMyBpbnNlcnRpb25zKCspLCAx
IGRlbGV0aW9uKC0pCgpkaWZmIC0tZ2l0IGEvbW0vbXJlbWFwLmMgYi9tbS9tcmVtYXAuYwppbmRl
eCA1ZGQ1NzJkNTdjYTkuLmIzZjA3M2NmMjgwNiAxMDA2NDQKLS0tIGEvbW0vbXJlbWFwLmMKKysr
IGIvbW0vbXJlbWFwLmMKQEAgLTIwOCw4ICsyMDgsMTAgQEAgc3RhdGljIGJvb2wgbW92ZV9ub3Jt
YWxfcG1kKHN0cnVjdCB2bV9hcmVhX3N0cnVjdCAqdm1hLCB1bnNpZ25lZCBsb25nIG9sZF9hZGRy
LAogCSAqIFRoZSBkZXN0aW5hdGlvbiBwbWQgc2hvdWxkbid0IGJlIGVzdGFibGlzaGVkLCBmcmVl
X3BndGFibGVzKCkKIAkgKiBzaG91bGQgaGF2ZSByZWxlYXNlIGl0LgogCSAqLwotCWlmIChXQVJO
X09OKCFwbWRfbm9uZSgqbmV3X3BtZCkpKQorCWlmIChXQVJOX09OKCFwbWRfbm9uZSgqbmV3X3Bt
ZCkpKSB7CisJCXByaW50aygiIG9sZDogJWx4LSVseCBuZXc6ICVseCAodmFsOiAlbHgpXG4iLCBv
bGRfYWRkciwgb2xkX2VuZCwgbmV3X2FkZHIsIHBtZF92YWwoKm5ld19wbWQpKTsKIAkJcmV0dXJu
IGZhbHNlOworCX0KIAogCS8qCiAJICogV2UgZG9uJ3QgaGF2ZSB0byB3b3JyeSBhYm91dCB0aGUg
b3JkZXJpbmcgb2Ygc3JjIGFuZCBkc3QK
--000000000000daa8dc05aa070182--
