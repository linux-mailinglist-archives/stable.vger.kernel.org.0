Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAD1629D5E6
	for <lists+stable@lfdr.de>; Wed, 28 Oct 2020 23:09:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730320AbgJ1WJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Oct 2020 18:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:54000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728604AbgJ1WJf (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 28 Oct 2020 18:09:35 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDB17246C5;
        Wed, 28 Oct 2020 22:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603922975;
        bh=PWhQuBJQ9XBRoCUPgy8qrrxqa0eUYI5Ptxmr6pPiztY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YWSzRiZHLYkL53+DR87V2c/G0mh6KhsBNlC87TPVfx4U85tKMazTm8ggafeIsU8UY
         fo7PTqKUTsY0kR8ddlqLbhVRLLXkKXNOnYhIhym5qZDZJuepmhzsIaQ4eLmEzvrxJ2
         zt07AnvHIKuyuVeVW+LoRD6OXqMODnUQ+wEjRs3M=
Date:   Wed, 28 Oct 2020 18:09:33 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Matthieu Baerts <matthieu.baerts@tessares.net>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH 5.9 580/757] selftests: mptcp: depends on built-in IPv6
Message-ID: <20201028220933.GC87646@sasha-vm>
References: <20201027135450.497324313@linuxfoundation.org>
 <20201027135517.727716271@linuxfoundation.org>
 <3cdf310c-dcef-ad91-6f30-3cd48c6c47de@tessares.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <3cdf310c-dcef-ad91-6f30-3cd48c6c47de@tessares.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 27, 2020 at 04:59:45PM +0100, Matthieu Baerts wrote:
>Hi Greg,
>
>On 27/10/2020 14:53, Greg Kroah-Hartman wrote:
>>From: Matthieu Baerts <matthieu.baerts@tessares.net>
>>
>>[ Upstream commit 287d35405989cfe0090e3059f7788dc531879a8d ]
>>
>>Recently, CONFIG_MPTCP_IPV6 no longer selects CONFIG_IPV6. As a
>>consequence, if CONFIG_MPTCP_IPV6=y is added to the kconfig, it will no
>>longer ensure CONFIG_IPV6=y. If it is not enabled, CONFIG_MPTCP_IPV6
>>will stay disabled and selftests will fail.
>
>I think Sasha wanted to drop this patch [1]. But as I said earlier 
>[2], this patch is not wrong, it is just not needed in v5.9 because 
>the "Fixes" commit 010b430d5df5 ("mptcp: MPTCP_IPV6 should depend on 
>IPV6 instead of selecting it") is not in v5.9.
>
>I guess it is certainly easier to keep it because it is not wrong and 
>doesn't hurt.

I dropped a wrong patch by accident :(

Fixing this up... Thanks for pointing it out!

-- 
Thanks,
Sasha
