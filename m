Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E9EE112E81B
	for <lists+stable@lfdr.de>; Thu,  2 Jan 2020 16:33:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728685AbgABPdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Jan 2020 10:33:20 -0500
Received: from mx2.suse.de ([195.135.220.15]:58282 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728649AbgABPdT (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 2 Jan 2020 10:33:19 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F0B80ACF6;
        Thu,  2 Jan 2020 15:33:17 +0000 (UTC)
Date:   Thu, 2 Jan 2020 16:33:10 +0100
From:   Borislav Petkov <bp@suse.de>
To:     Sasha Levin <sashal@kernel.org>
Cc:     gregkh@linuxfoundation.org, jschoenh@amazon.de,
        Yazen.Ghannam@amd.com, hpa@zytor.com, linux-edac@vger.kernel.org,
        mingo@kernel.org, stable@vger.kernel.org, tglx@linutronix.de,
        tony.luck@intel.com, x86@kernel.org
Subject: Re: FAILED: patch "[PATCH] x86/mce: Fix possibly incorrect severity
 calculation on AMD" failed to apply to 4.19-stable tree
Message-ID: <20200102153310.GB22772@zn.tnic>
References: <157763491612458@kroah.com>
 <20191230155621.GA30811@zn.tnic>
 <20200102011411.GF16372@sasha-vm>
 <20200102091133.GA22772@zn.tnic>
 <20200102122923.GJ16372@sasha-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200102122923.GJ16372@sasha-vm>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 02, 2020 at 07:29:23AM -0500, Sasha Levin wrote:
> Not really as he usually picks up stable tagged patches way before
> AUTOSEL even looks at them,

Ok, then next time I'll simply wait. It will pick it up eventually. :-)

-- 
Regards/Gruss,
    Boris.

SUSE Software Solutions Germany GmbH, GF: Felix Imendörffer, HRB 36809, AG Nürnberg
