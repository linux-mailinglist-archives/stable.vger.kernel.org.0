Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0482EA5F7E
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 04:53:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbfICCxt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Sep 2019 22:53:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726592AbfICCxt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Sep 2019 22:53:49 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6BA1D21670;
        Tue,  3 Sep 2019 02:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567479228;
        bh=QGTCJ3LG3xyLpzAQ1+pZOE8js/YfQ5sdOz6rTiFppMM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Xs/18CA0ha9n0Q41No4JU81ZgQEQWJV87kIn2g7/Inw7JpCsp/AfO2NvmBrLaDq7A
         iEErbTzU10qyekcIn8HVxDoSgdNrqgpUNXp/jW2hlXCtdgvvgZaNP/7vBeOtkEJeNi
         o+kBhwpni7/RUou9DYZjCb+1MN/hnYpGli5zx0sY=
Date:   Mon, 2 Sep 2019 22:53:47 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     me@sam.st, dsafonov@virtuozzo.com, mhiramat@kernel.org,
        oleg@redhat.com, srikar@linux.vnet.ibm.com, tglx@linutronix.de,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] uprobes/x86: Fix detection of 32-bit user
 mode" failed to apply to 4.14-stable tree
Message-ID: <20190903025347.GD5281@sasha-vm>
References: <156745586914022@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <156745586914022@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Sep 02, 2019 at 10:24:29PM +0200, gregkh@linuxfoundation.org wrote:
>
>The patch below does not apply to the 4.14-stable tree.
>If someone wants it applied there, or to any other stable or longterm
>tree, then please email the backport, including the original git commit
>id to <stable@vger.kernel.org>.

I've backported this for 4.14, 4.9, and 4.4:

 - On 4.14 and 4.9 worked around missing e7ed9d9bd0375 ("uprobes/x86:
   Emulate push insns for uprobe on x86").
 - On 4.4 worked around missing abfb9498ee132 ("x86/entry: Rename
   is_{ia32,x32}_task() to in_{ia32,x32}_syscall()").

--
Thanks,
Sasha
