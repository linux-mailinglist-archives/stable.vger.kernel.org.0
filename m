Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 05C239D37A
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 17:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729287AbfHZP4z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 11:56:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:60092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727864AbfHZP4z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Aug 2019 11:56:55 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 899FD20828;
        Mon, 26 Aug 2019 15:56:53 +0000 (UTC)
Date:   Mon, 26 Aug 2019 11:56:51 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     Peter Zijlstra <peterz@infradead.org>,
        Song Liu <songliubraving@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: Re: [PATCH] x86/mm: Do not split_large_page() for
 set_kernel_text_rw()
Message-ID: <20190826115651.43c9bde3@gandalf.local.home>
In-Reply-To: <31AB5512-F083-4DC3-BA73-D5D65CBC410A@vmware.com>
References: <20190823052335.572133-1-songliubraving@fb.com>
        <20190823093637.GH2369@hirez.programming.kicks-ass.net>
        <20190826073308.6e82589d@gandalf.local.home>
        <31AB5512-F083-4DC3-BA73-D5D65CBC410A@vmware.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 26 Aug 2019 15:41:24 +0000
Nadav Amit <namit@vmware.com> wrote:

> > Anyway, I believe Nadav has some patches that converts ftrace to use
> > the shadow page modification trick somewhere.  
> 
> For the record - here is my previous patch:
> https://lkml.org/lkml/2018/12/5/211

FYI, when referencing older patches, please use lkml.kernel.org or
lore.kernel.org, lkml.org is slow and obsolete.

ie. http://lkml.kernel.org/r/20181205013408.47725-9-namit@vmware.com

-- Steve
