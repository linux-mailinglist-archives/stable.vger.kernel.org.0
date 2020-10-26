Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46353298F8D
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 15:40:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1781774AbgJZOkM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 10:40:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:34050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1781716AbgJZOir (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 10:38:47 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B24A2168B;
        Mon, 26 Oct 2020 14:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603723126;
        bh=fp8FOSTLzAGidjBmcX0gce8ZpATV3xb1M66KolKs7ZQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hp1sSxz9VFVINDLknV3ARyIoScW+rvyXVcpXHXFS1vQh0FPmimWwsf1h5llleSTUz
         UNH0jWQh9YiUxf+ZYjWDlwH68Ftwi0GHgzKoSW0CMFHSMdd2ZvFJM0LoBQxNgLr3aN
         CysTI6KICMy0/6ni1ZpMSGxfttNzPmP2jFT6jAKw=
Date:   Mon, 26 Oct 2020 10:38:45 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     stable-commits@vger.kernel.org,
        linux-stable <stable@vger.kernel.org>
Subject: Re: Patch "drm/radeon: Prefer lower feedback dividers" has been
 added to the 5.9-stable tree
Message-ID: <20201026143845.GL4060117@sasha-vm>
References: <20201026050946.9E8B6223FD@mail.kernel.org>
 <C64F56FE-C10A-4F1B-B80C-2F0634E79222@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <C64F56FE-C10A-4F1B-B80C-2F0634E79222@canonical.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26, 2020 at 01:13:28PM +0800, Kai-Heng Feng wrote:
>Hi Sasha,
>
>> On Oct 26, 2020, at 13:09, Sasha Levin <sashal@kernel.org> wrote:
>>
>> This is a note to let you know that I've just added the patch titled
>>
>>    drm/radeon: Prefer lower feedback dividers
>>
>> to the 5.9-stable tree which can be found at:
>>    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary
>>
>> The filename of the patch is:
>>     drm-radeon-prefer-lower-feedback-dividers.patch
>> and it can be found in the queue-5.9 subdirectory.
>>
>> If you, or anyone else, feels it should not be added to the stable tree,
>> please let <stable@vger.kernel.org> know about it.
>
>Please drop this patch because it causes some regression.

Will do, thanks!

-- 
Thanks,
Sasha
