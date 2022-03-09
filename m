Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E39C4D434E
	for <lists+stable@lfdr.de>; Thu, 10 Mar 2022 10:19:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240709AbiCJJT4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Mar 2022 04:19:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240703AbiCJJTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Mar 2022 04:19:55 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B52AC11AA26;
        Thu, 10 Mar 2022 01:18:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E23F61CD7;
        Thu, 10 Mar 2022 09:18:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4332C340E8;
        Thu, 10 Mar 2022 09:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646903933;
        bh=1kXsgB9RV7owj+bfYobvcObXKkekftRuOqeuY/yo8YM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NhQUyrve6zFpPyG4bg/VdpU3KoaIm93JG6oJhIPk//76LOrevyQ0Iv1Nw3tuaiLLK
         y/C61OIIhmyNvMuFbSOYHiy4bDWVEtFUYlc/HUNK4Ib9dlsPQGa+002L4l3carbMCX
         UiPIgUbhVbgOZN5LAABOArb+URxAQGvKfPDXtj9I=
Date:   Wed, 9 Mar 2022 19:24:31 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        Stable <stable@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Shuah Khan <shuah@kernel.org>, patches@kernelci.org,
        lkft-triage@lists.linaro.org, Pavel Machek <pavel@denx.de>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Florian Fainelli <f.fainelli@gmail.com>, slade@sladewatkins.com
Subject: Re: [PATCH 4.19 00/18] 4.19.234-rc1 review
Message-ID: <Yijw3wz29xNiIhWl@kroah.com>
References: <20220309155856.155540075@linuxfoundation.org>
 <CADVatmMODnr1vQ3VGLOACT16wLEFA6hFrTzY44VdPO2M7gX+iw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADVatmMODnr1vQ3VGLOACT16wLEFA6hFrTzY44VdPO2M7gX+iw@mail.gmail.com>
X-Spam-Status: No, score=-6.5 required=5.0 tests=BAYES_00,DATE_IN_PAST_12_24,
        DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 09, 2022 at 06:08:19PM +0000, Sudip Mukherjee wrote:
> Hi Greg,
> 
> On Wed, Mar 9, 2022 at 4:03 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 4.19.234 release.
> > There are 18 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Fri, 11 Mar 2022 15:58:48 +0000.
> > Anything received after that time might be too late.
> 
> My tests are still running, but just an initial result for you,
> 
> x86_64 defconfig fails with:
> arch/x86/kernel/cpu/bugs.c: In function 'spectre_v2_select_mitigation':
> arch/x86/kernel/cpu/bugs.c:973:41: error: implicit declaration of
> function 'unprivileged_ebpf_enabled'
> [-Werror=implicit-function-declaration]
>   973 |         if (mode == SPECTRE_V2_EIBRS && unprivileged_ebpf_enabled())

It's in a .h file, how can it be undefined?  Must be a include path
somewhere, let me dig...


