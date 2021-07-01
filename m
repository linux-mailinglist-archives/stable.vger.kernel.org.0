Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BFD23B96C3
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 21:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbhGATxe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 15:53:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:49922 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhGATxe (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Jul 2021 15:53:34 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8DDF360FF2;
        Thu,  1 Jul 2021 19:51:02 +0000 (UTC)
Date:   Thu, 1 Jul 2021 15:51:00 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joe Perches <joe@perches.com>
Cc:     Paul Burton <paulburton@google.com>,
        Joel Fernandes <joelaf@google.com>,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/2] tracing: Simplify & fix saved_tgids logic
Message-ID: <20210701155100.3f29ddfb@oasis.local.home>
In-Reply-To: <51babd56c2fe53ba011152700a546151@perches.com>
References: <20210630003406.4013668-1-paulburton@google.com>
        <CAJWu+ooRQ6hFtaA4tr3BNs9Btss1yan8taua=VMWMopGmEVhSA@mail.gmail.com>
        <YN38D3dg0fLzL0Ia@google.com>
        <20210701140754.5847a50f@oasis.local.home>
        <YN4Fpl+dhijItkUP@google.com>
        <20210701142624.44bb4dde@oasis.local.home>
        <51babd56c2fe53ba011152700a546151@perches.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 01 Jul 2021 12:35:29 -0700
Joe Perches <joe@perches.com> wrote:

> C99 comments are allowed since about 5 years ago.

Really, I thought Linus hated them. Personally, I find them rather ugly
myself. The only user of them I see in the kernel/ directory appears to
be for RCU. But Paul's on the C/C++ committee, so perhaps he favors them.

The net/ directory doesn't have any, except perhaps to comment out code
(which I sometimes use it for that too).

The block/, arch/x86/ directories don't have them either.

I wouldn't go and change checkpatch, but I still rather avoid them,
especially for multi line comments.

 /*
  * When it comes to multi line comments I prefer using something
  * that denotes a start and an end to the comment, as it makes it
  * look like a nice clip of information.
  */

Instead of:

  // When it comes to multi line comments I prefer using something
  // that denotes a start and an end to the comment, as it makes it
  // look like a nice clip of information.

Which just looks like noise. But hey, maybe that's just me because I
find "*" as a sign of information and '//' something to ignore. ;-)

-- Steve
