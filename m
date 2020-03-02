Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 413E9175EA3
	for <lists+stable@lfdr.de>; Mon,  2 Mar 2020 16:45:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgCBPoO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Mar 2020 10:44:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:33626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727083AbgCBPoO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Mar 2020 10:44:14 -0500
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A055E21D56;
        Mon,  2 Mar 2020 15:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583163853;
        bh=CWBNUH2iAItyg2A93sPqWmwmyEV6bIPLx/P3HYth4/4=;
        h=Date:From:To:To:To:Cc:Cc:Cc:Subject:In-Reply-To:References:From;
        b=xRqzpRf2OwPOk6nVJMSOUFD5Kz9OZO6gMIIszyK0Do3n4PDQm3c5PZ1HvC260UKxt
         AfkaED0lepnfhEOer45zHo2Nz68djFSw+vSQunx4dm8+KG/qcHmEetRE2UdswkEBmo
         1dRfdPkstfTjQeOmwMqckzc5CqWXqnmwwZYi0Vyo=
Date:   Mon, 02 Mar 2020 15:44:12 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>
To:     axboe@kernel.dk
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>
Cc:     stable@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] ahci: Add Intel Comet Lake H RAID PCI ID
In-Reply-To: <20200227122822.14059-1-kai.heng.feng@canonical.com>
References: <20200227122822.14059-1-kai.heng.feng@canonical.com>
Message-Id: <20200302154413.A055E21D56@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a -stable tag.
The stable tag indicates that it's relevant for the following trees: all

The bot has tested the following trees: v5.5.6, v5.4.22, v4.19.106, v4.14.171, v4.9.214, v4.4.214.

v5.5.6: Build OK!
v5.4.22: Build OK!
v4.19.106: Build OK!
v4.14.171: Failed to apply! Possible dependencies:
    ebb82e3c79d2 ("ahci: Allow setting a default LPM policy for mobile chipsets")

v4.9.214: Failed to apply! Possible dependencies:
    7fab72f85d86 ("libata: Add the AHCI_HFLAG_NO_WRITE_TO_RO flag")
    ebb82e3c79d2 ("ahci: Allow setting a default LPM policy for mobile chipsets")
    ef0da1bf767d ("libata: Add the AHCI_HFLAG_YES_ALPM flag")

v4.4.214: Failed to apply! Possible dependencies:
    7fab72f85d86 ("libata: Add the AHCI_HFLAG_NO_WRITE_TO_RO flag")
    d684a90d38e2 ("ahci: per-port msix support")
    ebb82e3c79d2 ("ahci: Allow setting a default LPM policy for mobile chipsets")
    ef0da1bf767d ("libata: Add the AHCI_HFLAG_YES_ALPM flag")
    f893180b79f6 ("ahci: compile out msi/msix infrastructure")
    fb3296335500 ("drivers: ata: wake port before DMA stop for ALPM")


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
