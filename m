Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52C803C9D75
	for <lists+stable@lfdr.de>; Thu, 15 Jul 2021 13:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241738AbhGOLKA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 15 Jul 2021 07:10:00 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:58197 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232114AbhGOLJ7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 15 Jul 2021 07:09:59 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id A13AC5C01B5;
        Thu, 15 Jul 2021 07:07:06 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 15 Jul 2021 07:07:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=8dNsrbgZznxMli/bzRt7xUyBOhs
        Lh26Af7wai9plHMo=; b=JVwa2w8oZY1rYMltJRgg0QprRFB4f6sIDCi4vRSC60b
        m28tVIhmv879xnnhh+SCvMxU+iQgcAE2pJF8U+t+mZjcZenmk0iX8nnYVm0yRy84
        qfsm2veS3zUCOZ3DKmpv4sICXeA3nld0EDUS0+qaeNTsEzSCAlUVkD9ZP9eYzawA
        /82wIVNmocYYrsnMRIYv6KKlJbpul+nE1F/CO4AmmyCkSqAj2XQ5Rjf+K1NDJgo/
        W7OUeZTgvjf/oGv9zvg3vfgs8+RRCSCj7pusgqv7bQAzgVra6xWuJhF2yTLkveVb
        qE/Z2HIFCKvEgCdsVxd5i2NC4eC4dKCz3tKb2MoCFxg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=8dNsrb
        gZznxMli/bzRt7xUyBOhsLh26Af7wai9plHMo=; b=w2PUdjNtgdBI+g8apuSAva
        zWQ+ZnzMvqpkGFdJ5ZOJpr5f2wvVdAT1kRiNDrSJN3a723AG89ndnwh61EmkHswX
        H2fh418X5JlYLwEhsCzHTcx1SCK6rM3oUiHMrbcFAz3wQjTg+ioUTZkUGm0YaBbA
        hDw8v/UHbCrdG9zhysB+I55VUrHOtagEee5X0efLbWv2apoWAMHN4iG6FSsZ892u
        6Eow71TkCMvul4usZiy0cqoOVz+t0NaHEnR8BHKP7y0R0ZPl3Vqjb5T2t5810rCx
        nQiVCA0uGoI9Np90yfo67CkAAXLbFMgrDWX+nO6wmhot4jZtodndgbeVr7+UINkQ
        ==
X-ME-Sender: <xms:2hbwYMBhlVuZJKI0kuhIRzYDx7B-bg1P2ckSKEeywJkH2D0CfNVqfw>
    <xme:2hbwYOg6YxlsHnw8ZKUA0JGsXMNBEr5tqL04E8smuiA97_L3I_g9xfbrcNK8WLCNH
    HQ_Xggzmkak0A>
X-ME-Received: <xmr:2hbwYPncbGuCf4O2C3jb3bmccZ3hEw5plZhjmpyJwEGYCVU4gm_yCf9PdCYpdlV8O4fc2cHo9SIp-RB0oe9rj4QJMA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddtgddvhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepjeegleekud
    fhheejvddttedtteejkefgleefudefkeehgeejuedvfedtheeukeehnecuffhomhgrihhn
    pegrrhhmsghirghnrdgtohhmnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:2hbwYCw4UXRk7xakN478YxP6i09r42Ti3Ax0hCE3qeiUqCCsSCfMNQ>
    <xmx:2hbwYBQ34Kv23d8De7xOABtLBnHEEfgfb2owXajrzG3MLxZlL3yRyQ>
    <xmx:2hbwYNYHSj9beJqVSZVck5d09rg8HjWsu5rA3o_XJOIwxY_QtCwUCA>
    <xmx:2hbwYPMK26mlz4YeWvotxLxI-tpWGyXgby1SpoXAqToxDJPK02Hcbg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 15 Jul 2021 07:07:05 -0400 (EDT)
Date:   Thu, 15 Jul 2021 13:06:55 +0200
From:   Greg KH <greg@kroah.com>
To:     Andres Salomon <dilinger@queued.net>
Cc:     stable@vger.kernel.org, Cameron Nemo <cnemo@tutanota.com>
Subject: Re: [PATCH stable 5.10 0/2] arm64: dts: Fix USB 3 for rk3328 Rock64
 boards
Message-ID: <YPAWz0Ej45ZJcHPA@kroah.com>
References: <20210712194251.7af563ed@e7470.queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712194251.7af563ed@e7470.queued.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 12, 2021 at 07:42:51PM -0400, Andres Salomon wrote:
> Hi,
> 
> At some point the USB 3 port broke on Rock64 boards; users report it
> working back on 4.4 kernels, but by 5.3 it wasn't any more (eg,
> https://forum.armbian.com/topic/12439-rock64-usb-3-broken/).
> 
> These two patches add a USB3 node to the device-tree, which allows it
> to work again. I've tested a gigabit nic and was able to get
> close to 1000mbit speeds over the USB 3 ports. I'd love to see
> these two unintrusive patches added to 5.10.

Now queued up, thanks

greg k-h
