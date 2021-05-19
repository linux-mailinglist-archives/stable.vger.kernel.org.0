Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56005389250
	for <lists+stable@lfdr.de>; Wed, 19 May 2021 17:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234041AbhESPON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 May 2021 11:14:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:52698 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234445AbhESPOI (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 19 May 2021 11:14:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ED9BA61007;
        Wed, 19 May 2021 15:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621437169;
        bh=jHx90Q25+4UtQ9PpyiMmXBh1foAkG5dCGVCczk0gr8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GOu4qhI5xfk57x8ZiCjXpxiVettIgCqQtYvMfDknwRCtW+I0PHrhr1SM4hCwQFYUN
         TfavXJTRz6wWht9VmmyvNyPEz3B2goxeeMG7b3q01dVdT8/5wkvRVJI3E25OA/ocQz
         m6pysPmNpe6PHweo5ixbIrfZSV82+Azp8RXh2cmZDbi9liI5ww98WH/BLWgWlqNyeC
         flDk3qjzXnxy+uH/BpEe/CrSgZZG6JPXnUr+ENQ4Gw3ZBPIPxK+ReJAmxFcGPS42NP
         F1ejWpKOb8p0otPUJYYWDaDM2B78frzysPDzxuBNPdsjVIBTozrpK4/YuPXCznGmYf
         +8l3kmroXBk8g==
Date:   Wed, 19 May 2021 11:12:47 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     bjorn@kernel.org, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, bganne@cisco.com, stable@vger.kernel.org
Subject: Re: Backport of 11cc2d21499c for 5.4.y and 4.19.y
Message-ID: <YKUq7xqS4N5SoHRI@sashalap>
References: <20210518112739.14086-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210518112739.14086-1-magnus.karlsson@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 18, 2021 at 01:27:39PM +0200, Magnus Karlsson wrote:
>From: Magnus Karlsson <magnus.karlsson@intel.com>
>
>Hi Greg and Sasha,
>
>Please find attached backports of commit 11cc2d21499c ("xsk: Simplify
>detection of empty and full rings") for the 5.4.y and 4.19.y stable
>series. It solves a reproducible race between poll() and sendmsg()
>when used concurrently by two different processes using the same
>AF_XDP socket. Note that the commit above unknowingly (read: by sheer
>luck) fixed the bug as it was about simplification and performance
>improvement only. I have included two backports that are code wise
>equivallent to the commit above, however, they contain a commit message
>that describes the race in question and how it is fixed by the
>patch. Sorry, but I do not know the correct procedure in these kind of
>situations, but if you prefer to pick the original commit, please
>ignore the "backports" below.

In general, if it applies/builds/works cleanly, just telling us the
commit id would be enough. I've queued this one for 5.4 and 4.19,
thanks!

-- 
Thanks,
Sasha
