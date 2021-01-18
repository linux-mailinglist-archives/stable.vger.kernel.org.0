Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0502C2FA4F8
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 16:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393428AbhARPjp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 10:39:45 -0500
Received: from foss.arm.com ([217.140.110.172]:38178 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393360AbhARPjk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 10:39:40 -0500
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DFA59D6E;
        Mon, 18 Jan 2021 07:38:54 -0800 (PST)
Received: from e123427-lin.arm.com (unknown [10.57.56.252])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 2192A3F68F;
        Mon, 18 Jan 2021 07:38:51 -0800 (PST)
From:   Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        linux-arm-msm@vger.kernel.org,
        Stanimir Varbanov <svarbanov@mm-sol.com>,
        stable@vger.kernel.org,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Rob Herring <robh@kernel.org>, linux-pci@vger.kernel.org,
        Sham Muthayyan <smuthayy@codeaurora.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        linux-kernel@vger.kernel.org, Ilia Mirkin <imirkin@alum.mit.edu>,
        Andy Gross <agross@kernel.org>
Subject: Re: [RESEND PATCH] PCI: qcom: use PHY_REFCLK_USE_PAD only for ipq8064
Date:   Mon, 18 Jan 2021 15:38:42 +0000
Message-Id: <161098429512.19724.6931812959409748673.b4-ty@arm.com>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20201019165555.8269-1-ansuelsmth@gmail.com>
References: <20201019165555.8269-1-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, 19 Oct 2020 18:55:55 +0200, Ansuel Smith wrote:
> The use of PHY_REFCLK_USE_PAD introduced a regression for apq8064
> devices. It was tested that while apq doesn't require the padding, ipq
> SoC must use it or the kernel hangs on boot.

Applied to pci/dwc, thanks!

[1/1] PCI: qcom: use PHY_REFCLK_USE_PAD only for ipq8064
      https://git.kernel.org/lpieralisi/pci/c/cef11c377a

Thanks,
Lorenzo
