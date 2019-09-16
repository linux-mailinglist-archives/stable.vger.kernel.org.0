Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 862D5B35E1
	for <lists+stable@lfdr.de>; Mon, 16 Sep 2019 09:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726690AbfIPHrE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Sep 2019 03:47:04 -0400
Received: from mga18.intel.com ([134.134.136.126]:15975 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726316AbfIPHrE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Sep 2019 03:47:04 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 16 Sep 2019 00:47:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,510,1559545200"; 
   d="scan'208";a="361450315"
Received: from sshkruni-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.38.138])
  by orsmga005.jf.intel.com with ESMTP; 16 Sep 2019 00:46:59 -0700
Date:   Mon, 16 Sep 2019 10:46:57 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org
Cc:     Mimi Zohar <zohar@linux.ibm.com>, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tpm: Fix tpm_send() length calculation
Message-ID: <20190916074657.GA26795@linux.intel.com>
References: <20190916073535.25117-1-jarkko.sakkinen@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190916073535.25117-1-jarkko.sakkinen@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 16, 2019 at 10:35:35AM +0300, Jarkko Sakkinen wrote:
> Set the size of the tpm_buf correctly. Now it is set to the header
> length by tpm_buf_init().
> 
> Reported-by: Mimi Zohar <zohar@linux.ibm.com>
> Cc: stable@vger.kernel.org
> Fixes: 412eb585587a ("use tpm_buf in tpm_transmit_cmd() as the IO parameter")
> Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

This is all wrong in all possible ways :-( My excuse is the overnight
flight last night (no sleep). Mimi, I think what you first proposed as
the fix is the right way tho fix it. I'll take some sleep and after that
I'll make a legit commit with fix and a commit message explaining the
root cause.

Please try to ignore this.

/Jarkko
