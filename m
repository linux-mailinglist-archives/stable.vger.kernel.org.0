Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A956C3005AB
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728836AbhAVOjF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:39:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:34176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728658AbhAVOil (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:38:41 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4927A23444;
        Fri, 22 Jan 2021 14:38:00 +0000 (UTC)
Date:   Fri, 22 Jan 2021 09:37:58 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Gaurav Kohli <gkohli@codeaurora.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Denis Efremov <efremov@linux.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        stable@vger.kernel.org, Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH v1] trace: Fix race in trace_open and buffer resize call
Message-ID: <20210122093758.320bb4f9@gandalf.local.home>
In-Reply-To: <8e17ad41-b62b-5d39-82ef-3ee6ea9f4278@codeaurora.org>
References: <1601976833-24377-1-git-send-email-gkohli@codeaurora.org>
        <f06efd7b-c7b5-85c9-1a0e-6bb865111ede@linux.com>
        <20210121140951.2a554a5e@gandalf.local.home>
        <021b1b38-47ce-bc8b-3867-99160cc85523@linux.com>
        <20210121153732.43d7b96b@gandalf.local.home>
        <YAqwD/ivTgVJ7aap@kroah.com>
        <8e17ad41-b62b-5d39-82ef-3ee6ea9f4278@codeaurora.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 22 Jan 2021 16:55:29 +0530
Gaurav Kohli <gkohli@codeaurora.org> wrote:

> >> That could possibly work.  
> 
> Yes, this will work, As i have tested similar patch for internal testing 
> for kernel branches like 5.4/4.19.

Can you or Denis send a proper patch for Greg to backport? I'll review it,
test it and give my ack to it, so Greg can take it without issue.

Thanks!

-- Steve


> 
> > 
> > Ok, so what can I do here?  Can someone resend this as a backport to the
> > other stable kernels in this way so that I can queue it up?
> > 
