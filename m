Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 70C1F9BF25
	for <lists+stable@lfdr.de>; Sat, 24 Aug 2019 20:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbfHXSOt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 24 Aug 2019 14:14:49 -0400
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:53263 "EHLO
        out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726464AbfHXSOt (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 24 Aug 2019 14:14:49 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id EA80221111;
        Sat, 24 Aug 2019 14:14:47 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Sat, 24 Aug 2019 14:14:47 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=/f8CrK1773tk8Rkg7zT/3v6jDeU
        yqoqTy+dy34IURyY=; b=GNesZS/PecBCoCHukXDL2HTgI0uDCQ24y6/lUGQsKYA
        MPkNqnaH3/wATUcW4GG5DtBIZh93DO3dsmbeEx8MVlm5JY9V2eAmjRGJJndQZQ8j
        HEqiB0HPCxSXAPhWkcuwYJSleuGXNNNz4EoikWO9lSAGzlIIIpQKfYSLluMmtaGz
        Tip+TAlCRk4EBCAWFk/MTvXbvhFkt+N0XutBXhRe/RS17O33gn6y8FzvyNDBCHe0
        KPeDm0KKx55qEWiVIbTakdIsT08Ihp3IZjP5iPFRaGYssGsscL5dlh70vjs0eKO4
        xuCfcZE9sst0X9w24JQKIusd6vFU+xSAyZODVGRBO4w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=/f8CrK
        1773tk8Rkg7zT/3v6jDeUyqoqTy+dy34IURyY=; b=CYEX0bKbkGSq6TeIo63lOo
        B3kmfgnLHPzCgaBsQ5Qc0oWzpgIsvaNS2ECIt3R4e5Jci9S75Xc7V1ma6yOMQWjg
        PzmngTSXVrE6yu0dZ0KMlrEQ6hzmpBWK8klX7ZtIuuVFzTZHaXb4OsO+a5S7gcuF
        qqEvONlFiRN+LIYiRO4EYjtWzi6xuWD/rr0Ot9SP/P9BHw3gYydyQHkwkTF4CGQR
        s175uvK2ksqt5hjTCefai61ygt+XcMPVW8e3alKeGxke1Yi1tDlChL9lpLtzdNKl
        16JHN9Qn/BsGdugUDLrxtWmoG76SzHTYpXkqy3ZmjiGCbLVtYCRUEqmCl/Ju5R8g
        ==
X-ME-Sender: <xms:l35hXTy-Dj5knsfqU7fszmweeqEVpb9Khfmr5ZdnFGw8iCf_CwMDcA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudehtddguddvhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucffohhmrghinhepkhgvrhhnvg
    hlrdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenucfrrghrrghmpehmrghilhhf
    rhhomhepghhrvghgsehkrhhorghhrdgtohhmnecuvehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:l35hXejv_kaADxro_vcl6CVICNcnT2Q9n471KGEDM5ohutADNnXl8Q>
    <xmx:l35hXWwZwYjID5Sw75FEFdpW-G391zAFeSxr1Lh6J3AIi-lAzklOhw>
    <xmx:l35hXZJWADk2Ke2Eerik_tgr4MYKCf6St_F0PkOhMieQDPmM41x94Q>
    <xmx:l35hXSNnUiF5ZIQu9rCsKRAg-SKHsQA2TOpfAMJthUo_iS-R5OCOAA>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id CFB668005A;
        Sat, 24 Aug 2019 14:14:46 -0400 (EDT)
Date:   Sat, 24 Aug 2019 20:14:45 +0200
From:   Greg KH <greg@kroah.com>
To:     shuah <shuah@kernel.org>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net,
        patches@kernelci.org, ben.hutchings@codethink.co.uk,
        lkft-triage@lists.linaro.org
Subject: Re: [PATCH 5.2 000/135] 5.2.10-stable review
Message-ID: <20190824181445.GA10804@kroah.com>
References: <20190822170811.13303-1-sashal@kernel.org>
 <00216731-a088-7d47-eafb-70409f876bda@kernel.org>
 <20190824023829.GE9862@kroah.com>
 <e4d5ba59-8e38-a267-8a14-3c6bc03f77bd@kernel.org>
 <20190824153348.GA27505@kroah.com>
 <93850e40-7df9-b5db-bda4-5b4354d2c3f3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <93850e40-7df9-b5db-bda4-5b4354d2c3f3@kernel.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Aug 24, 2019 at 11:01:19AM -0600, shuah wrote:
> On 8/24/19 9:33 AM, Greg KH wrote:
> > On Sat, Aug 24, 2019 at 09:21:53AM -0600, shuah wrote:
> > > On 8/23/19 8:38 PM, Greg KH wrote:
> > > > On Fri, Aug 23, 2019 at 12:41:03PM -0600, shuah wrote:
> > > > > On 8/22/19 11:05 AM, Sasha Levin wrote:
> > > > > > 
> > > > > > This is the start of the stable review cycle for the 5.2.10 release.
> > > > > > There are 135 patches in this series, all will be posted as a response
> > > > > > to this one.  If anyone has any issues with these being applied, please
> > > > > > let me know.
> > > > > > 
> > > > > > Responses should be made by Sat 24 Aug 2019 05:07:10 PM UTC.
> > > > > > Anything received after that time might be too late.
> > > > > > 
> > > > > > The whole patch series can be found in one patch at:
> > > > > >            https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-5.2.10-rc1.gz
> > > > > 
> > > > > I am seeing "Sorry I can't find your kernels". Is this posted?
> > > > 
> > > > Ah, Sasha didn't generate the patch but it was still listed here, oops.
> > > > He copied my format and we didn't notice this, sorry about that.
> > > > 
> > > > As the thread shows, we didn't generate this file this time to see what
> > > > would happen.  If your test process requires it, we can generate it as I
> > > > don't want to break it.
> > > > 
> > > 
> > > It will make it lot easier for me to have continued support for patch
> > > generation. My scripts do "wget" to pull the patch and apply.
> > 
> > Ok, we will get this back and working, sorry about that.
> > 
> 
> Great. Thanks for accommodating my workflow.

I have uploaded it to kernel.org now, should show up on the "public
side" in 15 minutes or so.

thanks,

greg k-h
