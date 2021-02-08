Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 20F6D313E41
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 19:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232766AbhBHS6B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 13:58:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:33724 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235979AbhBHS5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 13:57:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 77B3E64E5A;
        Mon,  8 Feb 2021 18:57:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612810628;
        bh=+k2L5T8rooOqlrQ/b0zqgwOePzl/bojtsFWBr/fBYrE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m+tP6MxXMWby7nCMbeU5nvg3u7C13ljcHPv7d8GKchCud7IqgJYnnRn9+22FEhZq6
         BeNJnn3ok8r9Inpb4g7nBuTkbK6CmGzGGez1C0walGXN89E6cQ4jMM9iM5XiBjVvuA
         vxguyyKm/8O40MVju1HJEh0eT4CDCwGKc2wcSE0BprZkL113rw4e+USVD+inPUgUfG
         OYP6nXksKKroYPtHFnb84MagufKCxB9EqL3pwlnorMbbcqVYswkKK10NTRJYMU1LQv
         aESsmUbsguW1ZygRXi91DeUA7gvyrkvEoQ2Mr7UBJ7qcJlg4Ud9IESwDN0qmswy5D9
         HyM7rVxLziqCA==
Date:   Mon, 8 Feb 2021 13:57:07 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Avi Kivity <avi@scylladb.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org, lwn@lwn.net,
        jslaby@suse.cz
Subject: Re: Linux 4.9.256
Message-ID: <20210208185707.GC4035784@sasha-vm>
References: <1612535085125226@kroah.com>
 <23a28990-c465-f813-52a4-f7f3db007f9d@scylladb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <23a28990-c465-f813-52a4-f7f3db007f9d@scylladb.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 08, 2021 at 05:50:21PM +0200, Avi Kivity wrote:
>On 05/02/2021 16.26, Greg Kroah-Hartman wrote:
>>I'm announcing the release of the 4.9.256 kernel.
>>
>>This, and the 4.4.256 release are a little bit "different" than normal.
>>
>>This contains only 1 patch, just the version bump from .255 to .256 which ends
>>up causing the userspace-visable LINUX_VERSION_CODE to behave a bit differently
>>than normal due to the "overflow".
>>
>>With this release, KERNEL_VERSION(4, 9, 256) is the same as KERNEL_VERSION(4, 10, 0).
>
>
>I think this is a bad idea. Many kernel features can only be 
>discovered by checking the kernel version. If a feature was introduced 
>in 4.10, then an application can be tricked into thinking a 4.9 kernel 
>has it.
>
>
>IMO, better to stop LINUX_VERSION_CODE at 255 and introduce a 

In the upstream (and new -stable fix) we did this part.

>LINUX_VERSION_CODE_IMPROVED that has more bits for patchlevel.

Do you have a usecase where it's actually needed? i.e. userspace that
checks for -stable patchlevels?

-- 
Thanks,
Sasha
