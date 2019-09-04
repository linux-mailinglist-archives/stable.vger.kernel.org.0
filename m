Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7A51EA7BFE
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 08:50:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725938AbfIDGuW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 02:50:22 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48448 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfIDGuW (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Sep 2019 02:50:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=SSDyoF1tdrcOZz+6up0yqcnQw7uwk6EJ2fNkkSXZVNA=; b=m89abydh10d6Emc94UXol8Fjx
        qt84+LQ4oJ43cptYc5XQpaTA74Q3PS1JVKdRkO999cF7R50xPvhIibzJi3XUgC+neL+iERjoMroaF
        RVLhxIOJBL/ka/8b3eHDkT2bnVnwl5RHdFoOVz5OfzmmhT9wqI+zsSgI4xFlOfoqFjsF/RdK06ut/
        rZ4djzvhhE455jaHYPxutSzzjvkfaIewZL7xygT6ZlSTP9JwUJNol9QNzGD5jEdQ8cCzOrB7WYjPN
        jupWD7kUDlP/Fk85PlA4OOqj1h8tA2ylJOA6geIc0cQMFjlogCLvTDeChMtYWMXCdpHRKB5k437mw
        4iaxUSzlQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1i5P7N-0005w2-MZ; Wed, 04 Sep 2019 06:50:13 +0000
Date:   Tue, 3 Sep 2019 23:50:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Travis <mike.travis@hpe.com>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Borislav Petkov <bp@alien8.de>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Russ Anderson <russ.anderson@hpe.com>,
        Hedi Berriche <hedi.berriche@hpe.com>,
        Steve Wahl <steve.wahl@hpe.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 2/8] x86/platform/uv: Return UV Hubless System Type
Message-ID: <20190904065013.GA18003@infradead.org>
References: <20190903001815.504418099@stormcage.eag.rdlabs.hpecorp.net>
 <20190903001815.893030884@stormcage.eag.rdlabs.hpecorp.net>
 <20190903064914.GA9914@infradead.org>
 <0eee6d96-e4fc-763b-a8b9-52c85ddd5531@hpe.com>
 <20190903154109.GB2791@infradead.org>
 <b342b250-a427-60cf-6189-3eb3225e5c91@hpe.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b342b250-a427-60cf-6189-3eb3225e5c91@hpe.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 03, 2019 at 11:49:53AM -0700, Mike Travis wrote:
> 
> That is always being considered for everything we include into the community
> kernel source.  The problem is a couple of the kernel modules (hwperf being
> the prime example) is much more tied to hardware and BIOS/FW updates so has
> to be updated much more often than the current submittal/acceptance process
> allows.  We do opensource these modules but they are built from single
> source directories and have to be released as a module into a package that
> can be installed on different distros. There is not a source version for
> each kernel version.

Well, tought luck then.  We do not support interface for out of tree
modules only.  I actually found a few in uv and will send patches to
drop that dead weight.

> I have seen this method (declare the function with a leading underscore and
> a #define for the function reference) which is why I'm assuming it's a
> standard kernel practice?  (I'll find some examples if necessary?)

No, it isn't.
