Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1F75249DDC
	for <lists+stable@lfdr.de>; Wed, 19 Aug 2020 14:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726798AbgHSMaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Aug 2020 08:30:55 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:33571 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726794AbgHSMay (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Aug 2020 08:30:54 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 4ABD39E7;
        Wed, 19 Aug 2020 08:30:52 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 19 Aug 2020 08:30:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=IgeXLGe8cKlDFzKuL46wSUmqJJE
        h9VXmyd03EfjTTBI=; b=cqpa5AHuZiUrzSszQs7Mu7HD35CQZv1Zz0+IZhiHeac
        p3/NWEwN3gVl42hJFLRPzq5USIMfvb1X/THnhuy1kh+bB6MuZfiAajURokJdyzMU
        Erzjkn5IkMkWH+Kp3QTs03QH8bSHXGJaCMDo7gqV2Zya0eh4Uy4BRAWSyhGlbR1y
        9pUsM/AsalDda+HaKBPPi/z3xjVtqJPuJxwI8L6wR541RpqVRGWOMdLP9EG4NhLH
        5COtXl4Zr8sIvx5Y/Dmi4XZGjS4d6H8UNEq5gDN4Frk2LAtNxI2paCQKCHwHyoWY
        jid1fUDPclt7LjHIyNETdSteS7DLpVDiMXTpJvt4zmQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=IgeXLG
        e8cKlDFzKuL46wSUmqJJEh9VXmyd03EfjTTBI=; b=d4hFPAiDCCKmx2tvcCRznM
        +oIoE89uur/AklRJzcS6ea8OVIiR9nrL6x4NuSrlWkhOsqMtnJX/7ZvdHqjN5RxO
        SGgiIiTHF1cT1lhW5u3QBMSiggNeHVR8IeWuBybOpwbUs5DhEfF0aFxZ1xAmFnNs
        Bz9gUvdFfpQE076jM1OFM5FdHLZpWeYLZlDpitVKg+dPolGwWIUrMyAB7YbaiI+e
        MVuxZYnk/tjrkO9g9Vx3ZehqbaJS9evUU7aPwndiqVRs4JdOSd0RJ2WDP9j8OI41
        3mjhqRZsEuXI5pBaEbeWXpo5w10xmdVNpilyGGQ1uhZydmCbtolAvJmCf69Cxjtw
        ==
X-ME-Sender: <xms:exs9Xx9VwpNdbB4ddMjk24D13uMV8w1LrTOMW0h68CWN6UBrmOsfUQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedruddtkedgfeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:exs9X1s0wiQ3fdytMXRo5Wtl-GdKGCrsL43htyN_CQoMTBVowm3AgQ>
    <xmx:exs9X_Bk_kYxgNqS0uAx81XaxPLL2Ty-s4LSEBKMsEtHMfTqzTtorQ>
    <xmx:exs9X1cGJDusyHJ0zYcXi2zePUuCgWzqKijeqIDtIXFZ57kBVZO_Qg>
    <xmx:exs9X5Z3eOF35KUkBiIfFrERBFwYz6iroVD5YGzeConH5SSaCcfgrA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 3CBC83280063;
        Wed, 19 Aug 2020 08:30:51 -0400 (EDT)
Date:   Wed, 19 Aug 2020 14:31:14 +0200
From:   Greg KH <greg@kroah.com>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     dann frazier <dann.frazier@canonical.com>, stable@vger.kernel.org
Subject: Re: [PATCH 5.4] tracing: Move pipe reference to trace array instead
 of current_tracer
Message-ID: <20200819123114.GA964875@kroah.com>
References: <20200812205322.229101-1-dann.frazier@canonical.com>
 <20200812165936.39e2203f@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200812165936.39e2203f@oasis.local.home>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 12, 2020 at 04:59:36PM -0400, Steven Rostedt wrote:
> On Wed, 12 Aug 2020 14:53:22 -0600
> dann frazier <dann.frazier@canonical.com> wrote:
> 
> > From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>
> > 
> > commit 7ef282e05132d56b6f6b71e3873f317664bea78b upstream
> > 
> > If a process has the trace_pipe open on a trace_array, the current tracer
> > for that trace array should not be changed. This was original enforced by a
> > global lock, but when instances were introduced, it was moved to the
> > current_trace. But this structure is shared by all instances, and a
> > trace_pipe is for a single instance. There's no reason that a process that
> > has trace_pipe open on one instance should prevent another instance from
> > changing its current tracer. Move the reference counter to the trace_array
> > instead.
> > 
> > This is marked as "Fixes" but is more of a clean up than a true fix.
> > Backport if you want, but its not critical.
> > 
> 
> A note to stable maintainers. I originally thought this was just a
> clean up, but it was then found that it actually does fix a bug.
> (See below)

Now queued up, thanks!

greg k-h
