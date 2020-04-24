Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E60EA1B7ADB
	for <lists+stable@lfdr.de>; Fri, 24 Apr 2020 17:56:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727898AbgDXP4j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Apr 2020 11:56:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727063AbgDXP4i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Apr 2020 11:56:38 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EC2BC09B046;
        Fri, 24 Apr 2020 08:56:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=ajLPeTZ2LB0Od4fQUmCVBUekxC2O/Q3IB9mDGtoNpBM=; b=VwYSGio2fYVXLWKk6BBR/yeb+K
        Uhz5OLEmWuFsr4OeuNZvpOQFTXDq4hcrPDYAfXJPd+20xdm3B/CrKXlcMS+3fWF2gDp/e9wBDaNJQ
        tVji0GDAUI+l/g/0j5Nimzs0SCcDAUbXKk7NMmxqSQGQOdLP3I995qtxCyWe+qS5faJSmWDMERuEd
        m9Xu8M90m3cV/MyVDN8sQbWYm7fmr263RobJY/HjcWIYedCUxIFECQF+nqoQzmef8/Geq/RctviYT
        mQ7EjcCRBCHlHuH6CQrLfYBf3/pB0lDc6wCQBHXDkq28fY8lewCXCNv3NlTQVwNVDmwPIZfzjMvF5
        vOAjbtJA==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=noisy.programming.kicks-ass.net)
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jS0gp-0001eu-Q2; Fri, 24 Apr 2020 15:56:32 +0000
Received: from hirez.programming.kicks-ass.net (hirez.programming.kicks-ass.net [192.168.1.225])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by noisy.programming.kicks-ass.net (Postfix) with ESMTPS id 6134730257C;
        Fri, 24 Apr 2020 17:56:29 +0200 (CEST)
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id 467B229B1ED2F; Fri, 24 Apr 2020 17:56:29 +0200 (CEST)
Date:   Fri, 24 Apr 2020 17:56:29 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Ben Hutchings <ben@decadent.org.uk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        akpm@linux-foundation.org, Denis Kirjanov <kda@linux-powerpc.org>,
        Jann Horn <jannh@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 3.16 246/247] futex: Fix inode life-time issue
Message-ID: <20200424155629.GB13558@hirez.programming.kicks-ass.net>
References: <lsq.1587743245.5555628@decadent.org.uk>
 <lsq.1587743246.9036831@decadent.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <lsq.1587743246.9036831@decadent.org.uk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 24, 2020 at 04:51:31PM +0100, Ben Hutchings wrote:
> 3.16.83-rc2 review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Peter Zijlstra <peterz@infradead.org>
> 
> commit 8019ad13ef7f64be44d4f892af9c840179009254 upstream.

Please do not forget:

  8d67743653dc ("futex: Unbreak futex hashing")

which fixes this fix.
