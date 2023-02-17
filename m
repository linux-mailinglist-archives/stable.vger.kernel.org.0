Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F0A5869AD4B
	for <lists+stable@lfdr.de>; Fri, 17 Feb 2023 15:04:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229685AbjBQOEP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Feb 2023 09:04:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbjBQOEO (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Feb 2023 09:04:14 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AC3A67835;
        Fri, 17 Feb 2023 06:04:13 -0800 (PST)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id E979D5C008D;
        Fri, 17 Feb 2023 09:04:09 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 17 Feb 2023 09:04:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1676642649; x=1676729049; bh=JYD+K0NSfi
        9AOLieICaP5zFuHYuBfFIrwG19utBbT3Q=; b=hnRtpqXED+kCcCpCxZP0JKWPb1
        j1KGp05Fig3KP1TYelno1pUQT/D8DjABsBm1K3uHeMmsfso9LM08xOA9Ot675D5A
        PneqLZPXG2oJmJe8CuNuBF6uKiteTSoUJ63CQ0p3EwQqkzKjqOaSVJZgKGxyoDfB
        4jHOykDq8Z3ohBpxFiT7iIRFYKZJuPn5XG4z3VQc4rI0XR7WgWr4MuvmIUOCae6K
        Uoc13YNeNaQmf4XrftD6jKFtwAVgU8at15I0PpbJAwRYw9cumVhNt0bK1G0vOQT3
        5+hAYf/tY2isVRkgWC9iY3oLb9aLolYPFJSIHO57zhsRPnxT9Rdbr5lhIdJw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1676642649; x=1676729049; bh=JYD+K0NSfi9AOLieICaP5zFuHYuB
        fFIrwG19utBbT3Q=; b=owARVM+gzFI0ToBDD4y0TjK5mfbN5/5U+GvTK2ul20n8
        j9f+pByj2o4gSSwQYnbDNQSLyEkJHlFbn7B9udCcMxLeutWtauNbr12arL5OBdzl
        SWTEFUtT6lTxyrQu75pkZ9AOeRfOX7gPTEfqXpZXTUlQ8C6BUsdXs7TjXzqbdeD3
        rSeER2am5qAqPLKiatWFKdsPMcw4p0SPie7HaJ4zVfBKd/7pwU1iSD9YJiAQGagS
        hPCgQEuavJDfJPc6LqaZNlmA0tGRNlr7AL3VE7q+fkIEvkr8emB3yg9Ip16+1+5t
        pTWcqhR6cstqQvuSaZrh+aHXQzN7+FD+J0WPnEFOuA==
X-ME-Sender: <xms:WYnvY4spap7p53xCjiqMhGMsKpPmZE6SLVmmZgmG4VhI3TK0RKmUug>
    <xme:WYnvY1euoPIrNB0OmcSJHMtQlpR7i5m6sl3Yk2nTmNxEPjk2JhlXIax5n8Tji23IG
    QULOVmbcwm4Mg>
X-ME-Received: <xmr:WYnvYzy9oMxeSloXKzyr6ZlwgjLlWbM2l6zs3tSaavjm7zyKKuRBj9qTs7ns1GIvQ-Mb-qcruZKJH_xfNXf1G4VM1bctKOWI-Md31Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrudeiledgheejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:WYnvY7Pmp0rj3YttosV5SQkTGPt2CS-SxoYFPd3uG7KmmJMBGNrY0Q>
    <xmx:WYnvY4_QCcbvw92XDVrhaA6sDMhf3clExvZCsWcWLC6rVsAf4MbqDg>
    <xmx:WYnvYzXjSOqBSBiQ_-OFAo0VJ-wNsis7l0ZhDy3bRzJVuasel5OCqQ>
    <xmx:WYnvY52kUQ2sUV6Q8TATDWV6Ogh8CVY49zUviMM3quRsf13dJe_Abw>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 17 Feb 2023 09:04:09 -0500 (EST)
Date:   Fri, 17 Feb 2023 15:04:06 +0100
From:   Greg KH <greg@kroah.com>
To:     Anand Jain <anand.jain@oracle.com>
Cc:     stable@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Daan De Meyer <daandemeyer@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>
Subject: Re: [PATCH stable-5.4.y] btrfs: free device in btrfs_close_devices
 for a single device filesystem
Message-ID: <Y++JVrLeMPKl8CFg@kroah.com>
References: <03596be514e296d87240c2b044b7088962ad9f1c.1676435839.git.anand.jain@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <03596be514e296d87240c2b044b7088962ad9f1c.1676435839.git.anand.jain@oracle.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 15, 2023 at 12:53:03PM +0800, Anand Jain wrote:
> commit 5f58d783fd7823b2c2d5954d1126e702f94bfc4c upstream
> 
> We have this check to make sure we don't accidentally add older devices
> that may have disappeared and re-appeared with an older generation from
> being added to an fs_devices (such as a replace source device). This
> makes sense, we don't want stale disks in our file system. However for
> single disks this doesn't really make sense.
> 
> I've seen this in testing, but I was provided a reproducer from a
> project that builds btrfs images on loopback devices. The loopback
> device gets cached with the new generation, and then if it is re-used to
> generate a new file system we'll fail to mount it because the new fs is
> "older" than what we have in cache.
> 
> Fix this by freeing the cache when closing the device for a single device
> filesystem. This will ensure that the mount command passed device path is
> scanned successfully during the next mount.
> 
> CC: stable@vger.kernel.org # 5.10+
> Reported-by: Daan De Meyer <daandemeyer@fb.com>
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> Reviewed-by: David Sterba <dsterba@suse.com>
> Signed-off-by: David Sterba <dsterba@suse.com>
> Signed-off-by: Anand Jain <anand.jain@oracle.com>
> ---
> This patch has already been submitted for the LTS stable 5.10 and above.

Now queued up, thanks.

greg k-h
