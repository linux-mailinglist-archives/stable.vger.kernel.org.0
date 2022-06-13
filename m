Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CE841548304
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 11:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230112AbiFMJCN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 05:02:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231440AbiFMJCN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 05:02:13 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72F94AE53
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 02:02:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A213611C6
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 09:02:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179CCC34114;
        Mon, 13 Jun 2022 09:02:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655110931;
        bh=jxARUtI3z25nO/hP9BE9uwwwXxwviyv/cVVMOJGQiGg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m5dWKxv6V7jldgvlqXs9t4gD2+xdO6NUKDRkidVA0I+kU5AA+ttHajv9jszCNc6D7
         +7R7h4tIpW17zjWszWMZlUs8Fd7MQAfM+LrM0nl5Ajn/2MjKDcPeFpM4WnnfE/Lr13
         IYQc+w8AmhFN1x1fUue/rZHXS0tnkVB2yRmoaHz8=
Date:   Mon, 13 Jun 2022 11:02:08 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH stable 5.18 5.17 5.15 5.10 0/3] rng stable patches from
 5.19-rc2
Message-ID: <Yqb9EDP6LyM/iES3@kroah.com>
References: <20220613080749.153222-1-Jason@zx2c4.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220613080749.153222-1-Jason@zx2c4.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 13, 2022 at 10:07:46AM +0200, Jason A. Donenfeld wrote:
> Hi Greg,
> 
> These three patches from 5.19-rc2 failed to automatically apply. The
> following series should work okay.

All now queued up, thanks.

> Note that these are already part of the 4.9, 4.14, 4.19, 5.4 backport I
> did for later this week.

Great, thanks for adding them there too.

greg k-h
