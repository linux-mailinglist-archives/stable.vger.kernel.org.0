Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A9E497C3C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 10:42:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231245AbiAXJmt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 04:42:49 -0500
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:47177 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231812AbiAXJmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 04:42:49 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id 87BD758011C;
        Mon, 24 Jan 2022 04:42:48 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 24 Jan 2022 04:42:48 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm2; bh=P8UmLlHN9BGZ+esvPmRpvSz5It+8CW0B+z+h7m
        qv6Lk=; b=ecJJLXJ/Kp+Nil5/vc883vHJk0/KIyb7hhP6iSXTTwzya3ojRgChVc
        DBSgFpaUJvhlR19igIj7rP/8a6b9U7Zfao78fE3uAiC7OPTs9WBOg3OXKEgTq6As
        yHWL6V27q4Pc5wakooL62EM9Ay571LdJnWIN+vB5Sz2OWOGhF0qQlZ016kF6Ypjk
        e44rbAzwp20w7Swk6267ZY64ny1/KyVT1Zfiqzo1mi2GaFRRJzOnFANlrqVPz2oc
        9NWd9GmZ6lOCEgVWj9+7EC2r3UOVkR48J9ZfUiVNMaVXOAAlOveCtbaMbLQsLxjE
        KOTQihe1Gdg5irRZGN5ygmaXnn80t1EQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=P8UmLlHN9BGZ+esvP
        mRpvSz5It+8CW0B+z+h7mqv6Lk=; b=CQdazKNEiq2FcHTlFL0uPMb5vLW/qC86C
        o7moITxwIk/AdB90Xz1k1g9FpRlBS60WhckuoXzIh6ee7yQZOfcp1fvi7Lhv180Z
        RRDN2wsC5LP0twXOE842WI4MMRtGDwajK5p1LWPjO34veG/oH+NJ25WfhQ3fK+rd
        P4vWqFj6dPQlkm74sxZqhpdjoYNL/eD4woYay8uEELNkVbwPSYpqT3npzcElZIos
        tbcSHbcyqMIGuJYagh05xZ6tz+QgNe9ZwhSrBGAq4E2u5MmafmcEauaTBtaZxtXT
        9jKZbqWnRTA8zuiUmr2nCwSE4ZnTJdrX04g6Ug+/JdEiNsj+r5qUQ==
X-ME-Sender: <xms:l3TuYZs4WYtzYXKGvUmlQZ6qTEAL0VXvL83nP6AfxPNEYavh0ZIqUA>
    <xme:l3TuYSd4sl5uGKM2T9fKLT8vT4LXROUpCdQNG8XXrlczU6aewlHw3STG3ZPtbab43
    XikM_8TVBRYeQ>
X-ME-Received: <xmr:l3TuYcyKRDeVDHiosVw6unhQ6Vw3IaTpC6SmyCbW2zDAXJo3CLbqDNcF6cWeUfKkhs93civ1pSfqVBhj9xtUPX875W7G2DN2>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrvdeigddtjecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:l3TuYQPN1T0BEGzqQVp5X59NbIZEWA_RehUCZ7K4JsdrYy9FlZur4g>
    <xmx:l3TuYZ_AQD8MtjTxP_2h-y5A68SyWBzDsHAN5SeMho1BCLjw78wTCg>
    <xmx:l3TuYQV6GxHEv58_OUO5trHPu3PteZtoWQDNmeDSWRPb86Z5vwBQyA>
    <xmx:mHTuYfPCJPPU7ZpKL8-FeKWHVMnp3DfwfihodT2qB4adsocIWEcQlg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 24 Jan 2022 04:42:47 -0500 (EST)
Date:   Mon, 24 Jan 2022 10:42:45 +0100
From:   Greg KH <greg@kroah.com>
To:     Will McVicker <willmcvicker@google.com>
Cc:     Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>,
        Takashi Iwai <tiwai@suse.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        kernel-team@android.com,
        KaiChieh Chuang <kaichieh.chuang@mediatek.com>,
        alsa-devel@alsa-project.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, stable@vger.kernel.org
Subject: Re: [PATCH v1 1/1] ASoC: dpcm: prevent snd_soc_dpcm use after free
Message-ID: <Ye50ldr/4/TW7S/3@kroah.com>
References: <20220121231644.1732744-1-willmcvicker@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220121231644.1732744-1-willmcvicker@google.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 21, 2022 at 11:16:44PM +0000, Will McVicker wrote:
> From: KaiChieh Chuang <kaichieh.chuang@mediatek.com>
> 
> [ Upstream commit a9764869779081e8bf24da07ac040e8f3efcf13a ]
> 
> The dpcm get from fe_clients/be_clients
> may be free before use
> 
> Add a spin lock at snd_soc_card level,
> to protect the dpcm instance.
> The lock may be used in atomic context, so use spin lock.
> 
> Use irq spin lock version,
> since the lock may be used in interrupts.
> 
> possible race condition between
> void dpcm_be_disconnect(
> 	...
> 	list_del(&dpcm->list_be);
> 	list_del(&dpcm->list_fe);
> 	kfree(dpcm);
> 	...
> 
> and
> 	for_each_dpcm_fe()
> 	for_each_dpcm_be*()
> 
> race condition example
> Thread 1:
>     snd_soc_dapm_mixer_update_power()
>         -> soc_dpcm_runtime_update()
>             -> dpcm_be_disconnect()
>                 -> kfree(dpcm);
> Thread 2:
>     dpcm_fe_dai_trigger()
>         -> dpcm_be_dai_trigger()
>             -> snd_soc_dpcm_can_be_free_stop()
>                 -> if (dpcm->fe == fe)
> 
> Excpetion Scenario:
> 	two FE link to same BE
> 	FE1 -> BE
> 	FE2 ->
> 
> 	Thread 1: switch of mixer between FE2 -> BE
> 	Thread 2: pcm_stop FE1
> 
> Exception:
> 
> Unable to handle kernel paging request at virtual address dead0000000000e0
> 
> pc=<> [<ffffff8960e2cd10>] dpcm_be_dai_trigger+0x29c/0x47c
> 	sound/soc/soc-pcm.c:3226
> 		if (dpcm->fe == fe)
> lr=<> [<ffffff8960e2f694>] dpcm_fe_dai_do_trigger+0x94/0x26c
> 
> Backtrace:
> [<ffffff89602dba80>] notify_die+0x68/0xb8
> [<ffffff896028c7dc>] die+0x118/0x2a8
> [<ffffff89602a2f84>] __do_kernel_fault+0x13c/0x14c
> [<ffffff89602a27f4>] do_translation_fault+0x64/0xa0
> [<ffffff8960280cf8>] do_mem_abort+0x4c/0xd0
> [<ffffff8960282ad0>] el1_da+0x24/0x40
> [<ffffff8960e2cd10>] dpcm_be_dai_trigger+0x29c/0x47c
> [<ffffff8960e2f694>] dpcm_fe_dai_do_trigger+0x94/0x26c
> [<ffffff8960e2edec>] dpcm_fe_dai_trigger+0x3c/0x44
> [<ffffff8960de5588>] snd_pcm_do_stop+0x50/0x5c
> [<ffffff8960dded24>] snd_pcm_action+0xb4/0x13c
> [<ffffff8960ddfdb4>] snd_pcm_drop+0xa0/0x128
> [<ffffff8960de69bc>] snd_pcm_common_ioctl+0x9d8/0x30f0
> [<ffffff8960de1cac>] snd_pcm_ioctl_compat+0x29c/0x2f14
> [<ffffff89604c9d60>] compat_SyS_ioctl+0x128/0x244
> [<ffffff8960283740>] el0_svc_naked+0x34/0x38
> [<ffffffffffffffff>] 0xffffffffffffffff
> 
> Signed-off-by: KaiChieh Chuang <kaichieh.chuang@mediatek.com>
> Signed-off-by: Mark Brown <broonie@kernel.org>
> [willmcvicker: move spinlock to bottom of struct snd_soc_card]
> Signed-off-by: Will McVicker <willmcvicker@google.com>
> Cc: stable@vger.kernel.org # 4.19+
> ---
>  include/sound/soc.h  |  2 ++
>  sound/soc/soc-core.c |  1 +
>  sound/soc/soc-pcm.c  | 40 +++++++++++++++++++++++++++++++++-------
>  3 files changed, 36 insertions(+), 7 deletions(-)

Now queued up, thanks.

greg k-h
