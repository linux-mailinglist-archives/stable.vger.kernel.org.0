Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 145AB697D0C
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 14:22:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231515AbjBONWb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Feb 2023 08:22:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233460AbjBONWa (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Feb 2023 08:22:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB52E9EFE
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 05:22:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 99C58B81F81
        for <stable@vger.kernel.org>; Wed, 15 Feb 2023 13:22:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15580C433D2;
        Wed, 15 Feb 2023 13:22:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676467347;
        bh=hMJJFDU/ZyToGYtH82ti+I0QxsbKZ/NyC+WwmTWEjZ0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GhiQZDYF+ujWtPUv4JxWKF6BLO53TqcRtscN992avkfwTKwGNkclLw+pN1Zj+XgF2
         iWVYPNXovIftp1elpOF/iRxGsa9Juhxddd38kaRSyWpjufSHr4e0qmg1Nv0vnICide
         cMB7yM9FWHTYXT36GkxuyzLxR3qMLKYSpyKfadvU=
Date:   Wed, 15 Feb 2023 14:22:24 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc:     stable@vger.kernel.org, debian-s390@lists.debian.org,
        debian-kernel@lists.debian.org, svens@linux.ibm.com,
        hca@linux.ibm.com, gor@linux.ibm.com, Ulrich.Weigand@de.ibm.com,
        dipak.zope1@ibm.com
Subject: Re: [PATCH 1/1] s390/signal: fix endless loop in do_signal
Message-ID: <Y+zckC7f4J453O81@kroah.com>
References: <20230215120413.949348-1-sumanthk@linux.ibm.com>
 <20230215120413.949348-2-sumanthk@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230215120413.949348-2-sumanthk@linux.ibm.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 15, 2023 at 01:04:13PM +0100, Sumanth Korikkar wrote:
> No upstream commit exists.

Why not?  Please explain how this was fixed in Linus's tree and why we
can't take the same change here as well.

thanks,

greg k-h
