Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D61F96BAAFF
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 09:44:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231772AbjCOIoA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 04:44:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231571AbjCOIn7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 04:43:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 736836C698;
        Wed, 15 Mar 2023 01:43:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F0FD161B7D;
        Wed, 15 Mar 2023 08:43:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B08DC433EF;
        Wed, 15 Mar 2023 08:43:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678869836;
        bh=/zkJv0YnYehTIFbZn9vVn25TH5tonpCa+mlBavMUXl8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J3OyF18hJnp1/67jy48xL/zfhQdQ5krfTSu8CZYdlcZGn2ey6ErbypVmtWti3cngx
         9oCcZ0k3a5jllzbmtzKAvo2P8O4QPkxkqlyq8r9XQW+DpR/sQwwp/Uc82qaQRd70Aj
         WZ/I76Ut/70QaCL9bdBNke2RU9H/AIDpqN31PBJY=
Date:   Wed, 15 Mar 2023 09:43:46 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Hauke Mehrtens <hauke@hauke-m.de>
Cc:     stable <stable@vger.kernel.org>,
        Andres Freund <andres@anarazel.de>,
        Quentin Monnet <quentin@isovalent.com>, bpf@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: stable backport of patches fixing perf, libbpf and bpftools
 compilation with binutils 2.40
Message-ID: <ZBGFQvnRspELWT6x@kroah.com>
References: <e6e2df31-6327-f2ad-3049-0cbfa214ae5c@hauke-m.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e6e2df31-6327-f2ad-3049-0cbfa214ae5c@hauke-m.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 06, 2023 at 11:58:12PM +0100, Hauke Mehrtens wrote:
> Hi,
> 
> The following patches are fixing the compilation of perf, bpf_jit_disasm and
> bpftools with binutils 2.40.
> 
> commit cfd59ca91467056bb2c36907b2fa67b8e1af9952
> Subject: tools build: Add feature test for init_disassemble_info API changes
> 
> commit a45b3d6926231c3d024ea0de4f7bd967f83709ee
> Subject: tools include: add dis-asm-compat.h to handle version differences
> 
> commit 83aa0120487e8bc3f231e72c460add783f71f17c
> Subject: tools perf: Fix compilation error with new binutils
> 
> commit 96ed066054abf11c7d3e106e3011a51f3f1227a3
> Subject: tools bpf_jit_disasm: Fix compilation error with new binutils
> 
> commit 600b7b26c07a070d0153daa76b3806c1e52c9e00
> Subject: tools bpftool: Fix compilation error with new binutils
> 
> 
> Please backport these patches to kernel 5.15. Backporting them to 5.10
> resulted in more merge conflicts for me so I did not continue if it.

Now all queued up to 5.15, thanks.

greg k-h
