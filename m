Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CBF229EBBA
	for <lists+stable@lfdr.de>; Thu, 29 Oct 2020 13:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725767AbgJ2MSU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Oct 2020 08:18:20 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:48923 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726634AbgJ2MSU (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 29 Oct 2020 08:18:20 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id C952E9AF;
        Thu, 29 Oct 2020 08:18:18 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Thu, 29 Oct 2020 08:18:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=BHkZdC0G76tK3OuS/Hvq8k0Yo6+
        YxTQWQ6RCg6q5kOQ=; b=FHs0PYw0GJhxQpk94NTdH7Rtd3KpQ5RHQ7gtlKpE/uG
        ZftZgyOWieedTnnxYDTUrcADUoOnepS8T1cT6wh+7R8WICgs9lz4nbrOqwSdWMQo
        KIeAXuVJZSL5sh2CrMh7BGDRqORWo6RNUgJX6AOGIOm7lAMrPB2S9FeK35TsfwGg
        ZTNflhxxuzrxHEX2XNWAcGV/s3N8VC6Ui1B2g8ueClqQhgsgp7Vz6dpYBYqveEBA
        WEK1d6J1LnQczKzlmakFFtlqbcxccZAApL74m13eouf87kg0C5YqXS5bSxSdbX3y
        WRnqZEOM6yl20OLwoh0hznkxINl3Z1e4cevsp/kYFpQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=BHkZdC
        0G76tK3OuS/Hvq8k0Yo6+YxTQWQ6RCg6q5kOQ=; b=ipMlQihz/9K4IZAXicneyp
        MqC1l27PICaRPvWY3p/6gIdC15+VRnFEjEn7CghEZlvzRD+iPSRsGSOIB0fXEK6M
        AJEBcbb4/iH9C7YzHwXKWAGXh+H7QvLUksGpcPRICPER1QUok6hfWZl98Qm1D4rY
        jCYocryYpqmRUlhsHNpBSArY5yjxBZhacxOWxwsUsdWq/PN5QhN97xsWvni3mALv
        otIVCWLKMVb72rCmHtftGd8mktGyyZaBNjPfLDipwcWylNcj6JRbmojiLlGiANZo
        8t9+CiIXGiullPfQM1/HwMC9K7kUwqL+FSYY8yEMYjzOPC9Po7jZcZZg0e7urm9Q
        ==
X-ME-Sender: <xms:CrOaXyUUAgD0tT5NpsRO9Bh2AYIunq7a9HFWfcJzhGyKokAq5dXihQ>
    <xme:CrOaX-ntDc-G99UiZ_FdGUY6czjSXdKS-L62cXIBDXSClXCs3-GA65uxnyq7dltvI
    PJ7l1s68raLcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrleefgdefkecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilh
    hfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:CrOaX2b62QTHlpyOgjARqLFp2NKuBBqWowbF3Q90ixd7kvBiRsitGg>
    <xmx:CrOaX5WtsnYZnXYfTyaLHTf53CZs67myNaZ7npII83HG1DPJf0iulQ>
    <xmx:CrOaX8mKp4kHppkPXxsYrBydi372Fpm_YODY4uYg_05qY3wny6an6g>
    <xmx:CrOaX-SUAOGc-Qi536AgOEnKeVLbhx_7-OwPFUAmbIsENqBPuLvENw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id ADA1A3280059;
        Thu, 29 Oct 2020 08:18:17 -0400 (EDT)
Date:   Thu, 29 Oct 2020 13:18:38 +0100
From:   Greg KH <greg@kroah.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: 5.8 stable inclusion request
Message-ID: <20201029121838.GA1502391@kroah.com>
References: <e9b172db-412a-4c94-cb13-1e64f0a386e5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e9b172db-412a-4c94-cb13-1e64f0a386e5@kernel.dk>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 28, 2020 at 10:33:06AM -0600, Jens Axboe wrote:
> Please include this series of patches for 5.8-stable, thanks.

All now queued up, thanks!

greg k-h
