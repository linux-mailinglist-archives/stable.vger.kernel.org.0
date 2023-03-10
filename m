Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FEDD6B4DE5
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 18:02:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231145AbjCJRCi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 12:02:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjCJRCF (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 12:02:05 -0500
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8EB41117F;
        Fri, 10 Mar 2023 09:00:08 -0800 (PST)
Date:   Fri, 10 Mar 2023 17:59:24 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1678467570;
        bh=1XkA2pFPCekG7SW1u/IzTz7HJiS543v3cVcYXFm439M=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=FxF9ujnZAviKanmbeXjaVbGcPYun8NmfyaNiGvb01H+6SmswONpi/ldJqAaJ3tX/E
         rN+TMiHu/tkImH30uhPXr8GiPb3UCnN2tGspATx3mGquAq175NKNI/rqg1fV/etKzz
         ZbTZBT++RQ2P3majyHCXzh98h91Ne+pHU3DgzyRYXvDwwsRni0/LcSbgyVrvnfEwqN
         FplPujSKqneRzUiwJeKt8h8mobIIzlIMcALBBGl83+RbxQZ66BrytxjaDGH4WZYRM8
         da+XrRnH9v9AtjVIf//66Dqe5h23NfQUGR0CAuk2PKaCKOsXtVu+w/vNQjYuKY5b7E
         ZNZLcl0Vk2k9Q==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.2 000/211] 6.2.4-rc1 review
Message-ID: <20230310165924.GB2619@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230310133718.689332661@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
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

> This is the start of the stable review cycle for the 6.2.4 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Hi Greg

6.2.4-rc1

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
