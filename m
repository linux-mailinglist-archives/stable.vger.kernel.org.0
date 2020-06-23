Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E8E1205371
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 15:30:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732624AbgFWNan (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 09:30:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:50380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732594AbgFWNan (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 09:30:43 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B144B20707;
        Tue, 23 Jun 2020 13:30:41 +0000 (UTC)
Date:   Tue, 23 Jun 2020 09:30:40 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, mhiramat@kernel.org,
        anders.roxell@linaro.org, anil.s.keshavamurthy@intel.com,
        davem@davemloft.net, gustavoars@kernel.org, mingo@elte.hu,
        mingo@kernel.org, naveen.n.rao@linux.ibm.com, peterz@infradead.org,
        zsun@redhat.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] kprobes: Fix to protect
 kick_kprobe_optimizer() by" failed to apply to 4.9-stable tree
Message-ID: <20200623093040.1390fd31@oasis.local.home>
In-Reply-To: <20200623132628.GX1931@sasha-vm>
References: <159291344624382@kroah.com>
        <20200623132628.GX1931@sasha-vm>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 23 Jun 2020 09:26:28 -0400
Sasha Levin <sashal@kernel.org> wrote:

> The conflict happened because we don't have 2d1e38f56622 ("kprobes: Cure
> hotplug lock ordering issues") on 4.9 and 4.4. I've fixed it up and
> queued for both branches.

Thanks Sasha!

-- Steve
