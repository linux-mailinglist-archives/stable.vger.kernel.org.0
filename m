Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 621BD23EE01
	for <lists+stable@lfdr.de>; Fri,  7 Aug 2020 15:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726204AbgHGNSL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Aug 2020 09:18:11 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:59283 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726015AbgHGNSK (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Aug 2020 09:18:10 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 292C5A51;
        Fri,  7 Aug 2020 09:18:09 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 07 Aug 2020 09:18:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=DQhh3sRf5rzVw/c/kxpgper8I1j
        t+rjV1GSVvWGnKy8=; b=SdaTDc21JXfpfLchnhr3jVHS4tRQlIZEc1rQzZI5wtQ
        BXV5h1bUe3Vs+6I9pfyubXdPij8vMhzuFI2n3HIF3dNeqGsxy+oSrKFF24TPIDH1
        sIJtkMaoFeWwWH42OL1XNZfB4Dy8baIyXPPTr4aaun5ZxHNtJjVyh7EjnvJavCxi
        0dYtqcEd2iqQr3L5PbzOrL0HTx8Zw7SQfaH8UpNoH1fqaRpQSBlmqkO1M4k/rDol
        EppO06TARuhY6BfQAkSdUAczYjA7dgH8vEUNEpfx38P07gHcTsjrs9ka0n241OIb
        dThuvAZYDq+YaAcXbaChpyop/IzeV2l744vJ71V2/iQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=DQhh3s
        Rf5rzVw/c/kxpgper8I1jt+rjV1GSVvWGnKy8=; b=JvYzB7arlzCouDFDNxT4Ye
        wgDSXolRX0xPdvSfIG4/RfvT2rI2N3mam8fzLp35un6cJmJxxxu0iKxhniAFSktA
        zmD7JpquuDPL37I1L0pOkIYawADfRi1A/thNcY9eI0085nCbks3XlV2fKHLZELIi
        UV2xkMi9U53RYAfeLfoUhkOoy5yBoeFKJC2TuWo9+PASvhY65IWRBg84OZWaEwE5
        HCZTy7JVGxV2xWz3U+zLio7pJv0g6FnprEsZO8UQUW2QMo3rasdyvfUKwbpxvv/K
        +l/D4DGvEQz/BnQHcmg7pl6D2rx3fpTP6R8NV18Cxil6h54quz84igjPprJfLwbA
        ==
X-ME-Sender: <xms:kFQtX_52UMflKckiIe_m2MlSpSm0W2ZRy8j1VBbUZH4oP4YwrVMZow>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrkedvgdeihecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:kFQtX076SGbh0pM7ejoKT6sjJJ8SmZck2si3TcA_vl7q0mPvCojjyg>
    <xmx:kFQtX2f_PHmehc0rXNq-pZP5Z1GUm4haWDRuc13uOBIXG8s6Q72-Ow>
    <xmx:kFQtXwK1RnZZ7A9RR_2oRTJ3_DqzTEiumYuEy8DM-7Bb3PagY_AMIA>
    <xmx:kFQtX4WDTSyVy5j5ytvQPT_E5dbFOpDrq-6tzfXdkDoMVHxSPRxK0Q>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 275CC306005F;
        Fri,  7 Aug 2020 09:18:08 -0400 (EDT)
Date:   Fri, 7 Aug 2020 15:18:21 +0200
From:   Greg KH <greg@kroah.com>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     stable@vger.kernel.org
Subject: Re: 5.4 stable inclusion request
Message-ID: <20200807131821.GC664450@kroah.com>
References: <9740b863-25f0-7adc-7bdc-f95bf8c664f5@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9740b863-25f0-7adc-7bdc-f95bf8c664f5@kernel.dk>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 05, 2020 at 12:34:09PM -0600, Jens Axboe wrote:
> Hi,
> 
> Below is a io_uring patch that I'd like to get into 5.4. There's no
> equiv 5.5 commit, because the resulting changes were a lot more invasive
> there to avoid re-reading important sqe fields. But the reporter has
> also tested this one and verifies it fixes his issue. Can we get this
> queued up for 5.4?
> 
> 
> commit 8cfecb9a5d7b2aff34547652adc5bb00a8da5fac
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Wed Aug 5 12:30:36 2020 -0600
> 
>     io_uring: prevent re-read of sqe->opcode
>     
>     Liu reports that he can trigger a NULL pointer dereference with
>     IORING_OP_SENDMSG, by changing the sqe->opcode after we've validated
>     that the previous opcode didn't need a file and didn't assign one.
>     
>     Ensure we validate and read the opcode only once.
>     
>     Reported-by: Liu Yong <pkfxxxing@gmail.com>
>     Tested-by: Liu Yong <pkfxxxing@gmail.com>
>     Signed-off-by: Jens Axboe <axboe@kernel.dk>

Now queued up, thanks!

greg k-h
