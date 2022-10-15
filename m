Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 21BFA5FF9CB
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 13:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229595AbiJOLYr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Oct 2022 07:24:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbiJOLYp (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Oct 2022 07:24:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12ED1140FB
        for <stable@vger.kernel.org>; Sat, 15 Oct 2022 04:24:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 825FB60AB4
        for <stable@vger.kernel.org>; Sat, 15 Oct 2022 11:24:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCA77C433D6;
        Sat, 15 Oct 2022 11:24:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665833079;
        bh=MF/Vg0bJ/1V+mRDQpkPPQYoHFQ4d7vodoZnPmh8rtAo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eEkYLQqcXeNpro0PRydUnoKotH1NGqt+Lhye3kvsSuA6iu+/QcaViF+h6oN/CfC56
         BidMT0HCj143aXeXBvLBkyYSeWKkUlfWya0Vbv9kVgoNu70WaFHryZq7PzbKfrCtIk
         tzE13SWfvZ+Me2IS80/+IOuHVgsabvgf1mGgaayxFTDI8nRLhRlMFUGOXCPrFsvhsl
         ZsDaJVZ44MPriSUUFmHwiWorhd1JXJ/sieJNOQ5L62sZ1JAG9fo2DqPFvcx9iEK8PZ
         vwGE9jpfXocGMNrH/zISbtLmJpDsbuQkIjvYme5Hww1fz5vJDytkHYpXbQ/2iQ+u10
         ENbpiHg/Efdkw==
Date:   Sat, 15 Oct 2022 07:24:38 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Tyler Hicks <code@tyhicks.com>
Cc:     gregkh@linuxfoundation.org, stable@vger.kernel.org
Subject: Re: Process question about dropped patches
Message-ID: <Y0qYdgC2L5twjfoW@sashalap>
References: <20221014205503.3w2ge6srfpk6gtlt@sequoia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20221014205503.3w2ge6srfpk6gtlt@sequoia>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 14, 2022 at 03:55:03PM -0500, Tyler Hicks wrote:
>Hey Greg and Sasha - I'm starting to think through how I can monitor for
>dropped stable patches that touch certain file paths in order to help
>out with backporting. I've come across a few examples where Greg's
>automated emails point out that the patch couldn't be applied to a
>certain series but then the patch shows up in a future -rc release
>without anyone submitting a fixed backport to the list. An example:
>
>FAILED email: https://lore.kernel.org/stable/1664091338227131@kroah.com/
>-rc review email: https://lore.kernel.org/stable/20221003070722.143782710@linuxfoundation.org/
>
>Is this just a case of one of you manually doing the backports (or
>dependency resolution) yourselves or are folks directly sending you
>backports?
>
>This isn't a problem for me, BTW. I just want to make sure that I
>understand the process. Thanks!

If there's nothing on the mailing list, it's usually me fixing up
dropped patches.

In the example above, you can see I took an additional patch right
before the one you've linked to make things work.

I think that the only exception are the occasional "security" patches
that happen off list and take some time to get backported.

-- 
Thanks,
Sasha
