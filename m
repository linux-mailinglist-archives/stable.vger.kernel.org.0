Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56E126723D
	for <lists+stable@lfdr.de>; Fri, 12 Jul 2019 17:22:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727221AbfGLPWF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Jul 2019 11:22:05 -0400
Received: from mga05.intel.com ([192.55.52.43]:15023 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726254AbfGLPWE (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Jul 2019 11:22:04 -0400
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Jul 2019 08:22:02 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.63,483,1557212400"; 
   d="scan'208";a="250149540"
Received: from yanbeibe-mobl2.ger.corp.intel.com ([10.249.32.118])
  by orsmga001.jf.intel.com with ESMTP; 12 Jul 2019 08:21:57 -0700
Message-ID: <b5a73063fe855e027623c211e6ea5c7d20a27a04.camel@linux.intel.com>
Subject: Re: [PATCH] tpm: Fix TPM 1.2 Shutdown sequence to prevent future
 TPM operations
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Greg KH <gregkh@linuxfoundation.org>,
        Doug Anderson <dianders@chromium.org>
Cc:     Jason Gunthorpe <jgg@ziepe.ca>, "# 4.0+" <stable@vger.kernel.org>,
        Guenter Roeck <groeck@chromium.org>,
        Vadim Sukhomlinov <sukhomlinov@google.com>,
        Arnd Bergmann <arnd@arndb.de>, Peter Huewe <peterhuewe@gmx.de>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-integrity@vger.kernel.org
Date:   Fri, 12 Jul 2019 18:21:56 +0300
In-Reply-To: <20190712115025.GA8221@kroah.com>
References: <20190711162919.23813-1-dianders@chromium.org>
         <20190711163915.GD25807@ziepe.ca> <20190711170437.GA7544@kroah.com>
         <20190711171726.GE25807@ziepe.ca> <20190711172630.GA11371@kroah.com>
         <CAD=FV=U0ue_4FyS7MO+iaKQ5gr0PhuLZaTV1adPY3ZtNhKTmHA@mail.gmail.com>
         <20190712115025.GA8221@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.1-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-07-12 at 13:50 +0200, Greg KH wrote:
> But the sysfs comment means I should not apply this backport then?
> 
> Totally confused by this long thread, sorry.
> 
> What am I supposed to do for the stable trees here?

I'll work out a proper patch set for stable kernels with necessary
patches and cover letter with a brief summary in the week starting
29th of this month when I come back from vacation.

/Jarkko

