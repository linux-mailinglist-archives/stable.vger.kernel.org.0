Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5E91EFA09
	for <lists+stable@lfdr.de>; Fri,  5 Jun 2020 16:10:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgFEOKu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Jun 2020 10:10:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:41694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726553AbgFEOKt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Jun 2020 10:10:49 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2636206F0;
        Fri,  5 Jun 2020 14:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591366248;
        bh=T3bksh4XKrIYohL9aAjwAoVhjENaoCmVKili6aSe0JE=;
        h=Date:From:To:To:To:CC:Cc:Subject:In-Reply-To:References:From;
        b=KPPPEsI6QQ2oMGVJ4pWfJBO/rC9qu+HthkKzWvTJIVR4Cw8nwiF0OlOqzWNasQnuc
         o9cqrv0q5RS8cyfFV41VQLfErq6kT47r4wpGgHy0aiSM2C3FK9GXSUpKvDXvPTrzJ6
         /KjYdCLk7pyoaHccdCUx1Flj6ryPmNhKmt/AJ5pI=
Date:   Fri, 05 Jun 2020 14:10:47 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Roberto Sassu <roberto.sassu@huawei.com>
To:     <zohar@linux.ibm.com>, <tiwai@suse.de>
CC:     <linux-integrity@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 2/2] ima: Call ima_calc_boot_aggregate() in ima_eventdigest_init()
In-Reply-To: <20200603150821.8607-2-roberto.sassu@huawei.com>
References: <20200603150821.8607-2-roberto.sassu@huawei.com>
Message-Id: <20200605141048.A2636206F0@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 3ce1217d6cd5 ("ima: define template fields library and new helpers").

The bot has tested the following trees: v5.6.15, v5.4.43, v4.19.125, v4.14.182, v4.9.225, v4.4.225.

v5.6.15: Failed to apply! Possible dependencies:
    6f1a1d103b48 ("ima: Switch to ima_hash_algo for boot aggregate")
    7ca79645a1f8 ("ima: Store template digest directly in ima_template_entry")

v5.4.43: Failed to apply! Possible dependencies:
    6f1a1d103b48 ("ima: Switch to ima_hash_algo for boot aggregate")
    7ca79645a1f8 ("ima: Store template digest directly in ima_template_entry")

v4.19.125: Failed to apply! Possible dependencies:
    100b16a6f290 ("tpm: sort objects in the Makefile")
    1ad6640cd614 ("tpm: move tpm1_pcr_extend to tpm1-cmd.c")
    6f1a1d103b48 ("ima: Switch to ima_hash_algo for boot aggregate")
    70a3199a7101 ("tpm: factor out tpm_get_timeouts()")
    7ca79645a1f8 ("ima: Store template digest directly in ima_template_entry")
    879b589210a9 ("tpm: retrieve digest size of unknown algorithms with PCR read")
    899102bc4518 ("tpm2: add new tpm2 commands according to TCG 1.36")
    95adc6b410b7 ("tpm: use u32 instead of int for PCR index")
    b2d6e6de005e ("tpm: factor out tpm 1.x duration calculation to tpm1-cmd.c")
    c82a330ceced ("tpm: factor out tpm 1.x pm suspend flow into tpm1-cmd.c")
    d4a317563207 ("tpm: move tpm 1.x selftest code from tpm-interface.c tpm1-cmd.c")
    d856c00f7d16 ("tpm: add tpm_calc_ordinal_duration() wrapper")

v4.14.182: Failed to apply! Possible dependencies:
    0bfb23746052 ("tpm: Move eventlog files to a subdirectory")
    100b16a6f290 ("tpm: sort objects in the Makefile")
    58cc1e4faf10 ("tpm: parse TPM event logs based on EFI table")
    5c2a640aff73 ("ima: Use tpm_default_chip() and call TPM functions with a tpm_chip")
    67cb8e113ecd ("tpm: rename event log provider files")
    6f1a1d103b48 ("ima: Switch to ima_hash_algo for boot aggregate")
    7ca79645a1f8 ("ima: Store template digest directly in ima_template_entry")
    879b589210a9 ("tpm: retrieve digest size of unknown algorithms with PCR read")
    95adc6b410b7 ("tpm: use u32 instead of int for PCR index")
    9b01b5356629 ("tpm: Move shared eventlog functions to common.c")
    aad887f66411 ("tpm: use struct tpm_chip for tpm_chip_find_get()")
    b2d6e6de005e ("tpm: factor out tpm 1.x duration calculation to tpm1-cmd.c")
    c82a330ceced ("tpm: factor out tpm 1.x pm suspend flow into tpm1-cmd.c")
    d4a317563207 ("tpm: move tpm 1.x selftest code from tpm-interface.c tpm1-cmd.c")
    fd3ec3663718 ("tpm: move tpm_eventlog.h outside of drivers folder")

v4.9.225: Failed to apply! Possible dependencies:
    02ae1382882f ("tpm: redefine read_log() to handle ACPI/OF at runtime")
    2528a64664f8 ("tpm: define a generic open() method for ascii & bios measurements")
    37f4915fef05 ("tpm: use idr_find(), not idr_find_slowpath()")
    5c2a640aff73 ("ima: Use tpm_default_chip() and call TPM functions with a tpm_chip")
    62bfdacbac4c ("tpm: Do not print an error message when doing TPM auto startup")
    745b361e989a ("tpm: infrastructure for TPM spaces")
    748935eeb72c ("tpm: have event log use the tpm_chip")
    7518a21a9da3 ("tpm: drop tpm1_chip_register(/unregister)")
    84fda15286d1 ("tpm: sanitize constant expressions")
    aaa6f7f6c8bf ("tpm: Clean up reading of timeout and duration capabilities")
    aad887f66411 ("tpm: use struct tpm_chip for tpm_chip_find_get()")
    b1a9b7b602c5 ("tpm: replace symbolic permission with octal for securityfs files")
    c1f92b4b04ad ("tpm: enhance TPM 2.0 PCR extend to support multiple banks")
    c659af78eb7b ("tpm: Check size of response before accessing data")
    ca6d45802201 ("tpm: place kdoc just above tpm_pcr_extend")
    cd9b7631a888 ("tpm: replace dynamically allocated bios_dir with a static array")
    f865c196856d ("tpm: add kdoc for tpm_transmit and tpm_transmit_cmd")

v4.4.225: Failed to apply! Possible dependencies:
    062807f20e3f ("tpm: Remove all uses of drvdata from the TPM Core")
    23d06ff700f5 ("tpm: drop tpm_atmel specific fields from tpm_vendor_specific")
    25112048cd59 ("tpm: rework tpm_get_timeouts()")
    37f4915fef05 ("tpm: use idr_find(), not idr_find_slowpath()")
    4eea703caaac ("tpm: drop 'iobase' from struct tpm_vendor_specific")
    570a36097f30 ("tpm: drop 'irq' from struct tpm_vendor_specific")
    5c2a640aff73 ("ima: Use tpm_default_chip() and call TPM functions with a tpm_chip")
    62bfdacbac4c ("tpm: Do not print an error message when doing TPM auto startup")
    6e599f6f261f ("tpm: drop 'read_queue' from struct tpm_vendor_specific")
    7ab4032fa579 ("tpm_tis: Get rid of the duplicate IRQ probing code")
    84fda15286d1 ("tpm: sanitize constant expressions")
    aaa6f7f6c8bf ("tpm: Clean up reading of timeout and duration capabilities")
    aad887f66411 ("tpm: use struct tpm_chip for tpm_chip_find_get()")
    af782f339a5d ("tpm: Move tpm_vendor_specific data related with PTP specification to tpm_chip")
    c1f92b4b04ad ("tpm: enhance TPM 2.0 PCR extend to support multiple banks")
    c659af78eb7b ("tpm: Check size of response before accessing data")
    d4956524f1b0 ("tpm: drop manufacturer_id from struct tpm_vendor_specific")
    e3837e74a06d ("tpm_tis: Refactor the interrupt setup")
    ee1779840d09 ("tpm: drop 'base' from struct tpm_vendor_specific")
    f865c196856d ("tpm: add kdoc for tpm_transmit and tpm_transmit_cmd")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
