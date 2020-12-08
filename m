Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 731C02D281D
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 10:51:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727945AbgLHJtw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Dec 2020 04:49:52 -0500
Received: from mail.skyhub.de ([5.9.137.197]:60852 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727612AbgLHJtw (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Dec 2020 04:49:52 -0500
Received: from zn.tnic (p200300ec2f0f0800de4a64cb7778f3c5.dip0.t-ipconnect.de [IPv6:2003:ec:2f0f:800:de4a:64cb:7778:f3c5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 206B41EC026D;
        Tue,  8 Dec 2020 10:49:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1607420951;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=nHwrzM8sBYNzv3ZS/BVe63dW+mG8m9RUPLrJK5+MKCc=;
        b=V4UeYHj/eosomKIA9BRFUbVJfw6zHLgZzMrF7YI5efUMT6fFPsA7WJ+GaTTxd1v5FuWVM8
        anEiGoNi/O3FPInZWnkmxzB2yeYwXYuH7SI7HamwIaCZSfvEW7OnwEP5P9x9J7ISuanBCM
        HKJFqjKTLP/83HQIS9uvXCiHr2NkjSc=
Date:   Tue, 8 Dec 2020 10:49:07 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     tglx@linutronix.de, fenghua.yu@intel.com, tony.luck@intel.com,
        kuo-lang.tseng@intel.com, shakeelb@google.com,
        valentin.schneider@arm.com, mingo@redhat.com, babu.moger@amd.com,
        james.morse@arm.com, hpa@zytor.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH 1/3] x86/resctrl: Move setting task's active CPU in a
 mask into helpers
Message-ID: <20201208094907.GB27920@zn.tnic>
References: <cover.1607036601.git.reinette.chatre@intel.com>
 <77973e75a10bf7ef9b33c664544667deee9e1a8e.1607036601.git.reinette.chatre@intel.com>
 <20201207182912.GF20489@zn.tnic>
 <db6bea7e-b60b-2859-aa35-c3d2d5356eaa@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <db6bea7e-b60b-2859-aa35-c3d2d5356eaa@intel.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 07, 2020 at 01:24:51PM -0800, Reinette Chatre wrote:
> How about:
> "Move the setting of the CPU on which a task is running in a CPU mask into a
> couple of helpers.
> 
> There is no functional change. This is a preparatory change for the fix in
> the following patch from where the Fixes tag is copied."

Almost. Just not call it a "following patch" because once this is
applied, the following one might be a different one depending on the
ordering a git command has requested. So a "later patch" would be
probably better.

> Correct. I will add it. The addition to the commit message above aims to
> explain a Fixes tag to a patch with no functional changes.

Yes but you need to tell the stable people somehow that this one is a
prerequisite and that they should pick it up too.

Unless you can reorg your code this way that you don't need patch 1...

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
