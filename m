Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55A6C3B5CA2
	for <lists+stable@lfdr.de>; Mon, 28 Jun 2021 12:44:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbhF1KrG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Jun 2021 06:47:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232762AbhF1KrF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Jun 2021 06:47:05 -0400
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB116C061767
        for <stable@vger.kernel.org>; Mon, 28 Jun 2021 03:44:39 -0700 (PDT)
Received: from [IPv6:::1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id A59B982DB6;
        Mon, 28 Jun 2021 12:44:37 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1624877078;
        bh=0p+ciJ3zZIm3RfWSsuWqScKsXBw8wD1FfIDDMY6qp9c=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=eeqNb6K6aKIQXF2CNYgemrJgBrNZ4uQqIFoRpsJUDWL4nXPTCaDnM7PISUELhZ5LX
         QhFKBy8J7SBSnWOumYfHWevQ8WkN0DO0f1zX/VcknMwD1uCQ4WOQuUBrIDlb6owWg7
         6/H/j2I3DQIKewY1pc2/e6yu36JFDC0QcsBbYqlWMsG1lTwCfEFVPkObzxw7TBVjYv
         prlVPrmaSqWFdGc40mivYPCkYyMcfhvVzlmzcV99LM8hV8BPjFaJnvuJ/NynKAA5v2
         Xi9V/BZ5X5lfXMe9DqeatYLmXGrCC9JKudbnENzh+dZ170Q6L/YTTC4PiidAMNzYM7
         vtje0R8rRpaYQ==
Subject: Re: [PATCH] ARM: dts: stm32: Rework LAN8710Ai PHY reset on DHCOM SoM
To:     linux-arm-kernel@lists.infradead.org,
        linux-stable <stable@vger.kernel.org>
Cc:     Alexandre Torgue <alexandre.torgue@st.com>,
        Patrice Chotard <patrice.chotard@st.com>,
        Patrick Delaunay <patrick.delaunay@st.com>,
        linux-stm32@st-md-mailman.stormreply.com,
        Sasha Levin <sashal@kernel.org>
References: <20210408230001.310215-1-marex@denx.de>
From:   Marek Vasut <marex@denx.de>
Message-ID: <47597d13-e6ec-ccd2-c34b-eb65896cdd70@denx.de>
Date:   Mon, 28 Jun 2021 12:44:37 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210408230001.310215-1-marex@denx.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.103.2 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 4/9/21 1:00 AM, Marek Vasut wrote:
> The Microchip LAN8710Ai PHY requires XTAL1/CLKIN external clock to be
> enabled when the nRST is toggled according to datasheet Microchip
> LAN8710A/LAN8710Ai DS00002164B page 35 section 3.8.5.1 Hardware Reset:

[...]

> Fixes: 34e0c7847dcf ("ARM: dts: stm32: Add DH Electronics DHCOM STM32MP1 SoM and PDK2 board")

Adding stable to CC.

Patch is now part of Linux 5.13 as commit

1cebcf9932ab ("ARM: dts: stm32: Rework LAN8710Ai PHY reset on DHCOM SoM")

It would be nice to pick it into stable, since it fixes ethernet 
stability issues on the device.
