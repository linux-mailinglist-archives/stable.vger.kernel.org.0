Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 303C3FBFF4
	for <lists+stable@lfdr.de>; Thu, 14 Nov 2019 07:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725852AbfKNGA3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Nov 2019 01:00:29 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:42645 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725601AbfKNGA3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Nov 2019 01:00:29 -0500
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 040DE21C48;
        Thu, 14 Nov 2019 01:00:26 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Thu, 14 Nov 2019 01:00:26 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=bOhPEorLgq40odzPkVIz9bWI8cp
        PTksxL6qMb3wQTfg=; b=iSXqf+2k9adoaBSxNewUa4kFiQhUiRT+8wb0rZMiXeE
        ftxUg/sPrUnuiT/rsobHRfehY792q6kq8LRDlgDT6z8P4tqCKxbOy00uCTd8v6W3
        p8a+o+flpBp9lvOTuoyMCfOZOKdqwq3HJsPDtsju/juFZIvdrV2dq7F8adrpfyvX
        i5ujWqnZLslUM8faeVPJ/7Zfx6KA8FLI6p29YqJbLTpAo6qilfa/FWh8mCtQt9Dl
        JcaslXfJ18kWMazoEbgBb01156XuyhUbKEP5zZ6N3K2wGfKcEyn6t/N/afZQ1yYs
        h+JbR2/E42zblbTetBuo+8p80EvrcYdpyefbTqHKsqQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=bOhPEo
        rLgq40odzPkVIz9bWI8cpPTksxL6qMb3wQTfg=; b=holVrRTpHJzCNLluCgEQGr
        /k8Rp3MBjypXbJPW+qWVqNBKiyTYaXgkTtXO/9oqFEFCdiAKRWc8fs9SCK5xE6bD
        HTMFN0rA8nYh7Vj7jk3DY8lOH7H8pnOPPeP+3/8JlXj1DTg0tqmx8mRGovtAPTK4
        LW0Rs8ftCvolUxubPXuTYP0UDJkY730Z8tGoGnzWv2mfnHwXXgN/5IjuXhmaZSi2
        vX+TH+4v1Da0Ldmd9igiajedsnOaGheaX6EQhQUXqS9YB+z9Z+KbkImIUSRG62E5
        44us0pKUw55wwrByOra2YAB+V71HhF6Dwh3a7Crv6eJN8wPjrhfFQN05dqWEZMlQ
        ==
X-ME-Sender: <xms:ee3MXQgO4RsJaxBdQ8rZlxLtK65f_BQrCdHMm8oShxOrDQeiOTvXgQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrudefvddgledvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeduvdegrddvudelrdefud
    drleefnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:ee3MXT4zoV6mEq7vcVWwt5Xaip01IUUmT0r5wOB2xdKa2cCXJid1cw>
    <xmx:ee3MXf5FA4NOiCQjQ_wXelhAQuscfC7OjixcMZXxNvuzFpBvEet9VQ>
    <xmx:ee3MXfcOWfEfc-cC8PEvhctd_zUEdyvnegRu7I0KHsHIX6UhdVUC2A>
    <xmx:ee3MXWCXLMdHFrXwlre3lR6p2C3Q45FFqjNfv33sz0Yo13wOlAyEpQ>
Received: from localhost (unknown [124.219.31.93])
        by mail.messagingengine.com (Postfix) with ESMTPA id 2AC7B3060065;
        Thu, 14 Nov 2019 01:00:24 -0500 (EST)
Date:   Thu, 14 Nov 2019 14:00:14 +0800
From:   Greg KH <greg@kroah.com>
To:     Michael Schmitz <schmitzmic@gmail.com>
Cc:     stable@vger.kernel.org, Finn Thain <fthain@telegraphics.com.au>,
        Sasha Levin <sashal@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: core: Handle drivers which set sg_tablesize to zero
Message-ID: <20191114060014.GB353293@kroah.com>
References: <20191113012739.GN8496@sasha-vm>
 <1573627181-20123-1-git-send-email-schmitzmic@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1573627181-20123-1-git-send-email-schmitzmic@gmail.com>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 13, 2019 at 07:39:41PM +1300, Michael Schmitz wrote:
> commit 9393c8de628c upstream

<snip>

Thanks for this, now queued up.

greg k-h
