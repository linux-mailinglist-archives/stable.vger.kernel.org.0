Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27D25575AF5
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 07:25:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbiGOFZv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 01:25:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229730AbiGOFZt (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 01:25:49 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E2BE79EE1;
        Thu, 14 Jul 2022 22:25:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA8D7B82A9C;
        Fri, 15 Jul 2022 05:25:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94F7FC341C6;
        Fri, 15 Jul 2022 05:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657862746;
        bh=LibR5gdvV1FppPi6j75ld0+91VGoEGhnyLiUEP6tYQ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=mtMKX97g3Hj6YyhNNICTmKA5pXMgFEWWpCPjBDfGUw5IYNXyXHPCnsnk4MlOZ+s8c
         1TqvylvtTct8JUGejaqXrdKyK4l96fFrfPmGwZ5baFt0YO/wvEr0VOPbx6BYCDa2gV
         W7WJxSabjjXH0SAQq1ZVU+e3upO2rVp51qr10OLk=
Date:   Fri, 15 Jul 2022 07:25:43 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        antonio.gomez.iglesias@linux.intel.com,
        Josh Poimboeuf <jpoimboe@kernel.org>
Subject: Re: [PATCH v2] x86/bugs: Warn when "ibrs" mitigation is selected on
 Enhanced IBRS parts
Message-ID: <YtD6V5i0rS3szVIX@kroah.com>
References: <0456b35fb9ef957d9a9138e0913fb1a3fd445dff.1657747493.git.pawan.kumar.gupta@linux.intel.com>
 <2a5eaf54583c2bfe0edc4fea64006656256cca17.1657814857.git.pawan.kumar.gupta@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a5eaf54583c2bfe0edc4fea64006656256cca17.1657814857.git.pawan.kumar.gupta@linux.intel.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jul 14, 2022 at 04:15:35PM -0700, Pawan Gupta wrote:
> IBRS mitigation for spectre_v2 forces write to MSR_IA32_SPEC_CTRL at
> every kernel entry/exit. On Enhanced IBRS parts setting
> MSR_IA32_SPEC_CTRL[IBRS] only once at boot is sufficient. MSR writes at
> every kernel entry/exit incur unnecessary performance loss.
> 
> When Enhanced IBRS feature is present, print a warning about this
> unnecessary performance loss.
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> ---
> v1->v2: Instead of changing the mitigation, print a warning about the
>         perf loss.
> 
> v1: https://lore.kernel.org/lkml/0456b35fb9ef957d9a9138e0913fb1a3fd445dff.1657747493.git.pawan.kumar.gupta@linux.intel.com/
> 
>  arch/x86/kernel/cpu/bugs.c | 3 +++
>  1 file changed, 3 insertions(+)

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
