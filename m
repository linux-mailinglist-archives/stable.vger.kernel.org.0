Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5C87660E66
	for <lists+stable@lfdr.de>; Sat,  7 Jan 2023 12:48:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231911AbjAGLrq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 7 Jan 2023 06:47:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33974 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbjAGLrR (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 7 Jan 2023 06:47:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1821B12AAE;
        Sat,  7 Jan 2023 03:47:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9F20960BC8;
        Sat,  7 Jan 2023 11:47:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AF0EC433EF;
        Sat,  7 Jan 2023 11:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673092035;
        bh=Zt3glH4ngDwZ1KETrIlg+tSxgjMbMEp2QJAqGCix2FQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ghzZY5B6wuntw8rYEeyadV3WjwQRsWBJpxefqCUHJKw+3Jd7D0kQ8Rc5MI91Kg4xy
         lbRYH+eu9nfo79MuLPd43kEhQO/t9/PvDun63JYdG30VX31EauElt5vUgLKdqHnoYM
         UoWX++uIaWLw0NV8QMSFZsncgo/GpHwMP67suKdA=
Date:   Sat, 7 Jan 2023 12:47:07 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        torvalds@linux-foundation.org, stable@vger.kernel.org
Cc:     lwn@lwn.net, jslaby@suse.cz
Subject: Re: Linux 4.9.337
Message-ID: <Y7lbu6/0P7Q/P3oj@kroah.com>
References: <167309164122758@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <167309164122758@kroah.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jan 07, 2023 at 12:40:41PM +0100, Greg Kroah-Hartman wrote:
> I'm announcing the release of the 4.9.337 kernel.
> 
> All users of the 4.9 kernel series must upgrade.

Note, this is the LAST 4.9.y kernel to be released.

This kernel is now END-OF-LIFE and you should move to 4.14.y at the
least, 6.1.y is the better option.

As I stated in the -rc announcement, if this is a problem for anyone,
please let me know.  I am already working with a few groups to move them
off of this now-expired kernel tree, feel free to reach out if you need
help as well.

thanks,

greg k-h
