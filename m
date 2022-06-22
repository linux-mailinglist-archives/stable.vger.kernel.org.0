Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 547E155434C
	for <lists+stable@lfdr.de>; Wed, 22 Jun 2022 09:04:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351750AbiFVGxl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jun 2022 02:53:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352098AbiFVGx0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Jun 2022 02:53:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65843FD1C;
        Tue, 21 Jun 2022 23:53:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EB92B81A8C;
        Wed, 22 Jun 2022 06:53:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A1DC34114;
        Wed, 22 Jun 2022 06:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655880803;
        bh=fkCnpyOGxXVQBQzpIq+Cax/ef+Xx5fbgJz5m7udLC4Q=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=la0eq7ccOqwl+3Lvmh43wZ9e3iiF0FnyS9XkdlnBatlX35ZzkaVpGY3dY6ZAniJZH
         C4ByUlmUd6reQ/Z5XRZtmMxCA06QEnV+DlmFY8eMJagmb6Wx0HPrx+SlOQT29dimf/
         e24paj8OcscGYq92PM5deNGqXGRACavtsuf/dfgACY+L/iLuSxmz0QkAOaow4lcTQT
         4AtCCKAM+ER1fJtr9Hm4cAmAeQ6epvJOUucm9KOHQ2YGg/zNyPX8b/x0zXyaGSFQl3
         JXAAuRfjawt0l1Fr13j9pDU5RcUr9O2Y5POs3Eg/WEjIIwTFDb8V0os664Qz/iYkoe
         EyftOkdCoCnqA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1o3uEo-0004NB-UT; Wed, 22 Jun 2022 08:53:19 +0200
Date:   Wed, 22 Jun 2022 08:53:18 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        charles-yeh@prolific.com.tw, Charles Yeh <charlesyeh522@gmail.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH] USB: serial: pl2303: add support for more HXN (G) types
Message-ID: <YrK8Xmv3vT1VFw+q@hovoldconsulting.com>
References: <20220621085855.6252-1-johan@kernel.org>
 <YrGKK7Ua20Boz1oZ@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YrGKK7Ua20Boz1oZ@kroah.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jun 21, 2022 at 11:06:51AM +0200, Greg Kroah-Hartman wrote:
> On Tue, Jun 21, 2022 at 10:58:55AM +0200, Johan Hovold wrote:
> > Add support for further HXN (G) type devices (GT variant, GL variant, GS
> > variant and GR) and document the bcdDevice mapping.
> > 
> > Note that the TA and TB types use the same bcdDevice as some GT and GE
> > variants, respectively, but that the HX status request can be used to
> > determine which is which.
> > 
> > Also note that we currently do not distinguish between the various HXN
> > (G) types in the driver but that this may change eventually (e.g. when
> > adding GPIO support).
> > 
> > Reported-by: Charles Yeh <charlesyeh522@gmail.com>
> > Link: https://lore.kernel.org/r/YrF77b9DdeumUAee@hovoldconsulting.com
> > Cc: stable@vger.kernel.org	# 5.13
> > Signed-off-by: Johan Hovold <johan@kernel.org>

> Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

Thanks for reviewing. Now applied.

Johan
