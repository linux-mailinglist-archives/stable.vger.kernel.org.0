Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6681D65A993
	for <lists+stable@lfdr.de>; Sun,  1 Jan 2023 11:20:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbjAAKUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 1 Jan 2023 05:20:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51352 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjAAKUv (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 1 Jan 2023 05:20:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33BB710C5
        for <stable@vger.kernel.org>; Sun,  1 Jan 2023 02:20:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B982C60C01
        for <stable@vger.kernel.org>; Sun,  1 Jan 2023 10:20:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11DEC433EF;
        Sun,  1 Jan 2023 10:20:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672568449;
        bh=RHrs/fQdgfGzS8njOcsGB02qvTeG4aNG1LcbjAI/mlQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XXjRXoVAeSa5bCYEtv7t5EEEQML4PjFE1q22HodQfMcvWSIJ+Y1mdvkxHmqenSHzQ
         k2G3/9PWcWmUd36Ra6LXorRmn1R/Oq4EYT547jzPqDG041F+V85j7whS/3zk993zAi
         ECmr3UO8hC6UrByitOMGct9ZxKOGd7nGMbPrziMk=
Date:   Sun, 1 Jan 2023 11:20:45 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     =?utf-8?Q?=C5=81ukasz_Kalam=C5=82acki?= <lukasz@pm.kalamlacki.eu>
Cc:     Willy Tarreau <w@1wt.eu>, stable@vger.kernel.org
Subject: Re: Cannot compile 6.1.2 kernel release
Message-ID: <Y7FefVRwIQZWUosS@kroah.com>
References: <b0ef1e48-ca8d-9a5e-6e21-688711dab650@pm.kalamlacki.eu>
 <20230101065337.GA20539@1wt.eu>
 <d3f0d0a5-a15f-9735-5f12-b1c00a474531@pm.kalamlacki.eu>
 <Y7FIo0Eup6TKswTA@kroah.com>
 <187e8f10-2b73-3a18-d9ad-48b2d84bd6b9@pm.kalamlacki.eu>
 <20230101100518.GA21587@1wt.eu>
 <36e196c7-849f-bcda-4dbc-da9c0c492bbd@pm.kalamlacki.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <36e196c7-849f-bcda-4dbc-da9c0c492bbd@pm.kalamlacki.eu>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sun, Jan 01, 2023 at 10:12:12AM +0000, Łukasz Kalamłacki wrote:
> Allright, my kernel config is available here:
> https://kalamlacki.eu/KERNELS/kconfig-6.1
> 
> Compilation on 11th gen i5 core cpu using command:
> 
> make -j 9 bindeb-pkg

As we have both stated, we are not the people to be discussing this
with as the kernel source is not the problem at all, so there's nothing
we can do here, sorry.

Have a good new year!

greg k-h
