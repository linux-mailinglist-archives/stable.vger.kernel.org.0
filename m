Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 907FB4E68FC
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 20:01:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352782AbiCXTDP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 15:03:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343982AbiCXTDP (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 15:03:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5919BB823C
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 12:01:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09A9FB821FA
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 19:01:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 465A5C340EC;
        Thu, 24 Mar 2022 19:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648148500;
        bh=6WOfTyFhbwVN+AgaEVZE0nEPo1keKiex323dA0PStkI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cm9OShjBEDri1httCNgm9VYZODdmS1sJVohycBgazcvGP+L1n4Jni7Mj6BarNmAQi
         yS8oRLITNHm6a+7nkKRNKI98BUDhnqDwJm1bo41uJyNJGpVqxfvCw5/mexFuBQnQTn
         5WdIV8usl9cHt3wqML79oKQXE1CWr7rFKC7XymU4=
Date:   Thu, 24 Mar 2022 20:01:30 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Apply "tpm: Fix error handling in async work" to stable
Message-ID: <YjzACvzAM0gv8tfh@kroah.com>
References: <e7d8a669-b2ba-a7c3-9bcb-24af77a51d7d@linaro.org>
 <Yjyk6Eek06iJlWs4@kroah.com>
 <23a2f6ae-42bb-fe05-9f3a-649de9f52a39@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <23a2f6ae-42bb-fe05-9f3a-649de9f52a39@linaro.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 24, 2022 at 11:56:58AM -0700, Tadeusz Struk wrote:
> On 3/24/22 10:05, Greg KH wrote:
> > On Thu, Mar 24, 2022 at 07:55:00AM -0700, Tadeusz Struk wrote:
> > > Please apply upstream commit
> > > 2e8e4c8f6673 ("tpm: Fix error handling in async work")
> > > to stable 5.4, 5.10, 5.15, 5.16, 5.17
> > > Link:https://lore.kernel.org/all/20220116012627.2031-1-tstruk@gmail.com/
> > Now queued up, thanks.
> 
> Thanks, but I can see it queued up for 5.17 only.
> What about 5.4, 5.10, 5.15, 5.16?

I was stuck in a meeting and didn't push it out yet.  Now done :)
