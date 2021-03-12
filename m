Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36FB0339980
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 23:13:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235497AbhCLWMx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 17:12:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:51052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235495AbhCLWMr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 12 Mar 2021 17:12:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6E07864F2D;
        Fri, 12 Mar 2021 22:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615587167;
        bh=EPVNavQ8mQcIPlKa3lsb4lp6iLJm+8sfFbqye9bNnm8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dOTu/yIxAjm9cR8ju5H0e3Pvj8zvz5eW02kqzGxa8wTOVYJf6mbaVZEJb824E8cV5
         T/25AUmCdfP8aDminddmVytmHNyVHEXaeZCnbMq50wTZb3AZlX5Z78Fl58P4HPUS+P
         89rrZqkxUGgYb9p5WaB74JLlXuf7Aj3YACZPc7e7Mn1Pms7HW85kVeZMoWgk8ldA7t
         OZ7DvxyWZ7CuHlySr3BzXsmgKKlDPuYBlOlieOncvX01mYBREskSlMcl2/pZFNCOHt
         4TqlV968QGpOddcpqqZTH1hNM6z3ABJin32tIV8jx7E4pcahLfCsbHykjEFhsSTMMc
         RIPjvi7masRPg==
Date:   Fri, 12 Mar 2021 17:12:46 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jeremy Linton <jeremy.linton@arm.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-mmc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        bcm-kernel-feedback-list@broadcom.com
Subject: Re: [PATCH AUTOSEL 5.10 11/47] mmc: sdhci-iproc: Add ACPI bindings
 for the RPi
Message-ID: <YEvnXgCUmDzRbJ1w@sashalap>
References: <20210302115646.62291-1-sashal@kernel.org>
 <20210302115646.62291-11-sashal@kernel.org>
 <445ed4c0-3b2c-1371-931d-b0de7bdb497a@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <445ed4c0-3b2c-1371-931d-b0de7bdb497a@arm.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 02, 2021 at 10:16:59AM -0600, Jeremy Linton wrote:
>Hi,
>
>
>On 3/2/21 5:56 AM, Sasha Levin wrote:
>>From: Jeremy Linton <jeremy.linton@arm.com>
>>
>>[ Upstream commit 4f9833d3ec8da34861cd0680b00c73e653877eb9 ]
>>
>>The RPi4 has an Arasan controller it carries over from the RPi3 and a newer
>>eMMC2 controller.  Because of a couple of quirks, it seems wiser to bind
>>these controllers to the same driver that DT is using on this platform
>>rather than the generic sdhci_acpi driver with PNP0D40.
>>
>>So, BCM2847 describes the older Arasan and BRCME88C describes the newer
>>eMMC2. The older Arasan is reusing an existing ACPI _HID used by other OSes
>>booting these tables on the RPi.
>>
>>With this change, Linux is capable of utilizing the SD card slot, and the
>>Wi-Fi when booted with UEFI+ACPI on the RPi4.
>
>For this to actually work on kernels < 5.11 you also need:
>
>c5b1c6dc13da mmc: sdhci: Update firmware interface API

I'll take this one for 5.10 then, thanks!

-- 
Thanks,
Sasha
