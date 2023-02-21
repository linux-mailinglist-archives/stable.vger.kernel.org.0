Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BDF069E8E4
	for <lists+stable@lfdr.de>; Tue, 21 Feb 2023 21:10:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbjBUUKG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Feb 2023 15:10:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230098AbjBUUKF (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Feb 2023 15:10:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCE91311F0;
        Tue, 21 Feb 2023 12:09:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2B8F2611B6;
        Tue, 21 Feb 2023 20:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16709C433EF;
        Tue, 21 Feb 2023 20:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677010175;
        bh=PDlZrmXnGxViFhO+UyI439zNPqKOHgyGApQNdK17fWw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=acOYXC1rU8WOHugWLCP0XWMFBGugXvlyJY0ExSVTt+KEgbuCn8/3STkYDqZ8AH0Uy
         gv9su2T2P4KsHHo9Rey5pcBpVca7Z3RsTvYsU7Jg4jOoV5y9569gz2kUujMczVNGxd
         3pzV3qVWZi+q6HFamtftL0Noq2zl5V0Feqd8Dw78=
Date:   Tue, 21 Feb 2023 21:09:32 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     KP Singh <kpsingh@kernel.org>, linux-kernel@vger.kernel.org,
        pjt@google.com, evn@google.com, jpoimboe@kernel.org,
        tglx@linutronix.de, x86@kernel.org, hpa@zytor.com,
        peterz@infradead.org, pawan.kumar.gupta@linux.intel.com,
        kim.phillips@amd.com, alexandre.chartre@oracle.com,
        daniel.sneddon@linux.intel.com, corbet@lwn.net, bp@suse.de,
        linyujun809@huawei.com, jmattson@google.com,
        =?iso-8859-1?Q?Jos=E9?= Oliveira <joseloliveira11@gmail.com>,
        Rodrigo Branco <rodrigo@kernelhacking.com>,
        Alexandra Sandulescu <aesa@google.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/2] x86/speculation: Allow enabling STIBP with legacy
 IBRS
Message-ID: <Y/Uk/CnJq+F2idie@kroah.com>
References: <20230221184908.2349578-1-kpsingh@kernel.org>
 <Y/UbqiHQ2/aczPzg@kroah.com>
 <CACYkzJ7pLhJ+NfUq36PaMxadkgv-cPtO60TW=g_Nh7vU1vEWqA@mail.gmail.com>
 <Y/Uf2lnU/VcsFs1O@kroah.com>
 <Y/UiJmv7j12hOe0k@zn.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/UiJmv7j12hOe0k@zn.tnic>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 21, 2023 at 08:57:26PM +0100, Borislav Petkov wrote:
> On Tue, Feb 21, 2023 at 08:47:38PM +0100, Greg KH wrote:
> > Why does anyone need to "drop stable" from a patch discussion?  That's
> > not a problem, we _WANT_ to see the patch review and discussion also
> > copied there to be aware of what is coming down the pipeline.  So
> > whomever said that is not correct, sorry.
> 
> Someone dropped stable because you used to send automated formletter
> mails that this is not how one should submit a patch to stable. I guess
> that is not needed anymore so I'll stop dropping stable.

I still send them, and so does 0-day, IF you send the emails
incorrectly.  So far, that's not been the case for this series at all
(hint, there needs to be a cc: stable in the signed-off-by area of the
patch, that's all.)

thanks,

greg k-h
