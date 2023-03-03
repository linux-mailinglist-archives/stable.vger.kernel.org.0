Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 613386A9B19
	for <lists+stable@lfdr.de>; Fri,  3 Mar 2023 16:49:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjCCPtQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Mar 2023 10:49:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231201AbjCCPtP (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Mar 2023 10:49:15 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17B2A61A7;
        Fri,  3 Mar 2023 07:49:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C514AB8184D;
        Fri,  3 Mar 2023 15:49:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 444F3C4339B;
        Fri,  3 Mar 2023 15:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1677858552;
        bh=xV/t1gEFTxzD6Xk6NPA6oK0JPckecCtoxh7uIXbFh8U=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=16n/b/dfW6arYvlI9SdOKIXzs0yDJaepp73J9KTwz17Ozyu3Yfo2dJ2pv0KGxQ78K
         Z/I3liFsy3LxMOp64z351orA30c5xjzyDpJg8nsQYCfya57b9wY1f5jAz61oQRKakR
         5ggYfVkECP9gOTJWdJpa2BtFmuqB0A9OiAt1xuzI=
Date:   Fri, 3 Mar 2023 16:49:10 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     stable@vger.kernel.org, agross@kernel.org,
        bjorn.andersson@linaro.org, balbi@kernel.org, lee.jones@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15] usb: dwc3: dwc3-qcom: Add missing
 platform_device_put() in dwc3_qcom_acpi_register_core
Message-ID: <ZAIW9mkHpKKQyIK+@kroah.com>
References: <20230303023439.774616-1-zhengyejian1@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230303023439.774616-1-zhengyejian1@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Mar 03, 2023 at 10:34:39AM +0800, Zheng Yejian wrote:
> From: Miaoqian Lin <linmq006@gmail.com>
> 
> commit fa0ef93868a6062babe1144df2807a8b1d4924d2 upstream.
> 
> Add the missing platform_device_put() before return from
> dwc3_qcom_acpi_register_core in the error handling case.
> 
> Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> Link: https://lore.kernel.org/r/20211231113641.31474-1-linmq006@gmail.com
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CVE: CVE-2023-22995

That is a bogus CVE, please go revoke it.

thanks,

greg k-h
