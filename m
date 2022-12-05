Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AF0E6420E4
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 01:57:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231175AbiLEA5d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Dec 2022 19:57:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230483AbiLEA5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Dec 2022 19:57:32 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A0B6B859
        for <stable@vger.kernel.org>; Sun,  4 Dec 2022 16:57:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 137FBB80D2C
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 00:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88752C433C1;
        Mon,  5 Dec 2022 00:57:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670201848;
        bh=ysbPfPIEZBsV8t3hJS18Jy4c7blSVWMNeGdyX6u4a+8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vJg4LO02rd1wymBCc4/46bokSpwSvc/2+M2DaBEd/meaVMgPQPVNEqWOeXzH2J/64
         ei7fPOX4FZYTw22eXt2CSH8zxGjFDcu+2PhyZnHv0ZgBiBj3dEnhDE4XweQ2frtjkG
         ww2lzOeIdOUwAM06WlX+8MFEX7+W8kErt0Ll/8u4L+lHLKnT+0rETbbPd/VPMN3E2v
         kYty76y77TMTvTNCIcSSfTrS3J6R1kJdtrnc72gVpF90UgeNe+55khXkUIEmKCy4Vi
         GHGlzqdQblACGD/arvUWmC2qmWag3ACy7FyPxL3utlWLyS5HO3lVur/GsvdVZCmHcA
         Oi1Y9pN9KFmDQ==
Date:   Sun, 4 Dec 2022 19:57:26 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Steven Rostedt <rostedt@goodmis.org>, akpm@linux-foundation.org,
        mhiramat@kernel.org, yujie.liu@intel.com, zhengyejian1@huawei.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] tracing: Free buffers when a used dynamic
 event is removed" failed to apply to 4.19-stable tree
Message-ID: <Y41B9nmN0RL3RNYi@sashalap>
References: <167006641591124@kroah.com>
 <20221203173655.1b1b2fac@gandalf.local.home>
 <Y4xYg2i7lS6z3eIe@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y4xYg2i7lS6z3eIe@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Dec 04, 2022 at 09:21:23AM +0100, Greg KH wrote:
>On Sat, Dec 03, 2022 at 05:36:55PM -0500, Steven Rostedt wrote:
>> On Sat, 03 Dec 2022 12:20:15 +0100
>> <gregkh@linuxfoundation.org> wrote:
>>
>> > The patch below does not apply to the 4.19-stable tree.
>> > If someone wants it applied there, or to any other stable or longterm
>> > tree, then please email the backport, including the original git commit
>> > id to <stable@vger.kernel.org>.
>> >
>> > Possible dependencies:
>> >
>> > 4313e5a61304 ("tracing: Free buffers when a used dynamic event is removed")
>>
>> Hmm, isn't the above the patch that failed to apply?
>
>yes, tools are not the smartest at times :)

It's just what the script does: it always lists the commit we actually
want to apply, makes it easier for the rest of my scripts :)

-- 
Thanks,
Sasha
