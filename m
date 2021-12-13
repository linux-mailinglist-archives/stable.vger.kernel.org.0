Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4EF1472427
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 10:34:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232464AbhLMJe1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 04:34:27 -0500
Received: from mail.skyhub.de ([5.9.137.197]:46294 "EHLO mail.skyhub.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234110AbhLMJd6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Dec 2021 04:33:58 -0500
Received: from zn.tnic (dslb-088-067-202-008.088.067.pools.vodafone-ip.de [88.67.202.8])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.skyhub.de (SuperMail on ZX Spectrum 128k) with ESMTPSA id BD41C1EC0453;
        Mon, 13 Dec 2021 10:33:52 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=alien8.de; s=dkim;
        t=1639388032;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:in-reply-to:in-reply-to:  references:references;
        bh=1huGVmkguuzzMxIZ2Dja7uTDx6LCZKFCFZ0VWUfUYIU=;
        b=it0BEgU6aEhs9+HfPB1v/QGqueENQox0QLT0EkEyqtCdYJBuT8sVYAEo4af49viEz9bwxH
        9ZifKJOTKYNreGa3RvnTO/XP3v5kOwQA7D2+ixnhCAHaBxWI8FoGvxlFjbxGGqcUDK9ZN+
        cpinYkRWyxKRXX/taMzPnsqhHFtEqhA=
Date:   Mon, 13 Dec 2021 10:33:53 +0100
From:   Borislav Petkov <bp@alien8.de>
To:     Mike Rapoport <rppt@kernel.org>
Cc:     Juergen Gross <jgross@suse.com>,
        John Dorminy <jdorminy@redhat.com>, tip-bot2@linutronix.de,
        anjaneya.chagam@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        stable@vger.kernel.org, x86@kernel.org,
        Hugh Dickins <hughd@google.com>,
        "Patrick J. Volkerding" <volkerdi@gmail.com>
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and
 early param parsing
Message-ID: <YbcTgQdTpJAHAZw4@zn.tnic>
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
 <20211209143810.452527-1-jdorminy@redhat.com>
 <YbIeYIM6JEBgO3tG@zn.tnic>
 <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com>
 <YbIgsO/7oQW9h6wv@zn.tnic>
 <YbIu55LZKoK3IVaF@kernel.org>
 <YbIw1nUYJ3KlkjJQ@zn.tnic>
 <YbM5yR+Hy+kwmMFU@zn.tnic>
 <YbcCM81Fig3GC4Yi@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YbcCM81Fig3GC4Yi@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 13, 2021 at 10:20:03AM +0200, Mike Rapoport wrote:
> Thanks for taking care of this!

Sure, no probs.

Lemme send them out officially so they're on the list. Will queue them
this week.

Thx.

-- 
Regards/Gruss,
    Boris.

https://people.kernel.org/tglx/notes-about-netiquette
