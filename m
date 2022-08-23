Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D98859D14E
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 08:32:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240617AbiHWG3E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 02:29:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240517AbiHWG3D (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 02:29:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9021D4056F;
        Mon, 22 Aug 2022 23:29:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2A97561477;
        Tue, 23 Aug 2022 06:29:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF9ABC433D6;
        Tue, 23 Aug 2022 06:29:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661236141;
        bh=JRtJ29lH/SslxxH7D0rWowl2W4WY4+1lbfXKoq/Nbc8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cpc1b1ygbuSbtiySOHMJUlZbIyRz8R+meI7a5Uy3z7PS5TK7ZXkGybvLNx0hfgEcl
         njq0bsaGeveOj0lTI4UAz/i/YIZQ2uLb5o0dGQT8scKcQQgEzMAXzu1lt23aSjlktu
         iOrkeiytkPiflfmBDOlWqQh8n068RVBg0rMRgIHs=
Date:   Tue, 23 Aug 2022 08:28:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     linux-doc@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Rikard Falkeborn <rikard.falkeborn@gmail.com>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Ralf Baechle <ralf@linux-mips.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Aditya Srivastava <yashsri421@gmail.com>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org
Subject: Re: [PATCH] mips: pci: remove extraneous asterisk from top level
 comment of ar2315 PCI driver
Message-ID: <YwRzqiJjHdnCA65Y@kroah.com>
References: <202208221854.8ASrzjKa-lkp@intel.com>
 <20220823030056.123709-1-bagasdotme@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220823030056.123709-1-bagasdotme@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 23, 2022 at 10:00:56AM +0700, Bagas Sanjaya wrote:
> kernel test robot reported kernel-doc warning:
> 
> arch/mips/pci/pci-ar2315.c:6: warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>     * Both AR2315 and AR2316 chips have PCI interface unit, which supports DMA
> 
> The warning above is caused by an extraneous asterisk on the top level
> (description) comment of pci-ar2315.c, for which the comment is confused as
> kernel-doc comment instead.
> 
> Remove the asterisk.
> 
> Link: https://lore.kernel.org/linux-doc/202208221854.8ASrzjKa-lkp@intel.com/
> Fixes: 3ed7a2a702dc0f ("MIPS: ath25: add AR2315 PCI host controller driver")
> Fixes: 3e58e839150db0 ("scripts: kernel-doc: add warning for comment not following kernel-doc syntax")
> Reported-by: kernel test robot <lkp@intel.com>
> Cc: stable@vger.kernel.org # v5.15, v5.19

kerneldoc issues are not stable worth, sorry.

thanks,

greg k-h
