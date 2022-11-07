Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7B8A61F7F6
	for <lists+stable@lfdr.de>; Mon,  7 Nov 2022 16:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232408AbiKGPuN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Nov 2022 10:50:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232084AbiKGPuM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Nov 2022 10:50:12 -0500
X-Greylist: delayed 373 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Nov 2022 07:50:10 PST
Received: from outbound-smtp47.blacknight.com (outbound-smtp47.blacknight.com [46.22.136.64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4D9FDB
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 07:50:10 -0800 (PST)
Received: from mail.blacknight.com (pemlinmail03.blacknight.ie [81.17.254.16])
        by outbound-smtp47.blacknight.com (Postfix) with ESMTPS id C2714FA804
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 15:43:51 +0000 (GMT)
Received: (qmail 16486 invoked from network); 7 Nov 2022 15:43:51 -0000
Received: from unknown (HELO techsingularity.net) (mgorman@techsingularity.net@[84.203.198.246])
  by 81.17.254.9 with ESMTPSA (AES256-SHA encrypted, authenticated); 7 Nov 2022 15:43:51 -0000
Date:   Mon, 7 Nov 2022 15:43:50 +0000
From:   Mel Gorman <mgorman@techsingularity.net>
To:     "Akira Naribayashi (Fujitsu)" <a.naribayashi@fujitsu.com>
Cc:     "akpm@linux-foundation.org" <akpm@linux-foundation.org>,
        "vbabka@suse.cz" <vbabka@suse.cz>,
        "rientjes@google.com" <rientjes@google.com>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mm, compaction: fix fast_isolate_around() to stay within
 boundaries
Message-ID: <20221107154350.34brdl3ms2ve5wud@techsingularity.net>
References: <20221027132557.5f724149bd5753036f41512a@linux-foundation.org>
 <20221031073559.36021-1-a.naribayashi@fujitsu.com>
 <TYCPR01MB77752C15C512BB7EC952F05BE53C9@TYCPR01MB7775.jpnprd01.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <TYCPR01MB77752C15C512BB7EC952F05BE53C9@TYCPR01MB7775.jpnprd01.prod.outlook.com>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 07, 2022 at 12:32:34PM +0000, Akira Naribayashi (Fujitsu) wrote:
> > Under what circumstances will this panic occur?  I assume those
> > circumstnces are pretty rare, give that 6e2b7044c1992 was nearly two
> > years ago.
> > 
> > Did you consider the desirability of backporting this fix into earlier
> > kernels?
> 
> 
> Panic can occur on systems with multiple zones in a single pageblock.
> 

Please provide an example of the panic and the zoneinfo.

> The reason it is rare is that it only happens in special configurations.

How is this special configuration created?

-- 
Mel Gorman
SUSE Labs
