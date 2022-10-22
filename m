Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 763B7608C09
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 12:57:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230140AbiJVK5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 06:57:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiJVK5c (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 06:57:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD2952E9804;
        Sat, 22 Oct 2022 03:16:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 93FC9B81A76;
        Sat, 22 Oct 2022 10:15:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C18F9C433D7;
        Sat, 22 Oct 2022 10:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666433740;
        bh=bLONuDyjj5rf4HsGrrSGvcEpn3Dvk8M1WhXm2C5YW/M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Vhk8qKm8IppwtnJudWOPfQraALhpSbCcZYUtM4slq3Ri86kFyJvj99C0MTl0lWsbM
         BPFBg2YXZBMH4JxO7DgWru++IpMkxtLmflbxaNE5uSsyvtNVJHN/o889KGyj9r8hja
         puWCPqlAZCH2uLg+MZS26Zzg5sde4kt6h7EdIDAg=
Date:   Sat, 22 Oct 2022 12:15:37 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net
Subject: Re: [PATCH 5.19 000/717] 5.19.17-rc1 review
Message-ID: <Y1PCyVHKEUst4mRL@kroah.com>
References: <20221022072415.034382448@linuxfoundation.org>
 <Y1Ov3KuyKmb9Nizm@debian.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y1Ov3KuyKmb9Nizm@debian.me>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Oct 22, 2022 at 03:54:52PM +0700, Bagas Sanjaya wrote:
> On Sat, Oct 22, 2022 at 09:17:59AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.19.17 release.
> > There are 717 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Note, this will be the LAST 5.19.y kernel to be released.  Please move
> > to the 6.0.y kernel branch at this point in time, as after this is
> > released, this branch will be end-of-life.
> > 
> 
> Hi Greg, thanks for the patch series, which is out three days after
> the -rc1 have been pused. As usual, the template message follows.

What exactly do you mean by "3 days after"?

Are you watching the linux-stable-rc branches?  Those are there only for
CI systems and are not a "real" -rc release at all until we do this
email announcement.

The -rc1 release here does not look at all like what was in the
linux-stable-rc branch 3 days ago if you look closely.  There are a lot
fewer patches now than before, and other changes.

So again, unless you are running a CI system, don't look at the
linux-stable-rc branches.

thanks,

greg k-h
