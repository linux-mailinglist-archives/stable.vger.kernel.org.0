Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93BF96B770C
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 12:59:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230035AbjCML7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Mar 2023 07:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbjCML7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Mar 2023 07:59:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E04135264;
        Mon, 13 Mar 2023 04:59:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE84E61213;
        Mon, 13 Mar 2023 11:59:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15AA5C433EF;
        Mon, 13 Mar 2023 11:59:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678708768;
        bh=kuCJ5bdh1Dnu5DXozrGx0DOc7vlJoWrF4JSBUocpLoI=;
        h=From:To:Cc:Subject:Date:From;
        b=bjYMh+uqjy5v9Lfxero6nDuJ1OgHhPrE7ZFKISGKPloMI8dG1Y4yXpdPhrUfSrsRF
         /6D6vlxu+TuiEShWkSTrMSleVZE+p3vk1APlEvyAznh7H4C3scwEGxVtjs18zCVhcx
         ZmlGYFBmFYNpEwXTrPLOcbJgkuNS5ylE2nMJcZIbuMNg5E755GNcm24Da8hbW0dBbR
         eGSFyhnsDKPXdK8DB8Ap9DSden6SBKrmm8I/nQAmz+cpwbUEHNbIfUZteq+UgZUmPa
         fXVKfyHeqSVCMiVX/XhGnOYG1EkVZxli3xMv4EvE8mdMC3Z73rX5UgEYU1zLmBzh8J
         p5eHLsKD8OHwQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pbgqq-0006kn-CZ; Mon, 13 Mar 2023 13:00:29 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Marc Zyngier <maz@kernel.org>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>
Subject: [PATCH stable-5.15 0/2] irqdomain: Fix mapping-creation race
Date:   Mon, 13 Mar 2023 13:00:05 +0100
Message-Id: <20230313120007.25938-1-johan@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johan Hovold <johan+linaro@kernel.org>

Here are backports of the irqdomain fixes that failed to apply to 5.15.

Johan

Johan Hovold (2):
  irqdomain: Refactor __irq_domain_alloc_irqs()
  irqdomain: Fix mapping-creation race

 kernel/irq/irqdomain.c | 152 +++++++++++++++++++++++++----------------
 1 file changed, 94 insertions(+), 58 deletions(-)

-- 
2.39.2

