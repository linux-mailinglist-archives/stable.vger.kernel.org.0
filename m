Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E765532A04
	for <lists+stable@lfdr.de>; Tue, 24 May 2022 14:10:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237109AbiEXMFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 May 2022 08:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234556AbiEXMFJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 May 2022 08:05:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D0CB644D8
        for <stable@vger.kernel.org>; Tue, 24 May 2022 05:05:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EDCE61543
        for <stable@vger.kernel.org>; Tue, 24 May 2022 12:05:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB53C385AA;
        Tue, 24 May 2022 12:05:03 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="GdsRKiSy"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1653393901;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CQzn+ULQIsY5a6uvvJSnpwdv1yDItOMPm0/5lWHlw5k=;
        b=GdsRKiSyBqgUXRUiN5My5S5pMSxBsF38f9eMRAPMa8Xzo+rb73sFuk1pn3NZ8qfJAjHmBI
        536GzlxixdXIMsfduZWBVGCHkADeRkvMSJOrsCCn3yXTsP7TTohZKKAU6RLIKn3d06Dblo
        aa+wfWaBZlrOJ76GF6z7H9qEjJ9+XXo=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 03836c4f (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 24 May 2022 12:05:01 +0000 (UTC)
Date:   Tue, 24 May 2022 14:04:57 +0200
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
To:     gregkh@linuxfoundation.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: Re: random.c backports for 5.18, 5.17, 5.15, and prior
Message-ID: <YozJ6eFqFf5sHU+J@zx2c4.com>
References: <YouECCoUA6eZEwKf@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YouECCoUA6eZEwKf@zx2c4.com>
X-Spam-Status: No, score=-6.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 23, 2022 at 02:54:45PM +0200, Jason A. Donenfeld wrote:
> In this git repo [2], there are three branches: linux-5.15.y,
> linux-5.17.y, and linux-5.18.y, which contain backports for everything
> up to and including [1].

There's now a linux-5.10.y branch too.

Jason
