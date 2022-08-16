Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A825595456
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 10:00:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230014AbiHPIAS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 04:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbiHPIAD (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 04:00:03 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36456FFF5C;
        Mon, 15 Aug 2022 22:17:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E0B16B815F9;
        Tue, 16 Aug 2022 05:17:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AC48C433B5;
        Tue, 16 Aug 2022 05:17:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660627061;
        bh=2I/NGcSiEnf11oojw4Zd1ZTECVubUZSd4cq2Kqak7bI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Cm2ONKbN1vvLCO13j29MicFAaqXQtVpABdDwLnh1s6BAszYu5Z5gHdrFe4nEjAPe8
         NB18o2CngjS7jSfqRfYus4tpz7g3Tjq62CZ1AauTivJUOMcPodyHpQVUcexgvhfVCU
         FmJ3C6hz2agOYmUL5986qiMOOiRCGMnP6E6xIQIA=
Date:   Tue, 16 Aug 2022 07:17:36 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        slade@sladewatkins.com
Subject: Re: [PATCH 5.19 0000/1157] 5.19.2-rc1 review
Message-ID: <YvsocKly+n9S4CsB@kroah.com>
References: <20220815180439.416659447@linuxfoundation.org>
 <YvruPKI4dCyrXCp5@home.goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YvruPKI4dCyrXCp5@home.goodmis.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 15, 2022 at 09:09:16PM -0400, Steven Rostedt wrote:
> On Mon, Aug 15, 2022 at 07:49:16PM +0200, Greg Kroah-Hartman wrote:
> > This is the start of the stable review cycle for the 5.19.2 release.
> > There are 1157 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> 
> Hi Greg,
> 
> Perhaps its time that you just send a single email to LKML pointing where to
> find the stable releases. These patch bombs are bringing vger down to its
> knees, and causing delays in people's workflows. This doesn't just affect
> LKML, but all other vger mailing lists. Probably because LKML has the biggest
> subscriber base that patch bombs to it can slow everything else down.
> 
> I sent 3 patches to the linux-trace-devel list almost 4 hours ago, and they
> still haven't shown up. I was going to point people to it tonight but it's now
> going to have to wait till tomorrow.

Email is async, sometimes it takes longer than others to recieve
messages.

My "patch bombs" get sent out slow to the mail servers, there is work to
fix up vger and move it over to the LF-managed infrastructure, perhaps
work with the vger admins to help that effort out?

> I really do not think LKML needs to see all 1157 patches that are being
> backported. There's other places to send them that will not be as disruptive.

And where would that be?

Getting the patches out for review is good, and necessary.  Patches
should never be considered "noise" as it is what we are doing here.  If
we have infrastructure issues handling these messages, we should work to
resolve them as really, 3000 emails should not be a lot to manage,
unless you are being throttled by your email provider?

thanks,

greg k-h
