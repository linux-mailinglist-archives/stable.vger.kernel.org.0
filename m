Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B29B55925E2
	for <lists+stable@lfdr.de>; Sun, 14 Aug 2022 19:59:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231635AbiHNR7S (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 14 Aug 2022 13:59:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiHNR7S (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 14 Aug 2022 13:59:18 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A4AA23BE7;
        Sun, 14 Aug 2022 10:59:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C3253CE0B6B;
        Sun, 14 Aug 2022 17:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD92AC433C1;
        Sun, 14 Aug 2022 17:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660499954;
        bh=WUnkyF/jNFURTckY2gWMqvZYLn4P0jY1yB4UNrr5PG8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U0G/IUM2CzBKuMP32GF2DT+SpuIncGNSM+suuHYblDIDY2fPihRaurMmpVkUZvngp
         S74HNwTNETAdQS9b3P++XwJUBRZ8ROSQURUoXwhKxW3TSAxkhRPkiQbxydz5nlYg8a
         BBtUqhH1dWa6TdIWyk6qRcxsvr3Snx+xh6fEaubt8oYZx8/evaW/vV7Mv9r2u9bagU
         blTyOdDObZPQaZck18EqfU5hR+q0b5O1dXaCCvmfMAfDP5eXhpp5rH3cHwFtzjeuZC
         VY7I+VPpMfR1KywGhWKk+WPzWRO4ug8kTVen4NcY3dYETebpxiyKypFE8TPkxvEuoD
         vSF6PvlXaKYow==
Date:   Sun, 14 Aug 2022 20:59:10 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Sven van Ashbrook <svenva@chromium.org>
Cc:     Peter Huewe <peterhuewe@gmx.de>, Jason Gunthorpe <jgg@ziepe.ca>,
        Hao Wu <hao.wu@rubrik.com>, Yi Chou <yich@google.com>,
        Andrey Pronin <apronin@chromium.org>,
        James Morris <james.morris@microsoft.com>,
        stable@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tpm: fix potential race condition in suspend/resume
Message-ID: <Yvk37kLvftaNbB91@kernel.org>
References: <20220809193921.544546-1-svenva@chromium.org>
 <YvSNSs84wMRZ8Fa9@kernel.org>
 <CAM7w-FX4NfeQy9chKgzjAj6gvvoK3OxCK0VYq9DT5qrdB=_tDA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM7w-FX4NfeQy9chKgzjAj6gvvoK3OxCK0VYq9DT5qrdB=_tDA@mail.gmail.com>
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Aug 11, 2022 at 09:09:38AM -0400, Sven van Ashbrook wrote:
> On Thu, Aug 11, 2022 at 1:02 AM Jarkko Sakkinen <jarkko@kernel.org> wrote:
> >
> > What about adding TPM_CHIP_FLAG_SUSPENDED instead?
> 
> Thank you for the feedback, Jarkko. After thinking this over, I
> believe this patch only moves kernel warnings around. Will re-post
> soon with a fresh approach, intended to fix the underlying issue
> rather than the symptom.
> 
> So please disregard this patch.

np 

BR, Jarkko
