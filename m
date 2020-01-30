Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 224B614D8DA
	for <lists+stable@lfdr.de>; Thu, 30 Jan 2020 11:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726873AbgA3KWX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jan 2020 05:22:23 -0500
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:50909 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726882AbgA3KWX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Jan 2020 05:22:23 -0500
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id 83552497;
        Thu, 30 Jan 2020 05:22:22 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Thu, 30 Jan 2020 05:22:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=v0E0ANRQhG+XzB/YAGEJaoXT895
        N4rbRDG0rTk0gBFI=; b=MNYjPhpH5o3jaYhguKpnETwDCI875MGMettye+WWsl5
        EUGxFH/Vpr20HWSf9Og6j3BC7ksiXzzmHrllKaV7ErK968Zfyz++WLeYU52sG2lR
        68WVn8OcbkRreJINtwS0a8bIqmVxRBF7UJ7SS9UzMM1GODVy/xBDg7TRXgMoHfe6
        Iq2Edpp3gE9HABSumlw4IwIRXIOFDkdVGbl5vSU+vYPMLyweaTC7tG4lzXaN4S8B
        isFiReqpx3TspzO5Cpia0SgCWwwgIjB5k6KstGgPTWeph0KdsDd6njqTFlRc4W2g
        BY8KFRMtPKIFvG9kdbd1NKPsvnCmWPRuN5p7Rslyt5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=v0E0AN
        RQhG+XzB/YAGEJaoXT895N4rbRDG0rTk0gBFI=; b=V7WQ/v3TwAWXiZ5bb2IpVN
        iJBKH9lIlQ357hKgYe+Jq3wQq/KVAcpbFb2PNlTyRWyIHR7lLfwLiumtW5ET178l
        UWaMhXkUWfTplNa6PsAX9UAm/Iat2jj9Es1OWYXxGkYonDgvlSII2PGPugdTCvC8
        EmvQmoKSghIL4Gn2iiydOdJiX3W7yoJ+eC9WYtFyPv7GsekTAAVlCUeWbnwc7/it
        kxpBOcXGu3Cq1Y8Kz2B377t4gtUVVBn2MHbzIB32mbPZiWxrFxQ0zN/wh91iLxlD
        HlKNaQaE1c/RI4ga0sZ1mi4sBiZaVhpTB9jsyFAENlw1ki4FxPBPw2qVeOmvN3ig
        ==
X-ME-Sender: <xms:Xq4yXtw3RuRyVtPeVVvF94BHPauXfAyLzWnq35ASpUmJtwabK65aMQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedugedrfeekgdduiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledruddtje
    enucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgv
    gheskhhrohgrhhdrtghomh
X-ME-Proxy: <xmx:Xq4yXm4jemoUO_cdzbRTzOKxSFqr0Ue5Wt6YfV1swqXFThBUFZenDw>
    <xmx:Xq4yXnXhD9G5eRaqiU9XJDw-eZAUh9rSU8ds-ArKxWftpL7D4chskg>
    <xmx:Xq4yXi0lrMpwEb0YQPjYKXsaSA_e2qQ6lvXzjsMp7yNT0YzHYFWLKQ>
    <xmx:Xq4yXptBMSJQsj-s3GGk8-j5bLF0tjVYsY-WpTdjteP94wrowuu0Og>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id C24E13060986;
        Thu, 30 Jan 2020 05:22:21 -0500 (EST)
Date:   Thu, 30 Jan 2020 11:22:20 +0100
From:   Greg KH <greg@kroah.com>
To:     David Miller <davem@davemloft.net>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCHES] Networking
Message-ID: <20200130102220.GA924555@kroah.com>
References: <20200130.111227.499725814662724955.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200130.111227.499725814662724955.davem@davemloft.net>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 30, 2020 at 11:12:27AM +0100, David Miller wrote:
> 
> Please queue up the following networking bug fixes for v5.4 and v5.5
> -stable, respectively.

All now queued up, thanks!

greg k-h
