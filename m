Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9962B46C26
	for <lists+stable@lfdr.de>; Fri, 14 Jun 2019 23:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfFNV4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Jun 2019 17:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726792AbfFNV4g (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Jun 2019 17:56:36 -0400
Received: from localhost (unknown [23.100.24.84])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2D9BD2184E;
        Fri, 14 Jun 2019 21:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560549395;
        bh=AaOXU9JSXW7lKOl4hZybnR5+zYZKfEbQwzFRA41gvv8=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=xWMm4yhEKB2Mx1cp5Ek+eYiTWFnytpnjFNZSnN05no6V8kPXEEnXPN7LOMhs3CKgh
         qP7UlS4SQtOeKJy3UIgInMEYMOWpVcMQo/QAhXJR//VZEPPU3Il/2DKQwGIwjMBbIX
         HrmYcOoZKI0ZdObfongKn+lIRHTWALWJuJeehGb0=
Date:   Fri, 14 Jun 2019 21:56:34 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Milan Broz <gmazyland@gmail.com>
To:     linux-integrity@vger.kernel.org
Cc:     Milan Broz <gmazyland@gmail.com>, stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] tpm: Fix null pointer dereference on chip register error path
In-Reply-To: <20190612084210.13562-1-gmazyland@gmail.com>
References: <20190612084210.13562-1-gmazyland@gmail.com>
Message-Id: <20190614215635.2D9BD2184E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.1.9, v4.19.50, v4.14.125, v4.9.181, v4.4.181.

v5.1.9: Build OK!
v4.19.50: Failed to apply! Possible dependencies:
    100b16a6f290 ("tpm: sort objects in the Makefile")
    29b47ce98759 ("tpm: move TPM space code out of tpm_transmit()")
    412eb585587a ("tpm: use tpm_buf in tpm_transmit_cmd() as the IO parameter")
    5faafbab77e3 ("tpm: remove @space from tpm_transmit()")
    70a3199a7101 ("tpm: factor out tpm_get_timeouts()")
    719b7d81f204 ("tpm: introduce tpm_chip_start() and tpm_chip_stop()")
    899102bc4518 ("tpm2: add new tpm2 commands according to TCG 1.36")
    9db7fe187c54 ("tpm: factor out tpm_startup function")
    9e1b74a63f77 ("tpm: add support for nonblocking operation")
    b2d6e6de005e ("tpm: factor out tpm 1.x duration calculation to tpm1-cmd.c")
    b34b77a99b1a ("tpm: declare struct tpm_header")
    c3465a370fb3 ("tpm: move tpm_validate_commmand() to tpm2-space.c")
    c3d477a725ef ("tpm: add ptr to the tpm_space struct to file_priv")
    c4df71d43a5b ("tpm: encapsulate tpm_dev_transmit()")
    d856c00f7d16 ("tpm: add tpm_calc_ordinal_duration() wrapper")

v4.14.125: Failed to apply! Possible dependencies:
    09dd144f72e7 ("tpm: Add explicit endianness cast")
    0bfb23746052 ("tpm: Move eventlog files to a subdirectory")
    100b16a6f290 ("tpm: sort objects in the Makefile")
    58cc1e4faf10 ("tpm: parse TPM event logs based on EFI table")
    67cb8e113ecd ("tpm: rename event log provider files")
    719b7d81f204 ("tpm: introduce tpm_chip_start() and tpm_chip_stop()")
    9b01b5356629 ("tpm: Move shared eventlog functions to common.c")
    b2d6e6de005e ("tpm: factor out tpm 1.x duration calculation to tpm1-cmd.c")
    d856c00f7d16 ("tpm: add tpm_calc_ordinal_duration() wrapper")
    fd3ec3663718 ("tpm: move tpm_eventlog.h outside of drivers folder")

v4.9.181: Failed to apply! Possible dependencies:
    02ae1382882f ("tpm: redefine read_log() to handle ACPI/OF at runtime")
    100b16a6f290 ("tpm: sort objects in the Makefile")
    2528a64664f8 ("tpm: define a generic open() method for ascii & bios measurements")
    719b7d81f204 ("tpm: introduce tpm_chip_start() and tpm_chip_stop()")
    748935eeb72c ("tpm: have event log use the tpm_chip")
    7518a21a9da3 ("tpm: drop tpm1_chip_register(/unregister)")
    9b01b5356629 ("tpm: Move shared eventlog functions to common.c")
    b1a9b7b602c5 ("tpm: replace symbolic permission with octal for securityfs files")
    b2d6e6de005e ("tpm: factor out tpm 1.x duration calculation to tpm1-cmd.c")
    cd9b7631a888 ("tpm: replace dynamically allocated bios_dir with a static array")
    d856c00f7d16 ("tpm: add tpm_calc_ordinal_duration() wrapper")

v4.4.181: Failed to apply! Possible dependencies:
    02ae1382882f ("tpm: redefine read_log() to handle ACPI/OF at runtime")
    036bb38ffb3e ("tpm_tis: Ensure interrupts are disabled when the driver starts")
    100b16a6f290 ("tpm: sort objects in the Makefile")
    23d06ff700f5 ("tpm: drop tpm_atmel specific fields from tpm_vendor_specific")
    25112048cd59 ("tpm: rework tpm_get_timeouts()")
    41a5e1cf1fe1 ("tpm/tpm_tis: Split tpm_tis driver into a core and TCG TIS compliant phy")
    4d627e672bd0 ("tpm_tis: Do not fall back to a hardcoded address for TPM2")
    4eea703caaac ("tpm: drop 'iobase' from struct tpm_vendor_specific")
    51dd43dff74b ("tpm_tis: Use devm_ioremap_resource")
    55a889c2cb13 ("tpm_crb: Use the common ACPI definition of struct acpi_tpm2")
    56671c893e0e ("tpm: drop 'locality' from struct tpm_vendor_specific")
    570a36097f30 ("tpm: drop 'irq' from struct tpm_vendor_specific")
    57dacc2b4ce5 ("tpm: tpm_tis: Share common data between phys")
    719b7d81f204 ("tpm: introduce tpm_chip_start() and tpm_chip_stop()")
    7ab4032fa579 ("tpm_tis: Get rid of the duplicate IRQ probing code")
    b2d6e6de005e ("tpm: factor out tpm 1.x duration calculation to tpm1-cmd.c")
    d30b8e4f68ef ("tpm: cleanup tpm_tis_remove()")
    d4956524f1b0 ("tpm: drop manufacturer_id from struct tpm_vendor_specific")
    d856c00f7d16 ("tpm: add tpm_calc_ordinal_duration() wrapper")
    e3837e74a06d ("tpm_tis: Refactor the interrupt setup")
    ee1779840d09 ("tpm: drop 'base' from struct tpm_vendor_specific")
    ef7b81dc7864 ("tpm_tis: Disable interrupt auto probing on a per-device basis")


How should we proceed with this patch?

--
Thanks,
Sasha
