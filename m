Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C9F3218D661
	for <lists+stable@lfdr.de>; Fri, 20 Mar 2020 18:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727304AbgCTR7r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Mar 2020 13:59:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:57132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726801AbgCTR7q (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Mar 2020 13:59:46 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B8F920663;
        Fri, 20 Mar 2020 17:59:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584727185;
        bh=m85KmfGIa5J6kHFrbVlcvE04dIaNYgTd2clrhmeL70k=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=NTbJ/ctoChWlfVnXNUb+odQWShz8p41aNye1ayNP9Hs89E+UImKUWBytFkjwin8Zy
         CB75xNcxL9Z/lV0axsrVio0h9IZqqR1gQuwPemq1Jj/QUXS6Y0/lbj6yerLDvNSAix
         Z5hm3lnyhW4uMI6UGxKqjlMOGyV2AfBNtBglwhTg=
Date:   Fri, 20 Mar 2020 17:59:44 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     George Wilson <gcwilson@linux.ibm.com>
To:     linux-integrity@vger.kernel.org
Cc:     Alexey Kardashevskiy <aik@ozlabs.ru>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v4] tpm: ibmvtpm: retry on H_CLOSED in tpm_ibmvtpm_send()
In-Reply-To: <20200320032758.228088-1-gcwilson@linux.ibm.com>
References: <20200320032758.228088-1-gcwilson@linux.ibm.com>
Message-Id: <20200320175945.6B8F920663@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 132f76294744 ("drivers/char/tpm: Add new device driver to support IBM vTPM").

The bot has tested the following trees: v5.5.10, v5.4.26, v4.19.111, v4.14.173, v4.9.216, v4.4.216.

v5.5.10: Build OK!
v5.4.26: Build OK!
v4.19.111: Build OK!
v4.14.173: Build OK!
v4.9.216: Failed to apply! Possible dependencies:
    02ae1382882f ("tpm: redefine read_log() to handle ACPI/OF at runtime")
    2528a64664f8 ("tpm: define a generic open() method for ascii & bios measurements")
    402149c6470d ("tpm: vtpm_proxy: Suppress error logging when in closed state")
    4d23cc323cdb ("tpm: add securityfs support for TPM 2.0 firmware event log")
    745b361e989a ("tpm: infrastructure for TPM spaces")
    748935eeb72c ("tpm: have event log use the tpm_chip")
    7518a21a9da3 ("tpm: drop tpm1_chip_register(/unregister)")
    b1a9b7b602c5 ("tpm: replace symbolic permission with octal for securityfs files")
    cd9b7631a888 ("tpm: replace dynamically allocated bios_dir with a static array")
    f5595f5baa30 ("tpm: Unify the send callback behaviour")

v4.4.216: Failed to apply! Possible dependencies:
    02ae1382882f ("tpm: redefine read_log() to handle ACPI/OF at runtime")
    036bb38ffb3e ("tpm_tis: Ensure interrupts are disabled when the driver starts")
    23d06ff700f5 ("tpm: drop tpm_atmel specific fields from tpm_vendor_specific")
    25112048cd59 ("tpm: rework tpm_get_timeouts()")
    402149c6470d ("tpm: vtpm_proxy: Suppress error logging when in closed state")
    41a5e1cf1fe1 ("tpm/tpm_tis: Split tpm_tis driver into a core and TCG TIS compliant phy")
    4d627e672bd0 ("tpm_tis: Do not fall back to a hardcoded address for TPM2")
    4eea703caaac ("tpm: drop 'iobase' from struct tpm_vendor_specific")
    51dd43dff74b ("tpm_tis: Use devm_ioremap_resource")
    55a889c2cb13 ("tpm_crb: Use the common ACPI definition of struct acpi_tpm2")
    56671c893e0e ("tpm: drop 'locality' from struct tpm_vendor_specific")
    570a36097f30 ("tpm: drop 'irq' from struct tpm_vendor_specific")
    57dacc2b4ce5 ("tpm: tpm_tis: Share common data between phys")
    745b361e989a ("tpm: infrastructure for TPM spaces")
    7ab4032fa579 ("tpm_tis: Get rid of the duplicate IRQ probing code")
    d30b8e4f68ef ("tpm: cleanup tpm_tis_remove()")
    d4956524f1b0 ("tpm: drop manufacturer_id from struct tpm_vendor_specific")
    e3837e74a06d ("tpm_tis: Refactor the interrupt setup")
    ee1779840d09 ("tpm: drop 'base' from struct tpm_vendor_specific")
    ef7b81dc7864 ("tpm_tis: Disable interrupt auto probing on a per-device basis")
    f5595f5baa30 ("tpm: Unify the send callback behaviour")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
