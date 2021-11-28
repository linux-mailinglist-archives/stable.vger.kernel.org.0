Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2A9D4609DC
	for <lists+stable@lfdr.de>; Sun, 28 Nov 2021 21:56:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231801AbhK1U7p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 28 Nov 2021 15:59:45 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57254 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231693AbhK1U5n (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 28 Nov 2021 15:57:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 126886110F
        for <stable@vger.kernel.org>; Sun, 28 Nov 2021 20:54:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8482C004E1;
        Sun, 28 Nov 2021 20:54:24 +0000 (UTC)
Date:   Sun, 28 Nov 2021 15:54:22 -0500
From:   Steven Rostedt <rostedt@goodmis.org>
To:     <gregkh@linuxfoundation.org>
Cc:     <stable@vger.kernel.org>
Subject: Re: FAILED: patch "[PATCH] tracing: Fix pid filtering when triggers
 are attached" failed to apply to 4.4-stable tree
Message-ID: <20211128155422.17602e4d@oasis.local.home>
In-Reply-To: <16380994544650@kroah.com>
References: <16380994544650@kroah.com>
X-Mailer: Claws Mail 3.18.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, 28 Nov 2021 12:37:34 +0100
<gregkh@linuxfoundation.org> wrote:

> The patch below does not apply to the 4.4-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I took an attempt to backport this patch to 4.4 but found that so much
has changed, that if anyone really has an issue with this broken in
4.4, I'd highly recommend they upgrade their kernel ;-)

-- Steve
