Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7679FD631E
	for <lists+stable@lfdr.de>; Mon, 14 Oct 2019 14:54:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730093AbfJNMya (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 08:54:30 -0400
Received: from mail-pl1-f196.google.com ([209.85.214.196]:32867 "EHLO
        mail-pl1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729864AbfJNMya (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Oct 2019 08:54:30 -0400
Received: by mail-pl1-f196.google.com with SMTP id d22so8007892pls.0
        for <stable@vger.kernel.org>; Mon, 14 Oct 2019 05:54:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=AIhgUFkta4ADnQDSmvlPHrNje3bhbPDGxBtEgxWVXJ4=;
        b=sxwPvAowp55am1warIq3F48oJqsrU47tvCrWx99u5OCXnnudf0lSNLfcn8g9cnMY43
         YRAsstvO2ge3Zoku7PrcvqsyT6FoYDqqq+8i0lR6CdGnz4vi552ZkuSwiy17HR0k6LIi
         rZbCJX8o9ZJWPHr6KaBZzrNpH4gUEmvFZqGs5s26fNl1yHTkiFJgWoOsQXYfC7b0RAi1
         ItYw/4Bg7aw9CHF1fs7i+jgClpq1ynsOv2Rpb9+tRKo7DU/NmUIBCJDCGqxIRtae34bS
         xOQsJOGygp2y+M1HuzGpmMYIdL5mDDR61T70S1RIiJ7cNTMDWpGj2cxcRoE3h6eNA7Dq
         n5BA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=AIhgUFkta4ADnQDSmvlPHrNje3bhbPDGxBtEgxWVXJ4=;
        b=f3BN6kRLVFHN38LYkRpC1tmt7nGaPb8TWQWywgsicjWWoDM1jKuqVen5J9sEbkoZ37
         JGpl9jGZ6eFjLeyxGOnN9yaHlut4tzyTtu4ZrwVkLwZztepJFAD04X2V7bS37a8CgTTp
         22WdRLcgiQjlCtlr6ja2qBRvfx46om53WAM3rGADkVx/DCqC8F+wUN+hdSmyJWmKnl2p
         oACtqHBJpwq1C1qA53aLmAROO6jyXtagbx0Toq5k7uizWd+u9YxXGZFUt8oA1CGEgQzy
         y7EdUqvTY1SvaE9lcI40PqMrRr0O2R9YT63Grx/U4KuiIEPljKciiydD3MSmZfjVqoxy
         +5Cw==
X-Gm-Message-State: APjAAAUuM2+sg/zgy1QDWEryrgV0zMUkJxo1ImDXdegbuXfvMPPgKtoJ
        o6156c2PzgvI+jP8hDBJYMUj45MuSGNsOIAAwdnqJw==
X-Google-Smtp-Source: APXvYqzGH5R8369OycOOW9pCLKOSpI+swxKckLy78dNGz6hwNIT7AnhJQz0aQRY13rkng04HpMzQeIt3eFMvu6qNTPI=
X-Received: by 2002:a17:902:9696:: with SMTP id n22mr28004924plp.252.1571057669076;
 Mon, 14 Oct 2019 05:54:29 -0700 (PDT)
MIME-Version: 1.0
References: <cki.B4A567748F.PFM8G4WKXI@redhat.com> <805988176.6044584.1571038139105.JavaMail.zimbra@redhat.com>
In-Reply-To: <805988176.6044584.1571038139105.JavaMail.zimbra@redhat.com>
From:   Andrey Konovalov <andreyknvl@google.com>
Date:   Mon, 14 Oct 2019 14:54:17 +0200
Message-ID: <CAAeHK+zxFWvCOgTYrMuD-oHJAFMn5DVYmQ6-RvU8NrapSz01mQ@mail.gmail.com>
Subject: =?UTF-8?B?UmU6IOKdjCBGQUlMOiBUZXN0IHJlcG9ydCBmb3Iga2VybmVsIDUuNC4wLXJjMi1kNmMyYw==?=
        =?UTF-8?B?MjMuY2tpIChzdGFibGUtbmV4dCk=?=
To:     Jan Stancek <jstancek@redhat.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc:     CKI Project <cki-project@redhat.com>,
        LTP List <ltp@lists.linux.it>,
        Linux Stable maillist <stable@vger.kernel.org>,
        Memory Management <mm-qe@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 9:29 AM Jan Stancek <jstancek@redhat.com> wrote:
>
>
>
> ----- Original Message -----
> >
> > Hello,
> >
> > We ran automated tests on a recent commit from this kernel tree:
> >
> >        Kernel repo:
> >        git://git.kernel.org/pub/scm/linux/kernel/git/sashal/linux-stabl=
e.git
> >             Commit: d6c2c23a29f4 - Merge branch 'stable-next' of
> >             ssh://chubbybox:/home/sasha/data/next into stable-next
> >
> > The results of these automated tests are provided below.
> >
> >     Overall result: FAILED (see details below)
> >              Merge: OK
> >            Compile: OK
> >              Tests: FAILED
> >
> > All kernel binaries, config files, and logs are available for download =
here:
> >
> >   https://artifacts.cki-project.org/pipelines/223563
> >
> > One or more kernel tests failed:
> >
> >     aarch64:
> >       =E2=9D=8C LTP: openposix test suite
> >
>
> Test [1] is passing value close to LONG_MAX, which on arm64 is now treate=
d as tagged userspace ptr:
>   057d3389108e ("mm: untag user pointers passed to memory syscalls")
>
> And now seems to hit overflow check after sign extension (EINVAL).
> Test should probably find different way to choose invalid pointer.
>
> [1] https://github.com/linux-test-project/ltp/blob/master/testcases/open_=
posix_testsuite/conformance/interfaces/mlock/8-1.c

+Catalin and Vincenzo

Per Documentation/arm64/tagged-address-abi.rst we now have:

User addresses not accessed by the kernel but used for address space
management (e.g. ``mmap()``, ``mprotect()``, ``madvise()``). The use
of valid tagged pointers in this context is always allowed.

However this breaks the test above.

What do you think we should do here?
