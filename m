Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5DE3A5B42
	for <lists+stable@lfdr.de>; Mon, 14 Jun 2021 03:03:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232230AbhFNBFm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 13 Jun 2021 21:05:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:59284 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232212AbhFNBFl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 13 Jun 2021 21:05:41 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 93D6861059;
        Mon, 14 Jun 2021 01:03:38 +0000 (UTC)
Date:   Sun, 13 Jun 2021 21:03:36 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     liangyan.peng@linux.alibaba.com, jnwang@linux.alibaba.com,
        mingo@redhat.com, wetp.zy@linux.alibaba.com,
        xlpang@linux.alibaba.com, yinbinbin@alibabacloud.com,
        <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Correct the length check which
 causes memory" failed to apply to 5.10-stable tree
Message-ID: <20210613210336.25574811@rorschach.local.home>
In-Reply-To: <20210613205118.0848b3dc@rorschach.local.home>
References: <162358538716087@kroah.com>
        <20210613205118.0848b3dc@rorschach.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 13 Jun 2021 20:51:18 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> The below works for 4.9 through 5.10. But will not work for 4.4.

And that's because the fix isn't applicable for 4.4 (saw another FAILED
patch for 4.4, but it wasn't this one.) So this should apply to all the
applicable backports.

-- Steve
