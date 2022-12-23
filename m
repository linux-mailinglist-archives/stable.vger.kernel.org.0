Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0ECAA6552FD
	for <lists+stable@lfdr.de>; Fri, 23 Dec 2022 17:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232156AbiLWQ7V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Dec 2022 11:59:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55866 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230372AbiLWQ7U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Dec 2022 11:59:20 -0500
Received: from relay4-d.mail.gandi.net (relay4-d.mail.gandi.net [217.70.183.196])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29BDE1D3;
        Fri, 23 Dec 2022 08:59:17 -0800 (PST)
Received: (Authenticated sender: m@thi.eu.com)
        by mail.gandi.net (Postfix) with ESMTPSA id 2A167E0007;
        Fri, 23 Dec 2022 16:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mathieu.digital;
        s=gm1; t=1671814756;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=WXSI10IVXOKLpHLEwsDwP4LsVDE3OI15YMpQoBhxAL8=;
        b=oEvYSA5/fBypDBAgb94T5+/5R7pAlcV1XBOT2I+vPJSXrHp3PUlore0Tya+hneubo8pwPq
        Z8c21oMmxdjfYoJ37GWhM1uxOeVR8EXFkO75DExXXigqKbgF8Hz4hhNxgdNlpXSHIzgG0O
        jV3/bTV3QI61RWzNn6cFuomzT0DH/UEmysesqJNUaP86w6OxaVMy/gQ3xigd48l5aGOk0d
        kQClBZwsf71nJbkU91968nfgvY8gd1icRWz6L1Sp3lbvPqWzhrK2m6gwshWflYQ5CGqAye
        pbUWxp+03/Zr+sOkFwwdks37Jek0hEmkANi21S3ckGN6yIo9PmbRzqyOzlT5bA==
Received: by paranoid-android.localdomain (Postfix, from userid 1000)
        id 9988440090F40; Fri, 23 Dec 2022 17:59:14 +0100 (CET)
Date:   Fri, 23 Dec 2022 17:59:14 +0100
From:   Mathieu Chouquet-Stringer <me@mathieu.digital>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, rafael.j.wysocki@intel.com,
        linux-rtc@vger.kernel.org, linux-acpi@vger.kernel.org,
        rafael@kernel.org, mgorman@techsingularity.net,
        alexandre.belloni@bootlin.com
Subject: Re: Fix for rtc driver boot breakage in 6.0.y
Message-ID: <Y6XeYmbil6X0WgMZ@paranoid-android>
References: <Y6D958DeurSuoCuY@paranoid-android>
 <Y6NOm7CE03isRJiW@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6NOm7CE03isRJiW@kroah.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Dec 21, 2022 at 07:21:15PM +0100, Greg KH wrote:
> All of these are in 6.0.14, can you test that to verify it all is
> working properly for you?

Indeed, all is good now.

Thanks,
-- 
Mathieu Chouquet-Stringer                             me@mathieu.digital
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
