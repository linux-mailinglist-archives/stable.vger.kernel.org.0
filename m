Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 28C055AEEA9
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 17:26:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239783AbiIFP0W (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 11:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238477AbiIFP0B (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 11:26:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4242F82F83;
        Tue,  6 Sep 2022 07:37:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C88966153F;
        Tue,  6 Sep 2022 14:13:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EFDCC433C1;
        Tue,  6 Sep 2022 14:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662473610;
        bh=ReLp09Oric94SThU8xEEdOiGbtIT/UTH/vw3wxdwKk0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pmOIdf7Z3hWXlnXbnO3UtcirFVgPFJgOhh6KPat8a6Sj7jQRdrK/cP1GawohAcprf
         BySnL4B5XWdknbhHNZ4/12Lc3SuvvnOVkk74jhEuk2HaonH3oBnv6bjxV8kgKkGMFw
         xjdw/ziMtaHfYLtmuBWaxoFIYWpoyJH4dYd3HBha+QqHFt8TF8/cNmeKnoMmGJR8r3
         /MCZY5AC5Uudr4ubzetANpJoY48X7g0QBksEPZ14UDrxHrY+jcN/EkQse2Kj/DheIH
         W137MKWkFREhml+9+IxTJ7roWMqUuzLG3k9hyjRiGy0zLopeTfu0UuAjbeFRrFrm5b
         jkJYEjZii+T6w==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1oVZKY-0000Gg-3k; Tue, 06 Sep 2022 16:13:34 +0200
Date:   Tue, 6 Sep 2022 16:13:34 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH stable-5.15 0/2] USB: serial: ch341: backports to 5.15
Message-ID: <YxdVjgURG/FmSPtL@hovoldconsulting.com>
References: <20220906122127.31321-1-johan@kernel.org>
 <YxdI6mtLKqW/s3WQ@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YxdI6mtLKqW/s3WQ@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Sep 06, 2022 at 03:19:38PM +0200, Greg Kroah-Hartman wrote:
> On Tue, Sep 06, 2022 at 02:21:25PM +0200, Johan Hovold wrote:
> > Here are backports of two patches that failed to apply to 5.15 and older
> > stable trees.
> > 
> > Only the first one actually needed to have some context adjusted.
> 
> Applied to 5.10.y and 5.15.y.  didn't apply to anything older, odds are
> no one cares about this driver for those kernels anyway :)

True. But now backported for "completeness". :)

Johan
