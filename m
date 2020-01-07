Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFFC51327BD
	for <lists+stable@lfdr.de>; Tue,  7 Jan 2020 14:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727894AbgAGNfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jan 2020 08:35:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:50916 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727559AbgAGNfX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jan 2020 08:35:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=LNR/sdifkLYBQN1o5vH9UJw/7uhmyLBfESVcRAGK3Sc=; b=Rs2n8vtgDhDr8N3x8HocNbNln
        MpRWLfHF8kmAhNlkNLXrqJ2lN0vCvCZTCmuVbeeZp6mqqhxyzLedI4rx3hV9fA+7yHgt1vHDPBB/d
        ewfn/OaAei/LvMStzPsYNrNHquMB95JbAmlymsPZgJR6rHlmEzcGVUBTk0dLCaDxexOm8CJ7SoE7b
        hgRfUlwQ5oXj2+BlWGW1sRXp+XqZoqiajsEy/OOqyrgWkaBOkxSDGx8KdYcdh0mCw4+6xXtn968ov
        K6JrfaASHi4CUgNYogNFxFp5E+cGKZpq0+frPSQgC7+Un7QZiztYFzEadakKRalwsfUSQrN9FiBWZ
        dO1GP4zQg==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iop0r-00076D-VB; Tue, 07 Jan 2020 13:35:14 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 4341730025A;
        Tue,  7 Jan 2020 14:33:38 +0100 (CET)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id BDB262B2835F0; Tue,  7 Jan 2020 14:35:10 +0100 (CET)
Date:   Tue, 7 Jan 2020 14:35:10 +0100
From:   Peter Zijlstra <peterz@infradead.org>
To:     Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc:     Borislav Petkov <bp@alien8.de>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        linux-tip-commits <linux-tip-commits@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@kernel.org>, x86 <x86@kernel.org>,
        stable <stable@vger.kernel.org>
Subject: Re: [tip: core/urgent] rseq: Reject unknown flags on rseq unregister
Message-ID: <20200107133510.GB2844@hirez.programming.kicks-ass.net>
References: <20191211161713.4490-2-mathieu.desnoyers@efficios.com>
 <157727033331.30329.17206832903007175600.tip-bot2@tip-bot2>
 <20191225113932.GD18098@zn.tnic>
 <1460494267.15769.1577399533860.JavaMail.zimbra@efficios.com>
 <1732849021.873.1578338087928.JavaMail.zimbra@efficios.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1732849021.873.1578338087928.JavaMail.zimbra@efficios.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 06, 2020 at 02:14:47PM -0500, Mathieu Desnoyers wrote:

> For the records, I had stable in CC in my original patch submission. The stable CC has
> been stripped when it was merged into the tip tree.

Argh, lemme go fix my scripts _again_..

I was recently made aware that we should not have spurious Cc: tags in
commit messages, but obviously the stable thing is an exception there.
