Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52AC0264AE4
	for <lists+stable@lfdr.de>; Thu, 10 Sep 2020 19:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726167AbgIJRQY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Sep 2020 13:16:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:45100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726970AbgIJQee (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Sep 2020 12:34:34 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CFAEC221E2;
        Thu, 10 Sep 2020 16:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599755661;
        bh=mNlP4ZrHGlhkDK0ugXlEzoq3K3ZLkqBvofzdPSoe+vI=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=iyLnNADRcEtXDXWuS9gAVtLDHgaS73WIsuw8yfJ+bQ0jys4rD6jd0O0bHbxn3yPE7
         LTizhwvNZrQaCSyvN5YD22//YDK6lDFPFMFfBfPnTZ4vqfXYv1JyXNuWQLFJzETuxs
         V/QsldXFJ65BXk4hhIaZd2bmpMjMUdHuC2xfrCK8=
Date:   Thu, 10 Sep 2020 16:34:20 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Arnd Bergmann <arnd@arndb.de>
To:     Kashyap Desai <kashyap.desai@broadcom.com>
Cc:     hch@infradead.org, Arnd Bergmann <arnd@arndb.de>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/3] scsi: megaraid_sas: check user-provided offsets
In-Reply-To: <20200908213715.3553098-2-arnd@arndb.de>
References: <20200908213715.3553098-2-arnd@arndb.de>
Message-Id: <20200910163420.CFAEC221E2@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.8.7, v5.4.63, v4.19.143, v4.14.196, v4.9.235, v4.4.235.

v5.8.7: Build OK!
v5.4.63: Build OK!
v4.19.143: Build OK!
v4.14.196: Failed to apply! Possible dependencies:
    107a60dd71b5 ("scsi: megaraid_sas: Add support for 64bit consistent DMA")
    1b4bed206159 ("scsi: megaraid_sas: Create separate functions for allocating and freeing controller DMA buffers")
    201a810cc188 ("scsi: megaraid_sas: Re-Define enum DCMD_RETURN_STATUS")
    2ce435087902 ("scsi: megaraid_sas: Enhance internal DCMD timeout prints")
    7535f27d1f14 ("scsi: megaraid_sas: Move initialization of instance parameters inside newly created function megasas_init_ctrl_params")
    82add4e1b354 ("scsi: megaraid_sas: Incorrect processing of IOCTL frames for SMP/STP commands")
    e5d65b4b81af ("scsi: megaraid_sas: Move controller memory allocations and DMA mask settings from probe to megasas_init_fw")
    e97e673ca63b ("scsi: megaraid_sas: Retry with reduced queue depth when alloc fails for higher QD")

v4.9.235: Failed to apply! Possible dependencies:
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

v4.4.235: Failed to apply! Possible dependencies:
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
