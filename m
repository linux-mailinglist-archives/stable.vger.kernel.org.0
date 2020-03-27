Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 20D8219562A
	for <lists+stable@lfdr.de>; Fri, 27 Mar 2020 12:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726661AbgC0LV0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Mar 2020 07:21:26 -0400
Received: from metis.ext.pengutronix.de ([85.220.165.71]:57117 "EHLO
        metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726454AbgC0LVZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Mar 2020 07:21:25 -0400
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1jHn3E-0005sM-9k; Fri, 27 Mar 2020 12:21:24 +0100
Subject: Re: [PATCH] ARM: imx: provide v7_cpu_resume() only on
 ARM_CPU_SUSPEND=y
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
To:     Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Rouven Czerwinski <r.czerwinski@pengutronix.de>
Cc:     linux-arm-kernel@lists.infradead.org,
        Clemens Gruber <clemens.gruber@pqgruber.com>,
        Russell King <linux@armlinux.org.uk>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200323081933.31497-1-a.fatoum@pengutronix.de>
 <6ae60120-2b3e-2ce2-14cc-8c44889d49ee@pengutronix.de>
Message-ID: <453f9aca-504a-6478-7e8d-5db646948c49@pengutronix.de>
Date:   Fri, 27 Mar 2020 12:21:22 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <6ae60120-2b3e-2ce2-14cc-8c44889d49ee@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: stable@vger.kernel.org
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Shawn,

On 3/23/20 9:25 AM, Ahmad Fatoum wrote:
> On 3/23/20 9:19 AM, Ahmad Fatoum wrote:
>> Fixes: 512a928affd5 ("ARM: imx: build v7_cpu_resume() unconditionally")
> 
> This commit is new in v5.6-rc5, so it would be great if the fix can land in
> Linus' tree before v5.6.

Gentle ping. I've received a few pings myself because it broke people's
stable release builds and I would like to avoid that for v5.6 as well..

Cheers
Ahmad

> 
> Cheers
> Ahmad
> 

-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
