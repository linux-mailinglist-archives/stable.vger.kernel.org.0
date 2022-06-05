Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9553C53DBB8
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 15:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbiFENkN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 09:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343834AbiFENkM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 09:40:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A3B4022B0C;
        Sun,  5 Jun 2022 06:40:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 659EAB80735;
        Sun,  5 Jun 2022 13:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C63D4C385A5;
        Sun,  5 Jun 2022 13:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654436409;
        bh=NwObenWbHO817AcTNpCBYS8i6ub6XU64uqzXl/+yLE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j6kYgd7n2jn3qs9IqmVReQcLWMBTH7vn27O+sxeFVNb5yEOFd5OU44wMcgn8ifkZz
         cg2MWStQOFkr5bbnEyCgDJE8MNT+vY4YRlfVfK5zr4iw4JfBV4xWB7M0RCT01lsgkf
         nLJeoalUm5C5Cz/Y1+ORyR6C8fu4HsFUFvydB5rjNnprL8cR7KyllDxx7wHLs9pt1L
         howxitaOjoX1GjwTT0qyAOzGOwoMz7Qh3Zpz+sgTSN7rRGdeNheFWwqFUPIPtG0z6L
         YPzYXkbgsAM+kgEJ896VuPGu69QYOrdh0We1duDEnX1M57VA/3cHSuS/VFPJI/rfJC
         v66Q8FtGJUi6A==
Date:   Sun, 5 Jun 2022 09:40:07 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Shaopeng Tan <tan.shaopeng@jp.fujitsu.com>,
        Fenghua Yu <fenghua.yu@intel.com>,
        Shuah Khan <skhan@linuxfoundation.org>, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.9 03/11] selftests/resctrl: Change the default
 limited time to 120 seconds
Message-ID: <YpyyN5OBWAE2O4cX@sashalap>
References: <20220601140100.2005469-1-sashal@kernel.org>
 <20220601140100.2005469-3-sashal@kernel.org>
 <55ef4461-75b5-4c1b-90b5-17909ec58f25@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <55ef4461-75b5-4c1b-90b5-17909ec58f25@intel.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jun 01, 2022 at 10:19:45AM -0700, Reinette Chatre wrote:
>Dear Stable Team,
>
>I received the below notice about this commit being considered for
>4.9 as well as other notices for it being considered for 4.14, 4.19,
>5.4, 5.10, 5.15, 5.17, and 5.18.
>
>I do not believe this commit is appropriate for stable because:
>- It forms part of a series and without the other accompanying patches
>  from that series it does not do anything. Series is at:
>  https://lore.kernel.org/lkml/20220323081227.1603991-1-tan.shaopeng@jp.fujitsu.com/
>- The original series was not not submitted for inclusion to stable and
>  none of its patches have a Fixes: tag.
>- The series this patch forms part of aims to port resctrl_tests to the
>  kselftest framework and I do not believe such a change matches stable
>  criteria.

Sure, I'll drop it, thanks!

-- 
Thanks,
Sasha
