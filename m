Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8AAC4E6772
	for <lists+stable@lfdr.de>; Thu, 24 Mar 2022 18:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346259AbiCXRHY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Mar 2022 13:07:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241559AbiCXRHW (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Mar 2022 13:07:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E713B0D12
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 10:05:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9F78B824A6
        for <stable@vger.kernel.org>; Thu, 24 Mar 2022 17:05:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9125C340EC;
        Thu, 24 Mar 2022 17:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648141547;
        bh=aJZ7EGLDqXyvF5QJigfYtPg4H02OqJyakd1sIhKWR1s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uyh7LSE0qEBHYJ0Ju0oQotRJYw1RySu+iJUaYBPbo7gyL1WLLuL3J5pvVoCogw/ju
         m6M+L0k/q58lJbftSshPpJIjHC8eQ8XGkstChRIGgZoPtH0pQTKbfE3W5Ewzsjm1nU
         IDcPfvHeBfHVSAqCzUNGUykbBNIHHQNks9OkeGTA=
Date:   Thu, 24 Mar 2022 18:05:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Tadeusz Struk <tadeusz.struk@linaro.org>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: Apply "tpm: Fix error handling in async work" to stable
Message-ID: <Yjyk6Eek06iJlWs4@kroah.com>
References: <e7d8a669-b2ba-a7c3-9bcb-24af77a51d7d@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7d8a669-b2ba-a7c3-9bcb-24af77a51d7d@linaro.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 24, 2022 at 07:55:00AM -0700, Tadeusz Struk wrote:
> Please apply upstream commit
> 2e8e4c8f6673 ("tpm: Fix error handling in async work")
> to stable 5.4, 5.10, 5.15, 5.16, 5.17
> Link: https://lore.kernel.org/all/20220116012627.2031-1-tstruk@gmail.com/

Now queued up, thanks.

greg k-h
