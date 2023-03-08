Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E41A96B08B2
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 14:29:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230013AbjCHN3C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 08:29:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230161AbjCHN2g (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 08:28:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E06DB3C780
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 05:27:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94207B81CB1
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 13:27:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 912D5C433AE;
        Wed,  8 Mar 2023 13:27:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678282043;
        bh=/eQSW5TM7+K5PgVT2TLWeu9IHwOzc9otKTIJcJmswD0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E2sMduDLeH6cLYnMWvDnrrOwEBeQbdoMMmxTUD0VS26/DgkJ5eNWa9ujMgjj9HWeg
         cOkV48sDxQh9lnTYmRcGXFUdQWdg4R5LE4VeQD8lAdTc/xLJD7TqHEMDEl5mQXuKql
         whj99Os8Moh+U55KVj4dV7Tjq/oCszEQYF6kr2rs=
Date:   Wed, 8 Mar 2023 14:27:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dmitry Goncharov <dgoncharov@users.sf.net>
Cc:     Eric Biggers <ebiggers@kernel.org>, bug-make@gnu.org,
        stable@vger.kernel.org
Subject: Re: No progress output when make 4.4.1 builds Linux 4.19 and earlier
Message-ID: <ZAiNN0wkLpdjY1Y2@kroah.com>
References: <ZAgnmbYtGa80L731@sol.localdomain>
 <ZAgogdFlu69QlYwu@kroah.com>
 <CAG+Z0CuAQsq-1DNaX0_qHnqSBt1YrUBbBaypxgwT0USFyOkk4g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAG+Z0CuAQsq-1DNaX0_qHnqSBt1YrUBbBaypxgwT0USFyOkk4g@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 08, 2023 at 08:12:57AM -0500, Dmitry Goncharov wrote:
> On Wed, Mar 8, 2023 at 1:37 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> > On Tue, Mar 07, 2023 at 10:13:45PM -0800, Eric Biggers wrote:
> ...
> > > Is this an intentional breakage from the 'make' side?
> No it is not an intentional breakage.
> This is a fix for https://savannah.gnu.org/bugs/?63347.
> 
> > The fact that kernels 5.4 and newer imply to me that there is
> > a kernel build fix that should resolve this if someone can take the time
> > to bisect it...
> 
> Kernel makefile was updated to work with old and new make in
> 4bf73588165ba7d32131a043775557a54b6e1db5.
> If you wanted to backport, try this commit.

Nice, that worked for me!  I'll go queue that up for the stable kernels
now, thank you for the quick response.

greg k-h
