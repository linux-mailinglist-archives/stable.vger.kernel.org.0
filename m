Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B8AB4D4642
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 12:48:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237141AbiCJLtJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 06:49:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233444AbiCJLtI (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 06:49:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 906B64664A;
        Thu, 10 Mar 2022 03:48:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3808DB81EF7;
        Thu, 10 Mar 2022 11:48:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7902CC340E8;
        Thu, 10 Mar 2022 11:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646912885;
        bh=P3/akn23t2kV1J+hQLFVUuaRoWJnWjwn12Tehec9bIU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vGnO/ONNfRJoqa9TWwGMM8TnS+MtfmCmZGKtwXLJ7Q+0aHSQOh2288xPKpvisPuQo
         wXSLF59lPgU2gszFIpCN6o1aMyM/A8eTORnkGlPdi4rBaP2T5j5fqRXtRf/MCTaRQQ
         +E0Z1QnAdgdndtFJ0AyadP+5nJ6tI+Hrrc+aMIYY=
Date:   Thu, 10 Mar 2022 12:48:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     Daniel =?iso-8859-1?Q?D=EDaz?= <daniel.diaz@linaro.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.9 00/24] 4.9.306-rc1 review
Message-ID: <YinlcYSs5FwO4oVd@kroah.com>
References: <20220309155856.295480966@linuxfoundation.org>
 <2f501345-e847-668e-7ca3-23af49b69224@linaro.org>
 <322280c2-8673-949c-ffd4-4e804a030b89@linaro.org>
 <20220310114116.GD20436@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220310114116.GD20436@duo.ucw.cz>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 10, 2022 at 12:41:16PM +0100, Pavel Machek wrote:
> Hi!
> 
> This is not breaking the build, but...
> 
> > commit d0002ea56072220ddab72bb6e31a32350c01b44e
> > Author: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
> > Date:   Thu Feb 10 16:05:45 2022 +0000
> >     ARM: Spectre-BHB workaround
> 
> >     comomit b9baf5c8c5c356757f4f9d8180b5e9d234065bc3 upstream.
> 
> ...the typo in word "commit" breaks our scripts, so we'd not mind if
> it was fixed.

good catch, I'll fix it up.

greg k-h
