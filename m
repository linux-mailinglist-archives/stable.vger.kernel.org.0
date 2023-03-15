Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9D3F56BA62B
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 05:27:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229447AbjCOE1J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 00:27:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbjCOE1H (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 00:27:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C99F843467;
        Tue, 14 Mar 2023 21:27:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 577D3B81BC1;
        Wed, 15 Mar 2023 04:27:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5E34C433EF;
        Wed, 15 Mar 2023 04:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678854421;
        bh=LBkQx4LAP2aLDYow6vxHgX9FLwS40i6k53JaMQG77D8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=P3I4iSsqDhgBPhxN9Z08ZriKoCH2c645hs4VL9HXOwWN8AAPF5CDOdfnVfZBPMYlk
         8aTz9O8ngPRlNS98kApjCuRf9AJPmNQSoXfIZLzg5r0AO3C4q+7uqI0ZA11yTLjXgs
         LsyNHaueL0JQw11etaP0rZTGoA8rQPp+7Q4Ddw5o=
Date:   Wed, 15 Mar 2023 05:26:58 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     listdansp <listdansp@mail.ru>
Cc:     stable@vger.kernel.org, Bin Liu <b-liu@ti.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        lvc-project@linuxtesting.org, Sergey Shtylyov <s.shtylyov@omp.ru>
Subject: Re: [PATCH 5.10 1/1] usb: musb: core: drop redundant checks
Message-ID: <ZBFJEoDcdUI2PyVK@kroah.com>
References: <20230314170113.11968-1-listdansp@mail.ru>
 <20230314170113.11968-2-listdansp@mail.ru>
 <ZBCqHJz8zYeXQ3Q7@kroah.com>
 <10af6434-a466-7884-5650-fd8de01d540b@mail.ru>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10af6434-a466-7884-5650-fd8de01d540b@mail.ru>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 15, 2023 at 07:16:44AM +0300, listdansp wrote:
> This patch was prepare in according to secure programming conception.

I do not understand what that means.

> In practice it indeed simply remove unused code.

Yes, it did, but why should that be added to a stable kernel tree?

> If you're thinking, that this patch is useless, we don't insist on applying
> it.

I'm confused as to why you thought it should have been applied at all.
Why did your testing deem it needed?

thanks,

greg k-h
