Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103E86362B2
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 16:04:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235513AbiKWPEp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 10:04:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236484AbiKWPEn (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 10:04:43 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 575016317;
        Wed, 23 Nov 2022 07:04:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 152C9B82097;
        Wed, 23 Nov 2022 15:04:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37600C433C1;
        Wed, 23 Nov 2022 15:04:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669215880;
        bh=sz1I93kqRX2YTMQK4I6Fw0uhU90OV64EIhqgoVGD9p4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IOZUgQ5GNKEMc404JK9IQ9CLqlIS1EYuwc/oJNbsZiW9xyG4ueI6gWPM3X1TzqiTt
         F2BQwFsUn0W8IEuJtOzIdzvPg1IpvgtYywpD2QIouNekahFKsppCsQ1nsqDYTDEZXF
         BE2GTmIbtc64rWva2XYfLOdW40lRdag/4TOXvzcRwO4U3LlXL9k332zb2meNnOBXsM
         tYTdvhu62rl8DVMEVSyHbuJ35MLeg7FKqcyJbhen7/yJRPwGjhmG16ETJQDsp6D2mA
         zpmRFpo6aWV+hN339CslC/X0I8iA1V4CclH5YYYnsIbA7U29AZw3qMJ0j/5fLKWYnK
         C4lrlxnuHJLUg==
Date:   Wed, 23 Nov 2022 08:04:37 -0700
From:   Keith Busch <kbusch@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mike Snitzer <snitzer@kernel.org>,
        Jens Axboe <axboe@kernel.dk>, agk@redhat.com,
        dm-devel@redhat.com
Subject: Re: [PATCH AUTOSEL 5.15 25/31] dm-log-writes: set dma_alignment
 limit in io_hints
Message-ID: <Y342hZgFQdLfTfdx@kbusch-mbp.dhcp.thefacebook.com>
References: <20221123124234.265396-1-sashal@kernel.org>
 <20221123124234.265396-25-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221123124234.265396-25-sashal@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Nov 23, 2022 at 07:42:26AM -0500, Sasha Levin wrote:
> From: Keith Busch <kbusch@kernel.org>
> 
> [ Upstream commit 50a893359cd2643ee1afc96eedc9e7084cab49fa ]
> 
> This device mapper needs bio vectors to be sized and memory aligned to
> the logical block size. Set the minimum required queue limit
> accordingly.

Probably harmless, but these dm dma_alignment patches are not needed
prior to 6.0.
