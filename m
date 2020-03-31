Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E909C199715
	for <lists+stable@lfdr.de>; Tue, 31 Mar 2020 15:11:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730951AbgCaNL3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 31 Mar 2020 09:11:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40096 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730946AbgCaNL3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 31 Mar 2020 09:11:29 -0400
Received: from localhost (unknown [137.135.114.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE69F2137B;
        Tue, 31 Mar 2020 13:11:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585660289;
        bh=h8dQvdWDnXNj+3sbtyq/jpBGmi1cyj9KIHH1gwtXnss=;
        h=Date:From:To:To:To:To:To:Cc:Cc:Cc:Cc:Cc:Subject:In-Reply-To:
         References:From;
        b=EJm6mnZuMze49ZjPb7R1ryUJGjATEkfm72UJ2ej3wXznSQrro46fiXWJBKNPt8iFT
         qwDqGcyUU+biDOH7E9ncS08Kz1j7TR6yukFbmPEzgD4vLC8hTchTGv92ZMIZhvv4nr
         V005pouVxckcxy66ApejYC+IckSPsWyPjoHjGFcs=
Date:   Tue, 31 Mar 2020 13:11:28 +0000
From:   Sasha Levin <sashal@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
To:     Ashok Raj <ashok.raj@intel.com>
To:     linux-pci@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>
To:     Bjorn Helgaas <bhelgaas@google.com>
To:     linux-pci@vger.kernel.org
Cc:     Ashok Raj <ashok.raj@intel.com>, linux-kernel@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Cc:     Ashok Raj <ashok.raj@intel.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] pci: Fixes MaxPayloadSize (MPS) programming for RCiEP devices.
In-Reply-To: <1585343775-4019-1-git-send-email-ashok.raj@intel.com>
References: <1585343775-4019-1-git-send-email-ashok.raj@intel.com>
Message-Id: <20200331131128.DE69F2137B@mail.kernel.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi

[This is an automated email]

This commit has been processed because it contains a "Fixes:" tag
fixing commit: 9dae3a97297f ("PCI: Move MPS configuration check to pci_configure_device()").

The bot has tested the following trees: v5.5.13, v5.4.28, v4.19.113, v4.14.174, v4.9.217, v4.4.217.

v5.5.13: Build OK!
v5.4.28: Build OK!
v4.19.113: Build OK!
v4.14.174: Build OK!
v4.9.217: Build OK!
v4.4.217: Build failed! Errors:
    drivers/pci/probe.c:1357:4: error: implicit declaration of function ‘pci_warn’; did you mean ‘pr_warn’? [-Werror=implicit-function-declaration]


NOTE: The patch will not be queued to stable trees until it is upstream.

How should we proceed with this patch?

-- 
Thanks
Sasha
