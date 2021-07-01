Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46A123B961F
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 20:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbhGAS26 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 14:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:39532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230014AbhGAS25 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Jul 2021 14:28:57 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6526761402;
        Thu,  1 Jul 2021 18:26:26 +0000 (UTC)
Date:   Thu, 1 Jul 2021 14:26:24 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Paul Burton <paulburton@google.com>
Cc:     Joel Fernandes <joelaf@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH 1/2] tracing: Simplify & fix saved_tgids logic
Message-ID: <20210701142624.44bb4dde@oasis.local.home>
In-Reply-To: <YN4Fpl+dhijItkUP@google.com>
References: <20210630003406.4013668-1-paulburton@google.com>
        <CAJWu+ooRQ6hFtaA4tr3BNs9Btss1yan8taua=VMWMopGmEVhSA@mail.gmail.com>
        <YN38D3dg0fLzL0Ia@google.com>
        <20210701140754.5847a50f@oasis.local.home>
        <YN4Fpl+dhijItkUP@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Added Joe Perches ]

On Thu, 1 Jul 2021 11:12:54 -0700
Paul Burton <paulburton@google.com> wrote:

> > not to mention, we don't
> > use '//' comments in the kernel, so that would have to be changed.  
> 
> D'oh! Apparently a year away from the kernel melted my internal style
> checker. Interestingly though, checkpatch didn't complain about this as
> I would have expected...

Joe, should the above be added to checkpatch?

I do understand that there are a few cases it's acceptable. Like for
SPDX headers.

-- Steve
