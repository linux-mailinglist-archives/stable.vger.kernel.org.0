Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C46167592F
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 22:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbfGYU5D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 16:57:03 -0400
Received: from mga12.intel.com ([192.55.52.136]:22260 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726479AbfGYU5D (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 16:57:03 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 13:57:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,308,1559545200"; 
   d="scan'208";a="254113350"
Received: from sjchrist-coffee.jf.intel.com (HELO linux.intel.com) ([10.54.74.165])
  by orsmga001.jf.intel.com with ESMTP; 25 Jul 2019 13:57:01 -0700
Date:   Thu, 25 Jul 2019 13:57:01 -0700
From:   Sean Christopherson <sean.j.christopherson@intel.com>
To:     Paolo Bonzini <pbonzini@redhat.com>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
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
Message-ID: <20190725205701.GF18612@linux.intel.com>
References: <20190725113437.GA27429@kroah.com>
 <230a5b34-d23e-8318-0b1f-d23ada7318e0@redhat.com>
 <CA+G9fYsWdmboyquZ=Bs3tkTwRFTzd1yuL0_EVpHOecNi4E_stA@mail.gmail.com>
 <20190725160939.GC18612@linux.intel.com>
 <33f1cfaa-525d-996a-4977-fda32dc368ee@redhat.com>
 <20190725162053.GD18612@linux.intel.com>
 <7bc207e0-0812-e41a-bfd5-e3fbfd43f242@redhat.com>
 <20190725163946.xt2p3pvxwuabzojj@xps.therub.org>
 <3e55414d-cb4f-8f3f-a359-e374b6298715@redhat.com>
 <20190725201933.aiqh6oj7bacdwact@xps.therub.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190725201933.aiqh6oj7bacdwact@xps.therub.org>
User-Agent: Mutt/1.5.24 (2015-08-30)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 25, 2019 at 03:19:33PM -0500, Dan Rue wrote:
> I would still prefer to run the latest tests against all kernel versions
> (but better control when we upgrade it). Like I said, we can handle
> expected failures, and it would even help to validate backports for
> fixes that do get backported. I'm afraid on your behalf that snapping
> (and maintaining) branches per kernel branch is going to be a lot to
> manage.

Having the branches would be beneficial for kernel developers as well,
e.g. on multiple occasions I've spent time hunting down non-existent KVM
bugs, only to realize my base kernel was stale with respect to kvm-unit-tests.

My thought was to have a mostly-unmaintained branch for each major kernel
version, e.g. snapshot a working version of kvm_unit_tests when the KVM
pull request for the merge window is sent, and for the most part leave it
at that.  I don't think it would introduce much overhead, but then again,
I'm not the person who would be maintaining this :-)
