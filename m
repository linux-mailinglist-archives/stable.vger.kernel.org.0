Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32BC94636AD
	for <lists+stable@lfdr.de>; Tue, 30 Nov 2021 15:30:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242190AbhK3OeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Nov 2021 09:34:13 -0500
Received: from foss.arm.com ([217.140.110.172]:39722 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242174AbhK3OeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Nov 2021 09:34:12 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0DB281063;
        Tue, 30 Nov 2021 06:30:53 -0800 (PST)
Received: from e123427-lin.arm.com (unknown [10.57.34.132])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 6FACB3F5A1;
        Tue, 30 Nov 2021 06:30:51 -0800 (PST)
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     =?UTF-8?q?Krzysztof=20Wilczy=C5=84ski?= <kw@linux.com>,
        Andrew Murray <amurray@thegoodpenguin.co.uk>,
        Rob Herring <robh@kernel.org>,
        Toan Le <toan@os.amperecomputing.com>,
        Bjorn Helgaas <bhelgaas@google.com>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        =?UTF-8?q?St=C3=A9phane=20Graber?= <stgraber@ubuntu.com>,
        stable@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH] PCI: xgene: Fix IB window setup
Date:   Tue, 30 Nov 2021 14:30:46 +0000
Message-Id: <163828263383.20216.14338890370157557636.b4-ty@arm.com>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20211129173637.303201-1-robh@kernel.org>
References: <20211129173637.303201-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 29 Nov 2021 11:36:37 -0600, Rob Herring wrote:
> Commit 6dce5aa59e0b ("PCI: xgene: Use inbound resources for setup")
> broke PCI support on XGene. The cause is the IB resources are now sorted
> in address order instead of being in DT dma-ranges order. The result is
> which inbound registers are used for each region are swapped. I don't
> know the details about this h/w, but it appears that IB region 0
> registers can't handle a size greater than 4GB. In any case, limiting
> the size for region 0 is enough to get back to the original assignment
> of dma-ranges to regions.
> 
> [...]

Applied to pci/xgene, thanks!

[1/1] PCI: xgene: Fix IB window setup
      https://git.kernel.org/lpieralisi/pci/c/c7a75d0782

Thanks,
Lorenzo
