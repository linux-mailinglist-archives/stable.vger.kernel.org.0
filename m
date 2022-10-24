Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 383A8609833
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 04:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbiJXCZp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Oct 2022 22:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229613AbiJXCZn (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Oct 2022 22:25:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7B1358EAD;
        Sun, 23 Oct 2022 19:25:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8739C60FAD;
        Mon, 24 Oct 2022 02:25:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D0CEC433D7;
        Mon, 24 Oct 2022 02:25:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666578341;
        bh=4O7XmuHpEkrgtDDMf7vyEN4lZbUi3RYguIgOz9Efq5Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=txQKJCyA9Qfe3Bga0olKTuGUxcvajw3kWMLi0izG+WvMzkRZRuPtYF1tUpP7Qf3HS
         +dLgKqSALpO09x/cGQcKaHljxsc0/bS6v3alFsXuzNDDmiEoSA6WcLfTsggo/us6vE
         Hb/KZLo40DKYdOAk3TG/6lcPnBDN6/a5asByZ1Dd/wiitnrgwsOULsp1UuboJRlPq0
         JLGWI63PV0vWylAnTJ6VI6JG0HQe7ROwU8a+cmSsdB+VVoaVdtAyY4UiPgMk7w4Bn4
         oWyWQOt3MpPKRByHPlTkwhn5DrFuOlanrLs3fcIlUy8j+reXBRXpPEuuzI7UCDiZx7
         oX2sAcM2vAEJw==
Date:   Mon, 24 Oct 2022 10:25:34 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Petr Benes <petr.benes@ysoft.com>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        Fabio Estevam <festevam@gmail.com>,
        NXP Linux Team <linux-imx@nxp.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        petrben@gmail.com, stable@vger.kernel.org,
        Michal =?utf-8?B?Vm9rw6HEjQ==?= <michal.vokac@ysoft.com>
Subject: Re: [PATCH] ARM: dts: imx6dl-yapp4: Do not allow PM to switch PU
 regulator off on Q/QP
Message-ID: <20221024022534.GC125525@dragon>
References: <20221004153920.104984-1-petr.benes@ysoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20221004153920.104984-1-petr.benes@ysoft.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Oct 04, 2022 at 05:39:20PM +0200, Petr Benes wrote:
> Fix our design flaw in supply voltage distribution on the Quad and QuadPlus
> based boards.
> 
> The problem is that we supply the SoC cache (VDD_CACHE_CAP) from VDD_PU
> instead of VDD_SOC. The VDD_PU internal regulator can be disabled by PM
> if VPU or GPU is not used. If that happens the system freezes. To prevent
> that configure the reg_pu regulator to be always on.
> 
> Fixes: 0de4ab81ab26 ("ARM: dts: imx6dl-yapp4: Add Y Soft IOTA Crux/Crux+ board")
> Cc: petrben@gmail.com
> Cc: stable@vger.kernel.org
> Signed-off-by: Petr Benes <petr.benes@ysoft.com>
> Signed-off-by: Michal Vokáč <michal.vokac@ysoft.com>

Applied, thanks!
