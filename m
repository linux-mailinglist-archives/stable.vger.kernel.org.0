Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEA1E153349
	for <lists+stable@lfdr.de>; Wed,  5 Feb 2020 15:45:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbgBEOpI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Feb 2020 09:45:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:37844 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726543AbgBEOpH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 Feb 2020 09:45:07 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 31F5F218AC;
        Wed,  5 Feb 2020 14:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580913907;
        bh=94GkFpBxAel3ql0NTweeMe/aQbZ1pXa5A68amsyF/dI=;
        h=Date:From:To:To:To:Cc:Subject:In-Reply-To:References:From;
        b=EUsbTdUHALsNvSgloGkVsnike7amrg5DZDnAKzKroS2IRP9EaoIo+GpzX2c5bDuc8
         vV1jE2oOC/MQx5CMCa4h0KHMb1x5TZl+vMGKxuR5kpKtJ4sqdBPoTtfhZC1HFjayN4
         QKLV2ozcGJwgbWYqgKy5Wgxj5JbJCksQThc2BGWk=
Date:   Wed, 05 Feb 2020 14:45:06 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Filipe Manana <fdmanana@suse.com>
To:     linux-btrfs@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] Btrfs: fix race between using extent maps and merging them
In-Reply-To: <20200131140607.26923-1-fdmanana@kernel.org>
References: <20200131140607.26923-1-fdmanana@kernel.org>
Message-Id: <20200205144507.31F5F218AC@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: 4.4+

The bot has tested the following trees: v5.5.1, v5.4.17, v4.19.101, v4.14.169, v4.9.212, v4.4.212.

v5.5.1: Build OK!
v5.4.17: Build OK!
v4.19.101: Build OK!
v4.14.169: Build OK!
v4.9.212: Build failed! Errors:
    fs/btrfs/extent_map.c:238:6: error: implicit declaration of function ‘refcount_read’ [-Werror=implicit-function-declaration]

v4.4.212: Build failed! Errors:
    fs/btrfs/extent_map.c:238:6: error: implicit declaration of function ‘refcount_read’ [-Werror=implicit-function-declaration]


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks,
Sasha
