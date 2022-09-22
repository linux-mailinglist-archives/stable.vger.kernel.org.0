Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43F005E5F47
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 12:04:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbiIVKEQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 06:04:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230196AbiIVKEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 06:04:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B47D6ABF2D;
        Thu, 22 Sep 2022 03:04:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70DD5B83595;
        Thu, 22 Sep 2022 10:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C33E4C433D7;
        Thu, 22 Sep 2022 10:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663841051;
        bh=x5+Lbg6OdD/L/wDxx25IzZpqRp8tfGtR2HgwDhgZ/ME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G6znEEZchfsOLsfUw4ZMLq9vSy7aMQzKHquymaGen1RZF20+XHldSBo//f37Gtkxv
         qxTJ4HewlsYkWreCqjCVoAwAePU7O6yEbIm3mI5XX/bW4QaR+wcbOkf7jNO/i086iD
         n5THvNqP2m7Cj54+oIrE2WdCz/9/4Co4vgnxGKjQ=
Date:   Thu, 22 Sep 2022 12:04:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chandan Babu R <chandan.babu@oracle.com>
Cc:     sashal@kernel.org, mcgrof@kernel.org, linux-xfs@vger.kernel.org,
        stable@vger.kernel.org, djwong@kernel.org, amir73il@gmail.com,
        leah.rumancik@gmail.com
Subject: Re: [PATCH 5.4 00/17] xfs stable patches for 5.4.y (from v5.5)
Message-ID: <YywzGEFApUMalXNn@kroah.com>
References: <20220921032352.307699-1-chandan.babu@oracle.com>
 <YyrS7dE8UtDydjZF@kroah.com>
 <Yysu56U3OYFozSLD@kroah.com>
 <871qs3pwu9.fsf@debian-BULLSEYE-live-builder-AMD64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <871qs3pwu9.fsf@debian-BULLSEYE-live-builder-AMD64>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 02:46:16PM +0530, Chandan Babu R wrote:
> On Wed, Sep 21, 2022 at 05:33:59 PM +0200, Greg KH wrote:
> > On Wed, Sep 21, 2022 at 11:01:33AM +0200, Greg KH wrote:
> >> On Wed, Sep 21, 2022 at 08:53:35AM +0530, Chandan Babu R wrote:
> >> > Hi Greg,
> >> > 
> >> > This 5.4.y backport series contains fixes from v5.5. The patchset has
> >> > been acked by Darrick.
> >> > 
> [...]
> >> > 
> >> 
> >> All now queued up, thanks.
> >
> > Any specific reason why you didn't also include 2 other commits in this
> > series, that fix issues that were created by some patches in this
> > series?
> >
> > I am referring to:
> > 	496b9bcd62b0 ("xfs: fix use-after-free when aborting corrupt attr inactivation")
> > 	6da1b4b1ab36 ("xfs: fix an ABBA deadlock in xfs_rename")
> >
> 
> I had not considered the possibility of fixes introducing regressions. I will
> test these patches and send them to the mailing list soon. Thanks for pointing
> out the missing patches.

Ok, let me drop these from the queue right now then, so that we don't
end up adding more problems then you are fixing :)

Please resend the whole new series again when they are ready.

thanks,

greg k-h

