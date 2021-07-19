Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECD3A3CD4F6
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 14:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236571AbhGSMBO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 08:01:14 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:51731 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231388AbhGSMBO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 08:01:14 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id A5BA632008FC;
        Mon, 19 Jul 2021 08:41:53 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Mon, 19 Jul 2021 08:41:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=amyQYpBvFYPfdNhUff4Z1cpZooE
        dKlHEQeGTIIX5Fmw=; b=N0sADinJHO7mxz5NYCcQYGZmGNwnEiPTKLLuUIdILLD
        JBrUhL18lDByVN2BCkWbKkX+8Q9M29OwD85hq4jg2aTMpqkaubDOYNi6+m/vZ/tX
        HEvaM+7kZRv4MTkd8BkrvHlRPkRemgOtH3e2M5ItCzxqhN+R9NWCjLHlf2fzVpc8
        i/YiuEq6Z05NVCM6JuIXEnxFLgs25CDT/Jw2iKYChtIMw9ksHk9hFo9d/1ME3rAP
        Z8G6/MlZR3xNN31mt8NXzBgybSJnfcUE0FLJZCL1npHrk7zvYqe7E97feFDqB5kS
        0clXYdATiJnFRqnvf1jLjhxlhp3ldYs1TeIM7fol+FA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=amyQYp
        BvFYPfdNhUff4Z1cpZooEdKlHEQeGTIIX5Fmw=; b=aBnQPma3qxo6s8TxLfsCxW
        yLHRUe9QmaRpsq+Nu2M8XvO9mcm2NPaZfkn4i2+HOuOES/WTPUbKlS395mNEgBa3
        JdXR32xk4bZrfTDsZEp9UervhU/vuDTKZ/B1ZdQKQzKykGaCopgI9i1z4bAgN1rV
        DCZZqWhlLgiheZOTfOV7ut3MUxmDdqQFt/dZNljKArJlsZE3OlpT92bPoCDOkxVT
        7KNlmPQ5uHiGonQPqIIa0vuljxmjPFhlYAc0kHrVDTXpyXhKL+oZ7X0vxrn2Kff7
        +I0qbMEq+/jqAftrCekPUPLCwFjyRfm1g0ONoshtIlzXWeNlz61O/J2SysHVsdKQ
        ==
X-ME-Sender: <xms:EXP1YAAASJu_k5G9of7kmc9kMOzYUdP1AqFUtpAGu0QjXDNQt6XLzA>
    <xme:EXP1YCgcnhUK4p2YHalMI51pdf0b92OOaHdzfOdliiwBZH5qqO_1DV1yLOCmQJjpV
    0B0Oq9KINfbSA>
X-ME-Received: <xmr:EXP1YDlF3t15E_7Lgp_0YMd9GIQOW_Y4IOF8YzGuDbI0u9ftyI38D3CPXcXylVeX0IzeCqVPLRuPaydPmBGZ9B2Sd5h4RqrK>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrfedtgdehgecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtrodttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveehgfejie
    dtffefhfdvgeelieegjeegieffkeeiffejfeelhfeigeethfdujeeunecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:EXP1YGwbRK3xXqCffXi7b-nzI1QSg6gWLrHXJ_WtfddNcSvfuiWx5Q>
    <xmx:EXP1YFR5diLVz0T-lP6IFRFkfZD5JvlTMxjcG3I86wkf4CAThYvICg>
    <xmx:EXP1YBa9yU9gI50sWedJivgwRZ58bMM8A1gUDXeNPAUgSZr4WK_szg>
    <xmx:EXP1YDP_Q4T_e-M5nersHSv5rJG9fRq9FOW19frEYGWgfyn06R2Nfg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Jul 2021 08:41:52 -0400 (EDT)
Date:   Mon, 19 Jul 2021 14:41:45 +0200
From:   Greg KH <greg@kroah.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     stable@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 4.9] fscrypt: don't ignore minor_hash when hash is 0
Message-ID: <YPVzCTmfqbtjqMHh@kroah.com>
References: <20210717000557.60029-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210717000557.60029-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 16, 2021 at 07:05:57PM -0500, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> commit 77f30bfcfcf484da7208affd6a9e63406420bf91 upstream.
> [Please apply to 4.9-stable.]

Now queued up, thanks!

greg k-h
