Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293C34287FA
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 09:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234374AbhJKHpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 03:45:16 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:35609 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234317AbhJKHpP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Oct 2021 03:45:15 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 939D83200E60;
        Mon, 11 Oct 2021 03:43:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 11 Oct 2021 03:43:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=qCbhiE2KmlHC2aGFcT/8AUqCFwz
        D4Kpy5x6fUMsDxXE=; b=waamM1HRKA9Si6ssv4tsnOxQH42YsJxW5oS6TFfOJ2L
        SidHdm8PX/+uJSen0IFfBWSYjl2w7tRax5qlqqoFB/gS8DI4Jkn5s5jSqdCAplUr
        lMyqiaTgIN2afed4HSZOLMP6Rg6AN8C4SSEcBmPAsPEYbTfk8vaqaCopR5Jq3u/4
        H++iW4dxOxsx2CYAwXWvuxYnKtWDRMMKjHtF2w6VbRz6OaoDnW+SvQTzIIA90Ddj
        hf/AfrlmN1tMuW2NQAzk4oaOH7WvY3DQWwo5BJv0JPmhKq/6ejRSormDEqszVYsx
        spiV2xX1KNBFlyZxYHdtNfKy8a3sdQIOnCuJpQLPjSQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=qCbhiE
        2KmlHC2aGFcT/8AUqCFwzD4Kpy5x6fUMsDxXE=; b=jIK9GHJ0u+q0twFoGwy+8J
        0tUT50XDPQCkNy7bqEBqF9uvfAXNAh5mvEzqhBEr+TVdSQFX9Qnlrb5mv7Rg0BCo
        BevfwSFkGLBm89VqlWfDMwgYYwKTk8xcK2px/bxzVTfd57GztGdHen/9yrZwKiGI
        uNyGK6Ed38kvpQlOhga425ugGrMMnXx6wokZ8Aemg/jh1J8wTPCvvJmShUIeRmTU
        C6BDOYxX9s+Ia8qNQ/1d3JcxZwbvKAbT+pajVkC8aoQqV1DAxyZC9fXt+aCEY8Xd
        R7IyLs1VKfwm+Wlm2zxFDfM24irgj37cCsnT5c+AQ2XxTntm1nejRqvDyDpUPy+w
        ==
X-ME-Sender: <xms:E-tjYawkF63bS0SXlVOcJ37j_UIYV_YsPZAnJX1Hd0cTcEmvTI16_A>
    <xme:E-tjYWRBU7wnFWNdUQN6NOZBeiWXx4FqAgaO_97rDHmkw0TFkGJ7icg1XazMTUfSV
    HbSw6u-LdakJw>
X-ME-Received: <xmr:E-tjYcUHw_Mo4Pacz5uHLvDtpyfcSkX0pAam7yFGE--yXT9zW19_7se78EeSSNvRCWdeHEvbYr0O8ZEOKtPvTtb_xCU5dHsV>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrvddthedguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:E-tjYQi5hEcFPHAAPvl6RyL_Eva6erEd5GT7n9FcB1_62DxCEN9U-Q>
    <xmx:E-tjYcC8Y3FvNNvHZh_ld9ECIvIAKDUFXXuZ5DqKON82Y4LeEm-ZUw>
    <xmx:E-tjYRJ68uRV1Z26ssPX5KLqkuRGqsMCAYI-wlYiRsOw_cBnFQk8Ww>
    <xmx:E-tjYf_7vsFytHX96roDUtPqlZR1RiaTziah0XvZSHKsXriv7JNLeA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 11 Oct 2021 03:43:14 -0400 (EDT)
Date:   Mon, 11 Oct 2021 09:43:12 +0200
From:   Greg KH <greg@kroah.com>
To:     Adrian Hunter <adrian.hunter@intel.com>
Cc:     stable@vger.kernel.org, Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v5.10] scsi: ufs: core: Fix task management completion
Message-ID: <YWPrEN74aqb90DuM@kroah.com>
References: <20211011063559.357128-1-adrian.hunter@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211011063559.357128-1-adrian.hunter@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 11, 2021 at 09:35:59AM +0300, Adrian Hunter wrote:
> commit f5ef336fd2e4c36dedae4e7ca66cf5349d6fda62 upstream.
> 

Now queued up, thanks.

greg k-h
