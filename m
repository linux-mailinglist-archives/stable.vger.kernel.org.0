Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 632EB2E6C7D
	for <lists+stable@lfdr.de>; Tue, 29 Dec 2020 00:26:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727737AbgL1XZM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 18:25:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:35982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726567AbgL1XZM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 18:25:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75BB0207A6;
        Mon, 28 Dec 2020 23:24:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1609197871;
        bh=DsdJFN10wM0d2NKyziGy+hEzY0wktj07KQzUt/bFPes=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kw6Sl+ye8P8dTQzHVXw5zfKb1sYRIt4xyoNHjDhGlrx2kDfcw3sqtxOrBhKu6Iwai
         OtfRImN2FmXD4eZGbLNt9NtxwK8r3txumVMoOh6zTkPDg4sOHk8FOWsRGk8NBQwPQp
         k7Ti3Nr1f98oWqfJVarVfX04x2jFfn+XR0Nl70Y+nLcnnIekhFRZR3p8eZxT5Rugw4
         7jW52XEd3it3X/hgZf92QewX5DvYzKb8jJXcUsedSSJSRVJD9+wwVE5K7SrApv2vnA
         MoMHuN50mbqNRqEJBNvkyLPXCd3shNhQeDcoRduI5nxdrXbegKFJC8diwPnewPxeDY
         W8+OsN0u4MTFg==
Date:   Mon, 28 Dec 2020 18:24:30 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vincent Bernat <vincent@bernat.ch>
Subject: Re: [PATCH 5.10 098/717] net: evaluate
 net.ipvX.conf.all.ignore_routes_with_linkdown
Message-ID: <20201228232430.GJ2790422@sasha-vm>
References: <20201228125020.963311703@linuxfoundation.org>
 <20201228125025.671560851@linuxfoundation.org>
 <20201228105058.7c66e522@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201228105058.7c66e522@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 10:50:58AM -0800, Jakub Kicinski wrote:
>On Mon, 28 Dec 2020 13:41:36 +0100 Greg Kroah-Hartman wrote:
>> From: Vincent Bernat <vincent@bernat.ch>
>>
>> [ Upstream commit c0c5a60f0f1311bcf08bbe735122096d6326fb5b ]
>>
>> Introduced in 0eeb075fad73, the "ignore_routes_with_linkdown" sysctl
>> ignores a route whose interface is down. It is provided as a
>> per-interface sysctl. However, while a "all" variant is exposed, it
>> was a noop since it was never evaluated. We use the usual "or" logic
>> for this kind of sysctls.
>
>I'd recommend to drop 98 and 99, at least for now.
>
>The kernel always behaved this way, and it remains to be seen if anyone
>depended on that (mis) behavior.
>
>This needs to hit a real release.

I'll drop it.

-- 
Thanks,
Sasha
