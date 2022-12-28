Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04B87657582
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 11:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229966AbiL1Kzj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 05:55:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46030 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiL1Kzj (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 05:55:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E1A291;
        Wed, 28 Dec 2022 02:55:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BE1386146A;
        Wed, 28 Dec 2022 10:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 821F2C433EF;
        Wed, 28 Dec 2022 10:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672224937;
        bh=Z1+L4dSWFslZO2tkLZMfOV7N216z7PEnH6Dq5HNvPJM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RqdO4cjOpsF6Xd2d9UIbBNszoNN6Mah2k8oV2fdS5akZpH2P8QzhOHP6Jjfq8cd4E
         N67pZAbyKi5Yn85Qsl4VVAE0RgPZvlQ/q51SPYemJLWSD3Xr8s4jws9fSdqJZ4yKLc
         VJdtfXrxrLO9uQldi/DBq3Ch2H+rGP7bbjXxfoW03pbTZQmAevD2uylTcAO5da/GOQ
         N6EUhqWvVcVJb3MAyjXipcYsJCF7r0YaHR6dQx+ZdbmrYkhAq/8xXfhfYpsZx9IEr+
         TQXArtrIYTdhK1+eNtbqmHutHNEOg2/70rI23qieF5rl39ThkFUQpQCMByUBMr/edg
         WccNSGmXlJRfw==
Date:   Wed, 28 Dec 2022 16:25:32 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Reinette Chatre <reinette.chatre@intel.com>
Cc:     fenghua.yu@intel.com, dave.jiang@intel.com,
        dmaengine@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH V2 0/3] dmaengine: idxd: Error path fixes
Message-ID: <Y6wgpI7cbicyUgj8@matsya>
References: <cover.1670452419.git.reinette.chatre@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1670452419.git.reinette.chatre@intel.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 07-12-22, 14:52, Reinette Chatre wrote:
> Changes since v1:
> - V1: https://lore.kernel.org/lkml/cover.1670005163.git.reinette.chatre@intel.com/
> - Cover trimmed after obtaining needed information.
> - Added Reviewed-by tags.
> - cc stable team.
> - Please see individual patches for patch specific changes.
> 
> Dear Maintainers,
> 
> I have been using the IDXD driver to experiment with the upcoming core
> changes in support of IMS ([1], [2], [3]). As part of this work I
> happened to exercise the error paths within IDXD and encountered
> a few issues that are addressed in this series. These changes are
> independent from IMS and just aims to make the IDXD driver more
> robust against errors.
> 
> Your feedback is greatly appreciated.

Applied, thanks

-- 
~Vinod
