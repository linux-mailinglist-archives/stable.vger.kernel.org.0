Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970E04DDE18
	for <lists+stable@lfdr.de>; Fri, 18 Mar 2022 17:14:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233695AbiCRQPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Mar 2022 12:15:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46738 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233685AbiCRQPe (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Mar 2022 12:15:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC9DC1CFE4;
        Fri, 18 Mar 2022 09:14:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8D529B824A7;
        Fri, 18 Mar 2022 16:14:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654FEC340E8;
        Fri, 18 Mar 2022 16:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647620052;
        bh=OEa4kSOpcUxd2Ktxa4MIliyQMClUaaW4AHu+nc9CldM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GNwlr54+e9nPxlb8JGqOpn27YX5yaaQJb952ZKO4ws9qo2y89/9VUgZRX/8i6E30q
         qmg7gT/HH5YeL2YMHQ8FCJCaIhXf+oPuYZ2ipaMrkr5b2qShljr99D+1xwGN6dM6Aw
         qQstyhNWeOPbXQ8p/wBbnGml7OnJI/DCOlJXfsOI=
Date:   Fri, 18 Mar 2022 17:14:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.10 00/23] 5.10.107-rc1 review
Message-ID: <YjSvz2UXhmgqUEic@kroah.com>
References: <20220317124525.955110315@linuxfoundation.org>
 <20220317211922.GB5328@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220317211922.GB5328@duo.ucw.cz>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 17, 2022 at 10:19:22PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.107 release.
> > There are 23 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> 
> > Christophe JAILLET <christophe.jaillet@wanadoo.fr>
> >     bnx2: Fix an error message
> 
> As commented during the AUTOSEL phase, this patch actually _adds_ an
> error in at least 5.10 and older. Please drop.

Now dropped, thanks.

greg k-h
