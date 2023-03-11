Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DA136B5CA6
	for <lists+stable@lfdr.de>; Sat, 11 Mar 2023 15:16:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbjCKOQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Mar 2023 09:16:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbjCKOQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 11 Mar 2023 09:16:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7A8AD11;
        Sat, 11 Mar 2023 06:16:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BDED660C38;
        Sat, 11 Mar 2023 14:16:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9734DC433D2;
        Sat, 11 Mar 2023 14:15:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678544160;
        bh=Byk8OJy7FAffNevRuOq1SrYcViAV1cY6st/7GhgpR/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bYHl0ogBs1PmWBud8dlJgzDkHockoQW+Zf9OY2mkEfUkxdW2D6DNOjQJ6yeqcSG8p
         N3g9Qgq5krodxEfY/Y3ep2pOhFvHEzbOAlifRBqaWboMeHHkPp2uITfGgeEtmfSnxo
         /0B7UcJxGpWTb9RpSvme/rs9RBluw+547eSIgi1I=
Date:   Sat, 11 Mar 2023 15:15:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 4.14 000/192] 4.14.308-rc2 review
Message-ID: <ZAyNHcm9ZqUj4Hon@kroah.com>
References: <20230311092102.206109890@linuxfoundation.org>
 <8c29b19c-e0b2-410d-b501-b6d8ddb77470@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c29b19c-e0b2-410d-b501-b6d8ddb77470@roeck-us.net>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 11, 2023 at 05:43:51AM -0800, Guenter Roeck wrote:
> On Sat, Mar 11, 2023 at 10:40:14AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 4.14.308 release.
> > There are 192 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Mon, 13 Mar 2023 09:20:28 +0000.
> > Anything received after that time might be too late.
> > 
> 
> Build results:
> 	total: 168 pass: 168 fail: 0
> Qemu test results:
> 	total: 430 pass: 430 fail: 0
> 
> Tested-by: Guenter Roeck <linux@roeck-us.net>

Wonderful, thanks for the quick turn-around!


greg k-h
