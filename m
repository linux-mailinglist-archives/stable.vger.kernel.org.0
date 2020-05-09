Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48C8C1CC14E
	for <lists+stable@lfdr.de>; Sat,  9 May 2020 14:30:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728388AbgEIMay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 May 2020 08:30:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:60104 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726370AbgEIMau (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 9 May 2020 08:30:50 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35DEA24955;
        Sat,  9 May 2020 12:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589027450;
        bh=eCjMpbaNJxg0ww4qqESu0qP9xE4Bnq65Wj/Gj97mpyA=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Cc:Subject:
         In-Reply-To:References:From;
        b=X9J1uWDkaKGUDnpGaFjXSST9hY/dt8km1C5Sn+e/1wkaseQxuDVWtGCmJNdYCBwL7
         vk5N77QcfZr9g5OG67FCYZF5ZeVMImn4uLv+92+bQTgZdvFEKb2wezMwq20tNFagVr
         l0Mq66FvTZYsgqLP5JYc4Z3WWN9HkFIOg3WPUS6w=
Date:   Sat, 09 May 2020 12:30:49 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Dan Williams <dan.j.williams@intel.com>
To:     rafael.j.wysocki@intel.com
Cc:     stable@vger.kernel.org, Len Brown <lenb@kernel.org>
Cc:     <stable@vger.kernel.org>
Cc:     Len Brown <lenb@kernel.org>
Cc:     Borislav Petkov <bp@alien8.de>
Cc:     Ira Weiny <ira.weiny@intel.com>
Cc:     James Morse <james.morse@arm.com>
Cc:     Erik Kaneda <erik.kaneda@intel.com>
Cc:     Myron Stowe <myron.stowe@redhat.com>
Cc:     "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] ACPI: Drop rcu usage for MMIO mappings
In-Reply-To: <158889473309.2292982.18007035454673387731.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <158889473309.2292982.18007035454673387731.stgit@dwillia2-desk3.amr.corp.intel.com>
Message-Id: <20200509123050.35DEA24955@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 620242ae8c3d ("ACPI: Maintain a list of ACPI memory mapped I/O remappings").

The bot has tested the following trees: v5.6.11, v5.4.39, v4.19.121, v4.14.179, v4.9.222, v4.4.222.

v5.6.11: Build OK!
v5.4.39: Build OK!
v4.19.121: Failed to apply! Possible dependencies:
    bee6f87166e9 ("acpi: Use built-in RCU list checking for acpi_ioremaps list")

v4.14.179: Failed to apply! Possible dependencies:
    bee6f87166e9 ("acpi: Use built-in RCU list checking for acpi_ioremaps list")
    eeb2d80d502a ("ACPI / LPIT: Add Low Power Idle Table (LPIT) support")

v4.9.222: Failed to apply! Possible dependencies:
    bee6f87166e9 ("acpi: Use built-in RCU list checking for acpi_ioremaps list")
    d44fa3d46079 ("ACPI: Add support for ResourceSource/IRQ domain mapping")
    eeb2d80d502a ("ACPI / LPIT: Add Low Power Idle Table (LPIT) support")

v4.4.222: Failed to apply! Possible dependencies:
    05d961320ba6 ("of: earlycon: Fixup earlycon console name and index")
    088da2a17619 ("of: earlycon: Initialize port fields from DT properties")
    2eaa790989e0 ("earlycon: Use common framework for earlycon declarations")
    4d118c9a8665 ("of: earlycon: Add options string handling")
    5ae74f2cc2f1 ("ACPI / tables: Move table override mechanisms to tables.c")
    836d0830188a ("ACPI / debugger: Add module support for ACPI debugger")
    8cfb0cdf07e2 ("ACPI / debugger: Add IO interface to access debugger functionalities")
    a543132ee04d ("ACPI / OSL: Clean up initrd table override code")
    ad1696f6f09d ("ACPI: parse SPCR and enable matching console")
    af06f8b7a102 ("ACPI / x86: Cleanup initrd related code")
    bee6f87166e9 ("acpi: Use built-in RCU list checking for acpi_ioremaps list")
    c85cc817e5b6 ("ACPI / OSL: Add support to install tables via initrd")
    d503187b6cc4 ("of/serial: move earlycon early_param handling to serial")
    da3d3f98d28b ("ACPI / tables: table upgrade: refactor function definitions")
    eeb2d80d502a ("ACPI / LPIT: Add Low Power Idle Table (LPIT) support")
    f8d31489629c ("ACPICA: Debugger: Convert some mechanisms to OSPM specific")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
