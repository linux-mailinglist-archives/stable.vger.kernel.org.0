Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C8C6345FE65
	for <lists+stable@lfdr.de>; Sat, 27 Nov 2021 13:03:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239409AbhK0MHA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 27 Nov 2021 07:07:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235503AbhK0MFA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 27 Nov 2021 07:05:00 -0500
X-Greylist: delayed 357 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 27 Nov 2021 04:01:46 PST
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EDE7C061574;
        Sat, 27 Nov 2021 04:01:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id A9B50CE093A;
        Sat, 27 Nov 2021 11:55:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B807C53FAD;
        Sat, 27 Nov 2021 11:55:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638014144;
        bh=ebKm58QdnSNQOWjfNvxNMu29gEV5Xyzf+bN9EcoriZk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PB2/RTRi/WfXwhezNW9Qs44LyHUXAH2u33gbeCzFmdZqtUk9SKesJlhfQvf8nbkeI
         gH/PjU/Db20WH+51pEz7/pgqoGVaNQ53xYAlxjZ4MxKPT7wkMC2V26ojjsNKmoQTQ2
         mjZnMrn+Nn7KzUvFeoliMnGP4mD/iUuXYwOCEHdo=
Date:   Sat, 27 Nov 2021 12:55:42 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>
Cc:     Tom Yan <tom.ty89@gmail.com>, linux-scsi@vger.kernel.org,
        damien.lemoal@wdc.com, martin.petersen@oracle.com,
        sashal@kernel.org, stable@vger.kernel.org
Subject: Re: [Regression][Stable] sd use scsi_mode_sense with invalid param
Message-ID: <YaIcvg3LgfCjwxfF@kroah.com>
References: <CAGnHSE=uOEiLUS=Sx5xhSVrx-7kvdriC=RZxuRasZaM2cLmDeQ@mail.gmail.com>
 <CAGnHSEmFoAS-ZY6u=ar=O0UU=FPgEuOx5KLcBWkboEVdeFXbGg@mail.gmail.com>
 <CAGnHSEmkTyq_QqP9S6TemsHOKxj2Gzq3R7X6+PxbQs_R-iBB7Q@mail.gmail.com>
 <92cc74fd-ce93-b844-830f-71e744e0c084@opensource.wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <92cc74fd-ce93-b844-830f-71e744e0c084@opensource.wdc.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Nov 27, 2021 at 10:15:51AM +0900, Damien Le Moal wrote:
> On 2021/11/27 6:33, Tom Yan wrote:
> > Hi Greg,
> > 
> > Could you help pulling c749301ebee82eb5e97dec14b6ab31a4aabe37a6 into
> > the stable branches in which 17b49bcbf8351d3dbe57204468ac34f033ed60bc
> > has been pulled? Thanks!
> 
> Yeah, in retrospect, these 2 patches should really have been squashed together.
> Sorry about that. Note that none of these were marked for stable though. I think
> that Sasha's bot picked-up automatically
> 17b49bcbf8351d3dbe57204468ac34f033ed60bc for stable because of the "Fix" in the
> commit title. But c749301ebee82eb5e97dec14b6ab31a4aabe37a6 also has "Fix" in its
> title but was not picked-up. Weird.
> 
> Greg, Martin,
> 
> To fix this, c749301ebee82eb5e97dec14b6ab31a4aabe37a6 is needed in stable !
> 
> Reference: https://bugzilla.kernel.org/show_bug.cgi?id=215137

Now queued up, thanks.

greg k-h
