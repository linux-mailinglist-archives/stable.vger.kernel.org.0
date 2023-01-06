Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C45DC66024D
	for <lists+stable@lfdr.de>; Fri,  6 Jan 2023 15:35:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235347AbjAFOfH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Jan 2023 09:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235594AbjAFOep (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 Jan 2023 09:34:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 310B38318F;
        Fri,  6 Jan 2023 06:34:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D75D8B81C0C;
        Fri,  6 Jan 2023 14:34:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D60EC433D2;
        Fri,  6 Jan 2023 14:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673015658;
        bh=ynDFiEQrOvyn+hQ5jOy9DWfHWTy4bEEbSvBtrELW8dQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=wMa2bMRGLHxuCrjcj5axey3B7v6+dvVeQQuaJ8ItKM59V2cpPmjUZXy6+op3d6hT5
         A2BZBq2upk6x425FjB3YjhAokFgxKfnB82s2oZWj5Fj85R1ggEwW5sEpCyMfVUTG4T
         /8dN2p/dGuSrjAsXsnH3oNaFVlGCivLJr8MfbVPA=
Date:   Fri, 6 Jan 2023 15:34:15 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Georg =?iso-8859-1?Q?M=FCller?= <georgmueller@gmx.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 6.0 000/177] 6.0.18-rc1 review
Message-ID: <Y7gxZ201DOi7nyZZ@kroah.com>
References: <20230104160507.635888536@linuxfoundation.org>
 <53f19c0a-412d-ba8e-57bb-b626ba5b7672@gmx.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <53f19c0a-412d-ba8e-57bb-b626ba5b7672@gmx.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 06, 2023 at 03:27:58PM +0100, Georg Müller wrote:
> Hi Greg,
> 
> Am 04.01.23 um 17:04 schrieb Greg Kroah-Hartman:
> > This is the start of the stable review cycle for the 6.0.18 release.
> > There are 177 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Fri, 06 Jan 2023 16:04:29 +0000.
> > Anything received after that time might be too late.
> 
> There is an easy-to-trigger kernel panic in cifs which was introduced in 6.0.16 and could be fixed by backporting the following commit:
> 
>    9ee2afe5207b ("cifs: prevent copying past input buffer boundaries")
> 
> Please see https://bugzilla.kernel.org/show_bug.cgi?id=216895 for the details
> 
> Could this commit be added as well to 6.0.18?

It is too late for this release, we can add it to the next one.  Or you
can move to 6.1.y which you should be doing anyway as 6.0.y is about to
go end-of-life in a few days.

thanks,

greg k-h
