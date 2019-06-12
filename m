Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AD5C541DBD
	for <lists+stable@lfdr.de>; Wed, 12 Jun 2019 09:29:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404659AbfFLH36 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Jun 2019 03:29:58 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:46922 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404557AbfFLH36 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Jun 2019 03:29:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=Ruerba7IFUeKQJgdb05n8VtJMnJdntN4zRBrO6jeQmA=; b=j9a4hnrkrbMYymaPPairp/h1X
        YZ2MONa90q5qi99lpiB6viNJ0L73yG/57eC71Xsvh8n+kzMfGiEeIu2OFxLA6Bjey5Q0LCT0ARXX4
        b7CFzKQ2t8y6c06CR2+QYcT+G6GBKFYh8L7mQ/bd4DxXJQjs1HEsnYU8PAADKeTcI37epkiWssBF0
        Rmpjb3wRnktHQrGY11ZySERRcayBb4Y17VBTQETboupkthZF9NOdwdjzpJStLEdQpbEu9e2xuvBhM
        q4P3t1nBKK48GFcC9GkURqB0oiy0f6j/0cYNW0CVOh1U5/N6zCyraMfU7NHgDzq55x0vodqb94o+J
        /M1Esqjvw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1haxhB-0000hj-UD; Wed, 12 Jun 2019 07:29:22 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id CCF652025F4E4; Wed, 12 Jun 2019 09:29:19 +0200 (CEST)
Date:   Wed, 12 Jun 2019 09:29:19 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     "Phillips, Kim" <kim.phillips@amd.com>
Cc:     Ingo Molnar <mingo@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Martin =?utf-8?B?TGnFoWth?= <mliska@suse.cz>,
        "Suthikulpanit, Suravee" <Suravee.Suthikulpanit@amd.com>,
        "Natarajan, Janakarajan" <Janakarajan.Natarajan@amd.com>,
        "Hook, Gary" <Gary.Hook@amd.com>, Pu Wen <puwen@hygon.cn>,
        Stephane Eranian <eranian@google.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        "x86@kernel.org" <x86@kernel.org>
Subject: Re: [PATCH 1/2 RESEND] perf/x86/amd/uncore: Do not set ThreadMask
 and SliceMask for non-L3 PMCs
Message-ID: <20190612072919.GY3419@hirez.programming.kicks-ass.net>
References: <20190531161708.25658-1-kim.phillips@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190531161708.25658-1-kim.phillips@amd.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



Your emails are base64 encoded and my scripts don't like that.
