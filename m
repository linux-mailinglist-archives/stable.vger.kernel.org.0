Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 122FE4A3639
	for <lists+stable@lfdr.de>; Sun, 30 Jan 2022 13:28:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354781AbiA3M2W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 30 Jan 2022 07:28:22 -0500
Received: from new3-smtp.messagingengine.com ([66.111.4.229]:52189 "EHLO
        new3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237385AbiA3M2V (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 30 Jan 2022 07:28:21 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id 82740580192;
        Sun, 30 Jan 2022 07:28:18 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Sun, 30 Jan 2022 07:28:18 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=zUB207/0T8+iAaUGsiP3Ilwar5v0hrGNCVC7Ki
        i8yyQ=; b=ZiKi+jQ66Hz/ZVrR3UVizyz4wxGw6ivgmwit5C53OckC+OM+/RSN/u
        Cu/hQ23csRTKlrOdL2znyLTlmaFn8by6oJa4NJhLntuHmxbqZ2GrqiRNl5VVPBLo
        QzM+SNTML+T7JjA0eAVbWzqgr8hQjRGaieVkLJMY1juGPxLmZnXy08P8q4/TWlpA
        UUfP2kIGsWWLsPLF8BZgSMhZbg5x7ngadQWfUv1a1IW+MFfGtwpbV3ZRPHsHVk5J
        HxqQNIxYGWx5pXap44yTBIII67ZWbJGFhz1Vjs7aIVzboI71nHmzfWQAB6ODoumx
        X2NEuZaY1wLTpJAfpSR4NJDE6Cg2FR5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=zUB207/0T8+iAaUGs
        iP3Ilwar5v0hrGNCVC7Kii8yyQ=; b=VgK5TO8hdizqBvLH+FZ0wsIROkD4i3dOK
        H48rsr4+mToF6Fyt0O0LbIe6IlyF5xE3yGyHNaKq3b6SxFNpK2ei95AXwGmpgPTS
        DG76Mfoi44W7uMl/fH+r3MaN5k4b1Bcf+DCwwvxnu0mlNhIku/jiXgkKkSrnVqyt
        LzzEsKXuKshlWjs7+mVqcY7F6TReL6MrRUgnpOfEVS9XmDfB72sCKokMtU5EiFP7
        6Ds0Qo3vf4VjmHSV8Ux1S4Fl2Bjl1OQSX6+2dk0R6KaQFSMWghU/tM0DzyUTt5QW
        wQgDhZFhTJVRCXnp8V8G6Fue1jly6NM+zYcH9Z+0Ei4iAy95lc2wg==
X-ME-Sender: <xms:YYT2YSqMdo-Y5vK3DKmLJk_Xf4wgvatKCnNZPwSW6Q0oxBiAXo3lfA>
    <xme:YYT2YQqGFYL6dEeTdL2oizstCBQsz9D24gTXMYdmoWgG2GFWIsuLwJl9it8HgtEm9
    RIXyTYR8Xj5Fw>
X-ME-Received: <xmr:YYT2YXNmL-4iUz6A1ctrng7mmmg9H4b2-hcZwAqT3JFxtxz9ni63Qb1PcMBxxaSf4ESHvPcUV0fivgUNXsMoOFOUutU3QyKL>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfeelgdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:YYT2YR5dIXFqhTyO9IDbI5HzXYVNISqqGnCM0rraeKF3wNBvrv-xKw>
    <xmx:YYT2YR5eyTxaXRV8LVaJifMGMTd3H9eAoAP-Yv15a3BI9MszTET1MQ>
    <xmx:YYT2YRij2hRcqOHp1HWos-MU-9tZDAH00_mRWLsuvPYYFR03gtrhwg>
    <xmx:YoT2YZy-aiER06UagkZwS26Opwrk0hN8_5q7bapgOWTkbuc56b-rWg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 30 Jan 2022 07:28:17 -0500 (EST)
Date:   Sun, 30 Jan 2022 13:28:14 +0100
From:   Greg KH <greg@kroah.com>
To:     Felipe Contreras <felipe.contreras@gmail.com>
Cc:     stable@vger.kernel.org, linux-wireless@vger.kernel.org,
        Ryder Lee <ryder.lee@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Sasha Levin <sashal@kernel.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [PATCH] mt76: connac: introduce MCU_CE_CMD macro
Message-ID: <YfaEXktLe4G9pL7D@kroah.com>
References: <20220130075837.5270-1-felipe.contreras@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220130075837.5270-1-felipe.contreras@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 30, 2022 at 01:58:37AM -0600, Felipe Contreras wrote:
> From: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [ Upstream commit 680a2ead741ad9b479a53adf154ed5eee74d2b9a ]
> 
> Similar to MCU_EXT_CMD, introduce MCU_CE_CMD for CE commands.
> 
> Upstream commit 547224024579 (mt76: connac: introduce MCU_UNI_CMD macro,
> 2021-12-09) introduced a bug by removing MCU_UNI_PREFIX, but not
> updating MCU_CMD_MASK accordingly, so when commands are compared in
> mt7921_mcu_parse_response() one has the extra bit __MCU_CMD_FIELD_UNI
> set and the comparison fails:
> 
>   if (mcu_cmd != event->cid)
>   if (20001 != 1)
> 
> The fix was sneaked by in the next commit 680a2ead741a (mt76: connac:
> introduce MCU_CE_CMD macro, 2021-12-09):
> 
> -	int mcu_cmd = cmd & MCU_CMD_MASK;
> +	int mcu_cmd = FIELD_GET(__MCU_CMD_FIELD_ID, cmd);
> 
> But it was never merged into linux-stable.
> 
> We need either both commits, or none.
> 
> Cc: Sasha Levin <sashal@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Felix Fietkau <nbd@nbd.name>
> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> ---
>  .../net/wireless/mediatek/mt76/mt7615/mcu.c   | 16 +++----
>  .../wireless/mediatek/mt76/mt76_connac_mcu.c  | 47 ++++++++++--------
>  .../wireless/mediatek/mt76/mt76_connac_mcu.h  | 48 ++++++++++---------
>  .../net/wireless/mediatek/mt76/mt7921/mcu.c   | 24 +++++-----
>  .../wireless/mediatek/mt76/mt7921/testmode.c  |  4 +-
>  5 files changed, 73 insertions(+), 66 deletions(-)

Now queued up, thanks!

greg k-h
