Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80BCC396E94
	for <lists+stable@lfdr.de>; Tue,  1 Jun 2021 10:11:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233194AbhFAIMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Jun 2021 04:12:44 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:50203 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233162AbhFAIMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Jun 2021 04:12:43 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 4DB1C5C008C;
        Tue,  1 Jun 2021 04:11:02 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 01 Jun 2021 04:11:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=lnQ32Sf1wZ+WewKcBn/9udU3Qgu
        dicFZcnFTOCTBv/U=; b=YTClW1nWpNzvfFmYtkM+w/gdMbtTVPe+vYlB2gOhuAt
        eTAwndeGZAy1xyfDU8p44ZI/0bo4cXAm0DrPu8W+5Mb5ovxLI9pTx9eFxK0nDeWN
        9W0EC5DH/kJ7ECiSXovvKi1vv01W4MM9ORwyFQa8HMh4CN/zJc4bHwHzMiE7X/Ib
        DZAPOdWvXdWNx6vQC03e2RMMB/+fZ97yXPutMeFGQrxk8Y53tkT5vniExtgwRjC0
        XRkwzLjFH3aIGsnyntLr4ihZMnWbRGT24Tr6S38/3z4UZrXpHUUkx+oHncSrxtVj
        xTPSmrQSWG7riCWw6fXAp8cJb+zmNFwP8QojZ44mCuQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lnQ32S
        f1wZ+WewKcBn/9udU3QgudicFZcnFTOCTBv/U=; b=cvj7ILjsZrIT8Xx/AtlizM
        AeVAvdAO1+N5Ud7NTWsWJxOd4/gW8SukE/h/nqSzIb9h0NmYVuwWFGnAh0fRSJCp
        aCcTPtY3n4d2XCxO3Hr/otqHKB1xz8Pfu31e+xsfxZiTckUX0NSqcf42QAY30oA0
        JjCgR4cdAdvurziz22hwLw4WJDKNd+ShjsPw3qcpTg1IRV8m94xySjqIeyb4Iu+/
        uAcYmHNGRJf56sDhwOk3vVRDwAD2846GOi/w/ILja6qJF1H1eiD/qkApB8dltfz3
        8CEwpjwSLAOCUAFfW826fXsPKNtFBJtQ+djGTHaCbw9tL7eS8Uu1xzYbd3bWS84g
        ==
X-ME-Sender: <xms:leu1YKdM3Q9f6Ivk8cBemC48ZU7hUum7Ovvz0MTAOsoIIjHTJyp-Mw>
    <xme:leu1YEPJAVh_0DG4_7g8k0SHiuaeNWmPBzTd2jhva5R8TF6KDqWfPwVorlSmpoKcY
    _ZDETT_6s8WYQ>
X-ME-Received: <xmr:leu1YLg7ua5SPz819vjjcdEfrXNFyXm6vfjQDCDQyec96gSu-0Eyu_3drH5-CsKW9P__wAn_iyvMoAlCZRy5mPHk3Kicyd6a>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdelgedguddvlecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:leu1YH8pCbND97oRQgGxZocnYs5LOcT3UgeMfctejw-PlPO2yFT61Q>
    <xmx:leu1YGuJhhUJWF_Mfmt42wQxpuDC3fXno0adjBvwJhSfN3Km95809g>
    <xmx:leu1YOFASQP_Uknnr3AWemVkQ1eYa4-JpoLmvFPEfx98NcnCnyGNhQ>
    <xmx:luu1YIJdPBq0uq2eGKVE2SAVLJ0x6svKK5DPVApgLwzBIYGL52aQHQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 1 Jun 2021 04:11:01 -0400 (EDT)
Date:   Tue, 1 Jun 2021 10:10:59 +0200
From:   Greg KH <greg@kroah.com>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v4.9 00/10] wireless security fixes backports
Message-ID: <YLXrkzDG6tZGT9f7@kroah.com>
References: <20210531203021.180010-1-johannes@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210531203021.180010-1-johannes@sipsolutions.net>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 31, 2021 at 10:30:11PM +0200, Johannes Berg wrote:
> One or two of the patches here were already applied since they
> applied cleanly, but I'm resending the whole set for review now
> anyway.

All now qeued up, thanks!

greg k-h
