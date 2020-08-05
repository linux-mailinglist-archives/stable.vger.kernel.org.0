Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1A323D2D7
	for <lists+stable@lfdr.de>; Wed,  5 Aug 2020 22:16:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725946AbgHEUQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Aug 2020 16:16:43 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:41611 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725985AbgHEQS4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Aug 2020 12:18:56 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 2B1675C0113;
        Wed,  5 Aug 2020 10:29:32 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 05 Aug 2020 10:29:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=WMH703/icl+g+SDICao7QykLwpJ
        Pkv9C/m00aprnqTU=; b=qCAPACnqHleCkcqeQUN/NDzABpKK1PLK/ErTMdVz2l1
        NKJWt6Hbgvz33ckRbbE1GfsrxlXCjUUV+ehDFZdWxAAqg87OBZTjUmf3j5PMtR0G
        bzaioVR36j5CVGvsPZYrvc/MRLgdA+wOpevkFrM9yDmeuPoh1nibXC9Sj+2tByxo
        uH5aS6rhFcZMUYY/j4G3tHmI+bjkdmKtgoFGi22HAUnyPZrKmIg5bVSirKcoWR6g
        e54WJdM+A03CW0ODcrW0BAgzmpsd3zDddFLKT/1MjkMLlvr+hWBzdAf6GHUgL4oi
        NTK24lTaL6LE/v1SpV/al7iaW5DCQXFdXCRGeKYEHIQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=WMH703
        /icl+g+SDICao7QykLwpJPkv9C/m00aprnqTU=; b=Wv4ZOY50oBBsV8leAreoOK
        tBylc08xH9Wb6L7/hMoseXOwlTpFMTZkqiY+nCsBHK6Fq9CqWxGZh4cmKNkmx/dU
        0LFXe0OOXXZI9Ez07tH1ZhsVoS21cvkqafm/uLzltammTjWJJX+LpVX+az1z6xlK
        SluZk5FXlg359pxQtaW5jSEh8t+RRKFh7NuG+3wCL4AyjSk/EGTjL4BdLZiAMIcV
        /mNQeQPNYH3Fn09MqGEXmcQwDnv1BEUq3LYSINcjBeSIAzKwF+g/ktcESXWudC+l
        HjKDqBRDBRLznz87sLPuNc+dynjcp6384GQzOo3MrQVl9eY4OOl2R9KDr5uXJDEg
        ==
X-ME-Sender: <xms:SsIqX2xt0SrGQeWyzDllMc4bSSnnXEbrNWaYdqGiEIjTSZgZsrr2iA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrjeekgdejlecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeekfedr
    keeirdekledruddtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:SsIqXyS7ADPEgx8__DHOmato8PdvLpf8oK7Ha1gONgLWPoIZcNjnIQ>
    <xmx:SsIqX4VeAhTzF2f2DPEyrMBbQ-CnHu9YQQeQcZf9JRO_202Tu3COBQ>
    <xmx:SsIqX8gobWMYBwz5DqSX8W4vVRr6C-mhfMZSy--QKQvBmq3SPdvw5A>
    <xmx:TMIqX36_Xl46lmudaQYvGdBLdk2adWvWyx9b327RLX_ui82D84-4Kg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 471B0306005F;
        Wed,  5 Aug 2020 10:29:30 -0400 (EDT)
Date:   Wed, 5 Aug 2020 16:29:46 +0200
From:   Greg KH <greg@kroah.com>
To:     Jan Kara <jack@suse.cz>
Cc:     stable@vger.kernel.org, tytso@mit.edu, adilger.kernel@dilger.ca,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        wanglong19@meituan.com, heguanjun@meituan.com,
        Jiang Ying <jiangying8582@126.com>
Subject: Re: [PATCH v4] ext4: fix direct I/O read error
Message-ID: <20200805142946.GA2154236@kroah.com>
References: <1596614241-178185-1-git-send-email-jiangying8582@126.com>
 <20200805085107.GC4117@quack2.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200805085107.GC4117@quack2.suse.cz>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Aug 05, 2020 at 10:51:07AM +0200, Jan Kara wrote:
> Note to stable tree maintainers (summary from the rather long changelog):
> This is a non-upstream patch. It will not go upstream because the problem
> there has been fixed by converting ext4 to use iomap infrastructure.
> However that change is out of scope for stable kernels and this is a
> minimal fix for the problem that has hit real-world applications so I think
> it would be worth it to include the fix in stable trees. Thanks.

Thanks for the note, I wouldn't have noticed it otherwise :)

greg k-h
