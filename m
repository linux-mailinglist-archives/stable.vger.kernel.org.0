Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C10AA2AAB16
	for <lists+stable@lfdr.de>; Sun,  8 Nov 2020 14:14:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728453AbgKHNOe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Nov 2020 08:14:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:51694 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728425AbgKHNO2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Nov 2020 08:14:28 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5A978206ED;
        Sun,  8 Nov 2020 13:14:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604841267;
        bh=AJ+N1/3ZhM0QD7AR+VJPiydrjOBZSwlBVgPruD6V/2E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RGDHz/r6S0R7fbH6KEwQyDc5p2UcNE/W2EObG1st5Jtb4J2QziUUJRAhOoxjPW5/7
         l73CHp3DGf5gxu3YvWnFBlRKUOM2AuEJVFeIoRRt/kmFGmeGszBMC5n2oQDZLdmuqT
         a8YDEAhvuyM8ER3PRfeZwHgN80x6dggWb6pwzLe0=
Date:   Sun, 8 Nov 2020 08:14:26 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Neil Armstrong <narmstrong@baylibre.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Kevin Hilman <khilman@baylibre.com>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-amlogic@lists.infradead.org
Subject: Re: [PATCH AUTOSEL 5.9 03/35] arm64: dts: meson-axg-s400: enable USB
 OTG
Message-ID: <20201108131426.GP2092@sasha-vm>
References: <20201103011840.182814-1-sashal@kernel.org>
 <20201103011840.182814-3-sashal@kernel.org>
 <c8951cc9-1a3f-2eb2-52fe-654d49591c7a@baylibre.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <c8951cc9-1a3f-2eb2-52fe-654d49591c7a@baylibre.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Nov 03, 2020 at 09:55:51AM +0100, Neil Armstrong wrote:
>On 03/11/2020 02:18, Sasha Levin wrote:
>> From: Neil Armstrong <narmstrong@baylibre.com>
>>
>> [ Upstream commit f450d2c219f6a6b79880c97bf910c3c72725eb70 ]
>>
>> This enables USB OTG on the S400 board.
>>
>> Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
>> Reviewed-by: Kevin Hilman <khilman@baylibre.com>
>> Signed-off-by: Kevin Hilman <khilman@baylibre.com>
>> Signed-off-by: Sasha Levin <sashal@kernel.org>
>> ---
>>  arch/arm64/boot/dts/amlogic/meson-axg-s400.dts | 6 ++++++
>>  1 file changed, 6 insertions(+)
>>
>> diff --git a/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts b/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
>> index cb1360ae1211e..7740f97c240f0 100644
>> --- a/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
>> +++ b/arch/arm64/boot/dts/amlogic/meson-axg-s400.dts
>> @@ -584,3 +584,9 @@ &uart_AO {
>>  	pinctrl-0 = <&uart_ao_a_pins>;
>>  	pinctrl-names = "default";
>>  };
>> +
>> +&usb {
>> +	status = "okay";
>> +	dr_mode = "otg";
>> +	vbus-supply = <&usb_pwr>;
>> +};
>>
>
>Hi Sasha,
>
>This needs also support in the dwc3-meson-g12a driver, you can drop it from backport.

Dropped, thanks!

-- 
Thanks,
Sasha
