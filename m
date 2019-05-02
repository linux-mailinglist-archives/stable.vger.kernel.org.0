Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 78D73113B0
	for <lists+stable@lfdr.de>; Thu,  2 May 2019 09:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfEBHIB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 May 2019 03:08:01 -0400
Received: from mga11.intel.com ([192.55.52.93]:30290 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725791AbfEBHIB (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 May 2019 03:08:01 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 May 2019 00:08:00 -0700
X-ExtLoop1: 1
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.189])
  by orsmga002.jf.intel.com with ESMTP; 02 May 2019 00:07:57 -0700
Date:   Thu, 2 May 2019 10:07:58 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org, Stefan Berger <stefanb@linux.ibm.com>,
        Jerry Snitselaar <jsnitsel@redhat.com>
Subject: Re: [PATCH] tpm/tpm_i2c_atmel: Return -E2BIG when the transfer is
 incomplete
Message-ID: <20190502070758.GA14532@linux.intel.com>
References: <20190423124335.19792-1-jarkko.sakkinen@linux.intel.com>
 <20190423150307.GN17719@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190423150307.GN17719@sasha-vm>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 23, 2019 at 11:03:07AM -0400, Sasha Levin wrote:
> On Tue, Apr 23, 2019 at 03:43:35PM +0300, Jarkko Sakkinen wrote:
> > commit 442601e87a4769a8daba4976ec3afa5222ca211d upstream
> > 
> > Return -E2BIG when the transfer is incomplete. The upper layer does
> > not retry, so not doing that is incorrect behaviour.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: a2871c62e186 ("tpm: Add support for Atmel I2C TPMs")
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> > Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
> > Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>
> 
> Okay, between the upstream version and your backports we have this fix
> on all branches, thank you!

Awesome!

/Jarkko
