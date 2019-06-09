Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6EA723AB98
	for <lists+stable@lfdr.de>; Sun,  9 Jun 2019 21:13:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbfFITNp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jun 2019 15:13:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:58550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729163AbfFITNp (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 9 Jun 2019 15:13:45 -0400
Received: from localhost (unknown [107.242.116.141])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D5D1E20673;
        Sun,  9 Jun 2019 19:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560107624;
        bh=JmotrYdFAxye6PwZuAv9hObxAW5kAZw7LHEmNKMpOwQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OyDhyEcqPyhvQ61dxNhvuSuOlF0Xi6XmpNgV75oiGcgLcI0dasuPztIm2pBkpMWSk
         IwJDRIDZD5HTHP12/+LX4tDMJ6AtOcqka9RchPuqEOUTX5/bZcrUzq2rN9PhIqGiaK
         p79jkAcdmiPYO9NN8mXWHPDhMJllyS4qS68f1IZ4=
Date:   Sun, 9 Jun 2019 15:13:37 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Andreas Ziegler <andreas.ziegler@fau.de>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: [PATCH AUTOSEL 5.1 058/186] tracing: probeevent: Fix to make the
 type of $comm string
Message-ID: <20190609191337.GA1552@sasha-vm>
References: <20190601131653.24205-1-sashal@kernel.org>
 <20190601131653.24205-58-sashal@kernel.org>
 <20190608173113.5fc866bf@oasis.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190608173113.5fc866bf@oasis.local.home>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 08, 2019 at 05:31:13PM -0400, Steven Rostedt wrote:
>On Sat,  1 Jun 2019 09:14:34 -0400
>Sasha Levin <sashal@kernel.org> wrote:
>
>> From: Masami Hiramatsu <mhiramat@kernel.org>
>>
>> [ Upstream commit 3dd1f7f24f8ceec00bbbc364c2ac3c893f0fdc4c ]
>>
>> Fix to make the type of $comm "string".  If we set the other type to $comm
>> argument, it shows meaningless value or wrong data. Currently probe events
>> allow us to set string array type (e.g. ":string[2]"), or other digit types
>> like x8 on $comm. But since clearly $comm is just a string data, it should
>> not be fetched by other types including array.
>>
>> Link: http://lkml.kernel.org/r/155723736241.9149.14582064184468574539.stgit@devnote2
>>
>> Cc: Andreas Ziegler <andreas.ziegler@fau.de>
>> Cc: Ingo Molnar <mingo@redhat.com>
>> Cc: stable@vger.kernel.org
>> Fixes: 533059281ee5 ("tracing: probeevent: Introduce new argument fetching code")
>
>I thought the "AUTOSEL" patches are to find patches that are not marked
>for stable and pull them in. It would be good to differentiate those in
>the subject. As I'm more inclined to audit automatically pulled in ones,
>because those are more likely to be incorrectly backported.

That's indeed the case. I had some experimental changes for this merge
window and apparently some stable tagged patches ended up sneaking in.
Sorry about that!.

--
Thanks,
Sasha
