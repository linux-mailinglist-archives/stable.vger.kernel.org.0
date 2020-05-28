Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE9F31E6431
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 16:41:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728487AbgE1OlG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 10:41:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725948AbgE1OlE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 10:41:04 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF7C12089D;
        Thu, 28 May 2020 14:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590676864;
        bh=JFAlvbWtfvhpvXNlQlGB5602eAoQ0rPEgFXVACZtkms=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=aB1uKaxF3f6XtY0coeNB/1DA/nr8g0PS0gXPJS6vsdWuiroFwLZhyXlZrpsI34Trq
         68/B69fP0spg0gYr4y4+JRvcPpTilxguSsoCpUMgkwnWf0VHpnip59ygowwFf66rrK
         DP/bZKP+M/nPmBgM84QT+xqBK/azxMxKJTnc60T8=
Date:   Thu, 28 May 2020 14:41:03 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Paul Cercueil <paul@crapouillou.net>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     od@zcrc.me, linux-pwm@vger.kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3 2/4] pwm: jz4740: Enhance precision in calculation of duty cycle
In-Reply-To: <20200527115225.10069-2-paul@crapouillou.net>
References: <20200527115225.10069-2-paul@crapouillou.net>
Message-Id: <20200528144103.BF7C12089D@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: f6b8a5700057 ("pwm: Add Ingenic JZ4740 support").

The bot has tested the following trees: v5.6.14, v5.4.42, v4.19.124, v4.14.181, v4.9.224, v4.4.224.

v5.6.14: Failed to apply! Possible dependencies:
    485b56f08f33 ("pwm: jz4740: Improve algorithm of clock calculation")
    ce1f9cece057 ("pwm: jz4740: Use clocks from TCU driver")

v5.4.42: Failed to apply! Possible dependencies:
    485b56f08f33 ("pwm: jz4740: Improve algorithm of clock calculation")
    ce1f9cece057 ("pwm: jz4740: Use clocks from TCU driver")

v4.19.124: Failed to apply! Possible dependencies:
    1ac99c58bda9 ("pwm: jz4740: Apply configuration atomically")
    485b56f08f33 ("pwm: jz4740: Improve algorithm of clock calculation")
    ce1f9cece057 ("pwm: jz4740: Use clocks from TCU driver")

v4.14.181: Failed to apply! Possible dependencies:
    174dcc8eaec5 ("pwm: jz4740: Implement ->set_polarity()")
    1ac99c58bda9 ("pwm: jz4740: Apply configuration atomically")
    485b56f08f33 ("pwm: jz4740: Improve algorithm of clock calculation")
    b419006275db ("pwm: jz4740: Enable for all Ingenic SoCs")
    ce1f9cece057 ("pwm: jz4740: Use clocks from TCU driver")

v4.9.224: Failed to apply! Possible dependencies:
    174dcc8eaec5 ("pwm: jz4740: Implement ->set_polarity()")
    1ac99c58bda9 ("pwm: jz4740: Apply configuration atomically")
    485b56f08f33 ("pwm: jz4740: Improve algorithm of clock calculation")
    b419006275db ("pwm: jz4740: Enable for all Ingenic SoCs")
    ce1f9cece057 ("pwm: jz4740: Use clocks from TCU driver")

v4.4.224: Failed to apply! Possible dependencies:
    174dcc8eaec5 ("pwm: jz4740: Implement ->set_polarity()")
    1ac99c58bda9 ("pwm: jz4740: Apply configuration atomically")
    485b56f08f33 ("pwm: jz4740: Improve algorithm of clock calculation")
    b419006275db ("pwm: jz4740: Enable for all Ingenic SoCs")
    ce1f9cece057 ("pwm: jz4740: Use clocks from TCU driver")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
