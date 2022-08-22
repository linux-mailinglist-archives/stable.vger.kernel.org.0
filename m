Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 90F3559B961
	for <lists+stable@lfdr.de>; Mon, 22 Aug 2022 08:26:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232631AbiHVGZs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Aug 2022 02:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233116AbiHVGZk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 22 Aug 2022 02:25:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7C6513E17;
        Sun, 21 Aug 2022 23:25:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id ED75FB80E2C;
        Mon, 22 Aug 2022 06:25:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3762BC433D6;
        Mon, 22 Aug 2022 06:25:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661149535;
        bh=8lGO4gyyAJ7185vJVxTXPadYljMx4FMhRDbllKXjb2w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=2LirxRQYujzVSmN4YD8ifv5hKKbxq6KOzWmGTIne7PB/8IEdsXGTYZxbv446bDbEZ
         8MHBEbUPF0EHbcEqlsm1ayjBfnwPSIN1n+CrT0ZNCWyayDE6fkQJhPc5LacNVdEqhI
         KEd2OaNQ/y87g4ay2aIZCtce5GxwoW67Ze4kpk8g=
Date:   Mon, 22 Aug 2022 08:25:33 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     stable <stable@vger.kernel.org>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-x86_64@vger.kernel.org
Subject: Re: LTS kernel Linux 4.14.290 unable to boot with edk2-ovmf (x86_64
 UEFI runtime)
Message-ID: <YwMhXX6OhROLZ/LR@kroah.com>
References: <2d6012e8-805d-4225-80ed-d317c28f1899@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d6012e8-805d-4225-80ed-d317c28f1899@gmx.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 22, 2022 at 09:15:59AM +0800, Qu Wenruo wrote:
> Hi,
> 
> When backporting some btrfs specific patches to all LTS kernels, I found
> v4.14.290 kernel unable to boot as a KVM guest with edk2-ovmf
> (edk2-ovmf: 202205, qemu 7.0.0, libvirt 1:8.6.0).
> 
> While all other LTS/stable branches (4.19.x, 5.4.x, 5.10.x, 5.15.x,
> 5.18.x, 5.19.x) can boot without a hipccup.
> 
> I tried the following configs, but none of them can even provide an
> early output:
> 
> - CONFIG_X86_VERBOSE_BOOTUP
> - CONFIG_EARLY_PRINTK
> - CONFIG_EARLY_PRINTK_EFI
> 
> Is this a known bug or something new?

Has this ever worked properly on this very old kernel tree?  If so, can
you use 'git bisect' to find the offending commit?

thanks,

greg k-h
