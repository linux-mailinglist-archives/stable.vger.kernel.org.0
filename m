Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22986B01FB
	for <lists+stable@lfdr.de>; Wed, 11 Sep 2019 18:49:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbfIKQth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Sep 2019 12:49:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728794AbfIKQtg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Sep 2019 12:49:36 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF7DB20838;
        Wed, 11 Sep 2019 16:49:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568220576;
        bh=A2qAhsh3sOP7/ZiAL5HFy5Kd2qFX1x6e0g1DcVMInck=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=d0phoVz/WDpRXrAtZqI15eMbMMYP+VvHHa50f8m8haGoryO/DyQ0PJgGmwdh/9Zml
         LNfKh5LH4/+LcKy5eJsuACz45n3IBz4OFtG1pAxbmftPTFPbxQHlVsJLp7odVlC8m2
         0E36ifK+zxduTE1nKpzyoZfucFObvhvoJQnHBwYo=
Date:   Wed, 11 Sep 2019 12:49:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Ricardo Biehl Pasquali <pasqualirb@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Patch "ALSA: pcm: Return 0 when size < start_threshold in
 capture" has been added to the 4.19-stable tree
Message-ID: <20190911164934.GO2012@sasha-vm>
References: <20190911093035.57F102089F@mail.kernel.org>
 <20190911141431.GA21115@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20190911141431.GA21115@localhost.localdomain>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 11, 2019 at 11:14:31AM -0300, Ricardo Biehl Pasquali wrote:
>On Wed, Sep 11, 2019 at 05:30:33AM -0400, Sasha Levin wrote:
>> This is a note to let you know that I've just added the patch titled
>>
>>     ALSA: pcm: Return 0 when size < start_threshold in capture
>>
>> to the 4.19-stable tree which can be found at:
>>     http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      alsa-pcm-return-0-when-size-start_threshold-in-captu.patch
>> and it can be found in the queue-4.19 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>
>Hi Sasha.
>
>This patch was reverted by the commit 932a81519572156a88db
>("ALSA: pcm: Comment why read blocks when PCM is not
>running"):
>
>  This avoids bringing back the problem introduced by
>  62ba568f7aef ("ALSA: pcm: Return 0 when size <
>  start_threshold in capture") and fixed in 00a399cad1a0
>  ("ALSA: pcm: Revert capture stream behavior change in
>  blocking mode"), which prevented the user from starting
>  capture from another thread.
>
>Should this be queued anyway? If yes, I think it should also
>be queued the fix and the commit above.

Nope, I'll drop it. Thank you.

--
Thanks,
Sasha
