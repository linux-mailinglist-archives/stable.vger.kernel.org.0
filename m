Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CE39631BB6A
	for <lists+stable@lfdr.de>; Mon, 15 Feb 2021 15:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbhBOOx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Feb 2021 09:53:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:34864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229907AbhBOOxu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Feb 2021 09:53:50 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98A9264D9F;
        Mon, 15 Feb 2021 14:53:08 +0000 (UTC)
Date:   Mon, 15 Feb 2021 09:53:07 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Josh Poimboeuf <jpoimboe@redhat.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
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
Message-ID: <20210215095307.6f5fb12f@gandalf.local.home>
In-Reply-To: <20210214155147.3owdimqv2lyhu6by@treble>
References: <dded80b60d9136ea90987516c28f93273385651f.camel@mengyan1223.wang>
        <YCU3Vdoqd+EI+zpv@kroah.com>
        <CAKwvOd=GHdkvAU3u6ROSgtGqC_wrkXo8siL1nZHE-qsqSx0gsw@mail.gmail.com>
        <YCafKVSTX9MxDBMd@kroah.com>
        <20210212170750.y7xtitigfqzpchqd@treble>
        <20210212124547.1dcf067e@gandalf.local.home>
        <YCfdfkoeh8i0baCj@kroah.com>
        <20210213091304.2dd51e5f@oasis.local.home>
        <20210213155203.lehuegwc3h42nebs@treble>
        <YCf9bnsmXqRGMn+j@kroah.com>
        <20210214155147.3owdimqv2lyhu6by@treble>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 14 Feb 2021 09:51:47 -0600
Josh Poimboeuf <jpoimboe@redhat.com> wrote:

> Steve, looks like recordmcount avoids referencing weak symbols directly
> by their function symbol.  Maybe it can just skip weak symbols which
> don't have a section symbol, since this seems like a rare scenario.

When does the .text.unlikely section disappear? During the creation of the
object, or later in the linker stage?

-- Steve
