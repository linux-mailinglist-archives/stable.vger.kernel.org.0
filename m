Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C02DE3EED91
	for <lists+stable@lfdr.de>; Tue, 17 Aug 2021 15:41:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239873AbhHQNiw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Aug 2021 09:38:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236613AbhHQNhr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Aug 2021 09:37:47 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E09860E09;
        Tue, 17 Aug 2021 13:37:13 +0000 (UTC)
Date:   Tue, 17 Aug 2021 09:37:11 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Miroslav Benes <mbenes@suse.cz>
Cc:     Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Ingo Molnar <mingo@redhat.com>,
        Josh Poimboeuf <jpoimboe@redhat.com>,
        Jiri Kosina <jikos@kernel.org>, live-patching@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] tracing: define needed config DYNAMIC_FTRACE_WITH_ARGS
Message-ID: <20210817093711.192116ce@oasis.local.home>
In-Reply-To: <alpine.LSU.2.21.2108171126040.26111@pobox.suse.cz>
References: <20210806195027.16808-1-lukas.bulwahn@gmail.com>
        <20210806211808.6d927880@oasis.local.home>
        <alpine.LSU.2.21.2108171126040.26111@pobox.suse.cz>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 17 Aug 2021 11:28:25 +0200 (CEST)
Miroslav Benes <mbenes@suse.cz> wrote:

> > I placed it in my queue to go into the 5.14-rc cycle.
> > 
> > Since this affects live kernel patching, can I get a Tested-by from one
> > of the live kernel patching  folks?  
> 
> I see it got merged, but anyway it looks good to me. Thanks for fixing it.

Ah, I was going to wait for an ack, but it slipped into my push (I was
going to take it out, but forgot to).

Anyway, thanks for looking at it.

-- Steve
