Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4847445DBE7
	for <lists+stable@lfdr.de>; Thu, 25 Nov 2021 15:06:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232805AbhKYOJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 25 Nov 2021 09:09:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:37632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1350648AbhKYOHc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 25 Nov 2021 09:07:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6EFF610A7;
        Thu, 25 Nov 2021 14:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637849060;
        bh=5MQLTP9TTP/MuahLWmLPDrE3QfcXEHM3WH5wcRF/DPE=;
        h=From:To:Cc:Subject:Date:From;
        b=ZTkgQK8Q8oBAJCXU1UhJsIf5eTvlohrfNqgIM80BVV2GrYLBxReMOz5xrvRFC2V5N
         2H9CWks2eFqa8VJuGHaNoVJly3qyg+0sXsWtcKQDUhHUsrTNXtO3vtmS66SgK/hHxP
         l2H5C9AIs314SsON5O4DztvnnTBnBdGJf+4jEMUfXm1fuLNcYTGKsv1NiYhvEv59Xs
         Y5fHeqHbfo4YBJz2CO7hdt5A3QlhZwu+H5UBdalc0V8JFW4xRuY+OLGtfHMTwFdlN1
         t1yLKGbumbpXlVltpE5iHvJIxBrvTORqULrW5hqGaiT6pWeDY4DTpWyO2ucl+jq8Sx
         KWlSGktgo/OQA==
From:   =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>
Cc:     pali@kernel.org, stable@vger.kernel.org,
        =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>
Subject: [PATCH 5.15 0/4] Armada 3720 PCIe fixes for 5.15
Date:   Thu, 25 Nov 2021 15:04:12 +0100
Message-Id: <20211125140416.15181-1-kabel@kernel.org>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Greg, Sasha,

this series for 5.15-stable backports all the fixes (and their
dependencies) for Armada 3720 PCIe driver.
For 5.15 these are only changes to the pci-aardvark controller.

Marek

Marek Behún (1):
  PCI: aardvark: Deduplicate code in advk_pcie_rd_conf()

Pali Rohár (3):
  PCI: aardvark: Implement re-issuing config requests on CRS response
  PCI: aardvark: Simplify initialization of rootcap on virtual bridge
  PCI: aardvark: Fix link training

 drivers/pci/controller/pci-aardvark.c | 242 +++++++++++---------------
 1 file changed, 99 insertions(+), 143 deletions(-)

-- 
2.32.0

