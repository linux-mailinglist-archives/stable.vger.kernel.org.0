Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 106833FE014
	for <lists+stable@lfdr.de>; Wed,  1 Sep 2021 18:38:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245393AbhIAQj2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Sep 2021 12:39:28 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:40829 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232876AbhIAQj2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Sep 2021 12:39:28 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id BCAF95C0244;
        Wed,  1 Sep 2021 12:38:30 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Wed, 01 Sep 2021 12:38:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=aVrxOUeCPVGjI9W0MWh4CPHfFtM
        mCiBmOmbRLtgBONs=; b=i8fWIAMrVQiRfdn01HcqrnI4Ml79L9LYr4XeVtHG0pH
        vmmSOzoixqARScgAqKWW1INmXAkMkZNcXpXlQlCx81e2+mMJ31QsN2ZDgxzpPzdq
        I8pCdXjcDgnE0LxVRcDiCMKc/ttwEgMBflIfT+XVNdqRV2A4RtWUy+GQ4MCXhNV4
        8JrXFc24omBfV5QIPdEBQypjlKOHhJggaq/G2M1sby8YqEpl+xARh7knKS61O1ig
        vaqnf1JErXW2EzLR2WfWpnG0AbHQ2ASQHxkER3QDOxK4J+WWT9eg9/3jamCj8cyn
        fTS1KN5XHwJShbXPjeZuZxyIr5XiTABeSQVVErFJ2Nw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=aVrxOU
        eCPVGjI9W0MWh4CPHfFtMmCiBmOmbRLtgBONs=; b=mTjCx7TXH7F4g+/0Dzdehw
        3WRs0jBbSIsR6rl2w7Y++de6Diz1zTRBl1uClTMr723L/PK0JPcxn5+MAIi1pEFP
        IDZcWZFavjqAT0aQ8wi7MUUrD9U+KNMeVD9ytJn4bHggKvnNxqHZ/vHwU2CDr56G
        V9kxiI2uY/aH2KLTcFPLuzwHdvgMGjafH+7wzx6QfRd1io87xAIVjdEt2wwf2s36
        9aha2w/RSe6V/or0wJbZnTWngMI9mF0vQ1eUk6uzBT+7O4egYb0k/3jw/TSSKd0Y
        diA1kz+YYOeImxYX5HdbbVzhUOHShHxMFOAZ18QWmBRWuumQ+nborzagTuTNEW8g
        ==
X-ME-Sender: <xms:hqwvYUj2kB4wB2NG9TjOoarghBqP97eFYAz0GSWDZpT4nRtEv7XXTg>
    <xme:hqwvYdCoUwNqsoDpqG9W7vJK1zTp37HIZ0QKylO3pgfwgtqhQiXEPOg_zZeqbpRTd
    sF8dZRWygnOVQ>
X-ME-Received: <xmr:hqwvYcEYaovYx7hF-VyPnR8oxgaBExEe3h4kgvxo9GBAhvsSJ3zhqHj0yijrPl5QfY4_HrUhQy8qG4OQFVtGsnl6ZCm1S58N>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddruddvfedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:hqwvYVRcOSPGEWZSt-W-Wq2OBVictnQJTf1GzxlMiz5H3dCh97MH7A>
    <xmx:hqwvYRyME7qJ8RAQORll0V30SKn6iyQRUfLJrRuMozJj4J0-dD1Ppg>
    <xmx:hqwvYT5s6rzxuhMnUWBztJtTse92LHJZk0-CeLHGc1FbgDTAWY00Ng>
    <xmx:hqwvYTv8pV3mR-Pngjw5myHOeKW03TM9ZVzoW4Da_3qDDx6l5k6YsA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 1 Sep 2021 12:38:29 -0400 (EDT)
Date:   Wed, 1 Sep 2021 18:38:27 +0200
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 5.10 0/4] backport fscrypt symlink fixes to 5.10
Message-ID: <YS+sg+meMk0upj7H@kroah.com>
References: <20210901162721.138605-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210901162721.138605-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 01, 2021 at 09:27:17AM -0700, Eric Biggers wrote:
> This series resolves some silent cherry-pick conflicts due to the
> prototype of inode_operations::getattr having changed in v5.12, as well
> as a conflict in the ubifs patch.  Please apply to 5.10-stable.

Thanks, will queue these up after this next round of -rc kernels are
released.

greg k-h
