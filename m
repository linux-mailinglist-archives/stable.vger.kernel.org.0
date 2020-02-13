Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 61E6415C0CB
	for <lists+stable@lfdr.de>; Thu, 13 Feb 2020 15:58:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgBMO6o (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 13 Feb 2020 09:58:44 -0500
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:38139 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726300AbgBMO6o (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 13 Feb 2020 09:58:44 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 16B1C21ED6;
        Thu, 13 Feb 2020 09:58:43 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 13 Feb 2020 09:58:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=/AkAz94HEHG25Rdi1Yx5fWU5vN0
        A4FCwSbEczmTFpI0=; b=ObPPlVgLAqbJnoQrxztpTye5+coTeE0boM8IsF4m9Z2
        ym0LowQWPnAjehVKcuaq7FscsY9VykpwjRmCxb8LKtsx1I9jKfKRLFL3fsah8JH/
        z3tLpm6TOhP8C4g56IoUQs/akIPuVLL4Ie4n9jRJXuyjClM4lJcve068olNrF0lm
        mu61/UENxrTf2VknejojDSy7X+Bf3URAhQ1OIBxlrAqxvdn4YnwiQ/PQ7BPw0uN8
        6OJnSSXbmfUjAa1HlQFul3hjWIF0vYSbRITApxT0fPK+wyxol8pfZm/OjQvRyrTt
        sSLZDp8tA3uhxswUkeYQys4FZfrYQTFosDKYmCP2kUw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=/AkAz9
        4HEHG25Rdi1Yx5fWU5vN0A4FCwSbEczmTFpI0=; b=kQ5k5/gU8BmVcltvxlg/FL
        LcdSpw5Opip6f3g03uRqFrY4T9/+YPUsys29udnKaemd+S0vdPaW/QaxHgJrCmbU
        GfydFeZEy4d0D0DQ7cn7fo0EBR57a0KH7xrDMGMs0AxJtw80M5PsqsZu6b5cbecR
        TJYdp6Y+jWX/g485Aco+quIYSfkK3SJCHMgw1PeA1OUl6TwCzpBL9hrTIFWQAzNc
        7bWKamrLWQjyoifT5/p537LIyeWKMZprrX9JrDfOri1cEhMFOEgu+Fwjo8ynPddJ
        DFGq9zjebxp6EOU5Yu57E/maj+UKSqPkEUNeg1IvOPRK/AGMD50aQYdENNVLiCyA
        ==
X-ME-Sender: <xms:ImRFXjJ2MpdKlgZk9jAB525J0S_UDP7PIuI_2yGxZLt6X4q5IWfFwg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrieekgdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppedutdegrddufedvrddurddutd
    egnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhr
    vghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:ImRFXjcscMqENigzkBmSrpm_Xomzb5UTtll2st0wlTM0lXvh2x2YdA>
    <xmx:ImRFXudGL33dAFoEyEVv1RA5jaUpZ_pjDBuYC2VdZG5NL0VwGIdXjQ>
    <xmx:ImRFXuNZXE4Oh44PlFcD6gHsQNDg19Yx9u5I8IqhEyCauWBVMmvpqw>
    <xmx:I2RFXtINh9jG1ABmj2yBlL43x3fWsL67gWH0OJwt9Vm47NA8EcZ4WQ>
Received: from localhost (unknown [104.132.1.104])
        by mail.messagingengine.com (Postfix) with ESMTPA id A3E113060BB8;
        Thu, 13 Feb 2020 09:58:42 -0500 (EST)
Date:   Thu, 13 Feb 2020 06:58:41 -0800
From:   Greg KH <greg@kroah.com>
To:     Stefan Bader <stefan.bader@canonical.com>
Cc:     stable@vger.kernel.org, snitzer@redhat.com
Subject: Re: Backports 4.14, 4.9, 4.4: dm: fix potential for
 q->make_request_fn NULL pointer
Message-ID: <20200213145841.GA3409676@kroah.com>
References: <20200213095209.30560-1-stefan.bader@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213095209.30560-1-stefan.bader@canonical.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 13, 2020 at 10:52:06AM +0100, Stefan Bader wrote:
> Following are the backports into the 3 stable trees mentioned. Unfortunately
> context required ajustments for each tree. Mike, I would appreciate if you
> could glance over those to double check. Thanks.

All now queued up, thanks.

greg k-h
