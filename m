Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCE1918D663
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 18:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727316AbgCTR7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 13:59:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727303AbgCTR7r (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 13:59:47 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B76420773;
        Fri, 20 Mar 2020 17:59:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584727186;
        bh=DGeijnOIn12ma/KFVaPMSvVX+s9rvjhEG+Ur0PAtiuI=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=ONzJ0ZJ6nw3PrFfrdSoYaE8wT4mwKndSAPADBXc+39M1wul0Y2nVV2/xIgfhFkTno
         Lxu1FQbP2065765hwrMvNfCwQe3JlFIdcnNio/gpTrJ4BJCTS/lL+PP23IN25vwn3W
         ZcaqvudhiGxL3xUHgjRv3udAl6zCfims03R+UzHg=
Date:   Fri, 20 Mar 2020 17:59:45 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Corentin Labbe <clabbe@baylibre.com>
To:     a.zummo@towertech.it, alexandre.belloni@bootlin.com
Cc:     linux-kernel@vger.kernel.org, linux-rtc@vger.kernel.org
Cc:     stable <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] rtc: max8907: add missing select REGMAP_IRQ
In-Reply-To: <1584545209-20433-1-git-send-email-clabbe@baylibre.com>
References: <1584545209-20433-1-git-send-email-clabbe@baylibre.com>
Message-Id: <20200320175946.8B76420773@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 94c01ab6d754 ("rtc: add MAX8907 RTC driver").

The bot has tested the following trees: v5.5.10, v5.4.26, v4.19.111, v4.14.173, v4.9.216, v4.4.216.

v5.5.10: Build OK!
v5.4.26: Build OK!
v4.19.111: Build OK!
v4.14.173: Build OK!
v4.9.216: Failed to apply! Possible dependencies:
    959df7778bbd ("rtc: Enable compile testing for Maxim and Samsung drivers")

v4.4.216: Failed to apply! Possible dependencies:
    01ea01b35120 ("rtc: max77686: Use a driver data struct instead hard-coded values")
    0b4f8b085b5d ("rtc: max77686: fix checkpatch error")
    5981804b8365 ("rtc: max77686: Use usleep_range() instead of msleep()")
    69be249ab4bc ("rtc: max77686: use rtc regmap to access RTC registers")
    726fe738bd5c ("rtc: max77686: Add support for MAX20024/MAX77620 RTC IP")
    862f9453bd14 ("rtc: max77686: Use ARRAY_SIZE() instead of current array length")
    90a5698a86ba ("rtc: max77686: Add an indirection level to access RTC registers")
    959df7778bbd ("rtc: Enable compile testing for Maxim and Samsung drivers")
    bf035f42344a ("rtc: max77686: Cleanup and reduce dmesg output")
    f3937549a975 ("rtc: max77686: move initialisation of rtc regmap, irq chip locally")
    f604c48849a5 ("rtc: max77686: avoid reference of parent device info multiple places")
    f903129b8607 ("rtc: max77686: Add max77802 support")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
