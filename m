Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6920A67A633
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 23:57:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbjAXW5R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 17:57:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232306AbjAXW5Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 17:57:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9A374390A;
        Tue, 24 Jan 2023 14:57:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 680AE61383;
        Tue, 24 Jan 2023 22:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A184FC433EF;
        Tue, 24 Jan 2023 22:57:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674601034;
        bh=wCt/4k7JwsPSDMmJukJEoXgYRh7nHkCRVYd7ajzsAsM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y5ga1AT/o+68lRElAKuOnuTYxHcfC7CvKSzTrxwNLukxATBgSbz9BpQb8bNIuDpXY
         Y7/MKI+xj07nbxTT24BvaSEaP8UVGT5i5XQq6akTlGGqt2vSlODNhKCcy7dzF4mrE0
         0xn0pJXV3Xx8/C781fk0QAK9c+jTOaFwpVF8P0J1gdGFBP/xicBDvJXAanRw8eohIa
         CbbehekOvPR96T4smDEZET74xhrnnhBDoZOFaxsyZ/acuhMyGAW7Rp9GjHqOLLlo/y
         BxyfZtqLbP8rrlRVHY3FDS3hcRqN8omg1tOaa8JWFzYDgIW7hnas7aUSJeM0UufhTr
         36pNHAHtZPIeg==
Date:   Tue, 24 Jan 2023 17:57:13 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Ard Biesheuvel <ardb@kernel.org>
Cc:     "# 3.4.x" <stable@vger.kernel.org>,
        linux-efi <linux-efi@vger.kernel.org>
Subject: Re: please backport EFI patches to v6.1
Message-ID: <Y9BiSTs9+Zc8waWw@sashalap>
References: <CAMj1kXEZUi5nwe0vq2v5sYved-6_dxHBhb+UVm2qLMDKM8AArA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAMj1kXEZUi5nwe0vq2v5sYved-6_dxHBhb+UVm2qLMDKM8AArA@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jan 23, 2023 at 11:07:44PM +0100, Ard Biesheuvel wrote:
>please backport these EFI patches to v6.1:
>
>8a9a1a18731eb123 arm64: efi: Avoid workqueue to check whether EFI
>runtime is live
>7ea55715c421d22c arm64: efi: Account for the EFI runtime stack in stack unwinder

Queued up, thanks!

-- 
Thanks,
Sasha
