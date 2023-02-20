Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8178469CE93
	for <lists+stable@lfdr.de>; Mon, 20 Feb 2023 15:00:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbjBTOAW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Feb 2023 09:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52584 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232755AbjBTOAR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Feb 2023 09:00:17 -0500
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E70D40C7
        for <stable@vger.kernel.org>; Mon, 20 Feb 2023 05:59:48 -0800 (PST)
Received: from zn.tnic (p5de8e9fe.dip0.t-ipconnect.de [93.232.233.254])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id CDA691EC0513;
        Mon, 20 Feb 2023 14:59:39 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1676901579;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=tCYvyOqhfIrLXDGC2COxtQVEV4VuiZ4YWC2Ms3TU5gk=;
        b=BNYLltKUVGjjRGBxCi6MkaAwwSQNLQ9EBVVHCgqHYYhPYNnpmA6M6c4Xk2JgoM94Q20fLE
        3LfCNHhFnRWRhYY3fsi+qsf/eT/f8445c7nbZGAwDv/VsiNQzadau9aIfA1bzXDX3xmmRl
        j8BY4HODilEXUoo+TAHjAnXcJ4i1gP0=
Date:   Mon, 20 Feb 2023 14:59:35 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     KP Singh <kpsingh@kernel.org>
Cc:     Greg KH <gregkh@linuxfoundation.org>, security@kernel.org,
        pjt@google.com, evn@google.com, jpoimboe@kernel.org,
        tglx@linutronix.de, mingo@redhat.com, dave.hansen@linux.intel.com,
        x86@kernel.org, hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        =?utf-8?B?Sm9zw6k=?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>,
        Jim Mattson <jmattson@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH] x86/speculation: Fix user-mode spectre-v2 protection
 with KERNEL_IBRS
Message-ID: <Y/N8x4/upZmYlB51@zn.tnic>
References: <20230220103930.1963742-1-kpsingh@kernel.org>
 <Y/NQ6w4UlEuBSTql@kroah.com>
 <CACYkzJ7Umq_XQEAHZyPE60zhbWsSF_i-vNa7u_qCeqBgGVfC4g@mail.gmail.com>
 <Y/NXbz9V840KnVYh@kroah.com>
 <CACYkzJ44dwK8HZFnLNOvGSS_Uo3U0NUP_a41+t6oc8d=UAqRwA@mail.gmail.com>
 <Y/Nbu2p9CGG/nwcW@kroah.com>
 <CACYkzJ73cV-DHkXnKVLTL9-+ToB=y08VWXxvqxTNpLrVbs_wTw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CACYkzJ73cV-DHkXnKVLTL9-+ToB=y08VWXxvqxTNpLrVbs_wTw@mail.gmail.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 20, 2023 at 03:48:33AM -0800, KP Singh wrote:
> until I was nudged to read
> https://people.kernel.org/tglx/notes-about-netiquette.

I think you misread my signature. It gets added by my mail client to
*every* mail I send. See below.

So it had only tangentially to do with your situation.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
