Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B17C25E5BB0
	for <lists+stable@lfdr.de>; Thu, 22 Sep 2022 08:53:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229821AbiIVGxM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Sep 2022 02:53:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbiIVGxM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 22 Sep 2022 02:53:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F7E2B4434;
        Wed, 21 Sep 2022 23:53:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA8B2629B0;
        Thu, 22 Sep 2022 06:53:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6ACCC433D7;
        Thu, 22 Sep 2022 06:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663829588;
        bh=GKFmWfbyCCo3vuVHQOkvoMyXPRd6/Jc/1Gqf/isN/ME=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UZXg0DjXVIlVX/SjUHdShXSKCcQB4352Lx9mruTdHusDi+y7wEA2PhsPlKgusH4AB
         JZWOTLwBNGjkA5CHUawiW2b1tlVlC3zdOiq/Fk7yKw4nEOyyYhXXCp7mehTli8+m2K
         +BtO50+rYzjofbuqUtmhUsox+KxKUbyA/Max6QGs=
Date:   Thu, 22 Sep 2022 08:53:38 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bagas Sanjaya <bagasdotme@gmail.com>
Cc:     Joe Perches <joe@perches.com>, linux-kernel@vger.kernel.org,
        akpm@linux-foundation.org, torvalds@linux-foundation.org,
        stable@vger.kernel.org, lwn@lwn.net, jslaby@suse.cz,
        Jason Wang <wangborong@cdjrlc.com>
Subject: Re: Linux 4.14.294
Message-ID: <YywGcg/Qgf8B8wEj@kroah.com>
References: <1663669061118192@kroah.com>
 <1663669061138255@kroah.com>
 <e9863ed5576cb93a6fd9b59cd19be9b71fda597d.camel@perches.com>
 <445878e0-d8c9-558f-73b7-8d39fa1a5cde@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <445878e0-d8c9-558f-73b7-8d39fa1a5cde@gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Sep 22, 2022 at 11:02:21AM +0700, Bagas Sanjaya wrote:
> On 9/22/22 01:03, Joe Perches wrote:
> > On Tue, 2022-09-20 at 12:17 +0200, Greg Kroah-Hartman wrote:
> > []
> >> diff --git a/drivers/hid/intel-ish-hid/ishtp-hid.h b/drivers/hid/intel-ish-hid/ishtp-hid.h
> > []
> >> @@ -118,7 +118,7 @@ struct report_list {
> >>   * @multi_packet_cnt:	Count of fragmented packet count
> >>   *
> >>   * This structure is used to store completion flags and per client data like
> >> - * like report description, number of HID devices etc.
> >> + * report description, number of HID devices etc.
> >>   */
> >>  struct ishtp_cl_data {
> >>  	/* completion flags */
> > 
> > Needless backporting of typo fixes reduces confidence in the
> > backport process.
> > 
> 
> The upstream commit 94553f8a218540 ("HID: ishtp-hid-clientHID: ishtp-hid-client:
> Fix comment typo") didn't Cc: stable, but got AUTOSELed [1].
> 
> I think we should only AUTOSEL patches that have explicit Cc: stable.

That's not how AUTOSEL works or why it is there at all, sorry.
