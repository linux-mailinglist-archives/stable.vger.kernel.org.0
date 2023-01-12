Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D504667236
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 13:29:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229619AbjALM3Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 07:29:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232960AbjALM3J (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 07:29:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F8534A945
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 04:29:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 042D860A6F
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 12:29:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5628C433EF;
        Thu, 12 Jan 2023 12:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673526547;
        bh=PjKUzGcb6w1aBlWJPtY6OreWmF686LpnPKFwsmhEnPM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o/ETbcKOkFzfwNGozgWW6Z22tcjtEU8yrOhSsjoRvmSHpevSUvEw34keMVz3GFvak
         sAhqXM1uW3ubUvkVKsrtB2ZvotV+nbm86RJuJ9NdVX8gdFb0c80JcxMfyywLgcr82M
         StcMu5So0qr+Hv21nJc3BZj02DBLivxpuCPYgDw0=
Date:   Thu, 12 Jan 2023 13:29:04 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Kyle Huey <me@kylehuey.com>
Cc:     stable@vger.kernel.org, Dave Hansen <dave.hansen@linux.intel.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Andy Lutomirski <luto@kernel.org>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Robert O'Callahan <robert@ocallahan.org>,
        David Manouchehri <david.manouchehri@riseup.net>
Subject: Re: Please apply fixes for PKRU/ptrace interaction to 6 series
 stable kernels
Message-ID: <Y7/9EFVVESaoD6f3@kroah.com>
References: <CAP045Aq6pgaimrV9DCJUnweWtJTRGyULf7vTAftuCCrdDWzRCg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAP045Aq6pgaimrV9DCJUnweWtJTRGyULf7vTAftuCCrdDWzRCg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 09, 2023 at 12:30:50PM -0800, Kyle Huey wrote:
> Hi Greg,
> 
> The following commits fix a regression introduced into the kernel in
> 5.14 (in e84ba47e313d). Please cherry-pick them for both the 6.1.y and
> the 6.0.y branches.
> 
> 6a877d2450ac x86/fpu: Take task_struct* in copy_sigframe_from_user_to_xstate()
> 1c813ce03055 x86/fpu: Add a pkru argument to copy_uabi_from_kernel_to_xstate().
> 2c87767c35ee x86/fpu: Add a pkru argument to copy_uabi_to_xstate()
> 4a804c4f8356 x86/fpu: Allow PKRU to be (once again) written by ptrace.
> d7e5aceace51 x86/fpu: Emulate XRSTOR's behavior if the xfeatures PKRU
> bit is not set
> 6ea25770b043 selftests/vm/pkeys: Add a regression test for setting
> PKRU through ptrace
> 
> 5.15.y requires adjusted patches and will be sent separately.

All now queued up, thanks.

greg k-h
