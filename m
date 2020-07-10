Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40B5921B790
	for <lists+stable@lfdr.de>; Fri, 10 Jul 2020 16:02:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728278AbgGJOCo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jul 2020 10:02:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:49754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727097AbgGJOCn (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Jul 2020 10:02:43 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3CC3F2082E;
        Fri, 10 Jul 2020 14:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594389763;
        bh=VvptTRaDt7ndl05+l3JBeHa0G2eudUrK0ICgg1ZxOig=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=yiyfUPJIh0Rg2TkRM8SsoCFe/9D4eqQ5/nV7YwEVTaH6Ua03nCww8a9drYe1r2Jxt
         NiiwNOa0L93b0ACk+i+W4CJofmatBlKEBF2DXvpvtpFymdsoUOLge35xAgxrX+jjiz
         /p6ubifU2GbDGHowIxvcGtFdB0q/j4p8NvaUQCus=
Date:   Fri, 10 Jul 2020 14:02:42 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Lee Jones <lee.jones@linaro.org>
To:     lee.jones@linaro.org
Cc:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 02/10] mfd: mfd-core: Complete kerneldoc header for devm_mfd_add_devices()
In-Reply-To: <20200625064619.2775707-3-lee.jones@linaro.org>
References: <20200625064619.2775707-3-lee.jones@linaro.org>
Message-Id: <20200710140243.3CC3F2082E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.14.186, v4.9.228, v4.4.228.

v5.7.6: Build OK!
v5.4.49: Build OK!
v4.19.130: Build OK!
v4.14.186: Build OK!
v4.9.228: Build OK!
v4.4.228: Failed to apply! Possible dependencies:
    a8f447be8056d ("mfd: Add resource managed APIs for mfd_add_devices")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
