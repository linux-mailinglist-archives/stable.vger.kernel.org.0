Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9BAF40E8C9
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 20:01:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356169AbhIPRpO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 13:45:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355823AbhIPRmK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 13:42:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A6BD06058D;
        Thu, 16 Sep 2021 17:08:35 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Mark Brown <broonie@kernel.org>, Will Deacon <will@kernel.org>
Cc:     stable@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] arm64/sve: Use correct size when reinitialising SVE state
Date:   Thu, 16 Sep 2021 18:08:33 +0100
Message-Id: <163181210192.884883.4596115964596843618.b4-ty@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909165356.10675-1-broonie@kernel.org>
References: <20210909165356.10675-1-broonie@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 9 Sep 2021 17:53:56 +0100, Mark Brown wrote:
> When we need a buffer for SVE register state we call sve_alloc() to make
> sure that one is there. In order to avoid repeated allocations and frees
> we keep the buffer around unless we change vector length and just memset()
> it to ensure a clean register state. The function that deals with this
> takes the task to operate on as an argument, however in the case where we
> do a memset() we initialise using the SVE state size for the current task
> rather than the task passed as an argument.
> 
> [...]

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64/sve: Use correct size when reinitialising SVE state
      https://git.kernel.org/arm64/c/e35ac9d0b56e

-- 
Catalin

