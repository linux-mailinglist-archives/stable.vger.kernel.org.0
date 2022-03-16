Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 99EBD4DAE9C
	for <lists+stable@lfdr.de>; Wed, 16 Mar 2022 12:02:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355235AbiCPLDp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Mar 2022 07:03:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355228AbiCPLDp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 16 Mar 2022 07:03:45 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 573706007A
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 04:02:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C0D01CE1E83
        for <stable@vger.kernel.org>; Wed, 16 Mar 2022 11:02:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CFECC340E9;
        Wed, 16 Mar 2022 11:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647428548;
        bh=EcbZuPIvl8hAdXas6MQyY9QfFIA/SV5L7+6wbrwpYMU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MLEPyJKOZ60dtR+6GXyzVQDGjKArW3zlhxGlfLPAH0Js5HW+NpspyFCfQXlr7ZL6s
         xFU9NPLX+c2svXPzbfkrgDl0gve8GqYho5Xg8M0ftR1vQPv0lsLAW+s6Ol0nveJ//4
         5H0MDyRkkDGYzA9hT6ATZIOOFMBWoQovmtoma0IY=
Date:   Wed, 16 Mar 2022 12:02:23 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     stable@vger.kernel.org
Subject: Re: question about one acpi-cpufreq commit
Message-ID: <YjHDv1UngGPGr0je@kroah.com>
References: <87723ab6-2aa7-cf7f-0e91-38a35b29f92b@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <87723ab6-2aa7-cf7f-0e91-38a35b29f92b@linux.dev>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 16, 2022 at 04:56:11PM +0800, Guoqing Jiang wrote:
> Hi,
> 
> I just found the commit in 5.10 stable kernel.
> 
> stable-linux> git tag --sort=taggerdate --contain
> 8a3fc32b322cc3081dd3569047c9834f496b4ab0 | head -1
> v5.10.17
> 
> commit 8a3fc32b322cc3081dd3569047c9834f496b4ab0
> Author: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> Date:   Thu Feb 4 18:25:37 2021 +0100
> 
>     cpufreq: ACPI: Extend frequency tables to cover boost frequencies
> 
>     commit 3c55e94c0adea4a5389c4b80f6ae9927dd6a4501 upstream.
> 
>    [ ... ]
> 
>     Fixes: 41ea667227ba ("x86, sched: Calculate frequency invariance for AMD
> systems")
>     Fixes: 976df7e5730e ("x86, sched: Use midpoint of max_boost and max_P
> for frequency invariance on AMD EPYC")
>     Fixes: db865272d9c4 ("cpufreq: Avoid configuring old governors as
> default with intel_pstate")
> 
> Except db865272d9c4 was applied in v5.10-rc2, the others (41ea667227ba and
> 976df7e5730e)
> were first appeared in v5.11-rc1.
> 
> linux> git tag --sort=taggerdate --contain 41ea667227ba | head -1
> v5.11-rc1
> linux> git tag --sort=taggerdate --contain 976df7e5730e | head -1
> v5.11-rc1
> linux> git tag --sort=taggerdate --contain db865272d9c4 | head -1
> v5.10-rc2
> 
> So I am wondering if the mentioned commit is suitable for 5.10 stable
> kernel, or what am I missing?

Is it causing a problem for you?  What is the issue with having it in
the 5.10.y tree?

thanks,

greg k-h
