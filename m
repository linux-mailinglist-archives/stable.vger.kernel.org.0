Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F28FB12E441
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 10:11:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727842AbgABJLp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 04:11:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:46736 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727801AbgABJLp (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 04:11:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 22AA0B1DB;
        Thu,  2 Jan 2020 09:11:43 +0000 (UTC)
Date:   Thu, 2 Jan 2020 10:11:34 +0100
From:   Borislav Petkov <bp@suse.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, jschoenh@amazon.de,
        Yazen.Ghannam@amd.com, hpa@zytor.com, linux-edac@vger.kernel.org,
        mingo@kernel.org, stable@vger.kernel.org, tglx@linutronix.de,
        tony.luck@intel.com, x86@kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/mce: Fix possibly incorrect severity
 calculation on AMD" failed to apply to 4.19-stable tree
Message-ID: <20200102091133.GA22772@zn.tnic>
References: <157763491612458@kroah.com>
 <20191230155621.GA30811@zn.tnic>
 <20200102011411.GF16372@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200102011411.GF16372@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Jan 01, 2020 at 08:14:11PM -0500, Sasha Levin wrote:
> On Mon, Dec 30, 2019 at 04:56:21PM +0100, Borislav Petkov wrote:
> > On Sun, Dec 29, 2019 at 04:55:16PM +0100, gregkh@linuxfoundation.org wrote:
> > > The patch below does not apply to the 4.19-stable tree.
> > > If someone wants it applied there, or to any other stable or longterm
> > > tree, then please email the backport, including the original git commit
> > > id to <stable@vger.kernel.org>.
> > 
> > Here's a backport for all 4.x stable series. It only needed a
> > file-rename.
> 
> This ended up getting picked up by AUTOSEL which did the right thing
> with regards to filename changes as confirmed with the provided
> backport, thank you :)

Can Greg find out whether AUTOSEL did the right thing and then if so, not
send those mails?

:-)

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
