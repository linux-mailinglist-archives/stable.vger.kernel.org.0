Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60BCC6BE046
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 05:46:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbjCQEqY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 00:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229494AbjCQEqX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 00:46:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FC7F55065;
        Thu, 16 Mar 2023 21:46:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9E7A9621A9;
        Fri, 17 Mar 2023 04:46:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 869B4C433EF;
        Fri, 17 Mar 2023 04:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679028381;
        bh=5yNWvQgLeD+W3TatQwurqoEHcZNBbmWYCS4gwWkQqRQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ctHhz266/vA9IBD/uqQDLslLpdKys6D4Y6BGhe6S3UjAa2tEsn5V5rsMx/YIZ6PI3
         ZGY7Vx9RI9qJwmwf+efl3lZHanEerNwtRcswPG6rvtmVyzs7qMlg9NzH7a3xrDipOD
         WkBO6QWnWIJbVnRnvvF59UI3tgjJV3GRzCXoi5IE=
Date:   Fri, 17 Mar 2023 05:46:18 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Tom Saeger <tom.saeger@oracle.com>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: [PATCH 5.15 000/137] 5.15.103-rc2 review
Message-ID: <ZBPwmsMpxISpRw+G@kroah.com>
References: <20230316083443.411936182@linuxfoundation.org>
 <20230316193711.s4cwpbcayg24zv5l@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316193711.s4cwpbcayg24zv5l@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 16, 2023 at 01:37:11PM -0600, Tom Saeger wrote:
> On Thu, Mar 16, 2023 at 09:50:12AM +0100, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.103 release.
> > There are 137 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> > Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> > Anything received after that time might be too late.
> > 
> > The whole patch series can be found in one patch at:
> > 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.103-rc2.gz
> > or in the git tree and branch at:
> > 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> > and the diffstat can be found below.
> > 
> > thanks,
> > 
> > greg k-h
> 
> Build ID for arm64 is back with CONFIG_MODVERSIONS=y
> Hooray!
> 
> Tested-by: Tom Saeger <tom.saeger@oracle.com>

Yeah!  Thanks for sticking with that, sorry it took so long to get
merged.

greg k-h
