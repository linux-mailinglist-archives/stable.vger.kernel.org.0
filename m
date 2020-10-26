Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCD4298F29
	for <lists+stable@lfdr.de>; Mon, 26 Oct 2020 15:23:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1780814AbgJZOXa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 10:23:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:57524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1780757AbgJZOXa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 26 Oct 2020 10:23:30 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CA692075B;
        Mon, 26 Oct 2020 14:23:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603722210;
        bh=3cRs8+aFIHwhDrhEhE6hbibf8pvjg4zxaQgkKiudhoE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=chUkWrnl/1VgEMLV6DbOuJp3uB9mSpQt3naktmSInhvKrLW4GZNsUUsC114vYhmpL
         e4an/HslLVxyn7aJDoppaFVhNlh5grR8TrjantzQ90J6SDWnjnFzVjm8zy1cGFO95a
         5Tdbl0fRY2wAsiL71zXOwq4qX8kEbQcR5EiwsxNI=
Date:   Mon, 26 Oct 2020 10:23:29 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     stable-commits@vger.kernel.org, stable <stable@vger.kernel.org>
Subject: Re: Patch "selftests: mptcp: depends on built-in IPv6" has been
 added to the 5.9-stable tree
Message-ID: <20201026142329.GJ4060117@sasha-vm>
References: <20201026051850.8F51D206A1@mail.kernel.org>
 <1de2bf78-4b47-21b0-9d56-3c8063cdf4bb@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <1de2bf78-4b47-21b0-9d56-3c8063cdf4bb@tessares.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 26, 2020 at 09:20:47AM +0100, Matthieu Baerts wrote:
>Hi Sasha,
>
>On 26/10/2020 06:18, Sasha Levin wrote:
>>This is a note to let you know that I've just added the patch titled
>>
>>     selftests: mptcp: depends on built-in IPv6
>
>Thank you for backporting this patch.
>
>(...)
>
>>     Fixes: 010b430d5df5 ("mptcp: MPTCP_IPV6 should depend on IPV6 instead of selecting it")
>
>This patch is not really needed because AFAICS this commit here above 
>has not been backported to v5.9. It is only in v5.10-rc1.
>
>(...)
>
>>diff --git a/tools/testing/selftests/net/mptcp/config b/tools/testing/selftests/net/mptcp/config
>>index 8df5cb8f71ff9..741a1c4f4ae8f 100644
>>--- a/tools/testing/selftests/net/mptcp/config
>>+++ b/tools/testing/selftests/net/mptcp/config
>>@@ -1,4 +1,5 @@
>>  CONFIG_MPTCP=y
>>+CONFIG_IPV6=y
>>  CONFIG_MPTCP_IPV6=y
>
>But you can also keep this patch, it doesn't hurt: without this commit 
>010b430d5df5 ("mptcp: MPTCP_IPV6 should depend on IPV6 instead of 
>selecting it"), CONFIG_MPTCP_IPV6=y selects CONFIG_IPV6=y. In other 
>words, adding "CONFIG_IPV6=y" here in the selftests config is 
>redundant if you don't have this commit 010b430d5df5 but not wrong.
>
>Note that if you also want to backport this commit 010b430d5df5 
>("mptcp: MPTCP_IPV6 should depend on IPV6 instead of selecting it"), 
>you will need commit 0ed37ac586c0 ("mptcp: depends on IPV6 but not as 
>a module") as well.

I'll drop the selftests fix then, thanks for the heads-up!

-- 
Thanks,
Sasha
