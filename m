Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6895E1390A7
	for <lists+stable@lfdr.de>; Mon, 13 Jan 2020 13:03:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726277AbgAMMDw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jan 2020 07:03:52 -0500
Received: from fllv0016.ext.ti.com ([198.47.19.142]:34450 "EHLO
        fllv0016.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726236AbgAMMDw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jan 2020 07:03:52 -0500
Received: from lelv0266.itg.ti.com ([10.180.67.225])
        by fllv0016.ext.ti.com (8.15.2/8.15.2) with ESMTP id 00DC2xCT066475;
        Mon, 13 Jan 2020 06:02:59 -0600
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ti.com;
        s=ti-com-17Q1; t=1578916979;
        bh=rCDlfrd8km2xUmG6bzFw3i5aptxyHAA7AlJkzYZgtyQ=;
        h=Subject:From:To:CC:References:Date:In-Reply-To;
        b=cVuC+W4kzuwU4qxTixwv/TGhE6fRZz/ARLeW8MJZAtDXQPZb4HXWQPyB4Nyd+6V6q
         7SELq/VFOVplT8d3W53dtCWrJ8wfaMZBkz19lA4npqPLJ7idhj+U4nFvkH0g5V06Ii
         SC5cgrYR4BPSeeu4khDvOCA79SAKKuoccTORr71Y=
Received: from DFLE115.ent.ti.com (dfle115.ent.ti.com [10.64.6.36])
        by lelv0266.itg.ti.com (8.15.2/8.15.2) with ESMTPS id 00DC2xu1105405
        (version=TLSv1.2 cipher=AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 13 Jan 2020 06:02:59 -0600
Received: from DFLE115.ent.ti.com (10.64.6.36) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3; Mon, 13
 Jan 2020 06:02:59 -0600
Received: from fllv0040.itg.ti.com (10.64.41.20) by DFLE115.ent.ti.com
 (10.64.6.36) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.1847.3 via
 Frontend Transport; Mon, 13 Jan 2020 06:02:59 -0600
Received: from [172.24.145.246] (ileax41-snat.itg.ti.com [10.172.224.153])
        by fllv0040.itg.ti.com (8.15.2/8.15.2) with ESMTP id 00DC2tJF015538;
        Mon, 13 Jan 2020 06:02:57 -0600
Subject: Re: [PATCH] ARM: davinci: select CONFIG_RESET_CONTROLLER
From:   Sekhar Nori <nsekhar@ti.com>
To:     Arnd Bergmann <arnd@arndb.de>
CC:     <stable@vger.kernel.org>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        David Lechner <david@lechnology.com>,
        <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
References: <20191210195202.622734-1-arnd@arndb.de>
 <ba94531d-1f16-b985-5638-c226bab28d5b@ti.com>
Message-ID: <1513bfee-6623-47fa-1eef-6074ba9ab3b8@ti.com>
Date:   Mon, 13 Jan 2020 17:32:54 +0530
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <ba94531d-1f16-b985-5638-c226bab28d5b@ti.com>
Content-Type: text/plain; charset="utf-8"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-EXCLAIMER-MD-CONFIG: e1e8a2fd-e40a-4ac6-ac9b-f7e9cc9ee180
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Arnd,

On 11/12/19 3:42 PM, Sekhar Nori wrote:
> Hi Arnd,
> 
> On 11/12/19 1:21 AM, Arnd Bergmann wrote:
>> Selecting RESET_CONTROLLER is actually required, otherwise we
>> can get a link failure in the clock driver:
>>
>> drivers/clk/davinci/psc.o: In function `__davinci_psc_register_clocks':
>> psc.c:(.text+0x9a0): undefined reference to `devm_reset_controller_register'
>> drivers/clk/davinci/psc-da850.o: In function `da850_psc0_init':
>> psc-da850.c:(.text+0x24): undefined reference to `reset_controller_add_lookup'
>>
>> Fixes: f962396ce292 ("ARM: davinci: support multiplatform build for ARM v5")
>> Cc: <stable@vger.kernel.org> # v5.4
>> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> 
> Assuming you are going to apply directly to ARM-SoC,
> 
> Acked-by: Sekhar Nori <nsekhar@ti.com>

This is not yet in Linus's master. Let me know if I should collect it
and send a pull request.

Thanks,
Sekhar
