Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9EF85A9408
	for <lists+stable@lfdr.de>; Thu,  1 Sep 2022 12:16:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232313AbiIAKQO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Sep 2022 06:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230064AbiIAKQO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Sep 2022 06:16:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30E83132516;
        Thu,  1 Sep 2022 03:16:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C156E61BBD;
        Thu,  1 Sep 2022 10:16:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4799C433D6;
        Thu,  1 Sep 2022 10:16:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662027372;
        bh=uZ+oI9tPYlP6rcFKR0qKBUggEYKn53MeVCyIMmkvT4g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yoaisLSa3hD7MKb/tM8glDvfl0ElMn3nP23bJB2Ox4MHLgQEki88IOPqBxswlZODu
         QLsCtL0DD5FU956du0Oc3sN/tj9qiQDjV+O2QDLyDHh5SED5LstzGcPq4T7p9SgnTJ
         4pv53jcZNcDIgQUF2mPzmRi/pxWPVv3mC2XeG7kA=
Date:   Thu, 1 Sep 2022 12:16:09 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Cc:     stable@vger.kernel.org, andrew.cooper3@citrix.com, bp@suse.de,
        tony.luck@intel.com, antonio.gomez.iglesias@linux.intel.com,
        Daniel Sneddon <daniel.sneddon@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4.14 1/2] x86/cpu: Add Tiger Lake to Intel family
Message-ID: <YxCGaVZ8QRW65sIc@kroah.com>
References: <ec31e22b4f3b079d0da6b60f5899ffcd79d9bea0.1661899117.git.pawan.kumar.gupta@linux.intel.com>
 <20220830230008.uvkdp2r54uexpwbz@desk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220830230008.uvkdp2r54uexpwbz@desk>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 30, 2022 at 04:00:08PM -0700, Pawan Gupta wrote:
> On Tue, Aug 30, 2022 at 03:43:25PM -0700, Pawan Gupta wrote:
> > From: Gayatri Kammela <gayatri.kammela@intel.com>
> > 
> > [ Upstream commit 6e1c32c5dbb4b90eea8f964c2869d0bde050dbe0 ]
> > 
> > Add the model numbers/CPUIDs of Tiger Lake mobile and desktop to the
> > Intel family.
> > 
> > Suggested-by: Tony Luck <tony.luck@intel.com>
> > Signed-off-by: Gayatri Kammela <gayatri.kammela@intel.com>
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > Reviewed-by: Tony Luck <tony.luck@intel.com>
> > Cc: Linus Torvalds <torvalds@linux-foundation.org>
> > Cc: Peter Zijlstra <peterz@infradead.org>
> > Cc: Rahul Tanwar <rahul.tanwar@linux.intel.com>
> > Cc: Thomas Gleixner <tglx@linutronix.de>
> > Link: https://lkml.kernel.org/r/20190905193020.14707-2-tony.luck@intel.com
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> > Signed-off-by: Sasha Levin <sashal@kernel.org>
> 
> Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
> 
> I just realized that my sign-off was missing. I can resend the patch if
> required.

No need, I took it from here, thanks.

greg k-h
