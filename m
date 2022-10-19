Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE56F604027
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 11:43:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234285AbiJSJnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 05:43:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234987AbiJSJmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 05:42:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE75DF07FD;
        Wed, 19 Oct 2022 02:18:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7CCEA617ED;
        Wed, 19 Oct 2022 09:18:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1177C433C1;
        Wed, 19 Oct 2022 09:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666171110;
        bh=opd6/S7YDBuBgGOOzg7FhbC4ScBaoSAdesoPLTnZbUM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=oXHtWPKnC9Qi9vTpl0KFZ15/70SlRya/6iyxpWwOeo/tqzrZ59KaOhbI0Q+UOQLye
         QSpKLK9I8AMvc1IHZRP9VQlfz0zhWZ3UaeU6vxMZL97oEAE5W/wkgU6TnM57XWGrMe
         5ddAC0ep9jKK9GpdlpE5QxjVPiKBf9/EDk+j79GQPbq7DyhWi2kS3uNnYBT/VnZiCG
         A1E8Qv1EtkuV86kEExwjbPx3cts/TpOda3Aw+dIlpTCGwjUQQwbjLOpxrbV5DI0otH
         eWS6MxmrDVr4f8pMJTkuMFvm3Fxkbps47MKipfvHVSh7SJW45Xhum+s/8BqZ7K5qLW
         JuN6ZV/tuHnuA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1ol5DO-000578-TP; Wed, 19 Oct 2022 11:18:18 +0200
Date:   Wed, 19 Oct 2022 11:18:18 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Johan Hovold <johan+linaro@kernel.org>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.0 525/862] phy: qcom-qmp-pcie-msm8996: fix memleak on
 probe deferral
Message-ID: <Y0/A2nyogjIWq8lH@hovoldconsulting.com>
References: <20221019083249.951566199@linuxfoundation.org>
 <20221019083313.175878033@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221019083313.175878033@linuxfoundation.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Oct 19, 2022 at 10:30:12AM +0200, Greg Kroah-Hartman wrote:
> From: Johan Hovold <johan+linaro@kernel.org>
> 
> [ Upstream commit 1f69ededf8e80c42352e7f1c165a003614de9cc2 ]
> 
> Switch to using the device-managed of_iomap helper to avoid leaking
> memory on probe deferral and driver unbind.
> 
> Note that this helper checks for already reserved regions and may fail
> if there are multiple devices claiming the same memory.

Again, because of the above, this should not be backported. Please drop.

> Fixes: e78f3d15e115 ("phy: qcom-qmp: new qmp phy driver for qcom-chipsets")
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Link: https://lore.kernel.org/r/20220916102340.11520-4-johan+linaro@kernel.org
> Signed-off-by: Vinod Koul <vkoul@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Johan
