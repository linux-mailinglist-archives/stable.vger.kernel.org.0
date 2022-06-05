Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9876F53DB81
	for <lists+stable@lfdr.de>; Sun,  5 Jun 2022 15:17:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343895AbiFENRD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 5 Jun 2022 09:17:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38508 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233026AbiFENRC (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 5 Jun 2022 09:17:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAB4D7A;
        Sun,  5 Jun 2022 06:16:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 95AF0B80B1B;
        Sun,  5 Jun 2022 13:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F6EBC385A5;
        Sun,  5 Jun 2022 13:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654435015;
        bh=F6wwIuaJOs8q469GaToXANOtJ2igdQBRHipQBFQXKnE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GI9SyNFhvjfJ2HWJo2BaaEn/cPMwbik5qg6LQ2ULOgOKhUQWXAQ5n55qHeP6POnQ+
         XFbvVb219MM6Bip4Ib0BsOdvLAYINmsOv0mrktAU+fYcwlttGRIEmumh0MhpxzkgFw
         uPf+iaZzNqeHkheri+eJcu4FQcE+ZXtu0Ow8DDEPS+WfGi2d9OiSN/G3e+RDAHR8pF
         ChRGSop3IbwNIOgA5YP4rUEe4XPXFv7QM+NXDiXO6bUpoQd5SIdEtBR60RvHsL7YcN
         pMTq583688Ew3kaeYcOFitdSaZ4adjRm3m9Hr4b7WM1SGSHw5v5tOtu4lzLBlHA5Tp
         SMZsjN9YUA8eA==
Date:   Sun, 5 Jun 2022 09:16:53 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Bodo Stroesser <bostroesser@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Xiaoguang Wang <xiaoguang.wang@linux.alibaba.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.18 074/159] scsi: target: tcmu: Fix possible
 data corruption
Message-ID: <YpysxYs68FI2n19B@sashalap>
References: <20220530132425.1929512-1-sashal@kernel.org>
 <20220530132425.1929512-74-sashal@kernel.org>
 <12bb8139-be66-4e08-47be-909b0042926c@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <12bb8139-be66-4e08-47be-909b0042926c@gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 30, 2022 at 05:47:12PM +0200, Bodo Stroesser wrote:
>Sasha,
>
>the below patch introduces a new bug, which is fixed by commit
>  325d5c5fb216 ("scsi: target: tcmu: Avoid holding XArray lock when calling lock_page")
>Please consider adding this further fix.
>
>For my understanding: commit 325d5c5fb216 contains a "Fixes:"
>tag. So I'd expect it to be added automatically.
>Is there still something missing in the commit?

I'll make sure it's added along with this one, thanks!

-- 
Thanks,
Sasha
