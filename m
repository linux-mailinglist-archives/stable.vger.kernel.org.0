Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 310555AC4A5
	for <lists+stable@lfdr.de>; Sun,  4 Sep 2022 16:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233625AbiIDOKS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 4 Sep 2022 10:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230261AbiIDOKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 4 Sep 2022 10:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D0C418B00;
        Sun,  4 Sep 2022 07:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 29464B80D7E;
        Sun,  4 Sep 2022 14:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6100CC433D6;
        Sun,  4 Sep 2022 14:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662300612;
        bh=rXDDqtq4k9eNNjaHnvTNPyJjC4tPfigZUBuDkbKbVPo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j0Zp9YVK9D/+xrTCie4zJ31a4+4iC/289n0gGnFbotYCwffYO7gkCMrVjrDykUAur
         t55FtO7ql6YFnoUdJqwnLFp6wAtHPzkJJOf7/jukr1v0/kUeq3Jbl0fBzc2L+aqb+R
         ZfAjbGyIAjHPiy46QdgHPD+EM97BkE625JyrF0xk=
Date:   Sun, 4 Sep 2022 16:10:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     stable@vger.kernel.org, bpf@vger.kernel.org,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Rodriguez Reboredo <yakoyoku@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>
Subject: Re: [PATCH stable 5.15 0/2] kbuild: Fix compilation for latest
 pahole release
Message-ID: <YxSxwZWkYMmtcsmA@kroah.com>
References: <20220904131901.13025-1-jolsa@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220904131901.13025-1-jolsa@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Sep 04, 2022 at 03:18:59PM +0200, Jiri Olsa wrote:
> hi,
> new version of pahole (1.24) is causing compilation fail for 5.15
> stable kernel, discussed in here [1][2]. Sending fix for that plus
> one dependency patch.
> 
> Note for patch 1:
> there was one extra line change in scripts/pahole-flags.sh file in
> its linux tree merge commit:
> 
>   fc02cb2b37fe Merge tag 'net-next-for-5.16' of git://git.kernel.org/pub/scm/linux/kernel/git/netdev/net-next
> 
> not sure how/if to track that, I squashed the change in.

Squashing is fine, thanks.

And do we also need this for kernels older than 5.15?  Like 5.10 and 5.4?

thanks,

greg k-h
