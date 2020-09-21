Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 543C1272445
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 14:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726518AbgIUMyt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 08:54:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:60082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726395AbgIUMyt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 08:54:49 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 447672193E;
        Mon, 21 Sep 2020 12:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600692888;
        bh=1HrM3lSYOfEBUKOAwGhTGYDJhG1Lrr0XYiFktET6Pxw=;
        h=Date:From:To:To:To:Cc:Cc:Subject:In-Reply-To:References:From;
        b=CNCaaWv4SaZNGVnlB4VpvRDH7JDRmqbr2sYyZwdvFMmJvVSCxBJ5JPTwo3577yV5X
         oQDZsOhzX3ga9EJeh9p1rkocG/1FNT8FBnE3MKQvX7oA6n/4G+kT5Dt+XLqJxQe3/f
         TBV4xx2+npTmjBz/bhRDcKGjCZfoA/Kl2cHoq1Xw=
Date:   Mon, 21 Sep 2020 12:54:47 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     Christoph Hellwig <hch@infradead.org>, anand.lodnoor@broadcom.com
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 2/3] scsi: megaraid_sas: check user-provided offsets
In-Reply-To: <20200918121522.1466028-1-arnd@arndb.de>
References: <20200918121522.1466028-1-arnd@arndb.de>
Message-Id: <20200921125448.447672193E@mail.kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: c4a3e0a529ab ("[SCSI] MegaRAID SAS RAID: new driver").

The bot has tested the following trees: v5.8.10, v5.4.66, v4.19.146, v4.14.198, v4.9.236, v4.4.236.

v5.8.10: Build OK!
v5.4.66: Build OK!
v4.19.146: Build OK!
v4.14.198: Failed to apply! Possible dependencies:
    107a60dd71b5 ("scsi: megaraid_sas: Add support for 64bit consistent DMA")
    1b4bed206159 ("scsi: megaraid_sas: Create separate functions for allocating and freeing controller DMA buffers")
    201a810cc188 ("scsi: megaraid_sas: Re-Define enum DCMD_RETURN_STATUS")
    2ce435087902 ("scsi: megaraid_sas: Enhance internal DCMD timeout prints")
    7535f27d1f14 ("scsi: megaraid_sas: Move initialization of instance parameters inside newly created function megasas_init_ctrl_params")
    82add4e1b354 ("scsi: megaraid_sas: Incorrect processing of IOCTL frames for SMP/STP commands")
    e5d65b4b81af ("scsi: megaraid_sas: Move controller memory allocations and DMA mask settings from probe to megasas_init_fw")
    e97e673ca63b ("scsi: megaraid_sas: Retry with reduced queue depth when alloc fails for higher QD")

v4.9.236: Failed to apply! Possible dependencies:
    201a810cc188 ("scsi: megaraid_sas: Re-Define enum DCMD_RETURN_STATUS")
    2493c67e518c ("scsi: megaraid_sas: 128 MSIX Support")
    3e5eadb1a881 ("scsi: megaraid_sas: Enable or Disable Fast path based on the PCI Threshold Bandwidth")
    45b8a35eed7b ("scsi: megaraid_sas: 32 bit descriptor fire cmd optimization")
    45f4f2eb3da3 ("scsi: megaraid_sas: Add new pci device Ids for SAS3.5 Generic Megaraid Controllers")
    82add4e1b354 ("scsi: megaraid_sas: Incorrect processing of IOCTL frames for SMP/STP commands")
    8823abeddbbc ("scsi: megaraid_sas: Fix endianness issues in DCMD handling")
    95c060869e68 ("scsi: megaraid_sas: latest controller OCR capability from FW before sending shutdown DCMD")
    d0fc91d67c59 ("scsi: megaraid_sas: Send SYNCHRONIZE_CACHE for VD to firmware")
    f4fc209326c7 ("scsi: megaraid_sas: change issue_dcmd to return void from int")
    fad119b707f8 ("scsi: megaraid_sas: switch to pci_alloc_irq_vectors")

v4.4.236: Failed to apply! Possible dependencies:
    201a810cc188 ("scsi: megaraid_sas: Re-Define enum DCMD_RETURN_STATUS")
    6d40afbc7d13 ("megaraid_sas: MFI IO timeout handling")
    82add4e1b354 ("scsi: megaraid_sas: Incorrect processing of IOCTL frames for SMP/STP commands")
    8823abeddbbc ("scsi: megaraid_sas: Fix endianness issues in DCMD handling")
    8a01a41d8647 ("megaraid_sas: Make adprecovery variable atomic")
    95c060869e68 ("scsi: megaraid_sas: latest controller OCR capability from FW before sending shutdown DCMD")
    f4fc209326c7 ("scsi: megaraid_sas: change issue_dcmd to return void from int")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
