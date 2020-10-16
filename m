Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDD129089B
	for <lists+stable@lfdr.de>; Fri, 16 Oct 2020 17:38:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408447AbgJPPiZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 16 Oct 2020 11:38:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:55722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408427AbgJPPiZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 16 Oct 2020 11:38:25 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3B41207DE;
        Fri, 16 Oct 2020 15:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602862705;
        bh=wgXOoHVkVPjnMrqcgErkRfYElHlsFkJdpJKZOEHflzY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GOXom/y3bd47t/YLEAhgSEQ1l/L0yvd95y0T9YHf9ML0jENkmAQxf5Ri5jmXGgqU2
         KCxPhTg3LIDHyvLm0J7VYNWhwVHg6fnRmryypMQ5Np5FedltLTyB7cvGc+W1Of4PGr
         5MvSH53ZS7gtmkjRdqzlEL8MxxYqJVAhmFdQZkJg=
Date:   Fri, 16 Oct 2020 11:38:23 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     Daniel Burgener <dburgener@linux.microsoft.com>,
        stable@vger.kernel.org, stephen.smalley.work@gmail.com,
        paul@paul-moore.com, selinux@vger.kernel.org, jmorris@namei.org
Subject: Re: [PATCH v5.4 v2 0/4] Update SELinuxfs out of tree and then
 swapover
Message-ID: <20201016153823.GA2415204@sasha-vm>
References: <20201016134835.1886478-1-dburgener@linux.microsoft.com>
 <20201016150120.GB1807231@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201016150120.GB1807231@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 16, 2020 at 05:01:20PM +0200, Greg KH wrote:
>On Fri, Oct 16, 2020 at 09:48:31AM -0400, Daniel Burgener wrote:
>> v2: Include all commits from original series, and include commit ids
>>
>> This is a backport for stable of my series to fix a race condition in
>> selinuxfs during policy load:
>
>Has this race condition always been present, or is this a regression
>that is being fixed from previously working kernels?

So this issue has always been there, but:

>If it's always been present, why not just use 5.9 to solve it?

Because it was merged for 5.10 rather than 5.9, which is a few months
out, so Daniel is looking to see if we can have it in 5.8/5.4 to close
the gap.

-- 
Thanks,
Sasha
