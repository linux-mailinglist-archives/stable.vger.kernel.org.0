Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DED035B2B77
	for <lists+stable@lfdr.de>; Fri,  9 Sep 2022 03:22:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229819AbiIIBWZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 21:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiIIBWY (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 21:22:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05BD3F3BC0;
        Thu,  8 Sep 2022 18:22:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98BE1B82343;
        Fri,  9 Sep 2022 01:22:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01CF9C433B5;
        Fri,  9 Sep 2022 01:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662686539;
        bh=oeH1x7dHn1Z0LiTcj7X80mFWim+HBQmk4M3FrY+7H7I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OdzvccavgAlYFTW+7olM/9nTD/R1tRMymSFa2cTIHmnrJz2jAg66Xfiayj4H8SQb5
         5AlyhP8JfKeQBsSLm+z/8PjTLOwDeRvnJVNQlDutvJbahvBRuRpXe5BslD/zb84875
         P8XkLMkWeJc1co2n+NOw/m7v+6NiCkz7f4MaCDiwORUPMV22w/I/r4KcmuEW1RYGjR
         X+oum8FOEJCXuWrNF2Nmve6nUqi53cGCVy+2qQ4M6egnZKi0/uieirydzgERC1y4kc
         iPN5sK3k2Y/babc5+gI86zsVqag7icJA9LAicSPAWrBEIBAjXS3HMytc6nTfMWkBX3
         ra5JGuuMcotuQ==
Date:   Thu, 8 Sep 2022 21:22:17 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     Jean Delvare <jdelvare@suse.de>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.19 01/33] firmware: dmi: Use the proper
 accessor for the version field
Message-ID: <YxqVSV5IVyLZe0vu@sashalap>
References: <20220830171825.580603-1-sashal@kernel.org>
 <20220830233237.0c08cc7e@endymion.delvare>
 <Yw9LAbjrzoseziT7@smile.fi.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Yw9LAbjrzoseziT7@smile.fi.intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 31, 2022 at 02:50:25PM +0300, Andy Shevchenko wrote:
>On Tue, Aug 30, 2022 at 11:32:37PM +0200, Jean Delvare wrote:
>> On Tue, 30 Aug 2022 13:17:52 -0400, Sasha Levin wrote:
>> > From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
>> >
>> > [ Upstream commit d2139dfca361a1f5bfc4d4a23455b1a409a69cd4 ]
>> >
>> > The byte at offset 6 represents length. Don't take it and drop it
>> > immediately by using proper accessor, i.e. get_unaligned_be24().
>> >
>> > [JD: Change the subject to something less frightening]
>>
>> Nack. This is NOT a bug fix, there's simply no reason to backport
>> this to stable kernel trees.
>
>Agree.

I'll drop it, thanks.

-- 
Thanks,
Sasha
