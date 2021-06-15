Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE2923A8935
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 21:06:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231481AbhFOTIl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 15:08:41 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:43793 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229749AbhFOTIk (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 15:08:40 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.west.internal (Postfix) with ESMTP id 97CD216D6;
        Tue, 15 Jun 2021 15:06:34 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 15 Jun 2021 15:06:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=/2BblplUVZDT58n4HQMdwC2devr
        kLIjTioetJuumzdM=; b=gvA+vmNTW6SQ/yRcCeCc8RnklKzplFOAIG8fNSzh9L+
        8XtSYhIxME9ZU1GuXL/KHiSeVQPIOGSQ0ed0sBOlOsZSwOl9uVyPHZ+lD/EX/nZ+
        ooio3NmE0fOAXIliC8eBH69p8USXauj3RKx0faQqosQ6/ajh5gWC+KE2qfcKvVHb
        /i4oYHcBu/is6SbpcEEILMzp/fDrH9q8uFdsGsBHCkAl8LE9TLfchjH1PeEpy0Q/
        wR+WpuJCovcZKV8LrVNe4plvaXmxpGqdgIouRDwtEN4W6/7sPvLJYO6LFa9WnxZD
        sO0Wus8l10f/V5JlI+HMFZPQOaAoGKwWRvUq0V1LR0g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/2Bblp
        lUVZDT58n4HQMdwC2devrkLIjTioetJuumzdM=; b=nIWXQWhS4GKFXNzjNSdEBA
        RFicbQJhGGgswI/uVrquDNEWqbEwzQPmVmcJpaa8MtPa8K8zgWDRm53KcP31D0xl
        uJ0jLzHtsUqLXdr36C7189126kHKtEsbLkz8EPaDu040brcWDIROmh0mJg2agXPH
        mks9/jhHyV+n7WCZUyqvJC15jRL8npdobd8ZMag1mvlMAz3PAh4K3DLSoI8vMeQj
        O/MrTPeI5xZwZkfpUSsjO7gPt8z8D3wX9WAY6x5476FmxF59yFYEYhv3xSqGoHXv
        zvv/2nY6KGLj6vPUuf9j33oTzn9eDKiDaK9DEzq/kPUjZffuqVYBHbDQN8HDKanw
        ==
X-ME-Sender: <xms:OfrIYP2n_g5Yb5aI4_2SRbi5HqMc99pAHj7c2g5t7vDXhyK6bwiYXg>
    <xme:OfrIYOHwjLguz1mwKlAKofDCBeaPzagnCCjRRHoCldM2rA4kWxgkbRuUCVX48YNrj
    jQOOlwQFUf4hA>
X-ME-Received: <xmr:OfrIYP4NOVmzXLdsTqucuegfDTaBTX5CraIiRnzeIAwssRvwXPMswF2U-yqvVtKI4-Im3rE5OEfU366niZEqiNx_1wN6zMSR>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvjedgudefgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:OfrIYE2V6K65Slf0rcrUYye3zO7IYN-NXJNnwZ9bkYjKIw9n1o07ZA>
    <xmx:OfrIYCGEahT0QWUCjw42DHW_TR75p-8rKlWOAmrf4gHfJYipfWjABA>
    <xmx:OfrIYF-EYlE70mntHNE8J0SKjki_nKUv-4HwbIyHeJKJ5MilgGGesA>
    <xmx:OvrIYAXXo9JPd7PK6VQ7qTs4FWOljLBLF447V6RX6jsw60PRNGFoqE4cFe0>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Jun 2021 15:06:33 -0400 (EDT)
Date:   Tue, 15 Jun 2021 21:06:31 +0200
From:   Greg KH <greg@kroah.com>
To:     Siddharth Gupta <sidgup@codeaurora.org>
Cc:     bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 4/4] remoteproc: core: Cleanup device in case of
 failure
Message-ID: <YMj6N46ElCq/ndJJ@kroah.com>
References: <1623783824-13395-1-git-send-email-sidgup@codeaurora.org>
 <1623783824-13395-5-git-send-email-sidgup@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623783824-13395-5-git-send-email-sidgup@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 12:03:44PM -0700, Siddharth Gupta wrote:
> When a failure occurs in rproc_add() it returns an error, but does
> not cleanup after itself. This change adds the failure path in such
> cases.
> 
> Signed-off-by: Siddharth Gupta <sidgup@codeaurora.org>
> Cc: stable@vger.kernel.org
> ---
>  drivers/remoteproc/remoteproc_core.c | 15 ++++++++++++---
>  1 file changed, 12 insertions(+), 3 deletions(-)

Why is this needed for stable kernels?  And again, a Fixes: tag?
