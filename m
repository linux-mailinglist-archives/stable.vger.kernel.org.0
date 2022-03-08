Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D69A44D1C49
	for <lists+stable@lfdr.de>; Tue,  8 Mar 2022 16:48:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347916AbiCHPt0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Mar 2022 10:49:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347984AbiCHPt0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Mar 2022 10:49:26 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4FEF136E28;
        Tue,  8 Mar 2022 07:48:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04A1CB8199F;
        Tue,  8 Mar 2022 15:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C20C340EB;
        Tue,  8 Mar 2022 15:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646754506;
        bh=UlEV/kcHsBhnvTZ/QRKuS+F+zKNawPdoMIHBiUMf+ps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=lQ6SSReM6PJoqBmLv8ywGRwNuWIZGjS6VtKOz7S++o+/TeIUl7+ovhNCnGMgJWH47
         t9Svx7pJ6NkOA1ExKPyRztgYGlBuvdRBd/4EheTeiveaZdmyWU8ed971vvtymnZ73x
         l/tjhhQFryCvr2G8zG4GZd9U/sJpQ2UtMPK8let8=
Date:   Tue, 8 Mar 2022 16:48:23 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Luna Jernberg <droidbittin@gmail.com>
Cc:     Shuah Khan <skhan@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/256] 5.15.27-rc2 review
Message-ID: <Yid6xwAV7+j2xfPr@kroah.com>
References: <20220307162207.188028559@linuxfoundation.org>
 <97250f69-cde0-37c1-09d0-845047704bdc@linuxfoundation.org>
 <CADo9pHjuByLte3d8WhKf1jWw_=EoW-76405ptW-sZg0-AakxqQ@mail.gmail.com>
 <CADo9pHiJGXFwvXDRqRCjYqowJkkP3GYzkO8jqPQK=z71V_5FOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CADo9pHiJGXFwvXDRqRCjYqowJkkP3GYzkO8jqPQK=z71V_5FOw@mail.gmail.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 08, 2022 at 04:29:15PM +0100, Luna Jernberg wrote:
> oh i meant to send that too the 5.16.13 emails
> 
> On Tue, Mar 8, 2022 at 3:30 PM Luna Jernberg <droidbittin@gmail.com> wrote:
> 
> > Both rc2, and rc1 works fine from the linux-rc package in AUR on my Arch
> > Linux systems :)

If you respond with a "Tested-by:" line like others do, my scripts will
automatically put it in the commit log for the release commit if you
want.

thanks for testing!

greg k-h
