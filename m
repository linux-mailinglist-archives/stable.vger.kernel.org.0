Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C84672E73
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 14:07:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726099AbfGXMH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 08:07:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44878 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726087AbfGXMH4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 08:07:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 73C2C21850;
        Wed, 24 Jul 2019 12:07:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563970076;
        bh=e0H4W4MC74Gu+GRlJhe882q6wxHGKDvltQqIAe1bHyc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=N9Ggq/EtxggKl7XNO/rVWHpERVaiKA10EYwivfntyH7AB1wff6RvXPweQykvpFkjM
         e8TjuqYO+RkPtTnmUy/wHbR1YTQYlTUZ62SGnSZbw4g8hwZdbTWUkqrbWDrgQPMT7j
         j/fLhzD5FE+92Bnw/B6N8IznySxcJXJL547ect/g=
Date:   Wed, 24 Jul 2019 14:07:53 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Alessio Balsini <balsini@android.com>
Cc:     astrachan@google.com, maennich@google.com, kernel-team@android.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 4.9 1/2] um: Allow building and running on older hosts
Message-ID: <20190724120753.GH3244@kroah.com>
References: <20190722103338.111753-1-balsini@android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722103338.111753-1-balsini@android.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 22, 2019 at 11:33:37AM +0100, Alessio Balsini wrote:
> commit 0a987645672ebde7844a9c0732a5a25f3d4bb6c6 upstream.
> 
> Commit a78ff1112263 ("um: add extended processor state save/restore
> support") and b6024b21fec8 ("um: extend fpstate to _xstate to support
> YMM registers") forced the use of the x86 FP _xstate and
> PTRACE_GETREGSET/SETREGSET. On older hosts, we would neither be able to
> build UML nor run it anymore with these two commits applied because we
> don't have definitions for struct _xstate nor these two ptrace requests.
> 
> We can determine at build time which fp context structure to check
> against, just like we can keep using the old i387 fp save/restore if
> PTRACE_GETRESET/SETREGSET are not defined.
> 
> Fixes: a78ff1112263 ("um: add extended processor state save/restore support")
> Fixes: b6024b21fec8 ("um: extend fpstate to _xstate to support YMM registers")
> Change-Id: I2cda034c8a6637de392c2740a993982ad132bda5

No need for change-id in upstream patches :)

let me see if I can just take what is already in 4.13 directly...

