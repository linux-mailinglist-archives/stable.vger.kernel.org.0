Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 81F0B301952
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 04:22:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726316AbhAXDWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jan 2021 22:22:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:33832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725943AbhAXDWa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 Jan 2021 22:22:30 -0500
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5142822D0A;
        Sun, 24 Jan 2021 03:21:49 +0000 (UTC)
Date:   Sat, 23 Jan 2021 22:21:47 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Gaurav Kohli <gkohli@codeaurora.org>
Cc:     Denis Efremov <efremov@linux.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        stable@vger.kernel.org, Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH v1] trace: Fix race in trace_open and buffer resize call
Message-ID: <20210123222147.1e2d5626@oasis.local.home>
In-Reply-To: <46d1f82b-1eb4-a828-c79c-e6556eccf9d5@codeaurora.org>
References: <1601976833-24377-1-git-send-email-gkohli@codeaurora.org>
        <f06efd7b-c7b5-85c9-1a0e-6bb865111ede@linux.com>
        <20210121140951.2a554a5e@gandalf.local.home>
        <021b1b38-47ce-bc8b-3867-99160cc85523@linux.com>
        <20210121153732.43d7b96b@gandalf.local.home>
        <YAqwD/ivTgVJ7aap@kroah.com>
        <8e17ad41-b62b-5d39-82ef-3ee6ea9f4278@codeaurora.org>
        <20210122093758.320bb4f9@gandalf.local.home>
        <5959315a-507a-00df-031a-e60d45c1f7ab@linux.com>
        <46d1f82b-1eb4-a828-c79c-e6556eccf9d5@codeaurora.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 23 Jan 2021 22:03:27 +0530
Gaurav Kohli <gkohli@codeaurora.org> wrote:


> Sure I will do, I have never posted on backport branches. Let me check 
> and post it.
> 

Basically you take your original patch that was in mainline (as the
subject and commit message), and make it work as if you were doing the
same exact fix for the stable release.

Send it to me (and Cc everyone else), and I'll give it a test too.

Thanks!

-- Steve

