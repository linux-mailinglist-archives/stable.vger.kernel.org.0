Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80748496D6A
	for <lists+stable@lfdr.de>; Sat, 22 Jan 2022 19:45:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbiAVSpT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Jan 2022 13:45:19 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:34466 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230437AbiAVSpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Jan 2022 13:45:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 51A02CE0920;
        Sat, 22 Jan 2022 18:45:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C39BC004E1;
        Sat, 22 Jan 2022 18:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642877107;
        bh=sCXbGdPD/DLUXHC43kzl/N19hLy2775nseKkVywyCBo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eCCumVsQ3kuyG1y/yjxxjMGqkgA4TrZke2dcaXe8ArI5I62GP6D2W7a8hl2HpehcA
         XfodSGRoF9y1wZniKyrn0MCysm/kXWBKNuMHtZE7clm2fE3PMn0pORLOAKn271KE8d
         Skt1tgAttZNescYaqjWHttjHtS42gLbCiAtlO+Ati+0wLnw+VpU7i/SxI2f7p6BCNK
         rku/Nhsoa5o1X+L7Vzt2Si42IXemZqR9DmHbepkHpLF+nvO6y7URst0/X6hPgwns6p
         wF5FfKSaFFl3x4UEc+PgMWRAdjA8iSKlR1KcDrg+oSYO5ta9NM7bm+KfjXjUbq7GKk
         1JqSngEkHLrGw==
Date:   Sat, 22 Jan 2022 13:45:04 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Pavel Machek <pavel@ucw.cz>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Krzysztof =?utf-8?Q?Ha=C5=82asa?= <khalasa@piap.pl>,
        Rod Whitby <rod@whitby.id.au>, linux-leds@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.10 34/34] leds: leds-fsg: Drop FSG3 LED driver
Message-ID: <YexQsGqgu0Fz9UVw@sashalap>
References: <20220117170326.1471712-1-sashal@kernel.org>
 <20220117170326.1471712-34-sashal@kernel.org>
 <20220117230900.GB14035@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220117230900.GB14035@duo.ucw.cz>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 18, 2022 at 12:09:00AM +0100, Pavel Machek wrote:
>On Mon 2022-01-17 12:03:24, Sasha Levin wrote:
>> From: Linus Walleij <linus.walleij@linaro.org>
>>
>> [ Upstream commit b7f1ac9bb6413b739ea91bd61bdf23c9130a8007 ]
>>
>> The board file using this driver has been deleted and the
>> FSG3 LEDs can be modeled using a system controller and some
>> register bit LEDs in the device tree so this driver is no
>> longer needed.
>
>Please drop.

Uh, not sure how it made it in to begin with. Dropped, thanks!

-- 
Thanks,
Sasha
