Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10EFA6980FB
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 17:35:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229477AbjBOQfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 11:35:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbjBOQey (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 11:34:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C4991E2BF;
        Wed, 15 Feb 2023 08:34:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F209261CC4;
        Wed, 15 Feb 2023 16:34:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5205DC433EF;
        Wed, 15 Feb 2023 16:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676478864;
        bh=BadVFKzRGJF8LRdfl9yVztmi22ZUjwiwfoXaVOoyIx8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bwzQwwAYlv5fiul7hM7f4XRpWcvZAMq40/RitG6Iti/Dy5w2dOg9W7o6sNNtV68L4
         ylNE1uDjqm6Oh/aww7V5U8HfrT3Nl1ZfGKQn+HzC3CPnQyFE/warBJ/zVjcomognAC
         sKh/BU3jZ2oSbBHPIEZPvtX6Orpjj+Bk8LIuDySrCBlRmqNerA1mB3UvRkVLPjPKb9
         fIfg7bPtyw+1/34jeLkAoak2ecuGPbBl2tQOcRSU7jyCoPlJXJ/VDnsekc0SZWGA3w
         f0NfttJjtlpSOtSkCwNxG5UBV8MnnZm2hAjrixDPfqRbrXmChBrXGVyNfaNLIFsgMM
         KY20Q5WBjMNGg==
Date:   Wed, 15 Feb 2023 11:34:23 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Leah Rumancik <leah.rumancik@gmail.com>
Cc:     stable@vger.kernel.org, linux-xfs@vger.kernel.org,
        amir73il@gmail.com, chandan.babu@oracle.com
Subject: Re: [PATCH 5.15 00/10] xfs backports for 5.15.y
Message-ID: <Y+0Jj+biS10Qcm+q@sashalap>
References: <20230214212534.1420323-1-leah.rumancik@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230214212534.1420323-1-leah.rumancik@gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 14, 2023 at 01:25:24PM -0800, Leah Rumancik wrote:
>Hello,
>
>Here is the next batch of backports for 5.15.y. These patches have
>already been ACK'd on the xfs mailing list. Testing included
>25 runs of auto group on 12 xfs configs. No regressions were seen.
>I checked xfs/538 was run without issue as this test was mentioned
>in 56486f307100. Also, from 86d40f1e49e9, I ran ran xfs/117 with
>XFS compiled as a module and TEST_FS_MODULE_REOLOAD set, but I was
>unable to reproduce the issue.

Queued up, thanks!

-- 
Thanks,
Sasha
