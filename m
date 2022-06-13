Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 466B054832D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 11:44:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240728AbiFMJXm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 05:23:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241007AbiFMJXg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 05:23:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B966D12AC1;
        Mon, 13 Jun 2022 02:23:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7BCA1B80E4B;
        Mon, 13 Jun 2022 09:23:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A43A1C34114;
        Mon, 13 Jun 2022 09:23:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655112213;
        bh=uoPwChLebxdkiz98dMf9Y9fbxHGdFYEvmcsJyt6ThKU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HTZPl6uEudYr26qnCejKQSTROKkai7JvOdedYRVayJ+t4eOa1bdNCNP/uTA7I6pgv
         Q1LyWskOOZgvFjWpc4JZMLYyFJ/LQyaidNV7RFuFOrfi7dvCRKN1hTa2RpUx1rdNfa
         e1cF0jz486rzfhSYJF+NLD+fnUaa1b5jPSKaA6QI=
Date:   Mon, 13 Jun 2022 11:23:30 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Johan Hovold <johan+linaro@kernel.org>
Cc:     stable@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Stanimir Varbanov <svarbanov@mm-sol.com>
Subject: Re: [PATCH stable-4.9] PCI: qcom: Fix unbalanced PHY init on probe
 errors
Message-ID: <YqcCEkJm4u2poDqd@kroah.com>
References: <20220610120411.10619-1-johan+linaro@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220610120411.10619-1-johan+linaro@kernel.org>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jun 10, 2022 at 02:04:11PM +0200, Johan Hovold wrote:
> commit 83013631f0f9961416abd812e228c8efbc2f6069 upstream.
> 
> Undo the PHY initialisation (e.g. balance runtime PM) if host
> initialisation fails during probe.
> 
> Link: https://lore.kernel.org/r/20220401133854.10421-3-johan+linaro@kernel.org
> Fixes: 82a823833f4e ("PCI: qcom: Add Qualcomm PCIe controller driver")
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> Signed-off-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
> Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
> Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Acked-by: Stanimir Varbanov <svarbanov@mm-sol.com>
> Cc: stable@vger.kernel.org      # 4.5
> [ johan: adjust context to 4.9 ]
> Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> ---
>  drivers/pci/host/pcie-qcom.c | 7 ++++++-
>  1 file changed, 6 insertions(+), 1 deletion(-)

All now queued up, thanks.

greg k-h
