Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0C93A15A9A5
	for <lists+stable@lfdr.de>; Wed, 12 Feb 2020 14:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727692AbgBLNES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Feb 2020 08:04:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:35246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725887AbgBLNES (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 Feb 2020 08:04:18 -0500
Received: from localhost (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8072120659;
        Wed, 12 Feb 2020 13:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581512657;
        bh=XcyBnDmREiLpeUlrKtLecu1iRGsoDxvbHjAQAQ0neVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CavNMyfy5j5HTJ+1TQ8oqg2WKNyX/ZQ+0MUJbeKLn9ibmiYV9kdhCmV8mblCtMY7k
         EZyu1gXLCGbxUm0i8UMdyBvrMQ/2H+H17+jrmyq3gDOz2jTiqp54s9t8WoqkMiMeVw
         GdzVLGgt6vaViMx/ikghb43q3QXISl2E8kooFeUY=
Date:   Wed, 12 Feb 2020 08:04:16 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Steven Clarkson <sc@lambdal.com>
Cc:     stable@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: Request to cherry pick 2b73ea379624 into 5.4.x and 5.5.x
Message-ID: <20200212130416.GA32735@sasha-vm>
References: <CAHKq8taawUbZWubQ8qzy05+qUKuCAYGy7kEZ-PkgPeFhode5gg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAHKq8taawUbZWubQ8qzy05+qUKuCAYGy7kEZ-PkgPeFhode5gg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 11, 2020 at 09:17:02PM -0800, Steven Clarkson wrote:
>Greg,
>
>Commit 2b73ea379624 ("x86/boot: Handle malformed SRAT tables during
>early ACPI parsing") fixes a boot hang on some ASUS motherboards with
>an older BIOS. Could you pull this into 5.4.x and 5.5.x? Should cherry
>pick cleanly into both.

I've queued it up for 5.5 and 5.4, thanks!

-- 
Thanks,
Sasha
