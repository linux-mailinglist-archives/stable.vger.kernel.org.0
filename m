Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD5414DD49
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 15:51:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbgA3OvJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 09:51:09 -0500
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:54045 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727261AbgA3OvJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 09:51:09 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id EA962216A6;
        Thu, 30 Jan 2020 09:43:36 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 30 Jan 2020 09:43:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=eHyJA2pIADfuosyfCE4c/465jIa
        MgMgWcthLJpbO4pc=; b=kDhu4Q1wEwCGOHhMwsbk0z4k+l+SK5ziFYSUEZ54xKI
        ZtZ+F9MAVao+FE3wAu4eaXdQ/sqfS/Jgd22uLdzmipTgKDeS6ctg61r664zyBSmd
        MzsJLMip6/5WCwLuxd649EPdqFkqArDHJz+9nf+NKXPWWi8L38cHpIeNCuXmWqgA
        5Du9OGZ59o9uj0YtT7MuEDXYjd7IIEcpOxwgZPJZFlbomfg1WGQ94NJZbc8JQ5mb
        1HaPFWboYL7xfStWNTw5G2pYTI5SlnNEuoFsHMK3ATXwzv6dMv9rSmE4RwQ3g4qv
        DaKnwX5TVftbdLGQeVAkIk3L1jtQFr5PLi1HbIJ6PSQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=eHyJA2
        pIADfuosyfCE4c/465jIaMgMgWcthLJpbO4pc=; b=wdiHRosh4srqQb0KsP9s52
        ZZ02EKcVFOSiLE5wTjmI95FVo7UFbvVmSdQP+Kks1SsUVc3bMYCn5HZWA9RYjinN
        Hkk1tyLFMkq30AJMSpsYon21WA3+bqE1vKpv9TaVcHiPAuAAPHAOh7ZTGo0sEfSa
        dkSFZ4vK1l74VAYARP6h1UHI0ABsZ/qxaoRrGrn4QO+XlMlD5xMwVmPagcei8faj
        kRP+x9BtJKVfoNX8Jnh5TzYmeK0XOEK7xAdGOdre3mQGbj4CnttAcNX5o2XMDBoj
        rx8U/e4i1weUE4UegZvVKJHro0Mi8GXdHciRgy7hX4MbFUxBp77Vb4hokgEAgyZg
        ==
X-ME-Sender: <xms:mOsyXkL6RnSgyFk3Xmnv8bAKWZddOgS5bAfF-rzaw5bq1PeAYYRmRA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfeekgdeijecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekgedrvdeguddrudelkedrud
    ekudenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehg
    rhgvgheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:mOsyXnFi0FNFHTkLucV2-caCbWqI853GqJ_URdVKFtDQEUhXRfSsHw>
    <xmx:mOsyXrehdhmSdnQUFnR5l2KLCqZXzoSEoaFeh5S7emC-Hv2Eq9GGeA>
    <xmx:mOsyXrjBWyPc6loppwULu1gYk7fCOX4jcSq8SxpO-5I6nTZDIJHIbg>
    <xmx:mOsyXsB5ml8fMnZF1zM34JK0lbvLj-saS4CyarIOuec2Ysv4NAqdmQ>
Received: from localhost (unknown [84.241.198.181])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1D11A3060840;
        Thu, 30 Jan 2020 09:43:35 -0500 (EST)
Date:   Thu, 30 Jan 2020 15:34:17 +0100
From:   Greg KH <greg@kroah.com>
To:     "Huttunen, Janne (Nokia - FI/Espoo)" <janne.huttunen@nokia.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "peterz@infradead.org" <peterz@infradead.org>,
        "vincent.guittot@linaro.org" <vincent.guittot@linaro.org>
Subject: Re: Please apply f6783319737f ('sched/fair: Fix insertion in
 rq->leaf_cfs_rq_list') to 4.19.y
Message-ID: <20200130143417.GB963927@kroah.com>
References: <d43f6fb40c371f4944a67f416da18248f4705a9e.camel@nokia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d43f6fb40c371f4944a67f416da18248f4705a9e.camel@nokia.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 30, 2020 at 01:39:34PM +0000, Huttunen, Janne (Nokia - FI/Espoo) wrote:
> 
> The f6783319737f appears to fix a reproducible crash that we have
> been experiencing while stress-testing creation and deletion of
> containers.
> 
> The fix seems to apply to 4.19.y more easily if you first apply
> also 5d299eabea5a ('sched/fair: Add tmp_alone_branch assertion').
> 
> 

Now queued up, thanks.

greg k-h
