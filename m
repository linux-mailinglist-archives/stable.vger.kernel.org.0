Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E127017D096
	for <lists+stable@lfdr.de>; Sun,  8 Mar 2020 00:20:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgCGXUf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Mar 2020 18:20:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:41114 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbgCGXUf (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 7 Mar 2020 18:20:35 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D3DFE2075B;
        Sat,  7 Mar 2020 23:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583623235;
        bh=XhMk/XnNHsDbDy5lxDWDVGY09IrfM7hjHdn2sdMzPJE=;
        h=Date:From:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=jwze9UjjEUdTkqYdav3E1tbVHb5KNyZxbRhAZlN+a2KDW3QmD+QMzFp/Wbm40sVrR
         Qq0W9Lq1l6jtfBIduIsUb9OnCdEEfv90zlhGJ79qLCY3PP8idK7gY/o52K/GX53VYF
         VdMKw/bvlTo7Fg6IU74Ve57GP/v2BGouOjFO+hLo=
Date:   Sat, 07 Mar 2020 23:20:34 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Nikita Shubin <NShubin@topcon.com>
Cc:     Nikita Shubin <NShubin@topcon.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v5] remoteproc: Fix NULL pointer dereference in rproc_virtio_notify
In-Reply-To: <20200306072452.24743-1-NShubin@topcon.com>
References: <20200306072452.24743-1-NShubin@topcon.com>
Message-Id: <20200307232034.D3DFE2075B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 7a186941626d ("remoteproc: remove the single rpmsg vdev limitation").

The bot has tested the following trees: v5.5.8, v5.4.24, v4.19.108, v4.14.172, v4.9.215, v4.4.215.

v5.5.8: Build OK!
v5.4.24: Build OK!
v4.19.108: Failed to apply! Possible dependencies:
    086d08725d34 ("remoteproc: create vdev subdevice with specific dma memory pool")
    eb30596eae94 ("remoteproc: add rproc_va_to_pa function")

v4.14.172: Failed to apply! Possible dependencies:
    086d08725d34 ("remoteproc: create vdev subdevice with specific dma memory pool")
    eb30596eae94 ("remoteproc: add rproc_va_to_pa function")

v4.9.215: Failed to apply! Possible dependencies:
    086d08725d34 ("remoteproc: create vdev subdevice with specific dma memory pool")
    2b45cef5868a ("remoteproc: Further extend the vdev life cycle")
    a863af5d4193 ("remoteproc: virtio: Anchor vring life cycle in vdev")
    aab8d8022304 ("remoteproc: Assign kref to rproc_vdev")
    eb30596eae94 ("remoteproc: add rproc_va_to_pa function")
    f5bcb35387ef ("remoteproc: Decouple vdev resources and devices")

v4.4.215: Failed to apply! Possible dependencies:
    086d08725d34 ("remoteproc: create vdev subdevice with specific dma memory pool")
    2b45cef5868a ("remoteproc: Further extend the vdev life cycle")
    353861660aa2 ("remoteproc: core: Trivial: Improve error checking, spelling and debug prints")
    3d87fa1d47c1 ("remoteproc: core: Task sync during rproc_fw_boot()")
    9c219b2337b8 ("remoteproc: core: Ensure error message is clear")
    a863af5d4193 ("remoteproc: virtio: Anchor vring life cycle in vdev")
    aab8d8022304 ("remoteproc: Assign kref to rproc_vdev")
    b35d7afc3ba9 ("remoteproc: Calculate max_notifyid during load")
    d81fb32f3da6 ("remoteproc: Move vdev handling to boot/shutdown")
    ddf711872c9d ("remoteproc: Introduce auto-boot flag")
    eb30596eae94 ("remoteproc: add rproc_va_to_pa function")
    f5bcb35387ef ("remoteproc: Decouple vdev resources and devices")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
