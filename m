Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A9225AD37E
	for <lists+stable@lfdr.de>; Mon,  5 Sep 2022 15:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236307AbiIENLu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Sep 2022 09:11:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237050AbiIENLr (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Sep 2022 09:11:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 880033B976;
        Mon,  5 Sep 2022 06:11:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29528B8114A;
        Mon,  5 Sep 2022 13:11:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B0FFC433D7;
        Mon,  5 Sep 2022 13:11:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662383501;
        bh=0KoIHBK6TZ30pk9Mzc3v0fq4THBgyx9DStM/RTjEVrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qu5WxvUPuUpDUahL6mmkBZQ2HWQNuu9krraJdb8uLwmNn3ddWAO9zO6epw0/UemOx
         HlKaWqR4iViaxbBUOHq1OzSMHibmwpUWX5Hi8yTWXlvHF552rSTrxlammY6DDhSWOg
         9Y2o7/xdggRj5VZdsuwV5tin7COd5TLtF8Jh3A3oMA9WohVR+iNyDouZtKypv2uSyh
         2LxxbDES0wcgz4aSKbL7Iod2qaEpYGNhbbWbpBHARsjyVvKGlYCAosS4lhgqjFxjv/
         34qnNBGdlWsmU4QoC7JRURnWT5JSytHcjMUr1Q29NpvqT9vnJyVT27ejjpcVXTVVfl
         vxsvw2sSZfg6Q==
Date:   Mon, 5 Sep 2022 09:11:40 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Toke =?iso-8859-1?Q?H=F8iland-J=F8rgensen?= <toke@toke.dk>
Cc:     stable-commits@vger.kernel.org,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S. Miller" <davem@davemloft.net>, stable@vger.kernel.org
Subject: Re: Patch "sch_cake: Return __NET_XMIT_STOLEN when consuming
 enqueued skb" has been added to the 4.19-stable tree
Message-ID: <YxX1jNpOCRkYlD1J@sashalap>
References: <20220905125828.1042711-1-sashal@kernel.org>
 <87sfl6yntg.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1; format=flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87sfl6yntg.fsf@toke.dk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 05, 2022 at 03:04:43PM +0200, Toke Høiland-Jørgensen wrote:
>Sasha Levin <sashal@kernel.org> writes:
>
>> This is a note to let you know that I've just added the patch titled
>>
>>     sch_cake: Return __NET_XMIT_STOLEN when consuming enqueued skb
>>
>> to the 4.19-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      sch_cake-return-__net_xmit_stolen-when-consuming-enq.patch
>> and it can be found in the queue-4.19 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>
>This patch was subsequently reverted; please drop it from all the stable
>trees. The patch to be backported instead is this one:

Yup, I took the revert too (makes tracking easier for us).

>9efd23297cca ("sch_sfb: Don't assume the skb is still around after enqueueing to child")

Looks like it's not in Linus's tree yet.

-- 
Thanks,
Sasha
