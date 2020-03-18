Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BF6B418A20C
	for <lists+stable@lfdr.de>; Wed, 18 Mar 2020 19:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726623AbgCRSBe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Mar 2020 14:01:34 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:54251 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726596AbgCRSBe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Mar 2020 14:01:34 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id ADAF45E0;
        Wed, 18 Mar 2020 14:01:33 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 18 Mar 2020 14:01:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=OffRk3gZd43FEmaQ6UWi89gbhKu
        +95wm57Zcp+9Yzxc=; b=oOglvicOGVqZEofHf0g5aCZtRj6WVr416sp6kf23TbB
        xxmaOVbqox/r+Qe2UBIs78W2NJwXAOvMF33/sBLyehlAsnnkV+lSb59VpSWloPgR
        +DQmouf4YugEY9yH2K42c7j/53sYy44nAkhnlHe0rX3yGIzMDEhPdI5Hib6PxhNx
        yPRftMVxjro4ZGc/6GLQVbCg5+YbysvYnoUwZ/llwVBIFr32chIKByuQkxisiICI
        UdgX2LlfOKgTTqto4kydaJdQqhdiQalbenY09j84c7XlrwB5Xc8Wr4VBHXpCN83J
        9vJVxhlao/WKaCPlQUKeSh+IsYDJLn0hPdcksUfl3hg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=OffRk3
        gZd43FEmaQ6UWi89gbhKu+95wm57Zcp+9Yzxc=; b=Dz6eDOmDGBJWZVd1bcWTXV
        og9s1ttsPqarC9v+IYptt333oGnDwH7BgvUPuwDyfE+Y7GRrI3eyj0bITBvtYVDn
        5nTAyHT13v6DkiFAFmitykW4WA0yhCX1wD/k9f8574zJkalLs6DlXTQM/fmBArUL
        8iIPLWNsnuulRlUJiehD7DDJ41bFp18upMMuIblGTjts+r/DqTONUbNq+zF9cSy1
        P2t1kAP6Z5vCyOWvL5YbXYIdbr+vdJXEk21iV0/F7FCfaJB8q8/yHwosgjpXU9vq
        bt8Z1/tCNAT1utg6TlQh2WTBi3MUdInyhjHR2Y9bs7gl43Q1VX518HUyL1Q49mYA
        ==
X-ME-Sender: <xms:_GFyXvdY8_KSVb5jTkGVE_BptQbFTKGCuC2tUKVJ_D51_Kec3Soqrg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrudefjedguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:_GFyXhrBNLIFJlOJHu_0kexZ_pqqY6_A2f_zA5e6jJV8kpQeedraVw>
    <xmx:_GFyXkioLjVn-CDlV2ODYFWXlZ_IhYuaq_0jXtAqh248nJYa_V-s5A>
    <xmx:_GFyXiYC9xRXUE5vUIWJssEIDLyamWjK49GUk67b-un9ukEVs45VTg>
    <xmx:_WFyXpmNjb_eoKr-MvE2qc7ksenZyx4GShpLTSPWVp4wDaKUmLeJ7A>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9E06B3280063;
        Wed, 18 Mar 2020 14:01:32 -0400 (EDT)
Date:   Wed, 18 Mar 2020 19:01:30 +0100
From:   Greg KH <greg@kroah.com>
To:     Sven Eckelmann <sven@narfation.org>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.9 0/3] batman-adv: Pending fixes; part 2
Message-ID: <20200318180130.GA3207744@kroah.com>
References: <20200317201540.23496-1-sven@narfation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200317201540.23496-1-sven@narfation.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 17, 2020 at 09:15:37PM +0100, Sven Eckelmann wrote:
> Hi,
> 
> I've already send a couple of missing patches for stable linux-4.9.y. But
> I've noticed that there were some other ones which I skipped but which I now
> saw while checking for missing patches in linux-4.4.y.

All now queued up, thanks!

greg k-h
