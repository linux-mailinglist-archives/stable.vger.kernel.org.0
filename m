Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E3D431AC27
	for <lists+stable@lfdr.de>; Sat, 13 Feb 2021 15:16:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhBMOOz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Feb 2021 09:14:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:43558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229896AbhBMONs (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 13 Feb 2021 09:13:48 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6115064E35;
        Sat, 13 Feb 2021 14:13:06 +0000 (UTC)
Date:   Sat, 13 Feb 2021 09:13:04 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Josh Poimboeuf <jpoimboe@redhat.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Xi Ruoyao <xry111@mengyan1223.wang>,
        "# 3.4.x" <stable@vger.kernel.org>,
        Arnd Bergmann <arnd@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Miroslav Benes <mbenes@suse.cz>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip: objtool/urgent] objtool: Fix seg fault with Clang
 non-section symbols
Message-ID: <20210213091304.2dd51e5f@oasis.local.home>
In-Reply-To: <YCfdfkoeh8i0baCj@kroah.com>
References: <ba6b6c0f0dd5acbba66e403955a967d9fdd1726a.1607983452.git.jpoimboe@redhat.com>
        <160812658044.3364.4188208281079332844.tip-bot2@tip-bot2>
        <dded80b60d9136ea90987516c28f93273385651f.camel@mengyan1223.wang>
        <YCU3Vdoqd+EI+zpv@kroah.com>
        <CAKwvOd=GHdkvAU3u6ROSgtGqC_wrkXo8siL1nZHE-qsqSx0gsw@mail.gmail.com>
        <YCafKVSTX9MxDBMd@kroah.com>
        <20210212170750.y7xtitigfqzpchqd@treble>
        <20210212124547.1dcf067e@gandalf.local.home>
        <YCfdfkoeh8i0baCj@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 13 Feb 2021 15:09:02 +0100
Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> Thanks for the patch, but no, still fails with:
> 
> Cannot find symbol for section 8: .text.unlikely.
> kernel/kexec_file.o: failed
> make[1]: *** [scripts/Makefile.build:277: kernel/kexec_file.o] Error 1
> make[1]: *** Deleting file 'kernel/kexec_file.o'

It was just a guess.

I guess I'll need to find some time next week to set up a VM with
binutils 2.36 (I just checked, and all my development machines have
2.35). Then I'll be able to try and debug it.

-- Steve
