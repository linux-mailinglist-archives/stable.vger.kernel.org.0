Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 839B3117196
	for <lists+stable@lfdr.de>; Mon,  9 Dec 2019 17:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726491AbfLIQ1s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Dec 2019 11:27:48 -0500
Received: from mga06.intel.com ([134.134.136.31]:46285 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726477AbfLIQ1r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Dec 2019 11:27:47 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 09 Dec 2019 08:27:46 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,296,1571727600"; 
   d="scan'208";a="210139474"
Received: from tassilo.jf.intel.com (HELO tassilo.localdomain) ([10.7.201.21])
  by fmsmga007.fm.intel.com with ESMTP; 09 Dec 2019 08:27:46 -0800
Received: by tassilo.localdomain (Postfix, from userid 1000)
        id 5C1D4300DF5; Mon,  9 Dec 2019 08:27:46 -0800 (PST)
Date:   Mon, 9 Dec 2019 08:27:46 -0800
From:   Andi Kleen <ak@linux.intel.com>
To:     kan.liang@linux.intel.com
Cc:     peterz@infradead.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org, like.xu@linux.intel.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] perf/x86/intel/uncore: Fix missing marker for
 snr_uncore_imc_freerunning_events
Message-ID: <20191209162746.GA814951@tassilo.jf.intel.com>
References: <1575898953-85496-1-git-send-email-kan.liang@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1575898953-85496-1-git-send-email-kan.liang@linux.intel.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

> [   16.060540]  entry_SYSCALL_64_after_hwframe+0x49/0xbe
> 
> This snr_uncore_imc_freerunning_events array was missing an end-marker.

We had this often enough now that it might be worth a checkpatch rule?

-Andi
