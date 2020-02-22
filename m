Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF58168F42
	for <lists+stable@lfdr.de>; Sat, 22 Feb 2020 15:13:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbgBVONz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Feb 2020 09:13:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:53668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726883AbgBVONz (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 22 Feb 2020 09:13:55 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFA18206D7;
        Sat, 22 Feb 2020 14:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582380835;
        bh=Sj50+WKbpeOFdpdWCe9jgIEfPwoTqzVxQrce7HHxHyY=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=G+B97beEoQXDyzIFLtgTAP565qscNbUaUpmkA0pLIBvlkW2PgeYkiX9Ik5D8IMlz+
         qAlP7yQ+0H2svycTluQIQDjcJxynCvXWKRazBzEzKgJk+fMcOU4ma2mB4fC2icNAPX
         aG47vH265KF3ypC/7uf3io6PAV5/5A0x/VrS8j4M=
Date:   Sat, 22 Feb 2020 14:13:53 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Felix Fietkau <nbd@nbd.name>
To:     linux-wireless@vger.kernel.org
Cc:     kvalo@codeaurora.org, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.6] mt76: fix array overflow on receiving too many fragments for a packet
In-Reply-To: <20200220114139.46508-1-nbd@nbd.name>
References: <20200220114139.46508-1-nbd@nbd.name>
Message-Id: <20200222141354.EFA18206D7@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.5, v5.4.21, v4.19.105, v4.14.171, v4.9.214, v4.4.214.

v5.5.5: Build OK!
v5.4.21: Build OK!
v4.19.105: Build OK!
v4.14.171: Failed to apply! Possible dependencies:
    17f1de56df05 ("mt76: add common code shared between multiple chipsets")

v4.9.214: Failed to apply! Possible dependencies:
    17f1de56df05 ("mt76: add common code shared between multiple chipsets")

v4.4.214: Failed to apply! Possible dependencies:
    17f1de56df05 ("mt76: add common code shared between multiple chipsets")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks,
Sasha
