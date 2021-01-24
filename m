Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C6BD7301AFF
	for <lists+stable@lfdr.de>; Sun, 24 Jan 2021 11:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbhAXKFw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 24 Jan 2021 05:05:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:33506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726482AbhAXKFv (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 24 Jan 2021 05:05:51 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 053D0225A9;
        Sun, 24 Jan 2021 10:05:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611482710;
        bh=oN1qAJ16gf9zZdiZrwHZaHz1DTN37LlF4WI+ApSWK9I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vwRZxTQlhQAtWByFFiB46bDixXWndO08cP3tOGAe1hG6R2cEnhcKF7xtA4ZrKZs4K
         RZGQKzxw/gq5CTUlQzfPHZTy6sUWnAnC5VowLHxp+os0fbTmXbIoCJCyItIQGMckNQ
         FzWPKqTb2YZUu5855t1D84vOPq0Uuo6MuVu/tE+A=
Date:   Sun, 24 Jan 2021 11:05:07 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Gaurav Kohli <gkohli@codeaurora.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Denis Efremov <efremov@linux.com>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        stable@vger.kernel.org, Julia Lawall <julia.lawall@inria.fr>
Subject: Re: [PATCH v1] trace: Fix race in trace_open and buffer resize call
Message-ID: <YA1GU+xjL+zUDIjN@kroah.com>
References: <20210121140951.2a554a5e@gandalf.local.home>
 <021b1b38-47ce-bc8b-3867-99160cc85523@linux.com>
 <20210121153732.43d7b96b@gandalf.local.home>
 <YAqwD/ivTgVJ7aap@kroah.com>
 <8e17ad41-b62b-5d39-82ef-3ee6ea9f4278@codeaurora.org>
 <20210122093758.320bb4f9@gandalf.local.home>
 <5959315a-507a-00df-031a-e60d45c1f7ab@linux.com>
 <46d1f82b-1eb4-a828-c79c-e6556eccf9d5@codeaurora.org>
 <20210123222147.1e2d5626@oasis.local.home>
 <76f4c576-0b34-6c52-0a93-c1d863052a80@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <76f4c576-0b34-6c52-0a93-c1d863052a80@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 24, 2021 at 03:27:25PM +0530, Gaurav Kohli wrote:
> 
> 
> On 1/24/2021 8:51 AM, Steven Rostedt wrote:
> > On Sat, 23 Jan 2021 22:03:27 +0530
> > Gaurav Kohli <gkohli@codeaurora.org> wrote:
> > 
> > 
> > > Sure I will do, I have never posted on backport branches. Let me check
> > > and post it.
> > > 
> > 
> > Basically you take your original patch that was in mainline (as the
> > subject and commit message), and make it work as if you were doing the
> > same exact fix for the stable release.
> > 
> > Send it to me (and Cc everyone else), and I'll give it a test too.
> 
> Thanks for the guidance.
> Just sent and tested it for 5.4 kernel, please review it once.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
