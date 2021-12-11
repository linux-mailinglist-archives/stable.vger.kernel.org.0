Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B86D5471351
	for <lists+stable@lfdr.de>; Sat, 11 Dec 2021 11:30:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230327AbhLKKaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Dec 2021 05:30:09 -0500
Received: from mail.skyhub.de ([5.9.137.197]:59986 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229514AbhLKKaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Dec 2021 05:30:09 -0500
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id 996BA1EC04E4;
        Sat, 11 Dec 2021 11:30:03 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1639218603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=OFU0/e93ujVogv8pWNt0Pl7Wd5sKiPXJ0aG+F6+2Af0=;
        b=Crj3p+bhEQQLHGg0RNxq/wjWtjaTnkRrbE65SsADoru7Xhg6FtpJ3t93SoU3k1oHrIVNuv
        x8pkpMSU7Y09ozgEBujVfGWFWI5vdEMYKwtpPFmFECIV+kBqGH5VAUCAd+qRm/qH6wlWuh
        ZHnHn4vtO0VQ3cSmKvw6KXBhwX/2jO0=
Date:   Sat, 11 Dec 2021 11:30:09 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     John Dorminy <jdorminy@redhat.com>
Cc:     Mike Rapoport <rppt@kernel.org>, Juergen Gross <jgross@suse.com>,
        tip-bot2@linutronix.de, anjaneya.chagam@intel.com,
        dan.j.williams@intel.com,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-tip-commits@vger.kernel.org, stable@vger.kernel.org,
        x86@kernel.org, Hugh Dickins <hughd@google.com>,
        "Patrick J. Volkerding" <volkerdi@gmail.com>
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and
 early param parsing
Message-ID: <YbR9seIcOWWYcvTQ@zn.tnic>
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
 <20211209143810.452527-1-jdorminy@redhat.com>
 <YbIeYIM6JEBgO3tG@zn.tnic>
 <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com>
 <YbIgsO/7oQW9h6wv@zn.tnic>
 <YbIu55LZKoK3IVaF@kernel.org>
 <YbIw1nUYJ3KlkjJQ@zn.tnic>
 <YbM5yR+Hy+kwmMFU@zn.tnic>
 <CAMeeMh9DVNJC+Q1HSB+DJzy_YKto=j=3iGUiCgseqmx9qjVCUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAMeeMh9DVNJC+Q1HSB+DJzy_YKto=j=3iGUiCgseqmx9qjVCUg@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Dec 11, 2021 at 12:24:25AM -0500, John Dorminy wrote:
> Apologies for delay; my dev machine was broken much of today. But I
> have tested this patch under the same conditions as previously, and
> agree with Hugh that the patches make mem= work correctly.
> 
> Thanks!

Thanks for testing!

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
