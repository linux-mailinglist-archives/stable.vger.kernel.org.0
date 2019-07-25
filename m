Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC19775482
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 18:46:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727026AbfGYQqM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 12:46:12 -0400
Received: from mga04.intel.com ([192.55.52.120]:33320 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726781AbfGYQqL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 12:46:11 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 09:46:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,307,1559545200"; 
   d="scan'208";a="171862867"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by fmsmga007.fm.intel.com with ESMTP; 25 Jul 2019 09:46:11 -0700
Date:   Thu, 25 Jul 2019 09:46:11 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Anders Roxell <anders.roxell@linaro.org>,
        Ben Hutchings <ben.hutchings@codethink.co.uk>,
        wanpengli@tencent.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        patches@kernelci.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        linux- stable <stable@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shuah Khan <shuah@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, jmattson@google.com
Subject: Re: [PATCH 5.2 000/413] 5.2.3-stable review
Message-ID: <20190725164610.GE18612@linux.intel.com>
References: <20190724191735.096702571@linuxfoundation.org>
 <CADYN=9+WLxhmqX3JNL_s-kWSN97G=8WhD=TF=uAuKecJnKcj_Q@mail.gmail.com>
 <20190725113437.GA27429@kroah.com>
 <230a5b34-d23e-8318-0b1f-d23ada7318e0@redhat.com>
 <CA+G9fYsWdmboyquZ=Bs3tkTwRFTzd1yuL0_EVpHOecNi4E_stA@mail.gmail.com>
 <20190725160939.GC18612@linux.intel.com>
 <33f1cfaa-525d-996a-4977-fda32dc368ee@redhat.com>
 <20190725162053.GD18612@linux.intel.com>
 <7bc207e0-0812-e41a-bfd5-e3fbfd43f242@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7bc207e0-0812-e41a-bfd5-e3fbfd43f242@redhat.com>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 06:30:10PM +0200, Paolo Bonzini wrote:
> On 25/07/19 18:20, Sean Christopherson wrote:
> > On Thu, Jul 25, 2019 at 06:10:37PM +0200, Paolo Bonzini wrote:
> >> On 25/07/19 18:09, Sean Christopherson wrote:
> >>>> This investigation confirms it is a new test code failure on stable-rc 5.2.3
> >>> No, it only confirms that kvm-unit-tests/master fails on 5.2.*.  To confirm
> >>> a new failure in 5.2.3 you would need to show a test that passes on 5.2.2
> >>> and fails on 5.2.3.
> >>
> >> I think he meant "a failure in new test code". :)
> > 
> > Ah, that does appear to be the case.  So just to be clear, we're good, right?
> 
> Yes.  I'm happy to gather ideas on how to avoid this (i.e. 1) if a
> submodule would be useful; 2) where to stick it).

As a starting point, what about adding "stable" branches for each kernel
release to kvm-unit-tests, e.g. linux-5.2.y?  I assume we'd need something
similar for the submodules anyways.
