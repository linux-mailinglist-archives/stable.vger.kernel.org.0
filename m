Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3F43671C5C
	for <lists+stable@lfdr.de>; Wed, 18 Jan 2023 13:42:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbjARMmp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Jan 2023 07:42:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230346AbjARMkl (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Jan 2023 07:40:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA04D7ABB;
        Wed, 18 Jan 2023 04:04:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8BEE261784;
        Wed, 18 Jan 2023 12:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EE10C433D2;
        Wed, 18 Jan 2023 12:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674043489;
        bh=byI8kw4j/5NbDaFJyetz+Cc1M82TT3l6loPBm3ZkZ8E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nPTLhTUiJKfjzv/oVm/euIqyufniTvIKtv2L57L3rf6otrCx7R7q7Uj7Y/3F7PL7D
         e5j3AlbTXq6ykykOYeXlHVHj1a2/c+O9zMukrTnc3L+yUmGkPWFbY6YFpmJy7z0/fg
         OLC1bgPf4ksLR3sv8fV6Y2qcp5k9jelRcGsfT+Tj6pzkuImMngz2ESnYuRlWqeIg+9
         5f8eOXVyIScgZH3OGYq4PAejWsAJh+h5QGwpZyFeM2ELe9mkjSqcFv+UC1bCkt23Z0
         Mtk9qrA9TN7oywSZhFiCjVyxFLmyRk6uAlQnfPCiqQzYZnN96ru/ugVP551Dx1ukfD
         zdSk9x9KUA+Qw==
Date:   Wed, 18 Jan 2023 17:34:44 +0530
From:   Vinod Koul <vkoul@kernel.org>
To:     Mohan Kumar <mkumard@nvidia.com>
Cc:     ldewangan@nvidia.com, jonathanh@nvidia.com,
        thierry.reding@gmail.com, dmaengine@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] dmaengine: tegra210-adma: fix global intr clear
Message-ID: <Y8fgXGKp6jK/j2VP@matsya>
References: <20230102064844.31306-1-mkumard@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230102064844.31306-1-mkumard@nvidia.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 02-01-23, 12:18, Mohan Kumar wrote:
> The current global interrupt clear programming register offset
> was not correct. Fix the programming with right offset

Applied, thanks

-- 
~Vinod
