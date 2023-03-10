Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D81F06B4DA9
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 17:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230388AbjCJQyC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 11:54:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230347AbjCJQxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 11:53:41 -0500
X-Greylist: delayed 323 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 10 Mar 2023 08:50:47 PST
Received: from mail.antaris-organics.com (mail.antaris-organics.com [91.227.220.155])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E0E6135976;
        Fri, 10 Mar 2023 08:50:45 -0800 (PST)
Received: by mail.antaris-organics.com (Postfix, from userid 200)
        id 323EB45BD0; Fri, 10 Mar 2023 17:50:24 +0100 (CET)
Received: by mail.antaris-organics.com (Postfix, from userid 200)
        id 5F0B545BCF; Fri, 10 Mar 2023 17:47:32 +0100 (CET)
Date:   Fri, 10 Mar 2023 17:42:18 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=mareichelt.com;
        s=202107; t=1678466539;
        bh=rxemhKFCYeI9vDlgONo5pSH8U3Bu/Qezhd1e2LPmVWE=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=WLXfS/02mnMD+00LsQRk1PkxF5B4+kXFcoz1K0SrJhgO0T4nMi+y4paJOmN3R2Qwq
         swGwPIdSDUGvPD8mJKvG9fLBTAskUzGTIm1Q+fP0l5UyUed6RIkFycJd6k8zQ7buIw
         +I99QwKVi3bKI2qgDJCT9XZFvBbHBUGTD6XZFQaiySXTvzpM/T3Kdv7TZhjlMHEajO
         jlScv8PU6n04C4AnGumD4hkXs6CgUcGI6Pt2G/rTFkcoNzSIFSF9OT6amu/TcQJOAv
         mXIAvsmdxRwFmAufVl2TuEB1e9sk3hr9vYZoJzigMp/tMns9H1Il5O3EOMILLEx13J
         I3qxYRFxAozCg==
From:   Markus Reichelt <lkt+2023@mareichelt.com>
To:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6.1 000/200] 6.1.17-rc1 review
Message-ID: <20230310164218.GA2619@pc21.mareichelt.com>
Mail-Followup-To: stable@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230310133717.050159289@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
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

> This is the start of the stable review cycle for the 6.1.17 release.
> There are 200 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

Hi Greg

6.1.17-rc1

compiles, boots and runs here on x86_64
(AMD Ryzen 5 PRO 4650G, Slackware64-15.0)

Tested-by: Markus Reichelt <lkt+2023@mareichelt.com>
