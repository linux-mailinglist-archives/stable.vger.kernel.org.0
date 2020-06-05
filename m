Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0ACE71EFA0F
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728047AbgFEOKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:41864 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728044AbgFEOKx (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:10:53 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B250A206F0;
        Fri,  5 Jun 2020 14:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366252;
        bh=xPRpuqy1sIp5RX9LUwmgTjD/X5e/TaRHqPU8xmBTxvo=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=NrWTX5Wjd++B+aumdQed/YaWD37nth2cdF7OCOGuGfbf+3bRIk0hKQSQ9FL3g3Hg2
         73ajTWh4YjR9+mTzt4wjaaifHpxeKxc9wumb8XVBVij//DiL4YxejOMt+mI1wpMwmF
         dTAV7+wLPshGhPz2WkbuDfgSv27rPIQBRhC47rb4=
Date:   Fri, 05 Jun 2020 14:10:52 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Minas Harutyunyan <Minas.Harutyunyan@synopsys.com>
To:     Felipe Balbi <balbi@kernel.org>
Cc:     John Youn <John.Youn@synopsys.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] usb: dwc2: Postponed gadget registration to the udc class driver
In-Reply-To: <631755afa9aa2504684322ec285c7fa4fabca9de.1590935792.git.hminas@synopsys.com>
References: <631755afa9aa2504684322ec285c7fa4fabca9de.1590935792.git.hminas@synopsys.com>
Message-Id: <20200605141052.B250A206F0@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 117777b2c3bb ("usb: dwc2: Move gadget probe function into platform code").

The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182, v4.9.225, v4.4.225.

v5.6.15: Build failed! Errors:
    drivers/usb/dwc2/platform.c:517:4: error: label ‘error_init’ used but not defined

v5.4.43: Build failed! Errors:
    drivers/usb/dwc2/platform.c:517:4: error: label ‘error_init’ used but not defined

v4.19.125: Build failed! Errors:
    drivers/usb/dwc2/platform.c:502:4: error: label ‘error_init’ used but not defined

v4.14.182: Build failed! Errors:
    drivers/usb/dwc2/platform.c:462:4: error: label ‘error_init’ used but not defined

v4.9.225: Build failed! Errors:
    drivers/usb/dwc2/platform.c:671:4: error: label ‘error_init’ used but not defined

v4.4.225: Build failed! Errors:
    drivers/usb/dwc2/platform.c:462:4: error: label ‘error_init’ used but not defined


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
