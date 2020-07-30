Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AC2F23335B
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 15:48:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728442AbgG3NsP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 09:48:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:33344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728447AbgG3NsO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 09:48:14 -0400
Received: from localhost (unknown [70.37.104.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F330122B3F;
        Thu, 30 Jul 2020 13:48:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596116894;
        bh=kQ6B0Wkj/eUOtIDQNW29mjWW35eZamUc4j/sGcgQTzs=;
        h=Date:From:To:To:To:CC:Cc:Cc:Subject:In-Reply-To:References:From;
        b=as1eRrP2u7BCWtBlfe0vxnbkTe/MKX6o6eS1m1A2FOA+aHyUwfppU5vfsC307Z47G
         tXztmuM3ecHLZjipLYbRzjBytbpFJC2xleAfkuZU35GGjywdEwUp+ixEiD1fL4FwN4
         ZGRtn0XHCwp0NCcAoNaeWa/MlpdS8guzDkc4NHqc=
Date:   Thu, 30 Jul 2020 13:48:13 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Christian Eggers <ceggers@arri.de>
To:     Rob Herring <robh+dt@kernel.org>
CC:     <devicetree@vger.kernel.org>, <linux-iio@vger.kernel.org>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: iio: io-channel-mux: Fix compatible string in example code
In-Reply-To: <20200727101605.24384-1-ceggers@arri.de>
References: <20200727101605.24384-1-ceggers@arri.de>
Message-Id: <20200730134813.F330122B3F@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.11, v5.4.54, v4.19.135, v4.14.190, v4.9.231, v4.4.231.

v5.7.11: Build OK!
v5.4.54: Build OK!
v4.19.135: Build OK!
v4.14.190: Build OK!
v4.9.231: Failed to apply! Possible dependencies:
    7fde1484af21 ("iio: dpot-dac: DAC driver based on a digital potentiometer")
    a36954f58f6c ("dt-bindings: iio: io-channel-mux: document io-channel-mux bindings")
    b475f80b354a ("iio: envelope-detector: ADC driver based on a DAC and a comparator")
    e778aa142ab0 ("dt-bindings: iio: document envelope-detector bindings")
    ed13134ba8c0 ("dt-bindings: iio: document dpot-dac bindings")

v4.4.231: Failed to apply! Possible dependencies:
    16846ebeffe4 ("iio: adc: add IMX7D ADC driver support")
    3b8df5fd526e ("iio: Add IIO support for the Measurement Computing CIO-DAC family")
    6df2e98c3ea5 ("iio: adc: Add imx25-gcq ADC driver")
    7f270bc9a2d9 ("iio: dac: AD8801: add Analog Devices AD8801/AD8803 support")
    7fde1484af21 ("iio: dpot-dac: DAC driver based on a digital potentiometer")
    9bbccbe11ab7 ("iio: dac: add NXP LPC18xx DAC driver")
    a36954f58f6c ("dt-bindings: iio: io-channel-mux: document io-channel-mux bindings")
    b475f80b354a ("iio: envelope-detector: ADC driver based on a DAC and a comparator")
    c43a102e67db ("iio: ina2xx: add support for TI INA2xx Power Monitors")
    e778aa142ab0 ("dt-bindings: iio: document envelope-detector bindings")
    ed13134ba8c0 ("dt-bindings: iio: document dpot-dac bindings")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
