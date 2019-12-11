Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9492011BA9A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 18:47:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730672AbfLKRrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 12:47:09 -0500
Received: from mga17.intel.com ([192.55.52.151]:46279 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729912AbfLKRrI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 12:47:08 -0500
X-Amp-Result: UNSCANNABLE
X-Amp-File-Uploaded: False
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga107.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 11 Dec 2019 09:47:08 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,302,1571727600"; 
   d="scan'208";a="225614790"
Received: from cmclough-mobl.ger.corp.intel.com (HELO localhost) ([10.251.85.152])
  by orsmga002.jf.intel.com with ESMTP; 11 Dec 2019 09:47:02 -0800
Date:   Wed, 11 Dec 2019 19:47:01 +0200
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Tadeusz Struk <tadeusz.struk@intel.com>
Cc:     peterz@infradead.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, jgg@ziepe.ca, mingo@redhat.com,
        jeffrin@rajagiritech.edu.in, linux-integrity@vger.kernel.org,
        will@kernel.org, peterhuewe@gmx.de
Subject: Re: [PATCH] tpm: fix WARNING: lock held when returning to user space
Message-ID: <20191211174639.GH4516@linux.intel.com>
References: <34e5340f-de75-f20e-7898-6142eac45c13@intel.com>
 <157601267151.12904.7408818232910113434.stgit@tstruk-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157601267151.12904.7408818232910113434.stgit@tstruk-mobl1>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 10, 2019 at 01:17:51PM -0800, Tadeusz Struk wrote:
> When an application sends TPM commands in NONBLOCKING mode
> the driver holds chip->tpm_mutex returning from write(),
> which triggers WARNING: lock held when returning to user space!
> To silence this warning the driver needs to release the mutex
> and acquire it again in tpm_dev_async_work() before sending
> the command.
> 
> Cc: stable@vger.kernel.org
> Fixes: 9e1b74a63f776 (tpm: add support for nonblocking operation)
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Bundle the patch and test into same patch set (no need for
cover letter) in the case we need to iterate (as they must
be in sync anyway).

/Jarkko
