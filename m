Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155B9366CE6
	for <lists+stable@lfdr.de>; Wed, 21 Apr 2021 15:33:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240379AbhDUNeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Apr 2021 09:34:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:48436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239412AbhDUNeT (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 21 Apr 2021 09:34:19 -0400
Received: from gandalf.local.home (cpe-66-24-58-225.stny.res.rr.com [66.24.58.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9455C61449;
        Wed, 21 Apr 2021 13:33:45 +0000 (UTC)
Date:   Wed, 21 Apr 2021 09:33:43 -0400
From:   Steven Rostedt <rostedt@goodmis.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Wenwen Wang <wang6495@umn.edu>
Subject: Re: [PATCH 081/190] Revert "tracing: Fix a memory leak by early
 error exit in trace_pid_write()"
Message-ID: <20210421093343.2c52786a@gandalf.local.home>
In-Reply-To: <20210421092919.2576ce8d@gandalf.local.home>
References: <20210421130105.1226686-1-gregkh@linuxfoundation.org>
        <20210421130105.1226686-82-gregkh@linuxfoundation.org>
        <20210421092919.2576ce8d@gandalf.local.home>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 21 Apr 2021 09:29:19 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

> Reviewed-by: Steven Rostedt (VMware) <rostedt@goodmis.org>

Just to clear up any confusion about my tag above. It was a second review
of the original patch, not for the revert.

-- Steve
