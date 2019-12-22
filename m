Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB53128E48
	for <lists+stable@lfdr.de>; Sun, 22 Dec 2019 15:09:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbfLVOJO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Dec 2019 09:09:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725840AbfLVOJO (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Dec 2019 09:09:14 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF67F20665;
        Sun, 22 Dec 2019 14:09:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577023754;
        bh=bhQCmTd6uPrYtfjNQ+koPnXgX3BtvmoqIvQV8KEIoX4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i7uX8uPurHtNWQOosuO59PaVc5xX8qKzKIVrpntKKLUSy9X2ItNqynyn5givsWgG6
         d/gs6r/lBuk7g65hUEZ7cgC7TZWylC3FEWHVLY8TzrtGIaLu4oWek+BTntf0cmzBpc
         Fq6iNgxjBOWnXjJr9N6DDSdStaoMOqmWLdClG0AE=
Date:   Sun, 22 Dec 2019 09:09:12 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     stable <stable@vger.kernel.org>
Subject: Re: Patch "selftests: Fix O= and KBUILD_OUTPUT handling for relative
 paths" has been added to the 5.4-stable tree
Message-ID: <20191222140912.GX17708@sasha-vm>
References: <20191222024605.7B3862070B@mail.kernel.org>
 <CAKRRn-fz2xwXM6VperN3KOFcqHKMrGuLFzopmZfsWaqrv0txqQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAKRRn-fz2xwXM6VperN3KOFcqHKMrGuLFzopmZfsWaqrv0txqQ@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 21, 2019 at 09:54:30PM -0700, Shuah Khan wrote:
>On Sat, Dec 21, 2019, 7:46 PM Sasha Levin <sashal@kernel.org> wrote:
>
>> This is a note to let you know that I've just added the patch titled
>>
>>     selftests: Fix O= and KBUILD_OUTPUT handling for relative paths
>>
>> to the 5.4-stable tree which can be found at:
>>
>> http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>      selftests-fix-o-and-kbuild_output-handling-for-relat.patch
>> and it can be found in the queue-5.4 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>>
>
>Hi Sasha,
>
>Please don't add this commit. It broke stable workflows.

I'll drop it.

-- 
Thanks,
Sasha
