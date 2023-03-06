Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D21956AB624
	for <lists+stable@lfdr.de>; Mon,  6 Mar 2023 06:49:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229600AbjCFFtr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Mar 2023 00:49:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjCFFtq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Mar 2023 00:49:46 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3ECC665;
        Sun,  5 Mar 2023 21:49:45 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA0D560B9D;
        Mon,  6 Mar 2023 05:49:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0779C433EF;
        Mon,  6 Mar 2023 05:49:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678081784;
        bh=r4eUQi39HLgwCuSIOycdtHWsjI/OHiKFNufURTHBb5I=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=s4ud0kZyDf+Xy/kk4Y7k5l33cRwSLDKIztikXKb1TijW17FZNl1aXSg3htfKvZ688
         TBFgtshvmLekbxDOK4lLouoPoP4YSbwP5B/5PBYKNm86E3BLFHAFn+XemDJnBO0dwA
         CAqL8bnm0iYcM2LNBmhKhFGwDDyWZNQY9azva72s=
Date:   Mon, 6 Mar 2023 06:49:41 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     stable@vger.kernel.org, agross@kernel.org,
        bjorn.andersson@linaro.org, balbi@kernel.org, lee.jones@linaro.org,
        linux-arm-msm@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5.15] usb: dwc3: dwc3-qcom: Add missing
 platform_device_put() in dwc3_qcom_acpi_register_core
Message-ID: <ZAV+9ToKbIPFKJIs@kroah.com>
References: <20230303023439.774616-1-zhengyejian1@huawei.com>
 <ZAIW9mkHpKKQyIK+@kroah.com>
 <acc08af9-fdb3-5451-5c53-44784982fe2a@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acc08af9-fdb3-5451-5c53-44784982fe2a@huawei.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 06, 2023 at 09:26:31AM +0800, Zheng Yejian wrote:
> On 2023/3/3 23:49, Greg KH wrote:
> > On Fri, Mar 03, 2023 at 10:34:39AM +0800, Zheng Yejian wrote:
> > > From: Miaoqian Lin <linmq006@gmail.com>
> > > 
> > > commit fa0ef93868a6062babe1144df2807a8b1d4924d2 upstream.
> > > 
> > > Add the missing platform_device_put() before return from
> > > dwc3_qcom_acpi_register_core in the error handling case.
> > > 
> > > Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
> > > Link: https://lore.kernel.org/r/20211231113641.31474-1-linmq006@gmail.com
> > > Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > > CVE: CVE-2023-22995
> > 
> > That is a bogus CVE, please go revoke it.
> 
> Agree. I see this CVE and its fixes information from NVD,
> so try to backport this patch to fix it:
> Link: https://nvd.nist.gov/vuln/detail/CVE-2023-22995

Again, this is not a valid bug, the "problem" described can not ever be
hit in a real system from what I can tell.

> Then should I just remove the "CVE: " field and send a v2 patch?
> Or you mean "revoke" the CVE from NVD? I actually don't know how
> to do that :(

If you care about CVEs being "real", yes, please get it revoked from the
NVD.  There is no need to backport it either from what I can determine.

thanks,

greg k-h
