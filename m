Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EDB1525CBA
	for <lists+stable@lfdr.de>; Fri, 13 May 2022 10:03:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377939AbiEMHyx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 13 May 2022 03:54:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377952AbiEMHyv (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 13 May 2022 03:54:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63BDC29B025
        for <stable@vger.kernel.org>; Fri, 13 May 2022 00:54:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 294A461F27
        for <stable@vger.kernel.org>; Fri, 13 May 2022 07:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 219F2C34100;
        Fri, 13 May 2022 07:54:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652428489;
        bh=CtB8eWc5giTw2GqxlyMpmNDKRZQ1plzyfLO2D6CUniQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sPysA6fk8dgtyO7C25RhDkry03bB07tL8gQJpsWviBz2CBSk2yknnAVYPvBDP0MLo
         C7jCmRC0AkWT2FbT7nIalA1JSMJix1CJdZk2hoGc4woaVrWCxbtncp9/sMoEuiTXon
         wEuUd7AHDwycabdWH1oSjeQQGagPNYSLl/Aeh64s=
Date:   Fri, 13 May 2022 09:54:45 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian =?iso-8859-1?Q?L=F6hle?= <CLoehle@hyperstone.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Ricky WU <ricky_wu@realtek.com>
Subject: Re: [PATCH] mmc: rtsx: add 74 Clocks in power on flow
Message-ID: <Yn4OxZCarhz587RF@kroah.com>
References: <d569393619d54d8789a223a9db6d455e@hyperstone.com>
 <939808fa84904f72a54d427ca4592486@hyperstone.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <939808fa84904f72a54d427ca4592486@hyperstone.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 01:02:24PM +0000, Christian Löhle wrote:
> >commit 1f311c94aabd ("mmc: rtsx: add 74 Clocks in power on flow") upstream.
> >backport note: removed unavailable power_delay_ms 5ms as 10ms is fine, too.
> >
> >SD spec definition:
> >"Host provides at least 74 Clocks before issuing first command"
> >After 1ms for the voltage stable then start issuing the Clock signals
> >
> >if POWER STATE is
> >MMC_POWER_OFF to MMC_POWER_UP to issue Clock signal to card
> >MMC_POWER_UP to MMC_POWER_ON to stop issuing signal to card
> >
> >Signed-off-by: Ricky Wu <ricky_wu@realtek.com>
> >Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
> >Signed-off-by: Christian Loehle <cloehle@hyperstone.com>
> >---
> 
> Now for 4.9.y and 4.14.y, my bad and thanks a lot.

Now queued up, thanks.

greg k-h
