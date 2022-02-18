Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA6C34BB89D
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 12:48:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbiBRLsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Feb 2022 06:48:18 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:37142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232068AbiBRLsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 18 Feb 2022 06:48:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D6262F2
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 03:48:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0FC6F61F4F
        for <stable@vger.kernel.org>; Fri, 18 Feb 2022 11:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B82C340E9;
        Fri, 18 Feb 2022 11:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645184880;
        bh=APCFiJ/v6N5Xirn97oQk1HPQFoxt4DNKKk3XDOakULk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pZgum2DVVCo+veKVo9ggTF3U1vqoJ8ML9IYGwwcyLO8smpROQvd8/xW2uF06by8DX
         Brt207iALmhIPAemnCEqe320UR9+gZMMnM5RO31gqmC72XuCjZWG5rW5IKCojRskqu
         6edUqeEMQOZLtyk29U8IKONhD+Z4fElDrRgiQDP0=
Date:   Fri, 18 Feb 2022 12:47:57 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Christian =?iso-8859-1?Q?L=F6hle?= <CLoehle@hyperstone.com>
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] mmc: block: fix read single on recovery logic
Message-ID: <Yg+HbZYXOaTVEAhs@kroah.com>
References: <16451252511822@kroah.com>
 <abf69d264c7845bab8433ccae7ed0e0f@hyperstone.com>
 <Yg92AW1onRd47G9z@kroah.com>
 <03b3664476424756867d9dd76f984002@hyperstone.com>
 <916c2090-5b39-e9e8-190e-d0f8a77adfa3@intel.com>
 <3da3bebe0cdf40cc83bcf0fa37960c7c@hyperstone.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3da3bebe0cdf40cc83bcf0fa37960c7c@hyperstone.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 11:05:21AM +0000, Christian Löhle wrote:
> You're right, I did not get an email about 5.4, maybe it was caught up somewhere.
> Greg, can you apply this to 5.4, too?

Oops, forgot that one, now queued up.

greg k-h
