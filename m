Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE141134718
	for <lists+stable@lfdr.de>; Wed,  8 Jan 2020 17:05:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728772AbgAHQE7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Jan 2020 11:04:59 -0500
Received: from mga07.intel.com ([134.134.136.100]:7093 "EHLO mga07.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726922AbgAHQE7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 8 Jan 2020 11:04:59 -0500
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 08 Jan 2020 08:04:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,410,1571727600"; 
   d="scan'208";a="211580709"
Received: from dkurtaev-mobl.ccr.corp.intel.com ([10.252.22.167])
  by orsmga007.jf.intel.com with ESMTP; 08 Jan 2020 08:04:55 -0800
Message-ID: <80272f0259d967fe61dacd1036cbbd9f555b8402.camel@linux.intel.com>
Subject: Re: [PATCH] tpm: handle negative priv->response_len in
 tpm_common_read
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Tadeusz Struk <tadeusz.struk@intel.com>
Cc:     keescook@chromium.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, linux-integrity@vger.kernel.org,
        labbott@redhat.com
In-Reply-To: <b469b7e8454a69402529cc8e25244860e136308e.camel@linux.intel.com>
References: <b85fa669-d3aa-f6c9-9631-988ae47e392c@redhat.com>
         <157843468820.24718.10808226634364669421.stgit@tstruk-mobl1>
         <b469b7e8454a69402529cc8e25244860e136308e.camel@linux.intel.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160
 Espoo
Content-Type: text/plain; charset="UTF-8"
MIME-Version: 1.0
Date:   Wed, 08 Jan 2020 18:04:49 +0200
User-Agent: Evolution 3.34.1-2 
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 2020-01-08 at 17:58 +0200, Jarkko Sakkinen wrote:
> On Tue, 2020-01-07 at 14:04 -0800, Tadeusz Struk wrote:
> > The priv->responce_length can hold the size of an response or
> > an negative error code, and the tpm_common_read() needs to handle
> > both cases correctly. Changed the type of responce_length to
> > signed and accounted for negative value in tpm_common_read()
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: d23d12484307 ("tpm: fix invalid locking in NONBLOCKING mode")
> > Reported-by: Laura Abbott <labbott@redhat.com>
> > Signed-off-by: Tadeusz Struk <tadeusz.struk@intel.com>
> 
> Reviewed-by: Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
> 
> Adding to the next PR.

Applied but had to fix bunch of typos, missing punctaction and
missing parentheses in the commit message. Even checkpatch.pl
was complaining :-/

Thanks.

/Jarkko

