Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A1B33D2519
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 16:03:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232177AbhGVNWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 09:22:55 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:48191 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232118AbhGVNWy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 09:22:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.west.internal (Postfix) with ESMTP id C3BDC2B011CD;
        Thu, 22 Jul 2021 10:03:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Thu, 22 Jul 2021 10:03:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=PIk/hnjdDcCpZshdtUpN11tWW3z
        Z8Twd1XIuw3t2v9A=; b=FEd+443hzUX7l2d2yJupnpd04JIzl4zwpr50xC8aTPF
        NMErx37C4+VCbhcLdyuYUClJPHzYDBSh/R696L/J4C9s6ZOQGrGSIpoW9Zo94JsX
        Z1IzmiPK1IL2SVT9ZipkzrzYG3F7z3vWyOjPdPBlJPM4e87nBrhwDWjYJfSPneKh
        RhhO9xZFFyFXh0e/NfLPUuxJjeBbFwhYBM2oXwPp9JLQBOiXxLJSqavMQmxJKnCg
        kXBVsRBPGpu9VRNRTcnTZ+DoJ9ATg9SnfZ5wNOnCqGnJd6p3wBy6e6iqX+ghkcgL
        6YTqpUKIiXxApuCyfdA5e4BnMWBtSAafpP50KfiulzQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=PIk/hn
        jdDcCpZshdtUpN11tWW3zZ8Twd1XIuw3t2v9A=; b=NBW77Rf/nXISuONKAAJ99l
        OnLxSiMA5wuLeVEsb/9oX3BH9Tzq5SxKPG/yGZHDS4Jy9czL2S7ucQZ1xdqpWPvo
        qzDYFxCw/ScWzOjdhif/MsRJ/adTax7GRrWsg2rlAx/hiVkCEgggq2svK77cwY5i
        Hdg1g99CkTMJ/Qn6sW9hLLgCu10si/GV+U6ldmpvRmFN6aggSnzuGjsSthfWsebv
        PACKvGEGfWq55jYC0OugiDwFXh6FcBY7wmEOrvXzVpsqcuuV6C9UAoJTJr1Vk3QQ
        IMUFWft9LX98w5Tor/1CFHzM0oXHDpweQ4VbfWw5IgPpdCd1jY9Vyd8kIENV4ooA
        ==
X-ME-Sender: <xms:r3r5YBgjEs9SnC-0OBgvBfTxPSyYLAzhbJReyC7TlT5xd27CqR0qVQ>
    <xme:r3r5YGCdVuj20xJ5x4GDa9UCYY4z_6hWzA10An6ePc2RDTXo-PllfjoAnDzxsPDQb
    1YMMOhvyUzV6w>
X-ME-Received: <xmr:r3r5YBGaJQpMbe2lrmUSk-b9kOAcg_u9xIjPSS-VhLDWT2O-f_F3BcQGSQI1sADJRWKpXzu-_LmIs03E_clsazuMHdYU7OeS>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfeeigdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:r3r5YGRL_STZsjgzjiTjcvaBV_wtteAN7rCxTl_c55WkOwylT9wSZA>
    <xmx:r3r5YOy1CMZwiDVdgkLSXk1_NH9AshUTiZ1gzARN_8YIQmBCBVZXMQ>
    <xmx:r3r5YM4ZngPZNmC8VnHOyIqv97tu0VYWUzuQ_miu2FXyOmZKrRq5EQ>
    <xmx:sHr5YDqb-NhNKBF7RawpCav2SP-05XUU-SEQ75nRMxdRPMv3etaH53KUcEw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Jul 2021 10:03:27 -0400 (EDT)
Date:   Thu, 22 Jul 2021 16:03:22 +0200
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Daniel Rosenberg <drosen@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 5.10,5.12,5.13] f2fs: Show casefolding support only when
 supported
Message-ID: <YPl6qu39ZrG1SJTw@kroah.com>
References: <20210720161629.1918963-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720161629.1918963-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 20, 2021 at 09:16:29AM -0700, Eric Biggers wrote:
> From: Daniel Rosenberg <drosen@google.com>
> 
> commit 39307f8ee3539478c28e71b4909b5b028cce14b1 upstream.
> [Please apply to 5.10-stable, 5.12-stable, and 5.13-stable.]

Now queued up to 5.13 and 5.10 stable, thanks.

greg k-h
