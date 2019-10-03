Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A1BEC9E8B
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 14:33:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbfJCMcu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 08:32:50 -0400
Received: from mga12.intel.com ([192.55.52.136]:48259 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730131AbfJCMct (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 08:32:49 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga106.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 03 Oct 2019 05:32:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,252,1566889200"; 
   d="scan'208";a="196331276"
Received: from jsakkine-mobl1.tm.intel.com (HELO localhost) ([10.237.50.161])
  by orsmga006.jf.intel.com with ESMTP; 03 Oct 2019 05:32:47 -0700
Date:   Thu, 3 Oct 2019 15:32:46 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     gregkh@linuxfoundation.org
Cc:     stefanb@linux.ibm.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tpm_tis_core: Set TPM_CHIP_FLAG_IRQ
 before probing for" failed to apply to 4.9-stable tree
Message-ID: <20191003123246.GC10614@linux.intel.com>
References: <1570088789234154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1570088789234154@kroah.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 03, 2019 at 09:46:29AM +0200, gregkh@linuxfoundation.org wrote:
> 
> The patch below does not apply to the 4.9-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.
> 
> thanks,
> 
> greg k-h

Inspecting next week.

/Jarkko
