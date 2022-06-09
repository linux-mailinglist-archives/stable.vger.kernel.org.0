Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B337C544E38
	for <lists+stable@lfdr.de>; Thu,  9 Jun 2022 15:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244511AbiFINzx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Jun 2022 09:55:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244880AbiFINzu (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Jun 2022 09:55:50 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CC57396A3;
        Thu,  9 Jun 2022 06:55:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 22E40B82DEE;
        Thu,  9 Jun 2022 13:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C7CC34114;
        Thu,  9 Jun 2022 13:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654782944;
        bh=QaBH8RWuw9ExX/N1zYuNgWYtWQet8otWyR1xJziRo1c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XQUZBApnf27nuYzHbSmZsjnL8+u1qFeX32GbHQVDPDnlZze2Uu+VwipiH2xFBtrH7
         YpRYYp0L3BPuAtTQvdgPgzhCcFSXtjklFfpVTSD2X2JSMqXjRvOkgrKTTfcNp7Cemq
         ei5SlMr+6nNWg72BsN/GKbTcyW16etVPvOA3iYGf2IF13AvTXbtR/kiF47gPYeJeHH
         nhjOwazCNTMEvWCbHhT1XIcvL8U8+QkY4F2gLcE4MUsAOUR3LtNtiO1sAGaldHGp5o
         nweTIV3kii67GhMHCmoT6MTfq4yYHYPptwIebL5EXYzd29kvFTwnFrHdNtKgw7rE9a
         KRlqcVLlLI5Mw==
Date:   Thu, 9 Jun 2022 09:55:43 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Soumya Negi <soumya.negi97@gmail.com>,
        fabioaiuto83@gmail.com, hdegoede@redhat.com,
        straube.linux@gmail.com, linux@roeck-us.net,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 5.15 24/51] staging: rtl8723bs: Fix alignment to
 match open parenthesis
Message-ID: <YqH73xeDpPJki3hM@sashalap>
References: <20220607175552.479948-1-sashal@kernel.org>
 <20220607175552.479948-24-sashal@kernel.org>
 <ff5d5283af74576f65545399851a40cb4f16a85c.camel@perches.com>
 <YqA+mOYUNcYj59Cy@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YqA+mOYUNcYj59Cy@kroah.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 08, 2022 at 08:15:52AM +0200, Greg Kroah-Hartman wrote:
>On Tue, Jun 07, 2022 at 05:04:08PM -0700, Joe Perches wrote:
>> On Tue, 2022-06-07 at 13:55 -0400, Sasha Levin wrote:
>> > From: Soumya Negi <soumya.negi97@gmail.com>
>> >
>> > [ Upstream commit f722d67fad290b0c960f27062adc8cf59488d0a7 ]
>> >
>> > Adhere to Linux coding style. Fixes checkpatch warnings:
>> > CHECK: Alignment should match open parenthesis
>> > CHECK: line length of 101 exceeds 100 columns
>>
>> why should this be backported?  It's only whitespace changes.
>
>Good catch, it should not.

It shouldn't :/

Dropped, thanks!

-- 
Thanks,
Sasha
