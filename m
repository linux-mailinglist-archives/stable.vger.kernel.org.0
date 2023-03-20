Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9BD66C0BCC
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 09:10:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230243AbjCTIK6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 04:10:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55004 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230146AbjCTIK4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 04:10:56 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFB1D18AB7;
        Mon, 20 Mar 2023 01:10:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5ABEF6125F;
        Mon, 20 Mar 2023 08:10:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA4EC433D2;
        Mon, 20 Mar 2023 08:10:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679299850;
        bh=Iovv/2fKdurRGZdrav4dWvXPM92bjLaNxYjiFu0MZYQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=XKHWgmUIEYf22IHqbvr3/5TsCXc9eRB6ky8Xw5crf4K00ZZnYDpgHLAQDFyGYAK0Q
         K2HNRvYf2AVV3lhGNywFYWPEazSkZg1FppeiH7nt0WWMHJ61wkghjrZuG6iVdpP3NA
         mxZp0GzrSAJUYGSUQZ3tR1Yx3a6+Da4xymKCMRUSE24+Olo9+blXFSIVkZoNGOYGIQ
         17Ra8BrGCRVlqT9MfhLNRT8SCAQVjebwWNGfkjYEF7qc5aGg4Mhvbu7zxpT6qK2c3l
         ENNrsT46CwAr6a4+nfIF5dEYBh1PWnOsx4a5iwzbz0ZfCTp28T5h1twn9flg72KL9N
         QF5iUrTw2c9eA==
Message-ID: <5df22994-1570-35ac-8e1c-5d2d8608d3f3@kernel.org>
Date:   Mon, 20 Mar 2023 10:10:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] usb: cdns3: Fix issue with using incorrect PCI device
 function
Content-Language: en-US
To:     Pawel Laszczak <pawell@cadence.com>, peter.chen@kernel.org
Cc:     gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, a-govindraju@ti.com,
        felipe.balbi@linux.intel.com, stable@vger.kernel.org
References: <20230308124427.311245-1-pawell@cadence.com>
From:   Roger Quadros <rogerq@kernel.org>
In-Reply-To: <20230308124427.311245-1-pawell@cadence.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 08/03/2023 14:44, Pawel Laszczak wrote:
> PCI based platform can have more than two PCI functions.
> USBSS PCI Glue driver during initialization should
> consider only DRD/HOST/DEVICE PCI functions and
> all other should be ignored. This patch adds additional
> condition which causes that only DRD and HOST/DEVICE
> function will be accepted.
> 
> cc: <stable@vger.kernel.org>
> Fixes: 7733f6c32e36 ("usb: cdns3: Add Cadence USB3 DRD Driver")
> Signed-off-by: Pawel Laszczak <pawell@cadence.com>

Reviewed-by: Roger Quadros <rogerq@kernel.org>
