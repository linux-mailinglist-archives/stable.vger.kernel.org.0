Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 811D06C5E0C
	for <lists+stable@lfdr.de>; Thu, 23 Mar 2023 05:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229499AbjCWEgY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Mar 2023 00:36:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbjCWEgW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Mar 2023 00:36:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C425233CC
        for <stable@vger.kernel.org>; Wed, 22 Mar 2023 21:36:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 157FDB81DD0
        for <stable@vger.kernel.org>; Thu, 23 Mar 2023 04:36:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BF9BC433D2;
        Thu, 23 Mar 2023 04:36:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679546178;
        bh=gK//hSy/OCzF9OtzvhVi8wrSBQxlIeCQjdgZZOIKUt8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=twusLVwiWDzKgxM3N1YuyhvbFWmRnXpE8NBSHjfAUg7plYiQXOzSV2T08nso933Qk
         pkOp40duOv6nalntIhKaQ53Fh/CC/FXvSoq5ZZmJvSgGo7aAzPGpSERqduS7HdVGQV
         SlT5kBbq8drZ9Tyg49wNs++1vPOV+4YghDw4pYp0=
Date:   Thu, 23 Mar 2023 05:36:16 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Vaibhav Rustagi <vaibhavrustagi@google.com>
Cc:     "# 3.4.x" <stable@vger.kernel.org>
Subject: Re: Request for cherry-picking commit 4a625ce from Linus' tree
Message-ID: <ZBvXQJMIBkgw/gy/@kroah.com>
References: <CAMVonLh0jPpZpczXFqVpZ0w41OBg97z+6ixZewWQg_2TxL5ttQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMVonLh0jPpZpczXFqVpZ0w41OBg97z+6ixZewWQg_2TxL5ttQ@mail.gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 22, 2023 at 04:07:21PM -0700, Vaibhav Rustagi wrote:
> Hello,
> 
> In order to resolve CVE-2023-23005 in kernel v6.1 stable tree, I would
> like to request cherry-picking the below commit:
>
> mm/demotion: fix NULL vs IS_ERR checking in memory_tier_init (4a625ce)

This "fix" can never actually be hit in a real system, right?

So it would seem that this CVE is invalid, please work to invalidate it
with whatever group creates such bogus claims.

thanks,

greg k-h
