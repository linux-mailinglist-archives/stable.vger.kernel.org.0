Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 006931D95A8
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 13:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728626AbgESLtS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 07:49:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:57880 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728881AbgESLtQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 07:49:16 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA36520709;
        Tue, 19 May 2020 11:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589888956;
        bh=DirzvNejKZlsxkIQ47WnDC22YWf+1vRMU5Jm1H4pSuk=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=VTEpYSJFNddlQXZ/D7QJRIPPQO5oBZ4UnvrVAmexAuY1LqyA/eC9oQtjOwF3umk9w
         yTNliMJ3gNJczR6T0nOgvOU2+A1OXkAYuvo9X7fWtwvpV+hpLcqAvYBB0tKRfo1+5k
         KCIVXVrcvCgJ4ZZSncZJYoJJgQo2x4Fm/EbcJV5Q=
Date:   Tue, 19 May 2020 11:49:15 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Sebastian Reichel <sebastian.reichel@collabora.com>
To:     Robert Beckett <bob.beckett@collabora.com>
To:     Sebastian Reichel <sre@kernel.org>
Cc:     Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHv1] ARM: dts/imx6q-bx50v3: Set display interface clock parents
In-Reply-To: <20200514170236.24814-1-sebastian.reichel@collabora.com>
References: <20200514170236.24814-1-sebastian.reichel@collabora.com>
Message-Id: <20200519114915.DA36520709@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.13, v5.4.41, v4.19.123, v4.14.180, v4.9.223, v4.4.223.

v5.6.13: Build OK!
v5.4.41: Build OK!
v4.19.123: Build OK!
v4.14.180: Failed to apply! Possible dependencies:
    e26dead44268 ("ARM: dts: imx6q-bx50v3: Add internal switch")

v4.9.223: Failed to apply! Possible dependencies:
    1d0c7bb20c08 ("ARM: dts: imx: Correct B850v3 clock assignment")
    e26dead44268 ("ARM: dts: imx6q-bx50v3: Add internal switch")

v4.4.223: Failed to apply! Possible dependencies:
    15ef03b86247 ("ARM: dts: imx: b450/b650v3: Move ldb_di clk assignment")
    1d0c7bb20c08 ("ARM: dts: imx: Correct B850v3 clock assignment")
    2252792b4677 ("ARM: dts: imx: Add support for Advantech/GE B850v3")
    226d16c80c61 ("ARM: dts: imx: Add support for Advantech/GE Bx50v3")
    547da6bbcf08 ("ARM: dts: imx: Add support for Advantech/GE B450v3")
    987e71877ae6 ("ARM: dts: imx: Add support for Advantech/GE B650v3")
    b492b8744da9 ("ARM: dts: imx6q-b850v3: Update display clock source")
    e26dead44268 ("ARM: dts: imx6q-bx50v3: Add internal switch")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
