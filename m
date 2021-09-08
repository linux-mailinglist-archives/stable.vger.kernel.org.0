Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5369A40383E
	for <lists+stable@lfdr.de>; Wed,  8 Sep 2021 12:52:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347834AbhIHKyD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Sep 2021 06:54:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348884AbhIHKyC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Sep 2021 06:54:02 -0400
Received: from mail.skyhub.de (mail.skyhub.de [IPv6:2a01:4f8:190:11c2::b:1457])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1D60C061575;
        Wed,  8 Sep 2021 03:52:54 -0700 (PDT)
Received: from zn.tnic (p200300ec2f0efc002d1ac0b1b41b9169.dip0.t-ipconnect.de [IPv6:2003:ec:2f0e:fc00:2d1a:c0b1:b41b:9169])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 823EB1EC0246;
        Wed,  8 Sep 2021 12:52:52 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1631098372;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=/c1i7MJmMtvpNZUmYoO8pHyXNL8x7+xg5ZYSPs97nbA=;
        b=jr+NflkNApcbMcE3x32XD/UX7p/0fqIF65IsSvGVzESGORog8godikPznZVkEHWAEfDZp/
        3cJpFWYdwvZIYVjJoVqIb18N+9kITRR9p/Hy2pBWEoAPDfgBtrObF1m218D0WEFw/Run5F
        lcaRmegenetKjtMzrdNH5JFrk8D+7M8=
Date:   Wed, 8 Sep 2021 12:52:45 +0200
From:   Borislav Petkov <bp@alien8.de>
To:     Dave Hansen <dave.hansen@intel.com>,
        Mike Rapoport <rppt@kernel.org>
Cc:     x86@kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Andy Lutomirski <luto@kernel.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        David Hildenbrand <david@redhat.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Oscar Salvador <osalvador@suse.de>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] x86/mm: fix kern_addr_valid to cope with existing but
 not present entries
Message-ID: <YTiV/Sdm/T/jnsHC@zn.tnic>
References: <20210819132717.19358-1-rppt@kernel.org>
 <35f4a263-1001-5ba5-7b6c-3fcc5f93cc30@intel.com>
 <YTiR6aK6XKJ4z0wH@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YTiR6aK6XKJ4z0wH@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 08, 2021 at 12:35:21PM +0200, Borislav Petkov wrote:
> So I did stare at this for a while, trying to make sense of it and David
> Hildenbrand asked for a Fixes: tag in v1 review and from doing a bit of
> git archeology I think it should be:
> 
> c40a56a7818c ("x86/mm/init: Remove freed kernel image areas from alias mapping")
> 
> because that thing added the clearing of the Present bit for the high
> kernel image mapping of those areas.
> 
> Right?

Hmm, but that commit is in v4.19. Mike has added

Cc: <stable@vger.kernel.org>    # 4.4+

Mike, why 4.4 and newer?

Hmmm.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
