Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C98025FCA3
	for <lists+stable@lfdr.de>; Mon,  7 Sep 2020 17:07:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730086AbgIGPHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Sep 2020 11:07:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:35086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730102AbgIGPDv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Sep 2020 11:03:51 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0265921481;
        Mon,  7 Sep 2020 15:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1599491020;
        bh=XbIVvWsfCm/G4p7cNAOocEkxrFTNNurqa0/U1011ZAU=;
        h=Date:From:To:To:To:CC:Cc:Cc:Subject:In-Reply-To:References:From;
        b=vj1ADFg4g1PfpVI+j3WGSpo5j3udA0cWvuAis+rlnmN0MBjHRt9rZsx5dWSh2GJL0
         hESTcUQLVTk5zHX8kDOUJW7kV9AgjGBcyAlsNSmMP8tWThJ6IJECMeZZqpCeyxv2L/
         Q7/q114QZNiQzcnIEsRkBAN/KVXgRh6qHNZRvc0c=
Date:   Mon, 07 Sep 2020 15:03:39 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <mjg59@google.com>
CC:     <linux-integrity@vger.kernel.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2 01/12] ima: Don't ignore errors from crypto_shash_update()
In-Reply-To: <20200904092339.19598-2-roberto.sassu@huawei.com>
References: <20200904092339.19598-2-roberto.sassu@huawei.com>
Message-Id: <20200907150340.0265921481@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 3323eec921ef ("integrity: IMA as an integrity service provider").

The bot has tested the following trees: v5.8.7, v5.4.63, v4.19.143, v4.14.196, v4.9.235, v4.4.235.

v5.8.7: Build OK!
v5.4.63: Build OK!
v4.19.143: Failed to apply! Possible dependencies:
    100b16a6f290 ("tpm: sort objects in the Makefile")
    6f1a1d103b48 ("ima: Switch to ima_hash_algo for boot aggregate")
    70a3199a7101 ("tpm: factor out tpm_get_timeouts()")
    879b589210a9 ("tpm: retrieve digest size of unknown algorithms with PCR read")
    95adc6b410b7 ("tpm: use u32 instead of int for PCR index")
    b03c43702e7b ("tpm: add tpm_auto_startup() into tpm-interface.c")
    b2d6e6de005e ("tpm: factor out tpm 1.x duration calculation to tpm1-cmd.c")
    c82a330ceced ("tpm: factor out tpm 1.x pm suspend flow into tpm1-cmd.c")
    d4a317563207 ("tpm: move tpm 1.x selftest code from tpm-interface.c tpm1-cmd.c")
    d856c00f7d16 ("tpm: add tpm_calc_ordinal_duration() wrapper")

v4.14.196: Failed to apply! Possible dependencies:
    5ef924d9e2e8 ("tpm: use tpm_msleep() value as max delay")
    6f1a1d103b48 ("ima: Switch to ima_hash_algo for boot aggregate")
    879b589210a9 ("tpm: retrieve digest size of unknown algorithms with PCR read")
    95adc6b410b7 ("tpm: use u32 instead of int for PCR index")
    aad887f66411 ("tpm: use struct tpm_chip for tpm_chip_find_get()")
    b03c43702e7b ("tpm: add tpm_auto_startup() into tpm-interface.c")
    c82a330ceced ("tpm: factor out tpm 1.x pm suspend flow into tpm1-cmd.c")
    d4a317563207 ("tpm: move tpm 1.x selftest code from tpm-interface.c tpm1-cmd.c")
    fc1d52b745ba ("tpm: rename tpm_chip_find_get() to tpm_find_get_ops()")

v4.9.235: Failed to apply! Possible dependencies:
    06e93279ca77 ("tpm: move endianness conversion of TPM_TAG_RQU_COMMAND to tpm_input_header")
    175d5b2a570c ("tpm: move TPM 1.2 code of tpm_pcr_extend() to tpm1_pcr_extend()")
    37f4915fef05 ("tpm: use idr_find(), not idr_find_slowpath()")
    51b0be640cf6 ("tpm: Fix expected number of response bytes of TPM1.2 PCR Extend")
    62bfdacbac4c ("tpm: Do not print an error message when doing TPM auto startup")
    6f1a1d103b48 ("ima: Switch to ima_hash_algo for boot aggregate")
    84fda15286d1 ("tpm: sanitize constant expressions")
    879b589210a9 ("tpm: retrieve digest size of unknown algorithms with PCR read")
    a69faebf4d3e ("tpm: move endianness conversion of ordinals to tpm_input_header")
    aaa6f7f6c8bf ("tpm: Clean up reading of timeout and duration capabilities")
    aad887f66411 ("tpm: use struct tpm_chip for tpm_chip_find_get()")
    c659af78eb7b ("tpm: Check size of response before accessing data")
    ca6d45802201 ("tpm: place kdoc just above tpm_pcr_extend")
    f865c196856d ("tpm: add kdoc for tpm_transmit and tpm_transmit_cmd")

v4.4.235: Failed to apply! Possible dependencies:
    0014777f989b ("tpm: constify TPM 1.x header structures")
    062807f20e3f ("tpm: Remove all uses of drvdata from the TPM Core")
    06e93279ca77 ("tpm: move endianness conversion of TPM_TAG_RQU_COMMAND to tpm_input_header")
    175d5b2a570c ("tpm: move TPM 1.2 code of tpm_pcr_extend() to tpm1_pcr_extend()")
    25112048cd59 ("tpm: rework tpm_get_timeouts()")
    3635e2ec7cbb ("tpm: Get rid of devname")
    37f4915fef05 ("tpm: use idr_find(), not idr_find_slowpath()")
    570a36097f30 ("tpm: drop 'irq' from struct tpm_vendor_specific")
    6e599f6f261f ("tpm: drop 'read_queue' from struct tpm_vendor_specific")
    6f1a1d103b48 ("ima: Switch to ima_hash_algo for boot aggregate")
    7ab4032fa579 ("tpm_tis: Get rid of the duplicate IRQ probing code")
    84fda15286d1 ("tpm: sanitize constant expressions")
    879b589210a9 ("tpm: retrieve digest size of unknown algorithms with PCR read")
    a69faebf4d3e ("tpm: move endianness conversion of ordinals to tpm_input_header")
    aad887f66411 ("tpm: use struct tpm_chip for tpm_chip_find_get()")
    af782f339a5d ("tpm: Move tpm_vendor_specific data related with PTP specification to tpm_chip")
    c659af78eb7b ("tpm: Check size of response before accessing data")
    ddab0e34288a ("tpm/st33zp24: Remove unneeded tpm_reg in get_burstcount")
    e3837e74a06d ("tpm_tis: Refactor the interrupt setup")
    f865c196856d ("tpm: add kdoc for tpm_transmit and tpm_transmit_cmd")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
