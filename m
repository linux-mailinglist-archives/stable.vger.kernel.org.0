Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94A3740990C
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 18:27:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237213AbhIMQ2w (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 12:28:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:58544 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229542AbhIMQ2v (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 12:28:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2D3760E76;
        Mon, 13 Sep 2021 16:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631550455;
        bh=+JU75Xr+8q9kiFLxr1qYENZSbwe5QYQ0hiW2ZF5UCD0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nYFQxeHb0GejwY1c9Wp9liAY4sMkenPKpjRCTclr2YunjCOr2wzwBBi9vD2HLuJqZ
         3IggVeQkyIqLwrVt3TtoTcy1sxq3XNWr1A7EoQ19iUO4AiDMtfw7dRIDzG5S9R/ErQ
         Virp4+/ZMn77Wme4xWVuK6Tu0KOI5CrCApWRGLtE4bUotf+nENo1Dp2HzucqOyfds4
         Cba13pYZKZZRD1iF0CGMasAJpGr9AEYYFMv2aJok+Sxg6guc6WB7HbFHtkdAOLL1ab
         lD5nLJ2m1ZC9wCVnN2Hsq3gLWEbNML9M0RDKvaoivMQMQFL5Tc/sYjsUHN4DOdrtYN
         41BPrC2M6gogQ==
Date:   Mon, 13 Sep 2021 12:27:34 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Phillip Potter <phil@philpotter.co.uk>,
        kernel test robot <lkp@intel.com>,
        linux-staging@lists.linux.dev
Subject: Re: [PATCH AUTOSEL 5.14 044/252] staging: rtl8188eu: remove
 rtw_wx_set_rate handler function
Message-ID: <YT979kMB0rOJeqZO@sashalap>
References: <20210909114106.141462-1-sashal@kernel.org>
 <20210909114106.141462-44-sashal@kernel.org>
 <YTn0ofrVzKH/IuyV@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YTn0ofrVzKH/IuyV@kroah.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 09, 2021 at 01:48:49PM +0200, Greg Kroah-Hartman wrote:
>On Thu, Sep 09, 2021 at 07:37:38AM -0400, Sasha Levin wrote:
>> From: Phillip Potter <phil@philpotter.co.uk>
>>
>> [ Upstream commit ac5951a6e3d50cfa861ea83baa2ec15d994389cb ]
>>
>> Remove rtw_wx_set_rate handler function, which currently handles the
>> SIOCSIWRATE wext ioctl. This function (although containing a lot of
>> code) set nothing outside its own local variables, and did nothing other
>> than call a now removed debugging statement repeatedly. Removing it and
>> leaving its associated entry in rtw_handlers as NULL is therefore the
>> better option. Removing this function also fixes a kernel test robot
>> warning.
>>
>> Reported-by: kernel test robot <lkp@intel.com>
>> Signed-off-by: Phillip Potter <phil@philpotter.co.uk>
>> Link: https://lore.kernel.org/r/20210625191658.1299-1-phil@philpotter.co.uk
>> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  .../staging/rtl8188eu/os_dep/ioctl_linux.c    | 75 -------------------
>>  1 file changed, 75 deletions(-)
>
>This whole driver is now gone in 5.15-rc1, so no need for doing anything
>like this for older kernels.  Please drop this patch from all branches.

Dropped, thanks!

-- 
Thanks,
Sasha
