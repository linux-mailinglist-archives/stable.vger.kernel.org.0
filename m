Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1ABAF1E642D
	for <lists+stable@lfdr.de>; Thu, 28 May 2020 16:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728484AbgE1OlE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 28 May 2020 10:41:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:44370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725795AbgE1OlC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 28 May 2020 10:41:02 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6FE60207D3;
        Thu, 28 May 2020 14:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590676861;
        bh=8Sy4SGFy9WOB7rPR7XK0WJf25jfeyvcDfaCkmDkOQcY=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=tpWXd42MqAcAJZ74lqRKUprDaM82Gh2z20V5eGpHLsTStpw2CzVTYDt9Rtnqj42az
         t7VRejA1E9w5Bq5c5gAoXipsLxQrKWqanchqU9tUdTMfeiLEKwImYSEFvY1tZjOHmQ
         l7ItfRuLdasxXTQ5DsD94LsIPs28GJJF84CX9pIw=
Date:   Thu, 28 May 2020 14:41:00 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Dan Carpenter <dan.carpenter@oracle.com>
To:     Kalle Valo <kvalo@codeaurora.org>, Hu Jiahui <kirin.say@gmail.com>
Cc:     security@kernel.org, linux-wireless@vger.kernel.org
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v3] airo: Fix read overflows sending packets
In-Reply-To: <20200527184830.GA1164846@mwanda>
References: <20200527184830.GA1164846@mwanda>
Message-Id: <20200528144101.6FE60207D3@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.14, v5.4.42, v4.19.124, v4.14.181, v4.9.224, v4.4.224.

v5.6.14: Build OK!
v5.4.42: Build OK!
v4.19.124: Build OK!
v4.14.181: Build OK!
v4.9.224: Build OK!
v4.4.224: Failed to apply! Possible dependencies:
    Unable to calculate


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
