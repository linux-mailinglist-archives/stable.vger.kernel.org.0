Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 253795215A9
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 14:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232506AbiEJMoj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 08:44:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234396AbiEJMoi (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 08:44:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 198F5A1B6
        for <stable@vger.kernel.org>; Tue, 10 May 2022 05:40:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D30A6B81B14
        for <stable@vger.kernel.org>; Tue, 10 May 2022 12:40:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E20C385C2;
        Tue, 10 May 2022 12:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652186438;
        bh=svrKlK4fEsIn8Ww6BnHMblDDpGm5RnkmfQqw7f3JXw0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NJYswgjHhvvS4ugtvc8/ARgUvP26MxvhCgD+qOtY1jPj2n5dOP750abbGCKG7FkO5
         x8Uu5c+3bXoZFDlTphVNBPzbTjTIhu1d04dz+pOuhCtlB2D9N6X+OdpQ/ESxXrPl5X
         ILvDNPViJv+pfFJWcI5xA9KeZVdXM8iZdKFd2ZcM=
Date:   Tue, 10 May 2022 14:40:35 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian =?iso-8859-1?Q?L=F6hle?= <CLoehle@hyperstone.com>
Cc:     Ulf Hansson <ulf.hansson@linaro.org>,
        Ricky WU <ricky_wu@realtek.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mmc: rtsx: add 74 Clocks in power on flow
Message-ID: <YnpdQ7ei82FJpRiF@kroah.com>
References: <64c6a1e0131e4084960864d1f4a9f961@hyperstone.com>
 <faa583cd83af4d17bf33bd8ed6c822fa@hyperstone.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <faa583cd83af4d17bf33bd8ed6c822fa@hyperstone.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 10, 2022 at 12:09:45PM +0000, Christian Löhle wrote:
> >commit 1f311c94aabd ("mmc: rtsx: add 74 Clocks in power on flow") upstream.
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
> 
> Based on 5.10.y, applies to all down to 4.9.y=

It breaks the build on 4.14.y and 4.9.y :(

