Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0920665A95F
	for <lists+stable@lfdr.de>; Sun,  1 Jan 2023 09:48:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229631AbjAAIsy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Jan 2023 03:48:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjAAIsx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Jan 2023 03:48:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCD545FAB;
        Sun,  1 Jan 2023 00:48:52 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 77593B80958;
        Sun,  1 Jan 2023 08:48:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C782CC433D2;
        Sun,  1 Jan 2023 08:48:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672562930;
        bh=0laKcUnYZy1Wya1Ad43Dj/S22zlWyrWGL+9dUxMLiNs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=u36Rz//bHNhoecebTMT2cllilLm5ndeUoZ9CZ4+i5cTqyNuamxVfKjcy0ysmmCtsw
         ysUX6a/1S+9EvweO446H+EUDb5fAnedPpbQmg20GyPMkdOuyk0NGnQjUFw3dIIbONA
         rBWQ/K6VnlQbhT7ug+eAZCPffIeh9Ps5UZsBotW4=
Date:   Sun, 1 Jan 2023 09:48:47 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     linux-kernel@vger.kernel.org, Paul McKenney <paulmck@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Zhouyi Zhou <zhouzhouyi@gmail.com>, stable@vger.kernel.org,
        Davidlohr Bueso <dave@stgolabs.net>,
        Josh Triplett <josh@joshtriplett.org>
Subject: Re: [PATCH] torture: Fix hang during kthread shutdown phase
Message-ID: <Y7FI71mW7ZJZDiTI@kroah.com>
References: <20230101061555.278129-1-joel@joelfernandes.org>
 <CAEXW_YQyieW+w-VJ48N5kMkQo-RzJhFXD2kBR91B0KqhVFJNbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXW_YQyieW+w-VJ48N5kMkQo-RzJhFXD2kBR91B0KqhVFJNbw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 01, 2023 at 01:20:01AM -0500, Joel Fernandes wrote:
> On Sun, Jan 1, 2023 at 1:16 AM Joel Fernandes (Google)
> > Cc: Paul McKenney <paulmck@kernel.org>
> > Cc: Frederic Weisbecker <fweisbec@gmail.com>
> > Cc: Zhouyi Zhou <zhouzhouyi@gmail.com>
> > Cc: <stable@vger.kernel.org> # 6.0.x
> 
> Question for stable maintainers:
> This patch is for mainline and 6.0 stable. However, it should also go
> to 6.1 stable. How do we tag it to do that? I did not know how to tag
> 2 stable versions. I guess the above implies > 6.0 ?

The above implies 6.0 and newer already which included 6.1, so all is
good.

