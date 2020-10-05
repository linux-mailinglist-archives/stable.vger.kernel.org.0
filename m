Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38A9D283C8D
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 18:32:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729000AbgJEQcH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 12:32:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:44982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726991AbgJEQcH (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 12:32:07 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40DAF20756;
        Mon,  5 Oct 2020 16:32:06 +0000 (UTC)
Date:   Mon, 5 Oct 2020 12:32:04 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Gaurav Kohli <gkohli@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v1] trace: Fix race in trace_open and buffer resize call
Message-ID: <20201005123204.46a1cfc4@gandalf.local.home>
In-Reply-To: <6ebba9b9-0add-0313-3982-01031d946f44@codeaurora.org>
References: <1600955705-27382-1-git-send-email-gkohli@codeaurora.org>
        <71b8fe4c-7be2-fe51-cd84-890320c98cda@codeaurora.org>
        <20201005102515.07859ddf@gandalf.local.home>
        <20201005102745.2e49bc42@gandalf.local.home>
        <6ebba9b9-0add-0313-3982-01031d946f44@codeaurora.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 5 Oct 2020 21:59:02 +0530
Gaurav Kohli <gkohli@codeaurora.org> wrote:

> Hi Steven,
> 
> I am using normal git send-email(never saw problem with this), Not sure 
> what is wrong. In my older mail i have kept you in to and rest in cc.
> 
> Let me try to resent it.

The Cc is working (I got it in my LKML box), but I don't see any connection
in my server. Note, the rostedt@goodmis.org is a server at my home.

-- Steve
