Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40C469D380
	for <lists+stable@lfdr.de>; Mon, 26 Aug 2019 17:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbfHZP5P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Aug 2019 11:57:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55860 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727864AbfHZP5P (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Aug 2019 11:57:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=4NfHu2NwcaIl5KJfjUKcoltjlmMkEeidEpjbwYEixgE=; b=r1kTwVUB5QH1N5CenHdiuQMyL
        epdJF8JRIsTjreqYtZ3jHgWB2dqS/ApoJxZUQSemx+9ZhkJXMCD4Sz8+GsJJrltATyTmlo/RNqwmI
        cQORD6x35RxPARdeCAeJPXh5GimEVflKFll5aJMahzRfAvXyXucGhYDrb1XtVf+r8NtSzL2ksDmCN
        ua6RsFBwDercls43+V2Ereka5jvkE7rsIGoB2diqEOvlvx/+Ndwi6wvJ4hiNzcL3im3zrFmm0PD/y
        pQ/8pgOiW+8WYzFHE4DnG2mYOJsH6B7pHgseuEglCV6ut2GMwiB3uzM/MtgPMPKGTdYxV8n7dOV56
        XCfs9tmrA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1i2HMV-0004Cw-6v; Mon, 26 Aug 2019 15:56:55 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 5D42D301FF9;
        Mon, 26 Aug 2019 17:56:18 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DB56320C9570B; Mon, 26 Aug 2019 17:56:51 +0200 (CEST)
Date:   Mon, 26 Aug 2019 17:56:51 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Nadav Amit <namit@vmware.com>
Cc:     Steven Rostedt <rostedt@goodmis.org>,
        Song Liu <songliubraving@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>,
        "kernel-team@fb.com" <kernel-team@fb.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Andy Lutomirski <luto@amacapital.net>,
        Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: Re: [PATCH] x86/mm: Do not split_large_page() for
 set_kernel_text_rw()
Message-ID: <20190826155651.GX2369@hirez.programming.kicks-ass.net>
References: <20190823052335.572133-1-songliubraving@fb.com>
 <20190823093637.GH2369@hirez.programming.kicks-ass.net>
 <20190826073308.6e82589d@gandalf.local.home>
 <31AB5512-F083-4DC3-BA73-D5D65CBC410A@vmware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <31AB5512-F083-4DC3-BA73-D5D65CBC410A@vmware.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 26, 2019 at 03:41:24PM +0000, Nadav Amit wrote:

> For the record - here is my previous patch:
> https://lkml.org/lkml/2018/12/5/211

Thanks!
