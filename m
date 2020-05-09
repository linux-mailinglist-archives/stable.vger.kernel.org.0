Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 634041CC14A
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 14:30:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728551AbgEIMax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 08:30:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:60248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728388AbgEIMaw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 May 2020 08:30:52 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6142521775;
        Sat,  9 May 2020 12:30:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589027452;
        bh=seKJQxzEC9BDEm3+SirKDq/bgsaFHJesV2opJ9ejC1U=;
        h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=fsKNPdfTG+ts8xWAfIz8zsVV+/2EwcxkOhQBV5dYzu1ngXu43qbR3aJ+KciVKUCU2
         v8Sy/YBXMkesNCALXdA6Ji0JRf7caOl6xxkJON7Ha+YrtQV1vjPMJwnWI095ViZaOC
         1SxR4pdwZSOlPKxogl3II1y++2m6PB+7PtanGUIc=
Date:   Sat, 09 May 2020 12:30:51 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Veerabhadrarao Badiganti <vbadigan@codeaurora.org>
To:     Sarthak Garg <sartgarg@codeaurora.org>
To:     adrian.hunter@intel.com, ulf.hansson@linaro.org
Cc:     stummala@codeaurora.org, linux-mmc@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH V1 2/2] mmc: core: Fix recursive locking issue in CQE recovery path
In-Reply-To: <1588775643-18037-3-git-send-email-vbadigan@codeaurora.org>
References: <1588775643-18037-3-git-send-email-vbadigan@codeaurora.org>
Message-Id: <20200509123052.6142521775@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 4.19+

The bot has tested the following trees: v5.6.11, v5.4.39, v4.19.121.

v5.6.11: Failed to apply! Possible dependencies:
    511ce378e16f ("mmc: Add MMC host software queue support")

v5.4.39: Failed to apply! Possible dependencies:
    511ce378e16f ("mmc: Add MMC host software queue support")

v4.19.121: Failed to apply! Possible dependencies:
    310df020cdd7 ("mmc: stop abusing the request queue_lock pointer")
    511ce378e16f ("mmc: Add MMC host software queue support")
    b061b326287d ("mmc: simplify queue initialization")
    f5d72c5c55bc ("mmc: stop abusing the request queue_lock pointer")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
