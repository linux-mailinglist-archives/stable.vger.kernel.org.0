Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2D76E6AAC
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 19:14:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230384AbjDRRNr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 13:13:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231472AbjDRRNp (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 13:13:45 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80043F1;
        Tue, 18 Apr 2023 10:13:44 -0700 (PDT)
Date:   Tue, 18 Apr 2023 19:13:42 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1681838023;
        bh=0aIict0PFARB9EHsINfxyJJQfRo9DOasR5OXiFcGm3g=;
        h=Date:From:To:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To:Cc:Cc:content-type:content-type:date:date:
         From:from:in-reply-to:in-reply-to:message-id:mime-version:
         references:reply-to:Sender:Subject:Subject:To:To;
        b=fN1w/p+OT5IjAMerBrSJ7uuFTr3Z/jjSA7xpegEp7RtBAaltkYcFueKw5pHgmxCqm
         0bjjbF+Vikkt4X3XYCyJTHvP4X6Kz7CJVOm/LpJGE+Eowu6ylJVr6pPvxf2TprqHCe
         UhmxdONr625Znekt8xr5ZKAproDTzV99lSekkopirKLzmS0dhIgtPm2gMXiT1myzit
         gxe4MdGvvSlt9houXhWeioLRiITBNGxHCLDfnrOKb4Kpkz2xsCPDUVL3ckuDsvBKhe
         ZOxG4nfI3nSMjVD6TE4SL8LSi+7Ijnatzqj/5C8jH3vKoyc3prFO87SoNlBpxpXenU
         6VYKNBRT/GepQ==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.2 000/139] 6.2.12-rc1 review
Message-ID: <20230418171342.GC3871@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230418120313.725598495@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
Organization: still stuck in reorganization mode
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.2.12 release.
> There are 139 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.

Hi Greg

6.2.12-rc1

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
