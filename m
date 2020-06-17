Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69ED01FD1C4
	for <lists+stable@lfdr.de>; Wed, 17 Jun 2020 18:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726329AbgFQQQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jun 2020 12:16:18 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:38051 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726341AbgFQQQR (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Jun 2020 12:16:17 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 380EE5C0151;
        Wed, 17 Jun 2020 12:16:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 17 Jun 2020 12:16:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=UaYnvLSAOyUgSOLm32J0pHtE69N
        N8DT37pJoP1LX07o=; b=AmS3bOLe/0kkgPwZTjfqesyWlEO0vM8oDh23AmfeCTf
        gY/WLjnVFE3CeTYrQTb0SDOqebzvcJaWSKhHiQ08h4v7DdsDpe2AVe9DlVnJGdDJ
        44C5/ms3l+ZhWqbjrDcZYM53aWfRjB/qsKnMnPHm2SEEdzyN+0oQ1x4rntztZ1tf
        ridLKw33jbmfil/RA8yF+TlhMKyuYIWMIpZWXQAvXgJ2k3gdwr0JKZ3y1NVnY6LL
        s6c6Q/R3ygSTkZEC3rH6kBCEECdMdEU38YjPiOLqs3ddhd06leY3zFF8uskGRSHO
        rdVHqPPvV4VYKIC+GM86GJtqKoVmazFkWlghYC5aCrg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=UaYnvL
        SAOyUgSOLm32J0pHtE69NN8DT37pJoP1LX07o=; b=EqqhvNadkDbAtyb+82RFML
        UGQnOvzr0sH6VoOsk+hIdyMHRV1slaTvKs6ME4Szd8CP5Llwgv18k/IouBQTL/6o
        J1NNm43ezG9DzIky+zHG8mxLWHgEacgaSdNQ+IBgEkxCFA2g6l+KT0V0258+q2+U
        uN5UsqyZMBKv6vn4xVszNCiIExFjZz7avVsRgkgKEyE8s/Iuw8s3qE7FNzjObRh6
        tDHeAZJP2xqCZOFAnV+XM2u74/10It0JT30PswG5gHuqmNVwM2Z4V7sA144xkPxJ
        5nYKG22LsimuQIOyd2F46Lv5tXIVFiQ1BPb3a58NdLkX6MrdPUjlKvRRKNIO5KXQ
        ==
X-ME-Sender: <xms:0EHqXsciHCU-TlLQxDs-pSVhVq6cvHegHwQwaRDUZfHj2Q3X-tVxLw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrudejvddgleekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevueehje
    fgfffgiedvudekvdektdelleelgefhleejieeugeegveeuuddukedvteenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:0EHqXuO0o_14dPUKy2xk_Fk4KBJEM4LjFWatd7lNRUGRmcYZ2YMcCg>
    <xmx:0EHqXthO3KUF7ykpnB0P-XgK2qU4ob25SfA-V5BMPSnNzq-0iPaQag>
    <xmx:0EHqXh8Op9FastTWrdt6v2_vQ7NSpcOGiUJGS-E_Eus0HAk7kdDkDg>
    <xmx:0EHqXm5_TW5vZOUUKnmWvSRo2v13l7VLR1YVwCJlJqqWFEr5g772zw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C9CAD3060FE7;
        Wed, 17 Jun 2020 12:16:15 -0400 (EDT)
Date:   Wed, 17 Jun 2020 18:16:06 +0200
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200617161606.GA3788378@kroah.com>
References: <20200615.182706.1005238769928076763.davem@davemloft.net>
 <20200616074356.GA2253721@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200616074356.GA2253721@kroah.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 16, 2020 at 09:43:56AM +0200, Greg KH wrote:
> On Mon, Jun 15, 2020 at 06:27:06PM -0700, David Miller wrote:
> > 
> > Please queue up the following networking bug fixes for v5.6 and
> > v5.7 -stable, respectively.
> 
> All queued up now, thanks!

Note, 5.6 is now end-of-life, so no need for any more stable patches for
that tree, thanks!

greg k-h
