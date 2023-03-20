Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1818C6C12CB
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231549AbjCTNK2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 09:10:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231509AbjCTNKZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:10:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85FC51E1C5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 06:10:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 45F6DB80D58
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A943BC433D2;
        Mon, 20 Mar 2023 13:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679317822;
        bh=a4lxARHOdQSnOeVyy3uLZ+qNfKHejs3essZDfDZnfQo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Q/Jnvjw3vhia0+eQrJKv5iXDhRf6bduSqCHiuxdx4pQfDoAuF2gkOG01GhoMHqjUA
         nAarkUQJhu40m8h/nWcy9IffWxV1UZkI/XMEL9ITOlKEBGw3VQB8v0xjDYxwsIUhMW
         Jg2Rtaa2M30nU3y1ICLIEimxAdn4wwuldrooK3WQ=
Date:   Mon, 20 Mar 2023 14:10:19 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Qais Yousef <qyousef@layalina.io>
Cc:     stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar Eggemann <dietmar.eggemann@arm.com>
Subject: Re: [PATCH 0/7] Backport uclamp vs margin fixes into 5.15.y
Message-ID: <ZBhbO3efvJoA+axo@kroah.com>
References: <20230308162207.2886641-1-qyousef@layalina.io>
 <ZBF74StdWaGP/KSP@kroah.com>
 <ZBGHpGccMmxHnUns@kroah.com>
 <20230315125304.g6yuhltvewnfneqs@airbuntu>
 <ZBLIvuqi0LYWIPBN@kroah.com>
 <20230318173359.agw5rq7gwwjdvnat@airbuntu>
 <20230318193530.bzb4b2g6wlukibr2@airbuntu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230318193530.bzb4b2g6wlukibr2@airbuntu>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Mar 18, 2023 at 07:35:30PM +0000, Qais Yousef wrote:
> On 03/18/23 17:33, Qais Yousef wrote:
> 
> > And they all compiled without an error. Happy to retake them or prefer a resend
> > anyway though nothing has changed?
> 
> Actually I just did a resend. I guess you won't find them easily in your inbox
> anymore.

Many thanks, yes, they were long gone :)
