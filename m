Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E12476C3689
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 17:04:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230200AbjCUQEf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 12:04:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231573AbjCUQEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 12:04:32 -0400
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B7092D46;
        Tue, 21 Mar 2023 09:04:30 -0700 (PDT)
Date:   Tue, 21 Mar 2023 17:04:28 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1679414669;
        bh=F6MWRaCEw1dbNH7mHAJ7fjXfChLnXV0kWxkZaShITSs=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=0mWxlzvPs6MM+iUFviudEYX6j8OutKMNCrYXvvIzGwxvkszIu+wJwj8a2EM9GmTew
         5F74OntLkSWXK1fBjjZFco1P5wtZe25mkxkWQCZEegsvOqBDqABjHqadc7cTkzEtKt
         zrkdm05ehO/nAciJCTkvLtRZPMpbgJlZhQtvHOZ/WpeuxCnsR+KojWm9VXFNGLsPTa
         x67HTF2sZWCZ4wp3UgqMc8fDx3IoiJF6ntdgKuNrXi1OO2s7pisjow1E11SqY1ZAE9
         nZYqfEW3BdkQ7/sbKnRms4aNT4LIyZ/OU2wSJcELl+iCXdMwwDd+Ab34LycXG3327z
         12OdMXomuspEw==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1 000/198] 6.1.21-rc2 review
Message-ID: <20230321160428.GA2458@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230321080705.245176209@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230321080705.245176209@linuxfoundation.org>
Organization: still stuck in reorganization mode
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

* Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:

> This is the start of the stable review cycle for the 6.1.21 release.
> There are 198 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Mar 2023 08:06:28 +0000.
> Anything received after that time might be too late.

Hi Greg

6.1.21-rc2

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
