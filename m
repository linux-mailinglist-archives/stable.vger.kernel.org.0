Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83377468AD9
	for <lists+stable@lfdr.de>; Sun,  5 Dec 2021 13:42:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233734AbhLEMqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Dec 2021 07:46:23 -0500
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:51671 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233720AbhLEMqU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Dec 2021 07:46:20 -0500
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 840255C008E;
        Sun,  5 Dec 2021 07:42:53 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Sun, 05 Dec 2021 07:42:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=iecYnGYiVPdit3vXcQPO6CB22Tq
        HffOdq/OYjkikbtw=; b=cLqu/zDlF56P5/Fqyi1Sxn3zBm5C1lUpEJXP6kThckD
        cUnEhsAqdv5usuF5vhPOoxLeflCrFTuXkykQ4pEncbycLR5hlipfhWVK4stjSEeI
        EPiWfqct4RHJYeDVPx+pwvGp1jpGPVkdg2PHXIyNm5zNJTm+rMlUoRVGU0pHBCPo
        2iTzqKQc+O+O+ddljMALpxrrXbx7JM+7wE7csou+AIM0Y71BTK9+52GuwwvlU1Hc
        +axGT5xSkzBDT/tGxBRfVvWr0ptoFelUGewbV2ENyInYauPYXY+UoQVaq72FDfgx
        qFsZJ1AOhX84pLF4ou4mqS9BPjsg2a7dBbgZllxPYpw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=iecYnG
        YiVPdit3vXcQPO6CB22TqHffOdq/OYjkikbtw=; b=SdwzJkx6C2zVwSF5nBoBI2
        6H2Mz6E71eG+2svTWEq4/J3fU28rQbmm+naooJan5cMfJo8iVMDVZyYcPiBshlz/
        37BwvNAFctLa28xsivsQioM/Z1XBkzLa2RgfrwyPj0Z+1r7WyDjz3FoixGBma0ok
        kmPks3xxq0n2d3MNu98x85vk9iZeAxzBikDljDBNM534adOw+ZSdTmHQKnqK0+Xn
        6TC5GrzFIgzzRkJGqzCh+14wgbKoa60WBD3Za1PSyEYF72Q/7RebaAD8b/Zw10fL
        MRnf6+NiY4DH2Nksa9l84ZySWVFavqvVrg3LcC1AcSt0O1MigPPS1/X2kQFNKdtw
        ==
X-ME-Sender: <xms:zLOsYfiSnbxB2OPR6kuQ5xlxyKFbCXePl38RkpXjyYtuViE-n-kkMg>
    <xme:zLOsYcB_uLU9wStj1IlX-pUFQJXzoSHbcyQvmnnUq9pkFBNmn3AKZbEUelScwCcJe
    jSOUsYUGcLRfQ>
X-ME-Received: <xmr:zLOsYfE8tV6dyZWabcCZrzoUpDnvO2mxGWddqfxQdStQnWqL5qFQiy-yIv-0-bXllNLsvwZ3gwNc032nDrQhOVWnTSfOHFwE>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvuddrjedugdegvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:zLOsYcTk-phMs8B70-dx4YCf_6eJ0rBpMt7mLZqPDh0aZfhw_G3zgg>
    <xmx:zLOsYcxDT6Uz9V56LN4rTnYFQglZ7VmEvm8FZXBfHO39gyVMDnHa-w>
    <xmx:zLOsYS7Cn4JeliLbHgsyzHbxLBlifVPI4naK2VKRkm7vGpl0ViEc4g>
    <xmx:zbOsYblDYauFfZZCdLj_VQtYGe1ki0ndU0DBGcunaF0hBn_sKKJXeQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 5 Dec 2021 07:42:52 -0500 (EST)
Date:   Sun, 5 Dec 2021 13:42:50 +0100
From:   Greg KH <greg@kroah.com>
To:     James Zhu <James.Zhu@amd.com>
Cc:     stable@vger.kernel.org, jzhums@gmail.com,
        alexander.deucher@amd.com, kolAflash@kolahilft.de
Subject: Re: [PATCH 0/5] Bug:211277 fix backport for 5.10, 5.12 stable
Message-ID: <YayzyuulcNyx3O56@kroah.com>
References: <1638552452-4198-1-git-send-email-James.Zhu@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1638552452-4198-1-git-send-email-James.Zhu@amd.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 03, 2021 at 12:27:27PM -0500, James Zhu wrote:
> These patches are back port for 5.10 and 5.12 stable.

5.12 is way long end-of-life, why would we need them for that specific
kernel?

I'll go queue these up for 5.10, thanks.

greg k-h
