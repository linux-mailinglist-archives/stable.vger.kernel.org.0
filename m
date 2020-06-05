Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58DE41EF8F9
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 15:26:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726946AbgFEN0B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 09:26:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:16169 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726931AbgFEN0A (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 09:26:00 -0400
IronPort-SDR: sjSG+MwpU7tDcBFJzmoDFNhpoyXMHvgt6gZkmnhYKDcYyaCgnjuQ+uHENMwB/634CgX3Dq+z3F
 e+nNIYuRzXeQ==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2020 06:25:59 -0700
IronPort-SDR: QqxE7vVCy+o4w+yOREYmgWZnFs85Wh6JiXNHvhNhepNpRslwIXDBPaaHax64B+3tgyJr2LBEAt
 oaWmWd4bnrag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,476,1583222400"; 
   d="scan'208";a="294688917"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga004.fm.intel.com with ESMTP; 05 Jun 2020 06:25:56 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andy.shevchenko@gmail.com>)
        id 1jhCMA-00B2K3-BC; Fri, 05 Jun 2020 16:25:58 +0300
Date:   Fri, 5 Jun 2020 16:25:58 +0300
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
To:     Alexander Gordeev <agordeev@linux.ibm.com>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-s390@vger.kernel.org, Stable <stable@vger.kernel.org>,
        Yury Norov <yury.norov@gmail.com>,
        Amritha Nambiar <amritha.nambiar@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Kees Cook <keescook@chromium.org>,
        Matthew Wilcox <willy@infradead.org>,
        Miklos Szeredi <mszeredi@redhat.com>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "Tobin C . Harding" <tobin@kernel.org>,
        Vineet Gupta <vineet.gupta1@synopsys.com>,
        Will Deacon <will.deacon@arm.com>,
        Willem de Bruijn <willemb@google.com>
Subject: Re: [PATCH RESEND] lib: fix bitmap_parse() on 64-bit big endian archs
Message-ID: <20200605132558.GM2428291@smile.fi.intel.com>
References: <1589798090-11136-1-git-send-email-agordeev@linux.ibm.com>
 <CAHp75VdM2yrpd2d3pK2RkmbhF3yiM4=fiTXL4i3yu3AxV3wY-A@mail.gmail.com>
 <20200518115059.GA19150@oc3871087118.ibm.com>
 <20200602102430.GA17703@oc3871087118.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200602102430.GA17703@oc3871087118.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 02, 2020 at 12:24:31PM +0200, Alexander Gordeev wrote:
> On Mon, May 18, 2020 at 01:50:59PM +0200, Alexander Gordeev wrote:
> > On Mon, May 18, 2020 at 02:33:43PM +0300, Andy Shevchenko wrote:
> > > On Mon, May 18, 2020 at 1:40 PM Alexander Gordeev
> > > <agordeev@linux.ibm.com> wrote:
> > > >
> > > > Commit 2d6261583be0 ("lib: rework bitmap_parse()") does
> > > > not take into account order of halfwords on 64-bit big
> > > > endian architectures.
> > > 
> > > Thanks for report and the patch!
> > > 
> > > Did it work before? Can we have a test case for that that we will see
> > > the failure?
> > 
> > The test exists and enabled with CONFIG_TEST_BITMAP.
> > It does not appear ever passed before on 64 BE.
> > It does not fail on 64 LE for me either.
> 
> Hi Andy et al,
> 
> Any feedback on the fix? Does it work on 64 LE for you?

Test case, please.

Yes, you can simulate BE test case on LE platform and vise versa.

-- 
With Best Regards,
Andy Shevchenko


