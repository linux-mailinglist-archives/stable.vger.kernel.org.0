Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FF96A3B42
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 07:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229696AbjB0Ga1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Feb 2023 01:30:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjB0GaZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Feb 2023 01:30:25 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D390111160;
        Sun, 26 Feb 2023 22:30:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F0A260C58;
        Mon, 27 Feb 2023 06:30:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BF7FC433D2;
        Mon, 27 Feb 2023 06:30:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677479423;
        bh=OkkKd+AQuilhMHmzIPJvOT+D/nKGS6JpV/9LKlF5iAE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AzXui+vJWbScpZLRAm2pC2UVM2jlWGzm/XzW3mltOAQdmpKxw4q4WBWr8eBPZjbq7
         swJJt725zQCB2SXgl9BNd2Yo2A5ST2DF2SF3dDn3+qNGRPoUQSg5IEAMXTGf9o4JEp
         dP6H2G+tsTzhBuai986dgIsX4N9pxW+yXM5cy8r4=
Date:   Mon, 27 Feb 2023 07:30:20 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     KP Singh <kpsingh@kernel.org>
Cc:     linux-kernel@vger.kernel.org, pjt@google.com, evn@google.com,
        jpoimboe@kernel.org, tglx@linutronix.de, x86@kernel.org,
        hpa@zytor.com, peterz@infradead.org,
        pawan.kumar.gupta@linux.intel.com, kim.phillips@amd.com,
        alexandre.chartre@oracle.com, daniel.sneddon@linux.intel.com,
        corbet@lwn.net, bp@suse.de, linyujun809@huawei.com,
        jmattson@google.com, mingo@redhat.com, seanjc@google.com,
        andrew.cooper3@citrix.com, stable@vger.kernel.org
Subject: Re: [PATCH v3 2/2] Documentation/hw-vuln: Document the interaction
 between IBRS and STIBP
Message-ID: <Y/xN/JWUOPJNmoRE@kroah.com>
References: <20230227060541.1939092-1-kpsingh@kernel.org>
 <20230227060541.1939092-2-kpsingh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230227060541.1939092-2-kpsingh@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Feb 27, 2023 at 07:05:41AM +0100, KP Singh wrote:
> Explain why STIBP is needed with legacy IBRS as currently implemented
> (KERNEL_IBRS) and why STIBP is not needed when enhanced IBRS is enabled.
> 
> Fixes: 7c693f54c873 ("x86/speculation: Add spectre_v2=ibrs option to support Kernel IBRS")
> Cc: stable@vger.kernel.org
> Signed-off-by: KP Singh <kpsingh@kernel.org>
> ---
>  Documentation/admin-guide/hw-vuln/spectre.rst | 21 ++++++++++++++-----
>  1 file changed, 16 insertions(+), 5 deletions(-)


Hi,

This is the friendly patch-bot of Greg Kroah-Hartman.  You have sent him
a patch that has triggered this response.  He used to manually respond
to these common problems, but in order to save his sanity (he kept
writing the same thing over and over, yet to different people), I was
created.  Hopefully you will not take offence and will fix the problem
in your patch and resubmit it so that it can be accepted into the Linux
kernel tree.

You are receiving this message because of the following common error(s)
as indicated below:

- This looks like a new version of a previously submitted patch, but you
  did not list below the --- line any changes from the previous version.
  Please read the section entitled "The canonical patch format" in the
  kernel file, Documentation/process/submitting-patches.rst for what
  needs to be done here to properly describe this.

If you wish to discuss this problem further, or you have questions about
how to resolve this issue, please feel free to respond to this email and
Greg will reply once he has dug out from the pending patches received
from other developers.

thanks,

greg k-h's patch email bot
