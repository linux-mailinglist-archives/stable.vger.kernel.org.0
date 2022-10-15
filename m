Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C16A5FFB03
	for <lists+stable@lfdr.de>; Sat, 15 Oct 2022 17:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbiJOP3c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 15 Oct 2022 11:29:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229567AbiJOP3b (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 15 Oct 2022 11:29:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93EDC24BEB;
        Sat, 15 Oct 2022 08:29:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52C93B80ABA;
        Sat, 15 Oct 2022 15:29:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87E47C433C1;
        Sat, 15 Oct 2022 15:29:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665847767;
        bh=KhYdy7ejyB5d6Go30tj2pav2W566YojdyrFrtMdH3uQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gtx/HYBLq4aP1FIxJn/iMi5Hxawr4grfPtBjlaRd+zd8NhSwVXmCfDBpAkQdTJwC7
         mYxvEvTTDOO8jqvDGkp4QjCtSkI7rKESNQT6oG92cGCUYJ7ZJHH5R3PZ6bKFywWveE
         DpH4DJ38oGIJhayA5QEywp4qDPKW598ed+TqJMAM=
Date:   Sat, 15 Oct 2022 17:30:13 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marcus Meissner <meissner@suse.de>,
        Jiri Kosina <jkosina@suse.de>
Subject: Re: [RFC v5.10 0/3] mac80211 use-after-free fix
Message-ID: <Y0rSBcPzqfOYJC59@kroah.com>
References: <20221014163906.23156-1-johannes@sipsolutions.net>
 <05b245f76948c081ac5384f69d3b993ae24ac950.camel@sipsolutions.net>
 <Y0mfPoTQT0QTFPVF@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y0mfPoTQT0QTFPVF@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 14, 2022 at 07:41:18PM +0200, Greg KH wrote:
> On Fri, Oct 14, 2022 at 06:56:44PM +0200, Johannes Berg wrote:
> > Sorry about the duplicate, I'm on a train to Berlin and network was
> > spotty.
> 
> No worries!  I'll do a round of stable updates with what we have right
> now tomorrow morning and then will look at these when I return home
> later tomorrow evening.  Thanks for doing them!

They look sane, thanks, all now queued up!

greg k-h
