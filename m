Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 934D91C7E05
	for <lists+stable@lfdr.de>; Thu,  7 May 2020 01:42:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728146AbgEFXmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 May 2020 19:42:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:55518 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728105AbgEFXmJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 May 2020 19:42:09 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9B4F22075E;
        Wed,  6 May 2020 23:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588808528;
        bh=xE5UCydrZdLXC/0XxDrxTwDC9mtYeBtrSi/8/nUIkvM=;
        h=Date:From:To:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:
         From;
        b=nqe9SqGytaIBBrEi3MDQGKxroo/OKW/2JmNAyJIHcPryUGOWIr63DUKGCW/iQk9Yd
         agccir07kwNrVdVwW4xcx6WmJ5x322ePsd+SbNlHmQlQmAkH2Jc4078ORCGR587uM4
         IdZ12TBrplw6jl8uVj+nU7QF80br7AXhdYjlvu6I=
Date:   Wed, 06 May 2020 23:42:07 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Michal Simek <michal.simek@xilinx.com>
To:     Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
To:     linux-kernel@vger.kernel.org, monstr@monstr.eu
Cc:     Shubhrajyoti Datta <shubhrajyoti.datta@xilinx.com>
Cc:     stable <stable@vger.kernel.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH v2] tty: xilinx_uartps: Fix missing id assignment to the console
In-Reply-To: <ed3111533ef5bd342ee5ec504812240b870f0853.1588602446.git.michal.simek@xilinx.com>
References: <ed3111533ef5bd342ee5ec504812240b870f0853.1588602446.git.michal.simek@xilinx.com>
Message-Id: <20200506234208.9B4F22075E@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.6.10, v5.4.38, v4.19.120, v4.14.178, v4.9.221, v4.4.221.

v5.6.10: Build OK!
v5.4.38: Build OK!
v4.19.120: Failed to apply! Possible dependencies:
    024ca329bfb9 ("serial: uartps: Register own uart console and driver structures")
    10a5315b47b0 ("serial: uartps: Fill struct uart_driver in probe()")
    14090ad1805f ("serial: uartps: Move alias reading higher in probe()")
    18cc7ac8a28e ("Revert "serial: uartps: Register own uart console and driver structures"")
    427c8ae9bebc ("serial: uartps: Change logic how console_port is setup")
    46a460f0150a ("serial: uartps: Do not use static struct uart_driver out of probe()")
    8da1a3940da4 ("Revert "serial: uartps: Use the same dynamic major number for all ports"")
    ab262666018d ("serial: uartps: Use the same dynamic major number for all ports")
    bed25ac0e2b6 ("serial: uartps: Move Port ID to device data structure")
    e4bbb5194ea3 ("serial: uartps: Move register to probe based on run time detection")

v4.14.178: Failed to apply! Possible dependencies:
    024ca329bfb9 ("serial: uartps: Register own uart console and driver structures")
    0413fe045dda ("serial: uartps: Use dynamic array for console port")
    0a84bae7edfb ("serial: uartps: Remove static port array")
    10a5315b47b0 ("serial: uartps: Fill struct uart_driver in probe()")
    14090ad1805f ("serial: uartps: Move alias reading higher in probe()")
    18cc7ac8a28e ("Revert "serial: uartps: Register own uart console and driver structures"")
    1f2107223e5b ("serial: uartps: Move cnds_uart_get_port to probe")
    427c8ae9bebc ("serial: uartps: Change logic how console_port is setup")
    46a460f0150a ("serial: uartps: Do not use static struct uart_driver out of probe()")
    8da1a3940da4 ("Revert "serial: uartps: Use the same dynamic major number for all ports"")
    ab262666018d ("serial: uartps: Use the same dynamic major number for all ports")
    e4bbb5194ea3 ("serial: uartps: Move register to probe based on run time detection")

v4.9.221: Failed to apply! Possible dependencies:
    024ca329bfb9 ("serial: uartps: Register own uart console and driver structures")
    0413fe045dda ("serial: uartps: Use dynamic array for console port")
    0a84bae7edfb ("serial: uartps: Remove static port array")
    10a5315b47b0 ("serial: uartps: Fill struct uart_driver in probe()")
    14090ad1805f ("serial: uartps: Move alias reading higher in probe()")
    18cc7ac8a28e ("Revert "serial: uartps: Register own uart console and driver structures"")
    1f2107223e5b ("serial: uartps: Move cnds_uart_get_port to probe")
    46a460f0150a ("serial: uartps: Do not use static struct uart_driver out of probe()")
    4b9d33c6a306 ("serial: uartps: Fix suspend functionality")
    81e33b51ed69 ("serial: xuartps: Cleanup the clock enable")
    8da1a3940da4 ("Revert "serial: uartps: Use the same dynamic major number for all ports"")
    ab262666018d ("serial: uartps: Use the same dynamic major number for all ports")
    d62100f1aac2 ("serial: xilinx_uartps: Add pm runtime support")
    d653c43aefed ("serial: xilinx_uartps: Fix the error path")
    e4bbb5194ea3 ("serial: uartps: Move register to probe based on run time detection")
    ecfc5771ef06 ("serial: xuartps: Enable clocks in the pm disable case also")

v4.4.221: Failed to apply! Possible dependencies:
    024ca329bfb9 ("serial: uartps: Register own uart console and driver structures")
    10a5315b47b0 ("serial: uartps: Fill struct uart_driver in probe()")
    14090ad1805f ("serial: uartps: Move alias reading higher in probe()")
    18cc7ac8a28e ("Revert "serial: uartps: Register own uart console and driver structures"")
    354fb1a7d7e5 ("tty: xuartps: Cleanup: Reformat if-else")
    373e882f9ecf ("tty: xuartps: Refactor IRQ handling")
    3816b2f886d0 ("serial: xuartps: Adds RXBS register support for zynqmp")
    46a460f0150a ("serial: uartps: Do not use static struct uart_driver out of probe()")
    4b9d33c6a306 ("serial: uartps: Fix suspend functionality")
    55861d11c5c8 ("tty: xuartps: Move request_irq to after setting up the HW")
    5ede4a5cde27 ("tty: xuartps: Move RX path into helper function")
    6e14f7c1f2c2 ("tty: xuartps: Improve startup function")
    81e33b51ed69 ("serial: xuartps: Cleanup the clock enable")
    8da1a3940da4 ("Revert "serial: uartps: Use the same dynamic major number for all ports"")
    a19eda0f49e5 ("tty: xuartps: Acquire port lock for shutdown")
    a8df6a51600a ("tty: xuartps: Remove '_OFFSET' suffix from #defines")
    ab262666018d ("serial: uartps: Use the same dynamic major number for all ports")
    aea8f3ddcf5d ("tty: xuartps: Clear interrupt status register in shutdown")
    e3538c37ee38 ("tty: xuartps: Beautify read-modify writes")
    e4bbb5194ea3 ("serial: uartps: Move register to probe based on run time detection")
    ea8dd8e58576 ("tty: xuartps: Don't consider circular buffer when enabling transmitter")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
