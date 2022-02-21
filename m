Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABDE84BE0FB
	for <lists+stable@lfdr.de>; Mon, 21 Feb 2022 18:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1381252AbiBUQtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Feb 2022 11:49:06 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:35870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbiBUQsy (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Feb 2022 11:48:54 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14949237C9;
        Mon, 21 Feb 2022 08:48:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A477E61368;
        Mon, 21 Feb 2022 16:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87773C340E9;
        Mon, 21 Feb 2022 16:48:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645462110;
        bh=5Pik22iN7iVIuLmm2Qayj9ScyA9AdJpopJLWIeVTAO8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j6/VUANCfZ3zsZMa78OVM/eXtdb+Wx7BU73JJqHVT2qCPaPdr8GVfBMnUHK4Egzxj
         9ZR8kjzx7pM5mcb6n6n8j9lhrg1eU/0CXFGdD1pzT/KTXV1vUIu/ViKYGoJ36XDfsz
         MLPOiBsSkPOsTYIhQsHfLc4A/ROVu11any6IKXso=
Date:   Mon, 21 Feb 2022 15:16:08 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/58] 4.19.231-rc1 review
Message-ID: <YhOeqJ0XLjYVuBCe@kroah.com>
References: <20220221084911.895146879@linuxfoundation.org>
 <20220221122340.GA15152@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220221122340.GA15152@duo.ucw.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 21, 2022 at 01:23:40PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 4.19.231 release.
> > There are 58 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> > and the diffstat can be found below.
> 
> Do you think you could quote git hash of the respective commit here?

No, as that tree is a "throw away" one which I delete instantly on my
side once I create it and push it out.  I am only creating it so that
people who use git for their CI can have an easy way to test it.

Once I do a -rc announcement, the branch here should always work, if
not, please report it.

thanks,

greg k-h
