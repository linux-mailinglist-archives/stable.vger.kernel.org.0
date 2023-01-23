Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2ED7677A4F
	for <lists+stable@lfdr.de>; Mon, 23 Jan 2023 12:46:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjAWLqJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Jan 2023 06:46:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229548AbjAWLqI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 Jan 2023 06:46:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F3F14EAF;
        Mon, 23 Jan 2023 03:46:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3E58C60E93;
        Mon, 23 Jan 2023 11:46:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35656C433D2;
        Mon, 23 Jan 2023 11:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1674474364;
        bh=zEg8X0VHfQqYvwVDau1Shrz6CwI/I0yBIiV+dvFeFYA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=aD27Z0fJAsAKFYaqhwqKgUlIi1xST5vKkpDVe6VFUZDwJTR6HrGDqCF2LRCKyMG4r
         lKUbFTMOCX3B1zmzVnj8Am7T+fdi1VwQBZ3rUOupxoCL3dplA01lSTZdL1HHDiSkUv
         FcgP37Cf5IiUsonXBZGeF2clb2ZN86GawF9F/ns4=
Date:   Mon, 23 Jan 2023 12:46:02 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.10 00/98] 5.10.165-rc1 review
Message-ID: <Y85zeq74fg7OtLyf@kroah.com>
References: <20230122150229.351631432@linuxfoundation.org>
 <Y85wE2OBrVvwUlLp@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y85wE2OBrVvwUlLp@duo.ucw.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 12:31:31PM +0100, Pavel Machek wrote:
> Hi!
> 
> > This is the start of the stable review cycle for the 5.10.165 release.
> > There are 98 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Hmm. Interesting.
> 
> We tested
> 
> commit 9096aabfe9e099a5af5d13bb0fb36e98bb623398
> Author: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Date:   Mon Jan 23 10:49:12 2023 +0100
> 
>     Linux 5.10.165-rc2
> 
> and found no problems there, but that is -rc2 and you announced -rc1.

https://lore.kernel.org/r/20230123094914.748265495@linuxfoundation.org

