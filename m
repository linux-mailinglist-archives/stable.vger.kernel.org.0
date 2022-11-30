Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B85BE63D3E9
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 12:05:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230105AbiK3LF4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 06:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230004AbiK3LFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 06:05:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7F712BB08;
        Wed, 30 Nov 2022 03:05:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7C63361B20;
        Wed, 30 Nov 2022 11:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD870C433D6;
        Wed, 30 Nov 2022 11:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669806353;
        bh=4Ub3C/+d/jdwoZ0TGuzEde0ZhlBroS9yrWnH1uEfPnI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ktfygm9w35Zx1Js1cyZE91al/U1Wvpd1MojuGyQS7c1q4BPT/UwOIznui3YAwZrZT
         ZmO/xCJFK6B3pCXliFTHDLxGz60pwsi5wEdcL0sZrdBmoSM+QWUwblfonM+xKmaKWJ
         QZIrW4+lsNbjIffoXRmLDsAXrYf3fV9AMJAtmKN6KBuh4VW0OYeegrLMFpxM8QxwPD
         IEAZMwGi+wTTg5Xl4lQCDa3wDm9zT54uZKvxZV0eYmOEOnLAOig/puHSv02Xu8N23x
         M13lDADuGbgYkyxUyhUi8072juDpMIKEVPq+brzOKmcTURkn2w3BBIEXS8j8lTZVrz
         UvhqkPehJVhxw==
Date:   Wed, 30 Nov 2022 06:05:52 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>, linux-block@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.15 23/31] block: make blk_set_default_limits()
 private
Message-ID: <Y4c5EJohWPv99e+K@sashalap>
References: <20221123124234.265396-1-sashal@kernel.org>
 <20221123124234.265396-23-sashal@kernel.org>
 <27f3a493-4684-7eee-b3af-fa1c70b492e0@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <27f3a493-4684-7eee-b3af-fa1c70b492e0@kernel.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 06:44:02AM -0700, Jens Axboe wrote:
>On 11/23/22 5:42 AM, Sasha Levin wrote:
>> From: Keith Busch <kbusch@kernel.org>
>>
>> [ Upstream commit b3228254bb6e91e57f920227f72a1a7d81925d81 ]
>>
>> There are no external users of this function.
>
>Please drop the 5.15 and earlier backports of this series, it's
>not needed.

Will do, thanks!

-- 
Thanks,
Sasha
