Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0E2DC241130
	for <lists+stable@lfdr.de>; Mon, 10 Aug 2020 21:53:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgHJTxQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Aug 2020 15:53:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728099AbgHJTxQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 Aug 2020 15:53:16 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB15CC061756;
        Mon, 10 Aug 2020 12:53:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=gc8xlQBhhYuNt1vX0skCipVMdjr1NoGLoeS5+nC7osc=; b=nDr7JriQkkNERVl7hb4AmM4bbl
        X1Y8cncuzP4z16igTnuC1r6Hs4Kd5dd/2JdrOquAQLK9/1/YoGJiF0YEO3mrg30E4U0zsDrokN7oW
        RQNrMPodoYTszyvJLbXEkbfLserLdp5iUO9F9fzYaAgReLlsYo4LQVm9xxi+4G9Ok8CGQahsM+hB1
        iC1YyJdKBNP9CdtIGkw4Nrf3ju4X4OE6IHOn5MWc8dybSHxlXFlMF9JqKcq6gHBJ0yRfVGm63x3yw
        6TOoVVFB+/qLm8VXNqrwT+L484DGtuL1/Only8rTC12vgsa93UGZIw7faPAMqnRMNNL2EJPjCt2SB
        wHfadXLA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=worktop.programming.kicks-ass.net)
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k5Dr7-0004eb-0m; Mon, 10 Aug 2020 19:53:13 +0000
Received: by worktop.programming.kicks-ass.net (Postfix, from userid 1000)
        id A7E419801BE; Mon, 10 Aug 2020 21:53:11 +0200 (CEST)
Date:   Mon, 10 Aug 2020 21:53:11 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     io-uring@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/2] kernel: split task_work_add() into two separate
 helpers
Message-ID: <20200810195311.GA3982@worktop.programming.kicks-ass.net>
References: <20200808183439.342243-1-axboe@kernel.dk>
 <20200808183439.342243-2-axboe@kernel.dk>
 <20200810113740.GR2674@hirez.programming.kicks-ass.net>
 <ae401501-ede0-eb08-12b7-1d50f6b3eaa5@kernel.dk>
 <a420842b-40af-8e39-591e-ae70d797e241@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a420842b-40af-8e39-591e-ae70d797e241@kernel.dk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 10, 2020 at 11:51:33AM -0600, Jens Axboe wrote:

> Added a note of that in the commit message, otherwise the patch is
> unchanged:
> 
> https://git.kernel.dk/cgit/linux-block/commit/?h=io_uring-5.9&id=67e5aca3cb1bd40de0392fea5a661eae2372d6cc

Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
