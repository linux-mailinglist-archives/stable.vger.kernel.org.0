Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD82D0413
	for <lists+stable@lfdr.de>; Wed,  9 Oct 2019 01:27:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726384AbfJHX1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 19:27:51 -0400
Received: from mga05.intel.com ([192.55.52.43]:4002 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbfJHX1v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Oct 2019 19:27:51 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Oct 2019 16:27:50 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.67,273,1566889200"; 
   d="scan'208";a="223394807"
Received: from jhogan1-mobl.ger.corp.intel.com (HELO localhost) ([10.252.2.221])
  by fmsmga002.fm.intel.com with ESMTP; 08 Oct 2019 16:27:48 -0700
Date:   Wed, 9 Oct 2019 02:27:47 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Tadeusz Struk <tadeusz.struk@intel.com>
Cc:     linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH] tpm: add check after commands attribs tab allocation
Message-ID: <20191008232747.GB12089@linux.intel.com>
References: <157048479752.25182.17480591993061064051.stgit@tstruk-mobl1.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <157048479752.25182.17480591993061064051.stgit@tstruk-mobl1.jf.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 07, 2019 at 02:46:37PM -0700, Tadeusz Struk wrote:
> devm_kcalloc() can fail and return NULL so we need to check for that.
> 
> Fixes: 58472f5cd4f6f ("tpm: validate TPM 2.0 commands")
> Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>

Thank you.

Cc: stable@vger.kernel.org
Reviewed-by:  Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>

/Jarkko
