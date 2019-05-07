Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 571921694E
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 19:36:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726821AbfEGRg5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 13:36:57 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:47702 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726378AbfEGRg5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 May 2019 13:36:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=clVmOpDd5LzvkH+bJWwETDAH6oZsPTXJW+h72BQ3YmA=; b=Lv9eHU/YCnEEcZbzOeCcafBMF
        OswjYy2ZYStFugMU0UuKCzCEoJL1SeV8aIwcRB9okQqJ9hF87xa9smgAI1nlogUPWbQt2/csogLsh
        klr5i5nLmuZlcA3EdxtfOlQsI/rKdwxGZAQBVMngU6fNViPjUE0ZjFowgSXAg8QafQF6y/1aUavH0
        DUg3anwUIkMdltSZOAIXMEjLKzAr+mCBhyHfLIPctmeSOWVj0/hAbr7k51DT5uC3RrDFnyzw4TvKi
        S0nHugtqx5JMKIFWALxBGRckiMkHDJtdM0Xq80o6t5HYCsbAMDW/hJD8IlHtxEyO7TF0+zvLtkShr
        WlE47EP3Q==;
Received: from willy by bombadil.infradead.org with local (Exim 4.90_1 #2 (Red Hat Linux))
        id 1hO41Q-0000Zl-4S; Tue, 07 May 2019 17:36:56 +0000
Date:   Tue, 7 May 2019 10:36:55 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Michal Hocko <mhocko@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        Mikhail Zaslonko <zaslonko@linux.ibm.com>,
        Gerald Schaefer <gerald.schaefer@de.ibm.com>,
        Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>,
        Dave Hansen <dave.hansen@intel.com>,
        Alexander Duyck <alexander.h.duyck@linux.intel.com>,
        Pasha Tatashin <Pavel.Tatashin@microsoft.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>,
        linux-mm <linux-mm@kvack.org>
Subject: Re: [PATCH AUTOSEL 4.14 62/95] mm, memory_hotplug: initialize struct
 pages for the full memory section
Message-ID: <20190507173655.GA1403@bombadil.infradead.org>
References: <20190507053826.31622-1-sashal@kernel.org>
 <20190507053826.31622-62-sashal@kernel.org>
 <CAKgT0Uc8ywg8zrqyM9G+Ws==+yOfxbk6FOMHstO8qsizt8mqXA@mail.gmail.com>
 <CAHk-=win03Q09XEpYmk51VTdoQJTitrr8ON9vgajrLxV8QHk2A@mail.gmail.com>
 <20190507170208.GF1747@sasha-vm>
 <CAHk-=wi5M-CC3CUhmQZOvQE2xJgfBgrgyAxp+tE=1n3DaNocSg@mail.gmail.com>
 <20190507171806.GG1747@sasha-vm>
 <20190507173224.GS31017@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190507173224.GS31017@dhcp22.suse.cz>
User-Agent: Mutt/1.9.2 (2017-12-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 07, 2019 at 07:32:24PM +0200, Michal Hocko wrote:
> On Tue 07-05-19 13:18:06, Sasha Levin wrote:
> > Michal, is there a testcase I can plug into kselftests to make sure we
> > got this right (and don't regress)? We care a lot about memory hotplug
> > working right.
> 
> As said in other email. The memory hotplug tends to work usually. It
> takes unexpected memory layouts which trigger corner cases. This makes
> testing really hard.

Can we do something with qemu?  Is it flexible enough to hotplug memory
at the right boundaries?
