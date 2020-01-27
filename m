Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63ECC14AA95
	for <lists+stable@lfdr.de>; Mon, 27 Jan 2020 20:36:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726054AbgA0Tg1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jan 2020 14:36:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:54616 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725990AbgA0Tg0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Jan 2020 14:36:26 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C4DEE2467F;
        Mon, 27 Jan 2020 19:36:25 +0000 (UTC)
Date:   Mon, 27 Jan 2020 14:36:24 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Tom Zanussi <zanussi@kernel.org>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Fix histogram code when
 expression has same var as" failed to apply to 4.19-stable tree
Message-ID: <20200127143624.78121b64@gandalf.local.home>
In-Reply-To: <1580152768.2442.2.camel@kernel.org>
References: <15801394743854@kroah.com>
        <1580150181.5072.5.camel@kernel.org>
        <20200127135147.5c1ae6d1@gandalf.local.home>
        <1580152768.2442.2.camel@kernel.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 27 Jan 2020 13:19:28 -0600
Tom Zanussi <zanussi@kernel.org> wrote:

> It does fix the issue for me and passes the selftests.  Remember that
> 4.19 doesn't have the .trace() hist action - you need to use the event
> name e.g. .first()

Yeah I did that, but it was still clearing out the start variable when
I tried. I'll test the full commits next, right after I fix my git repo
that got corrupted because it had an alternative based on a repo that
rebased :-(

-- Steve
