Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1D5357EF49
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 15:50:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbiGWNt7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 09:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233071AbiGWNt6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 09:49:58 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BA872229D
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 06:49:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 0AE4ECE02C8
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 13:49:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E155FC341C0;
        Sat, 23 Jul 2022 13:49:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658584194;
        bh=Fz128Vzp1zg0uq8f/DFzj7uCbBbbkmP4dHaaPgW/4qk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FQ53eKP4RNFF7bhNy7JqR4A2oyRncbOZCEfhaJQ7NeFaSnbgJ+GWfau99VzhSUlv/
         Q1+1266ZTlGSKp2FVCdwvNRNw9iHcIIFVJq6lwESWo8jPVctU1XJoLeQ0i25yrLpPs
         2fxAOug9cLg8vgIZXxuPO0Il1h/6ACSKlpuem6bE=
Date:   Sat, 23 Jul 2022 15:49:50 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Peter Wang =?utf-8?B?KOeOi+S/oeWPiyk=?= <peter.wang@mediatek.com>
Cc:     "rafael.j.wysocki@intel.com" <rafael.j.wysocki@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Stanley Chu =?utf-8?B?KOacseWOn+mZnik=?= 
        <stanley.chu@mediatek.com>
Subject: Re: backport commit ("887371066039011144b4a94af97d9328df6869a2 PM:
 runtime: Fix supplier device management during consumer probe") to
 linux-5.15
Message-ID: <Ytv8frVgVzJ+vPTW@kroah.com>
References: <PSAPR03MB5605DCFFD56137A47C1CA05CEC879@PSAPR03MB5605.apcprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <PSAPR03MB5605DCFFD56137A47C1CA05CEC879@PSAPR03MB5605.apcprd03.prod.outlook.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jul 11, 2022 at 02:03:50PM +0000, Peter Wang (王信友) wrote:
> Hi reviewers,
> 
> I suggest to backport
> commit "887371066039011144b4a94af97d9328df6869a2 PM: runtime: Fix supplier device management during consumer probe"
> to linux-5.15 tree.
> 
> This patch fix device link of runtime pm issue.
> 
> commit: 887371066039011144b4a94af97d9328df6869a2
> subject: PM: runtime: Fix supplier device management during consumer probe

As I said in the message you responded to, if anyone wants this in the
5.15 or older kernel trees, please provide a working backport.  As
obviously you have tested this in your 5.15.y tree, please send it to me
for inclusion.

thanks,

greg k-h
