Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D324957EFF0
	for <lists+stable@lfdr.de>; Sat, 23 Jul 2022 17:05:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237992AbiGWPFE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Jul 2022 11:05:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237985AbiGWPFC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Jul 2022 11:05:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9791192BB
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 08:05:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 64BDD60B6F
        for <stable@vger.kernel.org>; Sat, 23 Jul 2022 15:05:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70379C341C0;
        Sat, 23 Jul 2022 15:05:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658588700;
        bh=ZMwD79j/IgRZB2HSt2E5MX86sqSrmKSLdROfiMUMiXQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SstVfk4TjBS3SxAWWiYryKnYF6jNz8tuOCl7aR7eQSzcVxOE+R3Z/zlnosmQvoxGs
         /TsFFc1ksq/MqAft5KEIU9UsUbNDvPfONPwL5HBu/GeGDMFcxv803BNGkgmE2FHZVD
         Moz0pb1tYgIpKD/NDIPC9ujPeglGvLNz935WEQdw=
Date:   Sat, 23 Jul 2022 17:04:32 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: Re: [PATCH 5.10 0/7] net: fix use-after-free of net_device's in
 __rtnl_newlink()
Message-ID: <YtwOAE1XRD+A3hBW@kroah.com>
References: <20220715162632.332718-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220715162632.332718-1-pchelkin@ispras.ru>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jul 15, 2022 at 07:26:25PM +0300, Fedor Pchelkin wrote:
> Syzkaller reports use-after-free for net_device's in 5.10 stable releases.
> The problem has been fixed by the following patch series and
> it can be cleanly applied to the 5.10 branch.
> 
> Found by Linux Verification Center (linuxtesting.org) with Syzkaller.
> 

All now queued up, thanks.

greg k-h
