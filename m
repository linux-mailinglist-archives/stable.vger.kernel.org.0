Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90A6D672B9
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 17:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727086AbfGLPrM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 11:47:12 -0400
Received: from mga07.intel.com ([134.134.136.100]:50301 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726867AbfGLPrM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 11:47:12 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jul 2019 08:47:11 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,483,1557212400"; 
   d="scan'208";a="318032328"
Received: from yanbeibe-mobl2.ger.corp.intel.com ([10.249.32.118])
  by orsmga004.jf.intel.com with ESMTP; 12 Jul 2019 08:47:06 -0700
Message-ID: <40bf8745601c1d775f67f4e85eb0a98dc6d25200.camel@linux.intel.com>
Subject: Re: [PATCH] tpm: Fix TPM 1.2 Shutdown sequence to prevent future
 TPM operations
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Doug Anderson <dianders@chromium.org>,
        Greg KH <gregkh@linuxfoundation.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, "# 4.0+" <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        Arnd Bergmann <arnd@arndb.de>, Peter Huewe <peterhuewe@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org
Date:   Fri, 12 Jul 2019 18:47:04 +0300
In-Reply-To: <CAD=FV=UBOWHrEFQRhxsnK-PmVkFjcvnEruuy0sYHh0p-Qnk8pA@mail.gmail.com>
References: <20190711162919.23813-1-dianders@chromium.org>
         <20190711163915.GD25807@ziepe.ca> <20190711170437.GA7544@kroah.com>
         <20190711171726.GE25807@ziepe.ca> <20190711172630.GA11371@kroah.com>
         <CAD=FV=U0ue_4FyS7MO+iaKQ5gr0PhuLZaTV1adPY3ZtNhKTmHA@mail.gmail.com>
         <20190712115025.GA8221@kroah.com>
         <CAD=FV=UBOWHrEFQRhxsnK-PmVkFjcvnEruuy0sYHh0p-Qnk8pA@mail.gmail.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-07-12 at 08:00 -0700, Doug Anderson wrote:
> * On 5.2 / 5.1: you've already got this picked to stable.  Good
> 
> * On 4.14 / 4.19: Jarkko will look at in 2 weeks.
> 
> * On 4.9 and older: I'd propose skipping unless someone is known to
> need a solution here.

I'll prioritize 4.14 and 4.19.

If it doesn't become a too big struggle, I'll try to fix also older
but no final word on that at this point.

/Jarkko

