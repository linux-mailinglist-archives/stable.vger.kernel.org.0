Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0403A1C7E07
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 01:42:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728105AbgEFXmL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 19:42:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:55714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728079AbgEFXmL (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 19:42:11 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D15FA20735;
        Wed,  6 May 2020 23:42:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588808531;
        bh=KBnO5Y8ohQ5TuAhfpgnGvmGyceSpfMTr78jQxuP6tkU=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=q04wHOEDNAmFU41H+m9Ca5/b+t0BqbA2tBFTz0wwEEvOeN/5DIz3HKAeSboh/pK9d
         Xzw7+APVtUxfX63/pSz8SjCqb1Zy06EBVyd9zrHnQLagiMH4OInohtnObgBrljTlOt
         ogWsuRktU1mkTwWYnHLfczF2tfV6TTmXDzdtyzyk=
Date:   Wed, 06 May 2020 23:42:10 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
To:     Mika Westerberg <mika.westerberg@linux.intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, linux-acpi@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] pinctrl: cherryview: Ensure _REG(ACPI_ADR_SPACE_GPIO, 1) gets called
In-Reply-To: <20200504145957.480418-1-hdegoede@redhat.com>
References: <20200504145957.480418-1-hdegoede@redhat.com>
Message-Id: <20200506234210.D15FA20735@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.10, v5.4.38, v4.19.120, v4.14.178, v4.9.221, v4.4.221.

v5.6.10: Build OK!
v5.4.38: Build OK!
v4.19.120: Build OK!
v4.14.178: Build OK!
v4.9.221: Failed to apply! Possible dependencies:
    a0b028597d59 ("pinctrl: cherryview: Add support for GMMR GPIO opregion")

v4.4.221: Build OK!

NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
