Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 08E778064B
	for <lists+stable@lfdr.de>; Sat,  3 Aug 2019 15:22:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388635AbfHCNWN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 3 Aug 2019 09:22:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:34764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388206AbfHCNWN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 3 Aug 2019 09:22:13 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1849D2075C;
        Sat,  3 Aug 2019 13:22:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564838532;
        bh=rNiZa+mqVGJZ5+FwSdNYKYCZ7QYSLSNFGdD+mAZPQ9E=;
        h=Date:From:To:To:To:Cc:Subject:In-Reply-To:References:From;
        b=h58SAicgzposQzWHq4WjwvMAdMDCaoWjq6plJn0qPCf2/lf1lhl4GKRSJIp+lmyd0
         M983QxqZJKzPGbK0lLB145s7+prvRmR/bOD2+KW6kBMpHKyA1qkuTpqp0VKfuwny9v
         Pp7zyNrIwR3OAebtgAJ2AmF5IwRtPlb2iBMokB5o=
Date:   Sat, 03 Aug 2019 13:22:11 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     "M. Vefa Bicakci" <m.v.b@runbox.com>
To:     Masahiro Yamada <yamada.masahiro@socionext.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] kconfig: Clear "written" flag to avoid data loss
In-Reply-To: <20190803100212.8227-1-m.v.b@runbox.com>
References: <20190803100212.8227-1-m.v.b@runbox.com>
Message-Id: <20190803132212.1849D2075C@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag,
fixing commit: 8e2442a5f86e kconfig: fix missing choice values in auto.conf.

The bot has tested the following trees: v5.2.5, v4.19.63.

v5.2.5: Build OK!
v4.19.63: Failed to apply! Possible dependencies:
    aff11cd983ec ("kconfig: Terminate menu blocks with a comment in the generated config")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

--
Thanks,
Sasha
