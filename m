Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E81206D679D
	for <lists+stable@lfdr.de>; Tue,  4 Apr 2023 17:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234451AbjDDPjn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Apr 2023 11:39:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235827AbjDDPjf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 4 Apr 2023 11:39:35 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B4B559D3;
        Tue,  4 Apr 2023 08:39:16 -0700 (PDT)
Date:   Tue, 4 Apr 2023 17:39:14 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1680622755;
        bh=4iheBDUEXoHX+NGVC8wvboCGujgUMDWwA0qhziV4nJs=;
        h=Date:From:To:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To:Cc:Cc:content-type:content-type:date:date:
         From:from:in-reply-to:in-reply-to:message-id:mime-version:
         references:reply-to:Sender:Subject:Subject:To:To;
        b=CheTohrsHk+v5CCh695xKBoC7UZ8p2jbu79xGriHB1fphEYImCtCBZOQU+ShRjtHS
         FdyI4PMjkgwucNZB7zWUjmgcd+MAauPfXz9NMcwVXivaqGP5v5mUBJfHNDpyzQYpQf
         X1Jz4JPwzxKemQYivXeJVG7AeYrcUGO32CBxBgMqp+58EgcE4O3pfMxXn1RWab56QR
         j7lGlhxxhZpVFcHRGS2V+eEIgg/I43Z6g00D4p2w8if8yvJufXm7TdrK0feFq/hHCY
         W+13EmTdLMKkZ+s1foGbpZessQgS9aEKMxgYBBZicB3KfKa/zzSMbG1eh6haBtfbDw
         GxTkau3FwHlaw==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.2 000/187] 6.2.10-rc1 review
Message-ID: <20230404153914.GB5308@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230403140416.015323160@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
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
> There are 187 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.

Hi Greg

6.2.10-rc1

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
