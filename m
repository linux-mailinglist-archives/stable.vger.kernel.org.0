Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C168226E4AF
	for <lists+stable@lfdr.de>; Thu, 17 Sep 2020 20:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726553AbgIQSyh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 14:54:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:37044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728428AbgIQQU3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 12:20:29 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23ECD221E3;
        Thu, 17 Sep 2020 15:53:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600358016;
        bh=DJoY4SjCm0Aq9Cv3Amd8XdYF2qxkng+cNtLI1j/5DaE=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=XM/wX/1lFyQ5ceU5E5oLA5UfhCfGPVZm/15Ci0O+oyUl/yBmYnTJP6/1Gqpc9lsBz
         KGkNbYMbDK/v4zbKw3s0l1BJtByZyg00MIlhjW+lJAJJH96Pbj6OBa3j0/uNlegCjc
         4HlA3IDOkkWVbmCqzHABbWVDZu+dFSoqOGukoNXY=
Date:   Thu, 17 Sep 2020 15:53:35 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Bartosz Golaszewski <brgl@bgdev.pl>
To:     Bartosz Golaszewski <bgolaszewski@baylibre.com>
To:     Alessandro Zummo <a.zummo@towertech.it>
Cc:     linux-rtc@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 01/14] rtc: rx8010: don't modify the global rtc ops
In-Reply-To: <20200914154601.32245-2-brgl@bgdev.pl>
References: <20200914154601.32245-2-brgl@bgdev.pl>
Message-Id: <20200917155336.23ECD221E3@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: ed13d89b08e3 ("rtc: Add Epson RX8010SJ RTC driver").

The bot has tested the following trees: v5.8.9, v5.4.65, v4.19.145, v4.14.198, v4.9.236.

v5.8.9: Build OK!
v5.4.65: Build OK!
v4.19.145: Failed to apply! Possible dependencies:
    9d085c54202d ("rtc: rx8010: simplify getting the adapter of a client")

v4.14.198: Failed to apply! Possible dependencies:
    9d085c54202d ("rtc: rx8010: simplify getting the adapter of a client")

v4.9.236: Failed to apply! Possible dependencies:
    9d085c54202d ("rtc: rx8010: simplify getting the adapter of a client")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
