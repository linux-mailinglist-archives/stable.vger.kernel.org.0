Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 439C93B9289
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 15:55:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232076AbhGAN56 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Jul 2021 09:57:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231915AbhGAN56 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 1 Jul 2021 09:57:58 -0400
Received: from oasis.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 423CE61350;
        Thu,  1 Jul 2021 13:55:27 +0000 (UTC)
Date:   Thu, 1 Jul 2021 09:55:25 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joel Fernandes <joelaf@google.com>
Cc:     Paul Burton <paulburton@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing: Resize tgid_map to PID_MAX_LIMIT, not
 PID_MAX_DEFAULT
Message-ID: <20210701095525.400839d3@oasis.local.home>
In-Reply-To: <20210630191145.64f526b0@rorschach.local.home>
References: <20210630003406.4013668-1-paulburton@google.com>
        <20210630003406.4013668-2-paulburton@google.com>
        <20210630083513.1658a6fb@oasis.local.home>
        <YNzdllg/634Sa6Rt@google.com>
        <20210630173400.7963f619@oasis.local.home>
        <CAJWu+ooJzcTFBFPSqWE5oHe2_4Gt_GHXftcXutk5mm-UX_hUUA@mail.gmail.com>
        <20210630191145.64f526b0@rorschach.local.home>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 30 Jun 2021 19:11:45 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> On Wed, 30 Jun 2021 18:34:11 -0400
> Joel Fernandes <joelaf@google.com> wrote:
> 
> > > Anyway, I'll wait to hear what Joel says on this. If he thinks this is
> > > worth 16M of memory when enabled, I may take it.    
> > 
> > I am not a huge fan of the 16M, in Android we enable this feature on
> > all devices. Low end Android devices traced in the field are sometimes
> > 1 GB and the added memory pressure may be unwelcome. Very least, maybe
> > make it optional only for folks who increase pid_max?  
> 
> Yeah, can we just set it to the size of pid_max, at whatever it is set
> to?

Can you send a V2 with this update and address Joel's comments to patch 1,
and get it to me today? I plan on sending Linus a pull request
tomorrow, which means I have to kick off my tests tonight for what I
want to send.

-- Steve
