Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CD685144E1
	for <lists+stable@lfdr.de>; Fri, 29 Apr 2022 10:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238626AbiD2I5Y (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 29 Apr 2022 04:57:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236950AbiD2I5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 29 Apr 2022 04:57:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 54474C44F3
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 01:54:06 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EE677B832D7
        for <stable@vger.kernel.org>; Fri, 29 Apr 2022 08:54:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A4FCC385A4;
        Fri, 29 Apr 2022 08:54:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1651222443;
        bh=7sxTxNSpghaTsV+LZi9fEWUUnVWXwA3/w7rupizoAWc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0sycRl+t7UkC6T9KnxS9w7M2AS9F2DLdaitECjk4re3HeXaDJ2sa7bzSu168YdBgx
         Pz9HhGNrMB5LiY1wUtu1ij2nF5KqW5ruLaRRqU9yZs0XGxnxLo8BRJ7kVEK1bmpGP0
         bZAASQXlSwSKz1lQtOyXfTi8FcLHp20Tf0BzNGDo=
Date:   Fri, 29 Apr 2022 10:54:00 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Robert Kolchmeyer <rkolchmeyer@google.com>
Cc:     stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>
Subject: Re: Request to cherry-pick 3db09e762dc7 to 4.14+
Message-ID: <YmunqO0belBlN1Ei@kroah.com>
References: <CAJc0_fxu9ehTRQYZ2A-WYhQ2bfXHoQGc1XL0cOrYLRavLMj71w@mail.gmail.com>
 <YmPHaOjWuegSYE6p@kroah.com>
 <CAJc0_fxR1wND+GjQ2uASvnOoWNdN_r3TOKi2CAy+9UBjfUv32w@mail.gmail.com>
 <CAJc0_fx8Lmi5d=CVA9KF6m7yxn+E0Phr1Lv=VJz1eCQyu4kzcA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJc0_fx8Lmi5d=CVA9KF6m7yxn+E0Phr1Lv=VJz1eCQyu4kzcA@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 28, 2022 at 04:32:25PM -0700, Robert Kolchmeyer wrote:
> I posted the 4.14 and 4.19 backports for review:
> 
> https://lore.kernel.org/stable/20220428232605.1231397-1-rkolchmeyer@google.com/T/#u
> https://lore.kernel.org/stable/20220428232534.1230905-1-rkolchmeyer@google.com/T/#u

Both now queued up, thanks!

greg k-h
