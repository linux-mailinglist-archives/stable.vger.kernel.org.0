Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341DEB9F95
	for <lists+stable@lfdr.de>; Sat, 21 Sep 2019 21:21:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388019AbfIUTVK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 21 Sep 2019 15:21:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:49462 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387853AbfIUTVK (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 21 Sep 2019 15:21:10 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D9EF206B6;
        Sat, 21 Sep 2019 19:21:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569093669;
        bh=j0to6bgCUsZE0XxIyWSeuw/6QHjOGtUvrMcN8EFYmK4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=omT7YqoxJ29+diKTG/rBh1gGynceLLK2NZmgblVXO3coic6tCvrRB5ytdBKVflgBA
         u+4oyWS9arHhMrhVca2GO8gHA4nez5FhP4TgjliLUKDJYnmUpYbj4fkDVHa681R/X+
         FmY9A/cmEtGWeZsIGc/om28tQKqrETrOFvPpUAKE=
Date:   Sat, 21 Sep 2019 15:21:08 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     Tom Zanussi <zanussi@kernel.org>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        linux-rt-users <linux-rt-users@vger.kernel.org>,
        stable@vger.kernel.org
Subject: Re: [for-next][PATCH 3/8] tracing: Make sure variable reference
 alias has correct var_ref_idx
Message-ID: <20190921192108.GB8171@sasha-vm>
References: <20190919232359.825502403@goodmis.org>
 <20190921120618.DF81120665@mail.kernel.org>
 <20190921082035.4fc9ccc5@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190921082035.4fc9ccc5@oasis.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Sep 21, 2019 at 08:20:35AM -0400, Steven Rostedt wrote:
>On Sat, 21 Sep 2019 12:06:18 +0000
>Sasha Levin <sashal@kernel.org> wrote:
>
>> Hi,
>>
>> [This is an automated email]
>>
>> This commit has been processed because it contains a "Fixes:" tag,
>> fixing commit: .
>>
>> The bot has tested the following trees: v5.2.16, v4.19.74, v4.14.145, v4.9.193, v4.4.193.
>
>
>The fixes tag is 7e8b88a30b085 which was added to mainline in 4.17.
>According to this email, it applies fine to 5.2 and 4.19, but fails on
>4.14 and earlier. As the commit was added in 4.17 that makes perfect
>sense. Can you update your scripts to test when the fixes commit was
>added, and not send spam about it not applying to stable trees where
>it's not applicable.

The script already does that. What happened here is that it got confused
with your previous "Fixes:" statement in the commit message and went
haywire.

I thought that something like this shouldn't happen because I grep for
"^fixes:", but looks like something is broken. I'll go fix that...


--
Thanks,
Sasha
