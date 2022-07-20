Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC5F157BEC7
	for <lists+stable@lfdr.de>; Wed, 20 Jul 2022 21:43:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbiGTTny (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 20 Jul 2022 15:43:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiGTTnx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 20 Jul 2022 15:43:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73549691F0;
        Wed, 20 Jul 2022 12:43:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E715261AC3;
        Wed, 20 Jul 2022 19:43:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7995C3411E;
        Wed, 20 Jul 2022 19:43:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658346231;
        bh=qQam1ROdrxitInCeW3g4Wlq0zse5g0rhSdwht3K49qw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IL9JRYx00JE0+Mc92Kt8SWx7ACHmFoN7GAjoEvApOYhJ+BFJiTcpRYSz1SOYq1R3+
         6sgFpQx3N3YX2DnzES3PmHAU0/IXybUZwjjmvkgt1Ukzp9vUpDTc6RvfXxvAnVPooA
         ZgfC4DoRwLprIFAnJEMU7R6W8aI05P0XrVGt3J0w=
Date:   Wed, 20 Jul 2022 21:43:47 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Viktor =?iso-8859-1?Q?J=E4gersk=FCpper?= 
        <viktor_jaegerskuepper@freenet.de>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.18 000/231] 5.18.13-rc1 review
Message-ID: <Ytha8yjbJ3c3QNVu@kroah.com>
References: <20220719114714.247441733@linuxfoundation.org>
 <9038467b-5ada-9384-84b9-e7db11782d43@freenet.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <9038467b-5ada-9384-84b9-e7db11782d43@freenet.de>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jul 20, 2022 at 06:05:55PM +0200, Viktor Jägersküpper wrote:
> Greg Kroah-Hartman:
> > This is the start of the stable review cycle for the 5.18.13 release.
> > There are 231 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Hi Greg,
> 
> I noticed that there are several patches in the list which are also part of your
> retbleed-5.18 queue. If I am not mistaken, these are:
> 
> [PATCH 5.18 145/231] x86/kvm: Fix SETcc emulation for return thunks
> [PATCH 5.18 146/231] x86/sev: Avoid using __x86_return_thunk
> [PATCH 5.18 147/231] x86/bugs: Report AMD retbleed vulnerability
> [PATCH 5.18 148/231] objtool: Update Retpoline validation
> [PATCH 5.18 149/231] x86/xen: Rename SYS* entry points
> [PATCH 5.18 150/231] x86/cpu/amd: Add Spectral Chicken
> 
> I'm wondering if this is intended or if it would be better to release a stable
> kernel with all the retbleed patches later because of the problems that came up
> with these patches so far. I'm just a user, so I can't say anything about the
> technical side, and I don't know how the patches were selected.

Yes, sorry, I need to drop those and then add them only as part of the
retbleed stuff.

thanks,

greg k-h
