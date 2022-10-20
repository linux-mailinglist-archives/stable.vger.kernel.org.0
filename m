Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 795AD6059B0
	for <lists+stable@lfdr.de>; Thu, 20 Oct 2022 10:26:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229972AbiJTI0P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Oct 2022 04:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229988AbiJTI0O (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 20 Oct 2022 04:26:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA86FB14FB
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 01:26:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 651C261A5E
        for <stable@vger.kernel.org>; Thu, 20 Oct 2022 08:26:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54F7DC433C1;
        Thu, 20 Oct 2022 08:26:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666254369;
        bh=8dK6SX27N0cg4W8gfGBF4T1SYha39pvFiDv1/5Ot948=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AW45o7mC8VaHn7Zc7TVoaLFT1tfMSSszEQRDdQ7hihPC1pYDGSoIpRFpwEqozgT/t
         maqwFGe0m624id8KUfiJ6fHvjzI39jSI5DlxzJ3ZiVOEJ84iXewsnmoqvIJghAKZvK
         6VJTPKhVyC5quHg1oWpRiOCdRqjDStRM/KxTUYdk=
Date:   Thu, 20 Oct 2022 10:26:06 +0200
From:   "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>
To:     Suleiman Souhlal <suleiman@google.com>
Cc:     sashal@kernel.org, Sangwhan Moon <sxm@google.com>,
        stable@vger.kernel.org
Subject: Re: LTS 5.15 EOL Date
Message-ID: <Y1EGHnKcWzKv6t99@kroah.com>
References: <CABCjUKBwLuTWE7A4PkNvRZx=6jeu3QjsFZq5iWZAKnmPYWKLog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CABCjUKBwLuTWE7A4PkNvRZx=6jeu3QjsFZq5iWZAKnmPYWKLog@mail.gmail.com>
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Oct 20, 2022 at 08:25:35AM +0900, Suleiman Souhlal wrote:
> Hello,
> 
> I saw that the projected EOL of LTS 5.15 is Oct 2023.
> How likely is it that the date will be extended? I'm guessing it's
> pretty likely, given that Android uses it.

Android is the only user that has talked to me about this kernel
version so far.  Please see:
	http://kroah.com/log/blog/2021/02/03/helping-out-with-lts-kernel-releases/
for what I require in order to keep an LTS kernel going longer than 2
years.

If your group at Google is going to rely on this kernel version, please
read the above link and talk to me about it.

thanks,

greg k-h
