Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 40F53B2136
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:49:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388966AbfIMNkI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:40:08 -0400
Received: from mga18.intel.com ([134.134.136.126]:21563 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388387AbfIMNkI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:40:08 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Sep 2019 06:40:06 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,489,1559545200"; 
   d="scan'208";a="386387608"
Received: from ltudorx-wtg.ger.corp.intel.com (HELO localhost) ([10.252.37.39])
  by fmsmga006.fm.intel.com with ESMTP; 13 Sep 2019 06:40:01 -0700
Date:   Fri, 13 Sep 2019 14:39:59 +0100
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Petr Vorel <petr.vorel@gmail.com>
Cc:     Shuah Khan <shuah@kernel.org>, linux-kselftest@vger.kernel.org,
        linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Joey Pabalinas <joeypabalinas@gmail.com>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] selftests/tpm2: Add the missing TEST_FILES assignment
Message-ID: <20190913133732.GG7412@linux.intel.com>
References: <20190910222523.8116-1-jarkko.sakkinen@linux.intel.com>
 <20190911092005.GA22492@dell5510>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911092005.GA22492@dell5510>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 11, 2019 at 11:20:06AM +0200, Petr Vorel wrote:
> Hi Jarkko,
> 
> > The Python files required by the selftests are not packaged because of
> > the missing assignment to TEST_FILES. Add the assignment.
> 
> > Cc: stable@vger.kernel.org
> > Fixes: 6ea3dfe1e073 ("selftests: add TPM 2.0 tests")
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Reviewed-by: Petr Vorel <pvorel@suse.cz>

Thank you.

/Jarkko
