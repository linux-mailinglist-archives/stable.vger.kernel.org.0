Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 767ED3B8ACE
	for <lists+stable@lfdr.de>; Thu,  1 Jul 2021 01:11:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231414AbhF3XOR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 19:14:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:35638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229540AbhF3XOR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 30 Jun 2021 19:14:17 -0400
Received: from rorschach.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23F1761454;
        Wed, 30 Jun 2021 23:11:47 +0000 (UTC)
Date:   Wed, 30 Jun 2021 19:11:45 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Joel Fernandes <joelaf@google.com>
Cc:     Paul Burton <paulburton@google.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@redhat.com>, stable@vger.kernel.org
Subject: Re: [PATCH 2/2] tracing: Resize tgid_map to PID_MAX_LIMIT, not
 PID_MAX_DEFAULT
Message-ID: <20210630191145.64f526b0@rorschach.local.home>
In-Reply-To: <CAJWu+ooJzcTFBFPSqWE5oHe2_4Gt_GHXftcXutk5mm-UX_hUUA@mail.gmail.com>
References: <20210630003406.4013668-1-paulburton@google.com>
        <20210630003406.4013668-2-paulburton@google.com>
        <20210630083513.1658a6fb@oasis.local.home>
        <YNzdllg/634Sa6Rt@google.com>
        <20210630173400.7963f619@oasis.local.home>
        <CAJWu+ooJzcTFBFPSqWE5oHe2_4Gt_GHXftcXutk5mm-UX_hUUA@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 30 Jun 2021 18:34:11 -0400
Joel Fernandes <joelaf@google.com> wrote:

> > Anyway, I'll wait to hear what Joel says on this. If he thinks this is
> > worth 16M of memory when enabled, I may take it.  
> 
> I am not a huge fan of the 16M, in Android we enable this feature on
> all devices. Low end Android devices traced in the field are sometimes
> 1 GB and the added memory pressure may be unwelcome. Very least, maybe
> make it optional only for folks who increase pid_max?

Yeah, can we just set it to the size of pid_max, at whatever it is set
to?

-- Steve
