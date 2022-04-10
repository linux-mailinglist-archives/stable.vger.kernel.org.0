Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 02B484FAB77
	for <lists+stable@lfdr.de>; Sun, 10 Apr 2022 04:07:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229618AbiDJCJN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 9 Apr 2022 22:09:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229732AbiDJCJM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 9 Apr 2022 22:09:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7F83319
        for <stable@vger.kernel.org>; Sat,  9 Apr 2022 19:07:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 802B7B80AFE
        for <stable@vger.kernel.org>; Sun, 10 Apr 2022 02:07:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E28C385A4;
        Sun, 10 Apr 2022 02:07:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649556421;
        bh=NOFe15za0I6PoKw94Nl0R43Wh7kd8LAz05rWU2sv9ao=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bEH+JboUnwhGP84vL8gD5d5MFgIttXdtvBv3kvl65Q4GdwLWe/+tUp8+Qj/bQEI7N
         Ejvd3nJI9ZxxeIQAUBZuGfQu0m8/uPJTfDshNcpOIhYheroJq8bfS7IDOunZtrnIIE
         ed1B967P6wIy4vyN5xTXYIXq4NYDM5uuSkjeXpCaJTq7oHSGo11pB7xja3WjMkY9yA
         DanxQx1Zi/gxx+dzINKlR5xw2SS0t8YrUXq8tgqu+r25dIvDdN8h5jUsekmFGKPaV6
         fmid05sftXeXuRfb4McaoEt1daAjv9eFMAxuUkKsdvQ+BKFcCX6Ul71kgjb7cizyqv
         /iLl3UxjKuc7w==
Date:   Sat, 9 Apr 2022 22:07:00 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        nanericwang@gmail.com, KY Srinivasan <kys@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: stable 5.10: please revert
 c4dc584a2d4c8d74b054f09d67e0a076767bdee5
Message-ID: <YlI7xE0JFYZSqJUL@sashalap>
References: <beaf8136-1c97-a65f-e64b-a98f23f024d2@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <beaf8136-1c97-a65f-e64b-a98f23f024d2@infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Apr 09, 2022 at 09:07:51AM -0700, Randy Dunlap wrote:
>According to https://bugzilla.kernel.org/show_bug.cgi?id=215823,
>c4dc584a2d4c8d74b054f09d67e0a076767bdee5 ("hv: utils: add PTP_1588_CLOCK to Kconfig to fix build")
>is a problem for 5.10 since CONFIG_PTP_1588_CLOCK_OPTIONAL does not exist in 5.10.
>This prevents the hyper-V NIC timestamping from working, so please revert that commit.

I've reverted it, thanks for the report.

-- 
Thanks,
Sasha
