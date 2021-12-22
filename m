Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9166F47CB7C
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 04:04:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242022AbhLVDE5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Dec 2021 22:04:57 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:54996 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235520AbhLVDE5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Dec 2021 22:04:57 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 82C71B81995
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 03:04:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 02B91C36AE8;
        Wed, 22 Dec 2021 03:04:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640142295;
        bh=adXnHII1o0LaatBwJ/GW9FRuuju6Up9er/RM6HX8tXQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PklokTl/v09iHXBXi+nQYBJDYb1wf5H3eOr6Jz1afG4flblnWEf0c8b8og6x5nUCD
         m2SS+msM0uOBhOwdpQ66PBgFU9ZYwldMT2txkkLekXHU70u7bZ4eAaNEB4JecaFj+x
         7XQ/IuOSkFjWv0YpH29SjALyonAa3pCsk7yzJw0OOql07jV355xDC0lt2l+gWY9anB
         eBmBidpYJpq3au4E65PywLvlVqG/o9vZZ78QF8xvueuexiZCzzvf5QkXxOeuGBbBkX
         lTmYXkZsoM9t/ajIyALp3u+TMWcOqAGO4szGLr7H6Zgm0XQzxAxZ6ARhSp5PIuxW/5
         z71xL/OD1wYDQ==
Date:   Tue, 21 Dec 2021 22:04:53 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Greg Jesionowski <jesionowskigreg@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: Hardware IDs patch, requesting add to stable 5.15.10
Message-ID: <YcKV1dkpsRF6AnGE@sashalap>
References: <20211221174957.GA3233@devoptiplex>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20211221174957.GA3233@devoptiplex>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 21, 2021 at 10:49:57AM -0700, Greg Jesionowski wrote:
>original patch subject: 'net: usb: lan78xx: add Allied Telesis AT29M2-AF'
>upstream commit: ef8a0f6eab1ca5d1a75c242c5c7b9d386735fa0a
>requested kernel: 5.15.10
>
>Hello,
>
>This patch adds hardware IDs for an Allied Telesis USB Gigabit ethernet
>device. People with this device that want to use it need to
>apply the patch manually right now.
>
>Next time I'll know to add a Cc: for the stable list when a patch is first submitted.

I'll queue it up for the next release. Looks like it was picked up
by AUTOSEL anyway :)

Thanks Greg!

-- 
Thanks,
Sasha
