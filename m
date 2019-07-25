Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B2C4474F53
	for <lists+stable@lfdr.de>; Thu, 25 Jul 2019 15:26:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726689AbfGYN0u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Jul 2019 09:26:50 -0400
Received: from mga05.intel.com ([192.55.52.43]:63208 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbfGYN0u (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Jul 2019 09:26:50 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga105.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 25 Jul 2019 06:26:49 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.64,306,1559545200"; 
   d="scan'208";a="253932233"
Received: from irvmail001.ir.intel.com ([163.33.26.43])
  by orsmga001.jf.intel.com with ESMTP; 25 Jul 2019 06:26:47 -0700
Received: from sivswdev08.ir.intel.com (sivswdev08.ir.intel.com [10.237.217.47])
        by irvmail001.ir.intel.com (8.14.3/8.13.6/MailSET/Hub) with ESMTP id x6PDQl5I026858;
        Thu, 25 Jul 2019 14:26:47 +0100
Received: from sivswdev08.ir.intel.com (localhost [127.0.0.1])
        by sivswdev08.ir.intel.com with ESMTP id x6PDQkKH017252;
        Thu, 25 Jul 2019 14:26:46 +0100
Received: (from gcabiddu@localhost)
        by sivswdev08.ir.intel.com with LOCAL id x6PDQjLP017244;
        Thu, 25 Jul 2019 14:26:45 +0100
Date:   Thu, 25 Jul 2019 14:26:45 +0100
From:   Giovanni Cabiddu <giovanni.cabiddu@intel.com>
To:     "Sverdlin, Alexander (Nokia - DE/Ulm)" <alexander.sverdlin@nokia.com>
Cc:     "qat-linux@intel.com" <qat-linux@intel.com>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] crypto: qat - Silence smp_processor_id() warning
Message-ID: <20190725132645.GA16573@sivswdev08.ir.intel.com>
References: <20190723072347.16247-1-alexander.sverdlin@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190723072347.16247-1-alexander.sverdlin@nokia.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Alexander,

Thanks for you patch.

On Tue, Jul 23, 2019 at 07:24:01AM +0000, Sverdlin, Alexander (Nokia - DE/Ulm) wrote:
> It seems that smp_processor_id() is only used for a best-effort
> load-balancing, refer to qat_crypto_get_instance_node(). It's not feasible
> to disable preemption for the duration of the crypto requests. Therefore,
> just silence the warning. This commit is similar to e7a9b05ca4
> ("crypto: cavium - Fix smp_processor_id() warnings").
> 
> Silences the following splat:
> BUG: using smp_processor_id() in preemptible [00000000] code: cryptomgr_test/2904
> caller is qat_alg_ablkcipher_setkey+0x300/0x4a0 [intel_qat]
> CPU: 1 PID: 2904 Comm: cryptomgr_test Tainted: P           O    4.14.69 #1
How did you reproduce this problem?

Thanks,

-- 
Giovanni
