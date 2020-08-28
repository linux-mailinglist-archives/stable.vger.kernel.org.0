Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51F98255ED8
	for <lists+stable@lfdr.de>; Fri, 28 Aug 2020 18:36:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726677AbgH1Qgv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Aug 2020 12:36:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:40298 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726524AbgH1Qgv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Aug 2020 12:36:51 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7039320872;
        Fri, 28 Aug 2020 16:36:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598632610;
        bh=S3K11L2Ws9RoFoiHF2dBKgkGk5nN5svUjIexK0Dyb/I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NfnNo6sj6MMVNZRgJ/BiW190PvetzDwBcw+02YugifzNxy+vfuSxKxHih7iPtvNBM
         B18v+mmC0zTzlM46vXttCFXexfGOB2KY2GPxlHNj/lvwBgddFcO3XzplJXiSgeL13B
         VSAcpfRA84OYwmbLZPAo1+fZiH5PM+I5itV11nYc=
Date:   Fri, 28 Aug 2020 12:36:49 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Qais Yousef <qais.yousef@arm.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Mel Gorman <mgorman@suse.de>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH 0/2] Backport uclamp static key to 5.4.y stable
Message-ID: <20200828163649.GT8670@sasha-vm>
References: <20200828125610.30943-1-qais.yousef@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200828125610.30943-1-qais.yousef@arm.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 28, 2020 at 01:56:08PM +0100, Qais Yousef wrote:
>Hi Greg/Sasha
>
>The following 2 patches are backports of
>
>	46609ce22703: ("sched/uclamp: Protect uclamp fast path code with static key")
>	e65855a52b47: ("sched/uclamp: Fix a deadlock when enabling uclamp static key")
>
>into 5.4.y stable tree. The conflict was trivial and due to:
>
>	1. uclamp_rq_util_with() was renamed from util_util_with()
>	2. 2 local variables were converted to unsigned long from unsigned int.
>
>I did do compile test on aarch64 and x86_64 and both looked fine. Beside I ran
>a quick and short mmtest to verify the functionality and got the following
>results which is inline with what's expected.

I've queued it up, thanks!

-- 
Thanks,
Sasha
