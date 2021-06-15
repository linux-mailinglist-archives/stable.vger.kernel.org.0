Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2202C3A8939
	for <lists+stable@lfdr.de>; Tue, 15 Jun 2021 21:07:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231451AbhFOTJE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Jun 2021 15:09:04 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:48045 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229749AbhFOTJD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 15 Jun 2021 15:09:03 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailnew.west.internal (Postfix) with ESMTP id 9D4144A4;
        Tue, 15 Jun 2021 15:06:57 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 15 Jun 2021 15:06:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=cLDd673qlTPNnbBVHeSueP8NcgB
        xfNN53BWwhPepOT4=; b=fTeldxXjTw/8zsV5Pq8tgRXD0siUnoi/zcSdmirNCB2
        TWS5GvFvfhQIvJL4q8DxQCj06G6tSScnjsGrP5yxaZNpkGZGmt2yTZBqsJAdTE6K
        QtWUhpy/jqG0ho3MymjpsU30qIqoTInVx4DCczcKwopLopHJ5NAB48R1ij1duoRb
        7lldwWgTuSBbLlAiYia6e/CnrK+zPM1sX25XjRBfXmd8+yYEhN6WFiVSFo3Bl4TY
        TCjzeomCPE8kklHY8aUYco+kOsEdPtLKxsrRKhu/wkcX2U23T4bdNm3zOMYvm1CZ
        xl6CODnSHAve8q0hxMdD5wbua0DRJGFDfk/5/cLjhDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=cLDd67
        3qlTPNnbBVHeSueP8NcgBxfNN53BWwhPepOT4=; b=LhhZDCH90n4FOWIstm5IXE
        OWJdOXzDfFYVaByP38MNfC1LafowrXs4HPM+KCiDIaR/ZD4j2maMmVw3iJAjNf4S
        Lg4w1Ky6d8Df0NBPkk2thuXF9yx4FLV+uCamoiKYvR+nGh90viOIknQjXJQhDoQ/
        7VQOUy/Wy4hsWoR46f96QA2QJauSlL2o+7nXsuG2oe5hBeBR2WJ+4ZqZW5NbSgDg
        pmyxH2QkiV6j5Xu3FLawy3T4zUhPDCPLbyBYgQI8kX1Wih4xDb5GfEIUIUQBgH7v
        7xpJiLxBPVcdA9vjZoTj3Tr/r6PXL8Ifn4VNPG1n2gIm6ggCFDgaETVx1Up0dn1A
        ==
X-ME-Sender: <xms:UfrIYOaZm0mWOjDdtbmqV28J3sIX3_UArD-78IcwaAOrW5tVvkUKUg>
    <xme:UfrIYBZHg7-7ZQB9iqN7Iuetsw5fVXjPISjLitSVbhn46SLJoxuA5KngzYOKrdlFO
    _YXOvwSQRJTag>
X-ME-Received: <xmr:UfrIYI9gaxDRLW3_0B_e4cu2BhhUuxFwg9fktYh7UnKDN-V1yoRXup9tOew-jpTZq6SFvvd9ZlSAAlVlblKItDlIAv4Qg3f6>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrfedvjedgudeffecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhs
    thgvrhfuihiivgepudenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:UfrIYAoDMMHWxiySpcQLraqHst8mvNjrc4IR6onG1yQ3sWHJfEBhxA>
    <xmx:UfrIYJoLqBlME2TiPVC08_S8ZSJHcEVp4MGx3Zn7zSY0xvErAc5j5Q>
    <xmx:UfrIYOTo16U3tDCeFw3hW17svgzJi2S6BEl8aoaYu6x_i34cEFGXmQ>
    <xmx:UfrIYPbYZR0AERPb3UBd_LdN27YKpbvtTyvCtdMLhqMxiK5xH5AWamRSgs0>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Jun 2021 15:06:56 -0400 (EDT)
Date:   Tue, 15 Jun 2021 21:06:55 +0200
From:   Greg KH <greg@kroah.com>
To:     Siddharth Gupta <sidgup@codeaurora.org>
Cc:     bjorn.andersson@linaro.org, ohad@wizery.com,
        linux-remoteproc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, psodagud@codeaurora.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v4 3/4] remoteproc: core: Fix cdev remove and rproc del
Message-ID: <YMj6T7qeKwQpccPv@kroah.com>
References: <1623783824-13395-1-git-send-email-sidgup@codeaurora.org>
 <1623783824-13395-4-git-send-email-sidgup@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1623783824-13395-4-git-send-email-sidgup@codeaurora.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 15, 2021 at 12:03:43PM -0700, Siddharth Gupta wrote:
> The rproc_char_device_remove() call currently unmaps the cdev
> region instead of simply deleting the cdev that was added as a
> part of the rproc_char_device_add() call. This change fixes that
> behaviour, and also fixes the order in which device_del() and
> cdev_del() need to be called.
> 
> Signed-off-by: Siddharth Gupta <sidgup@codeaurora.org>
> Cc: stable@vger.kernel.org

Is this really needed for stable?  What bug does this solve?  ANd again,
fixes: ?
