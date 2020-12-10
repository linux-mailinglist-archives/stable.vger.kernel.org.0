Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A07542D5E01
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 15:37:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391005AbgLJOg0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 09:36:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:43664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390985AbgLJOgM (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:36:12 -0500
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 935CC23D9B;
        Thu, 10 Dec 2020 14:35:31 +0000 (UTC)
Date:   Thu, 10 Dec 2020 09:35:29 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Fix userstacktrace option for
 instances" failed to apply to 4.4-stable tree
Message-ID: <20201210093529.1bd8905c@gandalf.local.home>
In-Reply-To: <X9IZWcMVpAyBfTFQ@kroah.com>
References: <16075030712612@kroah.com>
        <20201209121938.50430114@gandalf.local.home>
        <X9IZWcMVpAyBfTFQ@kroah.com>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 10 Dec 2020 13:49:29 +0100
Greg KH <gregkh@linuxfoundation.org> wrote:

> On Wed, Dec 09, 2020 at 12:19:38PM -0500, Steven Rostedt wrote:
> > 
> > This should be the fix for 4.4.  
> 
> All now queued up, thanks for the backports.

My pleasure. This particular fix was needed for a tool I'm writing, and I'm
hoping it gets pulled into all the distro kernels as well.

-- Steve
