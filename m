Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C838F5716FD
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 12:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232448AbiGLKQa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 06:16:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230244AbiGLKQ3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 06:16:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B688DAC041;
        Tue, 12 Jul 2022 03:16:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 53E38617E8;
        Tue, 12 Jul 2022 10:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 351FAC3411C;
        Tue, 12 Jul 2022 10:16:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657620987;
        bh=aHfWc1u8nt5QQ0z6FkxjWhxFa6wi8IwziyhVtAhIivU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IyYCzh2isaQcF8uCf/yjGHuqsnWbo5pHzA/L7aJ6l8G4GGdhYcG22y5y9DpYHbukP
         2LreF9E2DUfGcHH1u5Dy418WvOJNI3OvvmuSmw46L1XZ+3Sx1pD4LKcI3ZE0PWSkYt
         O1ZOJi4HC5eip8YRiQBox5NlvMS16rgtxkXF4jtU=
Date:   Tue, 12 Jul 2022 12:16:25 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.15 000/226] 5.15.54-rc3 review
Message-ID: <Ys1J+c6xtYIxmJJh@kroah.com>
References: <20220712071513.420542604@linuxfoundation.org>
 <Ys1I9dL88ocqoluR@debian.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ys1I9dL88ocqoluR@debian.me>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jul 12, 2022 at 05:12:05PM +0700, Bagas Sanjaya wrote:
> On Tue, Jul 12, 2022 at 09:16:20AM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.15.54 release.
> > There are 226 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> > 
> 
> Successfully cross-compiled for arm64 (bcm2711_defconfig, GCC 10.2.0)
> and powerpc (ps3_defconfig, GCC 12.1.0).
> 
> Tested-by: Bagas Sanjaya <bagasdotme@gmail.com>

Wonderful, thanks for verifying the powerpc fixes.
