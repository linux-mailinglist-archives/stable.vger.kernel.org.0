Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 10BDD591A80
	for <lists+stable@lfdr.de>; Sat, 13 Aug 2022 15:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239440AbiHMNMo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 13 Aug 2022 09:12:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51274 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239434AbiHMNMn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 13 Aug 2022 09:12:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05F4026ACE
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 06:12:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B25B5B8015A
        for <stable@vger.kernel.org>; Sat, 13 Aug 2022 13:12:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 249D3C4314B;
        Sat, 13 Aug 2022 13:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660396354;
        bh=oCz+YsCPO21uQC6aTqV/OYwGccfP4dNmQHy448YBMCY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ssocc9iKBVaZ28MYuOkDl1R+MetLItuaODuKrn2Tnv7CdQyzXH0wQLeIjuVK0taBg
         Sawq3D7hiAV81b3Ss+7QY9D4QhNHYE3TAePAWj+p7TTFGSD4GvL7iqC1fc3cjMUoK4
         YxrRo4jmFOwFj1U+zNbrgH3RGHDiyDX9TaNCaSAM=
Date:   Sat, 13 Aug 2022 15:12:31 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Ovidiu Panait <ovidiu.panait@windriver.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 4.19 0/4] bpf: fix CVE-2021-4159
Message-ID: <YvejP3g2TJWgicGq@kroah.com>
References: <20220809073947.33804-1-ovidiu.panait@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809073947.33804-1-ovidiu.panait@windriver.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 10:39:43AM +0300, Ovidiu Panait wrote:
> All verifier selftests pass in qemu for x86-64 with this series applied:
> root@intel-x86-64:~# ./test_verifier
> ...
> #664/p mov64 src == dst OK
> #665/p mov64 src != dst OK
> #666/u calls: ctx read at start of subprog OK
> #666/p calls: ctx read at start of subprog OK
> Summary: 932 PASSED, 0 SKIPPED, 0 FAILED
> 
> Jean-Philippe Brucker (1):
>   selftests/bpf: Fix "dubious pointer arithmetic" test
> 
> John Fastabend (1):
>   bpf: Verifer, adjust_scalar_min_max_vals to always call
>     update_reg_bounds()
> 
> Maxim Mikityanskiy (1):
>   selftests/bpf: add selftest part of "bpf: Fix the off-by-two error in
>     range markings"
> 
> Stanislav Fomichev (1):
>   selftests/bpf: Fix test_align verifier log patterns
> 
>  kernel/bpf/verifier.c                       |  1 +
>  tools/testing/selftests/bpf/test_align.c    | 41 +++++++++++----------
>  tools/testing/selftests/bpf/test_verifier.c | 32 ++++++++--------
>  3 files changed, 38 insertions(+), 36 deletions(-)
> 
> -- 
> 2.37.1
> 

Patches 2-4 now queued up, thanks.

greg k-h
