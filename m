Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D74DE1C0C54
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 04:55:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728172AbgEACzX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 22:55:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:60138 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727985AbgEACzV (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 22:55:21 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 29058207DD;
        Fri,  1 May 2020 02:55:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588301721;
        bh=AY/2sAFJABO2jGTnMjxy1+23WPlfoZvwL8LoXdIPHpA=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=RHswbWJhwahYzKgGMUyHb3eX1lZHbUiQELgzux4gNsasOrylmZzoQ6um6LkZaiuU2
         ol1eo0MMUFUN3Qgm7HFUvOEKVMaBqbTNKXx+ZbsucaBYUI1VfnLXqetNIFt9eQMzrL
         tH29ndvRWOM4qhvp0YtFbI2cmXK1i1hcjOxjCE5k=
Date:   Fri, 01 May 2020 02:55:20 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Tomas Winkler <tomas.winkler@intel.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Alexander Usyskin <alexander.usyskin@intel.com>
Cc:     <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [char-misc] mei: me: disable mei interface on LBG servers.
In-Reply-To: <20200428211200.12200-1-tomas.winkler@intel.com>
References: <20200428211200.12200-1-tomas.winkler@intel.com>
Message-Id: <20200501025521.29058207DD@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.7, v5.4.35, v4.19.118, v4.14.177, v4.9.220, v4.4.220.

v5.6.7: Build OK!
v5.4.35: Failed to apply! Possible dependencies:
    52f6efdf8092 ("mei: add trc detection register to sysfs")

v4.19.118: Failed to apply! Possible dependencies:
    43b8a7ed4739 ("mei: expose device state in sysfs")
    52f6efdf8092 ("mei: add trc detection register to sysfs")
    ce0925e8c2f8 ("mei: dma ring buffers allocation")

v4.14.177: Failed to apply! Possible dependencies:
    173436ba800d ("mei: me: mark LBG devices as having dma support")
    1be8624a0cbe ("mei: me: add mule creek canyon (EHL) device ids")
    3cfaeb335305 ("mei: expose fw version to sysfs")
    43b8a7ed4739 ("mei: expose device state in sysfs")
    52f6efdf8092 ("mei: add trc detection register to sysfs")
    587f17407741 ("mei: me: add Tiger Lake point LP device ID")
    7026a5fd7f2c ("mei: define dma ring buffer sizes for PCH12 HW and newer")
    8d52af6795c0 ("mei: speed up the power down flow")
    af336cabe083 ("mei: limit the number of queued writes")
    ce0925e8c2f8 ("mei: dma ring buffers allocation")
    efe814e90b98 ("mei: me: add ice lake point device id.")
    f8204f0ddd62 ("mei: avoid FW version request on Ibex Peak and earlier")

v4.9.220: Failed to apply! Possible dependencies:
    17ba8a08b58a ("mei: consolidate repeating code in mei_cl_irq_read_msg")
    29fe7d59bdd8 ("mei: make mei_io_list_flush static")
    3cfaeb335305 ("mei: expose fw version to sysfs")
    43b8a7ed4739 ("mei: expose device state in sysfs")
    52f6efdf8092 ("mei: add trc detection register to sysfs")
    6537ae2f2041 ("mei: amthif: clean command queue upon disconnection")
    7026a5fd7f2c ("mei: define dma ring buffer sizes for PCH12 HW and newer")
    88d1bece891f ("mei: show the HBM protocol versions in the device attributes")
    962ff7bcec24 ("mei: replace callback structures used as list head by list_head")
    9ecdbc58f96b ("mei: amthif: allow the read completion after close")
    a2eb0fc07f4d ("mei: fix the back to back interrupt handling")
    af336cabe083 ("mei: limit the number of queued writes")
    e0cb6b2f878d ("mei: enable to set the internal flag for client write")
    f046192d98c9 ("mei: revamp io list cleanup function.")
    f5ac3c49ff0b ("mei: me: use an index instead of a pointer for private data")

v4.4.220: Failed to apply! Possible dependencies:
    32a1dc1d02eb ("mei: amthif: fix request cancel")
    3cfaeb335305 ("mei: expose fw version to sysfs")
    43b8a7ed4739 ("mei: expose device state in sysfs")
    4bddf56fc93c ("mei: amthif: use rx_wait queue also for amthif client")
    52f6efdf8092 ("mei: add trc detection register to sysfs")
    62e8e6ad6097 ("mei: rename variable names 'file_object' to fp")
    7026a5fd7f2c ("mei: define dma ring buffer sizes for PCH12 HW and newer")
    77537ad2917b ("mei: recover after errors in runtime pm flow")
    88d1bece891f ("mei: show the HBM protocol versions in the device attributes")
    8b2458f413c4 ("mei: always copy the read buffer if data is ready")
    9abd8b312924 ("mei: amthif: replace amthif_rd_complete_list with rd_completed")
    af336cabe083 ("mei: limit the number of queued writes")
    c85dba9e8737 ("mei: amthif: drop mei_clear_lists function")
    f046192d98c9 ("mei: revamp io list cleanup function.")
    f23e2cc4bb1d ("mei: constify struct file pointer")
    f5ac3c49ff0b ("mei: me: use an index instead of a pointer for private data")
    f862b6b24f0f ("mei: fix possible integer overflow issue")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
