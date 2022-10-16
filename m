Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBB1F5FFEBC
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 12:50:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiJPKuB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 06:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbiJPKtf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 06:49:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A17CF1004F;
        Sun, 16 Oct 2022 03:49:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D85060A56;
        Sun, 16 Oct 2022 10:49:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 461A4C433D6;
        Sun, 16 Oct 2022 10:49:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665917371;
        bh=H7gM9TLHxVIJ3T3+SR0Qi2B1qrGZ+otdQuICAByme8w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W9hOjA8ouIWA0LdJ0j9N2JSDicjNq4OoixwmVyLP1raxzDI/pVh3eI5Z0ch9uz1iM
         19jVE5VWhUKs9W+2zepmwpdM9i28+AD6D+iaFK9JUqERVaxKU6qfzSlIGoIVBc09t9
         QGc0VtvESqSLL9K1K1Tl2IDkgkU11GjGSLtg1S3g=
Date:   Sun, 16 Oct 2022 12:50:17 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Stephen Boyd <swboyd@chromium.org>
Cc:     stable@vger.kernel.org, Sibi Sankar <sibis@codeaurora.org>,
        linux-kernel@vger.kernel.org, patches@lists.linux.dev,
        Alex Elder <elder@linaro.org>,
        Evan Green <evgreen@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Subject: Re: [PATCH 5.10] arm64: dts: qcom: sc7180-trogdor: Fixup modem
 memory region
Message-ID: <Y0vh6Q0U99bnUCbc@kroah.com>
References: <20221014215302.3905135-1-swboyd@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221014215302.3905135-1-swboyd@chromium.org>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Oct 14, 2022 at 02:53:02PM -0700, Stephen Boyd wrote:
> From: Sibi Sankar <sibis@codeaurora.org>
> 
> commit ef9a5d188d663753e73a3c8e8910ceab8e9305c4 upstream.
> 
> The modem firmware memory requirements vary between 32M/140M on
> no-lte/lte skus respectively, so fixup the modem memory region
> to reflect the requirements.
> 
> Reviewed-by: Evan Green <evgreen@chromium.org>
> Signed-off-by: Sibi Sankar <sibis@codeaurora.org>
> Link: https://lore.kernel.org/r/1602786476-27833-1-git-send-email-sibis@codeaurora.org
> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> ---
> 
> This fixes boot of the modem on trogdor boards with the DTS from 5.10.y
> stable tree. Without this patch I run into memory assignment errors and
> then the modem fails to boot.

You forgot to sign off on this patch you forwarded on for stable
inclusion :(

Please fix up and resend if you wish to see it applied.

thanks,

greg k-h
