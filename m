Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2133A378808
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:41:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238902AbhEJLUY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:20:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:44332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236470AbhEJLIN (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:08:13 -0400
Received: from disco-boy.misterjones.org (disco-boy.misterjones.org [51.254.78.96])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADDB26199C;
        Mon, 10 May 2021 11:01:36 +0000 (UTC)
Received: from 78.163-31-62.static.virginmediabusiness.co.uk ([62.31.163.78] helo=hot-poop.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <maz@kernel.org>)
        id 1lg3fK-000N3U-Ho; Mon, 10 May 2021 12:01:34 +0100
From:   Marc Zyngier <maz@kernel.org>
To:     alex.williamson@redhat.com, mst@redhat.com,
        Zhu Lingshan <lingshan.zhu@intel.com>, jasowang@redhat.com
Cc:     kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        cohuck@redhat.com, kvmarm@lists.cs.columbia.edu,
        stable@vger.kernel.org
Subject: Re: [PATCH] Revert "irqbypass: do not start cons/prod when failed connect"
Date:   Mon, 10 May 2021 12:01:12 +0100
Message-Id: <162064445049.841205.6886190424187341445.b4-ty@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210508071152.722425-1-lingshan.zhu@intel.com>
References: <20210508071152.722425-1-lingshan.zhu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 62.31.163.78
X-SA-Exim-Rcpt-To: alex.williamson@redhat.com, mst@redhat.com, lingshan.zhu@intel.com, jasowang@redhat.com, kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, cohuck@redhat.com, kvmarm@lists.cs.columbia.edu, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, 8 May 2021 15:11:52 +0800, Zhu Lingshan wrote:
> This reverts commit a979a6aa009f3c99689432e0cdb5402a4463fb88.
> 
> The reverted commit may cause VM freeze on arm64 platform.
> Because on arm64 platform, stop a consumer will suspend the VM,
> the VM will freeze without a start consumer

Applied to fixes, thanks!

[1/1] Revert "irqbypass: do not start cons/prod when failed connect"
      commit: 0b1c0157b7b0d66d2d749ec950c7f8799d4a2e0e

Cheers,

	M.
-- 
Without deviation from the norm, progress is not possible.


