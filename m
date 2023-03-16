Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E74A46BD59C
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 17:30:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230164AbjCPQa6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 12:30:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230156AbjCPQaz (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 12:30:55 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E4B122037;
        Thu, 16 Mar 2023 09:30:51 -0700 (PDT)
Date:   Thu, 16 Mar 2023 17:30:48 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1678984249;
        bh=jeR/NRXRjJLxySP9oIxOLTiz9pwgULcWBCaoBTdDcug=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=z8PmfTYZJFPOEANBqFAV1KRXQVrGB1vFOn8inhqLB1rQUQf03WtfHyjmzWjogcL0t
         887+bLCPVljfGdjUQhICXtwvsScCipyXqrRUUQi1fkBfF2SVhVs10hEOo4V46/FzPw
         nwUtMaaTslsV6vC3ds7zKvpx/jK0EaM7ev3kIUIE/u4CR6HYwj155eO+LPA1pNx8dZ
         hCnZN2gNMD2/rWUZ9FFiPwH/dAMQ4nLuM2D7yHr4k1RUrPn/mhyyYK3QtyNB2VgqX6
         sVgGXUqSTZuV3l3Hvvuix6+Ycedtqr3BreYA95juqzxiBtWpMnFKKn5bLE9q9h5OEs
         pr+OinUSIhT6g==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1 000/140] 6.1.20-rc2 review
Message-ID: <20230316163048.GA3702@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230316083444.336870717@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230316083444.336870717@linuxfoundation.org>
Organization: still stuck in reorganization mode
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.20 release.
> There are 140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.

Hi Greg

6.1.20-rc2

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
