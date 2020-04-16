Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF1851AB615
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 05:09:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389135AbgDPDJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Apr 2020 23:09:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:48632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388679AbgDPDJI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 15 Apr 2020 23:09:08 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5FE0E2072D;
        Thu, 16 Apr 2020 03:09:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587006548;
        bh=iWZRq6tWLslJqU+dIvBTOVdHi3+1e7pVb4r0dKHaO4s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rIfjd/Nt+sqtmnfJiZdFp2lP90Sr6J0OmO217RZtNJ66ErsxwB4Xel0lpaJF6b4/D
         ToyJG9epbcrQp0wn3UQPbxKWUVO3X9T57PcSrv/DcW6r1YnaCZlntaV3myNKmdRSAC
         MpPP1ISI2AoqkZKIkHSDvDdUNW+oREiWyzugYiBw=
Date:   Wed, 15 Apr 2020 23:09:07 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     gregkh@linuxfoundation.org, mhiramat@kernel.org,
        treeze.taeung@gmail.com, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] ftrace/kprobe: Show the maxactive number
 on kprobe_events" failed to apply to 4.19-stable tree
Message-ID: <20200416030907.GD1068@sasha-vm>
References: <158695112724822@kroah.com>
 <20200415151400.2347497b@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200415151400.2347497b@gandalf.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Apr 15, 2020 at 03:14:00PM -0400, Steven Rostedt wrote:
>On Wed, 15 Apr 2020 13:45:27 +0200
><gregkh@linuxfoundation.org> wrote:
>
>> The patch below does not apply to the 4.19-stable tree.
>> If someone wants it applied there, or to any other stable or longterm
>> tree, then please email the backport, including the original git commit
>> id to <stable@vger.kernel.org>.
>>
>> thanks,
>>
>> greg k-h
>>
>>
>
>This should apply to both 4.14 and 4.19 and fix the same issue:

Queued up for 4.19 and 4.14, thanks Steve!

-- 
Thanks,
Sasha
