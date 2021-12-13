Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7CA2472247
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 09:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231484AbhLMIUg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 03:20:36 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:38854 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232817AbhLMIUg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 03:20:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92256B80DD9;
        Mon, 13 Dec 2021 08:20:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B09FC00446;
        Mon, 13 Dec 2021 08:20:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639383633;
        bh=hgp2kfj4sMh9M5IsmMQHKVZep1Z/4vAaLFQJLHd+DHA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FN1txgq77CBgC6qc66+DTBt8mKPhyfVt1b3q+XHcpKxyVsxBOIK3CtQZU7nU12sIo
         kFx7cCjFX61T4rNbPVMx+5mJlhsLHQLq1GW73ZZNmSD52Vr8CvwEufosh8HSgvLnxM
         Z/lItCbAyhZHXcWJKYP4sUx+YcNND4Via17FZl8PSJDS+JpWnk3vyq+r1nPVDfVEOf
         OCOrdrA7TtD4xn46PIozSRW2R7Dv+kw9tEUvK9b9D6C7wIsuD/GtFDxCWTXsZuuc9t
         zLajLSTMCfpsKH9/kLKSrI1aU5PbhbAD5n2ELsE/2fQ6LfZzbSSbwFvXii4PL73+/h
         BFUoFEwxslc9w==
Date:   Mon, 13 Dec 2021 10:20:03 +0200
From:   Mike Rapoport <rppt@kernel.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Juergen Gross <jgross@suse.com>,
        John Dorminy <jdorminy@redhat.com>, tip-bot2@linutronix.de,
        anjaneya.chagam@intel.com, dan.j.williams@intel.com,
        linux-kernel@vger.kernel.org, linux-tip-commits@vger.kernel.org,
        stable@vger.kernel.org, x86@kernel.org,
        Hugh Dickins <hughd@google.com>,
        "Patrick J. Volkerding" <volkerdi@gmail.com>
Subject: Re: [tip: x86/urgent] x86/boot: Pull up cmdline preparation and
 early param parsing
Message-ID: <YbcCM81Fig3GC4Yi@kernel.org>
References: <163697618022.414.12673958553611696646.tip-bot2@tip-bot2>
 <20211209143810.452527-1-jdorminy@redhat.com>
 <YbIeYIM6JEBgO3tG@zn.tnic>
 <50f25412-d616-1cc6-f07f-a29d80b4bd3b@suse.com>
 <YbIgsO/7oQW9h6wv@zn.tnic>
 <YbIu55LZKoK3IVaF@kernel.org>
 <YbIw1nUYJ3KlkjJQ@zn.tnic>
 <YbM5yR+Hy+kwmMFU@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YbM5yR+Hy+kwmMFU@zn.tnic>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Dec 10, 2021 at 12:28:09PM +0100, Borislav Petkov wrote:
> On Thu, Dec 09, 2021 at 05:37:42PM +0100, Borislav Petkov wrote:
> > Whatever we do, it needs to be tested by all folks on Cc who already
> > reported regressions, i.e., Anjaneya, Hugh, John and Patrick.
> 
> Ok, Mike is busy so here are some patches for testing:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/bp/bp.git/log/?h=rc4-boot

Thanks for taking care of this!

-- 
Sincerely yours,
Mike.
