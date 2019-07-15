Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 946A369A20
	for <lists+stable@lfdr.de>; Mon, 15 Jul 2019 19:48:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbfGORse (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Jul 2019 13:48:34 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:36604 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730854AbfGORse (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Jul 2019 13:48:34 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 74F1360F38; Mon, 15 Jul 2019 17:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563212913;
        bh=ebMlBJPIGkZjoy4+LA3jCPs11ejsMA/w+UdmaiFwChc=;
        h=Subject:From:In-Reply-To:References:To:Cc:Date:From;
        b=Gj+7dOwa0MEg30f9eo+5MLPeyrJEWq+9szVsJzEFT6scv2t73h1CrYhd0m3HDwrG+
         LzpmWiQJS2iMVKLWJJIos1y7GV+QJkPUOTu/Yl9x6tAdzGOIaW4LqgnLJt21PnKSbN
         w4umWNIBtWadFeG30H42stoWOlfj0pef/PQPjGoU=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,MISSING_DATE,MISSING_MID,SPF_NONE autolearn=no
        autolearn_force=no version=3.4.0
Received: from potku.adurom.net (88-114-240-156.elisa-laajakaista.fi [88.114.240.156])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: kvalo@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 81F6160A44;
        Mon, 15 Jul 2019 17:48:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1563212912;
        bh=ebMlBJPIGkZjoy4+LA3jCPs11ejsMA/w+UdmaiFwChc=;
        h=Subject:From:In-Reply-To:References:To:Cc:From;
        b=RgZ65/RtUVe8Tjrw8fRSkA8yBQblbgvKKwKUmm4WaxbKdDk3gt2IqiLgt75Vgo1uv
         T9muJYHTLUz0Xqh2rr+DZCu2qC0kHMUkCUaZ+6biWwczQfDQGRW6+Lbv+saGsTamL4
         xLWwv1trerWPHSVe9caHajWk7kJkAKTwJNGBtMPM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 81F6160A44
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=kvalo@codeaurora.org
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 1/2] iwlwifi: add new cards for 9000 and 20000 series
From:   Kalle Valo <kvalo@codeaurora.org>
In-Reply-To: <20190708155534.18241-2-luca@coelho.fi>
References: <20190708155534.18241-2-luca@coelho.fi>
To:     Luca Coelho <luca@coelho.fi>
Cc:     linux-wireless@vger.kernel.org,
        Ihab Zhaika <ihab.zhaika@intel.com>, stable@vger.kernel.org,
        Luca Coelho <luciano.coelho@intel.com>
User-Agent: pwcli/0.0.0-git (https://github.com/kvalo/pwcli/) Python/2.7.12
Message-Id: <20190715174833.74F1360F38@smtp.codeaurora.org>
Date:   Mon, 15 Jul 2019 17:48:33 +0000 (UTC)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Luca Coelho <luca@coelho.fi> wrote:

> From: Ihab Zhaika <ihab.zhaika@intel.com>
> 
> add two new PCI ID's for 9000 and 20000 series
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Ihab Zhaika <ihab.zhaika@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>

2 patches applied to wireless-drivers.git, thanks.

ffcb60a54f24 iwlwifi: add new cards for 9000 and 20000 series
a7d544d63120 iwlwifi: pcie: add support for qu c-step devices

-- 
https://patchwork.kernel.org/patch/11035359/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches

