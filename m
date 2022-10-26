Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17CB760E5A6
	for <lists+stable@lfdr.de>; Wed, 26 Oct 2022 18:45:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233736AbiJZQo6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Oct 2022 12:44:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233764AbiJZQoz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Oct 2022 12:44:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0C71186F8;
        Wed, 26 Oct 2022 09:44:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FD3161FC1;
        Wed, 26 Oct 2022 16:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667D6C433D6;
        Wed, 26 Oct 2022 16:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666802691;
        bh=v2vJEnTUg412iPyFqVh3AU7lTJ8xlrRpmNsdJMgQONo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=z52xgPPJhqJZ1LUJNuyTcSUnCQgc2fk/LJ4wwshdKmoxYPho4SCkIZ/aG6EHKVCxB
         48VQ8+9/1zhMOcaLJu2wOTfpu4YpMByRygviQl9nHJI9JNgx6NTFcTBtGkhHmsYFqv
         3DERACnBjaeWMdeT9cyuCMHYigQ5Z1M8MR6rR1FM=
Date:   Wed, 26 Oct 2022 18:44:49 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Philip =?iso-8859-1?Q?M=FCller?= <philm@manjaro.org>
Subject: Re: [PATCH stable 5.10 0/5] kbuild: Fix compilation for latest
 pahole release
Message-ID: <Y1lkASXgeW0jfP8o@kroah.com>
References: <20221019085604.1017583-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019085604.1017583-1-jolsa@kernel.org>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 10:55:59AM +0200, Jiri Olsa wrote:
> hi,
> new version of pahole (1.24) is causing compilation fail for 5.10
> stable kernel, discussed in here [1][2]. Sending fix for that plus
> dependency patches.
> 
> thanks,
> jirka
> 
> 
> [1] https://lore.kernel.org/bpf/20220825163538.vajnsv3xcpbhl47v@altlinux.org/
> [2] https://lore.kernel.org/bpf/YwQRKkmWqsf%2FDu6A@kernel.org/
> ---
> Andrii Nakryiko (1):
>       kbuild: skip per-CPU BTF generation for pahole v1.18-v1.21
> 
> Ilya Leoshkevich (1):
>       bpf: Generate BTF_KIND_FLOAT when linking vmlinux
> 
> Javier Martinez Canillas (1):
>       kbuild: Quote OBJCOPY var to avoid a pahole call break the build
> 
> Jiri Olsa (1):
>       kbuild: Unify options for BTF generation for vmlinux and modules
> 
> Martin Rodriguez Reboredo (1):
>       kbuild: Add skip_encoding_btf_enum64 option to pahole
> 
>  Makefile                |  3 +++
>  scripts/link-vmlinux.sh |  2 +-
>  scripts/pahole-flags.sh | 21 +++++++++++++++++++++
>  3 files changed, 25 insertions(+), 1 deletion(-)
>  create mode 100755 scripts/pahole-flags.sh

Now queued up, thanks.

greg k-h
