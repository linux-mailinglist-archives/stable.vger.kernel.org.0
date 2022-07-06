Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F111C5683D0
	for <lists+stable@lfdr.de>; Wed,  6 Jul 2022 11:46:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbiGFJky (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 6 Jul 2022 05:40:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232345AbiGFJkU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 6 Jul 2022 05:40:20 -0400
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B49425E91
        for <stable@vger.kernel.org>; Wed,  6 Jul 2022 02:39:16 -0700 (PDT)
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7B04E1042;
        Wed,  6 Jul 2022 02:39:15 -0700 (PDT)
Received: from usa.arm.com (e103737-lin.cambridge.arm.com [10.1.197.49])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id DCB0D3F66F;
        Wed,  6 Jul 2022 02:39:13 -0700 (PDT)
From:   Sudeep Holla <sudeep.holla@arm.com>
To:     linux-arm-kernel@lists.infradead.org,
        Sudeep Holla <sudeep.holla@arm.com>
Cc:     huhai <huhai@kylinos.cn>, luriwen@kylinos.cn, liuyun01@kylinos.cn,
        cristian.marussi@arm.com, 15815827059@163.com,
        stable@vger.kernel.org
Subject: Re: [PATCH] firmware: arm_scpi: Ensure scpi_info is not assigned if the probe fails
Date:   Wed,  6 Jul 2022 10:39:01 +0100
Message-Id: <165710015321.2263892.16731207586574528205.b4-ty@arm.com>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220701160310.148344-1-sudeep.holla@arm.com>
References: <20220701160310.148344-1-sudeep.holla@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-6.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, 1 Jul 2022 17:03:10 +0100, Sudeep Holla wrote:
> When scpi probe fails, at any point, we need to ensure that the scpi_info
> is not set and will remain NULL until the probe succeeds. If it is not
> taken care, then it could result in kernel panic with a NULL pointer
> dereference.
> 
> 

Applied to sudeep.holla/linux (for-next/scmi), thanks!

[1/1] firmware: arm_scpi: Ensure scpi_info is not assigned if the probe fails
      https://git.kernel.org/sudeep.holla/c/689640efc0

--
Regards,
Sudeep

