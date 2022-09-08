Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE3825B2436
	for <lists+stable@lfdr.de>; Thu,  8 Sep 2022 19:07:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbiIHRH2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 8 Sep 2022 13:07:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229725AbiIHRH1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 8 Sep 2022 13:07:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 376BAC2F91
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 10:07:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C64B161DA1
        for <stable@vger.kernel.org>; Thu,  8 Sep 2022 17:07:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD237C433C1;
        Thu,  8 Sep 2022 17:07:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662656846;
        bh=Ouzyer9A+zkWkYqUb8Sr/7KuzoASjH7Y4cGJpH8If5g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UxG1kJwlWHSS3xBUjLbl8Kqab7MUxPL0KawF8B/b53Q49NqUCdZsXr5l1GU6EhPMP
         GYeOXN5mqudqPGhVdxm1wafJeDTg0I5kVAvmhP+Dy6+p0tt8maNx7+s5cMBM9lFwtN
         QSxqLq19cW9wLwSB3kVVDQ1BqXxvSyQ4aQMUNgS4=
Date:   Thu, 8 Sep 2022 19:07:47 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Enguerrand de Ribaucourt 
        <enguerrand.de-ribaucourt@savoirfairelinux.com>
Cc:     stable@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH v3 0/2] net: dp83822: backport fix interrupt floods
Message-ID: <YxohY8Loyg3SBuld@kroah.com>
References: <20220907104558.256807-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220907104558.256807-1-enguerrand.de-ribaucourt@savoirfairelinux.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Sep 07, 2022 at 12:45:57PM +0200, Enguerrand de Ribaucourt wrote:
> This series backports the following fixes from 5.10 to 5.4.
> This backport should also apply to 4.19.
> 
> A git conflict was solved involving DP83822_ANEG_COMPLETE_INT_EN which was moved
> to a conditional in 5.10.
> 
> Original commit IDs:
> c96614eeab663646f57f67aa591e015abd8bd0ba net: dp83822: disable false carrier interrupt
> 0e597e2affb90d6ea48df6890d882924acf71e19 net: dp83822: disable rx error interrupt
> 
> 

These are alread in 5.10.y, they showed up in 5.10.129.  Should I just
take these into 5.4.y and 4.19.y instead?

thanks,

greg k-h
