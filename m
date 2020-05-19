Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F23B01D9599
	for <lists+stable@lfdr.de>; Tue, 19 May 2020 13:49:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728662AbgESLtL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 May 2020 07:49:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:57658 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728626AbgESLtK (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 19 May 2020 07:49:10 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4FDD1207D3;
        Tue, 19 May 2020 11:49:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589888950;
        bh=IfvGjg51SBOS2RWb6J8Mv/72OVatLo8GQymceWMT/AY=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=c38mDUpvPxrQc8JGcEjD/ret9FOCeJZr8wk50L9aihQdwy/Za4OdCZKcdKyK9mANS
         TKeGGo3dDjiTNUUE8+4AHkKDkGmSkCqW8vfwHcRdPk6Oc2V2madU1JszWXgWMcLamR
         SYOr7iGKHQ+Z0vBN+hOKtOx/qA6N5WfvR4YmFKHc=
Date:   Tue, 19 May 2020 11:49:09 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Bob Haarman <inglorion@google.com>
To:     Thomas Gleixner <tglx@linutronix.de>
Cc:     Fangrui Song <maskray@google.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] x86_64: fix jiffies ODR violation
In-Reply-To: <20200515180544.59824-1-inglorion@google.com>
References: <20200515180544.59824-1-inglorion@google.com>
Message-Id: <20200519114910.4FDD1207D3@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 40747ffa5aa8 ("asmlinkage: Make jiffies visible").

The bot has tested the following trees: v5.6.13, v5.4.41, v4.19.123, v4.14.180, v4.9.223, v4.4.223.

v5.6.13: Build OK!
v5.4.41: Build OK!
v4.19.123: Build OK!
v4.14.180: Build OK!
v4.9.223: Build OK!
v4.4.223: Failed to apply! Possible dependencies:
    9ccaf77cf059 ("x86/mm: Always enable CONFIG_DEBUG_RODATA and remove the Kconfig option")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
