Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 076626C323C
	for <lists+stable@lfdr.de>; Tue, 21 Mar 2023 14:04:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbjCUNES (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Mar 2023 09:04:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbjCUNER (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Mar 2023 09:04:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C993224733
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 06:04:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1960ACE17D8
        for <stable@vger.kernel.org>; Tue, 21 Mar 2023 13:04:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D97EBC433D2;
        Tue, 21 Mar 2023 13:04:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679403844;
        bh=xicp2ZjjG9HCcZnawLl5zQfwI83fOJr2ed2aPLSBhZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JuiqRn6w4PRHQKQ5pjoX6CoJ8CFfKfmpMyYdTRm4AYO0CyysHONkkcKwdxfxWZ66A
         jsMi9DDjkEdIP/LY1JVUdpex0V8/fRa5rBw/aenfzm7rgUwmjoMzy44MHC8V5kvm3v
         XBCL/hRExaZYD2VFi2Lo/04IjV2kjQkg2nGD2ja0=
Date:   Tue, 21 Mar 2023 14:04:01 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Mark Brown <broonie@kernel.org>
Cc:     John Harrison <John.C.Harrison@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Jouni =?iso-8859-1?Q?H=F6gander?= <jouni.hogander@intel.com>,
        kernelci-results@groups.io, bot@kernelci.org,
        stable@vger.kernel.org, dri-devel@lists.freedesktop.org
Subject: Re: stable-rc/linux-5.10.y bisection: baseline.login on
 hp-x360-14-G1-sona
Message-ID: <ZBmrQZYg8FJCekK8@kroah.com>
References: <6419a07b.630a0220.8bbc0.07b1@mx.google.com>
 <7f0ccd45-ab53-4155-b647-d082221d65b3@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7f0ccd45-ab53-4155-b647-d082221d65b3@sirena.org.uk>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Mar 21, 2023 at 12:58:22PM +0000, Mark Brown wrote:
> On Tue, Mar 21, 2023 at 05:18:03AM -0700, KernelCI bot wrote:
> 
> The KernelCI bisection bot found a boot bisection on one of the HP
> ChromeBooks in v5.10.175 triggered by b5005605013d ("drm/i915: Don't use
> BAR mappings for ring buffers with LLC").  The system appears to die
> very early in boot with no output.

Should be fixed in the 5.10-rc that is out for review right now.

thanks,

greg k-h
