Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAB465BF8E5
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 10:20:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231474AbiIUIT7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 04:19:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231477AbiIUITf (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 04:19:35 -0400
Received: from mail.8bytes.org (mail.8bytes.org [IPv6:2a01:238:42d9:3f00:e505:6202:4f0c:f051])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4CC8B3AE6B;
        Wed, 21 Sep 2022 01:19:20 -0700 (PDT)
Received: from 8bytes.org (p549ad5ad.dip0.t-ipconnect.de [84.154.213.173])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.8bytes.org (Postfix) with ESMTPSA id 427A624131B;
        Wed, 21 Sep 2022 10:19:11 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
        s=default; t=1663748351;
        bh=9uqI9Ns9iqcTyBsCQpYejhiG2FuX8TbJQ1GMJeVpisc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AkHPVg/lsqesEvKEOavrXFZUtjoepND0S3TO1/AbOcI+9ZxKr8WbSgbfNN2RE9FI6
         nrbp0Vkd/fYVVGHzKDQU931AWM2tXNX2/t5E6YHsj1QpcG+XkJYnzuqKydq116cPR3
         6LM5+bsFSHOqCEWqO/NabpD2mGOVKp/NRFQToYUa71/MI8sPvblkU045qlpQlOUsgU
         bZaDPiKCo5RyulHbeV1NAUH2V+OwLpw+nE7NSu+N4vud6IeUHKG/umsphGvT9Fo8Q+
         RinbwdBqIHSSko892V4L/bdoHKPQsNJW80CFgIhEhvPU2mDlCpaSLZbY5hp9yrOmP4
         LAhE9L/gjvD/Q==
Date:   Wed, 21 Sep 2022 10:19:10 +0200
From:   Joerg Roedel <joro@8bytes.org>
To:     Thorsten Leemhuis <regressions@leemhuis.info>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Lu Baolu <baolu.lu@linux.intel.com>, iommu@lists.linux.dev,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>,
        LKML <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: Re: How to quickly resolve the IOMMU regression that currently
 plagues a lot of people in 5.19.y
Message-ID: <YyrI/qzx/EWapzck@8bytes.org>
References: <1d1844f0-c773-6222-36c6-862e14f6020d@leemhuis.info>
 <fd672632-7935-14ff-e2be-0db8443b0907@leemhuis.info>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fd672632-7935-14ff-e2be-0db8443b0907@leemhuis.info>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Thorsten,

On Wed, Sep 21, 2022 at 09:15:17AM +0200, Thorsten Leemhuis wrote:
> [resend with proper subject, sorry for the noise]

Thanks for the noise :) I will queue the fix today and send it upstream.

Regards,

	Joerg
