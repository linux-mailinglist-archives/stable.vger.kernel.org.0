Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3807755CF18
	for <lists+stable@lfdr.de>; Tue, 28 Jun 2022 15:06:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238839AbiF0UOU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Jun 2022 16:14:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239000AbiF0UOT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 27 Jun 2022 16:14:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F9191D306;
        Mon, 27 Jun 2022 13:14:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18F8BB81ACC;
        Mon, 27 Jun 2022 20:14:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488D4C34115;
        Mon, 27 Jun 2022 20:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656360855;
        bh=kvgcOZrQWrx0JNyz24fOHr3SC1L9IVTDxYubqdOpFYk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jz0wAmYorDGrP9ew5bHwPHOkxwdpz9pcBI8RvYOzWMWRQOZULN+BbQon/u3OGwObg
         cXkgKnAbqj4HJnCL0HRSyxFV0EfZfOfTzqoC2gHTHR3rSs+fOtBPCtjgkQzIScXEL/
         At7UNjEcyW9E6BHayhjBlZKRzbZP7Mmhk2XpnTOhXsv2gpq11vbDAZhQciHWYSRemu
         fi/eCX/DoRWp+SLirLJY+fkUq9LQu/DTjrHFcLLpg3hJNVL7VErC6PoTlqcasi7/x0
         vS5sDFlTGvS5uycEvAL0b1Pd94o/2pi+HID3rbNVTuZDR9aEVooK0olDMFjeDy4auR
         biYZUkn72OmWQ==
Date:   Mon, 27 Jun 2022 14:14:12 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Pablo Greco <pgreco@centosproject.org>
Cc:     stable@vger.kernel.org, Jens Axboe <axboe@fb.com>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] nvme-pci: add NVME_QUIRK_BOGUS_NID for ADATA XPG
 SX6000LNP (AKA SPECTRIX S40G)
Message-ID: <YroPlErIYce5LbMr@kbusch-mbp.dhcp.thefacebook.com>
References: <20220625121502.9092-1-pgreco@centosproject.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220625121502.9092-1-pgreco@centosproject.org>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Sat, Jun 25, 2022 at 09:15:02AM -0300, Pablo Greco wrote:
> ADATA XPG SPECTRIX S40G drives report bogus eui64 values that appear to
> be the same across drives in one system. Quirk them out so they are
> not marked as "non globally unique" duplicates.

Looks fine.

Reviewed-by: Keith Busch <kbusch@kernel.org>
