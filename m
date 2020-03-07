Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2F85917D098
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 00:20:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbgCGXUi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 18:20:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:41198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726319AbgCGXUh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Mar 2020 18:20:37 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1471C207FD;
        Sat,  7 Mar 2020 23:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583623237;
        bh=ZSf66mFr7oEMCFiPlvwqW1BttSBfQuOHrrWOYvFYtI0=;
        h=Date:From:To:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=Df0s5yarsGcwkMn+KNkrjxwDZcHkajaPD64REL7NG4Hx5TqOwXdRtTp9CitTMqWVt
         Z+0j+unfQ/NVYxphvPgRiHTbLQjIuSVELIvFDNnB7AmW1vQHL3F6IfECqS5bfzI/VK
         sszbw9d+eKFf3ljZgnt7lKN4YvTZrxC6ITgg0QoI=
Date:   Sat, 07 Mar 2020 23:20:36 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Leon Romanovsky <leon@kernel.org>
To:     Alex Vesker <valex@mellanox.com>
To:     Doug Ledford <dledford@redhat.com>
Cc:     Alex Vesker <valex@mellanox.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH rdma-rc] IB/mlx5: Replace tunnel mpls capability bits for tunnel_offloads
In-Reply-To: <20200305123841.196086-1-leon@kernel.org>
References: <20200305123841.196086-1-leon@kernel.org>
Message-Id: <20200307232037.1471C207FD@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: e818e255a58d ("IB/mlx5: Expose MPLS related tunneling offloads").

The bot has tested the following trees: v5.5.8, v5.4.24, v4.19.108.

v5.5.8: Build OK!
v5.4.24: Build OK!
v4.19.108: Failed to apply! Possible dependencies:
    caa185473544 ("net/mlx5: Expose IP-in-IP capability bit")
    db849faa9bef ("net/mlx5e: Rx, Fix checksum calculation for new hardware")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
