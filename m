Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1CBD2351B4
	for <lists+stable@lfdr.de>; Sat,  1 Aug 2020 12:35:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728643AbgHAKf0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 1 Aug 2020 06:35:26 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:57657 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728249AbgHAKf0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 1 Aug 2020 06:35:26 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 1CDEF60C;
        Sat,  1 Aug 2020 06:35:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sat, 01 Aug 2020 06:35:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=wGHBnjsER1Eo7LQdqlUFBup26PB
        oeSderg0tJPqCmak=; b=LaxJgr9PKiU3KEDKNh2XhM+8vtfNXcPdJ+gg8okjcjf
        OkWurjKLW0bMOs2uCvCPYUFNhBDxkhoHnMqsmTtYUn97pRSxrABqya8ftvX2pTZi
        Fp79p2fYitaTAz6L4SS0fbaIFoO/qnx3KNIl99s41p5onpzhw/TomlsXbZSWiCmz
        /7HnT+x0yCGuRV9m143jfRHXNNXvrs0EhWMf24X4B1LnMavLJeD0qm3PknH4ZorI
        XW59wHAqIhgq2ZPX7OHLMythur8dgcYwo6hAaG+5LyEObCGpT7xK/nZ6zPISgxUq
        QCLuYlTsoI4CVyD1d5MyfMI/I97S6uAO5V4SdnuIykQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=wGHBnj
        sER1Eo7LQdqlUFBup26PBoeSderg0tJPqCmak=; b=iGdYWhEtrBaEzWxXVjh9bl
        pUPDvefc38FrFs1Q8Ajo6+SukUW9hnAtDs+KHMkb1Zska+RUb3KqmLYpPJijEvrU
        fwUOF6nVha71hTTsoyjvclZ7U9QSBajlGMKK61STSOAjVuI96iW4/GimLpuxd1OP
        0RT2nACSemgG9+zC1nXFnrhFZfEdmB1546+sRYTbPuWGsCPfr7+CGsEQQSPcj3wl
        7sHkRjoapAMywQvz+fNDmuKhHtUe65H+Fwjlnp1F3L9b+O8eaD+aUKFN3BwB/xkG
        NBYp/AX3Ul4/ZhADZkUIFPtNYK2r/mMkPL8QvsLbxJNSBO+xO8KCuru3TtVUqKcA
        ==
X-ME-Sender: <xms:bEUlX7SGQvgM0AryvycZiv8jyLNESraatPgjKUWmcHISaCke2ELbvA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjedtgdeftdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:bEUlX8wuPwd_eTtDsw5JY77lv_EhD2ErcaPvS15ZklONkKCWHTpD-Q>
    <xmx:bEUlXw2NYt27uV5_E91u9x8sb_NUIAZYtsTyzLw7xwCkUP9rZn_XKA>
    <xmx:bEUlX7Aoj2BhV9m0_uhAY_QGRNrirOfYQutwHB7EUAFbuaIU47sV5g>
    <xmx:bEUlX9tAIozwOltbiW3TObM6eTCrs-u-GSYvME8luCl7iSS67ixUqA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 41FC13280060;
        Sat,  1 Aug 2020 06:35:24 -0400 (EDT)
Date:   Sat, 1 Aug 2020 12:35:09 +0200
From:   Greg KH <greg@kroah.com>
To:     Sathishkumar Muruganandam <murugana@codeaurora.org>
Cc:     stable@vger.kernel.org, ath10k@lists.infradead.org,
        linux-wireless@vger.kernel.org,
        Abhishek Ambure <aambure@codeaurora.org>,
        Balaji Pothunoori <bpothuno@codeaurora.org>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH] ath10k: enable transmit data ack RSSI for QCA9884
Message-ID: <20200801103509.GB3046974@kroah.com>
References: <20200731094416.5172-1-murugana@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200731094416.5172-1-murugana@codeaurora.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 31, 2020 at 03:14:16PM +0530, Sathishkumar Muruganandam wrote:
> From: Abhishek Ambure <aambure@codeaurora.org>
> 
> commit cc78dc3b790619aa05f22a86a9152986bd73698c upstream.
> 
> This commit fixes the regression caused by
> commit 6ddc3860a566 ("ath10k: add support for ack rssi value of data tx packets")
> in linux-5.4.y branch.
> 
> ath10k_is_rssi_enable() always returns 0 for QCA9984 and this will cause
> the ppdu_info_offset to hold invalid value in ath10k_htt_rx_tx_compl_ind().
> 
> This leads to CE corruption for HTC endpoints to cause WMI command failures
> with insufficient HTC credits. Below warnings are seen due to beacon
> command failure in QCA9984.
> 
> [  675.939638] ath10k_pci 0000:03:00.0: SWBA overrun on vdev 0, skipped old beacon
> [  675.947828] ath10k_pci 0000:04:00.0: SWBA overrun on vdev 1, skipped old beacon
> 
> Tested HW: QCA9984
> Tested FW: 10.4-3.10-00047
> Tested Kernel version: 5.4.22
> 
> Fixes: 6ddc3860a566 ("ath10k: add support for ack rssi value of data tx packets")
> Signed-off-by: Abhishek Ambure <aambure@codeaurora.org>
> Signed-off-by: Balaji Pothunoori <bpothuno@codeaurora.org>
> [kvalo@codeaurora.org: improve commit log]
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> Signed-off-by: Sathishkumar Muruganandam <murugana@codeaurora.org>
> ---
>  drivers/net/wireless/ath/ath10k/hw.c | 1 +
>  1 file changed, 1 insertion(+)

Now queued up, thanks.

greg k-h
