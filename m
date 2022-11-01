Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FC45615259
	for <lists+stable@lfdr.de>; Tue,  1 Nov 2022 20:33:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiKATdV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Nov 2022 15:33:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229636AbiKATdU (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Nov 2022 15:33:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCA312ACE
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 12:33:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5FCCFB81F0E
        for <stable@vger.kernel.org>; Tue,  1 Nov 2022 19:33:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32DC9C433D6;
        Tue,  1 Nov 2022 19:33:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667331197;
        bh=09IQBumYQ3CthozdLuOLaZ/SdazLOjjR7KXAIkTliC0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c1XU7RNxEpw7ZJIV7GJlS6zTUh5i3GTtlAHad3g350CHCPV/IwlwtShQJsQzPgj9p
         rGmnqqLGYkanQp6ZASg2SkXDwn0nVt9iJERcv6RBwojUKohUjCfq2d0HteIqQWlgBG
         WqCdJ0//NpgTmipQc9yltbmkTtxd2FldJD6hivuM=
Date:   Tue, 1 Nov 2022 20:34:11 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Anil Altinay <aaltinay@google.com>
Cc:     stable@vger.kernel.org
Subject: Re: Backporting 7a62ed61367b8fd01bae1e18e30602c25060d824 to 5.15
 stable
Message-ID: <Y2F0s/+TDf7deuIg@kroah.com>
References: <CACCxZWP-O07hx0QpZNkuG9xPH-QG71t-1e5qZU8hNkkyvFKVhA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACCxZWP-O07hx0QpZNkuG9xPH-QG71t-1e5qZU8hNkkyvFKVhA@mail.gmail.com>
X-Spam-Status: No, score=-8.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Oct 31, 2022 at 11:25:32AM -0700, Anil Altinay wrote:
> Hi,
> 
> Can you please backport the following commit to 5.15 stable?
> Title: "af_unix: Fix memory leaks of the whole sk due to OOB skb."
> Commit SHA: 7a62ed61367b8fd01bae1e18e30602c25060d824
> 
> This commit fixes "314001f0bf927015e459c9d387d62a231fe93af3" which
> landed on "tags/v5.15-rc1~157^2~305".

As this commit does not apply cleanly on the 5.15.y tree, how was it
tested?

Can you provide a working version of this change so that we can apply
it?

thanks,

greg k-h
