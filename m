Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC6B16D7FF5
	for <lists+stable@lfdr.de>; Wed,  5 Apr 2023 16:47:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238426AbjDEOr4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 Apr 2023 10:47:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238250AbjDEOrz (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 5 Apr 2023 10:47:55 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F4123C22;
        Wed,  5 Apr 2023 07:47:54 -0700 (PDT)
Date:   Wed, 5 Apr 2023 16:47:52 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1680706072;
        bh=lX6spcUeCWqdaJnL0Eo9sUiGTrgi5l9gBtcNkERTGHA=;
        h=Date:From:To:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To:Cc:Cc:content-type:content-type:date:date:
         From:from:in-reply-to:in-reply-to:message-id:mime-version:
         references:reply-to:Sender:Subject:Subject:To:To;
        b=1OxJBYi0OFBYIplbABTeZDWEi+H/DKLgcNUc8v7f5UhgAdcS7ARaM/zQQDlvE5Z3D
         MxvR0U/jKYRwRVpKyP+ElhtCZxZ6i2zq1WTq1rZFmDtfnBa+c9TX/opGHBihxOjHoP
         X+m4HZGPpLsKu7ItwCock1TVMR3o3qkb9j1/r7Qfweo1Zl22Ntnjkt1iOiXybqi/TQ
         0KV5WgHdVM1rkt15Ms8E2UAUYL3O3A7bN30eEtNn1RgMq7o8VcgOia/YeVCg/NK2vz
         61rKwYjp94Ef1JMUVtdsBB5RiPuuKR7V2efi3FhOs9WyikjvzYcA4vYBT6ROKFGtv/
         BNEz9beYePlqg==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.2 000/185] 6.2.10-rc2 review
Message-ID: <20230405144752.GC5308@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230405100309.298748790@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230405100309.298748790@linuxfoundation.org>
Organization: still stuck in reorganization mode
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.2.10 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Apr 2023 10:02:32 +0000.
> Anything received after that time might be too late.

Hi Greg

6.2.10-rc2

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
