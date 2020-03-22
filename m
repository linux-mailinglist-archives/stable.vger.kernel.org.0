Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 153AC18EBF1
	for <lists+stable@lfdr.de>; Sun, 22 Mar 2020 20:37:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726741AbgCVThl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 22 Mar 2020 15:37:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:46978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726502AbgCVThl (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 22 Mar 2020 15:37:41 -0400
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3FEBB2070A;
        Sun, 22 Mar 2020 19:37:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584905860;
        bh=EYj1ZjIKsB8UScswc5qhZWW0Mbv6Cjij0kOFbxjDnfc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=1q81UiRrdoT3EWkQSrFE/8Oxf5fsbuOdedj+OpfPoWQfNboDFhUWxv7q5Cmew0r3I
         lscAWsJuoUPQ+YbVM+cjiOtP9jryH8U4n1X2CSx2Rq587hM0J3ux2/ETMi761OGcF9
         ik1/p1oamSU1FIdpifNjRfJIxwijWCSJDdA+nlQs=
Date:   Sun, 22 Mar 2020 15:37:39 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vignesh Raghavendra <vigneshr@ti.com>,
        linux-spi@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.5 01/41] spi: spi-omap2-mcspi: Handle DMA size
 restriction on AM65x
Message-ID: <20200322193739.GO4189@sasha-vm>
References: <20200316023319.749-1-sashal@kernel.org>
 <20200316115057.GB5010@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20200316115057.GB5010@sirena.org.uk>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 16, 2020 at 11:50:57AM +0000, Mark Brown wrote:
>On Sun, Mar 15, 2020 at 10:32:39PM -0400, Sasha Levin wrote:
>> From: Vignesh Raghavendra <vigneshr@ti.com>
>>
>> [ Upstream commit e4e8276a4f652be2c7bb783a0155d4adb85f5d7d ]
>>
>> On AM654, McSPI can only support 4K - 1 bytes per transfer when DMA is
>> enabled. Therefore populate master->max_transfer_size callback to
>> inform client drivers of this restriction when DMA channels are
>> available.
>
>As ever this only provides information to other drivers which may be
>buggy.

I'll drop it, thanks!

-- 
Thanks,
Sasha
