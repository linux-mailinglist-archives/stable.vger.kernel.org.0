Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B858D58D3EC
	for <lists+stable@lfdr.de>; Tue,  9 Aug 2022 08:38:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232735AbiHIGiO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Aug 2022 02:38:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbiHIGiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Aug 2022 02:38:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C13818B27;
        Mon,  8 Aug 2022 23:38:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2190D61212;
        Tue,  9 Aug 2022 06:38:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7E69C433C1;
        Tue,  9 Aug 2022 06:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660027091;
        bh=kEDz6U1fYtswquqqI2nyeY3OyMypzP6JXVMOhJptEnw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ixpdt38b/Zy4nNvktyTEpyPEpKDMDIHN2+nz4rqj7M1s3P+3qb0adNY9FiTAC5WeJ
         p33MFI09VcKcKbGvjL2JCxuugjInTmoacM6/UlVWXmGdVAzpspNIKUhiRA8TgH5wH9
         bPrZLMP7kqFBQ0hOy73AysQVkpOhUFyYzbm5H2zc=
Date:   Tue, 9 Aug 2022 08:38:07 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qu Wenruo <quwenruo.btrfs@gmx.com>
Cc:     Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH STABLE 4.9 5.4 0/2] btrfs: raid56 backports to reduce
 destructive RMW
Message-ID: <YvIAz7g8rdp3tdl/@kroah.com>
References: <cover.1659599526.git.wqu@suse.com>
 <YvETDmzlSBMpObNm@kroah.com>
 <02c30c99-b469-7b55-ddf2-7cff177e40ce@gmx.com>
 <YvH1cU3XZLI093KZ@kroah.com>
 <a2d95460-af6b-f397-5019-ab09242f944e@gmx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a2d95460-af6b-f397-5019-ab09242f944e@gmx.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 09, 2022 at 02:08:31PM +0800, Qu Wenruo wrote:
> 
> 
> On 2022/8/9 13:49, Greg KH wrote:
> > On Tue, Aug 09, 2022 at 06:28:06AM +0800, Qu Wenruo wrote:
> > > 
> > > 
> > > On 2022/8/8 21:43, Greg KH wrote:
> > > > On Thu, Aug 04, 2022 at 03:54:17PM +0800, Qu Wenruo wrote:
> > > > > Hi Greg and Sasha,
> > > > > 
> > > > > This two patches are backports for stable branchs from v4.9 to v5.4.
> > > > 
> > > > Please note that these commits are not even in a public release from
> > > > Linus yet, so I would need a LOT of assurance from the BTRFS maintainers
> > > > that they are all allowed to be taken now as that goes against the
> > > > normal development cycle here.
> > > 
> > > Does this mean, normally backports only happen after a full release, not
> > > just after -rc releases?
> > 
> > After a -rc release.
> 
> Got it, will wait for the -rc release, and meanwhile prepare a v5.19
> backport too.

And get an ack from the btrfs maintainers please that these are ok to be
backported to stable kernels, as they originally were not marked as
such.

thanks,

greg k-h
