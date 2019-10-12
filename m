Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84D68D4EB0
	for <lists+stable@lfdr.de>; Sat, 12 Oct 2019 11:46:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729022AbfJLJqR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Oct 2019 05:46:17 -0400
Received: from paleale.coelho.fi ([176.9.41.70]:48496 "EHLO
        farmhouse.coelho.fi" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727083AbfJLJlR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 12 Oct 2019 05:41:17 -0400
Received: from [91.156.6.193] (helo=redipa)
        by farmhouse.coelho.fi with esmtpsa (TLS1.3:ECDHE_SECP256R1__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.92)
        (envelope-from <luca@coelho.fi>)
        id 1iJDtj-0005ol-GI; Sat, 12 Oct 2019 12:41:16 +0300
Message-ID: <bcd9ce3c452b64fdecbb932a2d9e94743ff17f5f.camel@coelho.fi>
From:   Luca Coelho <luca@coelho.fi>
To:     Sasha Levin <sashal@kernel.org>
Cc:     stable@vger.kernel.org
Date:   Sat, 12 Oct 2019 12:41:14 +0300
In-Reply-To: <20191011160330.GC2635@sasha-vm>
References: <20191011061402.32107-1-luca@coelho.fi>
         <20191011160330.GC2635@sasha-vm>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.0-2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on farmhouse.coelho.fi
X-Spam-Level: 
X-Spam-Status: No, score=-2.9 required=5.0 tests=ALL_TRUSTED,BAYES_00,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.2
Subject: Re: [PATCH v5.2 1/2] iwlwifi: mvm: add a wrapper around
 rs_tx_status to handle locks
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 2019-10-11 at 12:03 -0400, Sasha Levin wrote:
> On Fri, Oct 11, 2019 at 09:14:01AM +0300, Luca Coelho wrote:
> > From: Gregory Greenman <gregory.greenman@intel.com>
> > 
> > [ Upstream commit 23babdf06779482a65c5072a145d826a62979534 ]
> > 
> > iwl_mvm_rs_tx_status can be called from two places in the code, but the
> > mutex is taken only on one of the calls. Split it into a wrapper taking
> > locks and an internal __iwl_mvm_rs_tx_status function.
> 
> v5.2 is EOL, any other kernels this needs to be in?

Ah, I hadn't realized v5.2 was EOL already.  It was the only version
where we needed these patches.  They are already in v5.3 and above.

Thanks!

--
Cheers,
Luca.

