Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDCFC2F070F
	for <lists+stable@lfdr.de>; Sun, 10 Jan 2021 13:14:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726263AbhAJMOr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 10 Jan 2021 07:14:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:52076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726069AbhAJMOr (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 10 Jan 2021 07:14:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C660238E1;
        Sun, 10 Jan 2021 12:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610280846;
        bh=g9ViYPHPt0K15PWlJKJmyOcucEq5NZqkJRHOLX01QgQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=X3HNgh+IZJxoRkYjWez7bfhbAAx+BFCwsnElstNtRIFZGdcwgsgPaH89PHMAoPKLj
         9QxkGemoCaMJBlz+f97KC1esYxIJ+XFgmr6ewZP5KjZBIo62BEtFhXyOJ5VgYgE5HL
         uqAxgDdOoG7lbe9pMCua7hva4UWcGUNs/+h9L9o9Z34GCgtK2ExillKon44W2BqnhQ
         GtWntpACaH7dkCRd1ouFPdfyEKH8kiChRfuZwak7f/TfpZsFCLs2+nfQss/h792T0e
         HL1cUKioHhGRXxlXgFkaM7rY/Sgma+Nl1AvAnwi2rtJJB1hU5+xpN3YVDlyYZVjtl3
         5DKwWboDbXTXg==
Date:   Sun, 10 Jan 2021 07:14:05 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jan Kiszka <jan.kiszka@siemens.com>,
        Kieran Bingham <kieran@ksquared.org.uk>,
        Andrew Morton <akpm@linux-foundation.org>,
        Leonard Crestez <leonard.crestez@nxp.com>,
        =?iso-8859-1?Q?Andr=E9?= Draszik <git@andred.net>,
        Du Changbin <changbin.du@gmail.com>
Subject: Re: [stable 4.9.y 0/4] scripts/gdb Fixes for stable 4.9
Message-ID: <20210110121405.GJ4035784@sasha-vm>
References: <20210107225229.1502459-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210107225229.1502459-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jan 07, 2021 at 02:52:25PM -0800, Florian Fainelli wrote:
>Hi Greg, Sasha,
>
>This series contains some scripts/gdb/ fixes that are already present in
>newer stable kernels.

Queued up, thanks!

-- 
Thanks,
Sasha
