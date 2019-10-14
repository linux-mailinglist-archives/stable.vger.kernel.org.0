Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B515D6C0C
	for <lists+stable@lfdr.de>; Tue, 15 Oct 2019 01:30:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726529AbfJNXaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Oct 2019 19:30:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:56962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726534AbfJNX37 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 14 Oct 2019 19:29:59 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 053D1217F9;
        Mon, 14 Oct 2019 23:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571095799;
        bh=N7OHCeFI+a0vMqdp0xXrpomLgSmZqAvngQhTFh23tkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qQU/qyrkzUASxDxKkRVFOopTbSpBBWYfM6TrCU0SFdWwpsjBB7VJYTPNRsyUtph5o
         5yUksO2OSJXpimM4DTW8H8YKkdIEPfwn4DmdzebppAuJDCTZih4Rhx6u8DyC9FtpO5
         DQ1HeGgrcKtg88naDuMyBUs6lVo8ZuI+wN56kfbA=
Date:   Mon, 14 Oct 2019 19:29:58 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     John Garry <john.garry@huawei.com>
Cc:     stable@vger.kernel.org, catalin.marinas@arm.com, will@kernel.org,
        rjw@rjwysocki.net, lenb@kernel.org, sudeep.holla@arm.com,
        rrichter@marvell.com, jeremy.linton@arm.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, linuxarm@huawei.com,
        gregkh@linuxfoundation.org, guohanjun@huawei.com,
        wanghuiqiang@huawei.com
Subject: Re: [PATCH for-stable-5.3 1/2] ACPI/PPTT: Add support for ACPI 6.3
 thread flag
Message-ID: <20191014232958.GC31224@sasha-vm>
References: <1571054162-71090-1-git-send-email-john.garry@huawei.com>
 <1571054162-71090-2-git-send-email-john.garry@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1571054162-71090-2-git-send-email-john.garry@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 14, 2019 at 07:56:01PM +0800, John Garry wrote:
>From: Jeremy Linton <jeremy.linton@arm.com>
>
>Commit bbd1b70639f785a970d998f35155c713f975e3ac upstream.
>
>ACPI 6.3 adds a flag to the CPU node to indicate whether
>the given PE is a thread. Add a function to return that
>information for a given linux logical CPU.
>
>Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
>Reviewed-by: Sudeep Holla <sudeep.holla@arm.com>
>Reviewed-by: Robert Richter <rrichter@marvell.com>
>Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
>Signed-off-by: Will Deacon <will@kernel.org>
>Signed-off-by: John Garry <john.garry@huawei.com>

How far back should these patches be backported?

-- 
Thanks,
Sasha
