Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EBF8FC21
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 17:05:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726014AbfD3PFt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 11:05:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38328 "EHLO
        merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfD3PFt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 30 Apr 2019 11:05:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=In-Reply-To:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=0xdy8/6cVPDCTA4KqHYwmMG/mADuOV15e+WMpCce+eQ=; b=sWAEJBmmETqq2/gocj40ak1yU
        ZpviYJxIK/oPpIjAJwsgyrAs3pEUdTXq1ACOcROYeaS8R/6T6AiR2BN15WFOzgH8CVNVOfOIaSTmd
        VeESS/wORMxI/dQ6j9U8WA/BF0OKM/keKw1E/qX3oY0W5zE1LBXoDqKiZHgNSljxosL+9zuV0GWJU
        X/nzjE/5Z37n8Qquzi/sJKTHOD7mqqewb2lZbJuyzemuKl3/tQSG9Waey7oIGHMP9f23UKXOHzqO+
        14PBU0YwXva41P5/c6kwhwfue7pLWP27TsJ1ErmAM399UoyxE6u+N7/5ZoOvuT9Ek4v92QY9uWzQG
        GVCL5qXZw==;
Received: from j217100.upc-j.chello.nl ([24.132.217.100] helo=hirez.programming.kicks-ass.net)
        by merlin.infradead.org with esmtpsa (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hLUKE-0001n4-5K; Tue, 30 Apr 2019 15:05:42 +0000
Received: by hirez.programming.kicks-ass.net (Postfix, from userid 1000)
        id DEADA29B2FDBB; Tue, 30 Apr 2019 17:05:35 +0200 (CEST)
Date:   Tue, 30 Apr 2019 17:05:35 +0200
From:   Peter Zijlstra <peterz@infradead.org>
To:     Sean Christopherson <sean.j.christopherson@intel.com>
Cc:     Perr Zhang <strongbox8@zoho.com>, pbonzini@redhat.com,
        rkrcmar@redhat.com, tglx@linutronix.de, stable@vger.kernel.org,
        mingo@redhat.com, x86@kernel.org, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] KVM: x86: revert the order of calls in kvm_fast_pio()
Message-ID: <20190430150535.GK2589@hirez.programming.kicks-ass.net>
References: <20190430142423.3393-1-strongbox8@zoho.com>
 <20190430143201.GH2589@hirez.programming.kicks-ass.net>
 <20190430145724.GA32170@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190430145724.GA32170@linux.intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 30, 2019 at 07:57:24AM -0700, Sean Christopherson wrote:
> There's a more precise fix submitted for this bug[1].  In theory v2
> already went out, but I still don't see it posted to the KVM list.
> Either the KVM list or my mail client is being weird.
> 
> [1] https://patchwork.kernel.org/patch/10919849/

Thanks!
