Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBA3E3735E1
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 09:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231300AbhEEH4M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 03:56:12 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:56903 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229741AbhEEH4M (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 May 2021 03:56:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id A2DDE177D;
        Wed,  5 May 2021 03:55:15 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 05 May 2021 03:55:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=T6l1811bPixoEfPRmGE/mAV3M4s
        mRpxxFKmb6HeVRps=; b=GGxtExQw+Bt1MwZtovDteBA8CTtGcd2Th4F/slzc1Eg
        Kq5yKIQe4ReXTm+sUxlLZwb+vTSsM7VF+nr5C47BtbSYnqTADORWaRflQzncthjF
        YYNQ0P9tKLSmC3F9F+C09bSVntBWzRs0euQDn6GSKv12UgvLAL28JTvwIkq+Xp08
        3TN9pJyHPzHDPFET/z+pCGCGGrHoVwnnF9JTsmaOY0WIduyMNL44MBvELBMvoPD5
        /bRbgqEaVFfPmTAFjQyC7G/K2mtHRqQ/tNZKHPDCfshWajlzu2ZOlj0H14JGCa7P
        MIVX9cg/+PLjNSrEEdggc+OFNnrrkJv0lLRRAy2ly/Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=T6l181
        1bPixoEfPRmGE/mAV3M4smRpxxFKmb6HeVRps=; b=Pmb0iuLrh2Fo8TzGpCnjXm
        JH2/R1k3rYYVcDkFF74cGN5r2c2x5ywUyI4FxbM2ovbfIEl4YOJFgfNp2/9jpaVw
        19KQWwgaVYc8gZH6Fs2Ibpz7ANaM1cbA7W49xPNMT1D6O3gDS2xi/Pz6i7GA3FKA
        5rr+IwgsXyiZcQkRoQ3hcUwVNNk8L3kz0Zjyd/+7mX/mWTvU7PSRiPS3DWYf+MEK
        puL7vEGqlG50uPvcrzu1O1Q7tTSA0ZAuruFJXMx8S/rdLVbPDJMIFyE7IJ09vXMX
        0hGPJNRK/izFE/fBw1/Epg/AFXlbIqEB3Qt4pnrpdevnryJpC9KRGvB4UESEv+Pw
        ==
X-ME-Sender: <xms:Yk-SYPboC4rcJn9Oe6tRTXPrFpsAQnHOILwW_sVO1MyFtx6Tmi6aKg>
    <xme:Yk-SYOZQHdnlImQQ86tWh6xN4phxZwFdWM3eVExdClX7ZGRAXabn9tal2jqGxbLC_
    oRorfSAKUlf4Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefjedguddvtdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:Yk-SYB9ukseKqqGgQkOKx1KF-elXiATBus6knWrHI8D6vvKRWpUgig>
    <xmx:Yk-SYFopwDNfkh5_Hc79ks1UF9W6rKWx4ffAcxVFhgJV8LMi1scwgg>
    <xmx:Yk-SYKo7NBW_E1XWhtaXDKkdundMrMfGBNGnziMr-mCSPS17Ox1bUQ>
    <xmx:Y0-SYKLgtDW65rGzymuJHpg_VNgdjQfGTv3bxZMNdnFI-kerCGmV7Q>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed,  5 May 2021 03:55:14 -0400 (EDT)
Date:   Wed, 5 May 2021 09:55:12 +0200
From:   Greg KH <greg@kroah.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     stable@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sasha Levin <sashal@kernel.org>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: need to back port ("scsi: ufs: Unlock on a couple error paths")
Message-ID: <YJJPYNE1azQ49ocv@kroah.com>
References: <20210504184635.GT21598@kadam>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210504184635.GT21598@kadam>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 04, 2021 at 09:46:35PM +0300, Dan Carpenter wrote:
> Hi,
> 
> I ran Smatch on 5.4.116 and I found that we were missing commit
> bb14dd1564c9 ("scsi: ufs: Unlock on a couple error paths").
> 
> The problem was caused because somehow my Fixes tag did not match the
> upstream commit that stable used.  I have both hashes in my git tree and
> the patches are identical except for the hash.  I don't know git well
> enough to say what went wrong.  I don't think the SCSI tree rebases?
> 
> My fixes tag:
> Fixes: a276c19e3e98 ("scsi: ufs: Avoid busy-waiting by eliminating tag conflicts")
>        ^^^^^^^^^^^^
> 
> Stable hash:
> commit a8d2d45c70c7391386baf7863674f156da56a3d5
> Author: Bart Van Assche <bvanassche@acm.org>
> Date:   Mon Dec 9 10:13:08 2019 -0800
> 
>     scsi: ufs: Avoid busy-waiting by eliminating tag conflicts
> 
>     [ Upstream commit 7252a3603015f1fd04363956f4b72a537c9f9c42 ]
>                       ^^^^^^^^^^^^
> regards,
> dan carpenter

Thanks for catching this, now queued up.

greg k-h
