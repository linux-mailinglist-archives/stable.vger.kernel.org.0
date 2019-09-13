Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4E4B2168
	for <lists+stable@lfdr.de>; Fri, 13 Sep 2019 15:55:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389384AbfIMNuV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 Sep 2019 09:50:21 -0400
Received: from mga05.intel.com ([192.55.52.43]:7151 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388639AbfIMNuU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 13 Sep 2019 09:50:20 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Sep 2019 06:50:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,492,1559545200"; 
   d="scan'208";a="176286060"
Received: from ltudorx-wtg.ger.corp.intel.com (HELO localhost) ([10.252.37.39])
  by orsmga007.jf.intel.com with ESMTP; 13 Sep 2019 06:50:14 -0700
Date:   Fri, 13 Sep 2019 14:50:11 +0100
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Roberto Sassu <roberto.sassu@huawei.com>,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tpm: Call tpm_put_ops() when the validation for @digests
 fails
Message-ID: <20190913135011.GH7412@linux.intel.com>
References: <20190910142437.20889-1-jarkko.sakkinen@linux.intel.com>
 <20190910151121.3tgzwuhrroog5dvb@cantor>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190910151121.3tgzwuhrroog5dvb@cantor>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 10, 2019 at 08:11:21AM -0700, Jerry Snitselaar wrote:
> On Tue Sep 10 19, Jarkko Sakkinen wrote:
> > The chip is not released when the validation for @digests fails. Add
> > tpm_put_ops() to the failure path.
> > 
> > Cc: stable@vger.kernel.org
> > Reported-by: Roberto Sassu <roberto.sassu@huawei.com>
> > Signed-off-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Reviewed-by: Jerry Snitselaar <jsnitsel@redhat.com>

Roberto, can you just squash this fix with yours to a single patch and
send a new patch version? You can add suggested-by tag from me to v4.

/Jarkko
