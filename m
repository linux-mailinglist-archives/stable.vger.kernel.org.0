Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 115DD18CFC4
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 15:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727191AbgCTOMI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 10:12:08 -0400
Received: from mga11.intel.com ([192.55.52.93]:61180 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726738AbgCTOMI (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 10:12:08 -0400
IronPort-SDR: 6U9bv5gsSrAqXbT+aN4AXEij3e7otJOU0lXtg9sbnAstxyaAiIM9s+Gic3ks+Ea++qWikOb0dy
 4OElFHXd6kpA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Mar 2020 07:12:07 -0700
IronPort-SDR: hce375dXCIda9G8W4yXD7ilFmrdFvIXS9qsOkqtGySPeCKXm3b2NXt5PVYdsMQ3hLhvA4j3chV
 RKJgh6FgLNYA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,284,1580803200"; 
   d="scan'208";a="324863758"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.161])
  by orsmga001.jf.intel.com with ESMTP; 20 Mar 2020 07:12:04 -0700
Date:   Fri, 20 Mar 2020 16:12:02 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     George Wilson <gcwilson@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Stefan Berger <stefanb@linux.ibm.com>,
        Nayna Jain <nayna@linux.vnet.ibm.com>,
        Jason Gunthorpe <jgg@ziepe.ca>, linux-kernel@vger.kernel.org,
        Linh Pham <phaml@us.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v4] tpm: ibmvtpm: retry on H_CLOSED in tpm_ibmvtpm_send()
Message-ID: <20200320141202.GA3629@linux.intel.com>
References: <20200320032758.228088-1-gcwilson@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200320032758.228088-1-gcwilson@linux.ibm.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 19, 2020 at 11:27:58PM -0400, George Wilson wrote:
> tpm_ibmvtpm_send() can fail during PowerVM Live Partition Mobility resume
> with an H_CLOSED return from ibmvtpm_send_crq().  The PAPR says, 'The
> "partner partition suspended" transport event disables the associated CRQ
> such that any H_SEND_CRQ hcall() to the associated CRQ returns H_Closed
> until the CRQ has been explicitly enabled using the H_ENABLE_CRQ hcall.'
> This patch adds a check in tpm_ibmvtpm_send() for an H_CLOSED return from
> ibmvtpm_send_crq() and in that case calls tpm_ibmvtpm_resume() and
> retries the ibmvtpm_send_crq() once.
> 
> Reported-by: Linh Pham <phaml@us.ibm.com>
> Reviewed-by: Stefan Berger <stefanb@linux.ibm.com>
> Signed-off-by: George Wilson <gcwilson@linux.ibm.com>
> Tested-by: Linh Pham <phaml@us.ibm.com>
> Fixes: 132f76294744 ("drivers/char/tpm: Add new device driver to support IBM vTPM")
> Cc: stable@vger.kernel.org

Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

Thanks. Applied now.

/Jarkko
