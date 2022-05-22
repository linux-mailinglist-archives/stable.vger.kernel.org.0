Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6CB75304B7
	for <lists+stable@lfdr.de>; Sun, 22 May 2022 18:34:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbiEVQeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 May 2022 12:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229667AbiEVQeK (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 22 May 2022 12:34:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2103129823;
        Sun, 22 May 2022 09:34:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B818C61042;
        Sun, 22 May 2022 16:34:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E83F2C385AA;
        Sun, 22 May 2022 16:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653237248;
        bh=75JbfUJVbq8m89bwVZv50lhiY0elfyZiVby6AgbgJVI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q4pviJzlASGdz7iwoURgPIVQZlItbHjjG0X92g09VPPj//3PMb4FL0/AOzXzDzkMm
         Y79sGeRGW9jYhzmW9tJ+N1PBe/X8xPlX3EPSHeUJoVKtqZZ1IFMSeuTYfE8qLfxtFe
         62djGKHBzGeMTYr9AsdvPXaHF/f7gb+uk6LmWpXEV3GI5omINpuj8LC3V9qvgI+6NM
         YrHXQ7MpYySdj52P1N3pDJ4S/DgHJw6HD88E+tx+xLOqNVtXk3JUPPd3y83cqbBRHC
         vxaQJJva/j6Bl2yC2/L1voazwcsy6tD+O94c144Ysh1345bLUEKloTM3Rgv+pTUNM9
         hgC48hLvR5ZWg==
Date:   Sun, 22 May 2022 12:34:06 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Glenn Washburn <development@efficientek.com>
Cc:     stable@vger.kernel.org, stable-commits@vger.kernel.org,
        Jeff Dike <jdike@addtoit.com>,
        Richard Weinberger <richard@nod.at>
Subject: Re: Patch "um: port_user: Improve error handling when port-helper is
 not found" has been added to the 5.17-stable tree
Message-ID: <Yopl/v3SQoaaPmUJ@sashalap>
References: <20220519135207.392505-1-sashal@kernel.org>
 <20220520140515.35ab0497@crass-HP-ZBook-15-G2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220520140515.35ab0497@crass-HP-ZBook-15-G2>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, May 20, 2022 at 02:05:15PM -0500, Glenn Washburn wrote:
>Resending this because stable@vger.kernel.org using wrong header field.
>Apologize for duplicates.
>
>On Thu, 19 May 2022 09:52:07 -0400
>Sasha Levin <sashal@kernel.org> wrote:
>
>> This is a note to let you know that I've just added the patch titled
>>
>>     um: port_user: Improve error handling when port-helper is not found
>>
>> to the 5.17-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      um-port_user-improve-error-handling-when-port-helper.patch
>> and it can be found in the queue-5.17 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>
>First, I should say that I'm not familiar with the process so I'm
>likely to be wrong on any number of things. Second I'm the author of
>this patch and I would like to see this included in the stable trees.
>However, it appears to me that there is a problem in including just this
>patch, as it depends on a previous patch which does not appear to be
>applied[1].

Right, I've dropped it.

>The the afore mentioned patch that this patch depends on "env" is
>declared and set. Without it, I'd expect this to fail to compile. As
>such, I may be wrong in that the dependent patch was not already
>included because I'd expect there to have been a compile test prior to
>this patch getting to this phase.
>
>My suspicion is that the stable trees try to not include new
>functionality, which the missing patch may have been considered to have
>done, and thus was not included. If its deemed undesirable to include
>the missing patch, this "if" block can be removed. Although, I think
>the missing patch is valuable enough to include.
>
>The above goes for all the stable branches that this patch is set to be
>included in.

Could you provide a list of patches that are needed here?

-- 
Thanks,
Sasha
