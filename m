Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C607516780
	for <lists+stable@lfdr.de>; Sun,  1 May 2022 21:33:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353936AbiEATfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 May 2022 15:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357362AbiEATff (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 May 2022 15:35:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48925527EE;
        Sun,  1 May 2022 12:32:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9F62B80EF0;
        Sun,  1 May 2022 19:32:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 808AFC385A9;
        Sun,  1 May 2022 19:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651433522;
        bh=g7jlHPWeLM6Q7NEChcAELzEahFuYps1ugv49wmKn2zY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GMO6QTlMZHkU+L8stOdjIjyb2hFSs8H19LXHq1Vmq+xBvlxLNbie8cJcokuUjE3Ya
         8F7jZw8y4DQDHSEClk7wMMt8FK4lJqVd7Idd9M4go+j/xLN0GV5AXC8d2Xe4PqmE/7
         lDi4s0XVg1IXpiVdaC3abQGvFJlLItv5SpPnNGdcCrOBLQRDfvhZooUDetuH0pBrF4
         /fhxz2w+8r0sM3A7Gje+Ff09GFGdF8gb7ieiDHPfL1vV1DuV1mnq4ISUrLZnU1R2a4
         4sqmInBkTD6gRIkaXOodmYpQkOQ1uVyGjGi5ic4bdaw+8J9bunF8FxBUTET2YxRxRD
         /3GQByoMk+oIA==
Date:   Sun, 1 May 2022 15:32:01 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        cezary.rojewski@intel.com, liam.r.girdwood@linux.intel.com,
        yang.jie@linux.intel.com, perex@perex.cz, tiwai@suse.com,
        peter.ujfalusi@linux.intel.com, yung-chuan.liao@linux.intel.com,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.17 06/22] ASoC: Intel: sof_es8336: Add a quirk
 for Huawei Matebook D15
Message-ID: <Ym7gMZRI7ad6u0fL@sashalap>
References: <20220426190145.2351135-1-sashal@kernel.org>
 <20220426190145.2351135-6-sashal@kernel.org>
 <Ymko4F24MvbGJUXp@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Ymko4F24MvbGJUXp@sirena.org.uk>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 27, 2022 at 12:28:32PM +0100, Mark Brown wrote:
>On Tue, Apr 26, 2022 at 03:01:29PM -0400, Sasha Levin wrote:
>> From: Mauro Carvalho Chehab <mchehab@kernel.org>
>>
>> [ Upstream commit c7cb4717f641db68e8117635bfcf62a9c27dc8d3 ]
>>
>> Based on experimental tests, Huawei Matebook D15 actually uses
>> both gpio0 and gpio1: the first one controls the speaker, while
>> the other one controls the headphone.
>
>Are you sure this doesn't need the rest of the series it came along
>with?

I'm not :) Should we queue it too?

-- 
Thanks,
Sasha
