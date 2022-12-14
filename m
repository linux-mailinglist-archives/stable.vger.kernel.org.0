Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AEF5B64CD9F
	for <lists+stable@lfdr.de>; Wed, 14 Dec 2022 17:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237917AbiLNQDO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Dec 2022 11:03:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238934AbiLNQCx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 14 Dec 2022 11:02:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7FE125D8;
        Wed, 14 Dec 2022 08:02:26 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A0B4BB818E9;
        Wed, 14 Dec 2022 16:02:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D878EC433EF;
        Wed, 14 Dec 2022 16:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1671033744;
        bh=s3VAzbBEgCoYjZ3PPjTVrxpBpS30dWawg7QrX656MqE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yIrIMb/Ok8NvQE8a/8MN/HlE8kBajtHD+TJpRDglbgO8EKc3Sk9O7+Afq/H4hu6Fh
         7sqk3pO+FBmkk8DrDbU1mkGqp1Zwot5gLDgs+gc7Kgso2XA8MbODuXeeqJqd9jyZbr
         tncX0j5mM8PjgD0frcIMt/nrAGUnW7eaBQ/We6mk=
Date:   Wed, 14 Dec 2022 17:02:21 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Joel Fernandes <joel@joelfernandes.org>
Cc:     stable <stable@vger.kernel.org>,
        "Paul E. McKenney" <paulmck@kernel.org>, rcu <rcu@vger.kernel.org>
Subject: Re: Please apply to v5.10 stable: 29368e093921 ("x86/smpboot: Move
 rcu_cpu_starting() earlier")
Message-ID: <Y5nzjauYRdn7T6T+@kroah.com>
References: <CAEXW_YR=DvPhk5JWUe7gYHeVsn5d4Wba83x2UB9uqP0EURgk1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEXW_YR=DvPhk5JWUe7gYHeVsn5d4Wba83x2UB9uqP0EURgk1g@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Dec 13, 2022 at 12:17:20PM -0500, Joel Fernandes wrote:
> Hello,
> 
> Please apply to the stable v5.10 kernel, the commit: 29368e093921
> ("x86/smpboot:  Move rcu_cpu_starting() earlier").
> 
> It made it into the mainline in 5.11.  I am able to reproduce the
> following splat without it on v5.10 stable, which is identical to the
> one that the commit fixed:

Now queued up, thanks.

greg k-h
