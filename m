Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1437C186CDA
	for <lists+stable@lfdr.de>; Mon, 16 Mar 2020 15:12:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731128AbgCPOM3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Mar 2020 10:12:29 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:51409 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729856AbgCPOM3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Mar 2020 10:12:29 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 4E06247F;
        Mon, 16 Mar 2020 10:12:28 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 16 Mar 2020 10:12:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm3; bh=I
        3D18uyrlVANyw6/aP+YROCzgKUMQsjlpQlMNjGL284=; b=fFiKkQfi+a0MwVsgY
        sVy2vBC+kwDelUncVz3KTyIzVaEwu4Z0vWZFbwZ/bNpvyFwKWdZDhBl3Sy6Q5Iu/
        Agu3j1fc0rEziE1BrRtCBHFxF+y9XzFkcsf7BXQNKbznek6HmaKXS9agw1Vaag0H
        L0O5sFFrQSHwxg+y5qOc8P7VbTuyMQIuE5XeKv149YS8NIe+XnzMeGKGpsSIw6v0
        kyqiKITO8dxOfMP7jNXIgpxZfxRMbA56NP3rvGmGHxRWQNkCZNmxL3T4gu4A6e+q
        5RpuHXs8zpWuuzEOiTW+7ME3urrwEhNOEwiPE1jw+tkCGIr7zXm7BhQ4DFwhEFeJ
        0a+pQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; bh=I3D18uyrlVANyw6/aP+YROCzgKUMQsjlpQlMNjGL2
        84=; b=sYlvpiOPexesBjuCAee7oIKg1qciJa6khn+abnuSshPmt/Npc9pcBXKjE
        G2SseoKAaSLRHkGUDArQSz1dwPv4m894vwOEJ7jj77PPKNaUILBQpKCgTqxYmCT3
        CSjA4UU/Dg7/pWjdlgy1L22ejXi9Msyt5Kseokjy6u7CDKPs3og3wISxgAt/AkLS
        YEZRL4W+nbwLm0r0naZbvUBVoS/60OUFBATgBMiB+gDDjNoHnELKoMQ19nXc6ySl
        pDNRIf62CnhyGGXeZ+uaSYWqsMaGnE3OrVt/rzT2eAZ2WY+gfs5RxEq00w7YmzUD
        HgxZPKgSMo3VWvvf3dC6HVrPCmD9g==
X-ME-Sender: <xms:S4lvXqywtpeee2HfuGsF6UeP8-J4tDR4lVAtiG59O_vBZsRL_0K03g>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudeffedgieduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtjeenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:S4lvXo9KMGmOSHBSs4oxdh3_mr7PM-Rixy57dWk3_KWqqXJ7uu516w>
    <xmx:S4lvXoIchB29MDn7V-APt4u8AW3dacRmQXxwi0TN_DZOCMqFSIJLSA>
    <xmx:S4lvXm_7e5i0IeegOuSXISgIxiMU_VU-PZSJdVhNUBD2u8V93NsYPA>
    <xmx:S4lvXqMyx635r0eMOcDW9T5xkp755IuUC0OpCnFqH8EhxniZtN8omg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 346893062499;
        Mon, 16 Mar 2020 10:12:27 -0400 (EDT)
Date:   Mon, 16 Mar 2020 15:12:25 +0100
From:   Greg KH <greg@kroah.com>
To:     Matthias Maennich <maennich@google.com>
Cc:     stable@vger.kernel.org, kernel-team@android.com,
        qize wang <wangqize888888888@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [PATCH 4.9] mwifiex: Fix heap overflow in
 mmwifiex_process_tdls_action_frame()
Message-ID: <20200316141225.GA4048369@kroah.com>
References: <20200316140851.7622-1-maennich@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200316140851.7622-1-maennich@google.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 16, 2020 at 03:08:51PM +0100, Matthias Maennich wrote:
> From: qize wang <wangqize888888888@gmail.com>
> 
> mwifiex_process_tdls_action_frame() without checking
> the incoming tdls infomation element's vality before use it,
> this may cause multi heap buffer overflows.
> 
> Fix them by putting vality check before use it.
> 
> IE is TLV struct, but ht_cap and  ht_oper aren’t TLV struct.
> the origin marvell driver code is wrong:
> 
> memcpy(&sta_ptr->tdls_cap.ht_oper, pos,....
> memcpy((u8 *)&sta_ptr->tdls_cap.ht_capb, pos,...
> 
> Fix the bug by changing pos(the address of IE) to
> pos+2 ( the address of IE value ).
> 
> Signed-off-by: qize wang <wangqize888888888@gmail.com>
> Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
> (cherry picked from commit 1e58252e334dc3f3756f424a157d1b7484464c40)
> Signed-off-by: Matthias Maennich <maennich@google.com>
> ---
>  drivers/net/wireless/marvell/mwifiex/tdls.c | 70 +++++++++++++++++++--
>  1 file changed, 64 insertions(+), 6 deletions(-)

Now queued up, thanks.

greg k-h
