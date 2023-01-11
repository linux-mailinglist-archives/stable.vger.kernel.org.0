Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1215E66538C
	for <lists+stable@lfdr.de>; Wed, 11 Jan 2023 06:20:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236356AbjAKFUI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Jan 2023 00:20:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbjAKFSd (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Jan 2023 00:18:33 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABDF115812;
        Tue, 10 Jan 2023 21:11:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 246D6CE1AAF;
        Wed, 11 Jan 2023 05:11:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D74E2C433EF;
        Wed, 11 Jan 2023 05:11:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673413877;
        bh=JQud3bdxfW9d13HD1Va8xDyL1hemNpLFahGhhl8nLUk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TVutJN7rf0VxtG8MsHWzP2cIAO+/SLKDdyhbnT9gu0sILNj78HUbBTulQtLHAs84S
         4c56wNngFx4OGZFkFFtrWrbICDgq6cm8uC1upI+oROr6zwPG17oGaTmq+AJ4O0W7OJ
         qNBGq0Fd9SvaOQZIMuM6ejtMAS4jEswgGUZuHqOg=
Date:   Wed, 11 Jan 2023 06:11:13 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sedat Dilek <sedat.dilek@gmail.com>
Cc:     Sasha Levin <sashal@kernel.org>, helpdesk@kernel.org,
        stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Michael Larabel <Michael@michaellarabel.com>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Please, clear statement to what is next LTS linux-kernel
Message-ID: <Y75E8Y7FPGjxL0xx@kroah.com>
References: <CA+icZUUYrasObBwMQWae=+eAfUzvxc1Pk39QFz9=NXedWO41Vg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUUYrasObBwMQWae=+eAfUzvxc1Pk39QFz9=NXedWO41Vg@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 10, 2023 at 09:22:48PM +0100, Sedat Dilek wrote:
> Happy new 2023,
> 
> I normally watch [1] for the next LTS linux-kernel which is for me an
> official site and for an official announcement.
> 
> On the debian-kernel mailing list you read Linux 6.1 will be the
> official one for Debian-12 aka bookworm.
> 
> I saw a phoronix article about EOL of Linux-4.9 [3] which points to [2].
> 
> [2] says:
> 
> After being prompted on the kernel mailing list, Linux stable
> maintainer Greg Kroah-Hartman commented:
> > I usually pick the "last kernel of the year", and based on the normal release cycle, yes, 6.1 will be that kernel.
> > But I can't promise anything until it is released, for obvious reasons.
> 
> This is not a clear statement for me and was maybe at a point where
> 6.1 was not released.
> 
> If you published a clear statement please point me to it.
> And if so, please update [1] accordingly.
> ( It dropped 4.9 from LTS list recently from [1] - guess Konstantin or
> someone from helpdesk did - so [1] is actively maintained. )
> 
> Please, a clear statement.

Why exactly do you need a "clear statement"?  What will that change (or
not change) if it is made?

Please see this previous thread for what I need from others before I can
make such a thing:
	https://lore.kernel.org/r/Y53BputYK+3djDME@kroah.com

Can you help answer those questions for your use case please?  That will
help us make our decision.

thanks,

greg k-h
