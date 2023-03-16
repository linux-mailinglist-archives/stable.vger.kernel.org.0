Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E05336BCAFA
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 10:34:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230351AbjCPJei (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 05:34:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231200AbjCPJef (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 05:34:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52D7FAFBA0;
        Thu, 16 Mar 2023 02:34:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1B3361FAC;
        Thu, 16 Mar 2023 09:34:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0257C433EF;
        Thu, 16 Mar 2023 09:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678959268;
        bh=N6qBnppIi8AfwTjyHCvwjRK9nwxr0aaHUgabjTQA6gc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DeQWqElFbJqJyKYkHDHjFDA9gqhcmUurTa0rr6DnHTOccBMxG8C3dxD6NP3YP+Lys
         tu/L4bFq+AhbWdyf5m6kk7jg8KUmWMBHnECMN80mgl+w62fqIX1qkf51mYBQy9DN39
         cTkz+e1E+BgHE5HlC3ctWFBlZ5mVsm+LChY8NZrA=
Date:   Thu, 16 Mar 2023 10:34:25 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Pavel Machek <pavel@denx.de>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
Subject: Re: Missing patches in 4.19? was Re: [PATCH 4.19 00/39] 4.19.278-rc1
 review
Message-ID: <ZBLioUeQIdzjb+W5@kroah.com>
References: <20230315115721.234756306@linuxfoundation.org>
 <ZBLYf4KZYj62HuHX@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBLYf4KZYj62HuHX@duo.ucw.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 16, 2023 at 09:51:11AM +0100, Pavel Machek wrote:
> Hi!
> 
> > Pseudo-Shortlog of commits:
> 
> There is something missing here.
> 
> In 5.10-rc we have:
> 
> de365066382ce0dbbf3b7189128ccc16e4eae198 net: caif: Fix use-after-free in cfusbl_device_notify()
> 
> 4.14-rc has:
> 
> 921b052b636c72fbb97c50bd0be33bd7358ab374 net: caif: Fix use-after-free in cfusbl_device_notify()
> 
> But I don't see corresponding patch in 4.19.
> 
> More than one patch may be affected:
> 
>  |70cec8eec 9781e9 .: 5.10| net: caif: Fix use-after-free in cfusbl_device_notify()
>  |f690886b9 9781e9 .: 4.14| net: caif: Fix use-after-free in cfusbl_device_notify()
>  |98e6078de 11f180 .: 5.10| nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties
>  |012961752 11f180 .: 4.14| nfc: fdp: add null check of devm_kmalloc_array in fdp_nci_i2c_read_device_properties
>  |b4e4d4931 693aa2 o: 5.10| ila: do not generate empty messages in ila_xlat_nl_cmd_get_mapping()
>  |f2b350c04 693aa2 o: 4.14| ila: do not generate empty messages in ila_xlat_nl_cmd_get_mapping()

Good catch, now queued up and I'll push out a -rc3.
