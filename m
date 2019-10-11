Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D489CD44E8
	for <lists+stable@lfdr.de>; Fri, 11 Oct 2019 18:03:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726828AbfJKQDe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 11 Oct 2019 12:03:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:34304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726521AbfJKQDe (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 11 Oct 2019 12:03:34 -0400
Received: from localhost (unknown [131.107.147.255])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3AF58206CD;
        Fri, 11 Oct 2019 16:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570809814;
        bh=oSUEwW0Kt5KJpDOz/hQs70pv8zEwnLxRsyzvTwVucR0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KfO21gKsmwvNu3CbhvsWUI8veD+PqFndoIyk9jBqt+5G0eteuZD5P+oHnZlozTTAj
         SjxHWJlUn1WgPbVRENGadpn/2UzyESy7U4/GsiinC6VlDp7wX9r73cpCBFSCsBseeY
         gTOm1L3pFTUj+5V+bE1GhTJDQeH0FkE3sNWy+AoA=
Date:   Fri, 11 Oct 2019 12:03:30 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Luca Coelho <luca@coelho.fi>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v5.2 1/2] iwlwifi: mvm: add a wrapper around rs_tx_status
 to handle locks
Message-ID: <20191011160330.GC2635@sasha-vm>
References: <20191011061402.32107-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20191011061402.32107-1-luca@coelho.fi>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 11, 2019 at 09:14:01AM +0300, Luca Coelho wrote:
>From: Gregory Greenman <gregory.greenman@intel.com>
>
>[ Upstream commit 23babdf06779482a65c5072a145d826a62979534 ]
>
>iwl_mvm_rs_tx_status can be called from two places in the code, but the
>mutex is taken only on one of the calls. Split it into a wrapper taking
>locks and an internal __iwl_mvm_rs_tx_status function.

v5.2 is EOL, any other kernels this needs to be in?

-- 
Thanks,
Sasha
