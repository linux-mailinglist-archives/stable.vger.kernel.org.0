Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FFE95B8E74
	for <lists+stable@lfdr.de>; Wed, 14 Sep 2022 20:00:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229893AbiINSAI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Sep 2022 14:00:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiINSAE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Sep 2022 14:00:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1727B7EF;
        Wed, 14 Sep 2022 11:00:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D88D61DD7;
        Wed, 14 Sep 2022 18:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE62CC433D7;
        Wed, 14 Sep 2022 18:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663178401;
        bh=/T/HGsyFeq6YUQ0uFTTthXz3ER0Xg8cFzCxncScQBd8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G37Trs8qORJpFcJKWa9ESzclCkLrA8b/y7RUFOwNhtqwLbhlt80K79qkCEaXsPxH4
         WHuGmty1RigKSf6qy5i5VVzrjpdCD2ZWmrP9+7YnSb8TYkgkJG7FeDXZpnKSr3R3dm
         w+Zfxy/7W0PZ2OAowK6qIpTQz6p93p0VHEcMPKiTuL9AWXYeFgcGJD9XRSoPKe5cjq
         kKPF9fpghwaH9kDt4vK6GD5jLRb9ooSBObGRYOPttXUtGIavLRtA3KtwegXIvAccdi
         kt8uvUwbRskkF/tpKdvAvO2Qe5llb3kPs8P4NhsF4x5UtUVxMvtmORkyjgaODmcNJm
         jnGjg/EpLvg3w==
Date:   Wed, 14 Sep 2022 13:59:57 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>, seanjc@google.com,
        mark.rutland@arm.com, elver@google.com, david.engraf@sysgo.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.15 14/23] arm64/signal: Raise limit on stack
 frames
Message-ID: <YyIWnWen7lXoYezR@sashalap>
References: <20220830172141.581086-1-sashal@kernel.org>
 <20220830172141.581086-14-sashal@kernel.org>
 <Yw5PgFEtUloKxRNQ@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Yw5PgFEtUloKxRNQ@sirena.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 30, 2022 at 06:58:09PM +0100, Mark Brown wrote:
>On Tue, Aug 30, 2022 at 01:21:31PM -0400, Sasha Levin wrote:
>> From: Mark Brown <broonie@kernel.org>
>>
>> [ Upstream commit 7ddcaf78e93c9282b4d92184f511b4d5bee75355 ]
>>
>> The signal code has a limit of 64K on the size of a stack frame that it
>> will generate, if this limit is exceeded then a process will be killed if
>
>I don't believe this is relevant to kernels without SME support.

Ack, I'll drop it.

-- 
Thanks,
Sasha
