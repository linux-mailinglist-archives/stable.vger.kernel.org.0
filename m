Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EFD756D0548
	for <lists+stable@lfdr.de>; Thu, 30 Mar 2023 14:51:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231524AbjC3MvY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Mar 2023 08:51:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229895AbjC3MvX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 30 Mar 2023 08:51:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E19A8A6;
        Thu, 30 Mar 2023 05:51:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DAF662047;
        Thu, 30 Mar 2023 12:51:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63714C433EF;
        Thu, 30 Mar 2023 12:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680180681;
        bh=coIsgc+CiBcPlgInJagIMgb3EffrlH1xxW1EcxZen1Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Np0P0NKXupGHOcio5+c3CZ39JYWgICbWKaEBjM44Aavq8WgcFLAodQanvl0bAmyC1
         LdY5gkd+rC69rAHp2X/joIb/kLBMXvedMfElNJolGwa0fvEZDv/30GbFJo0giegJHb
         yFIjrTewxY1usaE0TeHOBQjDXc2bL6ho0gg/l/9Q=
Date:   Thu, 30 Mar 2023 14:51:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tudor Ambarus <tudor.ambarus@linaro.org>
Cc:     stable@kernel.org, stable@vger.kernel.org, tytso@mit.edu,
        adilger.kernel@dilger.ca, boyu.mt@taobao.com,
        linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
        leejones@google.com, Ye Bin <yebin10@huawei.com>,
        syzbot+4faa160fa96bfba639f8@syzkaller.appspotmail.com,
        Jun Nie <jun.nie@linaro.org>
Subject: Re: [PATCH RESEND][for-stable 5.10, 5.4, 4.19, 4.14] ext4: fix
 kernel BUG in 'ext4_write_inline_data_end()'
Message-ID: <ZCWFx_iRPRr1Afw0@kroah.com>
References: <20230307103840.2603092-1-tudor.ambarus@linaro.org>
 <42739df1-8b63-dfd6-6ec5-6c59d5d41dd8@linaro.org>
 <ZCV6I-CBHVw2GPre@kroah.com>
 <661ff1fb-ab0d-e0a3-693c-073443f556df@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <661ff1fb-ab0d-e0a3-693c-073443f556df@linaro.org>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 30, 2023 at 01:21:55PM +0100, Tudor Ambarus wrote:
> 
> 
> On 3/30/23 13:01, Greg KH wrote:
> > On Thu, Mar 30, 2023 at 12:42:27PM +0100, Tudor Ambarus wrote:
> >> + stable@vger.kernel.org
> >>
> >> Hi!
> >>
> >> Can we queue this to Linux stable, please?
> > 
> > Queue what exactly?
> > 
> 
> The patch on which we reply:
> https://lore.kernel.org/all/20230307103840.2603092-1-tudor.ambarus@linaro.org/
> 
> Shall I do something different next time?

Please resend, your commit message is very confusing and this patch is
long out of my review queue for some reason.

thanks,

greg k-h
