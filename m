Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD355649E4A
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 12:58:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231302AbiLLL62 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 06:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57520 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231365AbiLLL6H (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 06:58:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A99C27
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 03:57:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F38E860FF1
        for <stable@vger.kernel.org>; Mon, 12 Dec 2022 11:57:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1693C433D2;
        Mon, 12 Dec 2022 11:57:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670846259;
        bh=rYc0odHVUqpwlfJb7slZEPnHbxyXEB5QSpbsorZ5zX8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AYjTykiH4AwcRiIQ8pZEb3nazGiY+FXg8WXzFQlgtJe0i+5R5CM47srY0pq2idW4R
         3onvBBMOdX7+B99oKvDlKglSbqMM4/MH0s3DHbH6e48iRApSdy2zqyGFWq9OdmZCQE
         tqpJzyvYHnTldqXKrgyK+nVu0HFnjpvR/WL4Ze9A=
Date:   Mon, 12 Dec 2022 12:57:34 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Yilu Lin <linyilu@huawei.com>
Cc:     pbonzini@redhat.com, stable@vger.kernel.org,
        "security@kernel.org" <security@kernel.org>,
        caihe <caihe@huawei.com>,
        "Zhangzebin (Zebin, PSIRT)" <zhangzebin@huawei.com>,
        Xiexiangyou <xiexiangyou@huawei.com>,
        xingchaochao <xingchaochao@huawei.com>,
        "lishan (E)" <lishan24@huawei.com>, subo7@huawei.com,
        wanghaibin.wang@huawei.com, yuzenghui@huawei.com,
        xiewenbo@huawei.com
Subject: Re: KVM: a issue which maybe a vulnerability
Message-ID: <Y5cXLr1E8yypzoo/@kroah.com>
References: <1afb632c3c59499bb586d1c5287c92ec@huawei.com>
 <57d8b88a87754e9ab74be19139ea64a7@huawei.com>
 <Y5BOA69lp1LQ6F1m@kroah.com>
 <0167aa46-89da-9b91-f1bf-8023ab4b35c7@huawei.com>
 <Y5btJNMv1nXKLrPE@kroah.com>
 <743b09f8-3377-7556-2968-0607711b82cb@huawei.com>
 <c77c791d-85b0-b799-8f1e-ec00645e976b@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c77c791d-85b0-b799-8f1e-ec00645e976b@huawei.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 12, 2022 at 07:15:32PM +0800, Yilu Lin wrote:
> Hello. There is a issue about the kvm module in kernel, which may be a vulnerability. And I need your adivce.
> 
> Here is affect version:
>     Linux kernel version 3.10.The virtualization platform uses the general Linux version before 4.15, which may also involve.
>     The issue is fixed in v4.15-rc1.Commit ID is dedf9c5e216902c6d34b5a0d0c40f4acbb3706d8. Link is https://github.com/torvalds/linux/commit/dedf9c5e216902c6d34b5a0d0c40f4acbb3706d8.
> 

Have you tried backporting this commit to 4.14.y and seeing if it
resolves the issue?  If so, can you send the backport here for
inclusion?

thanks,

greg k-h
