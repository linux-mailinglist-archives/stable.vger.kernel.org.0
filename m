Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 25A306A6901
	for <lists+stable@lfdr.de>; Wed,  1 Mar 2023 09:43:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjCAInj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 03:43:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbjCAInh (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 03:43:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A04ACEB7B;
        Wed,  1 Mar 2023 00:43:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5B597B80F62;
        Wed,  1 Mar 2023 08:43:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96608C433D2;
        Wed,  1 Mar 2023 08:43:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677660214;
        bh=P6TBSi7zwnxjHUc4Xu9qIrJQ1O+gRdm3CdFxFAvnTMQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vmf+xNm+/EyDIzdH4PQ7EthTPPt8vHSAD2YLnDI0yce/+r4DcqL49wuoycs65t4gS
         5CjIfhuBJL5DYNJTR4Rv3vWQmyRQZDxuEcpl5Dk0p7DyzfTK10f9U1Ek3D3D8gFNCu
         ncrJpxccLNJLSA8r+FaEXYqZEdSY5JCsUCRr/UlQ=
Date:   Wed, 1 Mar 2023 09:43:31 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Willy Tarreau <w@1wt.eu>, Slade Watkins <srw@sladewatkins.net>,
        Sasha Levin <sashal@kernel.org>,
        Amir Goldstein <amir73il@gmail.com>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org
Subject: Re: AUTOSEL process
Message-ID: <Y/8QMzvyZeb7j8XX@kroah.com>
References: <Y/1em4ygHgSjIYau@sashalap>
 <Y/136zpJSWx96YEe@sol.localdomain>
 <CAOQ4uxietbePiWgw8aOZiZ+YT=5vYVdPH=ChnBkU_KCaHGv+1w@mail.gmail.com>
 <Y/3lV0P9h+FxmjyF@kroah.com>
 <8caf1c23-54e7-6357-29b0-4f7ddf8f16d2@sladewatkins.net>
 <Y/7fFHv3dU6osd6x@sol.localdomain>
 <Y/7sLcCtsk9oqZH0@kroah.com>
 <Y/79Tfn5kFIItUDD@sol.localdomain>
 <Y/8BU4cyySwQZSII@1wt.eu>
 <Y/8NWuHX0Sff+DhY@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y/8NWuHX0Sff+DhY@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 01, 2023 at 12:31:22AM -0800, Eric Biggers wrote:
> On Wed, Mar 01, 2023 at 08:40:03AM +0100, Willy Tarreau wrote:
> > But it's going into a dead end. You are the one saying that changes
> > are easy, suggesting to use get_maintainers.pl, so easy that you can't
> > try to adapt them in existing stuff. Even without modifying existing
> > scripts, if you are really interested by such features, why not at least
> > try to run your idea over a whole series, figure how long it takes, how
> > accurate it seems to be, adjust the output to remove unwanted noise and
> > propose for review a few lines that seem to do the job for you ?
> > 
> 
> As I said, Sasha *already does this for AUTOSEL*.  So it seems this problem has
> already been solved, but Sasha and Greg are not coordinating with each other.

We do not share the same scripts for these tasks as we have different
roles here.  That's all, nothing malicious.

thanks,

greg k-h
