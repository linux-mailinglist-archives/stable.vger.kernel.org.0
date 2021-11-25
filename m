Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725DD45D935
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 12:27:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234748AbhKYLay (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 06:30:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:49714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233814AbhKYL3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 06:29:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A368B60EB5;
        Thu, 25 Nov 2021 11:26:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637839581;
        bh=jczHUeQXjJYRMSrlQiWOTRcjAF8eUNNDeHT/L6eZ3A0=;
        h=From:To:Cc:Subject:Date:From;
        b=s4BGN40G1sOJ4aksxnb9AlA0HzPVt4RsFrsZ2+OqjdJMP7CrOaaBfdZiVLNXcOjIl
         X/h7Tum2dwY4Zh7vg1WQ7N64eglUeYFxDRyASnDnrpg4CPDjo8/7IyZAqZeVDt3KZI
         P0JbDwhgFu/x9B5BRJX/KbUQpVANrMKO5Gp2IBXJgo88uhckwsuHy5WamEXojxG2qx
         NE283gIHZrgxKRfcfPBUkSc6558A20or1EK8/o7pmunT0gNjO4yPx9p0+6X882jMwf
         s4BqssiCuquBjFJQzAvCqqTc0C52IQK9RFVlXDz5zlD3wWQ+2vh4ziQov7qYjawz3S
         IBJK52jmJyHYw==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.10 0/5] Armada 3720 PCIe fixes for 5.10
Date:   Thu, 25 Nov 2021 12:26:07 +0100
Message-Id: <20211125112612.11501-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg, Sasha,

this series for 5.10-stable backports all the fixes (and their
dependencies) for Armada 3720 PCIe driver.
For 5.10 these are only changes to the pci-aardvark controller.

Marek

Marek Behún (1):
  PCI: aardvark: Deduplicate code in advk_pcie_rd_conf()

Pali Rohár (4):
  PCI: aardvark: Update comment about disabling link training
  PCI: aardvark: Implement re-issuing config requests on CRS response
  PCI: aardvark: Simplify initialization of rootcap on virtual bridge
  PCI: aardvark: Fix link training

 drivers/pci/controller/pci-aardvark.c | 235 +++++++++++---------------
 1 file changed, 99 insertions(+), 136 deletions(-)

-- 
2.32.0

