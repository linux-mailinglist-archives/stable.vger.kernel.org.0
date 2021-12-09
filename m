Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80C8846E7C5
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 12:52:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233602AbhLILzu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 06:55:50 -0500
Received: from smtp-out1.suse.de ([195.135.220.28]:56546 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232177AbhLILzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 06:55:50 -0500
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 29A28210FF;
        Thu,  9 Dec 2021 11:52:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1639050736; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YX5nCd41/qX08Uy6D4mC8eSKOoVllnuhCQFVjt3bHYY=;
        b=j6xIyE0pjiaV96qWX6YW8i89fAGNYXWoIW7+5PM2DM4WJ8vnTVMSa1YyKGFM2noa3MJ/eT
        QRm5LfMJ6EsefviAuHICxTLFmzECai0JaOhxpXy0Z3CdjXgtDP1b3XKLSoUERfOBCuy8GU
        FHO+qS966nEFGaHI74MYKiUaoZKUXTI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1639050736;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=YX5nCd41/qX08Uy6D4mC8eSKOoVllnuhCQFVjt3bHYY=;
        b=2BnKLHTtAJ0egwCFnhgi64mr4fQdpOSH4ikfdztCnMR5ZUXr9pL+OLktq1UqQc4axI0TNa
        gYe4jlET5DEuJhBw==
Received: from suse.de (mgorman.udp.ovpn2.nue.suse.de [10.163.43.106])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by relay2.suse.de (Postfix) with ESMTPS id 0E978A3B93;
        Thu,  9 Dec 2021 11:52:14 +0000 (UTC)
Date:   Thu, 9 Dec 2021 11:52:11 +0000
From:   Mel Gorman <mgorman@suse.de>
To:     Huang Ying <ying.huang@intel.com>
Cc:     Peter Zijlstra <peterz@infradead.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Mel Gorman <mgorman@techsingularity.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Valentin Schneider <valentin.schneider@arm.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH -V2] numa balancing: move some document to make it
 consistent with the code
Message-ID: <20211209115211.GI3301@suse.de>
References: <20211209004442.999696-1-ying.huang@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20211209004442.999696-1-ying.huang@intel.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Dec 09, 2021 at 08:44:42AM +0800, Huang Ying wrote:
> After commit 8a99b6833c88 ("sched: Move SCHED_DEBUG sysctl to
> debugfs"), some NUMA balancing sysctls enclosed with SCHED_DEBUG has
> been moved to debugfs.  This patch move the document for these
> sysctls from
> 
>   Documentation/admin-guide/sysctl/kernel.rst
> 
> to
> 
>   Documentation/scheduler/debug.txt
> 
> to make the document consistent with the code.
> 

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
