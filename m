Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D859211397
	for <lists+stable@lfdr.de>; Wed,  1 Jul 2020 21:33:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727091AbgGATdp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jul 2020 15:33:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726908AbgGATdW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 1 Jul 2020 15:33:22 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C948B20870;
        Wed,  1 Jul 2020 19:33:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593632001;
        bh=Td9RQrVjQAYm4R6hKpsdZTaixRsTHAsdDvTyA61WDfk=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=rFi29rltPMQSh/8rT5NQpQtufKvwb6pjH/RdVJxK1LS0RUX4SyGxNb2JzqyX0wYuB
         QNhV+bYWIfnPkmIolUE0pu5XXLKQVE7RLQCey8Tf0Blzc+Sod1WzLPw0CcNjjtvtPJ
         oEl+czAvwKHUn0EEdzdqs1oRm8fJeFlg1MCg89sc=
Date:   Wed, 01 Jul 2020 19:33:20 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Hans de Goede <hdegoede@redhat.com>
To:     Cezary Rojewski <cezary.rojewski@intel.com>
Cc:     Hans de Goede <hdegoede@redhat.com>, alsa-devel@alsa-project.org
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 1/6] ASoC: Intel: cht_bsw_rt5672: Change bus format to I2S 2 channel
In-Reply-To: <20200628155231.71089-2-hdegoede@redhat.com>
References: <20200628155231.71089-2-hdegoede@redhat.com>
Message-Id: <20200701193320.C948B20870@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.7.6, v5.4.49, v4.19.130, v4.14.186, v4.9.228, v4.4.228.

v5.7.6: Build OK!
v5.4.49: Failed to apply! Possible dependencies:
    0d1571c197a92 ("ASoC: intel: use asoc_rtd_to_cpu() / asoc_rtd_to_codec() macro for DAI pointer")
    157b006f6be46 ("ASoC: bdw-rt5677: Add a DAI link for rt5677 SPI PCM device")
    17fe95d6df932 ("ASoC: Intel: boards: Add CML m/c using RT1011 and RT5682")
    332719b1840b9 ("ASoC: Intel: bytcr_rt5640: Remove code duplication in byt_rt5640_codec_fixup")
    35dc19ad86fdf ("ASoC: Intel: Add machine driver for da7219_max98373")
    461c623270e4f ("ASoC: rt5677: Load firmware via SPI using delayed work")
    4f0637eae56f0 ("ASoC: Intel: common: add ACPI matching tables for JSL")
    57ad18906f242 ("ASoC: Intel: bxt-da7219-max98357a: common hdmi codec support")
    59bbd703ea2ea ("ASoC: intel: sof_rt5682: common hdmi codec support")
    5b425814f13f3 ("ASoC: intel: Add Broadwell rt5650 machine driver")
    7d2ae58376658 ("ASoC: Intel: bxt_rt298: common hdmi codec support")
    8039105987fcd ("ASoC: Intel: boards: sof_rt5682: use dependency on SOF_HDA_LINK")
    a0e0d135427cf ("ASoC: rt5677: Add a PCM device for streaming hotword via SPI")
    ba0b3a977ecf5 ("ASoC: rt5677: Set ADC clock to use PLL and enable ASRC")
    dfe87aa86cd92 ("ASoC: Intel: glk_rt5682_max98357a: common hdmi codec support")
    f40ed2e8db8d5 ("ASoC: Intel: sof_pcm512x: add support for SOF platforms with pcm512x")

v4.19.130: Failed to apply! Possible dependencies:
    0b7990e38971d ("ASoC: add for_each_rtd_codec_dai() macro")
    0d1571c197a92 ("ASoC: intel: use asoc_rtd_to_cpu() / asoc_rtd_to_codec() macro for DAI pointer")
    10b02b53a9986 ("ASoC: Intel: select relevant machine drivers for SOF")
    35bc99aaa1a3a ("ASoC: Intel: Skylake: Add more platform granularity")
    5b425814f13f3 ("ASoC: intel: Add Broadwell rt5650 machine driver")
    6bae5ea949892 ("ASoC: hdac_hda: add asoc extension for legacy HDA codec drivers")
    7c33b5f16915a ("ASoC: Intel: Boards: Machine driver for SKL+ w/ HDAudio codecs")
    8c4e7c2ee8096 ("ASoC: Intel: Skylake: fix Kconfigs, make HDaudio codec optional")
    98061fdbfccc0 ("ASoC: add for_each_card_links() macro")
    bca0ac1d96739 ("ASoC: Intel: Boards: Add KBL Dialog Maxim I2S machine driver")
    bcb1fd1fcd650 ("ASoC: add for_each_card_rtds() macro")
    e894efef9ac7c ("ASoC: core: add support to card rebind")

v4.14.186: Failed to apply! Possible dependencies:
    0b7990e38971d ("ASoC: add for_each_rtd_codec_dai() macro")
    0d1571c197a92 ("ASoC: intel: use asoc_rtd_to_cpu() / asoc_rtd_to_codec() macro for DAI pointer")
    1a11d88f499ce ("ASoC: meson: add tdm formatter base driver")
    273d778ef38a8 ("ASoC: snd_soc_component_driver has endianness")
    291bfb928863d ("ASoC: topology: Revert recent changes while boot errors are investigated")
    45f8cb57da0d7 ("ASoC: core: Allow topology to override machine driver FE DAI link config.")
    53eb4b7aaa045 ("ASoC: meson: add axg spdif output")
    57d552e3ea760 ("ASoC: meson: add axg frddr driver")
    5d61f0ba6524d ("ASoC: pcm: Sync delayed work before releasing resources")
    69941bab7c7ae ("ASoC: snd_soc_component_driver has non_legacy_dai_naming")
    6dc4fa179fb86 ("ASoC: meson: add axg fifo base driver")
    7864a79f37b55 ("ASoC: meson: add axg sound card support")
    7a679ea75a1bc ("ASoC: Intel: Enable tdm slots for max98927")
    7ba236ce58bd7 ("ASoC: add Component level set_bias_level")
    7ed4877b403c9 ("ASoC: meson: add axg toddr driver")
    98061fdbfccc0 ("ASoC: add for_each_card_links() macro")
    9900a4226c785 ("ASoC: remove unneeded dai->driver->ops check")
    a655de808cbde ("ASoC: core: Allow topology to override machine driver FE DAI link config.")
    bcb1fd1fcd650 ("ASoC: add for_each_card_rtds() macro")
    bf14adcc4ddd1 ("ASoC: Intel: cht-bsw-rt5672: allow for topology-defined codec-dai setup")
    c41c2a355b863 ("ASoC: meson: add tdm output driver")
    d60e4f1e4be5e ("ASoC: meson: add tdm interface driver")
    e0dac41b8c21d ("ASoC: soc-core: add snd_soc_add_component()")
    f11a5c27f9287 ("ASoC: core: Add name prefix for machines with topology rewrites")
    f523acebbb74f ("ASoC: add Component level pcm_new/pcm_free v2")
    fbb16563c6c2b ("ASoC: snd_soc_component_driver has pmdown_time")

v4.9.228: Failed to apply! Possible dependencies:
    0b7990e38971d ("ASoC: add for_each_rtd_codec_dai() macro")
    0d1571c197a92 ("ASoC: intel: use asoc_rtd_to_cpu() / asoc_rtd_to_codec() macro for DAI pointer")
    17fb175520e54 ("ASoC: Define API to find a dai link")
    1a11d88f499ce ("ASoC: meson: add tdm formatter base driver")
    1a653aa447256 ("ASoC: core: replace aux_comp_list to component_dev_list")
    273d778ef38a8 ("ASoC: snd_soc_component_driver has endianness")
    2a18483a7fb41 ("ASoC: Intel: Add Kabylake machine driver for RT5514, RT5663 and MAX98927")
    44c07365e9e2c ("ASoC: add Component level set_jack")
    53eb4b7aaa045 ("ASoC: meson: add axg spdif output")
    57d552e3ea760 ("ASoC: meson: add axg frddr driver")
    69941bab7c7ae ("ASoC: snd_soc_component_driver has non_legacy_dai_naming")
    6dc4fa179fb86 ("ASoC: meson: add axg fifo base driver")
    71ccef0df533c ("ASoC: add Component level set_sysclk")
    759db1c4660b5 ("ASoC: Intel: boards: add card for MinnowBoardMax/Up I2S access")
    7864a79f37b55 ("ASoC: meson: add axg sound card support")
    7a679ea75a1bc ("ASoC: Intel: Enable tdm slots for max98927")
    7ba236ce58bd7 ("ASoC: add Component level set_bias_level")
    7ed4877b403c9 ("ASoC: meson: add axg toddr driver")
    804e73adf5cf4 ("ASoC: rt5670: Fix GPIO headset detection regression")
    82cf89de2c9c2 ("ASoC: Intel: add machine driver for BYT/CHT + DA7213")
    9178feb4538e0 ("ASoC: add Component level suspend/resume")
    98061fdbfccc0 ("ASoC: add for_each_card_links() macro")
    a655de808cbde ("ASoC: core: Allow topology to override machine driver FE DAI link config.")
    bcb1fd1fcd650 ("ASoC: add for_each_card_rtds() macro")
    bf14adcc4ddd1 ("ASoC: Intel: cht-bsw-rt5672: allow for topology-defined codec-dai setup")
    c41c2a355b863 ("ASoC: meson: add tdm output driver")
    d60e4f1e4be5e ("ASoC: meson: add tdm interface driver")
    d9fc40639dc1b ("ASoC: core: replace codec_dev_list to component_dev_list on Card")
    ec040dd5ef647 ("ASoC: Intel: Add Kabylake Realtek Maxim machine driver")
    ef641e5d5e6c7 ("ASoC: add Component level set_pll")
    fbb16563c6c2b ("ASoC: snd_soc_component_driver has pmdown_time")

v4.4.228: Failed to apply! Possible dependencies:
    0d1571c197a92 ("ASoC: intel: use asoc_rtd_to_cpu() / asoc_rtd_to_codec() macro for DAI pointer")
    17fb175520e54 ("ASoC: Define API to find a dai link")
    1a497983a5ae6 ("ASoC: Change the PCM runtime array to a list")
    49a5ba1cd9da4 ("ASoC: soc_bind_dai_link() directly returns success for a bound DAI link")
    6f2f1ff0de83a ("ASoC: Change 2nd argument of soc_bind_dai_link() to DAI link pointer")
    804e73adf5cf4 ("ASoC: rt5670: Fix GPIO headset detection regression")
    923c5e61ecd9b ("ASoC: Define soc_init_dai_link() to wrap link intialization.")
    98061fdbfccc0 ("ASoC: add for_each_card_links() macro")
    bcb1fd1fcd650 ("ASoC: add for_each_card_rtds() macro")
    bf14adcc4ddd1 ("ASoC: Intel: cht-bsw-rt5672: allow for topology-defined codec-dai setup")
    f8f80361d07d5 ("ASoC: Implement DAI links in a list & define API to add/remove a link")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
