Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6403423E65
	for <lists+stable@lfdr.de>; Wed,  6 Oct 2021 15:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbhJFNI0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Oct 2021 09:08:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:39426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229894AbhJFNI0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 6 Oct 2021 09:08:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1DE26610A1;
        Wed,  6 Oct 2021 13:06:30 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Mike Kravetz <mike.kravetz@oracle.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc:     Will Deacon <will@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable@vger.kernel.org, Mark Rutland <mark.rutland@arm.com>,
        Barry Song <song.bao.hua@hisilicon.com>
Subject: Re: [PATCH] arm64/hugetlb: fix CMA gigantic page order for non-4K PAGE_SIZE
Date:   Wed,  6 Oct 2021 14:06:29 +0100
Message-Id: <163352556550.2712644.3888051784195777797.b4-ty@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20211005202529.213812-1-mike.kravetz@oracle.com>
References: <20211005202529.213812-1-mike.kravetz@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, 5 Oct 2021 13:25:29 -0700, Mike Kravetz wrote:
> For non-4K PAGE_SIZE configs, the largest gigantic huge page size is
> CONT_PMD_SHIFT order.

Applied to arm64 (for-next/fixes), thanks!

[1/1] arm64/hugetlb: fix CMA gigantic page order for non-4K PAGE_SIZE
      https://git.kernel.org/arm64/c/0350419b14b9

-- 
Catalin

