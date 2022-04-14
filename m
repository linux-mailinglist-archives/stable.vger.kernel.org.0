Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DFBB500B82
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 12:48:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231304AbiDNKuv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 06:50:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234619AbiDNKut (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 06:50:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC0E67E58A;
        Thu, 14 Apr 2022 03:48:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 760DC60B63;
        Thu, 14 Apr 2022 10:48:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5599EC385A1;
        Thu, 14 Apr 2022 10:48:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649933303;
        bh=yW9RnnOtRJ4cX3nz1tfNRHZsNzlkwSHBEpZQQ4l0aq4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=E5WgGiCTsotbc012Rraa0eeuK1UJpO8mkdp+DvZcF3/NSqn8za5HXTS01m7Efexem
         n0mu9rquAKi07uXgurYTL6FhYHjHZhVvjZeQQG9DlmMoHOBACNUdSI1QqkDSAPMqr6
         M+rFrXWBWcSa7vGHG8BkXnDkJRW8gd9KqTzUHRhY=
Date:   Thu, 14 Apr 2022 12:48:19 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Waiman Long <longman@redhat.com>
Cc:     john.p.donnelly@oracle.com,
        chenguanyou <chenguanyou9338@gmail.com>, dave@stgolabs.net,
        hdanton@sina.com, linux-kernel@vger.kernel.org,
        mazhenhua@xiaomi.com, mingo@redhat.com, peterz@infradead.org,
        quic_aiquny@quicinc.com, will@kernel.org, sashal@kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v5] locking/rwsem: Make handoff bit handling more
 consistent
Message-ID: <Ylf78yGuXdXWugpn@kroah.com>
References: <20211116012912.723980-1-longman@redhat.com>
 <20220214154741.12399-1-chenguanyou@xiaomi.com>
 <3f02975c-1a9d-be20-32cf-f1d8e3dfafcc@oracle.com>
 <e873727e-22db-3330-015d-bd6581a2937a@redhat.com>
 <31178c33-e25c-c3e8-35e2-776b5211200c@oracle.com>
 <161c2e25-3d26-4dd7-d378-d1741f7bcca8@redhat.com>
 <2b6ed542-b3e0-1a87-33ac-d52fc0e0339c@oracle.com>
 <b3620b7b-c66a-65f8-b10b-c3669b2f82ec@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3620b7b-c66a-65f8-b10b-c3669b2f82ec@redhat.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 12, 2022 at 01:04:05PM -0400, Waiman Long wrote:
> The patch has already been in the tip tree. It may not be easy to add a
> Fixes tag to it. Anyway, I will encourage stable tree maintainer to take it
> as it does fix a problem as shown in your test.

I have no idea what you want me to do here.  Please be explicit...

thanks,

greg k-h
