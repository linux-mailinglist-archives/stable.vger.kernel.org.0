Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E46E5E6C96
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 22:02:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231510AbiIVUCQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 16:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232629AbiIVUBx (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 16:01:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 453F533373;
        Thu, 22 Sep 2022 13:01:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77DB3B83A6D;
        Thu, 22 Sep 2022 20:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA69C433D6;
        Thu, 22 Sep 2022 20:01:39 +0000 (UTC)
From:   Catalin Marinas <catalin.marinas@arm.com>
To:     Evgenii Stepanov <eugenis@google.com>,
        Peter Collingbourne <pcc@google.com>
Cc:     Will Deacon <will@kernel.org>, Marc Zyngier <maz@kernel.org>,
        Kenny Root <kroot@google.com>, Mark Brown <broonie@kernel.org>,
        Andrey Konovalov <andreyknvl@gmail.com>,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel test robot <lkp@intel.com>, stable@vger.kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v5] arm64: mte: move register initialization to C
Date:   Thu, 22 Sep 2022 21:01:37 +0100
Message-Id: <166387689171.428844.17569339789321559720.b4-ty@arm.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220915222053.3484231-1-eugenis@google.com>
References: <20220915222053.3484231-1-eugenis@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, 15 Sep 2022 15:20:53 -0700, Evgenii Stepanov wrote:
> From: Peter Collingbourne <pcc@google.com>
> 
> If FEAT_MTE2 is disabled via the arm64.nomte command line argument on a
> CPU that claims to support FEAT_MTE2, the kernel will use Tagged Normal
> in the MAIR. If we interpret arm64.nomte to mean that the CPU does not
> in fact implement FEAT_MTE2, setting the system register like this may
> lead to UNSPECIFIED behavior. Fix it by arranging for MAIR to be set
> in the C function cpu_enable_mte which is called based on the sanitized
> version of the system register.
> 
> [...]

Applied to arm64 (for-next/misc), thanks!

[1/1] arm64: mte: move register initialization to C
      https://git.kernel.org/arm64/c/973b9e373306

-- 
Catalin

