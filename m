Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 773822837A8
	for <lists+stable@lfdr.de>; Mon,  5 Oct 2020 16:25:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726003AbgJEOZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Oct 2020 10:25:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:39992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725903AbgJEOZS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Oct 2020 10:25:18 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7E46020757;
        Mon,  5 Oct 2020 14:25:17 +0000 (UTC)
Date:   Mon, 5 Oct 2020 10:25:15 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Gaurav Kohli <gkohli@codeaurora.org>
Cc:     linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v1] trace: Fix race in trace_open and buffer resize call
Message-ID: <20201005102515.07859ddf@gandalf.local.home>
In-Reply-To: <71b8fe4c-7be2-fe51-cd84-890320c98cda@codeaurora.org>
References: <1600955705-27382-1-git-send-email-gkohli@codeaurora.org>
        <71b8fe4c-7be2-fe51-cd84-890320c98cda@codeaurora.org>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 5 Oct 2020 10:09:34 +0530
Gaurav Kohli <gkohli@codeaurora.org> wrote:

> Hi Steven,
> 
> please let us know, if below looks good to you or need modifications.

Strange, I don't have your original email in my inbox. I do have it in my
LKML folder, but that's way too big for me to read. I checked my server
logs. I found where I received this from LKML, but there's no log that I
received this directly.

How are you sending out your patches? If it doesn't land in my inbox, I'll
never see it.

-- Steve


