Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 735E450CAE1
	for <lists+stable@lfdr.de>; Sat, 23 Apr 2022 15:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235879AbiDWOAH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 Apr 2022 10:00:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235874AbiDWOAE (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 23 Apr 2022 10:00:04 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F12761E3F6;
        Sat, 23 Apr 2022 06:57:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 890DC611D8;
        Sat, 23 Apr 2022 13:57:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5323C385A0;
        Sat, 23 Apr 2022 13:57:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650722222;
        bh=zGzRwwY4g8A2v1nQlf+NEVpuOwHFKGM8BY8W9ldNH00=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=eYunXOTeLEM1I4b5B5HtHuXue/YDymNhhZYJ6i+hAoRP7I9xu/iTwE28igUkEIKuN
         KMSQSKyrEIBCIQKkKBMsOFOn3EmLq1nfRQm2M8fAamgYcsG45qLVZQFy/zwc5imWS+
         ATw1j7U1AtOMbRvaAxTbQdKtCbYSKraGqH7uOljurgamy9IobZnKruWwfGn1OzPRO3
         slRn+gXTnEmLHetJykYgDYEyvejji4HYtYTyCuSqLOzZjTaQJdKEi2iYWEKlPN0cOy
         NaBLO8KZgL9q6EB6LO+Z2Zi7/jMVZF4hsEC7ddjJ0uBz3QcmdwXl41PzAIt4aGjm3A
         sej72ZZFAnTow==
Date:   Sat, 23 Apr 2022 09:57:01 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Rob Clark <robdclark@chromium.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Robin Murphy <robin.murphy@arm.com>,
        Rob Clark <robdclark@gmail.com>,
        Dmitry Baryshkov <dmitry.baryshkov@linaro.org>,
        sean@poorly.run, airlied@linux.ie, daniel@ffwll.ch,
        linux-arm-msm@vger.kernel.org, dri-devel@lists.freedesktop.org,
        freedreno@lists.freedesktop.org
Subject: Re: [PATCH AUTOSEL 5.4 11/14] drm/msm: Stop using iommu_present()
Message-ID: <YmQFrXEBzanbx5FJ@sashalap>
References: <20220419181444.485959-1-sashal@kernel.org>
 <20220419181444.485959-11-sashal@kernel.org>
 <CAJs_Fx7YVBn7qvaE23ThBOFzozKHBkefdSztfF+xtTw2hhgw2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <CAJs_Fx7YVBn7qvaE23ThBOFzozKHBkefdSztfF+xtTw2hhgw2Q@mail.gmail.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Apr 19, 2022 at 11:53:23AM -0700, Rob Clark wrote:
>You might want to drop this one, it seems to be causing some issues on
>older generations.. I'll be sending another PR shortly with a revert.
>
>https://patchwork.freedesktop.org/patch/482453

Dropped, thanks!

-- 
Thanks,
Sasha
