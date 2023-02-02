Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C68DD688548
	for <lists+stable@lfdr.de>; Thu,  2 Feb 2023 18:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232536AbjBBRUq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Feb 2023 12:20:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232537AbjBBRUp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Feb 2023 12:20:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3BA73772;
        Thu,  2 Feb 2023 09:20:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C1AAAB825C2;
        Thu,  2 Feb 2023 17:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45414C433D2;
        Thu,  2 Feb 2023 17:20:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675358442;
        bh=WJPiL9FiskiMG5n8G2LVOXU1V9wAI10z1FI/afpDBKI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kDySn9zUWGYLQsdknR1PVxc1qD0teiwokEEquVPLhdq3ciHIEg1HRN/H+JJqt9GUi
         z1iEa0Hgzl2C2YcmyLxEUZyBXUSgfdt6ioKYhpRI6Lx6/g56dDXSyHLUSbCknFh+7O
         cSsvUBlXJ0z3AaB9s9o3QksKYppK+SKaI021WaqdAcPukA3LL38xkn2/sqmPkO3ntY
         G1caCEaXfEmGxZJROX6oedktSN+tcJydNufhsAWUmgh0ecZOr1/CKKbCNiI0fxegAB
         lTpr0p6tra1KM55DjkvXi68u90OGtsPNrWhxgXEr7boS4qW1Xw6Y0pXxYNoS6rHqYo
         mJFWO/woQplew==
Date:   Thu, 2 Feb 2023 12:20:41 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     GUO Zihua <guozihua@huawei.com>
Cc:     stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        gregkh@linuxfoundation.org, zohar@linux.ibm.com,
        paul@paul-moore.com, luhuaxin1@huawei.com
Subject: Re: [PATCH 4.19 0/3] Backport handling -ESTALE policy update failure
 to 4.19
Message-ID: <Y9vw6RhQ6KJ5+E1I@sashalap>
References: <20230201023952.30247-1-guozihua@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20230201023952.30247-1-guozihua@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Feb 01, 2023 at 10:39:49AM +0800, GUO Zihua wrote:
>This series backports patches in order to resolve the issue discussed here:
>https://lore.kernel.org/selinux/389334fe-6e12-96b2-6ce9-9f0e8fcb85bf@huawei.com/
>
>This required backporting the non-blocking LSM policy update mechanism
>prerequisite patches.

Do we not need this on newer kernels? Why only 4.19?

-- 
Thanks,
Sasha
