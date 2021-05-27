Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63592392AEB
	for <lists+stable@lfdr.de>; Thu, 27 May 2021 11:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235744AbhE0Jih (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 05:38:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:40272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235675AbhE0Jig (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 May 2021 05:38:36 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC6F3610CE;
        Thu, 27 May 2021 09:37:03 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lmCRp-003uYV-Up; Thu, 27 May 2021 10:37:02 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     Zenghui Yu <yuzenghui@huawei.com>, kvmarm@lists.cs.columbia.edu,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH] KVM: arm64: Resolve all pending PC updates before immediate exit
Date:   Thu, 27 May 2021 10:36:58 +0100
Message-Id: <162210811963.2571441.8247846241479651886.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210526141831.1662-1-yuzenghui@huawei.com>
References: <20210526141831.1662-1-yuzenghui@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: yuzenghui@huawei.com, kvmarm@lists.cs.columbia.edu, linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, 26 May 2021 22:18:31 +0800, Zenghui Yu wrote:
> Commit 26778aaa134a ("KVM: arm64: Commit pending PC adjustemnts before
> returning to userspace") fixed the PC updating issue by forcing an explicit
> synchronisation of the exception state on vcpu exit to userspace.
> 
> However, we forgot to take into account the case where immediate_exit is
> set by userspace and KVM_RUN will exit immediately. Fix it by resolving all
> pending PC updates before returning to userspace.
> 
> [...]

Applied to fixes, thanks!

[1/1] KVM: arm64: Resolve all pending PC updates before immediate exit
      commit: e3e880bb1518eb10a4b4bb4344ed614d6856f190

with:
Fixes: 26778aaa134a ("KVM: arm64: Commit pending PC adjustemnts before returning to userspace")
Cc: stable@vger.kernel.org # 5.11

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


