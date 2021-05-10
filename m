Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 081DD377D77
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 09:51:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230029AbhEJHwn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 03:52:43 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:55327 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229852AbhEJHwm (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 10 May 2021 03:52:42 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 319CE580540;
        Mon, 10 May 2021 03:51:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 10 May 2021 03:51:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=VhyYWbCVZyj/osg0fZMdoO7lUYZ
        e5GOeCyPmVV4G8yQ=; b=F3eUyFg+RLnCewmpqmDKVAiXW7zhSix3oLkv36cXIXE
        ejI+AKIQZ3VFLY/9Og3csNeCjt8ah9a5fPjqNNUAhSlny70jXnL1B/0ZoACxkF1d
        xtQrw6+cSlYJUAb8eltQacXMGgdOQA1WTF2CvKcJJ7aG3GDLRoDHCvpr3krOmRCS
        ezXPg3h+jBPzczlfpw+AjWU3RuX1tHju/qAtzOSBqLwPS1jcagO1xJ22pSLqH337
        yEV2cZkt32Rod+H+D31lwLrROPiqL88pH+4PnnUJzMntcqKsKMGmrsfh8KztBAY1
        MD+FQTrTu4y/QRwIpm5PUo7mAxPihQH9zchCnrb9svg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=VhyYWb
        CVZyj/osg0fZMdoO7lUYZe5GOeCyPmVV4G8yQ=; b=FhDCo3hpsD8zCARdLXfT7Q
        SDgtc8NotOIINywl+unSapkdhV/2+OKpCrI3VsLyUPm+HGXQcqXl5irHgqKBK+Df
        vxoNHn5kJWbVHdx/W26Yx1IV80ESsJavb2e+Ll2F5M08LgjZUZCDBvAKWKsJAR5L
        0Hh9Ss4zP+rHD2gKmJyYAHkcY1XvB951Lbb4TE0QJA4sxaVmdyOamYECWD0UkRDY
        JlKn8WAclwAlKGGn/qDxgvYVJo+yBG8ffeQ3UeC8l26f78mSdK0KX470NPWeHBca
        frNHfdu+9vheCT3wDKxZtXOkocUsK/pZl5BdtZxiWxQLDHBHKzpBOmvJUIjjPbkw
        ==
X-ME-Sender: <xms:CeaYYDztxRJdGtE9axHbVmeYeXcpCp-mKIEdK_pm4RF6n2vpEu0-5g>
    <xme:CeaYYLQGsNSKBUkvnJq0zbK55Q7INTsRLYxy23zLS_oX2TV4qeelmV31RgsnIUuY6
    CnTlPOaESVqGQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdegjedguddvudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:CeaYYNXqSPJ0P9w6Y5uG3im7FZnFBt7bBfDExDoh04b8t0gSoSGL1g>
    <xmx:CeaYYNjGRiNz_7Wz4GI94rWlC9ocfyZHv7DKlZSskFEWvMuFqMLQ2Q>
    <xmx:CeaYYFB-LHex43ULTE6P7D_1n0VnCYH9wLXzAnn18g_40IQah6XpBw>
    <xmx:CuaYYKIzrLJM8D51CPVKxSpUfE9XdNA88STYjhEarXBfOGPK4XyN3A>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon, 10 May 2021 03:51:36 -0400 (EDT)
Date:   Mon, 10 May 2021 09:51:34 +0200
From:   Greg KH <greg@kroah.com>
To:     Pavel Machek <pavel@denx.de>
Cc:     stable@vger.kernel.org, mark.d.gray@redhat.com, wens@csie.org,
        Qiuyu Xiao <qiuyu.xiao.qyx@gmail.com>,
        Greg Rose <gvrose8192@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 4.4] geneve: add transport ports in route lookup for
 geneve
Message-ID: <YJjmBsne+uVBQQBU@kroah.com>
References: <20210509082755.GB25504@amd>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210509082755.GB25504@amd>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, May 09, 2021 at 10:27:55AM +0200, Pavel Machek wrote:
> From: Mark Gray <mark.d.gray@redhat.com>
> 
> [ Upstream commit 34beb21594519ce64a55a498c2fe7d567bc1ca20 ]

This is already in the 4.4.244 release, why do you want it in here
again?


