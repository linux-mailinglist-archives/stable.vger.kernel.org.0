Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 127215FF309
	for <lists+stable@lfdr.de>; Fri, 14 Oct 2022 19:40:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiJNRki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Oct 2022 13:40:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiJNRkh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Oct 2022 13:40:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EA13F7096;
        Fri, 14 Oct 2022 10:40:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4173B821B9;
        Fri, 14 Oct 2022 17:40:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB0F4C433C1;
        Fri, 14 Oct 2022 17:40:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665769234;
        bh=sZv4tT1NktlJCdklLMSqGglGDp5CEWez0v0Fpf/NyMo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BrgWGgnCQS/SgJEMXRaaTjttVZATbo92FtIQYwxmldwaDBTlSPEIB9bNJ+DAEm3Hc
         1MYR4rNanXsqhGbXmgWX3ZUfVmkDZYpgXsyjMiQxRduvkWTUV5jN0o1uRu/0WVY6F0
         sY4UNfpF9Ik7AQLJ7mOkJVP8Dm7TXMZsNXzD2lAs=
Date:   Fri, 14 Oct 2022 19:41:18 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-wireless@vger.kernel.org, stable@vger.kernel.org,
        Felix Fietkau <nbd@nbd.name>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Marcus Meissner <meissner@suse.de>,
        Jiri Kosina <jkosina@suse.de>
Subject: Re: [RFC v5.10 0/3] mac80211 use-after-free fix
Message-ID: <Y0mfPoTQT0QTFPVF@kroah.com>
References: <20221014163906.23156-1-johannes@sipsolutions.net>
 <05b245f76948c081ac5384f69d3b993ae24ac950.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05b245f76948c081ac5384f69d3b993ae24ac950.camel@sipsolutions.net>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 14, 2022 at 06:56:44PM +0200, Johannes Berg wrote:
> Sorry about the duplicate, I'm on a train to Berlin and network was
> spotty.

No worries!  I'll do a round of stable updates with what we have right
now tomorrow morning and then will look at these when I return home
later tomorrow evening.  Thanks for doing them!

greg k-h
