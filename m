Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43B871AC21F
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:14:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2894963AbgDPNOD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:14:03 -0400
Received: from mga14.intel.com ([192.55.52.115]:27289 "EHLO mga14.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2894939AbgDPNOC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:14:02 -0400
IronPort-SDR: CcmgXTLjx0NJ1DluPc8qvyzD++5ZOQo8ZhR4P5O+DATiRMyqdPHLkv/SUgOhVYm5BdJYBNgA/I
 /PwBQCvCF3Kw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 06:13:42 -0700
IronPort-SDR: WvI81BDYmtxqUsTDFRbJ7tWkzpztLdDLQPZXYSdcA4+j62BciXmPy3JbTTpOaVrSVcm/25Ai/b
 yJajpsV9fqOg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.72,391,1580803200"; 
   d="scan'208";a="332834202"
Received: from otazetdi-mobl.ccr.corp.intel.com (HELO localhost) ([10.249.42.128])
  by orsmga001.jf.intel.com with ESMTP; 16 Apr 2020 06:13:39 -0700
Date:   Thu, 16 Apr 2020 16:13:39 +0300
From:   Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     linux-integrity@vger.kernel.org, stable@vger.kernel.org,
        Peter Huewe <peterhuewe@gmx.de>,
        Jason Gunthorpe <jgg@ziepe.ca>, Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] tpm/tpm_tis: Free IRQ if probing fails
Message-ID: <20200416131339.GB65786@linux.intel.com>
References: <20200412170412.324200-1-jarkko.sakkinen@linux.intel.com>
 <b909aaee-3fff-4dca-40f4-4c5348474426@redhat.com>
 <20200413180732.GA11147@linux.intel.com>
 <7df7f8bd-c65e-1435-7e82-b9f4ecd729de@redhat.com>
 <20200414071349.GA8403@linux.intel.com>
 <d6684575-ce91-fe72-6035-11834a05cd54@redhat.com>
 <20200414160404.GA32775@linux.intel.com>
 <20200414164542.GC32775@linux.intel.com>
 <df580835-f887-1918-c933-6509e5a1ad47@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <df580835-f887-1918-c933-6509e5a1ad47@redhat.com>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 14, 2020 at 07:15:08PM +0200, Hans de Goede wrote:
> Sounds good, I guess it would be best to combine that with a:
> 
> 	if (priv->irq == 0)
> 		return;
> 
> At the top of disable_interrupts() and then unconditionally
> call disable_interrupts() where your v1 of this patch
> calls devm_free_irq(). That would be a reasonable clean
> solution I think.

Great, this was my plan (just wanted to double check).

/Jarkko
