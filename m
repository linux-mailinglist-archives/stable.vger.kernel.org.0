Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE8817939A
	for <lists+stable@lfdr.de>; Wed,  4 Mar 2020 16:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388271AbgCDPgA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Mar 2020 10:36:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:37986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388151AbgCDPgA (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Mar 2020 10:36:00 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F76D21741;
        Wed,  4 Mar 2020 15:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583336159;
        bh=xrHg6a6gcAx1kZXMHV9BB7FHa0jzGDwxjARU5ukTksg=;
        h=Date:From:To:To:To:CC:Cc:Cc:Subject:In-Reply-To:References:From;
        b=fwQ6HI6YyeO5m6pEtD8iLmuOByf5PXSfJLuV4dlKVzp1biFTN9sW1UxU0u5YuCI1V
         faqyNC0oYVNBu1297ktVfxj2MaY77QO25UheSvz3Nt/L+OuJoHuFfXtS59IyHYzrPX
         cmDcNYkXaNxUTMzT4eiWT+sNFx3XW/Qsg9opUBEo=
Date:   Wed, 04 Mar 2020 15:35:58 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Benoit Parrot <bparrot@ti.com>
To:     Hans Verkuil <hverkuil@xs4all.nl>
CC:     <linux-media@vger.kernel.org>, <devicetree@vger.kernel.org>
Cc:     stable <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [Patch 1/1] media: ti-vpe: cal: fix disable_irqs to only the intended target
In-Reply-To: <20200302135652.9365-1-bparrot@ti.com>
References: <20200302135652.9365-1-bparrot@ti.com>
Message-Id: <20200304153559.4F76D21741@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.7, v5.4.23, v4.19.107, v4.14.172, v4.9.215, v4.4.215.

v5.5.7: Build OK!
v5.4.23: Build OK!
v4.19.107: Build OK!
v4.14.172: Build OK!
v4.9.215: Build OK!
v4.4.215: Failed to apply! Possible dependencies:
    343e89a792a5 ("[media] media: ti-vpe: Add CAL v4l2 camera capture driver")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
