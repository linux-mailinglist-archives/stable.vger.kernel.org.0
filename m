Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 704FD4A2C2E
	for <lists+stable@lfdr.de>; Sat, 29 Jan 2022 07:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242059AbiA2Gsj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 Jan 2022 01:48:39 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:39283 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229958AbiA2Gsj (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 Jan 2022 01:48:39 -0500
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailnew.nyi.internal (Postfix) with ESMTP id A95B05802DE;
        Sat, 29 Jan 2022 01:48:38 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Sat, 29 Jan 2022 01:48:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=oaNHubmYc/LmCt9wHslNMar6n23AnSzdqKTHyN
        1xMik=; b=fIshGNgfSQgv1fa4PMRBDlfn0q+3a8NB23lHWKRZbSGg+xUuIIj2A+
        OD0CfSgiZRaQuEG5HCxzUry4tiASuoGyKDCodQNtI8jFk51E7/t5D420j8OcRQEe
        3Uhp3n8x9bg2o0KD6STorMyokFNeG0y8NgtC+lk/lyX/3rFc90jVDpF7jSPoJ3CV
        1NKEH5osIN0D/XnYEguqK/STWmRB/54wLTraZp8GKpjcEfZ1lin216xO7mqSwGg+
        W2W33Pmdws/RGGxNsap7l+Rujw9TNuGw6Qh3Ig05Ww914VrIGS/XxDBFPEErNTyy
        zydRE+O7S3tV/a7qhy11Cb22Azs8gKMw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=oaNHubmYc/LmCt9wH
        slNMar6n23AnSzdqKTHyN1xMik=; b=nN1pAzOFGiFdlKRdrL0LVJrz87rRxnyar
        NeSbri0LaPiErSwqW/DQM/FK1Fnztxaxan4Yb/9xIdbck9orZV2BmEYCgUjqDqKI
        U8VbvGzH5GooSRuS4iGrQwYMixZzoMeyu/e1tveJqtAdDMfnCUrxSOCT3ftKbWXP
        M6ohuK9r+v2wk573BKvgXQqjxGb7V2EgFEEPivluMVRYELLP+4iZQl1Tk5hqkri5
        mRu4bAtAiEFGWEVKmblbwnom5rxwB5m2RPCHVBW5yC0sfmec9d2bofElWxCabnJ3
        jmSazSRjNf8gDNpHSDi4um0Dhs6kTrLKB0e0Hu71S9A0A9Z/JYGaw==
X-ME-Sender: <xms:ReP0YUJ1XKVksc3zrdWRoMtRb88b0k1hUJQ-M0J-DJ4sCKeyLIw6Yw>
    <xme:ReP0YUJVhRYYxP9C5nXCHOLP5jIPlJ_ES_LKCmeCmXDZxMJICloJyvrFs-AzIH7N-
    gl9IsA3Cc0hbg>
X-ME-Received: <xmr:ReP0YUvxli0NBPKJkOz-RhNAiZADn194aWtUHzjqkW5zccoRtdbIbhCtsYMUX_H2U6mtqAjZWXTHF7PnLC6pzb7z1LDeaLFs>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrfeeigdellecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:ReP0YRaLFcbxUyogZbLizfQlcESmQY3ekcT49V0g959ZPJc8WNPreQ>
    <xmx:ReP0YbbArToSjr6lxg-OXvKOIAd2urBNOrkHpTGn0PjQLDTjwR93rg>
    <xmx:ReP0YdAtzROWHwNRZuFEOcLCHTmzTHG2mlULSKr0uWtzb6pSu3TewQ>
    <xmx:RuP0YTLMt7ERKS67wKB88wS8pW3DwMPSVdbvmhg_MqHZPhJWE4lxUw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sat,
 29 Jan 2022 01:48:37 -0500 (EST)
Date:   Sat, 29 Jan 2022 07:48:34 +0100
From:   Greg KH <greg@kroah.com>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        stable <stable@vger.kernel.org>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Mauro Carvalho Chehab <mchehab@kernel.org>,
        Tony Luck <tony.luck@intel.com>,
        James Morse <james.morse@arm.com>,
        Robert Richter <rric@kernel.org>, linux-edac@vger.kernel.org
Subject: Re: [PATCH 1/2] edac: altera: fix deferred probing
Message-ID: <YfTjQukS1ad9ZBmK@kroah.com>
References: <20220124185503.6720-1-s.shtylyov@omp.ru>
 <20220124185503.6720-2-s.shtylyov@omp.ru>
 <7b964ac0-6356-9330-a745-b43e620d051b@kernel.org>
 <YfQ3xUpLOPvDu5W+@zn.tnic>
 <ba83ca78-6a15-caf5-71ba-76d5b2b1b41d@omp.ru>
 <9f28d2de-5119-a7a6-9da7-08b2ce13f1a0@omp.ru>
 <YfRBCPRPkf+gD18/@zn.tnic>
 <5bd9cbc1-12d2-aedc-6d64-ac9eaa2460b1@omp.ru>
 <YfRB8SSugBDHAcwH@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfRB8SSugBDHAcwH@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 28, 2022 at 08:20:17PM +0100, Borislav Petkov wrote:
> On Fri, Jan 28, 2022 at 10:17:55PM +0300, Sergey Shtylyov wrote:
> >    My experience tells they do.
> 
> Let's ask them:
> 
> @stable folks, do you guys take patches based only on Fixes: tags
> nowadays or you still require CC:stable to be present in the commit
> message?

If you know you want a patch in the stable tree, add cc: stable.

Because not all maintainers remember to do so, we do dig through all
patches with just the fixes: tag, and try to backport them if needed,
but it does not always happen, and there can be long lags as well.

So again, if you know you want it in a stable kernel, add the cc:
stable.

thanks,

greg k-h
