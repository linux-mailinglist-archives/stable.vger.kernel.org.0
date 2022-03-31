Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E27544EDF2F
	for <lists+stable@lfdr.de>; Thu, 31 Mar 2022 18:57:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233620AbiCaQ7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 31 Mar 2022 12:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232806AbiCaQ7B (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 31 Mar 2022 12:59:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AF6F232128;
        Thu, 31 Mar 2022 09:57:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E73726142F;
        Thu, 31 Mar 2022 16:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DFC5C340ED;
        Thu, 31 Mar 2022 16:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648745833;
        bh=yA9+KO3O1jARWOMC2omd2MhcSPzFCNmSUyJCd+gNn5k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YyrGUdd2nxSYfhkeKX3ilGPHF0K/NKNqDhtBxYKuTvilMs+v4PDJHBHdS70CpkWAA
         LkzOitfAYtjD0P6FyA+SRCf+cRx66nvFwcIsHTpU+lwfsuelaEx7x80Kz/aKD6q4Ed
         7PVFdJwnBgoMxzSOo0Tnz4h9VmyQXV91vankcSQHeOq03QdyKnU37NNgfO1srcFWzC
         90B31pN3MovVSXMEukmzMvSRnDAcS1UIarVp8+avBU701s45i93Me7EqA0+3G74v1o
         pHDdVKGi4iPGy50KExpkCgm2oUrcfUHvsw32vawjO1ROvlrIgzn7pWRyThe4jcCpOb
         M5afp23LU6VLw==
Date:   Thu, 31 Mar 2022 12:57:12 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>, lgirdwood@gmail.com,
        perex@perex.cz, tiwai@suse.com, alsa-devel@alsa-project.org
Subject: Re: [PATCH AUTOSEL 5.17 64/66] ASoC: ak4642: Use
 of_device_get_match_data()
Message-ID: <YkXdaOOHd7w5OPG0@sashalap>
References: <20220330114646.1669334-1-sashal@kernel.org>
 <20220330114646.1669334-64-sashal@kernel.org>
 <YkRHhksDIqDpHoCz@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YkRHhksDIqDpHoCz@sirena.org.uk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 30, 2022 at 01:05:26PM +0100, Mark Brown wrote:
>On Wed, Mar 30, 2022 at 07:46:43AM -0400, Sasha Levin wrote:
>> From: Minghao Chi <chi.minghao@zte.com.cn>
>>
>> [ Upstream commit 835ca59799f5c60b4b54bdc7aa785c99552f63e4 ]
>>
>> Use of_device_get_match_data() to simplify the code.
>
>This is just a random code style improvement, I can't see why we'd
>backport it to stable?

Yup, I'll drop it.

-- 
Thanks,
Sasha
