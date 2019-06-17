Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 058964850D
	for <lists+stable@lfdr.de>; Mon, 17 Jun 2019 16:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728036AbfFQOOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jun 2019 10:14:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47984 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727690AbfFQOOh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Jun 2019 10:14:37 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0D812084B;
        Mon, 17 Jun 2019 14:14:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560780877;
        bh=GN7MGLfcIBYwDeKmz6MmS+SeGiI8qBeWfj6svyY2hXE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UNbFxms5HtNYD91rETHxuPNW0ku/3nrP9cWeW/kzkg4C5vs1mf59GQ5I0b1CmNfDm
         T03LY67SnEGQoXaNnp6YpcY42GAcccO8IF3SWsdfFjFCIBeAEu7wZ3YfGhptFat+J5
         9qXTwBAZXalHtMkzHSbR4dHkbyXoCYHVffa2H9TM=
Date:   Mon, 17 Jun 2019 10:14:35 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     "Eric W. Biederman" <ebiederm@xmission.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>, avagin@gmail.com,
        linux- stable <stable@vger.kernel.org>,
        lkft-triage@lists.linaro.org,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>
Subject: Re: stable-rc: ptrace: peeksiginfo failed on 4.19, 4.14, 4.9 and 4.4
Message-ID: <20190617141435.GB2226@sasha-vm>
References: <CA+G9fYsFL5AH6dkdN2Qd6UP=wdiXRDR_ioQFPSCq=uUBcmtHXw@mail.gmail.com>
 <87lfy0pd63.fsf@xmission.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <87lfy0pd63.fsf@xmission.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 17, 2019 at 08:13:56AM -0500, Eric W. Biederman wrote:
>Naresh Kamboju <naresh.kamboju@linaro.org> writes:
>
>> selftests: ptrace: peeksiginfo failed on x86_64, i386, arm64 and arm.
>> FAILED on stable rc branches 4.19, 4.14, 4.9 and 4.4.
>> PASS on mainline, next and 5.1 stable rc branch.
>
>Greg.
>
>Looking in my email it appears 4.19, 4.14, 4.9, and 4.4 patches are
>missing the "found=1" line from the original change.   This explains
>the test failure.

That's an interesting one.

Thanks for the report Naresh and the quick analysis Eric.

>Can you handle this?

I've fixed it up in the queue, thank you!

--
Thanks,
Sasha
