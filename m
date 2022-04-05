Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A3934F47E2
	for <lists+stable@lfdr.de>; Wed,  6 Apr 2022 01:44:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346744AbiDEVWi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 17:22:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48138 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1573704AbiDETqW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 15:46:22 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.17.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96E414087;
        Tue,  5 Apr 2022 12:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1649187852;
        bh=BXQ8G9Dr8k3xNyKxt7GcxOAd7iGTbrc+JOzLOV5RqvU=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject:In-Reply-To:References;
        b=c/J3VEbnYefBqbKhuaYmSYCRtp8LljUH7n9dOo4nnNZyr/chN6HnyRR2f7h7wSXjd
         CCp6+n1Djb2DYTiMbm/j3bRU3URtxO9YD6n/ciZOTT68EN/kgQNE6G+qO8BuwVF+Aa
         Z/BG5CoNCMGhSTKZv6KKnZlFy+Hu9peAKDBI8yaw=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from mir ([94.31.89.21]) by mail.gmx.net (mrgmx104 [212.227.17.168])
 with ESMTPSA (Nemesis) id 1MFsYx-1nmYTr0qh5-00HMCU; Tue, 05 Apr 2022 21:44:12
 +0200
Date:   Tue, 5 Apr 2022 21:44:09 +0200
From:   Stefan Lippers-Hollmann <s.l-h@gmx.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Bard Liao <yung-chuan.liao@linux.intel.com>,
        =?UTF-8?B?UMOpdGVy?= Ujfalusi <peter.ujfalusi@linux.intel.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 5.17 0943/1126] ASoC: Intel: sof_es8336: use NHLT
 information to set dmic and SSP
Message-ID: <20220405214409.52f3ede7@mir>
In-Reply-To: <20220405070435.188697055@linuxfoundation.org>
References: <20220405070407.513532867@linuxfoundation.org>
        <20220405070435.188697055@linuxfoundation.org>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:txWOjwm3T5sVY1g/TCsV7PEFAamF3HDYlLhAeFzUJWIJ8Pwmk8M
 Yt3AvXEPy9GHynICk1Yh/J6Msry5YqwlQrOi2fcr1AwEav8kKYSogYOJaTYDorYt/+6loHb
 1xCxhatseXMziahVddnYk6k3/iubRVPwGEhZerCXuvtYXznBZs3YA5fWnR+pOEo9Z9Jz+jm
 fTMANNVCFSnFWl4d6Me/Q==
X-UI-Out-Filterresults: notjunk:1;V03:K0:FkulZaLFO2w=:lgROdH3sTkvRRwtkQck4b0
 ZxEZsJDNtb9vh3Eubsth9tr5TxFyv/YTVXYheb5gUZIkzoasomNcj2jvkbZRy9lZZJQxbThkt
 Rkmnba/483239EKOSqKSPk8hQfoqdbuuRC+NtOjpMbQV03ZOhVe6WANX+WrwDW9XhbSsRAOgY
 aeAv98p5g8Q/llH3ywfhuuJ0c65qiPGtUu3pRDeh6TDV/V7LLCmH89v6qvrf5OaXog0jSHU6X
 gu8XliQMMBtc9k5hQ8WPDQhsVw8XFqG5D8pIhjvPJWJ76fZzPh76iAnVxG5Jmg+ggao+8KumA
 /lqQF593U6wRfDwvks+sBu1f8Z/BAU/DQApgizJYgvdUdN5Hlpss3lv3BWaoJZhGuJaK9mfLd
 P1jCrENw50lVraP30dR1rjSQeKr2sZ0RURocuRZhx7jWWv0gykHT2zFHDZD3S8SZGJ/wL5UDK
 WwOimnlSdWvDVSOLTLSOBVfBYkQuXWBa/kdH8aXv+haxtpX4VH2ZEmHW289r/ZpAWuX9+uivn
 XqCzgUIvvId6F+iCQyIEGBUQYWnKgqYiP2BFhoZYJe9+KhIoKzvuKalRRGjok5M+ftMce8xC+
 Yc6WQTpPaw6tr9is9UnhvBKVGkutL+HZT3aDgEUI73baLtQFj1icEbTFIrEUSRlgnyjSO1bcO
 pym0uXuR0HHYV9WHMHllMCSeBHQWljl9qfDI0a5fvhf8uO9fHej52wTL0WR9a68pnGkjuWSMN
 rg5Vew7SLUhjI+XTyVZ2fDf9Ds/9qmDdCTKdDJvSXYTp2homdssG7lXvi5fMnasJY/TyB2Z+F
 MyrZ0X1ClimOk/g9jq37r4lX4loLhMIxeXmajO6XLesEAE/ds3FPLndc3aYQxHsQE+ox2HOUj
 klqYvT43Hkm5iITxZrRdqqQHE6U0lTWrvH0Lb5FRaebn0pH463CJrFcMPlZxX2zuxF7hI6nvo
 kZyXRP3Ch9etZZ4WwxI7A1rOnhDWcWJ3zxCwsLhyyRGykwVUdgJ4suQu8ILhqxYHKeMKImfUy
 iqQIBMXOU6QLKrnjwBNmk3SXosNXy6RQdw8NHNWKHXmR9a20Wlm+MKCqchTz9fKbA5Oij+Jae
 xVcIxNv7OQiY/A=
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,FREEMAIL_FROM,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H4,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

On 2022-04-05, Greg Kroah-Hartman wrote:
> From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
>
> [ Upstream commit 651c304df7f6e3fbb4779527efa3eb128ef91329 ]
>
> Since we see a proliferation of devices with various configurations,
> we want to automatically set the DMIC and SSP information. This patch
> relies on the information extracted from NHLT and partially reverts
> existing DMI quirks added by commit a164137ce91a ("ASoC: Intel: add
> machine driver for SOF+ES8336")
>
> Note that NHLT can report multiple SSPs, choosing from the
> ssp_link_mask in an MSB-first manner was found experimentally to work
> fine.
>
> The only thing that cannot be detected is the GPIO type, and users may
> want to use the quirk override parameter if the 'wrong' solution is
> provided.
[...]

This patch, as part of v5.17.2-rc1 seems to introduce a build failure
on x86_64 (with CONFIG_SND_SOC_INTEL_SOF_ES8336_MACH=3Dm):

  LD [M]  sound/soc/intel/boards/snd-soc-sof_rt5682.o
  LD [M]  sound/soc/intel/boards/snd-soc-sof_cs42l42.o
  CC [M]  sound/soc/intel/boards/sof_es8336.o
/build/linux-5.17/sound/soc/intel/boards/sof_es8336.c: In function 'sof_es=
8336_probe':
/build/linux-5.17/sound/soc/intel/boards/sof_es8336.c:482:32: error: 'stru=
ct snd_soc_acpi_mach_params' has no member named 'i2s_link_mask'; did you =
mean 'link_mask'?
  482 |         if (!mach->mach_params.i2s_link_mask) {
      |                                ^~~~~~~~~~~~~
      |                                link_mask
/build/linux-5.17/sound/soc/intel/boards/sof_es8336.c:494:39: error: 'stru=
ct snd_soc_acpi_mach_params' has no member named 'i2s_link_mask'; did you =
mean 'link_mask'?
  494 |                 if (mach->mach_params.i2s_link_mask & BIT(2))
      |                                       ^~~~~~~~~~~~~
      |                                       link_mask
/build/linux-5.17/sound/soc/intel/boards/sof_es8336.c:496:44: error: 'stru=
ct snd_soc_acpi_mach_params' has no member named 'i2s_link_mask'; did you =
mean 'link_mask'?
  496 |                 else if (mach->mach_params.i2s_link_mask & BIT(1))
      |                                            ^~~~~~~~~~~~~
      |                                            link_mask
/build/linux-5.17/sound/soc/intel/boards/sof_es8336.c:498:45: error: 'stru=
ct snd_soc_acpi_mach_params' has no member named 'i2s_link_mask'; did you =
mean 'link_mask'?
  498 |                 else  if (mach->mach_params.i2s_link_mask & BIT(0)=
)
      |                                             ^~~~~~~~~~~~~
      |                                             link_mask
make[4]: *** [/build/linux-5.17/scripts/Makefile.build:288: sound/soc/inte=
l/boards/sof_es8336.o] Error 1

Reverting just this patch lets the build, using the same buildconfig,
succeed again.

Regards
	Stefan Lippers-Hollmann
