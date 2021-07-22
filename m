Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E973D2536
	for <lists+stable@lfdr.de>; Thu, 22 Jul 2021 16:07:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232263AbhGVN03 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Jul 2021 09:26:29 -0400
Received: from wnew3-smtp.messagingengine.com ([64.147.123.17]:51027 "EHLO
        wnew3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232166AbhGVN03 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Jul 2021 09:26:29 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 414BF2B011FE;
        Thu, 22 Jul 2021 10:07:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Thu, 22 Jul 2021 10:07:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=prWACrJFXo8y1jrEMMR+3UsGDvF
        jhhPhic6EAg8Shu8=; b=Aovg0XThHHqMgm5dfHwW8LWv/TBQCp732ZkT7NbUDqM
        vZFy5tM/TQ6gAkqK9TjecDrsFtA+qg5bdsvCO5esupgoJpMlC8UQMJEf4+D709jU
        BC64Z/qwUmOmMQ9HmAA/sEkqT+v0hlkkM4wemYGNGsXskLd0HNps3QpxE3331OS6
        Dayh0YpFWywsIa2BBtR5USXj/W5QzgxBwiV22OsZIExoVg0OrMPgHRgo/oBmOcIr
        92LdmWpQE7RhXcGGHybreEKMyh2Tqm51BVD9ws4YI1sNhCqlQd+9tD4Ly3MBJdn/
        OMah87GFIavl3JI2cwN1m9MVhlUL6xQUFQQPbXFhWjg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=prWACr
        JFXo8y1jrEMMR+3UsGDvFjhhPhic6EAg8Shu8=; b=IXn7WMQOI/JBPvPwCdFYdY
        OEmfUIWXOngyh/3b2yMQNNWkJgqsTupy3T01T82FclshPj66S2WqX9A3MmGj9arP
        FkO0xZZBFDMoWWU7kMal7B/QbWVcsN8Q26PUd0VbhTk5TJSs+K/FBSgkj0Z2WEnP
        NqhvDD+Km/cy0HorPsDa4lx1EalPJwtnNYelbqqjjG1jN9ea+sxYghnv+TPCLG8N
        kS9Em7A+SjE9sQv0pxr8oFCjRjyMcAJAicQ9CZwzS1k5qnaPc39hisZbAQDCPU64
        UVJwNswtau/srA+JW6YK0bpAbfs9OOpjotcRSmrj9NEz7KHt24u/TPRONxtmCESA
        ==
X-ME-Sender: <xms:hXv5YPr8ejODVQfwyTP1Q0ZvV-msDwaAMvtQzOiUHETQREI_gGgCMQ>
    <xme:hXv5YJpuFLUiZactFUJeoPEb8XUUmxtqmHRVdZRrIG7pDv4GeXaoXBTUqQ4aL-6DN
    PM3HpjNFavTdA>
X-ME-Received: <xmr:hXv5YMPLae4ylaJK7pHe7LtGHTzMkTxNDOXzSwwgoXJyYSWbWFcCDrdwOSoBy2dD8zr9d-OYrq-w_IFKmZQzgWVuVurZsJ6x>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfeeigdeilecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:hXv5YC5gxMai7SJx2LLToP0et-M-MNfz5bsMd2Qi5qc2KGt_ohbThA>
    <xmx:hXv5YO4LstqeDol9Z3otPxNxuBznrHzf4tAYhcsjZrUdRvhmyFZB-Q>
    <xmx:hXv5YKiE1fi-Rj3AMB91OFr5c5nyiBg6bfhQs5TJrzFb9T2gckUKvg>
    <xmx:hnv5YLx1iyMOtKHIErRZzh5topAIJWMtT0rLyOCJYJx6td_buemKpriqX9o>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 22 Jul 2021 10:07:01 -0400 (EDT)
Date:   Thu, 22 Jul 2021 16:06:59 +0200
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Daniel Rosenberg <drosen@google.com>,
        Chao Yu <yuchao0@huawei.com>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH 5.4] f2fs: Show casefolding support only when supported
Message-ID: <YPl7g2Gpec2Lh3a6@kroah.com>
References: <20210720161709.1919109-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210720161709.1919109-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 20, 2021 at 09:17:09AM -0700, Eric Biggers wrote:
> From: Daniel Rosenberg <drosen@google.com>
> 
> commit 39307f8ee3539478c28e71b4909b5b028cce14b1 upstream.
> [Please apply to 5.4-stable.]
> 
> The casefolding feature is only supported when CONFIG_UNICODE is set.
> This modifies the feature list f2fs presents under sysfs accordingly.
> 
> Fixes: 5aba54302a46 ("f2fs: include charset encoding information in the superblock")
> Cc: stable@vger.kernel.org # v5.4+
> Signed-off-by: Daniel Rosenberg <drosen@google.com>
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> Reviewed-by: Chao Yu <yuchao0@huawei.com>
> Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/f2fs/sysfs.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 

Now queued up, thanks.

greg k-h
