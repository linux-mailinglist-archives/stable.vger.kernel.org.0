Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8673C6E1CC3
	for <lists+stable@lfdr.de>; Fri, 14 Apr 2023 08:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbjDNGjd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Apr 2023 02:39:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbjDNGjc (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 14 Apr 2023 02:39:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABA4189
        for <stable@vger.kernel.org>; Thu, 13 Apr 2023 23:39:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4BC0A64491
        for <stable@vger.kernel.org>; Fri, 14 Apr 2023 06:39:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B453C433EF;
        Fri, 14 Apr 2023 06:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681454369;
        bh=XRnPwUDAcun8dp8F1VBhaYPZfc5fSu22UW3YsxEnpJs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KTfXHltYxl/mF0qkBo5ZDwIN8r1X/qtXdUXzZMp8xPSda5cO1wPAkly9CYbgzLJuC
         K1M5pWJMPtQee/F7i0Hzyx/RytFhu5CcKYjkVfb2Rh47Dw0Q5HxY8ed2dZOhGHaRfO
         PaakE8yo7te8Q6JlIRsVyp9D2M6lo/K/eOYBy5Y8=
Date:   Fri, 14 Apr 2023 08:39:25 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Imran Khan <imran.f.khan@oracle.com>
Cc:     stable@vger.kernel.org, paulmck@kernel.org
Subject: Re: [PATCH STABLE 5.15.y] Reduce IPI overload when multiple CPUs cat
 /proc/cpuinfo.
Message-ID: <ZDj1HZ_q4A6qrPB1@kroah.com>
References: <20230414024830.653235-1-imran.f.khan@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230414024830.653235-1-imran.f.khan@oracle.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Apr 14, 2023 at 12:48:30PM +1000, Imran Khan wrote:
> I am trying this approach (assuming that its okay) to avoid backporting
> multiple upstream patches to fix this single issue. Kindly let me know if
> its okay or would it be better to backport the relevant upstream patches
> instead.

It is almost never ok to diverge from what is in Linus's tree.  Please
never do that unless you have a very good reason to do so as it is
documented that when we do this, we almost always get it wrong.  Please
post the relevant patches instead and if they look too crazy, then we
can review them.

thanks,

greg k-h
