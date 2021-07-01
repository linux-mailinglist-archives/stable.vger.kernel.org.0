Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CEAE3B9624
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 20:28:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229934AbhGASa3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 14:30:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:39856 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhGASa3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Jul 2021 14:30:29 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1BD916141F;
        Thu,  1 Jul 2021 18:27:58 +0000 (UTC)
Date:   Thu, 1 Jul 2021 14:27:56 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Paul Burton <paulburton@google.com>
Cc:     linux-kernel@vger.kernel.org, Ingo Molnar <mingo@redhat.com>,
        Joel Fernandes <joelaf@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 2/2] tracing: Resize tgid_map to pid_max, not
 PID_MAX_DEFAULT
Message-ID: <20210701142756.7432583b@oasis.local.home>
In-Reply-To: <YN4GSV8/AzK1fz4o@google.com>
References: <20210701095525.400839d3@oasis.local.home>
        <20210701172407.889626-1-paulburton@google.com>
        <20210701172407.889626-2-paulburton@google.com>
        <20210701141221.1d0b1fe0@oasis.local.home>
        <YN4GSV8/AzK1fz4o@google.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 1 Jul 2021 11:15:37 -0700
Paul Burton <paulburton@google.com> wrote:

> Yeah, sorry about that - I should know better having been a maintainer
> in a former life...

No problem.

> 
> Just to confirm - are you happy to fix those up when applying or should
> I send a v3?

I made the conversion and I'm going to start my testing now.

Joel, I never saw a reviewed-by from you for this patch.

Thanks!

-- Steve
