Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3748C3C68EE
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 05:41:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229726AbhGMDoW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 23:44:22 -0400
Received: from mout.gmx.net ([212.227.17.22]:33177 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229571AbhGMDoV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 23:44:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1626147680;
        bh=cNViJekC3rjNU+L5V5+BCWxbatHT/ikYeX1hZnBrHOE=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=M1ZOoWPK4+SSML7l44gk4frAaGC/yQR1vXyaFWbajMjQEvtcR8l8tYVN8nUOZ0Wsm
         TL9s35PGzDeStFxMQb7T/1IqCH/jR2gvlv242wJU7GzWexwM3K/YyN6xw9HahMfs4U
         17gODNLD3OfTFx2wErkRLcaXs4jIMrT2BawDa1OI=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mir ([94.31.86.21]) by mail.gmx.net (mrgmx105 [212.227.17.168])
 with ESMTPSA (Nemesis) id 1Mdvqg-1lTXd81DYU-00b0JV; Tue, 13 Jul 2021 05:41:20
 +0200
Date:   Tue, 13 Jul 2021 05:41:18 +0200
From:   Stefan Lippers-Hollmann <s.l-h@gmx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>,
        Yong Zhi <yong.zhi@intel.com>, Bard Liao <bard.liao@intel.com>,
        Ranjani Sridharan <ranjani.sridharan@linux.intel.com>,
        Kai Vehmanen <kai.vehmanen@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.13 743/800] ASoC: Intel: sof_sdw: add quirk support
 for Brya and BT-offload
Message-ID: <20210713054118.4e5abba3@mir>
In-Reply-To: <20210712061045.833441566@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
        <20210712061045.833441566@linuxfoundation.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:pUDhmas1vn9MPMciTXYFOLPNxp+5IlGTZuIAVYZpj1FVya2RAvK
 xdniPCilA0QYNHxTnecVwZ+ZO1z3BAm91lFGQrOiqhf/5hE2LCgAithchFUXRdsLMtdA9um
 +Ry6Qjbb69r57T5lpLM5kvOd7MZkgkXvOk2EmQSVwL8FvTpb/1BXoLw7gI9418lKcI+rijj
 PGxYILi6osNa2e55jJDOQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:MQWwatOiT5o=:qBCtOH7p26VF5Husf5fpTo
 Z902ld5V8LxkKzwOw0yCLGoJkqfnrhoYMIzwX/QEkPOaY2ZEuMfYquLnthZcpKzAIIcV/VNC3
 3zPimUOPGeBYslXIcRBlJN6IPnYCVhthseyOlEIsheOI5oQwbQROgJl36n3DXwBUauDEcz8xF
 s1hVqh+QOQ0Y1FFEk5dyJYz3Xxbb5eyl08F0Qa5/f/VGn6l0dTYmofH+qDmT8djBSeU1TGZOg
 L7gYKT27eD3L5QbwK0XVezoSISWZojIXqQg5PNOL+Uox1BwXJd3Le9+NkGnUky/7PFhMK324Z
 M/H13t+dxco3Q6yRS8S+U9yokvqEZG+9Ho9NBo4+6bpOdUUZ0f/awOA6rUS2yUQ1dRHS4fx1f
 D+SCcI6Q/cXSu320v1jnvjHOuCJbV4ptN0R15wVVKQPjCCW1DXWnJ0QW0QWt+mXD8tHHFtJBm
 P0bBno5EsYj0zBqJ1HnyGjQ5ITu2s0Vdd8RXmf+5Rgw5q+Rabm5CiORqcmY6tBrG1LDmiq2Ai
 i+xNZJX9e2w045ajbd8yOcrPYhbYuxZbHcydekbjjJuK2J210McmqzMSG7+SH9OO3xSLXv2RV
 dSqoQy8RT7pCHYDkyjQDN27+Sb9kzBM5c/RyDQVrZSO6tXYEr6PCWfvLqeiGXbYOBXIJhgGGp
 HVYJR9yQAbWRYlConWuDwvLeCoP9syrKo+DKzmJ4XO67Ll6wIqogXKJ6RSlTir3LDoiYCg6e/
 u4V0+Dzcu4PtALhQXszpR+GHCVBKVQgihwPGXupPpfT1/Qw1LlLHNO/MeWs59ZAgxE78SFuic
 bGTmNRwFygfjTHPIRYbpUAWtVObfYtxWx+iN4RRPiCf7Y4TOcmKO/tTcclj7GkJAmLoR6W2qJ
 QUQt5Ahh0xicUHBABI1by0st73CMLVKdfUwhmEF9dh/dAvMN3IhXwbhJ10zr9hG24b7oxFfWR
 DKl4ZBBBQEcz7RM/wy7LyC6o0eu/9Oul6C8445YzNVJwQy8hilnAavdiOl/8OB9xYKTrVvtFb
 Q7oR6DQdLObOC9wwEGI7YrNR1AlhMAcxPU6xLLNwemqgn8r9HHmpCxKS5Z8l1s0/pfvy4QVQk
 saNvRB1FPyM0J8WesFyC+eiun6dt/8y4mF7
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

On 2021-07-12, Greg Kroah-Hartman wrote:
> From: Vamshi Krishna Gopal <vamshi.krishna.gopal@intel.com>
>
> [ Upstream commit 03effde3a2ea1d82c4dd6b634fc6174545d2c34f ]
>
> Brya is another ADL-P product.
>
> AlderLake has support for Bluetooth audio offload capability.
> Enable the BT-offload quirk for ADL-P Brya and the Intel RVP.
[...]

This patch seems to introduce a build failure into v5.13.2-rc1 on x86_64:

  CC [M]  sound/soc/intel/boards/sof_sdw.o
  CC [M]  sound/soc/intel/boards/sof_sdw_rt5682.o
  CC [M]  sound/soc/intel/boards/sof_sdw_rt700.o
  CC [M]  sound/soc/intel/boards/sof_sdw_rt711.o
  CC [M]  sound/soc/intel/boards/sof_sdw_rt711_sdca.o
  CC [M]  sound/soc/intel/boards/sof_sdw_rt715.o
  CC [M]  sound/soc/intel/boards/sof_sdw_rt715_sdca.o
  CC [M]  sound/soc/intel/boards/sof_sdw_dmic.o
  CC [M]  sound/soc/intel/boards/sof_sdw_hdmi.o
  LD [M]  sound/soc/intel/boards/snd-soc-sof_rt5682.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-haswell.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-bxt-da7219_max98357a.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-bxt-rt298.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-sof-pcm512x.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-sof-wm8804.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-glk-rt5682_max98357a.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-broadwell.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-bdw-rt5650-mach.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-bytcr-rt5640.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-bytcr-rt5651.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-cht-bsw-rt5672.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-cht-bsw-rt5645.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-cht-bsw-max98090_ti.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-cht-bsw-nau8824.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-byt-cht-cx2072x.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-byt-cht-da7213.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-byt-cht-es8316.o
  LD [M]  sound/soc/intel/boards/snd-soc-sst-byt-cht-nocodec.o
  LD [M]  sound/soc/intel/boards/snd-soc-cml_rt1011_rt5682.o
  LD [M]  sound/soc/intel/boards/snd-soc-kbl_da7219_max98357a.o
  LD [M]  sound/soc/intel/boards/snd-soc-kbl_da7219_max98927.o
  CHK     kernel/kheaders_data.tar.xz
  LD [M]  sound/soc/intel/boards/snd-soc-kbl_rt5663_max98927.o
  LD [M]  sound/soc/intel/boards/snd-soc-kbl_rt5660.o
  LD [M]  sound/soc/intel/boards/snd-soc-skl_rt286.o
  LD [M]  sound/soc/intel/boards/snd-skl_nau88l25_max98357a.o
  LD [M]  sound/soc/intel/boards/snd-soc-skl_nau88l25_ssm4567.o
  LD [M]  sound/soc/intel/boards/snd-soc-skl_hda_dsp.o
  LD [M]  sound/soc/intel/boards/snd-soc-sof_da7219_max98373.o
  LD [M]  sound/soc/intel/boards/snd-soc-ehl-rt5660.o
  LD [M]  sound/soc/snd-soc-acpi.o
/build/linux-aptosid-5.13/sound/soc/intel/boards/sof_sdw.c:200:6: error: i=
mplicit declaration of function 'SOF_BT_OFFLOAD_SSP' [-Werror=3Dimplicit-f=
unction-declaration]
  200 |      SOF_BT_OFFLOAD_SSP(2) |
      |      ^~~~~~~~~~~~~~~~~~
  LD [M]  sound/soundcore.o
  LD [M]  sound/soc/sof/xtensa/snd-sof-xtensa-dsp.o
/build/linux-aptosid-5.13/sound/soc/intel/boards/sof_sdw.c:201:6: error: '=
SOF_SSP_BT_OFFLOAD_PRESENT' undeclared here (not in a function)
  201 |      SOF_SSP_BT_OFFLOAD_PRESENT),
      |      ^~~~~~~~~~~~~~~~~~~~~~~~~~
  LD [M]  sound/soc/sof/intel/snd-sof-acpi-intel-bdw.o
  LD [M]  sound/soc/sof/intel/snd-sof-intel-hda.o
  LD [M]  sound/soc/sof/intel/snd-sof-pci-intel-tng.o
  LD [M]  sound/soc/sof/intel/snd-sof-pci-intel-apl.o
  LD [M]  sound/soc/sof/intel/snd-sof-pci-intel-cnl.o
  LD [M]  sound/soc/sof/intel/snd-sof-pci-intel-icl.o
  LD [M]  sound/soc/sof/intel/snd-sof-pci-intel-tgl.o
cc1: some warnings being treated as errors
make[5]: *** [/build/linux-aptosid-5.13/scripts/Makefile.build:273: sound/=
soc/intel/boards/sof_sdw.o] Error 1

> diff --git a/sound/soc/intel/boards/sof_sdw.c b/sound/soc/intel/boards/s=
of_sdw.c
> index dfad2ad129ab..35ad448902c7 100644
> --- a/sound/soc/intel/boards/sof_sdw.c
> +++ b/sound/soc/intel/boards/sof_sdw.c
> @@ -197,7 +197,21 @@ static const struct dmi_system_id sof_sdw_quirk_tab=
le[] =3D {
>  		.driver_data =3D (void *)(SOF_RT711_JD_SRC_JD1 |
>  					SOF_SDW_TGL_HDMI |
>  					SOF_RT715_DAI_ID_FIX |
> -					SOF_SDW_PCH_DMIC),
> +					SOF_SDW_PCH_DMIC |
> +					SOF_BT_OFFLOAD_SSP(2) |
> +					SOF_SSP_BT_OFFLOAD_PRESENT),
> +	},
> +	{
> +		.callback =3D sof_sdw_quirk_cb,
> +		.matches =3D {
> +			DMI_MATCH(DMI_SYS_VENDOR, "Google"),
> +			DMI_MATCH(DMI_PRODUCT_NAME, "Brya"),
> +		},
> +		.driver_data =3D (void *)(SOF_SDW_TGL_HDMI |
> +					SOF_SDW_PCH_DMIC |
> +					SOF_SDW_FOUR_SPK |
> +					SOF_BT_OFFLOAD_SSP(2) |
> +					SOF_SSP_BT_OFFLOAD_PRESENT),
>  	},
>  	{}
>  };

Regards
	Stefan Lippers-Hollmann
