Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D1435AF230
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 19:16:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234329AbiIFRON (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 13:14:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239736AbiIFRNo (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 13:13:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9CFC90820
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 10:03:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6C12AB81920
        for <stable@vger.kernel.org>; Tue,  6 Sep 2022 17:02:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCD96C433C1;
        Tue,  6 Sep 2022 17:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662483753;
        bh=OxVS0j3DhY0jSepGMNTpNTOLMzlwzr1sBvi69X6iYdw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Kli+TA/Hvlp3otVNdja8bLMZfC0Qkqu8qfWfIIYa39Wzn/x94kDuVcyc0A4yKTIlX
         o8yuV39HyE+HpBoh1jaKBKhgso2Lb6ffsBZBm6bPSsOqRPZkFycHBZwGUvU1ta5NYY
         uuy/pl+lAWUbRwML3xcrLeQSIljHpn1Q9ciuzwMfrc0WKYQJ3bgJle7ya5jFVwsxtD
         3IZ7PjO7tTBQjWt4X8wit3mAW1k/TlivzYhaxf8f3nWEUB0LOk3EKaq+/QFrMbAIKW
         83NO1xl1t9J0xIxPmLK5Uay4fszMoodRL16qLZOu1p0h6RkeanF3KnH1cHlbIIDDU2
         txjqBLIkX0GyA==
From:   SeongJae Park <sj@kernel.org>
To:     gregkh@linuxfoundation.org
Cc:     sj@kernel.org, jgross@suse.com, marmarek@invisiblethingslab.com,
        stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] xen-blkfront: Cache feature_persistent value before" failed to apply to 5.10-stable tree
Date:   Tue,  6 Sep 2022 17:02:31 +0000
Message-Id: <20220906170231.121076-1-sj@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <166245848519156@kroah.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On Tue, 06 Sep 2022 12:01:25 +0200 <gregkh@linuxfoundation.org> wrote:

> 
> The patch below does not apply to the 5.10-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

I just posted the patch:
https://lore.kernel.org/stable/20220906162414.105452-1-sj@kernel.org/


Thanks,
SJ

[...]
